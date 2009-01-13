From: akpm@linux-foundation.org
Subject: [merged] mfd-pcf50633-gpio-support.patch removed from -mm tree
Date: Tue, 13 Jan 2009 12:13:11 -0800
Message-ID: <200901132013.n0DKDBPC012338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945AbZAMUNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 15:13:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balajirrao@openmoko.org, andy@openmoko.com, david-b@pacbell.net, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: PCF50633 gpio support
has been removed from the -mm tree.  Its filename was
     mfd-pcf50633-gpio-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: PCF50633 gpio support
From: Balaji Rao <balajirrao@openmoko.org>

What the PCF05633 calls as a 'GPIO' is much more than the GPIO in the linux
sense and there are only 4 of them - which means, the gpiolib is not used
here.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig               |    7 +
 drivers/mfd/Makefile              |    1 
 drivers/mfd/pcf50633-gpio.c       |  118 ++++++++++++++++++++++++++++
 include/linux/mfd/pcf50633/gpio.h |   52 ++++++++++++
 4 files changed, 178 insertions(+)

diff -puN drivers/mfd/Kconfig~mfd-pcf50633-gpio-support drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-pcf50633-gpio-support
+++ a/drivers/mfd/Kconfig
@@ -233,6 +233,13 @@ config PCF50633_ADC
 	 Say yes here if you want to include support for ADC in the
 	 NXP PCF50633 chip.
 
+config PCF50633_GPIO
+	tristate "Support for NXP PCF50633 GPIO"
+	depends on MFD_PCF50633
+	help
+	 Say yes here if you want to include support GPIO for pins on
+	 the PCF50633 chip.
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -puN drivers/mfd/Makefile~mfd-pcf50633-gpio-support drivers/mfd/Makefile
--- a/drivers/mfd/Makefile~mfd-pcf50633-gpio-support
+++ a/drivers/mfd/Makefile
@@ -40,3 +40,4 @@ obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o
 obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
+obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
diff -puN /dev/null drivers/mfd/pcf50633-gpio.c
--- /dev/null
+++ a/drivers/mfd/pcf50633-gpio.c
@@ -0,0 +1,118 @@
+/* NXP PCF50633 GPIO Driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ * Broken down from monstrous PCF50633 driver mainly by
+ * Harald Welte, Andy Green and Werner Almesberger
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/mfd/pcf50633/gpio.h>
+
+enum pcf50633_regulator_id {
+	PCF50633_REGULATOR_AUTO,
+	PCF50633_REGULATOR_DOWN1,
+	PCF50633_REGULATOR_DOWN2,
+	PCF50633_REGULATOR_LDO1,
+	PCF50633_REGULATOR_LDO2,
+	PCF50633_REGULATOR_LDO3,
+	PCF50633_REGULATOR_LDO4,
+	PCF50633_REGULATOR_LDO5,
+	PCF50633_REGULATOR_LDO6,
+	PCF50633_REGULATOR_HCLDO,
+	PCF50633_REGULATOR_MEMLDO,
+};
+
+#define PCF50633_REG_AUTOOUT	0x1a
+#define PCF50633_REG_DOWN1OUT	0x1e
+#define PCF50633_REG_DOWN2OUT	0x22
+#define PCF50633_REG_MEMLDOOUT	0x26
+#define PCF50633_REG_LDO1OUT	0x2d
+#define PCF50633_REG_LDO2OUT	0x2f
+#define PCF50633_REG_LDO3OUT	0x31
+#define PCF50633_REG_LDO4OUT	0x33
+#define PCF50633_REG_LDO5OUT	0x35
+#define PCF50633_REG_LDO6OUT	0x37
+#define PCF50633_REG_HCLDOOUT	0x39
+
+static const u8 pcf50633_regulator_registers[PCF50633_NUM_REGULATORS] = {
+	[PCF50633_REGULATOR_AUTO]	= PCF50633_REG_AUTOOUT,
+	[PCF50633_REGULATOR_DOWN1]	= PCF50633_REG_DOWN1OUT,
+	[PCF50633_REGULATOR_DOWN2]	= PCF50633_REG_DOWN2OUT,
+	[PCF50633_REGULATOR_MEMLDO]	= PCF50633_REG_MEMLDOOUT,
+	[PCF50633_REGULATOR_LDO1]	= PCF50633_REG_LDO1OUT,
+	[PCF50633_REGULATOR_LDO2]	= PCF50633_REG_LDO2OUT,
+	[PCF50633_REGULATOR_LDO3]	= PCF50633_REG_LDO3OUT,
+	[PCF50633_REGULATOR_LDO4]	= PCF50633_REG_LDO4OUT,
+	[PCF50633_REGULATOR_LDO5]	= PCF50633_REG_LDO5OUT,
+	[PCF50633_REGULATOR_LDO6]	= PCF50633_REG_LDO6OUT,
+	[PCF50633_REGULATOR_HCLDO]	= PCF50633_REG_HCLDOOUT,
+};
+
+int pcf50633_gpio_set(struct pcf50633 *pcf, int gpio, u8 val)
+{
+	u8 reg;
+
+	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
+
+	return pcf50633_reg_set_bit_mask(pcf, reg, 0x07, val);
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_set);
+
+u8 pcf50633_gpio_get(struct pcf50633 *pcf, int gpio)
+{
+	u8 reg, val;
+
+	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
+	val = pcf50633_reg_read(pcf, reg) & 0x07;
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_get);
+
+int pcf50633_gpio_invert_set(struct pcf50633 *pcf, int gpio, int invert)
+{
+	u8 val, reg;
+
+	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
+	val = !!invert << 3;
+
+	return pcf50633_reg_set_bit_mask(pcf, reg, 1 << 3, val);
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_invert_set);
+
+int pcf50633_gpio_invert_get(struct pcf50633 *pcf, int gpio)
+{
+	u8 reg, val;
+
+	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
+	val = pcf50633_reg_read(pcf, reg);
+
+	return val & (1 << 3);
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_invert_get);
+
+int pcf50633_gpio_power_supply_set(struct pcf50633 *pcf,
+					int gpio, int regulator, int on)
+{
+	u8 reg, val, mask;
+
+	/* the *ENA register is always one after the *OUT register */
+	reg = pcf50633_regulator_registers[regulator] + 1;
+
+	val = !!on << (gpio - PCF50633_GPIO1);
+	mask = 1 << (gpio - PCF50633_GPIO1);
+
+	return pcf50633_reg_set_bit_mask(pcf, reg, mask, val);
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_power_supply_set);
diff -puN /dev/null include/linux/mfd/pcf50633/gpio.h
--- /dev/null
+++ a/include/linux/mfd/pcf50633/gpio.h
@@ -0,0 +1,52 @@
+/*
+ * gpio.h -- GPIO driver for NXP PCF50633
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MFD_PCF50633_GPIO_H
+#define __LINUX_MFD_PCF50633_GPIO_H
+
+#include <linux/mfd/pcf50633/core.h>
+
+#define PCF50633_GPIO1		1
+#define PCF50633_GPIO2		2
+#define PCF50633_GPIO3		3
+#define PCF50633_GPO		4
+
+#define PCF50633_REG_GPIO1CFG	0x14
+#define PCF50633_REG_GPIO2CFG	0x15
+#define PCF50633_REG_GPIO3CFG	0x16
+#define PCF50633_REG_GPOCFG 	0x17
+
+#define PCF50633_GPOCFG_GPOSEL_MASK	0x07
+
+enum pcf50633_reg_gpocfg {
+	PCF50633_GPOCFG_GPOSEL_0	= 0x00,
+	PCF50633_GPOCFG_GPOSEL_LED_NFET	= 0x01,
+	PCF50633_GPOCFG_GPOSEL_SYSxOK	= 0x02,
+	PCF50633_GPOCFG_GPOSEL_CLK32K	= 0x03,
+	PCF50633_GPOCFG_GPOSEL_ADAPUSB	= 0x04,
+	PCF50633_GPOCFG_GPOSEL_USBxOK	= 0x05,
+	PCF50633_GPOCFG_GPOSEL_ACTPH4	= 0x06,
+	PCF50633_GPOCFG_GPOSEL_1	= 0x07,
+	PCF50633_GPOCFG_GPOSEL_INVERSE	= 0x08,
+};
+
+int pcf50633_gpio_set(struct pcf50633 *pcf, int gpio, u8 val);
+u8 pcf50633_gpio_get(struct pcf50633 *pcf, int gpio);
+
+int pcf50633_gpio_invert_set(struct pcf50633 *, int gpio, int invert);
+int pcf50633_gpio_invert_get(struct pcf50633 *pcf, int gpio);
+
+int pcf50633_gpio_power_supply_set(struct pcf50633 *,
+					int gpio, int regulator, int on);
+#endif /* __LINUX_MFD_PCF50633_GPIO_H */
+
+
_

Patches currently in -mm which might be from balajirrao@openmoko.org are

origin.patch
linux-next.patch

