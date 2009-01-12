From: akpm@linux-foundation.org
Subject: + regulator-pcf50633-pmic-driver.patch added to -mm tree
Date: Mon, 12 Jan 2009 14:44:55 -0800
Message-ID: <200901122244.n0CMitbo009421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758630AbZALWpe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 17:45:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balajirrao@openmoko.org, andy@openmoko.com, broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk


The patch titled
     regulator: PCF50633 pmic driver
has been added to the -mm tree.  Its filename is
     regulator-pcf50633-pmic-driver.patch

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
Subject: regulator: PCF50633 pmic driver
From: Balaji Rao <balajirrao@openmoko.org>

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/Kconfig              |    7 
 drivers/regulator/Makefile             |    1 
 drivers/regulator/pcf50633-regulator.c |  329 +++++++++++++++++++++++
 include/linux/mfd/pcf50633/pmic.h      |   67 ++++
 4 files changed, 404 insertions(+)

diff -puN drivers/regulator/Kconfig~regulator-pcf50633-pmic-driver drivers/regulator/Kconfig
--- a/drivers/regulator/Kconfig~regulator-pcf50633-pmic-driver
+++ a/drivers/regulator/Kconfig
@@ -73,4 +73,11 @@ config REGULATOR_DA903X
 	  Say y here to support the BUCKs and LDOs regulators found on
 	  Dialog Semiconductor DA9030/DA9034 PMIC.
 
+config REGULATOR_PCF50633
+	tristate "PCF50633 regulator driver"
+        depends on MFD_PCF50633
+	help
+	 Say Y here to support the voltage regulators and convertors
+	 on PCF50633
+
 endif
