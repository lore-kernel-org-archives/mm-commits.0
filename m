From: akpm@osdl.org
Subject: - clockevents-i386-drivers.patch removed from -mm tree
Date: Wed, 24 Jan 2007 22:12:22 -0800
Message-ID: <200701250612.l0P6CMEO007783@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49622 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965523AbXAYGYw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:24:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, akpm@osdl.org, arjan@infradead.org, bunk@stusta.de, johnstul@us.ibm.com, mingo@elte.hu, vgoyal@in.ibm.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clockevents: i386 drivers
has been removed from the -mm tree.  Its filename was
     clockevents-i386-drivers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: clockevents: i386 drivers
From: Thomas Gleixner <tglx@linutronix.de>

Add clockevent drivers for i386: lapic (local) and PIT (global).  Update
the timer IRQ to call into the PIT driver's event handler and the
lapic-timer IRQ to call into the lapic clockevent driver.  The
assignement of timer functionality is delegated to the core framework
code and replaces the compile and runtime evalution in
do_timer_interrupt_hook()

Use the clockevents broadcast support and implement the lapic_broadcast
function for ACPI.

No changes to existing functionality.

[ kdump fix from Vivek Goyal <vgoyal@in.ibm.com> ]
[ fixes based on review feedback from Arjan van de Ven <arjan@infradead.org> ]

Cleanups-from: Adrian Bunk <bunk@stusta.de>
Build-fixes-from: Andrew Morton <akpm@osdl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-parameters.txt      |    5 
 arch/i386/Kconfig                        |    8 
 arch/i386/kernel/apic.c                  |  290 ++++++++++++---------
 arch/i386/kernel/i8253.c                 |   88 +++++-
 arch/i386/kernel/smpboot.c               |    5 
 arch/i386/kernel/time.c                  |   50 ---
 arch/i386/kernel/time_hpet.c             |    5 
 include/asm-i386/apic.h                  |    5 
 include/asm-i386/hpet.h                  |    1 
 include/asm-i386/i8253.h                 |   15 +
 include/asm-i386/mach-default/do_timer.h |   26 -
 include/asm-i386/mach-voyager/do_timer.h |   15 -
 include/asm-i386/mpspec.h                |    1 
 13 files changed, 291 insertions(+), 223 deletions(-)

diff -puN Documentation/kernel-parameters.txt~clockevents-i386-drivers Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~clockevents-i386-drivers
+++ a/Documentation/kernel-parameters.txt
@@ -763,6 +763,11 @@ and is between 256 and 4096 characters. 
 	lapic		[IA-32,APIC] Enable the local APIC even if BIOS
 			disabled it.
 
+	lapictimer	[IA-32,APIC] Enable the local APIC timer on UP
+			systems for high resulution timers and dynticks.
+			This only has an effect when the local APIC is
+			available. It does not imply the "lapic" option.
+
 	lasi=		[HW,SCSI] PARISC LASI driver for the 53c700 chip
 			Format: addr:<io>,irq:<irq>
 
diff -puN arch/i386/Kconfig~clockevents-i386-drivers arch/i386/Kconfig
--- a/arch/i386/Kconfig~clockevents-i386-drivers
+++ a/arch/i386/Kconfig
@@ -18,6 +18,14 @@ config GENERIC_TIME
 	bool
 	default y
 
+config GENERIC_CLOCKEVENTS
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+	default y
+
 config LOCKDEP_SUPPORT
 	bool
 	default y
diff -puN arch/i386/kernel/apic.c~clockevents-i386-drivers arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~clockevents-i386-drivers
+++ a/arch/i386/kernel/apic.c
@@ -25,6 +25,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/cpu.h>
+#include <linux/clockchips.h>
 #include <linux/module.h>
 
 #include <asm/atomic.h>
@@ -52,28 +53,48 @@
 #endif
 
 /*
- * cpu_mask that denotes the CPUs that needs timer interrupt coming in as
- * IPIs in place of local APIC timers
- */
-static cpumask_t timer_bcast_ipi;
-
-/*
  * Knob to control our willingness to enable the local APIC.
  *
  * -1=force-disable, +1=force-enable
  */
 static int enable_local_apic __initdata = 0;
 
