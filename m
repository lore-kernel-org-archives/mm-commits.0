From: akpm@linux-foundation.org
Subject: - x86_64-apic-shuffle-calibration-around.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:18:05 -0700
Message-ID: <200710150918.l9F9I5pZ027359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757389AbXJOJYc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:24:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86_64: Move apic calibration code around
has been removed from the -mm tree.  Its filename was
     x86_64-apic-shuffle-calibration-around.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: Move apic calibration code around
From: Thomas Gleixner <tglx@linutronix.de>

Let the calibration code fill in calibration_result directly and
move the variable on top of the file.

Fixup a printk w/o log level while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-apic-shuffle-calibration-around arch/x86_64/kernel/apic.c
--- a/arch/x86/kernel/apic_64.c~x86_64-apic-shuffle-calibration-around
+++ a/arch/x86/kernel/apic_64.c
@@ -55,6 +55,8 @@ static struct resource lapic_resource = 
 	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
 };
 
+static unsigned int calibration_result;
+
 /*
  * cpu_mask that denotes the CPUs that needs timer interrupt coming in as
  * IPIs in place of local APIC timers
@@ -801,7 +803,7 @@ static void setup_APIC_timer(unsigned in
 
 #define TICK_COUNT 100000000
 
-static int __init calibrate_APIC_clock(void)
+static void __init calibrate_APIC_clock(void)
 {
 	unsigned apic, apic_start;
 	unsigned long tsc, tsc_start;
@@ -835,17 +837,14 @@ static int __init calibrate_APIC_clock(v
 		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
 	}
-	printk("result %d\n", result);
-
+	printk(KERN_DEBUG "APIC timer calibration result %d\n", result);
 
 	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
 		result / 1000 / 1000, result / 1000 % 1000);
 
-	return result * APIC_DIVISOR / HZ;
+	calibration_result = result * APIC_DIVISOR / HZ;
 }
 
-static unsigned int calibration_result;
-
 void __init setup_boot_APIC_clock (void)
 {
 	if (disable_apic_timer) {
@@ -858,7 +857,7 @@ void __init setup_boot_APIC_clock (void)
 
 	local_irq_disable();
 
-	calibration_result = calibrate_APIC_clock();
+	calibrate_APIC_clock();
 	/*
 	 * Now set up the timer for real.
 	 */
@@ -965,8 +964,6 @@ void setup_APIC_extended_lvt(unsigned ch
 	apic_write(reg, v);
 }
 
-#undef APIC_DIVISOR
-
 /*
  * Local timer interrupt handler. It does both profiling and
  * process statistics/rescheduling.
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
