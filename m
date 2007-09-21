From: akpm@linux-foundation.org
Subject: + acpi-suspend-consolidate-handling-of-sx-states.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:32:14 -0700
Message-ID: <200709210732.l8L7WEAx024688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51399 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392AbXIUHdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:33:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikovskiy@suse.de, akpm@linux-foundation.org, lenb@kernel.org, rjw@sisk.pl


The patch titled
     ACPI: suspend: consolidate handling of Sx states.
has been added to the -mm tree.  Its filename is
     acpi-suspend-consolidate-handling-of-sx-states.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: suspend: consolidate handling of Sx states.
From: Alexey Starikovskiy <astarikovskiy@suse.de>

Recent changes to sleep initialization in ACPI dropped reporting of
supported Sx states above S3.  Fix that and also move S5 init into same
file as other Sx.  The only functional change is adding printk() for S4 and
S5 cases.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/Makefile   |    2 
 drivers/acpi/sleep/main.c     |   53 ++++++++++++++++++++--
 drivers/acpi/sleep/poweroff.c |   75 --------------------------------
 3 files changed, 49 insertions(+), 81 deletions(-)

diff -puN drivers/acpi/sleep/main.c~acpi-suspend-consolidate-handling-of-sx-states drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-suspend-consolidate-handling-of-sx-states
+++ a/drivers/acpi/sleep/main.c
@@ -15,6 +15,9 @@
 #include <linux/dmi.h>
 #include <linux/device.h>
 #include <linux/suspend.h>
+
+#include <asm/io.h>
+
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include "sleep.h"
@@ -57,6 +60,27 @@ static int acpi_pm_set_target(suspend_st
 	return error;
 }
 
+int acpi_sleep_prepare(u32 acpi_state)
+{
+#ifdef CONFIG_ACPI_SLEEP
+	/* do we have a wakeup address for S2 and S3? */
+	if (acpi_state == ACPI_STATE_S3) {
+		if (!acpi_wakeup_address) {
+			return -EFAULT;
+		}
+		acpi_set_firmware_waking_vector((acpi_physical_address)
+						virt_to_phys((void *)
+							     acpi_wakeup_address));
+
+	}
+	ACPI_FLUSH_CPU_CACHE();
+	acpi_enable_wakeup_device_prep(acpi_state);
+#endif
+	acpi_gpe_sleep_prepare(acpi_state);
+	acpi_enter_sleep_state_prep(acpi_state);
+	return 0;
+}
+
 /**
  *	acpi_pm_prepare - Do preliminary suspend work.
  *	@pm_state: ignored
@@ -355,6 +379,20 @@ int acpi_pm_device_sleep_state(struct de
 	return d_max;
 }
 
+static void acpi_power_off_prepare(void)
+{
+	/* Prepare to power off the system */
+	acpi_sleep_prepare(ACPI_STATE_S5);
+}
+
+static void acpi_power_off(void)
+{
+	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
+	printk("%s called\n", __FUNCTION__);
+	local_irq_disable();
+	acpi_enter_sleep_state(ACPI_STATE_S5);
+}
+
 int __init acpi_sleep_init(void)
 {
 	acpi_status status;
@@ -368,8 +406,8 @@ int __init acpi_sleep_init(void)
 	if (acpi_disabled)
 		return 0;
 
+printk(KERN_INFO PREFIX "(supports");
 #ifdef CONFIG_SUSPEND
-	printk(KERN_INFO PREFIX "(supports");
 	for (i = ACPI_STATE_S0; i < ACPI_STATE_S4; i++) {
 		status = acpi_get_sleep_type_data(i, &type_a, &type_b);
 		if (ACPI_SUCCESS(status)) {
@@ -377,7 +415,6 @@ int __init acpi_sleep_init(void)
 			printk(" S%d", i);
 		}
 	}
-	printk(")\n");
 
 	pm_set_ops(&acpi_pm_ops);
 #endif
@@ -387,10 +424,16 @@ int __init acpi_sleep_init(void)
 	if (ACPI_SUCCESS(status)) {
 		hibernation_set_ops(&acpi_hibernation_ops);
 		sleep_states[ACPI_STATE_S4] = 1;
+		printk(" S4");
 	}
-#else
-	sleep_states[ACPI_STATE_S4] = 0;
 #endif
-
+	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
+	if (ACPI_SUCCESS(status)) {
+		sleep_states[ACPI_STATE_S5] = 1;
+		printk(" S5");
+		pm_power_off_prepare = acpi_power_off_prepare;
+		pm_power_off = acpi_power_off;
+	}
+	printk(")\n");
 	return 0;
 }
