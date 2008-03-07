From: akpm@linux-foundation.org
Subject: + regulator-platform-interface.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:40:16 -0800
Message-ID: <200803070840.m278eGDs013447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757292AbYCGIlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 03:41:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com


The patch titled
     regulator: platform interface
has been added to the -mm tree.  Its filename is
     regulator-platform-interface.patch

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
Subject: regulator: platform interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This interface configures a regulator for use within a specific device.  It
allows for the creation of voltage and current domains (with constraints) for
each regulator.  Regulator constraints help prevent device damage by providing
protection for over voltage or over current events caused by buggy client
drivers.

This interface also allows the creation of a regulator tree whereby some
regulators are supplied by others (similar to a clock tree).  This means a
parent regulator will be enabled before it's children are enabled and disabled
after it's children have all been disabled.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/regulator/regulator-platform.h |   76 +++++++++++++++++
 1 file changed, 76 insertions(+)

diff -puN /dev/null include/linux/regulator/regulator-platform.h
--- /dev/null
+++ a/include/linux/regulator/regulator-platform.h
@@ -0,0 +1,76 @@
+/*
+ * regulator-platform.h -- SoC Regulator support, platform driver API.
+ *
+ * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Regulator Platform Interface.
+ */
+
+#ifndef __LINUX_REGULATOR_PLATFORM_H_
+#define __LINUX_REGULATOR_PLATFORM_H_
+
+#include <linux/regulator/regulator.h>
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
+};
+
+int regulator_set_parent(const char *regulator, const char *regulator_parent);
+
+const char *regulator_get_parent(const char *regulator);
+
+int regulator_set_platform_constraints(const char *regulator,
+	struct regulation_constraints *constraints);
+
+#endif
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

regulator-consumer-interface.patch
regulator-regulator-driver-interface.patch
regulator-platform-interface.patch
regulator-framework-core.patch
regulator-sysfs-abi.patch
regulator-kbuild.patch
regulator-maintainers.patch

