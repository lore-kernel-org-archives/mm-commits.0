From: akpm@linux-foundation.org
Subject: + sh-superh-keysc-platform-driver.patch added to -mm tree
Date: Fri, 29 Feb 2008 14:02:49 -0800
Message-ID: <200802292202.m1TM2oVr023005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761602AbYB2WEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 17:04:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, damm@igel.co.jp, dtor@mail.ru, lethal@linux-sh.org


The patch titled
     sh: SuperH KEYSC platform driver
has been added to the -mm tree.  Its filename is
     sh-superh-keysc-platform-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: SuperH KEYSC platform driver
From: Magnus Damm <magnus.damm@gmail.com>

Add a platform driver for the SuperH KEYSC block.  The driver expects to get
mode, timing information and keypad layout from the board code as platform
data.  The board code is resonsible for pin configuration.

Both sh7343 and sh7722 should be supported, but only the sh7722 processor has
been tested so far.  SH_KEYSC_MODE_3 is yet to be tested.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/Kconfig    |    9 
 drivers/input/keyboard/Makefile   |    1 
 drivers/input/keyboard/sh_keysc.c |  281 ++++++++++++++++++++++++++++
 include/asm-sh/sh_keysc.h         |   13 +
 4 files changed, 304 insertions(+)

diff -puN drivers/input/keyboard/Kconfig~sh-superh-keysc-platform-driver drivers/input/keyboard/Kconfig
--- a/drivers/input/keyboard/Kconfig~sh-superh-keysc-platform-driver
+++ a/drivers/input/keyboard/Kconfig
@@ -314,4 +314,13 @@ config KEYBOARD_BFIN
 	  To compile this driver as a module, choose M here: the
 	  module will be called bf54x-keys.
 
+config KEYBOARD_SH_KEYSC
+	tristate "SuperH KEYSC keypad support"
+	depends on SUPERH
+	help
+	  Say Y here if you want to use a keypad attached to the KEYSC block
+	  on SuperH processors such as sh7722 and sh7343.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sh_keysc.
 endif
diff -puN drivers/input/keyboard/Makefile~sh-superh-keysc-platform-driver drivers/input/keyboard/Makefile
--- a/drivers/input/keyboard/Makefile~sh-superh-keysc-platform-driver
+++ a/drivers/input/keyboard/Makefile
@@ -26,3 +26,4 @@ obj-$(CONFIG_KEYBOARD_HP6XX)		+= jornada
 obj-$(CONFIG_KEYBOARD_HP7XX)		+= jornada720_kbd.o
 obj-$(CONFIG_KEYBOARD_MAPLE)		+= maple_keyb.o
 obj-$(CONFIG_KEYBOARD_BFIN)		+= bf54x-keys.o
+obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
diff -puN /dev/null drivers/input/keyboard/sh_keysc.c
--- /dev/null
+++ a/drivers/input/keyboard/sh_keysc.c
@@ -0,0 +1,281 @@
+/*
+ * SuperH KEYSC Keypad Driver
+ *
+ * Copyright (C) 2008 Magnus Damm
+ *
+ * Based on gpio_keys.c, Copyright 2005 Phil Blundell
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/io.h>
+#include <asm/sh_keysc.h>
+
+#define KYCR1_OFFS   0x00
+#define KYCR2_OFFS   0x04
+#define KYINDR_OFFS  0x08
+#define KYOUTDR_OFFS 0x0c
+
+#define KYCR2_IRQ_LEVEL    0x10
+#define KYCR2_IRQ_DISABLED 0x00
+
+static const struct {
+	unsigned char kymd, keyout, keyin;
+} sh_keysc_mode[] = {
+	[SH_KEYSC_MODE_1] = { 0, 6, 5 },
+	[SH_KEYSC_MODE_2] = { 1, 5, 6 },
+	[SH_KEYSC_MODE_3] = { 2, 4, 7 },
+};
+
+struct sh_keysc_priv {
+	void __iomem *iomem_base;
+	unsigned long last_keys;
+	struct input_dev *input;
+	struct sh_keysc_info pdata;
+};
+
+static irqreturn_t sh_keysc_isr(int irq, void *dev_id)
+{
+	struct platform_device *pdev = dev_id;
+	struct sh_keysc_priv *priv = platform_get_drvdata(pdev);
+	struct sh_keysc_info *pdata = &priv->pdata;
+	unsigned long keys, keys1, keys0, mask;
+	unsigned char keyin_set, tmp;
+	int i, k;
+
+	dev_dbg(&pdev->dev, "isr!\n");
+
+	keys1 = ~0;
+	keys0 = 0;
+
+	do {
+		keys = 0;
+		keyin_set = 0;
+
+		iowrite16(KYCR2_IRQ_DISABLED, priv->iomem_base + KYCR2_OFFS);
+
+		for (i = 0; i < sh_keysc_mode[pdata->mode].keyout; i++) {
+			iowrite16(0xfff ^ (3 << (i * 2)),
+				  priv->iomem_base + KYOUTDR_OFFS);
+			udelay(pdata->delay);
+			tmp = ioread16(priv->iomem_base + KYINDR_OFFS);
+			keys |= tmp << (sh_keysc_mode[pdata->mode].keyin * i);
+			tmp ^= (1 << sh_keysc_mode[pdata->mode].keyin) - 1;
+			keyin_set |= tmp;
+		}
+
+		iowrite16(0, priv->iomem_base + KYOUTDR_OFFS);
+		iowrite16(KYCR2_IRQ_LEVEL | (keyin_set << 8),
+			  priv->iomem_base + KYCR2_OFFS);
+
+		keys ^= ~0;
+		keys &= (1 << (sh_keysc_mode[pdata->mode].keyin *
+			       sh_keysc_mode[pdata->mode].keyout)) - 1;
+		keys1 &= keys;
+		keys0 |= keys;
+
+		dev_dbg(&pdev->dev, "keys 0x%08lx\n", keys);
+
+	} while (ioread16(priv->iomem_base + KYCR2_OFFS) & 0x01);
+
+	dev_dbg(&pdev->dev, "last_keys 0x%08lx keys0 0x%08lx keys1 0x%08lx\n",
+		priv->last_keys, keys0, keys1);
+
+	for (i = 0; i < SH_KEYSC_MAXKEYS; i++) {
+		k = pdata->keycodes[i];
+		if (!k)
+			continue;
+
+		mask = 1 << i;
+
+		if (!((priv->last_keys ^ keys0) & mask))
+			continue;
+
+		if ((keys1 | keys0) & mask) {
+			input_event(priv->input, EV_KEY, k, 1);
+			priv->last_keys |= mask;
+		}
+
+		if (!(keys1 & mask)) {
+			input_event(priv->input, EV_KEY, k, 0);
+			priv->last_keys &= ~mask;
+		}
+
+	}
+	input_sync(priv->input);
+
+	return IRQ_HANDLED;
+}
+
+#define res_size(res) ((res)->end - (res)->start + 1)
+
+static int __devinit sh_keysc_probe(struct platform_device *pdev)
+{
+	struct sh_keysc_priv *priv;
+	struct sh_keysc_info *pdata;
+	struct resource *res;
+	struct input_dev *input;
+	int i, k;
+	int irq, error;
+
+	if (!pdev->dev.platform_data) {
+		dev_err(&pdev->dev, "no platform data defined\n");
+		error = -EINVAL;
+		goto err0;
+	}
+
+	error = -ENXIO;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get I/O memory\n");
+		goto err0;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to get irq\n");
+		goto err0;
+	}
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL) {
+		dev_err(&pdev->dev, "failed to allocate driver data\n");
+		error = -ENOMEM;
+		goto err0;
+	}
+
+	platform_set_drvdata(pdev, priv);
+	memcpy(&priv->pdata, pdev->dev.platform_data, sizeof(priv->pdata));
+	pdata = &priv->pdata;
+
+	res = request_mem_region(res->start, res_size(res), pdev->name);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to request I/O memory\n");
+		error = -EBUSY;
+		goto err1;
+	}
+
+	priv->iomem_base = ioremap_nocache(res->start, res_size(res));
+	if (priv->iomem_base == NULL) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		error = -ENXIO;
+		goto err2;
+	}
+
+	priv->input = input_allocate_device();
+	if (!priv->input) {
+		dev_err(&pdev->dev, "failed to allocate input device\n");
+		error = -ENOMEM;
+		goto err3;
+	}
+
+	input = priv->input;
+	input->evbit[0] = BIT_MASK(EV_KEY);
+
+	input->name = pdev->name;
+	input->phys = "sh-keysc-keys/input0";
+	input->dev.parent = &pdev->dev;
+
+	input->id.bustype = BUS_HOST;
+	input->id.vendor = 0x0001;
+	input->id.product = 0x0001;
+	input->id.version = 0x0100;
+
+	error = request_irq(irq, sh_keysc_isr, 0, pdev->name, pdev);
+	if (error) {
+		dev_err(&pdev->dev, "failed to request IRQ\n");
+		goto err4;
+	}
+
+	for (i = 0; i < SH_KEYSC_MAXKEYS; i++) {
+		k = pdata->keycodes[i];
+		if (k)
+			input_set_capability(input, EV_KEY, k);
+	}
+
+	error = input_register_device(input);
+	if (error) {
+		dev_err(&pdev->dev, "failed to register input device\n");
+		goto err5;
+	}
+
+	iowrite16((sh_keysc_mode[pdata->mode].kymd << 8) |
+		  pdata->scan_timing, priv->iomem_base + KYCR1_OFFS);
+	iowrite16(0, priv->iomem_base + KYOUTDR_OFFS);
+	iowrite16(KYCR2_IRQ_LEVEL, priv->iomem_base + KYCR2_OFFS);
+	return 0;
+ err5:
+	free_irq(irq, pdev);
+ err4:
+	input_free_device(input);
+ err3:
+	iounmap(priv->iomem_base);
+ err2:
+	release_mem_region(res->start, res_size(res));
+ err1:
+	platform_set_drvdata(pdev, NULL);
+	kfree(priv);
+ err0:
+	return error;
+}
+
+static int __devexit sh_keysc_remove(struct platform_device *pdev)
+{
+	struct sh_keysc_priv *priv = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	iowrite16(KYCR2_IRQ_DISABLED, priv->iomem_base + KYCR2_OFFS);
+
+	input_unregister_device(priv->input);
+	free_irq(platform_get_irq(pdev, 0), pdev);
+	input_free_device(priv->input);
+	iounmap(priv->iomem_base);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, res_size(res));
+
+	platform_set_drvdata(pdev, NULL);
+	kfree(priv);
+	return 0;
+}
+
+
+#define sh_keysc_suspend NULL
+#define sh_keysc_resume NULL
+
+struct platform_driver sh_keysc_device_driver = {
+	.probe		= sh_keysc_probe,
+	.remove		= __devexit_p(sh_keysc_remove),
+	.suspend	= sh_keysc_suspend,
+	.resume		= sh_keysc_resume,
+	.driver		= {
+		.name	= "sh_keysc",
+	}
+};
+
+static int __init sh_keysc_init(void)
+{
+	return platform_driver_register(&sh_keysc_device_driver);
+}
+
+static void __exit sh_keysc_exit(void)
+{
+	platform_driver_unregister(&sh_keysc_device_driver);
+}
+
+module_init(sh_keysc_init);
+module_exit(sh_keysc_exit);
+
+MODULE_AUTHOR("Magnus Damm");
+MODULE_DESCRIPTION("SuperH KEYSC Keypad Driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/asm-sh/sh_keysc.h
--- /dev/null
+++ a/include/asm-sh/sh_keysc.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_KEYSC_H__
+#define __ASM_KEYSC_H__
+
+#define SH_KEYSC_MAXKEYS 30
+
+struct sh_keysc_info {
+	enum { SH_KEYSC_MODE_1, SH_KEYSC_MODE_2, SH_KEYSC_MODE_3 } mode;
+	int scan_timing; /* 0 -> 7, see KYCR1, SCN[2:0] */
+	int delay;
+	int keycodes[SH_KEYSC_MAXKEYS];
+};
+
+#endif /* __ASM_KEYSC_H__ */
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

smc91x-pass-along-private-data-v2.patch
smc91x-introduce-platform-data-flags-v2.patch
smc91x-add-insw-outsw-to-default-config-v2.patch
smc91x-make-superh-use-default-config-v2.patch
git-sh.patch
sh-superh-keysc-platform-driver.patch
sh-superh-keysc-keypad-data-for-migor.patch
sh-superh-keysc-keypad-data-for-solution-engine-7722.patch
sm501-add-uart-support.patch

