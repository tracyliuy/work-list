#对于请求超时的记录进行标记，并打印出来 
#!/bin/sh 
BEGIN{ 
#基础单位，毫秒 
base=1000 
#超时阀值，建议设为50,单位为毫秒 
valve=50 
}


$7!=400&&$7!~/status/&&$7!~/favicon.ico/&&$7!~/to404ErrorPage.shtml/ { 
#总体统计 
costTime=$11*base 
sumTime+=costTime 
totalCount++ 
if(min>costTime) min=costTime 
if(max<costTime) max=costTime 
#分布区间 
if(costTime>=0 && costTime<10) {area01+=1} 
if(costTime>=10 && costTime<20) {area12+=1} 
if(costTime>=20 && costTime<30) {area23+=1} 
if(costTime>=30 && costTime<40) {area34+=1} 
if(costTime>=40 && costTime<50) {area45+=1} 
if(costTime>=50 && costTime<60) {area56+=1}
if(costTime>=60 && costTime<70) {area67+=1}
if(costTime>=70 && costTime<80) {area78+=1}
if(costTime>=80 && costTime<90) {area89+=1}
if(costTime>=90 && costTime<100) {area910+=1}
if(costTime>=100) {area100+=1} 
#超时统计 
pos=index($7,"?") 
if(pos>0) {url=substr($7,0,pos-1)} 
else { url=$7 } 
urlCount[url]++ 
urlsumTime[url]+=costTime 
if(costTime>valve) 
{ urlTimeout[url]++ } 
} 
END{ 
printf("\n当前正在分析文件%s,共处理%s个请求，响应时间最小为%2dms,最大为%8dms,平均%4dms\n",FILENAME,totalCount,min,max,sumTime/totalCount) 
printf("\n所有请求的分布区间如下:\n") 
printf("小于10毫秒的请求%8d个,占%.2f%\n",area01,area01/totalCount*100) 
printf("10--20毫秒的请求%8d个，占%.2f%\n",area12,area12/totalCount*100) 
printf("20--30毫秒的请求%8d个，占%.2f%\n",area23,area23/totalCount*100) 
printf("30--40毫秒的请求%8d个，占%.2f%\n",area34,area34/totalCount*100) 
printf("40--50毫秒的请求%8d个，占%.2f%\n",area45,area45/totalCount*100)
printf("50--60毫秒的请求%8d个，占%.2f%\n",area56,area56/totalCount*100)
printf("60--70毫秒的请求%8d个，占%.2f%\n",area67,area67/totalCount*100)
printf("70--80毫秒的请求%8d个，占%.2f%\n",area78,area78/totalCount*100)
printf("80--90毫秒的请求%8d个，占%.2f%\n",area89,area89/totalCount*100)
printf("90--100毫秒的请求%8d个，占%.2f%\n",area910,area910/totalCount*100)
printf("大于100毫秒的请求%8d个,占%.2f%\n",area100,area100/totalCount*100) 
printf("\n下面是请求超时严重的url列表，需要重点优化，当前超时设定为%5dms\n",valve) 
for(url in urlTimeout)  { 
 #超时小于等于3次，或者超时比例20%以下的不输出 
 if(urlTimeout[url]>3 && (urlTimeout[url]/urlCount[url]>0.2)) { 
 printf("%-80s共处理%5d次,超时%5d次,占%3.2f%,平均耗时%6dms\n",url,urlCount[url],urlTimeout[url],urlTimeout[url]/urlCount[url]*100,urlsumTime[url
]/urlCount[url]) 
 } 
 } 
} 
