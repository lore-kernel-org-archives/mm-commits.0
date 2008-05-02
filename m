From: akpm@linux-foundation.org
Subject: + regulator-consumer-device-interface.patch added to -mm tree
Date: Fri, 02 May 2008 16:57:32 -0700
Message-ID: <200805022357.m42NvXkm021805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758723AbYEBX5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 19:57:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, greg@kroah.com


The patch titled
     regulator: consumer device interface
has been added to the -mm tree.  Its filename is
     regulator-consumer-device-interface.patch

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
Subject: regulator: consumer device interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

The regulator framework is designed to provide a standard kernel interface to
control voltage and current regulators on SoC based systems.

The intention is to allow systems to dynamically control regulator power
output in order to save power and prolong battery life.  This applies to both
voltage regulators (where voltage output is controllable) and current sinks
(where current limit is controllable).



This patch:

Adds support to allow consumer device drivers to control their regulator power
supply.

This uses a similar API to the kernel clock interface in that consumer drivers
can get and put a regulator (like they can with clocks atm) and get/set
voltage, current limit, mode, enable and disable.  This should allow consumers
complete control over their supply voltage and current limit.  This also
compiles out if not in use so drivers can be reused in systems with no
regulator based power control.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/regulator/consumer.h |  284 +++++++++++++++++++++++++++
 1 file changed, 284 insertions(+)

