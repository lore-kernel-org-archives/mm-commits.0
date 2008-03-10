From: akpm@linux-foundation.org
Subject: - regulator-regulator-driver-interface.patch removed from -mm tree
Date: Mon, 10 Mar 2008 12:37:39 -0700
Message-ID: <200803101937.m2AJbd8R001896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbYCJTiA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:38:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     regulator: regulator driver interface
has been removed from the -mm tree.  Its filename was
     regulator-regulator-driver-interface.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: regulator driver interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This interface allows regulator drivers to register their voltage and current
regulators with the core.  It also has a notifier call chain for propagating
regulator events to clients.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/regulator/regulator-drv.h |   85 ++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff -puN /dev/null include/linux/regulator/regulator-drv.h
--- /dev/null
+++ a/include/linux/regulator/regulator-drv.h
@@ -0,0 +1,85 @@
+/*
+ * regulator-drv.h -- SoC Regulator support.
+ *
+ * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Regulator Driver Interface.
+ */
+
+#ifndef __LINUX_REGULATOR_DRV_H_
+#define __LINUX_REGULATOR_DRV_H_
+
+#include <linux/device.h>
+#include <linux/regulator/regulator.h>
+
+struct regulator_constraints;
+struct regulator_cdev;
+
+/**
+ * struct regulator_ops - regulator operations.
+ *
+ * This struct describes regulator operations.
+ */
+struct regulator_ops {
+
+	/* get/set regulator voltage */
+	int (*set_voltage) (struct regulator_cdev *, int uV);
+	int (*get_voltage) (struct regulator_cdev *);
+
+	/* get/set regulator current  */
+	int (*set_current) (struct regulator_cdev *, int uA);
+	int (*get_current) (struct regulator_cdev *);
+
+	/* enable/disable regulator */
+	int (*enable) (struct regulator_cdev *);
+	int (*disable) (struct regulator_cdev *);
+	int (*is_enabled) (struct regulator_cdev *);
+
+	/* get/set regulator operating mode (defined in regulator.h) */
+	int (*set_mode) (struct regulator_cdev *, unsigned int mode);
+	unsigned int (*get_mode) (struct regulator_cdev *);
+
+	/* get most efficient regulator operating mode for load */
+	unsigned int (*get_optimum_mode) (struct regulator_cdev *, int input_uV,
+					  int output_uV, int load_uA);
+};
+
+/*
+ * Regulators can either control voltage or current.
+ */
+enum regulator_type {
+	REGULATOR_VOLTAGE,
+	REGULATOR_CURRENT,
+};
+
+/**
+ * struct regulator_desc - Regulator descriptor
+ *
+ */
+struct regulator_desc {
+	const char *name;
+	int id;
+	struct regulator_ops *ops;
+	int irq;
+	enum regulator_type type;
+	struct module *owner;
+};
+
+
+struct regulator_cdev *regulator_register(struct regulator_desc *regulator_desc,
+					  void *reg_data);
+void regulator_unregister(struct regulator_cdev *rcdev);
+
+int regulator_notifier_call_chain(struct regulator_cdev *rcdev,
+				  unsigned long event, void *data);
+
+void *rcdev_get_drvdata(struct regulator_cdev *rcdev);
+int rcdev_get_id(struct regulator_cdev *rcdev);
+
+#endif
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

regulator-regulator-driver-interface.patch
regulator-regulator-driver-interface-fix.patch
regulator-platform-interface.patch
regulator-framework-core.patch
regulator-framework-core-fix.patch
regulator-sysfs-abi.patch
regulator-kbuild.patch
regulator-maintainers.patch

