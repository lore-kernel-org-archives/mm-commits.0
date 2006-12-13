From: akpm@osdl.org
Subject: - clockevents-remove-ptregs-argument-from-handlers.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:52:19 -0800
Message-ID: <200612132252.kBDMqK3v023283@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53464 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbWLMWwb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:52:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     clockevents: remove ptregs argument from handlers
has been removed from the -mm tree.  Its filename was
     clockevents-remove-ptregs-argument-from-handlers.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: clockevents: remove ptregs argument from handlers
From: Thomas Gleixner <tglx@linutronix.de>

cleanup: pt_regs irq handler argument conversion fallout.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/apic.c                  |   13 ++++----
 include/asm-i386/i8253.h                 |    4 +-
 include/asm-i386/mach-default/do_timer.h |    2 -
 include/linux/clockchips.h               |    2 -
 include/linux/hrtimer.h                  |    2 -
 kernel/hrtimer.c                         |    2 -
 kernel/time/clockevents.c                |   32 ++++++++++-----------
 7 files changed, 29 insertions(+), 28 deletions(-)

diff -puN arch/i386/kernel/apic.c~clockevents-remove-ptregs-argument-from-handlers arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~clockevents-remove-ptregs-argument-from-handlers
+++ a/arch/i386/kernel/apic.c
@@ -286,7 +286,7 @@ static __initdata unsigned long lapic_ca
 /*
  * Temporary interrupt handler.
  */
