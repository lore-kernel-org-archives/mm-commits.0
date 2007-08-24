From: akpm@linux-foundation.org
Subject: + x86_64-apic-remove-nested-irq-disable.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:05:08 -0700
Message-ID: <200708242205.l7OM5Fkd017023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34159 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759616AbXHXWGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:06:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     x86_64: remove nested irq disables
has been added to the -mm tree.  Its filename is
     x86_64-apic-remove-nested-irq-disable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-apic-remove-nested-irq-disable arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-apic-remove-nested-irq-disable
+++ a/arch/x86_64/kernel/apic.c
@@ -830,6 +830,9 @@ static void __init calibrate_APIC_clock(
 	unsigned apic, apic_start;
 	unsigned long tsc, tsc_start;
 	int result;
+
+	local_irq_disable();
+
 	/*
 	 * Put whatever arbitrary (but long enough) timeout
 	 * value into the APIC clock, we just want to get the
@@ -859,6 +862,9 @@ static void __init calibrate_APIC_clock(
 		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
 	}
+
+	local_irq_enable();
+
 	printk(KERN_DEBUG "APIC timer calibration result %d\n", result);
 
 	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
@@ -877,22 +883,16 @@ void __init setup_boot_APIC_clock (void)
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
