From: akpm@osdl.org
Subject: + allow-early-access-to-the-power-management-timer.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:36:41 -0800
Message-ID: <200701250636.l0P6af4M008358@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50421 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965562AbXAYGhj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:37:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     Allow early access to the power management timer
has been added to the -mm tree.  Its filename is
     allow-early-access-to-the-power-management-timer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
clocksource-add-verification-watchdog-helper-fix.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
