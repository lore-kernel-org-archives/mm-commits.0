From: akpm@linux-foundation.org
Subject: - regulator-ti-bq24022-li-ion-charger-driver.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:48 -0700
Message-ID: <200807141935.m6EJZmdA023954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756731AbYGNTfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, broonie@opensource.wolfsonmicro.com, lg@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     ] regulator: TI bq24022 Li-Ion Charger driver
has been removed from the -mm tree.  Its filename was
     regulator-ti-bq24022-li-ion-charger-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ] regulator: TI bq24022 Li-Ion Charger driver
From: Philipp Zabel <philipp.zabel@gmail.com>

This adds a regulator driver for the TI bq24022 Single-Chip Li-Ion Charger
with its nCE and ISET2 pins connected to GPIOs.

[akpm@linux-foundation.org: fix kerneldoc]
Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/Kconfig         |   10 +
 drivers/regulator/Makefile        |    2 
 drivers/regulator/bq24022.c       |  167 ++++++++++++++++++++++++++++
 include/linux/regulator/bq24022.h |   21 +++
 4 files changed, 200 insertions(+)

diff -puN drivers/regulator/Kconfig~regulator-ti-bq24022-li-ion-charger-driver drivers/regulator/Kconfig
--- a/drivers/regulator/Kconfig~regulator-ti-bq24022-li-ion-charger-driver
+++ a/drivers/regulator/Kconfig
@@ -46,4 +46,14 @@ config REGULATOR_VIRTUAL_CONSUMER
 
           If unsure, say no.
 
+config REGULATOR_BQ24022
+	tristate "TI bq24022 Dual Input 1-Cell Li-Ion Charger IC"
+	default n
+	select REGULATOR
+	help
+	  This driver controls a TI bq24022 Charger attached via
+	  GPIOs. The provided current regulator can enable/disable
+	  charging select between 100 mA and 500 mA charging current
+	  limit.
+
 endmenu
