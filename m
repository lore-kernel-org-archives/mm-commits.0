From: akpm@osdl.org
Subject: + clockevents-make-apicc-exports-gpl-remove-fastcall-attributes.patch added to -mm tree
Date: Mon, 11 Dec 2006 13:35:00 -0800
Message-ID: <200612112135.kBBLZ0Hq008336@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763136AbWLKVfK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 16:35:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     clockevents: make apic.c exports GPL, remove fastcall attributes
has been added to the -mm tree.  Its filename is
     clockevents-make-apicc-exports-gpl-remove-fastcall-attributes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clockevents: make apic.c exports GPL, remove fastcall attributes
From: Thomas Gleixner <tglx@linutronix.de>

Address more review feedback from Arjan: make apic.c exports _GPL, remove
fastcall attributes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/apic.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/i386/kernel/apic.c~clockevents-make-apicc-exports-gpl-remove-fastcall-attributes arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~clockevents-make-apicc-exports-gpl-remove-fastcall-attributes
+++ a/arch/i386/kernel/apic.c
@@ -509,7 +509,7 @@ void switch_APIC_timer_to_ipi(void *cpum
 	if (cpu_isset(cpu, mask) && levt->event_handler)
 		clockevents_set_global_broadcast(levt, 1);
 }
-EXPORT_SYMBOL(switch_APIC_timer_to_ipi);
+EXPORT_SYMBOL_GPL(switch_APIC_timer_to_ipi);
 
 void switch_ipi_to_APIC_timer(void *cpumask)
 {
@@ -520,12 +520,12 @@ void switch_ipi_to_APIC_timer(void *cpum
 	if (cpu_isset(cpu, mask) && levt->event_handler)
 		clockevents_set_global_broadcast(levt, 0);
 }
-EXPORT_SYMBOL(switch_ipi_to_APIC_timer);
+EXPORT_SYMBOL_GPL(switch_ipi_to_APIC_timer);
 
 /*
  * The guts of the apic timer interrupt
  */
-static fastcall void local_apic_timer_interrupt(struct pt_regs *regs)
+static void local_apic_timer_interrupt(struct pt_regs *regs)
 {
 	int cpu = smp_processor_id();
 	struct clock_event_device *evt = &per_cpu(lapic_events, cpu);
@@ -577,7 +577,7 @@ static fastcall void local_apic_timer_in
  *   interrupt as well. Thus we cannot inline the local irq ... ]
  */
 
-fastcall void smp_apic_timer_interrupt(struct pt_regs *regs)
+void smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
@@ -1284,7 +1284,7 @@ __setup("apic=", apic_set_verbosity);
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
-fastcall void smp_spurious_interrupt(struct pt_regs *regs)
+void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	unsigned long v;
 
@@ -1308,7 +1308,7 @@ fastcall void smp_spurious_interrupt(str
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
-fastcall void smp_error_interrupt(struct pt_regs *regs)
+void smp_error_interrupt(struct pt_regs *regs)
 {
 	unsigned long v, v1;
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-mtd.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
time-uninline-jiffiesh.patch
time-uninline-jiffiesh-fix.patch
time-fix-msecs_to_jiffies-bug.patch
time-fix-timeout-overflow.patch
cleanup-uninline-irq_enter-and-move-it-into-a-function.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-hrtimers-clean-up-callback-tracking.patch
updated-hrtimers-move-and-add-documentation.patch
updated-add-a-framework-to-manage-clock-event-devices.patch
updated-add-a-framework-to-manage-clock-event-devices-next_event-calculation-fix.patch
updated-add-a-framework-to-manage-clock-event-devices-pit-broadcasting-fix.patch
updated-acpi-include-apich.patch
updated-acpi-keep-track-of-timer-broadcast.patch
updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch
updated-i386-cleanup-apic-code.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-i386-rework-local-apic-calibration.patch
updated-high-res-timers-core.patch
updated-high-res-timers-core-high-res-timers-do-itimer-rearming-in-process-context.patch
updated-high-res-timers-core-cleanup-state-tracking-update.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
high-res-timers-utilize-tsc-clocksource-again.patch
high-res-timers-utilize-tsc-clocksource-again-fix.patch
updated-dynticks-core-code.patch
updated-dyntick-add-nohz-stats-to-proc-stat.patch
updated-dynticks-i386-arch-code.patch
updated-dynticks-fix-nmi-watchdog.patch
updated-high-res-timers-dynticks-enable-i386-support.patch
updated-debugging-feature-timer-stats.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
clockevents-convert-hpet-to-clockevents.patch
clockevents-make-apicc-exports-gpl-remove-fastcall-attributes.patch
clockevents-i8253c-remove-hpet-dependencies.patch
clockevents-remove-ptregs-argument-from-handlers.patch