+/* Enable local APIC timer for highres/dyntick on UP */
+static int enable_local_apic_timer __initdata = 0;
+
 /*
  * Debug level, exported for io_apic.c
  */
 int apic_verbosity;
 
-static void apic_pm_activate(void);
+static unsigned int calibration_result;
 
+static void lapic_next_event(unsigned long delta,
+			     struct clock_event_device *evt);
+static void lapic_timer_setup(enum clock_event_mode mode,
+			      struct clock_event_device *evt);
+static void apic_pm_activate(void);
 
-/* Using APIC to generate smp_local_timer_interrupt? */
-int using_apic_timer __read_mostly = 0;
+/*
+ * The local apic timer can be used for any function which is CPU local.
+ */
+static struct clock_event_device lapic_clockevent = {
+	.name = "lapic",
+	.capabilities = CLOCK_CAP_PROFILE
+#ifdef CONFIG_SMP
+	/*
+	 * On UP we keep update_process_times() on the PIT interrupt to
+	 * resemble the original behaviour as close as possible. SMP
+	 * requires to run this CPU local.
+	 */
+			| CLOCK_CAP_UPDATE
+#endif
+	,
+	.shift = 32,
+	.set_mode = lapic_timer_setup,
+	.set_next_event = lapic_next_event,
+};
+static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
 /* Local APIC was disabled by the BIOS and enabled by the kernel */
 static int enabled_via_apicbase;
@@ -152,6 +173,11 @@ int lapic_get_maxlvt(void)
  */
 
 /*
+ * FIXME: Move this to i8253.h. There is no need to keep the access to
+ * the PIT scattered all around the place -tglx
+ */
+
+/*
  * The timer chip is already set up at HZ interrupts per second here,
  * but we do not accept timer interrupts yet. We only allow the BP
  * to calibrate.
@@ -209,16 +235,17 @@ void (*wait_timer_tick)(void) __devinitd
 
 #define APIC_DIVISOR 16
 
-static void __setup_APIC_LVTT(unsigned int clocks)
+static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
 	unsigned int lvtt_value, tmp_value;
-	int cpu = smp_processor_id();
 
-	lvtt_value = APIC_LVT_TIMER_PERIODIC | LOCAL_TIMER_VECTOR;
+	lvtt_value = LOCAL_TIMER_VECTOR;
+	if (!oneshot)
+		lvtt_value |= APIC_LVT_TIMER_PERIODIC;
 	if (!lapic_is_integrated())
 		lvtt_value |= SET_APIC_TIMER_BASE(APIC_TIMER_BASE_DIV);
 
-	if (cpu_isset(cpu, timer_bcast_ipi))
+	if (!irqen)
 		lvtt_value |= APIC_LVT_MASKED;
 
 	apic_write_around(APIC_LVTT, lvtt_value);
@@ -231,31 +258,67 @@ static void __setup_APIC_LVTT(unsigned i
 				& ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE))
 				| APIC_TDR_DIV_16);
 
-	apic_write_around(APIC_TMICT, clocks/APIC_DIVISOR);
+	if (!oneshot)
+		apic_write_around(APIC_TMICT, clocks/APIC_DIVISOR);
 }
 
-static void __devinit setup_APIC_timer(unsigned int clocks)
+/*
+ * Program the next event, relative to now
+ */
+static void lapic_next_event(unsigned long delta,
+			     struct clock_event_device *evt)
+{
+	apic_write_around(APIC_TMICT, delta);
+}
+
+/*
+ * Setup the lapic timer in periodic or oneshot mode
+ */
+static void lapic_timer_setup(enum clock_event_mode mode,
+			      struct clock_event_device *evt)
 {
 	unsigned long flags;
+	unsigned int v;
 
 	local_irq_save(flags);
 
-	/*
-	 * Wait for IRQ0's slice:
-	 */
-	wait_timer_tick();
-
-	__setup_APIC_LVTT(clocks);
+	switch (mode) {
+	case CLOCK_EVT_PERIODIC:
+	case CLOCK_EVT_ONESHOT:
+		__setup_APIC_LVTT(calibration_result,
+				  mode != CLOCK_EVT_PERIODIC, 1);
+		break;
+	case CLOCK_EVT_SHUTDOWN:
+		v = apic_read(APIC_LVTT);
+		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+		apic_write_around(APIC_LVTT, v);
+		break;
+	}
 
 	local_irq_restore(flags);
 }
 
 /*
+ * Setup the local APIC timer for this CPU. Copy the initilized values
+ * of the boot CPU and register the clock event in the framework.
+ */
+static void __devinit setup_APIC_timer(void)
+{
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
+
+	memcpy(levt, &lapic_clockevent, sizeof(*levt));
+
+	register_local_clockevent(levt);
+}
+
+/*
  * In this function we calibrate APIC bus clocks to the external
  * timer. Unfortunately we cannot use jiffies and the timer irq
  * to calibrate, since some later bootup code depends on getting
  * the first irq? Ugh.
  *
+ * TODO: Fix this rather than saying "Ugh" -tglx
+ *
  * We want to do the calibration only once since we
  * want to have local timer irqs syncron. CPUs connected
  * by the same APIC bus have the very same bus frequency.
@@ -278,7 +341,7 @@ static int __init calibrate_APIC_clock(v
 	 * value into the APIC clock, we just want to get the
 	 * counter running for calibration.
 	 */
