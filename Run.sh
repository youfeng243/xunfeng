#!/bin/bash
CURRENT_PATH=`dirname $0`
cd $CURRENT_PATH

XUNFENG_LOG=~/project/xunfeng/log
XUNFENG_DB=/opt/xunfeng/db

[ ! -d $XUNFENG_LOG ] && mkdir -p ${XUNFENG_LOG}
[ ! -d $XUNFENG_DB ] && mkdir -p ${XUNFENG_DB}

echo "开始关闭所有xunfeng进程.."

# 先关闭进程
ps -ef | grep mongod | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep Run.py | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep Aider.py | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep NAScan.py | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep VulScan.py | grep -v grep | awk '{print $2}' | xargs kill

echo "关闭所有xunfeng进程完成..."

sleep 5

echo "开始启动巡风进程..."

nohup mongod --port 65521 --dbpath=${XUNFENG_DB} --auth  > ${XUNFENG_LOG}/db.log &
sleep 2
nohup python ./Run.py > ${XUNFENG_LOG}/web.log &
nohup python ./aider/Aider.py > ${XUNFENG_LOG}/aider.log &
nohup python ./nascan/NAScan.py > ${XUNFENG_LOG}/scan.log &
nohup python ./vulscan/VulScan.py > ${XUNFENG_LOG}/vul.log &

echo "启动巡风进程完成..."

