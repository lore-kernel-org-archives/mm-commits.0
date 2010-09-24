From: akpm@linux-foundation.org
Subject: + gpio-add-driver-for-basic-memory-mapped-gpio-controllers.patch added to -mm tree
Date: Fri, 24 Sep 2010 14:45:42 -0700
Message-ID: <201009242145.o8OLjgDR027117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab0IXVp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 17:45:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cbouatmailru@gmail.com, alan@lxorguk.ukuu.org.uk, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, sameo@linux.intel.com


The patch titled
     gpio: add driver for basic memory-mapped GPIO controllers
has been added to the -mm tree.  Its filename is
     gpio-add-driver-for-basic-memory-mapped-gpio-controllers.patch

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
Subject: gpio: add driver for basic memory-mapped GPIO controllers
From: Anton Vorontsov <cbouatmailru@gmail.com>

The basic GPIO controllers may be found in various on-board FPGA and ASIC
solutions that are used to control board's switches, LEDs, chip-selects,
Ethernet/USB PHY power, etc.

These controllers may not provide any means of pin setup
(in/out/open drain).

The driver supports:
- 8/16/32/64 bits registers;
- GPIO controllers with clear/set registers;
- GPIO controllers with a single "data" register;
- Big endian bits/GPIOs ordering (mostly used on PowerPC).

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig            |    5 
 drivers/gpio/Makefile           |    1 
 drivers/gpio/basic_mmio_gpio.c  |  281 ++++++++++++++++++++++++++++++
 include/linux/basic_mmio_gpio.h |   20 ++
 4 files changed, 307 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-add-driver-for-basic-memory-mapped-gpio-controllers drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-add-driver-for-basic-memory-mapped-gpio-controllers
+++ a/drivers/gpio/Kconfig
@@ -70,6 +70,11 @@ config GPIO_MAX730X
 
 comment "Memory mapped GPIO expanders:"
 
+config GPIO_BASIC_MMIO
+	tristate "Basic memory-mapped GPIO controllers support"
+	help
+	  Say yes here to support basic memory-mapped GPIO controllers.
+
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
 	depends on GPIOLIB
diff -puN drivers/gpio/Makefile~gpio-add-driver-for-basic-memory-mapped-gpio-controllers drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-add-driver-for-basic-memory-mapped-gpio-controllers
+++ a/drivers/gpio/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
+obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
 obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