-	__setup_APIC_LVTT(1000000000);
+	__setup_APIC_LVTT(1000000000, 0, 0);
 
 	/*
 	 * The timer chip counts down to zero. Let's wait
@@ -315,6 +378,17 @@ static int __init calibrate_APIC_clock(v
 
 	result = (tt1-tt2)*APIC_DIVISOR/LOOPS;
 
+	/* Calculate the scaled math multiplication factor */
+	lapic_clockevent.mult = div_sc(tt1-tt2, TICK_NSEC * LOOPS, 32);
+	lapic_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+	lapic_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &lapic_clockevent);
+
+	apic_printk(APIC_VERBOSE, "..... tt1-tt2 %ld\n", tt1 - tt2);
+	apic_printk(APIC_VERBOSE, "..... mult: %ld\n", lapic_clockevent.mult);
+	apic_printk(APIC_VERBOSE, "..... calibration result: %ld\n", result);
+
 	if (cpu_has_tsc)
 		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
 			"%ld.%04ld MHz.\n",
@@ -329,13 +403,10 @@ static int __init calibrate_APIC_clock(v
 	return result;
 }
 
-static unsigned int calibration_result;
-
 void __init setup_boot_APIC_clock(void)
 {
 	unsigned long flags;
 	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n");
-	using_apic_timer = 1;
 
 	local_irq_save(flags);
 
@@ -343,97 +414,82 @@ void __init setup_boot_APIC_clock(void)
 	/*
 	 * Now set up the timer for real.
 	 */
-	setup_APIC_timer(calibration_result);
+	setup_APIC_timer();
 
 	local_irq_restore(flags);
 }
 
 void __devinit setup_secondary_APIC_clock(void)
 {
-	setup_APIC_timer(calibration_result);
-}
-
-void disable_APIC_timer(void)
-{
-	if (using_apic_timer) {
-		unsigned long v;
-
-		v = apic_read(APIC_LVTT);
-		/*
-		 * When an illegal vector value (0-15) is written to an LVT
-		 * entry and delivery mode is Fixed, the APIC may signal an
-		 * illegal vector error, with out regard to whether the mask
-		 * bit is set or whether an interrupt is actually seen on
-		 * input.
-		 *
-		 * Boot sequence might call this function when the LVTT has
-		 * '0' vector value. So make sure vector field is set to
-		 * valid value.
-		 */
-		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
-		apic_write_around(APIC_LVTT, v);
-	}
-}
-
-void enable_APIC_timer(void)
-{
-	int cpu = smp_processor_id();
-
-	if (using_apic_timer && !cpu_isset(cpu, timer_bcast_ipi)) {
-		unsigned long v;
-
-		v = apic_read(APIC_LVTT);
-		apic_write_around(APIC_LVTT, v & ~APIC_LVT_MASKED);
-	}
+	setup_APIC_timer();
 }
 
 void switch_APIC_timer_to_ipi(void *cpumask)
 {
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 	cpumask_t mask = *(cpumask_t *)cpumask;
 	int cpu = smp_processor_id();
 
-	if (cpu_isset(cpu, mask) &&
-	    !cpu_isset(cpu, timer_bcast_ipi)) {
-		disable_APIC_timer();
-		cpu_set(cpu, timer_bcast_ipi);
-	}
+	if (cpu_isset(cpu, mask) && levt->event_handler)
+		clockevents_set_global_broadcast(levt, 1);
 }