diff -puN drivers/acpi/sleep/Makefile~acpi-suspend-consolidate-handling-of-sx-states drivers/acpi/sleep/Makefile
--- a/drivers/acpi/sleep/Makefile~acpi-suspend-consolidate-handling-of-sx-states
+++ a/drivers/acpi/sleep/Makefile
@@ -1,4 +1,4 @@
-obj-y					:= poweroff.o wakeup.o
+obj-y					:= wakeup.o
 obj-$(CONFIG_ACPI_SLEEP)		+= main.o
 obj-$(CONFIG_ACPI_SLEEP)		+= proc.o
 
diff -puN drivers/acpi/sleep/poweroff.c~acpi-suspend-consolidate-handling-of-sx-states /dev/null
--- a/drivers/acpi/sleep/poweroff.c
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * poweroff.c - ACPI handler for powering off the system.
- *
- * AKA S5, but it is independent of whether or not the kernel supports
- * any other sleep support in the system.
- *
- * Copyright (c) 2005 Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
- *
- * This file is released under the GPLv2.
- */
-
-#include <linux/pm.h>
-#include <linux/init.h>
-#include <acpi/acpi_bus.h>
-#include <linux/sysdev.h>
-#include <asm/io.h>
-#include "sleep.h"
-
-int acpi_sleep_prepare(u32 acpi_state)
-{
-#ifdef CONFIG_ACPI_SLEEP
-	/* do we have a wakeup address for S2 and S3? */
-	if (acpi_state == ACPI_STATE_S3) {
-		if (!acpi_wakeup_address) {
-			return -EFAULT;
-		}
-		acpi_set_firmware_waking_vector((acpi_physical_address)
-						virt_to_phys((void *)
-							     acpi_wakeup_address));
-
-	}
-	ACPI_FLUSH_CPU_CACHE();
-	acpi_enable_wakeup_device_prep(acpi_state);
-#endif
-	acpi_gpe_sleep_prepare(acpi_state);
-	acpi_enter_sleep_state_prep(acpi_state);
-	return 0;
-}
-
-#ifdef CONFIG_PM
-
-static void acpi_power_off_prepare(void)
-{
-	/* Prepare to power off the system */
-	acpi_sleep_prepare(ACPI_STATE_S5);
-}
-
-static void acpi_power_off(void)
-{
-	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
-	printk("%s called\n", __FUNCTION__);
-	local_irq_disable();
-	/* Some SMP machines only can poweroff in boot CPU */
-	acpi_enter_sleep_state(ACPI_STATE_S5);
-}
-
-static int acpi_poweroff_init(void)
-{
-	if (!acpi_disabled) {
-		u8 type_a, type_b;
-		acpi_status status;
-
-		status =
-		    acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
-		if (ACPI_SUCCESS(status)) {
-			pm_power_off_prepare = acpi_power_off_prepare;
-			pm_power_off = acpi_power_off;
-		}
-	}
-	return 0;
-}
-
-late_initcall(acpi_poweroff_init);
-
-#endif				/* CONFIG_PM */
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

git-acpi.patch
acpi-suspend-consolidate-handling-of-sx-states.patch
