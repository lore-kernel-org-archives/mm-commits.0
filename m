From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-au1xxx-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:03 -0700
Message-ID: <20130430185703.6E17031C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:51413 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab3D3S5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:06 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so77452ves.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-au1xxx: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-au1xxx-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-au1xxx: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-au1xxx.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-au1xxx.c~rtc-rtc-au1xxx-use-devm_rtc_device_register drivers/rtc/rtc-au1xxx.c
--- a/drivers/rtc/rtc-au1xxx.c~rtc-rtc-au1xxx-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-au1xxx.c
@@ -101,7 +101,7 @@ static int au1xtoy_rtc_probe(struct plat
 	while (au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_C0S)
 		msleep(1);
 
-	rtcdev = rtc_device_register("rtc-au1xxx", &pdev->dev,
+	rtcdev = devm_rtc_device_register(&pdev->dev, "rtc-au1xxx",
 				     &au1xtoy_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtcdev)) {
 		ret = PTR_ERR(rtcdev);
@@ -118,9 +118,6 @@ out_err:
 
 static int au1xtoy_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtcdev = platform_get_drvdata(pdev);