-EXPORT_SYMBOL(switch_APIC_timer_to_ipi);
+EXPORT_SYMBOL_GPL(switch_APIC_timer_to_ipi);
 
 void switch_ipi_to_APIC_timer(void *cpumask)
 {
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 	cpumask_t mask = *(cpumask_t *)cpumask;
 	int cpu = smp_processor_id();
 
-	if (cpu_isset(cpu, mask) &&
-	    cpu_isset(cpu, timer_bcast_ipi)) {
-		cpu_clear(cpu, timer_bcast_ipi);
-		enable_APIC_timer();
-	}
+	if (cpu_isset(cpu, mask) && levt->event_handler)
+		clockevents_set_global_broadcast(levt, 0);
 }
-EXPORT_SYMBOL(switch_ipi_to_APIC_timer);
+EXPORT_SYMBOL_GPL(switch_ipi_to_APIC_timer);
 
 /*
- * Local timer interrupt handler. It does both profiling and
- * process statistics/rescheduling.
+ * The guts of the apic timer interrupt
  */
-inline void smp_local_timer_interrupt(void)
+static void local_apic_timer_interrupt(void)
 {
-	profile_tick(CPU_PROFILING);
-#ifdef CONFIG_SMP
-	update_process_times(user_mode_vm(get_irq_regs()));
-#endif
+	int cpu = smp_processor_id();
+	struct clock_event_device *evt = &per_cpu(lapic_events, cpu);
 
 	/*
-	 * We take the 'long' return path, and there every subsystem
-	 * grabs the apropriate locks (kernel lock/ irq lock).
+	 * Normally we should not be here till LAPIC has been initialized but
+	 * in some cases like kdump, its possible that there is a pending LAPIC
+	 * timer interrupt from previous kernel's context and is delivered in
+	 * new kernel the moment interrupts are enabled.
 	 *
-	 * we might want to decouple profiling from the 'long path',
-	 * and do the profiling totally in assembly.
+	 * Interrupts are enabled early and LAPIC is setup much later, hence
+	 * its possible that when we get here evt->event_handler is NULL.
+	 * Check for event_handler being NULL and discard the interrupt as
+	 * spurious.
+	 */
+	if (!evt->event_handler) {
+		printk(KERN_WARNING
+		       "Spurious LAPIC timer interrupt on cpu %d\n", cpu);
+		return;
+	}
+
+	/* Normally we should not be here till LAPIC has been initialized
+	 * but in some cases like kdump, its possible that there is a
+	 * pending LAPIC timer interrupt from previous kernel's context
+	 * and is delivered in new kernel the moment interrupts are enabled.
 	 *
-	 * Currently this isn't too much of an issue (performance wise),
-	 * we can take more than 100K local irqs per second on a 100 MHz P5.
+	 * Interrupts are enabled early and LAPIC is setup much later, hence
+	 * its possible that when we get here evt->event_handler is NULL.
+	 * Check for event_handler being NULL and discard the interrupt
+	 * as spurious.
 	 */
+
+	if (!evt->event_handler) {
+		printk("Spurious LAPIC timer interrupt on cpu %d\n", cpu);
+		return;
+	}
+
+	per_cpu(irq_stat, cpu).apic_timer_irqs++;
+
+	evt->event_handler();
 }
 
 /*
@@ -445,15 +501,9 @@ inline void smp_local_timer_interrupt(vo
  *   interrupt as well. Thus we cannot inline the local irq ... ]
  */
 
