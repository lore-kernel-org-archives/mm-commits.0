From: akpm@linux-foundation.org
Subject: + drivers-block-sx8c-use-module_pci_driver.patch added to -mm
 tree
Date: Thu, 26 Sep 2013 14:44:22 -0700
Message-ID: <5244aab6.LeSffJNmsMHVz+s5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3IZVoX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 17:44:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, jg1.han@samsung.com

Subject: + drivers-block-sx8c-use-module_pci_driver.patch added to -mm tree
To: jg1.han@samsung.com,axboe@kernel.dk
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 14:44:22 -0700


The patch titled
     Subject: drivers/block/sx8.c: use module_pci_driver()
has been added to the -mm tree.  Its filename is
     drivers-block-sx8c-use-module_pci_driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-block-sx8c-use-module_pci_driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-block-sx8c-use-module_pci_driver.patch

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
Subject: drivers/block/sx8.c: use module_pci_driver()

Use module_pci_driver() macro which makes the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/sx8.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff -puN drivers/block/sx8.c~drivers-block-sx8c-use-module_pci_driver drivers/block/sx8.c
--- a/drivers/block/sx8.c~drivers-block-sx8c-use-module_pci_driver
+++ a/drivers/block/sx8.c
@@ -1747,17 +1747,4 @@ static void carm_remove_one (struct pci_
 	pci_set_drvdata(pdev, NULL);
 }
 
-static int __init carm_init(void)
-{
-	return pci_register_driver(&carm_driver);
-}
-
-static void __exit carm_exit(void)
-{
-	pci_unregister_driver(&carm_driver);
-}
-
-module_init(carm_init);
-module_exit(carm_exit);
-
-
+module_pci_driver(carm_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

kernel-params-fix-handling-of-signed-integer-types.patch
drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch
drivers-block-sx8c-use-module_pci_driver.patch
block-sx8-remove-unnecessary-pci_set_drvdata.patch
backlight-lp855x_bl-support-new-lp8555-device.patch
backlight-lm3630-apply-chip-revision.patch
backlight-ld9040-staticize-local-variable-gamma_table.patch
backlight-lm3639-dont-mix-different-enum-types.patch
backlight-lp8788-staticize-default_bl_config.patch
backlight-use-dev_get_platdata.patch
backlight-88pm860x_bl-use-devm_backlight_device_register.patch
backlight-aat2870-use-devm_backlight_device_register.patch
backlight-adp5520-use-devm_backlight_device_register.patch
backlight-adp8860-use-devm_backlight_device_register.patch
backlight-adp8870-use-devm_backlight_device_register.patch
backlight-as3711_bl-use-devm_backlight_device_register.patch
backlight-atmel-pwm-bl-use-devm_backlight_device_register.patch
backlight-bd6107-use-devm_backlight_device_register.patch
backlight-da903x_bl-use-devm_backlight_device_register.patch
backlight-da9052_bl-use-devm_backlight_device_register.patch
backlight-ep93xx-use-devm_backlight_device_register.patch
backlight-generic_bl-use-devm_backlight_device_register.patch
backlight-gpio_backlight-use-devm_backlight_device_register.patch
backlight-kb3886_bl-use-devm_backlight_device_register.patch
backlight-lm3533_bl-use-devm_backlight_device_register.patch
backlight-lp855x-use-devm_backlight_device_register.patch
backlight-lv5207lp-use-devm_backlight_device_register.patch
backlight-max8925_bl-use-devm_backlight_device_register.patch
backlight-pandora_bl-use-devm_backlight_device_register.patch
backlight-pcf50633-use-devm_backlight_device_register.patch
backlight-tps65217_bl-use-devm_backlight_device_register.patch
backlight-wm831x_bl-use-devm_backlight_device_register.patch
backlight-hx8357-use-devm_lcd_device_register.patch
backlight-ili922x-use-devm_lcd_device_register.patch
backlight-ili9320-use-devm_lcd_device_register.patch
backlight-lms283gf05-use-devm_lcd_device_register.patch
backlight-lms501kf03-use-devm_lcd_device_register.patch
backlight-ltv350qv-use-devm_lcd_device_register.patch
backlight-platform_lcd-use-devm_lcd_device_register.patch
backlight-tdo24m-use-devm_lcd_device_register.patch
backlight-ams369fg06-use-devm_backlightlcd_device_register.patch
backlight-ld9040-use-devm_backlightlcd_device_register.patch
backlight-corgi_lcd-use-devm_backlightlcd_device_register.patch
backlight-cr_bllcd-use-devm_backlightlcd_device_register.patch
backlight-s6e63m0-use-devm_backlightlcd_device_register.patch
backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch
backlight-lm3630-potential-null-deref-in-probe.patch
drivers-video-backlight-l4f00242t03c-remove-redundant-spi_set_drvdata.patch
drivers-video-backlight-tosa_lcdc-remove-redundant-spi_set_drvdata.patch
drivers-rtc-rtc-ds1307c-release-irq-on-error.patch
drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch
drivers-rtc-rtc-max6900c-remove-redundant-checks.patch
drivers-rtc-rtc-vt8500c-fix-return-value.patch
drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch
drivers-rtc-rtc-isl1208c-use-devm_-apis.patch
drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch
drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void.patch
drivers-rtc-rtc-88pm80xc-use-dev_get_platdata.patch
drivers-rtc-rtc-88pm860xc-use-dev_get_platdata.patch
drivers-rtc-rtc-cmosc-use-dev_get_platdata.patch
drivers-rtc-rtc-da9055c-use-dev_get_platdata.patch
drivers-rtc-rtc-ds1305c-use-dev_get_platdata.patch
drivers-rtc-rtc-ds1307c-use-dev_get_platdata.patch
drivers-rtc-rtc-ds2404c-use-dev_get_platdata.patch
drivers-rtc-rtc-ep93xxc-use-dev_get_platdata.patch
drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch
drivers-rtc-rtc-m48t59c-use-dev_get_platdata.patch
drivers-rtc-rtc-m48t86c-use-dev_get_platdata.patch
drivers-rtc-rtc-pcf2123c-use-dev_get_platdata.patch
drivers-rtc-rtc-rs5c348c-use-dev_get_platdata.patch
drivers-rtc-rtc-shc-use-dev_get_platdata.patch
drivers-rtc-rtc-v3020c-use-dev_get_platdata.patch
drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void.patch
gcov-reuse-kbasename-helper.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch
linux-next.patch

