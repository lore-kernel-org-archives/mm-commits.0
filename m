From: akpm@linux-foundation.org
Subject: - x86_64-apic-remove-nested-irq-disable.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:18:11 -0700
Message-ID: <200710150918.l9F9IBP2027373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755290AbXJOJYM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:24:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86_64: remove nested irq disables
has been removed from the -mm tree.  Its filename was
     x86_64-apic-remove-nested-irq-disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: remove nested irq disables
From: Thomas Gleixner <tglx@linutronix.de>

setup_APIC_timer disables interrupts anyway.  So no need to do the same in
setup_boot_APIC_clock and setup_secondary_APIC_clock.  Disable interrupts
explicit in the calibration code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-apic-remove-nested-irq-disable arch/x86_64/kernel/apic.c
--- a/arch/x86/kernel/apic_64.c~x86_64-apic-remove-nested-irq-disable
+++ a/arch/x86/kernel/apic_64.c
@@ -806,6 +806,9 @@ static void __init calibrate_APIC_clock(
 	unsigned apic, apic_start;
 	unsigned long tsc, tsc_start;
 	int result;
+
+	local_irq_disable();
+
 	/*
 	 * Put whatever arbitrary (but long enough) timeout
 	 * value into the APIC clock, we just want to get the
@@ -835,6 +838,9 @@ static void __init calibrate_APIC_clock(
 		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
 	}
+
+	local_irq_enable();
+
 	printk(KERN_DEBUG "APIC timer calibration result %d\n", result);
 
 	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
@@ -853,22 +859,16 @@ void __init setup_boot_APIC_clock (void)
 	printk(KERN_INFO "Using local APIC timer interrupts.\n");
 	using_apic_timer = 1;
 
-	local_irq_disable();
-
 	calibrate_APIC_clock();
 	/*
 	 * Now set up the timer for real.
 	 */
 	setup_APIC_timer();
-
-	local_irq_enable();
 }
 
 void __cpuinit setup_secondary_APIC_clock(void)
 {
-	local_irq_disable(); /* FIXME: Do we need this? --RR */
 	setup_APIC_timer();
-	local_irq_enable();
 }
 
 void disable_APIC_timer(void)
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
