From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-s3c-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:10 -0700
Message-ID: <20130430185610.6E45431C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:51044 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab3D3S4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:14 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86823qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-s3c: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-s3c-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-s3c: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-use-devm_rtc_device_register drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-s3c.c
@@ -423,10 +423,7 @@ static void s3c_rtc_enable(struct platfo
 
 static int s3c_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
 	platform_set_drvdata(dev, NULL);
-	rtc_device_unregister(rtc);
 
 	s3c_rtc_setaie(&dev->dev, 0);
 
@@ -511,7 +508,7 @@ static int s3c_rtc_probe(struct platform
 
 	/* register RTC and exit */
 
-	rtc = rtc_device_register("s3c", &pdev->dev, &s3c_rtcops,
+	rtc = devm_rtc_device_register(&pdev->dev, "s3c", &s3c_rtcops,
 				  THIS_MODULE);
 
 	if (IS_ERR(rtc)) {
@@ -574,7 +571,6 @@ static int s3c_rtc_probe(struct platform
 
  err_alarm_irq:
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(rtc);
 
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

