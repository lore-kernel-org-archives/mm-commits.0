From: akpm@linux-foundation.org
Subject: - allow-early-access-to-the-power-management-timer.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:14:38 -0800
Message-ID: <200702170714.l1H7EcSc021539@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946440AbXBQHSR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:18:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Allow early access to the power management timer
has been removed from the -mm tree.  Its filename was
     allow-early-access-to-the-power-management-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Allow early access to the power management timer
From: Thomas Gleixner <tglx@linutronix.de>

Allow early access to the power management timer by exposing the verified read
function and providing a helper function which checks the pmtmr_ioport
variable and returns either the pm timer readout or 0 in case the pm timer is
not available.

Create a new header file and replace also the ifdef'ed extern definition in
arch/i386/kernel/acpi/boot.c

This is a preperatory patch for the rework of the local apic timer
calibration.

No functional changes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/boot.c  |    5 ----
 drivers/clocksource/acpi_pm.c |   17 +++++++-------
 include/linux/acpi_pmtmr.h    |   38 ++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 12 deletions(-)

diff -puN arch/i386/kernel/acpi/boot.c~allow-early-access-to-the-power-management-timer arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~allow-early-access-to-the-power-management-timer
+++ a/arch/i386/kernel/acpi/boot.c
@@ -25,6 +25,7 @@
 
 #include <linux/init.h>
 #include <linux/acpi.h>
+#include <linux/acpi_pmtmr.h>
 #include <linux/efi.h>
 #include <linux/cpumask.h>
 #include <linux/module.h>
@@ -676,10 +677,6 @@ static int __init acpi_parse_hpet(struct
 #define	acpi_parse_hpet	NULL
 #endif
 
-#ifdef CONFIG_X86_PM_TIMER
-extern u32 pmtmr_ioport;
-#endif
-
 static int __init acpi_parse_fadt(struct acpi_table_header *table)
 {
 
diff -puN drivers/clocksource/acpi_pm.c~allow-early-access-to-the-power-management-timer drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~allow-early-access-to-the-power-management-timer
+++ a/drivers/clocksource/acpi_pm.c
@@ -16,15 +16,13 @@
  * This file is licensed under the GPL v2.
  */
 
+#include <linux/acpi_pmtmr.h>
 #include <linux/clocksource.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <asm/io.h>
 
-/* Number of PMTMR ticks expected during calibration run */
-#define PMTMR_TICKS_PER_SEC 3579545
-
 /*
  * The I/O port the PMTMR resides at.
  * The location is detected during setup_arch(),
@@ -32,15 +30,13 @@
  */
 u32 pmtmr_ioport __read_mostly;
 
-#define ACPI_PM_MASK CLOCKSOURCE_MASK(24) /* limit it to 24 bits */
-
 static inline u32 read_pmtmr(void)
 {
 	/* mask the output to 24 bits */
 	return inl(pmtmr_ioport) & ACPI_PM_MASK;
 }
 
-static cycle_t acpi_pm_read_verified(void)
+u32 acpi_pm_read_verified(void)
 {
 	u32 v1 = 0, v2 = 0, v3 = 0;
 
@@ -57,7 +53,12 @@ static cycle_t acpi_pm_read_verified(voi
 	} while (unlikely((v1 > v2 && v1 < v3) || (v2 > v3 && v2 < v1)
 			  || (v3 > v1 && v3 < v2)));
 
-	return (cycle_t)v2;
+	return v2;
+}
+
+static cycle_t acpi_pm_read_slow(void)
+{
+	return (cycle_t)acpi_pm_read_verified();
 }
 
 static cycle_t acpi_pm_read(void)
@@ -88,7 +89,7 @@ __setup("acpi_pm_good", acpi_pm_good_set
 
 static inline void acpi_pm_need_workaround(void)
 {
-	clocksource_acpi_pm.read = acpi_pm_read_verified;
+	clocksource_acpi_pm.read = acpi_pm_read_slow;
 	clocksource_acpi_pm.rating = 110;
 }
 
diff -puN /dev/null include/linux/acpi_pmtmr.h
--- /dev/null
+++ a/include/linux/acpi_pmtmr.h
@@ -0,0 +1,38 @@
+#ifndef _ACPI_PMTMR_H_
+#define _ACPI_PMTMR_H_
+
+#include <linux/clocksource.h>
+
+/* Number of PMTMR ticks expected during calibration run */
+#define PMTMR_TICKS_PER_SEC 3579545
+
+/* limit it to 24 bits */
+#define ACPI_PM_MASK CLOCKSOURCE_MASK(24)
+
+/* Overrun value */
+#define ACPI_PM_OVRRUN	(1<<24)
+
+#ifdef CONFIG_X86_PM_TIMER
+
+extern u32 acpi_pm_read_verified(void);
+extern u32 pmtmr_ioport;
+
+static inline u32 acpi_pm_read_early(void)
+{
+	if (!pmtmr_ioport)
+		return 0;
+	/* mask the output to 24 bits */
+	return acpi_pm_read_verified() & ACPI_PM_MASK;
+}
+
+#else
+
+static inline u32 acpi_pm_read_early(void)
+{
+	return 0;
+}
+
+#endif
+
+#endif
+
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