diff -puN drivers/regulator/Makefile~regulator-pcf50633-pmic-driver drivers/regulator/Makefile
--- a/drivers/regulator/Makefile~regulator-pcf50633-pmic-driver
+++ a/drivers/regulator/Makefile
@@ -11,5 +11,6 @@ obj-$(CONFIG_REGULATOR_BQ24022) += bq240
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
+obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff -puN /dev/null drivers/regulator/pcf50633-regulator.c
--- /dev/null
+++ a/drivers/regulator/pcf50633-regulator.c
@@ -0,0 +1,329 @@
+/* NXP PCF50633 PMIC Driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ * Broken down from monstrous PCF50633 driver mainly by
+ * Harald Welte and Andy Green and Werner Almesberger
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/mfd/pcf50633/pmic.h>
+
+#define PCF50633_REGULATOR(_name, _id) 		\
+	{					\
+		.name = _name, 			\
+		.id = _id,			\
+		.ops = &pcf50633_regulator_ops,	\
+		.type = REGULATOR_VOLTAGE, 	\
+		.owner = THIS_MODULE, 		\
+	}
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
+/* Bits from voltage value */
+static u8 auto_voltage_bits(unsigned int millivolts)
+{
+	if (millivolts < 1800)
+		return 0;
+	if (millivolts > 3800)
+		return 0xff;
+
+	millivolts -= 625;
+
+	return millivolts / 25;
+}
+
+static u8 down_voltage_bits(unsigned int millivolts)
+{
+	if (millivolts < 625)
+		return 0;
+	else if (millivolts > 3000)
+		return 0xff;
+
+	millivolts -= 625;
+
+	return millivolts / 25;
+}
+
+static u8 ldo_voltage_bits(unsigned int millivolts)
+{
+	if (millivolts < 900)
+		return 0;
+	else if (millivolts > 3600)
+		return 0x1f;
+
+	millivolts -= 900;
+	return millivolts / 100;
+}
+
+/* Obtain voltage value from bits */
+static unsigned int auto_voltage_value(u8 bits)
+{
+	if (bits < 0x2f)
+		return 0;
+
+	return 625 + (bits * 25);
+}
+
+
+static unsigned int down_voltage_value(u8 bits)
+{
+	return 625 + (bits * 25);
+}
+
+
+static unsigned int ldo_voltage_value(u8 bits)
+{
+	bits &= 0x1f;
+
+	return 900 + (bits * 100);
+}
+
+static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
+						int min_uV, int max_uV)
+{
+	struct pcf50633 *pcf;
+	int regulator_id, millivolts;
+	u8 volt_bits, regnr;
+
+	pcf = rdev_get_drvdata(rdev);
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= PCF50633_NUM_REGULATORS)
+		return -EINVAL;
+
+	millivolts = min_uV / 1000;
+
+	regnr = pcf50633_regulator_registers[regulator_id];
+
+	switch (regulator_id) {
+	case PCF50633_REGULATOR_AUTO:
+		volt_bits = auto_voltage_bits(millivolts);
+		break;
+	case PCF50633_REGULATOR_DOWN1:
+		volt_bits = down_voltage_bits(millivolts);
+		break;
+	case PCF50633_REGULATOR_DOWN2:
+		volt_bits = down_voltage_bits(millivolts);
+		break;
+	case PCF50633_REGULATOR_LDO1:
+	case PCF50633_REGULATOR_LDO2:
+	case PCF50633_REGULATOR_LDO3:
+	case PCF50633_REGULATOR_LDO4:
+	case PCF50633_REGULATOR_LDO5:
+	case PCF50633_REGULATOR_LDO6:
+	case PCF50633_REGULATOR_HCLDO:
+		volt_bits = ldo_voltage_bits(millivolts);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return pcf50633_reg_write(pcf, regnr, volt_bits);
+}
+
+static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
+{
+	struct pcf50633 *pcf;
+	int regulator_id, millivolts, volt_bits;
+	u8 regnr;
+
+	pcf = rdev_get_drvdata(rdev);;
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= PCF50633_NUM_REGULATORS)
+		return -EINVAL;
+
+	regnr = pcf50633_regulator_registers[regulator_id];
+
+	volt_bits = pcf50633_reg_read(pcf, regnr);
+	if (volt_bits < 0)
+		return -1;
+
+	switch (regulator_id) {
+	case PCF50633_REGULATOR_AUTO:
+		millivolts = auto_voltage_value(volt_bits);
+		break;
+	case PCF50633_REGULATOR_DOWN1:
+		millivolts = down_voltage_value(volt_bits);
+		break;
+	case PCF50633_REGULATOR_DOWN2:
+		millivolts = down_voltage_value(volt_bits);
+		break;
+	case PCF50633_REGULATOR_LDO1:
+	case PCF50633_REGULATOR_LDO2:
+	case PCF50633_REGULATOR_LDO3:
+	case PCF50633_REGULATOR_LDO4:
+	case PCF50633_REGULATOR_LDO5:
+	case PCF50633_REGULATOR_LDO6:
+	case PCF50633_REGULATOR_HCLDO:
+		millivolts = ldo_voltage_value(volt_bits);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return millivolts * 1000;
+}
+
+static int pcf50633_regulator_enable(struct regulator_dev *rdev)
+{
+	struct pcf50633 *pcf = rdev_get_drvdata(rdev);
+	int regulator_id;
+	u8 regnr;
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= PCF50633_NUM_REGULATORS)
+		return -EINVAL;
+
+	/* The *ENA register is always one after the *OUT register */
+	regnr = pcf50633_regulator_registers[regulator_id] + 1;
+
+	return pcf50633_reg_set_bit_mask(pcf, regnr, PCF50633_REGULATOR_ON,
+						       PCF50633_REGULATOR_ON);
+}
+
+static int pcf50633_regulator_disable(struct regulator_dev *rdev)
+{
+	struct pcf50633 *pcf = rdev_get_drvdata(rdev);
+	int regulator_id;
+	u8 regnr;
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= PCF50633_NUM_REGULATORS)
+		return -EINVAL;
+
+	/* the *ENA register is always one after the *OUT register */
+	regnr = pcf50633_regulator_registers[regulator_id] + 1;
+
+	return pcf50633_reg_set_bit_mask(pcf, regnr,
+					PCF50633_REGULATOR_ON, 0);
+}
+
+static int pcf50633_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct pcf50633 *pcf = rdev_get_drvdata(rdev);
+	int regulator_id = rdev_get_id(rdev);
+	u8 regnr;
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= PCF50633_NUM_REGULATORS)
+		return -EINVAL;
+
+	/* the *ENA register is always one after the *OUT register */
+	regnr = pcf50633_regulator_registers[regulator_id] + 1;
+
+	return pcf50633_reg_read(pcf, regnr) & PCF50633_REGULATOR_ON;
+}
+
+static struct regulator_ops pcf50633_regulator_ops = {
+	.set_voltage = pcf50633_regulator_set_voltage,
+	.get_voltage = pcf50633_regulator_get_voltage,
+	.enable = pcf50633_regulator_enable,
+	.disable = pcf50633_regulator_disable,
+	.is_enabled = pcf50633_regulator_is_enabled,
+};
+
+static struct regulator_desc regulators[] = {
+	[PCF50633_REGULATOR_AUTO] =
+		PCF50633_REGULATOR("auto", PCF50633_REGULATOR_AUTO),
+	[PCF50633_REGULATOR_DOWN1] =
+		PCF50633_REGULATOR("down1", PCF50633_REGULATOR_DOWN1),
+	[PCF50633_REGULATOR_DOWN2] =
+		PCF50633_REGULATOR("down2", PCF50633_REGULATOR_DOWN2),
+	[PCF50633_REGULATOR_LDO1] =
+		PCF50633_REGULATOR("ldo1", PCF50633_REGULATOR_LDO1),
+	[PCF50633_REGULATOR_LDO2] =
+		PCF50633_REGULATOR("ldo2", PCF50633_REGULATOR_LDO2),
+	[PCF50633_REGULATOR_LDO3] =
+		PCF50633_REGULATOR("ldo3", PCF50633_REGULATOR_LDO3),
+	[PCF50633_REGULATOR_LDO4] =
+		PCF50633_REGULATOR("ldo4", PCF50633_REGULATOR_LDO4),
+	[PCF50633_REGULATOR_LDO5] =
+		PCF50633_REGULATOR("ldo5", PCF50633_REGULATOR_LDO5),
+	[PCF50633_REGULATOR_LDO6] =
+		PCF50633_REGULATOR("ldo6", PCF50633_REGULATOR_LDO6),
+	[PCF50633_REGULATOR_HCLDO] =
+		PCF50633_REGULATOR("hcldo", PCF50633_REGULATOR_HCLDO),
+	[PCF50633_REGULATOR_MEMLDO] =
+		PCF50633_REGULATOR("memldo", PCF50633_REGULATOR_MEMLDO),
+};
+
+static int __devinit pcf50633_regulator_probe(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev;
+	struct pcf50633 *pcf;
+
+	/* Already set by core driver */
+	pcf = platform_get_drvdata(pdev);
+
+	rdev = regulator_register(&regulators[pdev->id], &pdev->dev, pcf);
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	if (pcf->pdata->regulator_registered)
+		pcf->pdata->regulator_registered(pcf, pdev->id);
+
+	return 0;
+}
+
+static int __devexit pcf50633_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+
+	regulator_unregister(rdev);
+
+	return 0;
+}
+
+static struct platform_driver pcf50633_regulator_driver = {
+	.driver = {
+		.name = "pcf50633-regltr",
+	},
+	.probe = pcf50633_regulator_probe,
+	.remove = __devexit_p(pcf50633_regulator_remove),
+};
+
+static int __init pcf50633_regulator_init(void)
+{
+	return platform_driver_register(&pcf50633_regulator_driver);
+}
+module_init(pcf50633_regulator_init);
+
+static void __exit pcf50633_regulator_exit(void)
+{
+	platform_driver_unregister(&pcf50633_regulator_driver);
+}
+module_exit(pcf50633_regulator_exit);
+
+MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
+MODULE_DESCRIPTION("PCF50633 regulator driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pcf50633-regulator");
diff -puN /dev/null include/linux/mfd/pcf50633/pmic.h
--- /dev/null
+++ a/include/linux/mfd/pcf50633/pmic.h
@@ -0,0 +1,67 @@
+#ifndef __LINUX_MFD_PCF50633_PMIC_H
+#define __LINUX_MFD_PCF50633_PMIC_H
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/platform_device.h>
+
+#define PCF50633_REG_AUTOOUT	0x1a
+#define PCF50633_REG_AUTOENA	0x1b
+#define PCF50633_REG_AUTOCTL	0x1c
+#define PCF50633_REG_AUTOMXC	0x1d
+#define PCF50633_REG_DOWN1OUT	0x1e
+#define PCF50633_REG_DOWN1ENA	0x1f
+#define PCF50633_REG_DOWN1CTL	0x20
+#define PCF50633_REG_DOWN1MXC	0x21
+#define PCF50633_REG_DOWN2OUT	0x22
+#define PCF50633_REG_DOWN2ENA	0x23
+#define PCF50633_REG_DOWN2CTL	0x24
+#define PCF50633_REG_DOWN2MXC	0x25
+#define PCF50633_REG_MEMLDOOUT	0x26
+#define PCF50633_REG_MEMLDOENA	0x27
+#define PCF50633_REG_LDO1OUT	0x2d
+#define PCF50633_REG_LDO1ENA	0x2e
+#define PCF50633_REG_LDO2OUT	0x2f
+#define PCF50633_REG_LDO2ENA	0x30
+#define PCF50633_REG_LDO3OUT	0x31
+#define PCF50633_REG_LDO3ENA	0x32
+#define PCF50633_REG_LDO4OUT	0x33
+#define PCF50633_REG_LDO4ENA	0x34
+#define PCF50633_REG_LDO5OUT	0x35
+#define PCF50633_REG_LDO5ENA	0x36
+#define PCF50633_REG_LDO6OUT	0x37
+#define PCF50633_REG_LDO6ENA	0x38
+#define PCF50633_REG_HCLDOOUT	0x39
+#define PCF50633_REG_HCLDOENA	0x3a
+#define PCF50633_REG_HCLDOOVL	0x40
+
+enum pcf50633_regulator_enable {
+	PCF50633_REGULATOR_ON		= 0x01,
+	PCF50633_REGULATOR_ON_GPIO1	= 0x02,
+	PCF50633_REGULATOR_ON_GPIO2	= 0x04,
+	PCF50633_REGULATOR_ON_GPIO3	= 0x08,
+};
+#define PCF50633_REGULATOR_ON_MASK	0x0f
+
+enum pcf50633_regulator_phase {
+	PCF50633_REGULATOR_ACTPH1	= 0x00,
+	PCF50633_REGULATOR_ACTPH2	= 0x10,
+	PCF50633_REGULATOR_ACTPH3	= 0x20,
+	PCF50633_REGULATOR_ACTPH4	= 0x30,
+};
+#define PCF50633_REGULATOR_ACTPH_MASK	0x30
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
+#endif
+
_

Patches currently in -mm which might be from balajirrao@openmoko.org are

mfd-pcf50633-core-driver.patch
mfd-pcf50633-adc-driver.patch
mfd-pcf50633-gpio-support.patch
rtc-pcf50633-rtc-driver.patch
power_supply-pcf50633-battery-charger-driver.patch
input-pcf50633-input-driver.patch
regulator-pcf50633-pmic-driver.patch

