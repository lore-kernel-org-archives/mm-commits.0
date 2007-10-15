From: akpm@linux-foundation.org
Subject: - acpi-remove-the-useless-ifdef-code.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:18:28 -0700
Message-ID: <200710150918.l9F9ISud027405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756846AbXJOJXR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:23:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     ACPI: remove the now unused ifdef code
has been removed from the -mm tree.  Its filename was
     acpi-remove-the-useless-ifdef-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: remove the now unused ifdef code
From: Thomas Gleixner <tglx@linutronix.de>

The conversion of x86-64 to clock events makes the
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 n the timer broadcast functions useless. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-remove-the-useless-ifdef-code drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-remove-the-useless-ifdef-code
+++ a/drivers/acpi/processor_idle.c
@@ -295,21 +295,12 @@ static void acpi_timer_check_state(int s
 
 static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
 {
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
 	unsigned long reason;
 
 	reason = pr->power.timer_broadcast_on_state < INT_MAX ?
 		CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;
 
 	clockevents_notify(reason, &pr->id);
-#else
-	cpumask_t mask = cpumask_of_cpu(pr->id);
-
-	if (pr->power.timer_broadcast_on_state < INT_MAX)
-		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
-	else
-		on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
-#endif
 }
 
 /* Power(C) State timer broadcast control */
@@ -317,8 +308,6 @@ static void acpi_state_timer_broadcast(s
 				       struct acpi_processor_cx *cx,
 				       int broadcast)
 {
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
-
 	int state = cx - pr->power.states;
 
 	if (state >= pr->power.timer_broadcast_on_state) {
@@ -328,7 +317,6 @@ static void acpi_state_timer_broadcast(s
 			CLOCK_EVT_NOTIFY_BROADCAST_EXIT;
 		clockevents_notify(reason, &pr->id);
 	}
-#endif
 }
 
 #else
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-arm.patch
git-mips.patch
provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
git-sched.patch
i386-cleanup-struct-irqaction-initializers.patch
x86_64-cleanup-struct-irqaction-initializers.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
frv-cleanup-struct-irqaction-initializers.patch
m32r-cleanup-struct-irqaction-initializers.patch
cris-cleanup-struct-irqaction-initializers.patch
uml-eliminate-hz.patch
uml-fix-timer-switching.patch
uml-simplify-interval-setting.patch
uml-separate-timer-initialization.patch
uml-generic_time-support.patch
uml-generic_clockevents-support.patch
uml-clocksource-support.patch
uml-clocksource-support-fix.patch
uml-tickless-support.patch
uml-tickless-support-fix.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
v850-cleanup-struct-irqaction-initializers.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
spin_lock_unlocked-cleanups.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