-fastcall void smp_apic_timer_interrupt(struct pt_regs *regs)
+void fastcall smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	int cpu = smp_processor_id();
-
-	/*
-	 * the NMI deadlock-detector uses this.
-	 */
-	per_cpu(irq_stat, cpu).apic_timer_irqs++;
 
 	/*
 	 * NOTE! We'd better ACK the irq immediately,
@@ -467,42 +517,24 @@ fastcall void smp_apic_timer_interrupt(s
 	 */
 	exit_idle();
 	irq_enter();
-	smp_local_timer_interrupt();
+	local_apic_timer_interrupt();
 	irq_exit();
+
 	set_irq_regs(old_regs);
 }
 
-#ifndef CONFIG_SMP
-static void up_apic_timer_interrupt_call(void)
+/*
+ * Local APIC set next event broadcast
+ */
+void lapic_timer_idle_broadcast(int broadcast)
 {
 	int cpu = smp_processor_id();
+	struct clock_event_device *evt = &per_cpu(lapic_events, cpu);
 
-	/*
-	 * the NMI deadlock-detector uses this.
-	 */
-	per_cpu(irq_stat, cpu).apic_timer_irqs++;
-
-	smp_local_timer_interrupt();
-}
-#endif
-
-void smp_send_timer_broadcast_ipi(void)
-{
-	cpumask_t mask;
-
-	cpus_and(mask, cpu_online_map, timer_bcast_ipi);
-	if (!cpus_empty(mask)) {
-#ifdef CONFIG_SMP
-		send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
-#else
-		/*
-		 * We can directly call the apic timer interrupt handler
-		 * in UP case. Minus all irq related functions
-		 */
-		up_apic_timer_interrupt_call();
-#endif
-	}
+	if (evt->event_handler)
+		clockevents_set_broadcast(evt, broadcast);
 }
+EXPORT_SYMBOL_GPL(lapic_timer_idle_broadcast);
 
 int setup_profiling_timer(unsigned int multiplier)
 {
@@ -914,6 +946,11 @@ void __devinit setup_local_APIC(void)
 			printk(KERN_INFO "No ESR for 82489DX.\n");
 	}
 
+	/* Disable the local apic timer */
+	value = apic_read(APIC_LVTT);
+	value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+	apic_write_around(APIC_LVTT, value);
+
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
 }
@@ -1128,6 +1165,13 @@ static int __init parse_nolapic(char *ar
 }
 early_param("nolapic", parse_nolapic);
 
