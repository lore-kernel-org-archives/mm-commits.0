From: akpm@linux-foundation.org
Subject: + rtc-rtc-bq32k-use-devm_rtc_device_register.patch added to -mm tree
Date: Thu, 14 Mar 2013 14:14:17 -0700
Message-ID: <20130314211417.C48835A40E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:56200 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3CNVOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 17:14:18 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so274661qen.4
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 14:14:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-bq32k: use devm_rtc_device_register()
has been added to the -mm tree.  Its filename is
     rtc-rtc-bq32k-use-devm_rtc_device_register.patch

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
Subject: rtc: rtc-bq32k: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bq32k.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-bq32k.c~rtc-rtc-bq32k-use-devm_rtc_device_register drivers/rtc/rtc-bq32k.c
--- a/drivers/rtc/rtc-bq32k.c~rtc-rtc-bq32k-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-bq32k.c
@@ -153,7 +153,7 @@ static int bq32k_probe(struct i2c_client
 	if (error)
 		return error;
 
-	rtc = rtc_device_register(bq32k_driver.driver.name, &client->dev,
+	rtc = devm_rtc_device_register(&client->dev, bq32k_driver.driver.name,
 						&bq32k_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -165,9 +165,6 @@ static int bq32k_probe(struct i2c_client
 
 static int bq32k_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	rtc_device_unregister(rtc);
 	return 0;
 }
 
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
drivers-char-hw_random-exynos-rngc-add-config_pm_sleep-to-suspend-resume-functions.patch

