From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-convert-s3c_rtc-to-dev_pm_ops.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:14:50 -0700
Message-ID: <20130312201450.747E45A402F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:45048 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3CLUOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:14:52 -0400
Received: by mail-vb0-f73.google.com with SMTP id fj18so22387vbb.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:14:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, grant.likely@secretlab.ca, rob.herring@calxeda.com


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: convert s3c_rtc to dev_pm_ops
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-convert-s3c_rtc-to-dev_pm_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
backlight-ep93xx_bl-remove-incorrect-__init-annotation.patch
drivers-video-backlight-atmel-pwm-blc-use-module_platform_driver_probe.patch
drivers-video-backlight-atmel-pwm-blc-add-__init-annotation.patch
drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe.patch
drivers-video-backlight-jornada720_c-use-dev_err-dev_info-instead-of-pr_err-pr_info.patch
drivers-video-backlight-omap1_blc-use-dev_info-instead-of-pr_info.patch
drivers-video-backlight-generic_blc-use-dev_info-instead-of-pr_info.patch
backlight-adp8870-add-missing-braces.patch
drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable.patch
backlight-ld9040-convert-ld9040-to-dev_pm_ops.patch
backlight-lms501kf03-convert-lms501kf03-to-dev_pm_ops.patch
backlight-s6e63m0-convert-s6e63m0-to-dev_pm_ops.patch
backlight-adp5520-convert-adp5520_bl-to-dev_pm_ops.patch
backlight-adp8860-convert-adp8860-to-dev_pm_ops.patch
backlight-adp8870-convert-adp8870-to-dev_pm_ops.patch
backlight-corgi_lcd-convert-corgi_lcd-to-dev_pm_ops.patch
backlight-ep93xx-convert-ep93xx-to-dev_pm_ops.patch
backlight-hp680_bl-convert-hp680bl-to-dev_pm_ops.patch
backlight-kb3886_bl-convert-kb3886bl-to-dev_pm_ops.patch
backlight-lm3533_bl-convert-lm3533_bl-to-dev_pm_ops.patch
backlight-locomolcd-convert-locomolcd-to-dev_pm_ops.patch
backlight-ltv350qv-convert-ltv350qv-to-dev_pm_ops.patch
backlight-tdo24m-convert-tdo24m-to-dev_pm_ops.patch
rtc-rtc-mv-add-__init-annotation.patch
rtc-rtc-davinci-add-__exit-annotation.patch
rtc-rtc-ds1302-add-__exit-annotation.patch
rtc-rtc-imxdi-add-__init-__exit-annotation.patch
rtc-rtc-nuc900-add-__init-__exit-annotation.patch
rtc-rtc-pcap-add-__init-__exit-annotation.patch
rtc-rtc-tegra-add-__init-__exit-annotation.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-max77686-use-module_platform_driver.patch
rtc-max77686-add-missing-module-author-name.patch
rtc-max77686-use-devm_kzalloc.patch
rtc-max77686-fix-indentation-of-bit-definitions.patch
rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register.patch
rtc-rtc-ab3100-use-module_platform_driver_probe.patch
rtc-rtc-at32ap700x-use-module_platform_driver_probe.patch
rtc-rtc-at91rm9200-use-module_platform_driver_probe.patch
rtc-rtc-au1xxx-use-module_platform_driver_probe.patch
rtc-rtc-coh901331-use-module_platform_driver_probe.patch
rtc-rtc-davinci-use-module_platform_driver_probe.patch
rtc-rtc-ds1302-use-module_platform_driver_probe.patch
rtc-rtc-efi-use-module_platform_driver_probe.patch
rtc-rtc-generic-use-module_platform_driver_probe.patch
rtc-rtc-imxdi-use-module_platform_driver_probe.patch
rtc-rtc-mc13xxx-use-module_platform_driver_probe.patch
rtc-rtc-msm6242-use-module_platform_driver_probe.patch
rtc-rtc-mv-use-module_platform_driver_probe.patch
rtc-rtc-nuc900-use-module_platform_driver_probe.patch
rtc-rtc-omap-use-module_platform_driver_probe.patch
rtc-rtc-pcap-use-module_platform_driver_probe.patch
rtc-rtc-ps3-use-module_platform_driver_probe.patch
rtc-rtc-pxa-use-module_platform_driver_probe.patch
rtc-rtc-rp5c01-use-module_platform_driver_probe.patch
rtc-rtc-sh-use-module_platform_driver_probe.patch
rtc-rtc-starfire-use-module_platform_driver_probe.patch
rtc-rtc-sun4v-use-module_platform_driver_probe.patch
rtc-rtc-tegra-use-module_platform_driver_probe.patch
rtc-rtc-tx4939-use-module_platform_driver_probe.patch
rtc-rtc-88pm80x-use-devm_rtc_device_register.patch
rtc-rtc-coh90133-use-devm_rtc_device_register.patch
rtc-rtc-da9052-use-devm_rtc_device_register.patch
rtc-rtc-da9055-use-devm_rtc_device_register.patch
rtc-rtc-davinci-use-devm_rtc_device_register.patch
rtc-rtc-ds1511-use-devm_rtc_device_register.patch
rtc-rtc-ds1553-use-devm_rtc_device_register.patch
rtc-rtc-ds1742-use-devm_rtc_device_register.patch
rtc-rtc-ep93xx-use-devm_rtc_device_register.patch
rtc-rtc-imxdi-use-devm_rtc_device_register.patch
rtc-rtc-lp8788-use-devm_rtc_device_register.patch
rtc-rtc-lpc32xx-use-devm_rtc_device_register.patch
rtc-rtc-max77686-use-devm_rtc_device_register.patch
rtc-rtc-max8907-use-devm_rtc_device_register.patch
rtc-rtc-max8997-use-devm_rtc_device_register.patch
rtc-rtc-mv-use-devm_rtc_device_register.patch
rtc-rtc-mxc-use-devm_rtc_device_register.patch
rtc-rtc-palmas-use-devm_rtc_device_register.patch
rtc-rtc-pcf8523-use-devm_rtc_device_register.patch
rtc-rtc-s3c-use-devm_rtc_device_register.patch
rtc-rtc-snvs-use-devm_rtc_device_register.patch
rtc-rtc-spear-use-devm_rtc_device_register.patch
rtc-rtc-stk17ta8-use-devm_rtc_device_register.patch
rtc-rtc-tps6586x-use-devm_rtc_device_register.patch
rtc-rtc-tps65910-use-devm_rtc_device_register.patch
rtc-rtc-tps80031-use-devm_rtc_device_register.patch
rtc-rtc-tx4939-use-devm_rtc_device_register.patch
rtc-rtc-vt8500-use-devm_rtc_device_register.patch
rtc-rtc-wm831x-use-devm_rtc_device_register.patch
rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep.patch
rtc-tegra-use-struct-dev_pm_ops-for-power-management.patch
rtc-tegra-set-irq-name-as-device-name.patch
rtc-tegra-use-managed-rtc_device_register.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch
rtc-rtc-s3c-convert-s3c_rtc-to-dev_pm_ops.patch