diff -puN drivers/regulator/Makefile~regulator-ti-bq24022-li-ion-charger-driver drivers/regulator/Makefile
--- a/drivers/regulator/Makefile~regulator-ti-bq24022-li-ion-charger-driver
+++ a/drivers/regulator/Makefile
@@ -7,4 +7,6 @@ obj-$(CONFIG_REGULATOR) += core.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 
+obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
+
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff -puN /dev/null drivers/regulator/bq24022.c
--- /dev/null
+++ a/drivers/regulator/bq24022.c
@@ -0,0 +1,167 @@
+/*
+ * Support for TI bq24022 (bqTINY-II) Dual Input (USB/AC Adpater)
+ * 1-Cell Li-Ion Charger connected via GPIOs.
+ *
+ * Copyright (c) 2008 Philipp Zabel
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/regulator/bq24022.h>
+#include <linux/regulator/driver.h>
+
+static int bq24022_set_current_limit(struct regulator_dev *rdev,
+					int min_uA, int max_uA)
+{
+	struct platform_device *pdev = rdev_get_drvdata(rdev);
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+
+	dev_dbg(&pdev->dev, "setting current limit to %s mA\n",
+		max_uA >= 500000 ? "500" : "100");
+
+	/* REVISIT: maybe return error if min_uA != 0 ? */
+	gpio_set_value(pdata->gpio_iset2, max_uA >= 500000);
+	return 0;
+}
+
+static int bq24022_get_current_limit(struct regulator_dev *rdev)
+{
+	struct platform_device *pdev = rdev_get_drvdata(rdev);
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+
+	return gpio_get_value(pdata->gpio_iset2) ? 500000 : 100000;
+}
+
+static int bq24022_enable(struct regulator_dev *rdev)
+{
+	struct platform_device *pdev = rdev_get_drvdata(rdev);
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+
+	dev_dbg(&pdev->dev, "enabling charger\n");
+
+	gpio_set_value(pdata->gpio_nce, 0);
+	return 0;
+}
+
+static int bq24022_disable(struct regulator_dev *rdev)
+{
+	struct platform_device *pdev = rdev_get_drvdata(rdev);
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+
+	dev_dbg(&pdev->dev, "disabling charger\n");
+
+	gpio_set_value(pdata->gpio_nce, 1);
+	return 0;
+}
+
+static int bq24022_is_enabled(struct regulator_dev *rdev)
+{
+	struct platform_device *pdev = rdev_get_drvdata(rdev);
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+
+	return !gpio_get_value(pdata->gpio_nce);
+}
+
+static struct regulator_ops bq24022_ops = {
+	.set_current_limit = bq24022_set_current_limit,
+	.get_current_limit = bq24022_get_current_limit,
+	.enable            = bq24022_enable,
+	.disable           = bq24022_disable,
+	.is_enabled        = bq24022_is_enabled,
+};
+
+static struct regulator_desc bq24022_desc = {
+	.name  = "bq24022",
+	.ops   = &bq24022_ops,
+	.type  = REGULATOR_CURRENT,
+};
+
+static int __init bq24022_probe(struct platform_device *pdev)
+{
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+	struct regulator_dev *bq24022;
+	int ret;
+
+	if (!pdata || !pdata->gpio_nce || !pdata->gpio_iset2)
+		return -EINVAL;
+
+	ret = gpio_request(pdata->gpio_nce, "ncharge_en");
+	if (ret) {
+		dev_dbg(&pdev->dev, "couldn't request nCE GPIO: %d\n",
+			pdata->gpio_nce);
+		goto err_ce;
+	}
+	ret = gpio_request(pdata->gpio_iset2, "charge_mode");
+	if (ret) {
+		dev_dbg(&pdev->dev, "couldn't request ISET2 GPIO: %d\n",
+			pdata->gpio_iset2);
+		goto err_iset2;
+	}
+	ret = gpio_direction_output(pdata->gpio_iset2, 0);
+	ret = gpio_direction_output(pdata->gpio_nce, 1);
+
+	bq24022 = regulator_register(&bq24022_desc, pdev);
+	if (IS_ERR(bq24022)) {
+		dev_dbg(&pdev->dev, "couldn't register regulator\n");
+		ret = PTR_ERR(bq24022);
+		goto err_reg;
+	}
+	platform_set_drvdata(pdev, bq24022);
+	dev_dbg(&pdev->dev, "registered regulator\n");
+
+	return 0;
+err_reg:
+	gpio_free(pdata->gpio_iset2);
+err_iset2:
+	gpio_free(pdata->gpio_nce);
+err_ce:
+	return ret;
+}
+
+static int __devexit bq24022_remove(struct platform_device *pdev)
+{
+	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+	struct regulator_dev *bq24022 = platform_get_drvdata(pdev);
+
+	regulator_unregister(bq24022);
+	gpio_free(pdata->gpio_iset2);
+	gpio_free(pdata->gpio_nce);
+
+	return 0;
+}
+
+static struct platform_driver bq24022_driver = {
+	.driver = {
+		.name = "bq24022",
+	},
+	.remove = __devexit_p(bq24022_remove),
+};
+
+static int __init bq24022_init()
+{
+	platform_driver_probe(&bq24022_driver, bq24022_probe);
+}
+
+static void __exit bq24022_exit()
+{
+	platform_driver_unregister(&bq24022_driver);
+}
+
+/*
+ * make sure this is probed before gpio_vbus and pda_power,
+ * but after asic3 or other GPIO expander drivers.
+ */
+subsys_initcall(bq24022_init);
+module_exit(bq24022_exit);
+
+MODULE_AUTHOR("Philipp Zabel");
+MODULE_DESCRIPTION("TI bq24022 Li-Ion Charger driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/regulator/bq24022.h
--- /dev/null
+++ a/include/linux/regulator/bq24022.h
@@ -0,0 +1,21 @@
+/*
+ * Support for TI bq24022 (bqTINY-II) Dual Input (USB/AC Adpater)
+ * 1-Cell Li-Ion Charger connected via GPIOs.
+ *
+ * Copyright (c) 2008 Philipp Zabel
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+/**
+ * bq24022_mach_info - platform data for bq24022
+ * @gpio_nce: GPIO line connected to the nCE pin, used to enable / disable charging
+ * @gpio_iset2: GPIO line connected to the ISET2 pin, used to limit charging current to 100 mA / 500 mA
+ */
+struct bq24022_mach_info {
+	int gpio_nce;
+	int gpio_iset2;
+};
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

linux-next.patch

