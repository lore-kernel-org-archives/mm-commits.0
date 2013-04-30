From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-tps6586x-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:20 -0700
Message-ID: <20130430185620.6DD9331C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:34233 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab3D3S4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:21 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so86587yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tps6586x: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tps6586x-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tps6586x: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps6586x.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-tps6586x.c~rtc-rtc-tps6586x-use-devm_rtc_device_register drivers/rtc/rtc-tps6586x.c
--- a/drivers/rtc/rtc-tps6586x.c~rtc-rtc-tps6586x-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-tps6586x.c
@@ -274,7 +274,7 @@ static int tps6586x_rtc_probe(struct pla
 	}
 
 	platform_set_drvdata(pdev, rtc);
-	rtc->rtc = rtc_device_register(dev_name(&pdev->dev), &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, dev_name(&pdev->dev),
 				       &tps6586x_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		ret = PTR_ERR(rtc->rtc);
@@ -306,12 +306,10 @@ fail_rtc_register:
 
 static int tps6586x_rtc_remove(struct platform_device *pdev)
 {
-	struct tps6586x_rtc *rtc = platform_get_drvdata(pdev);
 	struct device *tps_dev = to_tps6586x_dev(&pdev->dev);
 
 	tps6586x_update(tps_dev, RTC_CTRL, 0,
 		RTC_ENABLE | OSC_SRC_SEL | PRE_BYPASS | CL_SEL_MASK);
-	rtc_device_unregister(rtc->rtc);
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