diff -puN /dev/null include/linux/regulator/consumer.h
--- /dev/null
+++ a/include/linux/regulator/consumer.h
@@ -0,0 +1,284 @@
+/*
+ * consumer.h -- SoC Regulator consumer support.
+ *
+ * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Regulator Consumer Interface.
+ *
+ * A Power Management Regulator framework for SoC based devices.
+ * Features:-
+ *   o Voltage and current level control.
+ *   o Operating mode control.
+ *   o Regulator status.
+ *   o sysfs entries for showing client devices and status
+ *
+ * EXPERIMENTAL FEATURES:
+ *   Dynamic Regulator operating Mode Switching (DRMS) - allows regulators
+ *   to use most efficient operating mode depending upon voltage and load and
+ *   is transparent to client drivers.
+ *
+ *   e.g. Devices x,y,z share regulator r. Device x and y draw 20mA each during
+ *   IO and 1mA at idle. Device z draws 100mA when under load and 5mA when
+ *   idling. Regulator r has > 90% efficiency in NORMAL mode at loads > 100mA
+ *   but this drops rapidly to 60% when below 100mA. Regulator r has > 90%
+ *   efficiency in IDLE mode at loads < 10mA. Thus regulator r will operate
+ *   in normal mode for loads > 10mA and in IDLE mode for load <= 10mA.
+ *
+ */
+
+#ifndef __LINUX_REGULATOR_CONSUMER_H_
+#define __LINUX_REGULATOR_CONSUMER_H_
+
+/*
+ * Regulator operating modes.
+ *
+ * Regulators can run in a variety of different operating modes depending on
+ * output load. This allows further system power savings by selecting the
+ * best (and most efficient) regulator mode for a desired load.
+ *
+ * Most drivers will only care about NORMAL. The modes below are generic and
+ * will probably not match the naming convention of your regulator data sheet
+ * but should match the use cases in the datasheet.
+ *
+ * In order of power efficiency (least efficient at top).
+ *
+ *  Mode       Description
+ *  FAST       Regulator can handle fast changes in it's load.
+ *             e.g. useful in CPU voltage & frequency scaling where
+ *             load can quickly increase with CPU frequency increases.
+ *
+ *  NORMAL     Normal regulator power supply mode. Most drivers will
+ *             use this mode.
+ *
+ *  IDLE       Regulator runs in a more efficient mode for light
+ *             loads. Can be used for devices that have a low power
+ *             requirement during periods of inactivity. This mode
+ *             may be more noisy than NORMAL and may not be able
+ *             to handle fast load switching.
+ *
+ *  STANDBY    Regulator runs in the most efficient mode for very
+ *             light loads. Can be used by devices when they are
+ *             in a sleep/standby state. This mode is likely to be
+ *             the most noisy and may not be able to handle fast load
+ *             switching.
+ *
+ * NOTE: Most regulators will only support a subset of these modes. Some
+ * will only just support NORMAL.
+ *
+ * These modes can be OR'ed together to make up a mask of valid register modes.
+ */
+
+#define REGULATOR_MODE_FAST			0x1
+#define REGULATOR_MODE_NORMAL			0x2
+#define REGULATOR_MODE_IDLE			0x4
+#define REGULATOR_MODE_STANDBY			0x8
+
+/*
+ * Regulator notifier events.
+ *
+ * UNDER_VOLTAGE  Regulator output is under voltage.
+ * OVER_CURRENT   Regulator output current is too high.
+ * REGULATION_OUT Regulator output is out of regulation.
+ * FAIL           Regulator output has failed.
+ * OVER_TEMP      Regulator over temp.
+ * FORCE_DISABLE  Regulator shut down by software.
+ *
+ * NOTE: These events can be OR'ed together when passed into handler.
+ */
+
+#define REGULATOR_EVENT_UNDER_VOLTAGE		0x01
+#define REGULATOR_EVENT_OVER_CURRENT		0x02
+#define REGULATOR_EVENT_REGULATION_OUT		0x04
+#define REGULATOR_EVENT_FAIL			0x08
+#define REGULATOR_EVENT_OVER_TEMP		0x10
+#define REGULATOR_EVENT_FORCE_DISABLE		0x20
+
+struct regulator;
+
+/**
+ * struct regulator_bulk_data - Data used for bulk regulator operations.
+ *
+ * @supply   The name of the supply.  Initialised by the user before
+ *           using the bulk regulator APIs.
+ * @consumer The regulator consumer for the supply.  This will be managed
+ *           by the bulk API.
+ *
+ * The regulator APIs provide a series of regulator_bulk_() API calls as
+ * a convenience to consumers which require multiple supplies.  This
+ * structure is used to manage data for these calls.
+ */
+struct regulator_bulk_data {
+	const char *supply;
+	struct regulator *consumer;
+};
+
+#if defined(CONFIG_REGULATOR)
+
+/* regulator get and put */
+struct regulator *__must_check regulator_get(struct device *dev,
+					     const char *id);
+void regulator_put(struct regulator *regulator);
+
+/* regulator output control and status */
+int regulator_enable(struct regulator *regulator);
+int regulator_disable(struct regulator *regulator);
+int regulator_force_disable(struct regulator *regulator);
+int regulator_is_enabled(struct regulator *regulator);
+
+int regulator_bulk_get(struct device *dev, int num_consumers,
+		       struct regulator_bulk_data *consumers);
+int regulator_bulk_enable(int num_consumers,
+			  struct regulator_bulk_data *consumers);
+int regulator_bulk_disable(int num_consumers,
+			   struct regulator_bulk_data *consumers);
+void regulator_bulk_free(int num_consumers,
+			 struct regulator_bulk_data *consumers);
+
+int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV);
+int regulator_get_voltage(struct regulator *regulator);
+int regulator_set_current_limit(struct regulator *regulator,
+			       int min_uA, int max_uA);
+int regulator_get_current_limit(struct regulator *regulator);
+
+int regulator_set_mode(struct regulator *regulator, unsigned int mode);
+unsigned int regulator_get_mode(struct regulator *regulator);
+int regulator_set_optimum_mode(struct regulator *regulator, int load_uA);
+
+/* regulator notifier block */
+int regulator_register_notifier(struct regulator *regulator,
+			      struct notifier_block *nb);
+int regulator_unregister_notifier(struct regulator *regulator,
+				struct notifier_block *nb);
+
+/* driver data - core doesn't touch */
+void *regulator_get_drvdata(struct regulator *regulator);
+void regulator_set_drvdata(struct regulator *regulator, void *data);
+
+#else
+
+/*
+ * Make sure client drivers will still build on systems with no software
+ * controllable voltage or current regulators.
+ */
+static inline struct regulator *__must_check regulator_get(struct device *dev,
+	const char *id)
+{
+	/* Nothing except the stubbed out regulator API should be
+	 * looking at the value except to check if it is an error
+	 * value so the actual return value doesn't matter.
+	 */
+	return (struct regulator *)id;
+}
+static inline void regulator_put(struct regulator *regulator)
+{
+}
+
+static inline int regulator_enable(struct regulator *regulator)
+{
+	return 0;
+}
+
+static inline int regulator_disable(struct regulator *regulator)
+{
+	return 0;
+}
+
+static inline int regulator_is_enabled(struct regulator *regulator)
+{
+	return 1;
+}
+
+static inline int regulator_bulk_get(struct device *dev,
+				     int num_consumers,
+				     struct regulator_bulk_data *consumers)
+{
+	return 0;
+}
+
+static inline int regulator_bulk_enable(int num_consumers,
+					struct regulator_bulk_data *consumers)
+{
+	return 0;
+}
+
+static inline int regulator_bulk_disable(int num_consumers,
+					 struct regulator_bulk_data *consumers)
+{
+	return 0;
+}
+
+static inline void regulator_bulk_free(int num_consumers,
+				       struct regulator_bulk_data *consumers)
+{
+}
+
+static inline int regulator_set_voltage(struct regulator *regulator,
+					int min_uV, int max_uV)
+{
+	return 0;
+}
+
+static inline int regulator_get_voltage(struct regulator *regulator)
+{
+	return 0;
+}
+
+static inline int regulator_set_current_limit(struct regulator *regulator,
+					     int min_uA, int max_uA)
+{
+	return 0;
+}
+
+static inline int regulator_get_current_limit(struct regulator *regulator)
+{
+	return 0;
+}
+
+static inline int regulator_set_mode(struct regulator *regulator,
+	unsigned int mode)
+{
+	return 0;
+}
+
+static inline unsigned int regulator_get_mode(struct regulator *regulator)
+{
+	return REGULATOR_MODE_NORMAL;
+}
+
+static inline int regulator_set_optimum_mode(struct regulator *regulator,
+					int load_uA)
+{
+	return REGULATOR_MODE_NORMAL;
+}
+
+static inline int regulator_register_notifier(struct regulator *regulator,
+			      struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int regulator_unregister_notifier(struct regulator *regulator,
+				struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline void *regulator_get_drvdata(struct regulator *regulator)
+{
+	return NULL;
+}
+
+static inline void regulator_set_drvdata(struct regulator *regulator,
+	void *data)
+{
+}
+
+#endif
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

