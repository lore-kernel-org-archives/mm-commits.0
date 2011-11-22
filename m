From: akpm@linux-foundation.org
Subject: + backlight-remove-adx-backlight-device-support.patch added to -mm tree
Date: Tue, 22 Nov 2011 14:22:38 -0800
Message-ID: <201111222222.pAMMMdEJ027449@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:46907 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225Ab1KVWWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Nov 2011 17:22:44 -0500
Received: by lahi5 with SMTP id i5so6884lah.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 14:22:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pebolle@tiscali.nl, rpurdie@rpsys.net, thierry.reding@avionic-design.de, wim@iguana.be


The patch titled
     Subject: backlight: remove ADX backlight device support
has been added to the -mm tree.  Its filename is
     backlight-remove-adx-backlight-device-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: backlight: remove ADX backlight device support

Support for the Avionic Design Xanthos backlight device got added in
commit 3b96ea9ef8 ("backlight: Add support for the Avionic Design Xanthos
backlight device.").  That support depends on ARCH_PXA_ADX.  The code that
should have provided that Kconfig symbol never got submitted.  It has
never been possible to even build this driver.  Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig  |    8 -
 drivers/video/backlight/Makefile |    1 
 drivers/video/backlight/adx_bl.c |  182 -----------------------------
 3 files changed, 191 deletions(-)

diff -puN drivers/video/backlight/Kconfig~backlight-remove-adx-backlight-device-support drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-remove-adx-backlight-device-support
+++ a/drivers/video/backlight/Kconfig
@@ -280,14 +280,6 @@ config BACKLIGHT_WM831X
 	  If you have a backlight driven by the ISINK and DCDC of a
 	  WM831x PMIC say y to enable the backlight driver for it.
 
-config BACKLIGHT_ADX
-	tristate "Avionic Design Xanthos Backlight Driver"
-	depends on ARCH_PXA_ADX
-	default y
-	help
-	  Say Y to enable the backlight driver on Avionic Design Xanthos-based
-	  boards.
-
 config BACKLIGHT_ADP5520
 	tristate "Backlight Driver for ADP5520/ADP5501 using WLED"
 	depends on PMIC_ADP5520
diff -puN drivers/video/backlight/Makefile~backlight-remove-adx-backlight-device-support drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-remove-adx-backlight-device-support
+++ a/drivers/video/backlight/Makefile
@@ -32,7 +32,6 @@ obj-$(CONFIG_BACKLIGHT_APPLE)	+= apple_b
 obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
 obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
 obj-$(CONFIG_BACKLIGHT_WM831X)	+= wm831x_bl.o
-obj-$(CONFIG_BACKLIGHT_ADX)    += adx_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP5520)	+= adp5520_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8860)	+= adp8860_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8870)	+= adp8870_bl.o
diff -puN drivers/video/backlight/adx_bl.c~backlight-remove-adx-backlight-device-support /dev/null
--- a/drivers/video/backlight/adx_bl.c
+++ /dev/null
@@ -1,182 +0,0 @@
-/*
- * linux/drivers/video/backlight/adx.c
- *
- * Copyright (C) 2009 Avionic Design GmbH
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Written by Thierry Reding <thierry.reding@avionic-design.de>
- */
-
-#include <linux/backlight.h>
-#include <linux/fb.h>
-#include <linux/gfp.h>
-#include <linux/io.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-
-/* register definitions */
-#define ADX_BACKLIGHT_CONTROL		0x00
-#define ADX_BACKLIGHT_CONTROL_ENABLE	(1 << 0)
-#define ADX_BACKLIGHT_BRIGHTNESS	0x08
-#define ADX_BACKLIGHT_STATUS		0x10
-#define ADX_BACKLIGHT_ERROR		0x18
-
-struct adxbl {
-	void __iomem *base;
-};
-
-static int adx_backlight_update_status(struct backlight_device *bldev)
-{
-	struct adxbl *bl = bl_get_data(bldev);
-	u32 value;
-
-	value = bldev->props.brightness;
-	writel(value, bl->base + ADX_BACKLIGHT_BRIGHTNESS);
-
-	value = readl(bl->base + ADX_BACKLIGHT_CONTROL);
-
-	if (bldev->props.state & BL_CORE_FBBLANK)
-		value &= ~ADX_BACKLIGHT_CONTROL_ENABLE;
-	else
-		value |= ADX_BACKLIGHT_CONTROL_ENABLE;
-
-	writel(value, bl->base + ADX_BACKLIGHT_CONTROL);
-
-	return 0;
-}
-
-static int adx_backlight_get_brightness(struct backlight_device *bldev)
-{
-	struct adxbl *bl = bl_get_data(bldev);
-	u32 brightness;
-
-	brightness = readl(bl->base + ADX_BACKLIGHT_BRIGHTNESS);
-	return brightness & 0xff;
-}
-
-static int adx_backlight_check_fb(struct backlight_device *bldev, struct fb_info *fb)
-{
-	return 1;
-}
-
-static const struct backlight_ops adx_backlight_ops = {
-	.options = 0,
-	.update_status = adx_backlight_update_status,
-	.get_brightness = adx_backlight_get_brightness,
-	.check_fb = adx_backlight_check_fb,
-};
-
-static int __devinit adx_backlight_probe(struct platform_device *pdev)
-{
-	struct backlight_properties props;
-	struct backlight_device *bldev;
-	struct resource *res;
-	struct adxbl *bl;
-	int ret = 0;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENXIO;
-		goto out;
-	}
-
-	res = devm_request_mem_region(&pdev->dev, res->start,
-			resource_size(res), res->name);
-	if (!res) {
-		ret = -ENXIO;
-		goto out;
-	}
-
-	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
-	if (!bl) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	bl->base = devm_ioremap_nocache(&pdev->dev, res->start,
-			resource_size(res));
-	if (!bl->base) {
-		ret = -ENXIO;
-		goto out;
-	}
-
-	memset(&props, 0, sizeof(struct backlight_properties));
-	props.type = BACKLIGHT_RAW;
-	props.max_brightness = 0xff;
-	bldev = backlight_device_register(dev_name(&pdev->dev), &pdev->dev,
-					  bl, &adx_backlight_ops, &props);
-	if (IS_ERR(bldev)) {
-		ret = PTR_ERR(bldev);
-		goto out;
-	}
-
-	bldev->props.brightness = 0xff;
-	bldev->props.power = FB_BLANK_UNBLANK;
-
-	platform_set_drvdata(pdev, bldev);
-
-out:
-	return ret;
-}
-
-static int __devexit adx_backlight_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bldev;
-	int ret = 0;
-
-	bldev = platform_get_drvdata(pdev);
-	bldev->props.power = FB_BLANK_UNBLANK;
-	bldev->props.brightness = 0xff;
-	backlight_update_status(bldev);
-	backlight_device_unregister(bldev);
-	platform_set_drvdata(pdev, NULL);
-
-	return ret;
-}
-
-#ifdef CONFIG_PM
-static int adx_backlight_suspend(struct platform_device *pdev,
-		pm_message_t state)
-{
-	return 0;
-}
-
-static int adx_backlight_resume(struct platform_device *pdev)
-{
-	return 0;
-}
-#else
-#define adx_backlight_suspend NULL
-#define adx_backlight_resume NULL
-#endif
-
-static struct platform_driver adx_backlight_driver = {
-	.probe = adx_backlight_probe,
-	.remove = __devexit_p(adx_backlight_remove),
-	.suspend = adx_backlight_suspend,
-	.resume = adx_backlight_resume,
-	.driver = {
-		.name = "adx-backlight",
-		.owner = THIS_MODULE,
-	},
-};
-
-static int __init adx_backlight_init(void)
-{
-	return platform_driver_register(&adx_backlight_driver);
-}
-
-static void __exit adx_backlight_exit(void)
-{
-	platform_driver_unregister(&adx_backlight_driver);
-}
-
-module_init(adx_backlight_init);
-module_exit(adx_backlight_exit);
