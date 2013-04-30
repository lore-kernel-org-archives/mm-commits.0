From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-sa1100-switch-to-using-simple_dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:20 -0700
Message-ID: <20130430185820.7216F31C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:51853 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab3D3S6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:21 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so86979yen.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-sa1100: switch to using SIMPLE_DEV_PM_OPS
has been removed from the -mm tree.  Its filename was
     rtc-rtc-sa1100-switch-to-using-simple_dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-sa1100: switch to using SIMPLE_DEV_PM_OPS

Switch to using the SIMPLE_DEV_PM_OPS macro to declare the driver's
pm_ops.  It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sa1100.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-sa1100.c~rtc-rtc-sa1100-switch-to-using-simple_dev_pm_ops drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~rtc-rtc-sa1100-switch-to-using-simple_dev_pm_ops
+++ a/drivers/rtc/rtc-sa1100.c
@@ -327,7 +327,7 @@ static int sa1100_rtc_remove(struct plat
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int sa1100_rtc_suspend(struct device *dev)
 {
 	struct sa1100_rtc *info = dev_get_drvdata(dev);
@@ -343,13 +343,11 @@ static int sa1100_rtc_resume(struct devi
 		disable_irq_wake(info->irq_alarm);
 	return 0;
 }
-
-static const struct dev_pm_ops sa1100_rtc_pm_ops = {
-	.suspend	= sa1100_rtc_suspend,
-	.resume		= sa1100_rtc_resume,
-};
 #endif
 
+static SIMPLE_DEV_PM_OPS(sa1100_rtc_pm_ops, sa1100_rtc_suspend,
+			sa1100_rtc_resume);
+
 #ifdef CONFIG_OF
 static struct of_device_id sa1100_rtc_dt_ids[] = {
 	{ .compatible = "mrvl,sa1100-rtc", },
@@ -364,9 +362,7 @@ static struct platform_driver sa1100_rtc
 	.remove		= sa1100_rtc_remove,
 	.driver		= {
 		.name	= "sa1100-rtc",
-#ifdef CONFIG_PM
 		.pm	= &sa1100_rtc_pm_ops,
-#endif
 		.of_match_table = of_match_ptr(sa1100_rtc_dt_ids),
 	},
 };
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

