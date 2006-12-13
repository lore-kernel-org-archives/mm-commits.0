From: akpm@osdl.org
Subject: - updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:49:23 -0800
Message-ID: <200612132249.kBDMnNvr023153@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53289 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbWLMWvV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:51:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     PM_timer: allow early access and move externs to a header file
has been removed from the -mm tree.  Its filename was
     updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: PM_timer: allow early access and move externs to a header file
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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/acpi/boot.c  |    5 ----
 drivers/clocksource/acpi_pm.c |   17 +++++++-------
 include/linux/acpi_pmtmr.h    |   38 ++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 12 deletions(-)

diff -puN arch/i386/kernel/acpi/boot.c~updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file
+++ a/arch/i386/kernel/acpi/boot.c
@@ -25,6 +25,7 @@
 
 #include <linux/init.h>
 #include <linux/acpi.h>
+#include <linux/acpi_pmtmr.h>
 #include <linux/efi.h>
 #include <linux/cpumask.h>
 #include <linux/module.h>
@@ -703,10 +704,6 @@ static int __init acpi_parse_hpet(unsign
 #define	acpi_parse_hpet	NULL
 #endif
 
-#ifdef CONFIG_X86_PM_TIMER
-extern u32 pmtmr_ioport;
-#endif
-
 static int __init acpi_parse_fadt(unsigned long phys, unsigned long size)
 {
 	struct fadt_descriptor *fadt = NULL;
diff -puN drivers/clocksource/acpi_pm.c~updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file
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
@@ -87,7 +88,7 @@ __setup("acpi_pm_good", acpi_pm_good_set
 
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
+#define ACPI_PM_OVRRUN	1<<24
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
+	return acpi_pm_read_verified();
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
git-mtd.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch

