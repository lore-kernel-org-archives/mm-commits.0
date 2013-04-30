From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-omap-convert-omap_rtc_driver-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:17 -0700
Message-ID: <20130430190117.737FE31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64638 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562Ab3D3TBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:18 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so87427vbf.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-omap: convert omap_rtc_driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-rtc-omap-convert-omap_rtc_driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-omap: convert omap_rtc_driver to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-rtc-omap-convert-omap_rtc_driver-to-dev_pm_ops drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-rtc-omap-convert-omap_rtc_driver-to-dev_pm_ops
+++ a/drivers/rtc/rtc-omap.c
@@ -464,11 +464,10 @@ static int __exit omap_rtc_remove(struct
 	return 0;
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static u8 irqstat;
 
-static int omap_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int omap_rtc_suspend(struct device *dev)
 {
 	irqstat = rtc_read(OMAP_RTC_INTERRUPTS_REG);
 
@@ -476,34 +475,32 @@ static int omap_rtc_suspend(struct platf
 	 * source, and in fact this enable() call is just saving a flag
 	 * that's never used...
 	 */
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(dev))
 		enable_irq_wake(omap_rtc_alarm);
 	else
 		rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 
 	/* Disable the clock/module */
-	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_put_sync(dev);
 
 	return 0;
 }
 
-static int omap_rtc_resume(struct platform_device *pdev)
+static int omap_rtc_resume(struct device *dev)
 {
 	/* Enable the clock/module so that we can access the registers */
-	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_get_sync(dev);
 
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(dev))
 		disable_irq_wake(omap_rtc_alarm);
 	else
 		rtc_write(irqstat, OMAP_RTC_INTERRUPTS_REG);
 	return 0;
 }
-
-#else
-#define omap_rtc_suspend NULL
-#define omap_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(omap_rtc_pm_ops, omap_rtc_suspend, omap_rtc_resume);
+
 static void omap_rtc_shutdown(struct platform_device *pdev)
 {
 	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
@@ -512,12 +509,11 @@ static void omap_rtc_shutdown(struct pla
 MODULE_ALIAS("platform:omap_rtc");
 static struct platform_driver omap_rtc_driver = {
 	.remove		= __exit_p(omap_rtc_remove),
-	.suspend	= omap_rtc_suspend,
-	.resume		= omap_rtc_resume,
 	.shutdown	= omap_rtc_shutdown,
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
+		.pm	= &omap_rtc_pm_ops,
 		.of_match_table = of_match_ptr(omap_rtc_of_match),
 	},
 	.id_table	= omap_rtc_devtype,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

