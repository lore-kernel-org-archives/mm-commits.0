From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-coh901331-convert-coh901331_driver-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:14 -0700
Message-ID: <20130430190114.715B55A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:51247 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933593Ab3D3TBP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:15 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so87519yen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-coh901331: convert coh901331_driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-rtc-coh901331-convert-coh901331_driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-coh901331: convert coh901331_driver to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-convert-coh901331_driver-to-dev_pm_ops drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-convert-coh901331_driver-to-dev_pm_ops
+++ a/drivers/rtc/rtc-coh901331.c
@@ -47,7 +47,7 @@ struct coh901331_port {
 	u32 physize;
 	void __iomem *virtbase;
 	int irq;
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	u32 irqmaskstore;
 #endif
 };
@@ -225,17 +225,17 @@ static int __init coh901331_probe(struct
 	return ret;
 }
 
-#ifdef CONFIG_PM
-static int coh901331_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int coh901331_suspend(struct device *dev)
 {
-	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+	struct coh901331_port *rtap = dev_get_drvdata(dev);
 
 	/*
 	 * If this RTC alarm will be used for waking the system up,
 	 * don't disable it of course. Else we just disable the alarm
 	 * and await suspension.
 	 */
-	if (device_may_wakeup(&pdev->dev)) {
+	if (device_may_wakeup(dev)) {
 		enable_irq_wake(rtap->irq);
 	} else {
 		clk_enable(rtap->clk);
@@ -247,12 +247,12 @@ static int coh901331_suspend(struct plat
 	return 0;
 }
 
-static int coh901331_resume(struct platform_device *pdev)
+static int coh901331_resume(struct device *dev)
 {
-	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+	struct coh901331_port *rtap = dev_get_drvdata(dev);
 
 	clk_prepare(rtap->clk);
-	if (device_may_wakeup(&pdev->dev)) {
+	if (device_may_wakeup(dev)) {
 		disable_irq_wake(rtap->irq);
 	} else {
 		clk_enable(rtap->clk);
@@ -261,11 +261,10 @@ static int coh901331_resume(struct platf
 	}
 	return 0;
 }
-#else
-#define coh901331_suspend NULL
-#define coh901331_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(coh901331_pm_ops, coh901331_suspend, coh901331_resume);
+
 static void coh901331_shutdown(struct platform_device *pdev)
 {
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
@@ -279,10 +278,9 @@ static struct platform_driver coh901331_
 	.driver = {
 		.name = "rtc-coh901331",
 		.owner = THIS_MODULE,
+		.pm = &coh901331_pm_ops,
 	},
 	.remove = __exit_p(coh901331_remove),
-	.suspend = coh901331_suspend,
-	.resume = coh901331_resume,
 	.shutdown = coh901331_shutdown,
 };
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

