From: akpm@linux-foundation.org
Subject: + regulator-machine-driver-interface.patch added to -mm tree
Date: Fri, 02 May 2008 16:57:37 -0700
Message-ID: <200805022357.m42NvbLO021813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934520AbYEBX5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 19:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, greg@kroah.com


The patch titled
     regulator: machine driver interface
has been added to the -mm tree.  Its filename is
     regulator-machine-driver-interface.patch

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
Subject: regulator: machine driver interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This interface is for machine specific code and allows the creation of
voltage/current domains (with constraints) for each regulator.  It can provide
regulator constraints that will prevent device damage through over voltage or
over current caused by buggy client drivers.  It also allows the creation of a
regulator tree whereby some regulators are supplied by others (similar to a
clock tree).

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/regulator/machine.h |   84 ++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff -puN /dev/null include/linux/regulator/machine.h
--- /dev/null
+++ a/include/linux/regulator/machine.h
@@ -0,0 +1,84 @@
+/*
+ * machine.h -- SoC Regulator support, machine/board driver API.
+ *
+ * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Regulator Machine/Board Interface.
+ */
+
+#ifndef __LINUX_REGULATOR_MACHINE_H_
+#define __LINUX_REGULATOR_MACHINE_H_
+
+#include <linux/regulator/consumer.h>
+
+struct regulator;
+
+/*
+ * Regulator operation constraint flags. These flags are used to enable
+ * certain regulator operations and can be OR'ed together.
+ *
+ * VOLTAGE:  Regulator output voltage can be changed by software on this
+ *           board/machine.
+ * CURRENT:  Regulator output current can be changed by software on this
+ *           board machine.
+ * MODE:     Regulator operating mode can be changed by software on this
+ *           board machine.
+ * STATUS:   Regulator can be enabled and disabled.
+ * DRMS:     Dynamic Regulator Mode Switching is enabled for this regulator.
+ */
+
+#define REGULATOR_CHANGE_VOLTAGE	0x1
+#define REGULATOR_CHANGE_CURRENT	0x2
+#define REGULATOR_CHANGE_MODE		0x4
+#define REGULATOR_CHANGE_STATUS		0x8
+#define REGULATOR_CHANGE_DRMS		0x10
+
+/**
+ * struct regulation_constraints - regulator operating constraints.
+ *
+ * This struct describes regulator and board/machine specific constraints.
+ */
+struct regulation_constraints {
+
+	char *name;
+
+	/* voltage output range (inclusive) - for voltage control */
+	int min_uV;
+	int max_uV;
+
+	/* current output range (inclusive) - for current control */
+	int min_uA;
+	int max_uA;
+
+	/* valid regulator operating modes for this machine */
+	unsigned int valid_modes_mask;
+
+	/* valid operations for regulator on this machine */
+	unsigned int valid_ops_mask;
+
+	/* regulator input voltage - only if supply is another regulator */
+	int input_uV;
+
+	/* constriant flags */
+	u32 always_on:1;	/* regulator never off when system is on */
+	u32 boot_on:1;		/* bootloader/firmware enabled regulator */
+	u32 apply_uV:1;		/* apply uV constraint iff min == max */
+};
+
+int regulator_set_supply(const char *regulator, const char *regulator_supply);
+
+const char *regulator_get_supply(const char *regulator);
+
+int regulator_set_machine_constraints(const char *regulator,
+	struct regulation_constraints *constraints);
+
+int regulator_set_device_supply(const char *regulator, struct device *dev,
+				const char *supply);
+
+#endif
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

regulator-consumer-device-interface.patch
regulator-regulator-driver-interface.patch
regulator-machine-driver-interface.patch
regulator-fixed-regulator-interface.patch
regulator-regulator-framework-core.patch
regulator-add-support-for-fixed-regulators.patch
regulator-regulator-test-harness.patch
regulator-core-kbuild-files.patch
regulator-documentation-overview.patch
regulator-documentation-consumer-interface.patch
regulator-documentation-regulator-driver.patch
regulator-documentation-machine.patch
regulator-documentation-abi.patch

