From: akpm@linux-foundation.org
Subject: - regulator-add-support-for-fixed-regulators.patch removed from -mm tree
Date: Fri, 30 May 2008 16:07:48 -0700
Message-ID: <200805302307.m4UN7nqS016115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752925AbYE3XH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 19:07:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     regulator: add support for fixed regulators.
has been removed from the -mm tree.  Its filename was
     regulator-add-support-for-fixed-regulators.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: add support for fixed regulators.
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This adds supports for regulators that are not software controllable.  It
allows them to coexist in systems with mixed supplies.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/fixed.c |  129 ++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff -puN /dev/null drivers/regulator/fixed.c
--- /dev/null
+++ a/drivers/regulator/fixed.c
@@ -0,0 +1,129 @@
+/*
+ * reg-fixed-voltage.c
+ *
+ * Copyright 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This is useful for systems with mixed controllable and
+ * non-controllable regulators, as well as for allowing testing on
+ * systems with no controllable regulators.
+ */
+
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/regulator-drv.h>
+#include <linux/regulator/fixed-voltage.h>
+
+struct fixed_voltage_data {
+	struct regulator_desc desc;
+	struct regulator_dev *dev;
+	int microvolts;
+};
+
+static int fixed_voltage_is_enabled(struct regulator_dev *dev)
+{
+	return 1;
+}
+
+static int fixed_voltage_enable(struct regulator_dev *dev)
+{
+	return 0;
+}
+
+static int fixed_voltage_get_voltage(struct regulator_dev *dev)
+{
+	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
+
+	return data->microvolts;
+}
+
+static struct regulator_ops fixed_voltage_ops = {
+	.is_enabled = fixed_voltage_is_enabled,
+	.enable = fixed_voltage_enable,
+	.get_voltage = fixed_voltage_get_voltage,
+};
+
+static int regulator_fixed_voltage_probe(struct platform_device *pdev)
+{
+	struct fixed_voltage_config *config = pdev->dev.platform_data;
+	struct fixed_voltage_data *drvdata;
+	int ret;
+
+	drvdata = kzalloc(sizeof(struct fixed_voltage_data), GFP_KERNEL);
+	if (drvdata == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
+	if (drvdata->desc.name == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	drvdata->desc.type = REGULATOR_VOLTAGE;
+	drvdata->desc.owner = THIS_MODULE;
+	drvdata->desc.ops = &fixed_voltage_ops,
+
+	drvdata->microvolts = config->microvolts;
+
+	drvdata->dev = regulator_register(&drvdata->desc, drvdata);
+	if (IS_ERR(drvdata->dev)) {
+		ret = PTR_ERR(drvdata->dev);
+		goto err_name;
+	}
+
+	platform_set_drvdata(pdev, drvdata);
+
+	dev_dbg(&pdev->dev, "%s supplying %duV\n", drvdata->desc.name,
+		drvdata->microvolts);
+
+	return 0;
+
+err_name:
+	kfree(drvdata->desc.name);
+err:
+	kfree(drvdata);
+	return ret;
+}
+
+static int regulator_fixed_voltage_remove(struct platform_device *pdev)
+{
+	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
+
+	regulator_unregister(drvdata->dev);
+	kfree(drvdata->desc.name);
+	kfree(drvdata);
+
+	return 0;
+}
+
+static struct platform_driver regulator_fixed_voltage_driver = {
+	.probe		= regulator_fixed_voltage_probe,
+	.remove		= regulator_fixed_voltage_remove,
+	.driver		= {
+		.name		= "reg-fixed-voltage",
+	},
+};
+
+static int __init regulator_fixed_voltage_init(void)
+{
+	return platform_driver_register(&regulator_fixed_voltage_driver);
+}
+module_init(regulator_fixed_voltage_init);
+
+static void __exit regulator_fixed_voltage_exit(void)
+{
+	platform_driver_unregister(&regulator_fixed_voltage_driver);
+}
+module_exit(regulator_fixed_voltage_exit);
+
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("Fixed voltage regulator");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

linux-next.patch
git-regulator.patch

