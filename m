From: akpm@linux-foundation.org
Subject: + x86_64-preparatory-apic-set-lvtt.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:04:55 -0700
Message-ID: <200708242204.l7OM4tQv017001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756999AbXHXWGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:06:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     x86_64: prepare apic code for clock events
has been added to the -mm tree.  Its filename is
     x86_64-preparatory-apic-set-lvtt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: prepare apic code for clock events
From: Thomas Gleixner <tglx@linutronix.de>

Change __setup_APIC_LVTT so it takes the arguments which are necessary for the
later clock events switch.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-preparatory-apic-set-lvtt arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-preparatory-apic-set-lvtt
+++ a/arch/x86_64/kernel/apic.c
@@ -763,14 +763,14 @@ void __init init_apic_mappings(void)
 
 #define APIC_DIVISOR 16
 
-static void __setup_APIC_LVTT(unsigned int clocks)
+static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
 	unsigned int lvtt_value, tmp_value;
-	int cpu = smp_processor_id();
-
-	lvtt_value = APIC_LVT_TIMER_PERIODIC | LOCAL_TIMER_VECTOR;
 
-	if (cpu_isset(cpu, timer_interrupt_broadcast_ipi_mask))
+	lvtt_value = LOCAL_TIMER_VECTOR;
+	if (!oneshot)
+		lvtt_value |= APIC_LVT_TIMER_PERIODIC;
+	if (!irqen)
 		lvtt_value |= APIC_LVT_MASKED;
 
 	apic_write(APIC_LVTT, lvtt_value);
@@ -783,12 +783,14 @@ static void __setup_APIC_LVTT(unsigned i
 				& ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE))
 				| APIC_TDR_DIV_16);
 
-	apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
+	if (!oneshot)
+		apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
 }
 
 static void setup_APIC_timer(unsigned int clocks)
 {
 	unsigned long flags;
+	int irqen;
 
 	local_irq_save(flags);
 
@@ -809,7 +811,10 @@ static void setup_APIC_timer(unsigned in
 			c2 |= inb_p(0x40) << 8;
 		} while (c2 - c1 < 300);
 	}
-	__setup_APIC_LVTT(clocks);
+
+	irqen = ! cpu_isset(smp_processor_id(),
+			    timer_interrupt_broadcast_ipi_mask);
+	__setup_APIC_LVTT(clocks, 0, irqen);
 	/* Turn off PIT interrupt if we use APIC timer as main timer.
 	   Only works with the PM timer right now
 	   TBD fix it for HPET too. */
@@ -847,8 +852,10 @@ static int __init calibrate_APIC_clock(v
 	 * Put whatever arbitrary (but long enough) timeout
 	 * value into the APIC clock, we just want to get the
 	 * counter running for calibration.
+	 *
+	 * No interrupt enable !
 	 */
-	__setup_APIC_LVTT(4000000000);
+	__setup_APIC_LVTT(4000000000, 0, 0);
 
 	apic_start = apic_read(APIC_TMCCT);
 #ifdef CONFIG_X86_PM_TIMER
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