-static void __init lapic_cal_handler(struct pt_regs *regs)
+static void __init lapic_cal_handler(void)
 {
 	unsigned long long tsc = 0;
 	long tapic = apic_read(APIC_TMCCT);
@@ -324,7 +324,7 @@ void __init setup_boot_APIC_clock(void)
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 	const long pm_100ms = PMTMR_TICKS_PER_SEC/10;
 	const long pm_thresh = pm_100ms/100;
-	void (*real_handler)(struct pt_regs *regs);
+	void (*real_handler)(void);
 	unsigned long deltaj;
 	long delta, deltapm;
 	cpumask_t cpumask;
@@ -525,7 +525,7 @@ EXPORT_SYMBOL_GPL(switch_ipi_to_APIC_tim
 /*
  * The guts of the apic timer interrupt
  */
-static void local_apic_timer_interrupt(struct pt_regs *regs)
+static void local_apic_timer_interrupt(void)
 {
 	int cpu = smp_processor_id();
 	struct clock_event_device *evt = &per_cpu(lapic_events, cpu);
@@ -565,7 +565,7 @@ static void local_apic_timer_interrupt(s
 
 	per_cpu(irq_stat, cpu).apic_timer_irqs++;
 
-	evt->event_handler(regs);
+	evt->event_handler();
 }
 
 /*
@@ -593,8 +593,9 @@ void smp_apic_timer_interrupt(struct pt_
 	 */
 	exit_idle();
 	irq_enter();
-	local_apic_timer_interrupt(regs);
+	local_apic_timer_interrupt();
 	irq_exit();
+
 	set_irq_regs(old_regs);
 }
 
@@ -609,7 +610,7 @@ static void lapic_timer_broadcast(cpumas
 	cpus_and(mask, cpu_online_map, *cpumask);
 	if (cpu_isset(cpu, mask)) {
 		cpu_clear(cpu, mask);
-		local_apic_timer_interrupt(get_irq_regs());
+		local_apic_timer_interrupt();
 	}
 #ifdef CONFIG_SMP
 	if (!cpus_empty(mask))
diff -puN include/asm-i386/i8253.h~clockevents-remove-ptregs-argument-from-handlers include/asm-i386/i8253.h
--- a/include/asm-i386/i8253.h~clockevents-remove-ptregs-argument-from-handlers
+++ a/include/asm-i386/i8253.h
@@ -13,9 +13,9 @@ extern struct clock_event_device *global
  *
  * Call the global clock event handler.
  **/
-static inline void pit_interrupt_hook(struct pt_regs *regs)
+static inline void pit_interrupt_hook(void)
 {
-	global_clock_event->event_handler(regs);
+	global_clock_event->event_handler();
 }
 
 #endif	/* __ASM_I8253_H__ */
diff -puN include/asm-i386/mach-default/do_timer.h~clockevents-remove-ptregs-argument-from-handlers include/asm-i386/mach-default/do_timer.h
--- a/include/asm-i386/mach-default/do_timer.h~clockevents-remove-ptregs-argument-from-handlers
+++ a/include/asm-i386/mach-default/do_timer.h
@@ -12,7 +12,7 @@
 
 static inline void do_timer_interrupt_hook(void)
 {
-	pit_interrupt_hook(get_irq_regs());
+	pit_interrupt_hook();
 }
 
 
diff -puN include/linux/clockchips.h~clockevents-remove-ptregs-argument-from-handlers include/linux/clockchips.h
--- a/include/linux/clockchips.h~clockevents-remove-ptregs-argument-from-handlers
+++ a/include/linux/clockchips.h
@@ -80,7 +80,7 @@ struct clock_event_device {
 					  struct clock_event_device *);
 	void		(*set_mode)(enum clock_event_mode mode,
 				    struct clock_event_device *);
-	void		(*event_handler)(struct pt_regs *regs);
+	void		(*event_handler)(void);
 };
 
 /*
diff -puN include/linux/hrtimer.h~clockevents-remove-ptregs-argument-from-handlers include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~clockevents-remove-ptregs-argument-from-handlers
+++ a/include/linux/hrtimer.h
@@ -230,7 +230,7 @@ struct hrtimer_cpu_base {
 
 extern void hrtimer_clock_notify(void);
 extern void clock_was_set(void);
-extern void hrtimer_interrupt(struct pt_regs *regs);
+extern void hrtimer_interrupt(void);
 
 /*
  * In high resolution mode the time reference must be read accurate
diff -puN kernel/hrtimer.c~clockevents-remove-ptregs-argument-from-handlers kernel/hrtimer.c
--- a/kernel/hrtimer.c~clockevents-remove-ptregs-argument-from-handlers
+++ a/kernel/hrtimer.c
@@ -1381,7 +1381,7 @@ EXPORT_SYMBOL_GPL(hrtimer_get_res);
  * High resolution timer interrupt
  * Called with interrupts disabled
  */
-void hrtimer_interrupt(struct pt_regs *regs)
+void hrtimer_interrupt(void)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	struct hrtimer_clock_base *base;
diff -puN kernel/time/clockevents.c~clockevents-remove-ptregs-argument-from-handlers kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~clockevents-remove-ptregs-argument-from-handlers
+++ a/kernel/time/clockevents.c
@@ -76,7 +76,7 @@ unsigned long clockevent_delta2ns(unsign
 /*
  * Bootup and lowres handler: ticks only
  */
-static void handle_tick(struct pt_regs *regs)
+static void handle_tick(void)
 {
 	write_seqlock(&xtime_lock);
 	do_timer(1);
@@ -86,19 +86,19 @@ static void handle_tick(struct pt_regs *
 /*
  * Bootup and lowres handler: ticks and update_process_times
  */
-static void handle_tick_update(struct pt_regs *regs)
+static void handle_tick_update(void)
 {
 	write_seqlock(&xtime_lock);
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
 
-	update_process_times(user_mode(regs));
+	update_process_times(user_mode(get_irq_regs()));
 }
 
 /*
  * Bootup and lowres handler: ticks and profileing
  */
-static void handle_tick_profile(struct pt_regs *regs)
+static void handle_tick_profile(void)
 {
 	write_seqlock(&xtime_lock);
 	do_timer(1);
@@ -110,37 +110,37 @@ static void handle_tick_profile(struct p
 /*
  * Bootup and lowres handler: ticks, update_process_times and profiling
  */
-static void handle_tick_update_profile(struct pt_regs *regs)
+static void handle_tick_update_profile(void)
 {
 	write_seqlock(&xtime_lock);
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
 
-	update_process_times(user_mode(regs));
+	update_process_times(user_mode(get_irq_regs()));
 	profile_tick(CPU_PROFILING);
 }
 
 /*
  * Bootup and lowres handler: update_process_times
  */
-static void handle_update(struct pt_regs *regs)
+static void handle_update(void)
 {
-	update_process_times(user_mode(regs));
+	update_process_times(user_mode(get_irq_regs()));
 }
 
 /*
  * Bootup and lowres handler: update_process_times and profiling
  */
-static void handle_update_profile(struct pt_regs *regs)
+static void handle_update_profile(void)
 {
-	update_process_times(user_mode(regs));
+	update_process_times(user_mode(get_irq_regs()));
 	profile_tick(CPU_PROFILING);
 }
 
 /*
  * Bootup and lowres handler: profiling
  */
-static void handle_profile(struct pt_regs *regs)
+static void handle_profile(void)
 {
 	profile_tick(CPU_PROFILING);
 }
@@ -148,7 +148,7 @@ static void handle_profile(struct pt_reg
 /*
  * Noop handler when we shut down an event device
  */
-static void handle_noop(struct pt_regs *regs)
+static void handle_noop(void)
 {
 }
 
@@ -508,7 +508,7 @@ int clockevents_set_next_event(ktime_t e
 cpumask_t tick_broadcast_mask;
 cpumask_t event_broadcast_mask;
 static void (*broadcast_function)(cpumask_t *mask);
-static void (*global_event_handler)(struct pt_regs *regs);
+static void (*global_event_handler)(void);
 
 /*
  * Reprogram the broadcast device:
@@ -602,17 +602,17 @@ void clockevents_set_global_broadcast(st
 /*
  * Broadcast tick handler:
  */
-static void handle_tick_broadcast(struct pt_regs *regs)
+static void handle_tick_broadcast(void)
 {
 	/* Call the original handler global tick handler */
-	global_event_handler(regs);
+	global_event_handler();
 	broadcast_function(&tick_broadcast_mask);
 }
 
 /*
  * Broadcast next event handler:
  */
-static void handle_nextevt_broadcast(struct pt_regs *regs)
+static void handle_nextevt_broadcast(void)
 {
 	struct local_events *devices;
 	ktime_t now = ktime_get();
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
clockevents-remove-ptregs-argument-from-handlers.patch

