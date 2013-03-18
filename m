From: akpm@linux-foundation.org
Subject: + rtc-rtc-rc5t583-switch-to-using-simple_dev_pm_ops.patch added to -mm tree
Date: Mon, 18 Mar 2013 12:38:13 -0700
Message-ID: <20130318193813.BDFE35A4320@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:34218 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab3CRTiO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 15:38:14 -0400
Received: by mail-ia0-f201.google.com with SMTP id t4so1314152iag.0
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 12:38:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-rc5t583: switch to using SIMPLE_DEV_PM_OPS
has been added to the -mm tree.  Its filename is
     rtc-rtc-rc5t583-switch-to-using-simple_dev_pm_ops.patch

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
drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable-fix.patch
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
drivers-video-backlight-kconfig-fix-typo-mach_sam9ek-three-times.patch
drivers-video-backlight-adp5520_blc-fix-compiler-warning-in-adp5520_show.patch
video-backlight-add-ili922x-lcd-driver.patch
backlight-da903x_bl-use-bl_core_suspendresume-option.patch
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
rtc-rtc-ds1307-use-dev_dbg-instead-of-pr_debug.patch
rtc-rtc-fm3130-use-dev_dbg-instead-of-pr_debug.patch
rtc-rtc-ab3100-use-devm_rtc_device_register.patch
rtc-rtc-au1xxx-use-devm_rtc_device_register.patch
rtc-rtc-bq32k-use-devm_rtc_device_register.patch
rtc-rtc-dm355evm-use-devm_rtc_device_register.patch
rtc-rtc-ds1302-use-devm_rtc_device_register.patch
rtc-rtc-ds1672-use-devm_rtc_device_register.patch
rtc-rtc-ds3234-use-devm_rtc_device_register.patch
rtc-rtc-efi-use-devm_rtc_device_register.patch
rtc-rtc-em3027-use-devm_rtc_device_register.patch
rtc-rtc-generic-use-devm_rtc_device_register.patch
rtc-hid-sensor-time-use-devm_rtc_device_register.patch
rtc-rtc-ls1x-use-devm_rtc_device_register.patch
rtc-rtc-m41t93-use-devm_rtc_device_register.patch
rtc-rtc-m41t94-use-devm_rtc_device_register.patch
rtc-rtc-m48t86-use-devm_rtc_device_register.patch
rtc-rtc-max6900-use-devm_rtc_device_register.patch
rtc-rtc-max6902-use-devm_rtc_device_register.patch
rtc-rtc-ps3-use-devm_rtc_device_register.patch
rtc-rtc-r9701-use-devm_rtc_device_register.patch
rtc-rtc-rc5t583-use-devm_rtc_device_register.patch
rtc-rtc-rs5c313-use-devm_rtc_device_register.patch
rtc-rtc-rv3029c2-use-devm_rtc_device_register.patch
rtc-rtc-rx4581-use-devm_rtc_device_register.patch
rtc-rtc-rx8581-use-devm_rtc_device_register.patch
rtc-rtc-starfire-use-devm_rtc_device_register.patch
rtc-rtc-sun4v-use-devm_rtc_device_register.patch
rtc-rtc-test-use-devm_rtc_device_register.patch
rtc-rtc-tile-use-devm_rtc_device_register.patch
rtc-rtc-wm8350-use-devm_rtc_device_register.patch
rtc-rtc-x1205-use-devm_rtc_device_register.patch
rtc-rtc-at91rm9200-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-mxc-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-pxa-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-rc5t583-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-sa1100-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-sh-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-wm8350-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-tps6586x-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-tps65910-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-tps80031-switch-to-using-simple_dev_pm_ops.patch
drivers-char-hw_random-exynos-rngc-add-config_pm_sleep-to-suspend-resume-functions.patch

