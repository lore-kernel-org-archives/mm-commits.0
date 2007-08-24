From: akpm@linux-foundation.org
Subject: + x86_64-apic-calibration-remove-divisor.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:05:01 -0700
Message-ID: <200708242205.l7OM55ZD017017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757623AbXHXWOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:14:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     x86_64: Remove APIC_DIVISOR
has been added to the -mm tree.  Its filename is
     x86_64-apic-calibration-remove-divisor.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: Remove APIC_DIVISOR
From: Thomas Gleixner <tglx@linutronix.de>

APIC_DIVISOR is rather useless.  It makes the calibration result more accurate
in the first place, but we discard this later when we write the value to the
APIC timer by dividing the calibration value by APIC_DIVISOR.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-apic-calibration-remove-divisor arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-apic-calibration-remove-divisor
+++ a/arch/x86_64/kernel/apic.c
@@ -763,8 +763,6 @@ void __init init_apic_mappings(void)
  * P5 APIC double write bug.
  */
 
-#define APIC_DIVISOR 16
-
 static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
 	unsigned int lvtt_value, tmp_value;
@@ -786,7 +784,7 @@ static void __setup_APIC_LVTT(unsigned i
 				| APIC_TDR_DIV_16);
 
 	if (!oneshot)
-		apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
+		apic_write(APIC_TMICT, clocks);
 }
 
 static void setup_APIC_timer(unsigned int clocks)
@@ -839,7 +837,7 @@ static void __init calibrate_APIC_clock(
 	 *
 	 * No interrupt enable !
 	 */
-	__setup_APIC_LVTT(4000000000, 0, 0);
+	__setup_APIC_LVTT(250000000, 0, 0);
 
 	apic_start = apic_read(APIC_TMCCT);
 #ifdef CONFIG_X86_PM_TIMER
@@ -866,7 +864,7 @@ static void __init calibrate_APIC_clock(
 	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
 		result / 1000 / 1000, result / 1000 % 1000);
 
-	calibration_result = result * APIC_DIVISOR / HZ;
+	calibration_result = result / HZ;
 }
 
 void __init setup_boot_APIC_clock (void)
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
