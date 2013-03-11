From: akpm@linux-foundation.org
Subject: [alternative-merged] rtc-rtc-tegra-use-devm_rtc_device_register.patch removed from -mm tree
Date: Mon, 11 Mar 2013 13:28:25 -0700
Message-ID: <20130311202826.00FC65A4121@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50652 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3CKU21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:28:27 -0400
Received: by mail-vc0-f202.google.com with SMTP id m8so425019vcd.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:28:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tegra: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tegra-use-devm_rtc_device_register.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tegra: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-rtc-tegra-use-devm_rtc_device_register drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-rtc-tegra-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-tegra.c
@@ -348,8 +348,8 @@ static int __init tegra_rtc_probe(struct
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register(
-		pdev->name, &pdev->dev, &tegra_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register(
+		&pdev->dev, pdev->name, &tegra_rtc_ops, THIS_MODULE);
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
 		info->rtc_dev = NULL;
@@ -374,17 +374,11 @@ static int __init tegra_rtc_probe(struct
 	return 0;
 
 err_dev_unreg:
-	rtc_device_unregister(info->rtc_dev);
-
 	return ret;
 }
 
 static int __exit tegra_rtc_remove(struct platform_device *pdev)
 {
-	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(info->rtc_dev);
-
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
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

