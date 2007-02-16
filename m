From: akpm@linux-foundation.org
Subject: - time-x86_64-tsc-fixup-clocksource-changes.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:38:44 -0800
Message-ID: <200702160838.l1G8ciI9024753@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60754 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966229AbXBPIiw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:38:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     time-x86_64-tsc-fixup-clocksource-changes
has been removed from the -mm tree.  Its filename was
     time-x86_64-tsc-fixup-clocksource-changes.patch

This patch was dropped because it was folded into time-x86_64-convert-x86_64-to-use-generic_time.patch

------------------------------------------------------
Subject: time-x86_64-tsc-fixup-clocksource-changes


Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/tsc.c |   43 +++++++++++--------------------------
 1 files changed, 13 insertions(+), 30 deletions(-)

diff -puN arch/x86_64/kernel/tsc.c~time-x86_64-tsc-fixup-clocksource-changes arch/x86_64/kernel/tsc.c
--- a/arch/x86_64/kernel/tsc.c~time-x86_64-tsc-fixup-clocksource-changes
+++ a/arch/x86_64/kernel/tsc.c
@@ -46,13 +46,6 @@ static inline int check_tsc_unstable(voi
 {
 	return tsc_unstable;
 }
-
-void mark_tsc_unstable(void)
-{
-	tsc_unstable = 1;
-}
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
-
 #ifdef CONFIG_CPU_FREQ
 
 /* Frequency scaling support. Adjust the TSC based timer when the cpu frequency
@@ -143,12 +136,6 @@ core_initcall(cpufreq_tsc);
 
 static int tsc_unstable = 0;
 
-void mark_tsc_unstable(void)
-{
-	tsc_unstable = 1;
-}
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
-
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
@@ -187,9 +174,6 @@ __setup("notsc", notsc_setup);
 
 
 /* clock source code: */
-
-static int tsc_update_callback(void);
-
 static cycle_t read_tsc(void)
 {
 	cycle_t ret = (cycle_t)get_cycles_sync();
@@ -200,25 +184,24 @@ static struct clocksource clocksource_ts
 	.name			= "tsc",
 	.rating			= 300,
 	.read			= read_tsc,
-	.mask			= (cycle_t)-1,
-	.mult			= 0, /* to be set */
+	.mask			= CLOCKSOURCE_MASK(64),
 	.shift			= 22,
-	.update_callback	= tsc_update_callback,
-	.is_continuous		= 1,
+	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
+				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
-static int tsc_update_callback(void)
+void mark_tsc_unstable(void)
 {
-	int change = 0;
-
-	/* check to see if we should switch to the safe clocksource: */
-	if (clocksource_tsc.rating != 50 && check_tsc_unstable()) {
-		clocksource_tsc.rating = 50;
-		clocksource_reselect();
-		change = 1;
+	if (!tsc_unstable) {
+		tsc_unstable = 1;
+		/* Change only the rating, when not registered */
+		if (clocksource_tsc.mult)
+			clocksource_change_rating(&clocksource_tsc, 0);
+		else
+			clocksource_tsc.rating = 0;
 	}
-	return change;
 }
+EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 static int __init init_tsc_clocksource(void)
 {
@@ -226,7 +209,7 @@ static int __init init_tsc_clocksource(v
 		clocksource_tsc.mult = clocksource_khz2mult(cpu_khz,
 							clocksource_tsc.shift);
 		if (check_tsc_unstable())
-			clocksource_tsc.rating = 50;
+			clocksource_tsc.rating = 0;
 
 		return clocksource_register(&clocksource_tsc);
 	}
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
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
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
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
time-x86_64-hpet_address-cleanup.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-tsc-fixup-clocksource-changes.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
genirq-do-not-mask-interrupts-by-default.patch
genirq-remove-irq_disabled.patch
small-irq-management-simplification.patch