diff -puN /dev/null drivers/gpio/basic_mmio_gpio.c
--- /dev/null
+++ a/drivers/gpio/basic_mmio_gpio.c
@@ -0,0 +1,281 @@
+/*
+ * Driver for basic memory-mapped GPIO controllers.
+ *
+ * Copyright 2008 MontaVista Software, Inc.
+ * Copyright 2008,2010 Anton Vorontsov <cbouatmailru@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * ....``.```~~~~````.`.`.`.`.```````'',,,.........`````......`.......
+ * ...``                                                         ```````..
+ * ..The simplest form of a GPIO controller that the driver supports is``
+ *  `.just a single "data" register, where GPIO state can be read and/or `
+ *    `,..written. ,,..``~~~~ .....``.`.`.~~.```.`.........``````.```````
+ *        `````````
+                                    ___
+_/~~|___/~|   . ```~~~~~~       ___/___\___     ,~.`.`.`.`````.~~...,,,,...
+__________|~$@~~~        %~    /o*o*o*o*o*o\   .. Implementing such a GPIO .
+o        `                     ~~~~\___/~~~~    ` controller in FPGA is ,.`
+                                                 `....trivial..'~`.```.```
+ *                                                    ```````
+ *  .```````~~~~`..`.``.``.
+ * .  The driver supports  `...       ,..```.`~~~```````````````....````.``,,
+ * .   big-endian notation, just`.  .. A bit more sophisticated controllers ,
+ *  . register the device with -be`. .with a pair of set/clear-bit registers ,
+ *   `.. suffix.  ```~~`````....`.`   . affecting the data register and the .`
+ *     ``.`.``...```                  ```.. output pins are also supported.`
+ *                        ^^             `````.`````````.,``~``~``~~``````
+ *                                                   .                  ^^
+ *   ,..`.`.`...````````````......`.`.`.`.`.`..`.`.`..
+ * .. The expectation is that in at least some cases .    ,-~~~-,
+ *  .this will be used with roll-your-own ASIC/FPGA .`     \   /
+ *  .logic in Verilog or VHDL. ~~~`````````..`````~~`       \ /
+ *  ..````````......```````````                             \o_
+ *                                                           |
+ *                              ^^                          / \
+ *
+ *           ...`````~~`.....``.`..........``````.`.``.```........``.
+ *            `  8, 16, 32 and 64 bits registers are supported, and``.
+ *            . the number of GPIOs is determined by the width of   ~
+ *             .. the registers. ,............```.`.`..`.`.~~~.`.`.`~
+ *               `.......````.```
+ */
+
+#include <linux/init.h>
+#include <linux/bug.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/log2.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mod_devicetable.h>
+#include <linux/basic_mmio_gpio.h>
+
+struct bgpio_chip {
+	struct gpio_chip gc;
+	void __iomem *reg_dat;
+	void __iomem *reg_set;
+	void __iomem *reg_clr;
+	spinlock_t lock;
+
+	int bits;
+	int big_endian_bits;
+
+	/* shadowed data register to clear/set bits safely */
+	unsigned long data;
+};
+
+static struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
+{
+	return container_of(gc, struct bgpio_chip, gc);
+}
+
+static unsigned long bgpio_in(struct bgpio_chip *bgc)
+{
+	switch (bgc->bits) {
+	case 8:
+		return __raw_readb(bgc->reg_dat);
+	case 16:
+		return __raw_readw(bgc->reg_dat);
+	case 32:
+		return __raw_readl(bgc->reg_dat);
+#if BITS_PER_LONG >= 64
+	case 64:
+		return __raw_readq(bgc->reg_dat);
+#endif
+	}
+	return -EINVAL;
+}
+
+static void bgpio_out(struct bgpio_chip *bgc, void __iomem *reg,
+		      unsigned long data)
+{
+	switch (bgc->bits) {
+	case 8:
+		__raw_writeb(data, reg);
+		return;
+	case 16:
+		__raw_writew(data, reg);
+		return;
+	case 32:
+		__raw_writel(data, reg);
+		return;
+#if BITS_PER_LONG >= 64
+	case 64:
+		__raw_writeq(data, reg);
+		return;
+#endif
+	}
+}
+
+static unsigned long bgpio_pin2mask(struct bgpio_chip *bgc, unsigned int pin)
+{
+	if (bgc->big_endian_bits)
+		return 1 << (bgc->bits - 1 - pin);
+	else
+		return 1 << pin;
+}
+
+static int bgpio_get(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+
+	return bgpio_in(bgc) & bgpio_pin2mask(bgc, gpio);
+}
+
+static void bgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long mask = bgpio_pin2mask(bgc, gpio);
+	unsigned long flags;
+
+	if (bgc->reg_set) {
+		if (val)
+			bgpio_out(bgc, bgc->reg_set, mask);
+		else
+			bgpio_out(bgc, bgc->reg_clr, mask);
+		return;
+	}
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	if (val)
+		bgc->data |= mask;
+	else
+		bgc->data &= ~mask;
+
+	bgpio_out(bgc, bgc->reg_dat, bgc->data);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	return 0;
+}
+
+static int bgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	bgpio_set(gc, gpio, val);
+	return 0;
+}
+
+static int __devinit bgpio_probe(struct platform_device *pdev)
+{
+	const struct platform_device_id *platid = platform_get_device_id(pdev);
+	struct device *dev = &pdev->dev;
+	struct bgpio_pdata *pdata = dev_get_platdata(dev);
+	struct bgpio_chip *bgc;
+	struct resource *res_dat;
+	struct resource *res_set;
+	struct resource *res_clr;
+	resource_size_t dat_sz;
+	int bits;
+
+	res_dat = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
+	if (!res_dat)
+		return -EINVAL;
+
+	dat_sz = resource_size(res_dat);
+	if (!is_power_of_2(dat_sz))
+		return -EINVAL;
+
+	bits = dat_sz * 8;
+	if (bits > BITS_PER_LONG)
+		return -EINVAL;
+
+	bgc = devm_kzalloc(dev, sizeof(*bgc), GFP_KERNEL);
+	if (!bgc)
+		return -ENOMEM;
+
+	bgc->reg_dat = devm_ioremap(dev, res_dat->start, dat_sz);
+	if (!bgc->reg_dat)
+		return -ENOMEM;
+
+	res_set = platform_get_resource_byname(pdev, IORESOURCE_MEM, "set");
+	res_clr = platform_get_resource_byname(pdev, IORESOURCE_MEM, "clr");
+	if (res_set && res_clr) {
+		if (resource_size(res_set) != resource_size(res_clr) ||
+				resource_size(res_set) != dat_sz)
+			return -EINVAL;
+
+		bgc->reg_set = devm_ioremap(dev, res_set->start, dat_sz);
+		bgc->reg_clr = devm_ioremap(dev, res_clr->start, dat_sz);
+		if (!bgc->reg_set || !bgc->reg_clr)
+			return -ENOMEM;
+	} else if (res_set || res_clr) {
+		return -EINVAL;
+	}
+
+	spin_lock_init(&bgc->lock);
+
+	bgc->bits = bits;
+	bgc->big_endian_bits = !strcmp(platid->name, "basic-mmio-gpio-be");
+	bgc->data = bgpio_in(bgc);
+
+	bgc->gc.ngpio = bits;
+	bgc->gc.direction_input = bgpio_dir_in;
+	bgc->gc.direction_output = bgpio_dir_out;
+	bgc->gc.get = bgpio_get;
+	bgc->gc.set = bgpio_set;
+	bgc->gc.dev = dev;
+	bgc->gc.label = dev_name(dev);
+
+	if (pdata)
+		bgc->gc.base = pdata->base;
+	else
+		bgc->gc.base = -1;
+
+	dev_set_drvdata(dev, bgc);
+
+	return gpiochip_add(&bgc->gc);
+}
+
+static int __devexit bgpio_remove(struct platform_device *pdev)
+{
+	struct bgpio_chip *bgc = dev_get_drvdata(&pdev->dev);
+
+	return gpiochip_remove(&bgc->gc);
+}
+
+static const struct platform_device_id bgpio_id_table[] = {
+	{ "basic-mmio-gpio", },
+	{ "basic-mmio-gpio-be", },
+	{},
+};
+MODULE_DEVICE_TABLE(platform, bgpio_id_table);
+
+static struct platform_driver bgpio_driver = {
+	.driver = {
+		.name = "basic-mmio-gpio",
+	},
+	.id_table = bgpio_id_table,
+	.probe = bgpio_probe,
+	.remove = __devexit_p(bgpio_remove),
+};
+
+static int __init bgpio_init(void)
+{
+	return platform_driver_register(&bgpio_driver);
+}
+module_init(bgpio_init);
+
+static void __exit bgpio_exit(void)
+{
+	platform_driver_unregister(&bgpio_driver);
+}
+module_exit(bgpio_exit);
+
+MODULE_DESCRIPTION("Driver for basic memory-mapped GPIO controllers");
+MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/basic_mmio_gpio.h
--- /dev/null
+++ a/include/linux/basic_mmio_gpio.h
@@ -0,0 +1,20 @@
+/*
+ * Basic memory-mapped GPIO controllers.
+ *
+ * Copyright 2008 MontaVista Software, Inc.
+ * Copyright 2008,2010 Anton Vorontsov <cbouatmailru@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __BASIC_MMIO_GPIO_H
+#define __BASIC_MMIO_GPIO_H
+
+struct bgpio_pdata {
+	int base;
+};
+
+#endif /* __BASIC_MMIO_GPIO_H */
_

Patches currently in -mm which might be from cbouatmailru@gmail.com are

linux-next.patch
mtdpart-memory-accessor-interface-for-mtd-layer.patch
drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units.patch
gpio-add-driver-for-basic-memory-mapped-gpio-controllers.patch

