From: akpm@linux-foundation.org
Subject: - regulator-regulator-driver-interface.patch removed from -mm tree
Date: Fri, 30 May 2008 16:08:14 -0700
Message-ID: <200805302308.m4UN8EjS016220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753853AbYE3XIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 19:08:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     regulator: regulator driver interface
has been removed from the -mm tree.  Its filename was
     regulator-regulator-driver-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: regulator driver interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This allows regulator drivers to register their regulators and provide
operations to the core.  It also has a notifier call chain for propagating
regulator events to clients.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/regulator/driver.h |   86 +++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff -puN /dev/null include/linux/regulator/driver.h
--- /dev/null
+++ a/include/linux/regulator/driver.h
@@ -0,0 +1,86 @@
+/*
+ * driver.h -- SoC Regulator driver support.
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
+#ifndef __LINUX_REGULATOR_DRIVER_H_
+#define __LINUX_REGULATOR_DRIVER_H_
+
+#include <linux/device.h>
+#include <linux/regulator/consumer.h>
+
+struct regulator_constraints;
+struct regulator_dev;
+
+/**
+ * struct regulator_ops - regulator operations.
+ *
+ * This struct describes regulator operations.
+ */
+struct regulator_ops {
+
+	/* get/set regulator voltage */
+	int (*set_voltage) (struct regulator_dev *, int min_uV, int max_uV);
+	int (*get_voltage) (struct regulator_dev *);
+
+	/* get/set regulator current  */
+	int (*set_current_limit) (struct regulator_dev *,
+				 int min_uA, int max_uA);
+	int (*get_current_limit) (struct regulator_dev *);
+
+	/* enable/disable regulator */
+	int (*enable) (struct regulator_dev *);
+	int (*disable) (struct regulator_dev *);
+	int (*is_enabled) (struct regulator_dev *);
+
+	/* get/set regulator operating mode (defined in regulator.h) */
+	int (*set_mode) (struct regulator_dev *, unsigned int mode);
+	unsigned int (*get_mode) (struct regulator_dev *);
+
+	/* get most efficient regulator operating mode for load */
+	unsigned int (*get_optimum_mode) (struct regulator_dev *, int input_uV,
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
+struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
+					  void *reg_data);
+void regulator_unregister(struct regulator_dev *rdev);
+
+int regulator_notifier_call_chain(struct regulator_dev *rdev,
+				  unsigned long event, void *data);
+
+void *rdev_get_drvdata(struct regulator_dev *rdev);
+int rdev_get_id(struct regulator_dev *rdev);
+
+#endif
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

linux-next.patch
git-regulator.patch

