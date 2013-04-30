From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-twl-convert-twl4030rtc_driver-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:29 -0700
Message-ID: <20130430190129.70E6C5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:53227 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566Ab3D3TBa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:30 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so87155yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-twl: convert twl4030rtc_driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-rtc-twl-convert-twl4030rtc_driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-twl: convert twl4030rtc_driver to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-twl.c~rtc-rtc-twl-convert-twl4030rtc_driver-to-dev_pm_ops drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~rtc-rtc-twl-convert-twl4030rtc_driver-to-dev_pm_ops
+++ a/drivers/rtc/rtc-twl.c
@@ -566,11 +566,10 @@ static void twl_rtc_shutdown(struct plat
 	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static unsigned char irqstat;
 
-static int twl_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int twl_rtc_suspend(struct device *dev)
 {
 	irqstat = rtc_irq_bits;
 
@@ -578,17 +577,15 @@ static int twl_rtc_suspend(struct platfo
 	return 0;
 }
 
-static int twl_rtc_resume(struct platform_device *pdev)
+static int twl_rtc_resume(struct device *dev)
 {
 	set_rtc_irq_bit(irqstat);
 	return 0;
 }
-
-#else
-#define twl_rtc_suspend NULL
-#define twl_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(twl_rtc_pm_ops, twl_rtc_suspend, twl_rtc_resume);
+
 #ifdef CONFIG_OF
 static const struct of_device_id twl_rtc_of_match[] = {
 	{.compatible = "ti,twl4030-rtc", },
@@ -603,11 +600,10 @@ static struct platform_driver twl4030rtc
 	.probe		= twl_rtc_probe,
 	.remove		= twl_rtc_remove,
 	.shutdown	= twl_rtc_shutdown,
-	.suspend	= twl_rtc_suspend,
-	.resume		= twl_rtc_resume,
 	.driver		= {
 		.owner		= THIS_MODULE,
 		.name		= "twl_rtc",
+		.pm		= &twl_rtc_pm_ops,
 		.of_match_table = of_match_ptr(twl_rtc_of_match),
 	},
 };
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