+static int __init apic_enable_lapic_timer(char *str)
+{
+	enable_local_apic_timer = 1;
+	return 0;
+}
+early_param("lapictimer", apic_enable_lapic_timer);
+
 static int __init apic_set_verbosity(char *str)
 {
 	if (strcmp("debug", str) == 0)
@@ -1147,7 +1191,7 @@ __setup("apic=", apic_set_verbosity);
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
-fastcall void smp_spurious_interrupt(struct pt_regs *regs)
+void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	unsigned long v;
 
@@ -1171,7 +1215,7 @@ fastcall void smp_spurious_interrupt(str
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
-fastcall void smp_error_interrupt(struct pt_regs *regs)
+void smp_error_interrupt(struct pt_regs *regs)
 {
 	unsigned long v, v1;
 
diff -puN arch/i386/kernel/i8253.c~clockevents-i386-drivers arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~clockevents-i386-drivers
+++ a/arch/i386/kernel/i8253.c
@@ -2,7 +2,7 @@
  * i8253.c  8253/PIT functions
  *
  */
-#include <linux/clocksource.h>
+#include <linux/clockchips.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/sysdev.h>
@@ -19,20 +19,92 @@
 DEFINE_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
-void setup_pit_timer(void)
+/*
+ * HPET replaces the PIT, when enabled. So we need to know, which of
+ * the two timers is used
+ */
+struct clock_event_device *global_clock_event;
+
+/*
+ * Initialize the PIT timer.
+ *
+ * This is also called after resume to bring the PIT into operation again.
+ */
+static void init_pit_timer(enum clock_event_mode mode,
+			   struct clock_event_device *evt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&i8253_lock, flags);
+
+	switch(mode) {
+	case CLOCK_EVT_PERIODIC:
+		/* binary, mode 2, LSB/MSB, ch 0 */
+		outb_p(0x34, PIT_MODE);
+		udelay(10);
+		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
+		udelay(10);
+		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
+		break;
+
+	case CLOCK_EVT_ONESHOT:
+	case CLOCK_EVT_SHUTDOWN:
+		/* One shot setup */
+		outb_p(0x38, PIT_MODE);
+		udelay(10);
+		break;
+	}
+	spin_unlock_irqrestore(&i8253_lock, flags);
+}
+
+/*
+ * Program the next event in oneshot mode
+ *
+ * Delta is given in PIT ticks
+ */
+static void pit_next_event(unsigned long delta, struct clock_event_device *evt)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&i8253_lock, flags);
-	outb_p(0x34,PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
-	udelay(10);
-	outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
-	udelay(10);
-	outb(LATCH >> 8 , PIT_CH0);	/* MSB */
+	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
+	outb(delta >> 8 , PIT_CH0);	/* MSB */
 	spin_unlock_irqrestore(&i8253_lock, flags);
 }
 
 /*
+ * On UP the PIT can serve all of the possible timer functions. On SMP systems
+ * it can be solely used for the global tick.
+ *
+ * The profiling and update capabilites are switched off once the local apic is
+ * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
+ * !using_apic_timer decisions in do_timer_interrupt_hook()
+ */
+struct clock_event_device pit_clockevent = {
+	.name		= "pit",
+	.capabilities	= CLOCK_CAP_TICK | CLOCK_CAP_PROFILE | CLOCK_CAP_UPDATE
+			| CLOCK_CAP_NEXTEVT,
+	.set_mode	= init_pit_timer,
+	.set_next_event = pit_next_event,
+	.shift		= 32,
+};
+
+/*
+ * Initialize the conversion factor and the min/max deltas of the clock event
+ * structure and register the clock event source with the framework.
+ */
+void __init setup_pit_timer(void)
+{
+	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, 32);
+	pit_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFF, &pit_clockevent);
+	pit_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &pit_clockevent);
+	register_global_clockevent(&pit_clockevent);
+	global_clock_event = &pit_clockevent;
+}
+
+/*
  * Since the PIT overflows every tick, its not very useful
  * to just read by itself. So use jiffies to emulate a free
  * running counter:
@@ -46,7 +118,7 @@ static cycle_t pit_read(void)
 	static u32 old_jifs;
 
 	spin_lock_irqsave(&i8253_lock, flags);
-        /*
+	/*
 	 * Although our caller may have the read side of xtime_lock,
 	 * this is now a seqlock, and we are cheating in this routine
 	 * by having side effects on state that we cannot undo if
diff -puN arch/i386/kernel/smpboot.c~clockevents-i386-drivers arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~clockevents-i386-drivers
+++ a/arch/i386/kernel/smpboot.c
@@ -437,9 +437,7 @@ static void __cpuinit smp_callin(void)
 	/*
 	 * Save our processor parameters
 	 */
- 	smp_store_cpu_info(cpuid);
-
-	disable_APIC_timer();
+	smp_store_cpu_info(cpuid);
 
 	/*
 	 * Allow the master to continue.
@@ -559,7 +557,6 @@ static void __cpuinit start_secondary(vo
 		enable_NMI_through_LVT0(NULL);
 		enable_8259A_irq(0);
 	}
-	enable_APIC_timer();
 	/*
 	 * low-memory mappings have been cleared, flush them from
 	 * the local TLBs too.
diff -puN arch/i386/kernel/time.c~clockevents-i386-drivers arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c~clockevents-i386-drivers
+++ a/arch/i386/kernel/time.c
@@ -161,15 +161,6 @@ EXPORT_SYMBOL(profile_pc);
  */
 irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
-	/*
-	 * Here we are in the timer irq handler. We just have irqs locally
-	 * disabled but we don't know if the timer_bh is running on the other
-	 * CPU. We need to avoid to SMP race with it. NOTE: we don' t need
-	 * the irq version of write_lock because as just said we have irq
-	 * locally disabled. -arca
-	 */
-	write_seqlock(&xtime_lock);
-
 #ifdef CONFIG_X86_IO_APIC
 	if (timer_ack) {
 		/*
@@ -188,7 +179,6 @@ irqreturn_t timer_interrupt(int irq, voi
 
 	do_timer_interrupt_hook();
 
-
 	if (MCA_bus) {
 		/* The PS/2 uses level-triggered interrupts.  You can't
 		turn them off, nor would you want to (any attempt to
@@ -203,13 +193,6 @@ irqreturn_t timer_interrupt(int irq, voi
 		outb_p( irq_v|0x80, 0x61 );	/* reset the IRQ */
 	}
 
