function merge_package(){
    pn=`echo $1 | rev | cut -d'/' -f 1 | rev`
    find package/ -follow -name $pn -not -path "package/custom/*" | xargs -rt rm -rf
    if [ ! -z "$2" ]; then
        find package/ -follow -name $2 -not -path "package/custom/*" | xargs -rt rm -rf
    fi

    if [[ $1 == *'/trunk/'* || $1 == *'/branches/'* ]]; then
        svn export $1
    elif [[ $1 == *'/tree/'* ]]; then
        repo=`echo $1|awk -F'/tree/' '{print $1}'`
        git clone --depth=1 --single-branch $repo .tmprepo
        mv .tmprepo/$pn $pn
        rm .tmprepo -rf
    else
        git clone --depth=1 --single-branch $3 $1
        rm -rf $pn/.git
    fi
    mv $pn package/custom/
}
function drop_package(){
    find package/ -follow -name $1 -not -path "package/custom/*" | xargs -rt rm -rf
}
function merge_feed(){
    if [ ! -d "feed/$1" ]; then
        echo >> feeds.conf.default
        echo "src-git $1 $2" >> feeds.conf.default
    fi
    ./scripts/feeds update $1
    ./scripts/feeds install -a -p $1
}

rm -rf feeds/packages/net/mosdns package/feeds/packages/mosdns
rm -rf package/custom; mkdir package/custom
merge_feed nas "https://github.com/linkease/nas-packages;master"
merge_feed nas_luci "https://github.com/linkease/nas-packages-luci;main"
rm -r package/feeds/nas_luci/luci-app-ddnsto
merge_feed helloworld "https://github.com/stupidloud/helloworld;tmp"
merge_package https://github.com/ilxp/luci-app-ikoolproxy
merge_package https://github.com/sundaqiang/openwrt-packages/trunk/luci-app-wolplus
merge_package https://github.com/liudf0716/luci-app-xfrpc && sed -i 's/\.\.\/\.\.\/luci/$(TOPDIR)\/feeds\/luci\/luci/' package/custom/luci-app-xfrpc/Makefile
merge_package https://github.com/messense/aliyundrive-webdav/trunk/openwrt/aliyundrive-webdav
merge_package https://github.com/messense/aliyundrive-webdav/trunk/openwrt/luci-app-aliyundrive-webdav
merge_package "-b 18.06 https://github.com/jerrykuku/luci-theme-argon"
merge_package https://github.com/vernesong/OpenClash/trunk/luci-app-openclash
merge_package https://github.com/NateLol/luci-app-oled
merge_package https://github.com/xiaorouji/openwrt-passwall/tree/packages/brook
merge_package https://github.com/xiaorouji/openwrt-passwall/tree/packages/chinadns-ng
merge_package https://github.com/xiaorouji/openwrt-passwall/tree/packages/trojan-go
merge_package https://github.com/xiaorouji/openwrt-passwall/tree/packages/trojan-plus
merge_package https://github.com/xiaorouji/openwrt-passwall/tree/packages/sing-box
merge_package "-b luci https://github.com/xiaorouji/openwrt-passwall"
merge_package https://github.com/jerrykuku/lua-maxminddb
merge_package https://github.com/jerrykuku/luci-app-vssr
merge_package https://github.com/kongfl888/luci-app-adguardhome
drop_package luci-app-cd8021x
drop_package luci-app-cifs
drop_package verysync
drop_package luci-app-verysync
drop_package luci-app-mosdns