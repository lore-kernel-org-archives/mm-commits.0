From: akpm@linux-foundation.org
Subject: + x86_64-apic-shuffle-calibration-around.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:04:59 -0700
Message-ID: <200708242204.l7OM4xTS017008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759268AbXHXWGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:06:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     x86_64: Move apic calibration code around
has been added to the -mm tree.  Its filename is
     x86_64-apic-shuffle-calibration-around.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+), 9 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-apic-shuffle-calibration-around arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-apic-shuffle-calibration-around
+++ a/arch/x86_64/kernel/apic.c
@@ -55,6 +55,8 @@ static struct resource lapic_resource = 
 	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
 };
 
+static unsigned int calibration_result;
+
 /*
  * cpu_mask that denotes the CPUs that needs timer interrupt coming in as
  * IPIs in place of local APIC timers
@@ -825,7 +827,7 @@ static void setup_APIC_timer(unsigned in
 
 #define TICK_COUNT 100000000
 
-static int __init calibrate_APIC_clock(void)
+static void __init calibrate_APIC_clock(void)
 {
 	unsigned apic, apic_start;
 	unsigned long tsc, tsc_start;
@@ -859,17 +861,14 @@ static int __init calibrate_APIC_clock(v
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
@@ -882,7 +881,7 @@ void __init setup_boot_APIC_clock (void)
 
 	local_irq_disable();
 
-	calibration_result = calibrate_APIC_clock();
+	calibrate_APIC_clock();
 	/*
 	 * Now set up the timer for real.
 	 */
@@ -989,8 +988,6 @@ void setup_APIC_extended_lvt(unsigned ch
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
sigqueue_free-fix-the-race-with-collect_signal.patch
git-acpi.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
clockevents-remove-unused-inline-function.patch
clockevents-allow-build-without-runtime-use.patch
x86_64-consolidate-tsc-calibration.patch
i386-prepare-sharing-hpet-code.patch
i386-hpet-add-x8664-hpet-bits.patch
i386-prepare-sharing-pit-code.patch
x86_64-use-i386-i8253-h.patch
x86_64-preparatory-apic-set-lvtt.patch
x86_64-apic-remove-bogus-pit-synchronization.patch
x86_64-apic-shuffle-calibration-around.patch
x86_64-apic-calibration-remove-divisor.patch
x86_64-apic-change-setup-calling-convention.patch
x86_64-apic-remove-nested-irq-disable.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-apic-add-clockevents-functions.patch
x86_64-convert-to-clockevents.patch
x86_64-remove-unused-code.patch
x86_64-cleanup-apic-c.patch
jiffies-remove-unused-macros.patch
acpi-remove-the-useless-ifdef-code.patch
i386-pit-remove-the-useless-ifdefs.patch
i386-hpet-sharing-optimize.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
hpet-force-enable-on-ich34.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