-	write_sequnlock(&xtime_lock);
-
-#ifdef CONFIG_X86_LOCAL_APIC
-	if (using_apic_timer)
-		smp_send_timer_broadcast_ipi();
-#endif
-
 	return IRQ_HANDLED;
 }
 
@@ -279,39 +262,6 @@ void notify_arch_cmos_timer(void)
 		mod_timer(&sync_cmos_timer, jiffies + 1);
 }
 
-static int timer_resume(struct sys_device *dev)
-{
-#ifdef CONFIG_HPET_TIMER
-	if (is_hpet_enabled())
-		hpet_reenable();
-#endif
-	setup_pit_timer();
-	touch_softlockup_watchdog();
-	return 0;
-}
-
-static struct sysdev_class timer_sysclass = {
-	.resume = timer_resume,
-	set_kset_name("timer"),
-};
-
-
-/* XXX this driverfs stuff should probably go elsewhere later -john */
-static struct sys_device device_timer = {
-	.id	= 0,
-	.cls	= &timer_sysclass,
-};
-
-static int time_init_device(void)
-{
-	int error = sysdev_class_register(&timer_sysclass);
-	if (!error)
-		error = sysdev_register(&device_timer);
-	return error;
-}
-
-device_initcall(time_init_device);
-
 #ifdef CONFIG_HPET_TIMER
 extern void (*late_time_init)(void);
 /* Duplicate of time_init() below, with hpet_enable part added */
diff -puN arch/i386/kernel/time_hpet.c~clockevents-i386-drivers arch/i386/kernel/time_hpet.c
--- a/arch/i386/kernel/time_hpet.c~clockevents-i386-drivers
+++ a/arch/i386/kernel/time_hpet.c
@@ -221,11 +221,6 @@ int __init hpet_enable(void)
 	return 0;
 }
 
-int hpet_reenable(void)
-{
-	return hpet_timer_stop_set_go(hpet_tick);
-}
-
 int is_hpet_enabled(void)
 {
 	return use_hpet;
diff -puN include/asm-i386/apic.h~clockevents-i386-drivers include/asm-i386/apic.h
--- a/include/asm-i386/apic.h~clockevents-i386-drivers
+++ a/include/asm-i386/apic.h
@@ -113,13 +113,10 @@ extern void smp_local_timer_interrupt (v
 extern void setup_boot_APIC_clock (void);
 extern void setup_secondary_APIC_clock (void);
 extern int APIC_init_uniprocessor (void);
-extern void disable_APIC_timer(void);
-extern void enable_APIC_timer(void);
-static inline void lapic_timer_idle_broadcast(int broadcast) { }
+extern void lapic_timer_idle_broadcast(int broadcast);
 
 extern void enable_NMI_through_LVT0 (void * dummy);
 
-void smp_send_timer_broadcast_ipi(void);
 void switch_APIC_timer_to_ipi(void *cpumask);
 void switch_ipi_to_APIC_timer(void *cpumask);
 #define ARCH_APICTIMER_STOPS_ON_C3	1
diff -puN include/asm-i386/hpet.h~clockevents-i386-drivers include/asm-i386/hpet.h
--- a/include/asm-i386/hpet.h~clockevents-i386-drivers
+++ a/include/asm-i386/hpet.h
@@ -96,7 +96,6 @@ extern int hpet_use_timer;
 
 extern int hpet_rtc_timer_init(void);
 extern int hpet_enable(void);
-extern int hpet_reenable(void);
 extern int is_hpet_enabled(void);
 extern int is_hpet_capable(void);
 extern int hpet_readl(unsigned long a);
diff -puN include/asm-i386/i8253.h~clockevents-i386-drivers include/asm-i386/i8253.h
--- a/include/asm-i386/i8253.h~clockevents-i386-drivers
+++ a/include/asm-i386/i8253.h
@@ -1,6 +1,21 @@
 #ifndef __ASM_I8253_H__
 #define __ASM_I8253_H__
 
+#include <linux/clockchips.h>
+
 extern spinlock_t i8253_lock;
 
+extern struct clock_event_device *global_clock_event;
+
+/**
+ * pit_interrupt_hook - hook into timer tick
+ * @regs:	standard registers from interrupt
+ *
+ * Call the global clock event handler.
+ **/
+static inline void pit_interrupt_hook(void)
+{
+	global_clock_event->event_handler();
+}
+
 #endif	/* __ASM_I8253_H__ */
diff -puN include/asm-i386/mach-default/do_timer.h~clockevents-i386-drivers include/asm-i386/mach-default/do_timer.h
--- a/include/asm-i386/mach-default/do_timer.h~clockevents-i386-drivers
+++ a/include/asm-i386/mach-default/do_timer.h
@@ -1,36 +1,18 @@
 /* defines for inline arch setup functions */
+#include <linux/clockchips.h>
 
-#include <asm/apic.h>
 #include <asm/i8259.h>
+#include <asm/i8253.h>
 
 /**
  * do_timer_interrupt_hook - hook into timer tick
- * @regs:	standard registers from interrupt
  *
- * Description:
- *	This hook is called immediately after the timer interrupt is ack'd.
- *	It's primary purpose is to allow architectures that don't possess
- *	individual per CPU clocks (like the CPU APICs supply) to broadcast the
- *	timer interrupt as a means of triggering reschedules etc.
+ * Call the pit clock event handler. see asm/i8253.h
  **/
 
 static inline void do_timer_interrupt_hook(void)
 {
-	do_timer(1);
-#ifndef CONFIG_SMP
-	update_process_times(user_mode_vm(get_irq_regs()));
-#endif
-/*
- * In the SMP case we use the local APIC timer interrupt to do the
- * profiling, except when we simulate SMP mode on a uniprocessor
- * system, in that case we have to call the local interrupt handler.
- */
-#ifndef CONFIG_X86_LOCAL_APIC
-	profile_tick(CPU_PROFILING);
-#else
-	if (!using_apic_timer)
-		smp_local_timer_interrupt();
-#endif
+	pit_interrupt_hook();
 }
 
 
diff -puN include/asm-i386/mach-voyager/do_timer.h~clockevents-i386-drivers include/asm-i386/mach-voyager/do_timer.h
--- a/include/asm-i386/mach-voyager/do_timer.h~clockevents-i386-drivers
+++ a/include/asm-i386/mach-voyager/do_timer.h
@@ -1,13 +1,18 @@
 /* defines for inline arch setup functions */
+#include <linux/clockchips.h>
+
 #include <asm/voyager.h>
+#include <asm/i8253.h>
 
+/**
+ * do_timer_interrupt_hook - hook into timer tick
+ * @regs:     standard registers from interrupt
+ *
+ * Call the pit clock event handler. see asm/i8253.h
+ **/
 static inline void do_timer_interrupt_hook(void)
 {
-	do_timer(1);
-#ifndef CONFIG_SMP
-	update_process_times(user_mode_vm(irq_regs));
-#endif
-
+	pit_interrupt_hook(get_irq_regs());
 	voyager_timer_interrupt();
 }
 
diff -puN include/asm-i386/mpspec.h~clockevents-i386-drivers include/asm-i386/mpspec.h
--- a/include/asm-i386/mpspec.h~clockevents-i386-drivers
+++ a/include/asm-i386/mpspec.h
@@ -23,7 +23,6 @@ extern struct mpc_config_intsrc mp_irqs 
 extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;
 extern int pic_mode;
-extern int using_apic_timer;
 
 #ifdef CONFIG_ACPI
 extern void mp_register_lapic (u8 id, u8 enabled);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
clockevents-i386-drivers.patch
clockevents-i386-drivers-high-res-timers-fix-apic-event-broadcasting-code.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch
high-res-timers-core-hrtimers-add-state-tracking-fix.patch
high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
