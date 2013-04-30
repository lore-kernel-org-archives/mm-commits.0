From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-s3c-convert-s3c_rtc-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:53 -0700
Message-ID: <20130430185653.795065A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39384 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab3D3S4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:54 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86823ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, grant.likely@secretlab.ca, rob.herring@calxeda.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: convert s3c_rtc to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-rtc-s3c-convert-s3c_rtc-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-s3c.c: convert s3c_rtc to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.  Also, 'wake_en'
variable is moved, because it is only used when CONFIG_PM_SLEEP is
enabled.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-convert-s3c_rtc-to-dev_pm_ops drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-convert-s3c_rtc-to-dev_pm_ops
+++ a/drivers/rtc/rtc-s3c.c
@@ -51,7 +51,6 @@ static struct clk *rtc_clk;
 static void __iomem *s3c_rtc_base;
 static int s3c_rtc_alarmno = NO_IRQ;
 static int s3c_rtc_tickno  = NO_IRQ;
-static bool wake_en;
 static enum s3c_cpu_type s3c_rtc_cpu_type;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
@@ -579,14 +578,16 @@ static int s3c_rtc_probe(struct platform
 	return ret;
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 /* RTC Power management control */
 
 static int ticnt_save, ticnt_en_save;
+static bool wake_en;
 
-static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int s3c_rtc_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
+
 	clk_enable(rtc_clk);
 	/* save TICNT for anyone using periodic interrupts */
 	ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
@@ -596,19 +597,20 @@ static int s3c_rtc_suspend(struct platfo
 	}
 	s3c_rtc_enable(pdev, 0);
 
-	if (device_may_wakeup(&pdev->dev) && !wake_en) {
+	if (device_may_wakeup(dev) && !wake_en) {
 		if (enable_irq_wake(s3c_rtc_alarmno) == 0)
 			wake_en = true;
 		else
-			dev_err(&pdev->dev, "enable_irq_wake failed\n");
+			dev_err(dev, "enable_irq_wake failed\n");
 	}
 	clk_disable(rtc_clk);
 
 	return 0;
 }
 
-static int s3c_rtc_resume(struct platform_device *pdev)
+static int s3c_rtc_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	unsigned int tmp;
 
 	clk_enable(rtc_clk);
@@ -619,7 +621,7 @@ static int s3c_rtc_resume(struct platfor
 		writew(tmp | ticnt_en_save, s3c_rtc_base + S3C2410_RTCCON);
 	}
 
-	if (device_may_wakeup(&pdev->dev) && wake_en) {
+	if (device_may_wakeup(dev) && wake_en) {
 		disable_irq_wake(s3c_rtc_alarmno);
 		wake_en = false;
 	}
@@ -627,11 +629,10 @@ static int s3c_rtc_resume(struct platfor
 
 	return 0;
 }
-#else
-#define s3c_rtc_suspend NULL
-#define s3c_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(s3c_rtc_pm_ops, s3c_rtc_suspend, s3c_rtc_resume);
+
 #ifdef CONFIG_OF
 static struct s3c_rtc_drv_data s3c_rtc_drv_data_array[] = {
 	[TYPE_S3C2410] = { TYPE_S3C2410 },
@@ -681,12 +682,11 @@ MODULE_DEVICE_TABLE(platform, s3c_rtc_dr
 static struct platform_driver s3c_rtc_driver = {
 	.probe		= s3c_rtc_probe,
 	.remove		= s3c_rtc_remove,
-	.suspend	= s3c_rtc_suspend,
-	.resume		= s3c_rtc_resume,
 	.id_table	= s3c_rtc_driver_ids,
 	.driver		= {
 		.name	= "s3c-rtc",
 		.owner	= THIS_MODULE,
+		.pm	= &s3c_rtc_pm_ops,
 		.of_match_table	= of_match_ptr(s3c_rtc_dt_match),
 	},
 };
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

