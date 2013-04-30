From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rc5t583-switch-to-using-simple_dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:18 -0700
Message-ID: <20130430185818.7226131C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46243 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab3D3S6T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:19 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so87124vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rc5t583: switch to using SIMPLE_DEV_PM_OPS
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rc5t583-switch-to-using-simple_dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rc5t583: switch to using SIMPLE_DEV_PM_OPS

Switch to using the SIMPLE_DEV_PM_OPS macro to declare the driver's
pm_ops.  It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rc5t583.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-rc5t583.c~rtc-rtc-rc5t583-switch-to-using-simple_dev_pm_ops drivers/rtc/rtc-rc5t583.c
--- a/drivers/rtc/rtc-rc5t583.c~rtc-rtc-rc5t583-switch-to-using-simple_dev_pm_ops
+++ a/drivers/rtc/rtc-rc5t583.c
@@ -280,7 +280,6 @@ static int rc5t583_rtc_remove(struct pla
 }
 
 #ifdef CONFIG_PM_SLEEP
-
 static int rc5t583_rtc_suspend(struct device *dev)
 {
 	struct rc5t583 *rc5t583 = dev_get_drvdata(dev->parent);
@@ -302,24 +301,18 @@ static int rc5t583_rtc_resume(struct dev
 	return regmap_write(rc5t583->regmap, RC5T583_RTC_CTL1,
 		rc5t583_rtc->irqen);
 }
-
-static const struct dev_pm_ops rc5t583_rtc_pm_ops = {
-	.suspend	= rc5t583_rtc_suspend,
-	.resume		= rc5t583_rtc_resume,
-};
-
-#define DEV_PM_OPS     (&rc5t583_rtc_pm_ops)
-#else
-#define DEV_PM_OPS     NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(rc5t583_rtc_pm_ops, rc5t583_rtc_suspend,
+			rc5t583_rtc_resume);
+
 static struct platform_driver rc5t583_rtc_driver = {
 	.probe		= rc5t583_rtc_probe,
 	.remove		= rc5t583_rtc_remove,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "rtc-rc5t583",
-		.pm	= DEV_PM_OPS,
+		.pm	= &rc5t583_rtc_pm_ops,
 	},
 };
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

