#!/usr/bin/env R

list.of.packages <- c("lubridate", "maps", "mapdata", "data.table")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


library(data.table)
library(ggplot2)
library(lubridate)
library(maps)
library(mapdata)


url = "https://raw.githubusercontent.com/timsainb/example_r_colab_project/master/scrubbed.csv"
# check if the file is in the directory
if (!file.exists("scrubbed.csv")){
  print("Downloading data")
  download.file(url, "scrubbed.csv", "wget") 
}


ufo <- fread("scrubbed.csv")
ufo$datetime <- mdy_hm(ufo$datetime) # Date format
ufo$`date posted` <- mdy(ufo$`date posted`)
ufo$`duration (seconds)` <- as.numeric(ufo$`duration (seconds)`)

head(ufo, 3)


ufo$latitude <- as.numeric(ufo$latitude)


map <- borders("world", colour="black", fill="gray50") 
ufo_map <- ggplot(ufo) + map 
print(ufo_map + geom_point(aes(x=ufo$longitude, y=ufo$latitude,color=shape),shape=18) +
        theme(legend.position = "top")+
        ggtitle("UFOs"))

ggsave("ufocount.png", device="png", width = 5, height = 5, units = "in")


ggplot(ufo,aes(shape,fill=shape))+
  stat_count()+ggtitle("UFOS by Shape")+theme(legend.position="none")+
  theme(axis.text.x = element_text(angle = 45, size=8,hjust = 1))

ggsave("ufocount.png", device="png", width = 5, height = 5, units = "in")
