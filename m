From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-wm8350-switch-to-using-simple_dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:25 -0700
Message-ID: <20130430185825.71DD331C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:63832 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab3D3S60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:26 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86952ggc.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-wm8350: switch to using SIMPLE_DEV_PM_OPS
has been removed from the -mm tree.  Its filename was
     rtc-rtc-wm8350-switch-to-using-simple_dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-wm8350: switch to using SIMPLE_DEV_PM_OPS

Switch to using the SIMPLE_DEV_PM_OPS macro to declare the driver's
pm_ops.  It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm8350.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-switch-to-using-simple_dev_pm_ops drivers/rtc/rtc-wm8350.c
--- a/drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-switch-to-using-simple_dev_pm_ops
+++ a/drivers/rtc/rtc-wm8350.c
@@ -339,7 +339,7 @@ static const struct rtc_class_ops wm8350
 	.alarm_irq_enable = wm8350_rtc_alarm_irq_enable,
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int wm8350_rtc_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -375,10 +375,6 @@ static int wm8350_rtc_resume(struct devi
 
 	return 0;
 }
-
-#else
-#define wm8350_rtc_suspend NULL
-#define wm8350_rtc_resume NULL
 #endif
 
 static int wm8350_rtc_probe(struct platform_device *pdev)
@@ -469,10 +465,8 @@ static int wm8350_rtc_remove(struct plat
 	return 0;
 }
 
-static struct dev_pm_ops wm8350_rtc_pm_ops = {
-	.suspend = wm8350_rtc_suspend,
-	.resume = wm8350_rtc_resume,
-};
+static SIMPLE_DEV_PM_OPS(wm8350_rtc_pm_ops, wm8350_rtc_suspend,
+			wm8350_rtc_resume);
 
 static struct platform_driver wm8350_rtc_driver = {
 	.probe = wm8350_rtc_probe,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

