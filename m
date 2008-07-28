From: akpm@linux-foundation.org
Subject: - acpi-cpuidle-prevent-setting-pm_idle-to-null.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:11:12 -0700
Message-ID: <200807282111.m6SLBCkx027655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762597AbYG1VUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:20:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, andi@firstfloor.org, dhaval@linux.vnet.ibm.com, lenb@kernel.org, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI/CPUIDLE: prevent setting pm_idle to NULL
has been removed from the -mm tree.  Its filename was
     acpi-cpuidle-prevent-setting-pm_idle-to-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI/CPUIDLE: prevent setting pm_idle to NULL
From: Thomas Gleixner <tglx@linutronix.de>

pm_idle_save resp.  pm_idle_old can be NULL when the restore code in
acpi_processor_cst_has_changed() resp.  cpuidle_uninstall_idle_handler()
is called.  This can set pm_idle unconditinally to NULL, which causes the
kernel to panic when calling pm_idle in the x86 idle code.  This was
covered by an extra check for !pm_idle in the x86 idle code, which was
removed during the x86 idle code refactoring.

Instead of restoring the pm_idle check in the x86 code prevent the
acpi/cpuidle code to set pm_idle to NULL.

Based on a debug patch from Ingo Molnar

Reported-by: Dhaval Giani <dhaval@linux.vnet.ibm.com> [http://lkml.org/lkml/2008/7/2/309]
Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Len Brown <lenb@kernel.org>
Andi Kleen <andi@firstfloor.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |   15 +++++++++++----
 drivers/cpuidle/cpuidle.c     |    2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-cpuidle-prevent-setting-pm_idle-to-null drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-cpuidle-prevent-setting-pm_idle-to-null
+++ a/drivers/acpi/processor_idle.c
@@ -1332,9 +1332,15 @@ int acpi_processor_cst_has_changed(struc
 	if (!pr->flags.power_setup_done)
 		return -ENODEV;
 
-	/* Fall back to the default idle loop */
-	pm_idle = pm_idle_save;
-	synchronize_sched();	/* Relies on interrupts forcing exit from idle. */
+	/*
+	 * Fall back to the default idle loop, when pm_idle_save had
+	 * been initialized.
+	 */
+	if (pm_idle_save) {
+		pm_idle = pm_idle_save;
+		/* Relies on interrupts forcing exit from idle. */
+		synchronize_sched();
+	}
 
 	pr->flags.power = 0;
 	result = acpi_processor_get_power_info(pr);
@@ -1896,7 +1902,8 @@ int acpi_processor_power_exit(struct acp
 
 	/* Unregister the idle handler when processor #0 is removed. */
 	if (pr->id == 0) {
-		pm_idle = pm_idle_save;
+		if (pm_idle_save)
+			pm_idle = pm_idle_save;
 
 		/*
 		 * We are about to unload the current idle thread pm callback
diff -puN drivers/cpuidle/cpuidle.c~acpi-cpuidle-prevent-setting-pm_idle-to-null drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~acpi-cpuidle-prevent-setting-pm_idle-to-null
+++ a/drivers/cpuidle/cpuidle.c
@@ -94,7 +94,7 @@ void cpuidle_install_idle_handler(void)
  */
 void cpuidle_uninstall_idle_handler(void)
 {
-	if (enabled_devices && (pm_idle != pm_idle_old)) {
+	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
 		pm_idle = pm_idle_old;
 		cpuidle_kick_cpus();
 	}
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
linux-next.patch
x86-pci-replace-dbg-with-pr_debug.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
ntp-let-update_persistent_clock-sleep.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
timekeeping-fix-rounding-problem-during-clock-update.patch
aes-x86_64-asm-implementation-optimization.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
clocksource-keep-track-of-original-clocksource-frequency.patch
clocksource-introduce-clocksource_forward_now.patch
clocksource-introduce-clock_monotonic_raw.patch

