From: akpm@osdl.org
Subject: - clockevents-make-apicc-exports-gpl-remove-fastcall-attributes.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:52:12 -0800
Message-ID: <200612132252.kBDMqCw9023272@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53451 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbWLMWwY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:52:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     clockevents: make apic.c exports GPL, remove fastcall attributes
has been removed from the -mm tree.  Its filename was
     clockevents-make-apicc-exports-gpl-remove-fastcall-attributes.patch

This patch was dropped because it is obsolete

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
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
clockevents-make-apicc-exports-gpl-remove-fastcall-attributes.patch
clockevents-remove-ptregs-argument-from-handlers.patch

