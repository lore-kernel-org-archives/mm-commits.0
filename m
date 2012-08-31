From: akpm@linux-foundation.org
Subject: + backlight-remove-progear-driver.patch added to -mm tree
Date: Fri, 31 Aug 2012 15:54:30 -0700
Message-ID: <20120831225431.229AA1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:54663 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab2HaWyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 18:54:32 -0400
Received: by ggnu1 with SMTP id u1so399366ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 15:54:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.juszkiewicz@linaro.org, marcin@juszkiewicz.com.pl


The patch titled
     Subject: backlight: remove ProGear driver
has been added to the -mm tree.  Its filename is
     backlight-remove-progear-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
Subject: backlight: remove ProGear driver

This driver was for the ProGear webpad device which was produced in
2000/2001 and is not available on a market.  I no longer have this
hardware so can not even check how Linux works on it.

Signed-off-by: Marcin Juszkiewicz <marcin@juszkiewicz.com.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig      |    7 -
 drivers/video/backlight/Makefile     |    1 
 drivers/video/backlight/progear_bl.c |  162 -------------------------
 3 files changed, 170 deletions(-)

diff -puN drivers/video/backlight/Kconfig~backlight-remove-progear-driver drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-remove-progear-driver
+++ a/drivers/video/backlight/Kconfig
@@ -229,13 +229,6 @@ config BACKLIGHT_HP700
 	  If you have an HP Jornada 700 series,
 	  say Y to include backlight control driver.
 
-config BACKLIGHT_PROGEAR
-	tristate "Frontpath ProGear Backlight Driver"
-	depends on PCI && X86
-	help
-	  If you have a Frontpath ProGear say Y to enable the
-	  backlight driver.
-
 config BACKLIGHT_CARILLO_RANCH
 	tristate "Intel Carillo Ranch Backlight Driver"
 	depends on LCD_CLASS_DEVICE && PCI && X86 && FB_LE80578
diff -puN drivers/video/backlight/Makefile~backlight-remove-progear-driver drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-remove-progear-driver
+++ a/drivers/video/backlight/Makefile
@@ -28,7 +28,6 @@ obj-$(CONFIG_BACKLIGHT_LM3639)	+= lm3639
 obj-$(CONFIG_BACKLIGHT_LP855X)	+= lp855x_bl.o
 obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
 obj-$(CONFIG_BACKLIGHT_PANDORA)	+= pandora_bl.o
-obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
 obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
diff -puN drivers/video/backlight/progear_bl.c~backlight-remove-progear-driver /dev/null
--- a/drivers/video/backlight/progear_bl.c
+++ /dev/null
@@ -1,162 +0,0 @@
-/*
- *  Backlight Driver for Frontpath ProGear HX1050+
- *
- *  Copyright (c) 2006 Marcin Juszkiewicz
- *
- *  Based on Progear LCD driver by M Schacht
- *  <mschacht at alumni dot washington dot edu>
- *
- *  Based on Sharp's Corgi Backlight Driver
- *  Based on Backlight Driver for HP Jornada 680
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation.
- *
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/mutex.h>
-#include <linux/fb.h>
-#include <linux/backlight.h>
-#include <linux/pci.h>
-
-#define PMU_LPCR               0xB0
-#define SB_MPS1                0x61
-#define HW_LEVEL_MAX           0x77
-#define HW_LEVEL_MIN           0x4f
-
-static struct pci_dev *pmu_dev = NULL;
-static struct pci_dev *sb_dev = NULL;
-
-static int progearbl_set_intensity(struct backlight_device *bd)
-{
-	int intensity = bd->props.brightness;
-
-	if (bd->props.power != FB_BLANK_UNBLANK)
-		intensity = 0;
-	if (bd->props.fb_blank != FB_BLANK_UNBLANK)
-		intensity = 0;
-
-	pci_write_config_byte(pmu_dev, PMU_LPCR, intensity + HW_LEVEL_MIN);
-
-	return 0;
-}
-
-static int progearbl_get_intensity(struct backlight_device *bd)
-{
-	u8 intensity;
-	pci_read_config_byte(pmu_dev, PMU_LPCR, &intensity);
-
-	return intensity - HW_LEVEL_MIN;
-}
-
-static const struct backlight_ops progearbl_ops = {
-	.get_brightness = progearbl_get_intensity,
-	.update_status = progearbl_set_intensity,
-};
-
-static int progearbl_probe(struct platform_device *pdev)
-{
-	struct backlight_properties props;
-	u8 temp;
-	struct backlight_device *progear_backlight_device;
-	int ret;
-
-	pmu_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101, NULL);
-	if (!pmu_dev) {
-		pr_err("ALI M7101 PMU not found.\n");
-		return -ENODEV;
-	}
-
-	sb_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
-	if (!sb_dev) {
-		pr_err("ALI 1533 SB not found.\n");
-		ret = -ENODEV;
-		goto put_pmu;
-	}
-
-	/*     Set SB_MPS1 to enable brightness control. */
-	pci_read_config_byte(sb_dev, SB_MPS1, &temp);
-	pci_write_config_byte(sb_dev, SB_MPS1, temp | 0x20);
-
-	memset(&props, 0, sizeof(struct backlight_properties));
-	props.type = BACKLIGHT_RAW;
-	props.max_brightness = HW_LEVEL_MAX - HW_LEVEL_MIN;
-	progear_backlight_device = backlight_device_register("progear-bl",
-							     &pdev->dev, NULL,
-							     &progearbl_ops,
-							     &props);
-	if (IS_ERR(progear_backlight_device)) {
-		ret = PTR_ERR(progear_backlight_device);
-		goto put_sb;
-	}
-
-	platform_set_drvdata(pdev, progear_backlight_device);
-
-	progear_backlight_device->props.power = FB_BLANK_UNBLANK;
-	progear_backlight_device->props.brightness = HW_LEVEL_MAX - HW_LEVEL_MIN;
-	progearbl_set_intensity(progear_backlight_device);
-
-	return 0;
-put_sb:
-	pci_dev_put(sb_dev);
-put_pmu:
-	pci_dev_put(pmu_dev);
-	return ret;
-}
-
-static int progearbl_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bd = platform_get_drvdata(pdev);
-	backlight_device_unregister(bd);
-
-	return 0;
-}
-
-static struct platform_driver progearbl_driver = {
-	.probe = progearbl_probe,
-	.remove = progearbl_remove,
-	.driver = {
-		   .name = "progear-bl",
-		   },
-};
-
-static struct platform_device *progearbl_device;
-
-static int __init progearbl_init(void)
-{
-	int ret = platform_driver_register(&progearbl_driver);
-
-	if (ret)
-		return ret;
-	progearbl_device = platform_device_register_simple("progear-bl", -1,
-								NULL, 0);
-	if (IS_ERR(progearbl_device)) {
-		platform_driver_unregister(&progearbl_driver);
-		return PTR_ERR(progearbl_device);
-	}
-
-	return 0;
-}
-
-static void __exit progearbl_exit(void)
-{
-	pci_dev_put(pmu_dev);
-	pci_dev_put(sb_dev);
-
-	platform_device_unregister(progearbl_device);
-	platform_driver_unregister(&progearbl_driver);
-}
-
-module_init(progearbl_init);
-module_exit(progearbl_exit);
