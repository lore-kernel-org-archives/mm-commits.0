From: akpm@osdl.org
Subject: + clockevents-i383-drivers.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:36:53 -0800
Message-ID: <200701250636.l0P6arCe008383@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50472 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965599AbXAYGjb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:39:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, akpm@osdl.org, arjan@infradead.org, bunk@stusta.de, johnstul@us.ibm.com, mingo@elte.hu, vgoyal@in.ibm.com, zippel@linux-m68k.org


The patch titled
     clockevents: i386 drivers
has been added to the -mm tree.  Its filename is
     clockevents-i383-drivers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clockevents: i386 drivers
From: Thomas Gleixner <tglx@linutronix.de>

Add clockevent drivers for i386: lapic (local) and PIT/HPET (global).  Update
the timer IRQ to call into the PIT/HPET driver's event handler and the
lapic-timer IRQ to call into the lapic clockevent driver.  The assignement of
timer functionality is delegated to the core framework code and replaces the
compile and runtime evalution in do_timer_interrupt_hook()

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
 arch/i386/kernel/Makefile                |    1 
 arch/i386/kernel/apic.c                  |  291 ++++++------
 arch/i386/kernel/hpet.c                  |  497 ++++++++++++++++++++-
 arch/i386/kernel/i8253.c                 |   96 +++-
 arch/i386/kernel/i8259.c                 |    6 
 arch/i386/kernel/smpboot.c               |    5 
 arch/i386/kernel/time.c                  |   70 --
 arch/i386/kernel/time_hpet.c             |  497 ---------------------
 arch/i386/mach-default/setup.c           |    8 
 drivers/acpi/processor_idle.c            |   38 +
 include/asm-i386/apic.h                  |    5 
 include/asm-i386/hpet.h                  |   16 
 include/asm-i386/i8253.h                 |   15 
 include/asm-i386/mach-default/do_timer.h |   78 ---
 include/asm-i386/mach-voyager/do_timer.h |   27 -
 include/asm-i386/mpspec.h                |    1 
 18 files changed, 815 insertions(+), 849 deletions(-)

diff -puN Documentation/kernel-parameters.txt~clockevents-i383-drivers Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~clockevents-i383-drivers
+++ a/Documentation/kernel-parameters.txt
@@ -768,6 +768,11 @@ and is between 256 and 4096 characters. 
 	lapic		[IA-32,APIC] Enable the local APIC even if BIOS
 			disabled it.
 
+	lapictimer	[IA-32,APIC] Enable the local APIC timer on UP
+			systems for high resulution timers and dynticks.
+			This only has an effect when the local APIC is
+			available. It does not imply the "lapic" option.
+
 	lasi=		[HW,SCSI] PARISC LASI driver for the 53c700 chip
 			Format: addr:<io>,irq:<irq>
 
diff -puN arch/i386/Kconfig~clockevents-i383-drivers arch/i386/Kconfig
--- a/arch/i386/Kconfig~clockevents-i383-drivers
+++ a/arch/i386/Kconfig
@@ -22,6 +22,14 @@ config CLOCKSOURCE_WATCHDOG
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
diff -puN arch/i386/kernel/Makefile~clockevents-i383-drivers arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~clockevents-i383-drivers
+++ a/arch/i386/kernel/Makefile
@@ -32,7 +32,6 @@ obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-y				+= sysenter.o vsyscall.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat.o
-obj-$(CONFIG_HPET_TIMER) 	+= time_hpet.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_stub.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
 obj-$(CONFIG_VM86)		+= vm86.o
diff -puN arch/i386/kernel/apic.c~clockevents-i383-drivers arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~clockevents-i383-drivers
+++ a/arch/i386/kernel/apic.c
@@ -25,6 +25,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/cpu.h>
+#include <linux/clockchips.h>
 #include <linux/module.h>
 
 #include <asm/atomic.h>
@@ -52,28 +53,44 @@
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
 
+static int lapic_next_event(unsigned long delta,
+			    struct clock_event_device *evt);
+static void lapic_timer_setup(enum clock_event_mode mode,
+			      struct clock_event_device *evt);
+static void lapic_timer_broadcast(cpumask_t mask);
+static void apic_pm_activate(void);
 
-/* Using APIC to generate smp_local_timer_interrupt? */
-int using_apic_timer __read_mostly = 0;
+/*
+ * The local apic timer can be used for any function which is CPU local.
+ */
+static struct clock_event_device lapic_clockevent = {
+	.name		= "lapic",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
+			| CLOCK_EVT_FEAT_C3STOP,
+	.shift		= 32,
+	.set_mode	= lapic_timer_setup,
+	.set_next_event	= lapic_next_event,
+	.broadcast	= lapic_timer_broadcast,
+	.rating		= 100,
+	.irq		= -1,
+};
+static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
 /* Local APIC was disabled by the BIOS and enabled by the kernel */
 static int enabled_via_apicbase;
@@ -152,6 +169,11 @@ int lapic_get_maxlvt(void)
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
@@ -209,16 +231,17 @@ void (*wait_timer_tick)(void) __devinitd
 
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
@@ -231,31 +254,78 @@ static void __setup_APIC_LVTT(unsigned i
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
+static int lapic_next_event(unsigned long delta,
+			    struct clock_event_device *evt)
+{
+	apic_write_around(APIC_TMICT, delta);
+	return 0;
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
+	case CLOCK_EVT_MODE_PERIODIC:
+	case CLOCK_EVT_MODE_ONESHOT:
+		__setup_APIC_LVTT(calibration_result,
+				  mode != CLOCK_EVT_MODE_PERIODIC, 1);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		v = apic_read(APIC_LVTT);
+		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+		apic_write_around(APIC_LVTT, v);
+		break;
+	}
 
 	local_irq_restore(flags);
 }
 
 /*
+ * Local APIC timer broadcast function
+ */
+static void lapic_timer_broadcast(cpumask_t mask)
+{
+	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
+}
+
+/*
+ * Setup the local APIC timer for this CPU. Copy the initilized values
+ * of the boot CPU and register the clock event in the framework.
+ */
+static void __devinit setup_APIC_timer(void)
+{
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
+
+	memcpy(levt, &lapic_clockevent, sizeof(*levt));
+	levt->cpumask = cpumask_of_cpu(smp_processor_id());
+
+	clockevents_register_device(levt);
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
@@ -278,7 +348,7 @@ static int __init calibrate_APIC_clock(v
 	 * value into the APIC clock, we just want to get the
 	 * counter running for calibration.
 	 */
-	__setup_APIC_LVTT(1000000000);
+	__setup_APIC_LVTT(1000000000, 0, 0);
 
 	/*
 	 * The timer chip counts down to zero. Let's wait
@@ -315,6 +385,17 @@ static int __init calibrate_APIC_clock(v
 
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
@@ -329,13 +410,10 @@ static int __init calibrate_APIC_clock(v
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
 
@@ -343,97 +421,47 @@ void __init setup_boot_APIC_clock(void)
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
 
-void switch_APIC_timer_to_ipi(void *cpumask)
-{
-	cpumask_t mask = *(cpumask_t *)cpumask;
-	int cpu = smp_processor_id();
-
-	if (cpu_isset(cpu, mask) &&
-	    !cpu_isset(cpu, timer_bcast_ipi)) {
-		disable_APIC_timer();
-		cpu_set(cpu, timer_bcast_ipi);
-	}
-}
-EXPORT_SYMBOL(switch_APIC_timer_to_ipi);
-
-void switch_ipi_to_APIC_timer(void *cpumask)
-{
-	cpumask_t mask = *(cpumask_t *)cpumask;
-	int cpu = smp_processor_id();
-
-	if (cpu_isset(cpu, mask) &&
-	    cpu_isset(cpu, timer_bcast_ipi)) {
-		cpu_clear(cpu, timer_bcast_ipi);
-		enable_APIC_timer();
-	}
-}
-EXPORT_SYMBOL(switch_ipi_to_APIC_timer);
-
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
-	 *
-	 * we might want to decouple profiling from the 'long path',
-	 * and do the profiling totally in assembly.
+	 * Normally we should not be here till LAPIC has been
+	 * initialized but in some cases like kdump, its possible that
+	 * there is a pending LAPIC timer interrupt from previous
+	 * kernel's context and is delivered in new kernel the moment
+	 * interrupts are enabled.
 	 *
-	 * Currently this isn't too much of an issue (performance wise),
-	 * we can take more than 100K local irqs per second on a 100 MHz P5.
-	 */
+	 * Interrupts are enabled early and LAPIC is setup much later,
+	 * hence its possible that when we get here evt->event_handler
+	 * is NULL. Check for event_handler being NULL and discard
+	 * the interrupt as spurious.
+	 */
+	if (!evt->event_handler) {
+		printk(KERN_WARNING
+		       "Spurious LAPIC timer interrupt on cpu %d\n", cpu);
+		/* Switch it off */
+		lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, evt);
+		return;
+	}
+
+	per_cpu(irq_stat, cpu).apic_timer_irqs++;
+
+	evt->event_handler(evt);
 }
 
 /*
@@ -445,15 +473,9 @@ inline void smp_local_timer_interrupt(vo
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
@@ -467,41 +489,10 @@ fastcall void smp_apic_timer_interrupt(s
 	 */
 	exit_idle();
 	irq_enter();
-	smp_local_timer_interrupt();
+	local_apic_timer_interrupt();
 	irq_exit();
-	set_irq_regs(old_regs);
-}
 
-#ifndef CONFIG_SMP
-static void up_apic_timer_interrupt_call(void)
-{
-	int cpu = smp_processor_id();
-
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
+	set_irq_regs(old_regs);
 }
 
 int setup_profiling_timer(unsigned int multiplier)
@@ -914,6 +905,11 @@ void __devinit setup_local_APIC(void)
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
@@ -1128,6 +1124,13 @@ static int __init parse_nolapic(char *ar
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
@@ -1147,7 +1150,7 @@ __setup("apic=", apic_set_verbosity);
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
-fastcall void smp_spurious_interrupt(struct pt_regs *regs)
+void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	unsigned long v;
 
@@ -1171,7 +1174,7 @@ fastcall void smp_spurious_interrupt(str
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
-fastcall void smp_error_interrupt(struct pt_regs *regs)
+void smp_error_interrupt(struct pt_regs *regs)
 {
 	unsigned long v, v1;
 
diff -puN arch/i386/kernel/hpet.c~clockevents-i383-drivers arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~clockevents-i383-drivers
+++ a/arch/i386/kernel/hpet.c
@@ -1,4 +1,5 @@
 #include <linux/clocksource.h>
+#include <linux/clockchips.h>
 #include <linux/errno.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
@@ -6,17 +7,278 @@
 #include <asm/hpet.h>
 #include <asm/io.h>
 
+extern struct clock_event_device *global_clock_event;
+
 #define HPET_MASK	CLOCKSOURCE_MASK(32)
 #define HPET_SHIFT	22
 
 /* FSEC = 10^-15 NSEC = 10^-9 */
 #define FSEC_PER_NSEC	1000000
 
-static void *hpet_ptr;
+/*
+ * HPET address is set in acpi/boot.c, when an ACPI entry exists
+ */
+unsigned long hpet_address;
+static void __iomem * hpet_virt_address;
+
+static inline unsigned long hpet_readl(unsigned long a)
+{
+	return readl(hpet_virt_address + a);
+}
+
+static inline void hpet_writel(unsigned long d, unsigned long a)
+{
+	writel(d, hpet_virt_address + a);
+}
+
+/*
+ * HPET command line enable / disable
+ */
+static int boot_hpet_disable;
+
+static int __init hpet_setup(char* str)
+{
+	if (str) {
+		if (!strncmp("disable", str, 7))
+			boot_hpet_disable = 1;
+	}
+	return 1;
+}
+__setup("hpet=", hpet_setup);
+
+static inline int is_hpet_capable(void)
+{
+	return (!boot_hpet_disable && hpet_address);
+}
+
+/*
+ * HPET timer interrupt enable / disable
+ */
+static int hpet_legacy_int_enabled;
+
+/**
+ * is_hpet_enabled - check whether the hpet timer interrupt is enabled
+ */
+int is_hpet_enabled(void)
+{
+	return is_hpet_capable() && hpet_legacy_int_enabled;
+}
+
+/*
+ * When the hpet driver (/dev/hpet) is enabled, we need to reserve
+ * timer 0 and timer 1 in case of RTC emulation.
+ */
+#ifdef CONFIG_HPET
+static void hpet_reserve_platform_timers(unsigned long id)
+{
+	struct hpet __iomem *hpet = hpet_virt_address;
+	struct hpet_timer __iomem *timer = &hpet->hpet_timers[2];
+	unsigned int nrtimers, i;
+	struct hpet_data hd;
+
+	nrtimers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
+
+	memset(&hd, 0, sizeof (hd));
+	hd.hd_phys_address = hpet_address;
+	hd.hd_address = hpet_virt_address;
+	hd.hd_nirqs = nrtimers;
+	hd.hd_flags = HPET_DATA_PLATFORM;
+	hpet_reserve_timer(&hd, 0);
+
+#ifdef CONFIG_HPET_EMULATE_RTC
+	hpet_reserve_timer(&hd, 1);
+#endif
+
+	hd.hd_irq[0] = HPET_LEGACY_8254;
+	hd.hd_irq[1] = HPET_LEGACY_RTC;
+
+	for (i = 2; i < nrtimers; timer++, i++)
+		hd.hd_irq[i] = (timer->hpet_config & Tn_INT_ROUTE_CNF_MASK) >>
+			Tn_INT_ROUTE_CNF_SHIFT;
+
+	hpet_alloc(&hd);
+
+}
+#else
+static void hpet_reserve_platform_timers(unsigned long id) { }
+#endif
+
+/*
+ * Common hpet info
+ */
+static unsigned long hpet_period;
+
+static void hpet_set_mode(enum clock_event_mode mode,
+			  struct clock_event_device *evt);
+static int hpet_next_event(unsigned long delta,
+			   struct clock_event_device *evt);
+
+/*
+ * The hpet clock event device
+ */
+static struct clock_event_device hpet_clockevent = {
+	.name		= "hpet",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= hpet_set_mode,
+	.set_next_event = hpet_next_event,
+	.shift		= 32,
+	.irq		= 0,
+};
+
+static void hpet_start_counter(void)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
+
+	cfg &= ~HPET_CFG_ENABLE;
+	hpet_writel(cfg, HPET_CFG);
+	hpet_writel(0, HPET_COUNTER);
+	hpet_writel(0, HPET_COUNTER + 4);
+	cfg |= HPET_CFG_ENABLE;
+	hpet_writel(cfg, HPET_CFG);
+}
+
+static void hpet_enable_int(void)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
 
+	cfg |= HPET_CFG_LEGACY;
+	hpet_writel(cfg, HPET_CFG);
+	hpet_legacy_int_enabled = 1;
+}
+
+static void hpet_set_mode(enum clock_event_mode mode,
+			  struct clock_event_device *evt)
+{
+	unsigned long cfg, cmp, now;
+	uint64_t delta;
+
+	switch(mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * hpet_clockevent.mult;
+		delta >>= hpet_clockevent.shift;
+		now = hpet_readl(HPET_COUNTER);
+		cmp = now + (unsigned long) delta;
+		cfg = hpet_readl(HPET_T0_CFG);
+		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
+		       HPET_TN_SETVAL | HPET_TN_32BIT;
+		hpet_writel(cfg, HPET_T0_CFG);
+		/*
+		 * The first write after writing TN_SETVAL to the
+		 * config register sets the counter value, the second
+		 * write sets the period.
+		 */
+		hpet_writel(cmp, HPET_T0_CMP);
+		udelay(1);
+		hpet_writel((unsigned long) delta, HPET_T0_CMP);
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		cfg = hpet_readl(HPET_T0_CFG);
+		cfg &= ~HPET_TN_PERIODIC;
+		cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
+		hpet_writel(cfg, HPET_T0_CFG);
+		break;
+
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		cfg = hpet_readl(HPET_T0_CFG);
+		cfg &= ~HPET_TN_ENABLE;
+		hpet_writel(cfg, HPET_T0_CFG);
+		break;
+	}
+}
+
+static int hpet_next_event(unsigned long delta,
+			   struct clock_event_device *evt)
+{
+	unsigned long cnt;
+
+	cnt = hpet_readl(HPET_COUNTER);
+	cnt += delta;
+	hpet_writel(cnt, HPET_T0_CMP);
+
+	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0);
+}
+
+/*
+ * Try to setup the HPET timer
+ */
+int __init hpet_enable(void)
+{
+	unsigned long id;
+	uint64_t hpet_freq;
+
+	if (!is_hpet_capable())
+		return 0;
+
+	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+
+	/*
+	 * Read the period and check for a sane value:
+	 */
+	hpet_period = hpet_readl(HPET_PERIOD);
+	if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
+		goto out_nohpet;
+
+	/*
+	 * The period is a femto seconds value. We need to calculate the
+	 * scaled math multiplication factor for nanosecond to hpet tick
+	 * conversion.
+	 */
+	hpet_freq = 1000000000000000ULL;
+	do_div(hpet_freq, hpet_period);
+	hpet_clockevent.mult = div_sc((unsigned long) hpet_freq,
+				      NSEC_PER_SEC, 32);
+	/* Calculate the min / max delta */
+	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
+							   &hpet_clockevent);
+	hpet_clockevent.min_delta_ns = clockevent_delta2ns(0x30,
+							   &hpet_clockevent);
+
+	/*
+	 * Read the HPET ID register to retrieve the IRQ routing
+	 * information and the number of channels
+	 */
+	id = hpet_readl(HPET_ID);
+
+#ifdef CONFIG_HPET_EMULATE_RTC
+	/*
+	 * The legacy routing mode needs at least two channels, tick timer
+	 * and the rtc emulation channel.
+	 */
+	if (!(id & HPET_ID_NUMBER))
+		goto out_nohpet;
+#endif
+
+	/* Start the counter */
+	hpet_start_counter();
+
+	if (id & HPET_ID_LEGSUP) {
+		hpet_enable_int();
+		hpet_reserve_platform_timers(id);
+		/*
+		 * Start hpet with the boot cpu mask and make it
+		 * global after the IO_APIC has been initialized.
+		 */
+		hpet_clockevent.cpumask =cpumask_of_cpu(0);
+		clockevents_register_device(&hpet_clockevent);
+		global_clock_event = &hpet_clockevent;
+		return 1;
+	}
+	return 0;
+
+out_nohpet:
+	iounmap(hpet_virt_address);
+	hpet_virt_address = NULL;
+	return 0;
+}
+
+/*
+ * Clock source related code
+ */
 static cycle_t read_hpet(void)
 {
-	return (cycle_t)readl(hpet_ptr);
+	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
 
 static struct clocksource clocksource_hpet = {
@@ -24,29 +286,17 @@ static struct clocksource clocksource_hp
 	.rating		= 250,
 	.read		= read_hpet,
 	.mask		= HPET_MASK,
-	.mult		= 0, /* set below */
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init init_hpet_clocksource(void)
 {
-	unsigned long hpet_period;
-	void __iomem* hpet_base;
 	u64 tmp;
-	int err;
 
-	if (!is_hpet_enabled())
+	if (!hpet_virt_address)
 		return -ENODEV;
 
-	/* calculate the hpet address: */
-	hpet_base =
-		(void __iomem*)ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
-	hpet_ptr = hpet_base + HPET_COUNTER;
-
-	/* calculate the frequency: */
-	hpet_period = readl(hpet_base + HPET_PERIOD);
-
 	/*
 	 * hpet period is in femto seconds per cycle
 	 * so we need to convert this to ns/cyc units
@@ -62,11 +312,218 @@ static int __init init_hpet_clocksource(
 	do_div(tmp, FSEC_PER_NSEC);
 	clocksource_hpet.mult = (u32)tmp;
 
-	err = clocksource_register(&clocksource_hpet);
-	if (err)
-		iounmap(hpet_base);
-
-	return err;
+	return clocksource_register(&clocksource_hpet);
 }
 
 module_init(init_hpet_clocksource);
+
+#ifdef CONFIG_HPET_EMULATE_RTC
+
+/* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET
+ * is enabled, we support RTC interrupt functionality in software.
+ * RTC has 3 kinds of interrupts:
+ * 1) Update Interrupt - generate an interrupt, every sec, when RTC clock
+ *    is updated
+ * 2) Alarm Interrupt - generate an interrupt at a specific time of day
+ * 3) Periodic Interrupt - generate periodic interrupt, with frequencies
+ *    2Hz-8192Hz (2Hz-64Hz for non-root user) (all freqs in powers of 2)
+ * (1) and (2) above are implemented using polling at a frequency of
+ * 64 Hz. The exact frequency is a tradeoff between accuracy and interrupt
+ * overhead. (DEFAULT_RTC_INT_FREQ)
+ * For (3), we use interrupts at 64Hz or user specified periodic
+ * frequency, whichever is higher.
+ */
+#include <linux/mc146818rtc.h>
+#include <linux/rtc.h>
+
+#define DEFAULT_RTC_INT_FREQ	64
+#define DEFAULT_RTC_SHIFT	6
+#define RTC_NUM_INTS		1
+
+static unsigned long hpet_rtc_flags;
+static unsigned long hpet_prev_update_sec;
+static struct rtc_time hpet_alarm_time;
+static unsigned long hpet_pie_count;
+static unsigned long hpet_t1_cmp;
+static unsigned long hpet_default_delta;
+static unsigned long hpet_pie_delta;
+static unsigned long hpet_pie_limit;
+
+/*
+ * Timer 1 for RTC emulation. We use one shot mode, as periodic mode
+ * is not supported by all HPET implementations for timer 1.
+ *
+ * hpet_rtc_timer_init() is called when the rtc is initialized.
+ */
+int hpet_rtc_timer_init(void)
+{
+	unsigned long cfg, cnt, delta, flags;
+
+	if (!is_hpet_enabled())
+		return 0;
+
+	if (!hpet_default_delta) {
+		uint64_t clc;
+
+		clc = (uint64_t) hpet_clockevent.mult * NSEC_PER_SEC;
+		clc >>= hpet_clockevent.shift + DEFAULT_RTC_SHIFT;
+		hpet_default_delta = (unsigned long) clc;
+	}
+
+	if (!(hpet_rtc_flags & RTC_PIE) || hpet_pie_limit)
+		delta = hpet_default_delta;
+	else
+		delta = hpet_pie_delta;
+
+	local_irq_save(flags);
+
+	cnt = delta + hpet_readl(HPET_COUNTER);
+	hpet_writel(cnt, HPET_T1_CMP);
+	hpet_t1_cmp = cnt;
+
+	cfg = hpet_readl(HPET_T1_CFG);
+	cfg &= ~HPET_TN_PERIODIC;
+	cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
+	hpet_writel(cfg, HPET_T1_CFG);
+
+	local_irq_restore(flags);
+
+	return 1;
+}
+
+/*
+ * The functions below are called from rtc driver.
+ * Return 0 if HPET is not being used.
+ * Otherwise do the necessary changes and return 1.
+ */
+int hpet_mask_rtc_irq_bit(unsigned long bit_mask)
+{
+	if (!is_hpet_enabled())
+		return 0;
+
+	hpet_rtc_flags &= ~bit_mask;
+	return 1;
+}
+
+int hpet_set_rtc_irq_bit(unsigned long bit_mask)
+{
+	unsigned long oldbits = hpet_rtc_flags;
+
+	if (!is_hpet_enabled())
+		return 0;
+
+	hpet_rtc_flags |= bit_mask;
+
+	if (!oldbits)
+		hpet_rtc_timer_init();
+
+	return 1;
+}
+
+int hpet_set_alarm_time(unsigned char hrs, unsigned char min,
+			unsigned char sec)
+{
+	if (!is_hpet_enabled())
+		return 0;
+
+	hpet_alarm_time.tm_hour = hrs;
+	hpet_alarm_time.tm_min = min;
+	hpet_alarm_time.tm_sec = sec;
+
+	return 1;
+}
+
+int hpet_set_periodic_freq(unsigned long freq)
+{
+	uint64_t clc;
+
+	if (!is_hpet_enabled())
+		return 0;
+
+	if (freq <= DEFAULT_RTC_INT_FREQ)
+		hpet_pie_limit = DEFAULT_RTC_INT_FREQ / freq;
+	else {
+		clc = (uint64_t) hpet_clockevent.mult * NSEC_PER_SEC;
+		do_div(clc, freq);
+		clc >>= hpet_clockevent.shift;
+		hpet_pie_delta = (unsigned long) clc;
+	}
+	return 1;
+}
+
+int hpet_rtc_dropped_irq(void)
+{
+	return is_hpet_enabled();
+}
+
+static void hpet_rtc_timer_reinit(void)
+{
+	unsigned long cfg, delta;
+	int lost_ints = -1;
+
+	if (unlikely(!hpet_rtc_flags)) {
+		cfg = hpet_readl(HPET_T1_CFG);
+		cfg &= ~HPET_TN_ENABLE;
+		hpet_writel(cfg, HPET_T1_CFG);
+		return;
+	}
+
+	if (!(hpet_rtc_flags & RTC_PIE) || hpet_pie_limit)
+		delta = hpet_default_delta;
+	else
+		delta = hpet_pie_delta;
+
+	/*
+	 * Increment the comparator value until we are ahead of the
+	 * current count.
+	 */
+	do {
+		hpet_t1_cmp += delta;
+		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
+		lost_ints++;
+	} while ((long)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
+
+	if (lost_ints) {
+		if (hpet_rtc_flags & RTC_PIE)
+			hpet_pie_count += lost_ints;
+		if (printk_ratelimit())
+			printk(KERN_WARNING "rtc: lost %d interrupts\n",
+				lost_ints);
+	}
+}
+
+irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
+{
+	struct rtc_time curr_time;
+	unsigned long rtc_int_flag = 0;
+
+	hpet_rtc_timer_reinit();
+
+	if (hpet_rtc_flags & (RTC_UIE | RTC_AIE))
+		rtc_get_rtc_time(&curr_time);
+
+	if (hpet_rtc_flags & RTC_UIE &&
+	    curr_time.tm_sec != hpet_prev_update_sec) {
+		rtc_int_flag = RTC_UF;
+		hpet_prev_update_sec = curr_time.tm_sec;
+	}
+
+	if (hpet_rtc_flags & RTC_PIE &&
+	    ++hpet_pie_count >= hpet_pie_limit) {
+		rtc_int_flag |= RTC_PF;
+		hpet_pie_count = 0;
+	}
+
+	if (hpet_rtc_flags & RTC_PIE &&
+	    (curr_time.tm_sec == hpet_alarm_time.tm_sec) &&
+	    (curr_time.tm_min == hpet_alarm_time.tm_min) &&
+	    (curr_time.tm_hour == hpet_alarm_time.tm_hour))
+			rtc_int_flag |= RTC_AF;
+
+	if (rtc_int_flag) {
+		rtc_int_flag |= (RTC_IRQF | (RTC_NUM_INTS << 8));
+		rtc_interrupt(rtc_int_flag, dev_id);
+	}
+	return IRQ_HANDLED;
+}
+#endif
diff -puN arch/i386/kernel/i8253.c~clockevents-i383-drivers arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~clockevents-i383-drivers
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
@@ -19,20 +19,100 @@
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
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&i8253_lock, flags);
-	outb_p(0x34,PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
-	udelay(10);
-	outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
-	udelay(10);
-	outb(LATCH >> 8 , PIT_CH0);	/* MSB */
+
+	switch(mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		/* binary, mode 2, LSB/MSB, ch 0 */
+		outb_p(0x34, PIT_MODE);
+		udelay(10);
+		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
+		udelay(10);
+		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		/* One shot setup */
+		outb_p(0x38, PIT_MODE);
+		udelay(10);
+		break;
+	}
 	spin_unlock_irqrestore(&i8253_lock, flags);
 }
 
 /*
+ * Program the next event in oneshot mode
+ *
+ * Delta is given in PIT ticks
+ */
+static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&i8253_lock, flags);
+	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
+	outb(delta >> 8 , PIT_CH0);	/* MSB */
+	spin_unlock_irqrestore(&i8253_lock, flags);
+
+	return 0;
+}
+
+/*
+ * On UP the PIT can serve all of the possible timer functions. On SMP systems
+ * it can be solely used for the global tick.
+ *
+ * The profiling and update capabilites are switched off once the local apic is
+ * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
+ * !using_apic_timer decisions in do_timer_interrupt_hook()
+ */
+struct clock_event_device pit_clockevent = {
+	.name		= "pit",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= init_pit_timer,
+	.set_next_event = pit_next_event,
+	.shift		= 32,
+	.irq		= 0,
+};
+
+/*
+ * Initialize the conversion factor and the min/max deltas of the clock event
+ * structure and register the clock event source with the framework.
+ */
+void __init setup_pit_timer(void)
+{
+	/*
+	 * Start pit with the boot cpu mask and make it global after the
+	 * IO_APIC has been initialized.
+	 */
+	pit_clockevent.cpumask = cpumask_of_cpu(0);
+	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, 32);
+	pit_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFF, &pit_clockevent);
+	pit_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &pit_clockevent);
+	clockevents_register_device(&pit_clockevent);
+	global_clock_event = &pit_clockevent;
+}
+
+/*
  * Since the PIT overflows every tick, its not very useful
  * to just read by itself. So use jiffies to emulate a free
  * running counter:
@@ -46,7 +126,7 @@ static cycle_t pit_read(void)
 	static u32 old_jifs;
 
 	spin_lock_irqsave(&i8253_lock, flags);
-        /*
+	/*
 	 * Although our caller may have the read side of xtime_lock,
 	 * this is now a seqlock, and we are cheating in this routine
 	 * by having side effects on state that we cannot undo if
diff -puN arch/i386/kernel/i8259.c~clockevents-i383-drivers arch/i386/kernel/i8259.c
--- a/arch/i386/kernel/i8259.c~clockevents-i383-drivers
+++ a/arch/i386/kernel/i8259.c
@@ -410,12 +410,6 @@ void __init native_init_IRQ(void)
 	intr_init_hook();
 
 	/*
-	 * Set the clock to HZ Hz, we already have a valid
-	 * vector now:
-	 */
-	setup_pit_timer();
-
-	/*
 	 * External FPU? Set up irq13 if so, for
 	 * original braindamaged IBM FERR coupling.
 	 */
diff -puN arch/i386/kernel/smpboot.c~clockevents-i383-drivers arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~clockevents-i383-drivers
+++ a/arch/i386/kernel/smpboot.c
@@ -286,9 +286,7 @@ static void __cpuinit smp_callin(void)
 	/*
 	 * Save our processor parameters
 	 */
- 	smp_store_cpu_info(cpuid);
-
-	disable_APIC_timer();
+	smp_store_cpu_info(cpuid);
 
 	/*
 	 * Allow the master to continue.
@@ -407,7 +405,6 @@ static void __cpuinit start_secondary(vo
 		enable_NMI_through_LVT0(NULL);
 		enable_8259A_irq(0);
 	}
-	enable_APIC_timer();
 	/*
 	 * low-memory mappings have been cleared, flush them from
 	 * the local TLBs too.
diff -puN arch/i386/kernel/time.c~clockevents-i383-drivers arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c~clockevents-i383-drivers
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
 
@@ -279,63 +262,16 @@ void notify_arch_cmos_timer(void)
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
-#ifdef CONFIG_HPET_TIMER
 extern void (*late_time_init)(void);
 /* Duplicate of time_init() below, with hpet_enable part added */
 static void __init hpet_time_init(void)
 {
-	if ((hpet_enable() >= 0) && hpet_use_timer) {
-		printk("Using HPET for base-timer\n");
-	}
-
+	if (!hpet_enable())
+		setup_pit_timer();
 	do_time_init();
 }
-#endif
 
 void __init time_init(void)
 {
-#ifdef CONFIG_HPET_TIMER
-	if (is_hpet_capable()) {
-		/*
-		 * HPET initialization needs to do memory-mapped io. So, let
-		 * us do a late initialization after mem_init().
-		 */
-		late_time_init = hpet_time_init;
-		return;
-	}
-#endif
-	do_time_init();
+	late_time_init = hpet_time_init;
 }
diff -puN arch/i386/kernel/time_hpet.c~clockevents-i383-drivers /dev/null
--- a/arch/i386/kernel/time_hpet.c
+++ /dev/null
@@ -1,497 +0,0 @@
-/*
- *  linux/arch/i386/kernel/time_hpet.c
- *  This code largely copied from arch/x86_64/kernel/time.c
- *  See that file for credits.
- *
- *  2003-06-30    Venkatesh Pallipadi - Additional changes for HPET support
- */
-
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/param.h>
-#include <linux/string.h>
-#include <linux/init.h>
-#include <linux/smp.h>
-
-#include <asm/timer.h>
-#include <asm/fixmap.h>
-#include <asm/apic.h>
-
-#include <linux/timex.h>
-
-#include <asm/hpet.h>
-#include <linux/hpet.h>
-
-static unsigned long hpet_period;	/* fsecs / HPET clock */
-unsigned long hpet_tick;		/* hpet clks count per tick */
-unsigned long hpet_address;		/* hpet memory map physical address */
-int hpet_use_timer;
-
-static int use_hpet; 		/* can be used for runtime check of hpet */
-static int boot_hpet_disable; 	/* boottime override for HPET timer */
-static void __iomem * hpet_virt_address;	/* hpet kernel virtual address */
-
-#define FSEC_TO_USEC (1000000000UL)
-
-int hpet_readl(unsigned long a)
-{
-	return readl(hpet_virt_address + a);
-}
-
-static void hpet_writel(unsigned long d, unsigned long a)
-{
-	writel(d, hpet_virt_address + a);
-}
-
-#ifdef CONFIG_X86_LOCAL_APIC
-/*
- * HPET counters dont wrap around on every tick. They just change the
- * comparator value and continue. Next tick can be caught by checking
- * for a change in the comparator value. Used in apic.c.
- */
-static void __devinit wait_hpet_tick(void)
-{
-	unsigned int start_cmp_val, end_cmp_val;
-
-	start_cmp_val = hpet_readl(HPET_T0_CMP);
-	do {
-		end_cmp_val = hpet_readl(HPET_T0_CMP);
-	} while (start_cmp_val == end_cmp_val);
-}
-#endif
-
-static int hpet_timer_stop_set_go(unsigned long tick)
-{
-	unsigned int cfg;
-
-	/*
-	 * Stop the timers and reset the main counter.
-	 */
-	cfg = hpet_readl(HPET_CFG);
-	cfg &= ~HPET_CFG_ENABLE;
-	hpet_writel(cfg, HPET_CFG);
-	hpet_writel(0, HPET_COUNTER);
-	hpet_writel(0, HPET_COUNTER + 4);
-
-	if (hpet_use_timer) {
-		/*
-		 * Set up timer 0, as periodic with first interrupt to happen at
-		 * hpet_tick, and period also hpet_tick.
-		 */
-		cfg = hpet_readl(HPET_T0_CFG);
-		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
-		       HPET_TN_SETVAL | HPET_TN_32BIT;
-		hpet_writel(cfg, HPET_T0_CFG);
-
-		/*
-		 * The first write after writing TN_SETVAL to the config register sets
-		 * the counter value, the second write sets the threshold.
-		 */
-		hpet_writel(tick, HPET_T0_CMP);
-		hpet_writel(tick, HPET_T0_CMP);
-	}
-	/*
- 	 * Go!
- 	 */
-	cfg = hpet_readl(HPET_CFG);
-	if (hpet_use_timer)
-		cfg |= HPET_CFG_LEGACY;
-	cfg |= HPET_CFG_ENABLE;
-	hpet_writel(cfg, HPET_CFG);
-
-	return 0;
-}
-
-/*
- * Check whether HPET was found by ACPI boot parse. If yes setup HPET
- * counter 0 for kernel base timer.
- */
-int __init hpet_enable(void)
-{
-	unsigned int id;
-	unsigned long tick_fsec_low, tick_fsec_high; /* tick in femto sec */
-	unsigned long hpet_tick_rem;
-
-	if (boot_hpet_disable)
-		return -1;
-
-	if (!hpet_address) {
-		return -1;
-	}
-	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
-	/*
-	 * Read the period, compute tick and quotient.
-	 */
-	id = hpet_readl(HPET_ID);
-
-	/*
-	 * We are checking for value '1' or more in number field if
-	 * CONFIG_HPET_EMULATE_RTC is set because we will need an
-	 * additional timer for RTC emulation.
-	 * However, we can do with one timer otherwise using the
-	 * the single HPET timer for system time.
-	 */
-#ifdef CONFIG_HPET_EMULATE_RTC
-	if (!(id & HPET_ID_NUMBER)) {
-		iounmap(hpet_virt_address);
-		hpet_virt_address = NULL;
-		return -1;
-	}
-#endif
-
-
-	hpet_period = hpet_readl(HPET_PERIOD);
-	if ((hpet_period < HPET_MIN_PERIOD) || (hpet_period > HPET_MAX_PERIOD)) {
-		iounmap(hpet_virt_address);
-		hpet_virt_address = NULL;
-		return -1;
-	}
-
-	/*
-	 * 64 bit math
-	 * First changing tick into fsec
-	 * Then 64 bit div to find number of hpet clk per tick
-	 */
-	ASM_MUL64_REG(tick_fsec_low, tick_fsec_high,
-			KERNEL_TICK_USEC, FSEC_TO_USEC);
-	ASM_DIV64_REG(hpet_tick, hpet_tick_rem,
-			hpet_period, tick_fsec_low, tick_fsec_high);
-
-	if (hpet_tick_rem > (hpet_period >> 1))
-		hpet_tick++; /* rounding the result */
-
-	hpet_use_timer = id & HPET_ID_LEGSUP;
-
-	if (hpet_timer_stop_set_go(hpet_tick)) {
-		iounmap(hpet_virt_address);
-		hpet_virt_address = NULL;
-		return -1;
-	}
-
-	use_hpet = 1;
-
-#ifdef	CONFIG_HPET
-	{
-		struct hpet_data	hd;
-		unsigned int 		ntimer;
-
-		memset(&hd, 0, sizeof (hd));
-
-		ntimer = hpet_readl(HPET_ID);
-		ntimer = (ntimer & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT;
-		ntimer++;
-
-		/*
-		 * Register with driver.
-		 * Timer0 and Timer1 is used by platform.
-		 */
-		hd.hd_phys_address = hpet_address;
-		hd.hd_address = hpet_virt_address;
-		hd.hd_nirqs = ntimer;
-		hd.hd_flags = HPET_DATA_PLATFORM;
-		hpet_reserve_timer(&hd, 0);
-#ifdef	CONFIG_HPET_EMULATE_RTC
-		hpet_reserve_timer(&hd, 1);
-#endif
-		hd.hd_irq[0] = HPET_LEGACY_8254;
-		hd.hd_irq[1] = HPET_LEGACY_RTC;
-		if (ntimer > 2) {
-			struct hpet __iomem	*hpet;
-			struct hpet_timer __iomem *timer;
-			int			i;
-
-			hpet = hpet_virt_address;
-
-			for (i = 2, timer = &hpet->hpet_timers[2]; i < ntimer;
-				timer++, i++)
-				hd.hd_irq[i] = (timer->hpet_config &
-					Tn_INT_ROUTE_CNF_MASK) >>
-					Tn_INT_ROUTE_CNF_SHIFT;
-
-		}
-
-		hpet_alloc(&hd);
-	}
-#endif
-
-#ifdef CONFIG_X86_LOCAL_APIC
-	if (hpet_use_timer)
-		wait_timer_tick = wait_hpet_tick;
-#endif
-	return 0;
-}
-
-int hpet_reenable(void)
-{
-	return hpet_timer_stop_set_go(hpet_tick);
-}
-
-int is_hpet_enabled(void)
-{
-	return use_hpet;
-}
-
-int is_hpet_capable(void)
-{
-	if (!boot_hpet_disable && hpet_address)
-		return 1;
-	return 0;
-}
-
-static int __init hpet_setup(char* str)
-{
-	if (str) {
-		if (!strncmp("disable", str, 7))
-			boot_hpet_disable = 1;
-	}
-	return 1;
-}
-
-__setup("hpet=", hpet_setup);
-
-#ifdef CONFIG_HPET_EMULATE_RTC
-/* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET
- * is enabled, we support RTC interrupt functionality in software.
- * RTC has 3 kinds of interrupts:
- * 1) Update Interrupt - generate an interrupt, every sec, when RTC clock
- *    is updated
- * 2) Alarm Interrupt - generate an interrupt at a specific time of day
- * 3) Periodic Interrupt - generate periodic interrupt, with frequencies
- *    2Hz-8192Hz (2Hz-64Hz for non-root user) (all freqs in powers of 2)
- * (1) and (2) above are implemented using polling at a frequency of
- * 64 Hz. The exact frequency is a tradeoff between accuracy and interrupt
- * overhead. (DEFAULT_RTC_INT_FREQ)
- * For (3), we use interrupts at 64Hz or user specified periodic
- * frequency, whichever is higher.
- */
-#include <linux/mc146818rtc.h>
-#include <linux/rtc.h>
-
-#define DEFAULT_RTC_INT_FREQ 	64
-#define RTC_NUM_INTS 		1
-
-static unsigned long UIE_on;
-static unsigned long prev_update_sec;
-
-static unsigned long AIE_on;
-static struct rtc_time alarm_time;
-
-static unsigned long PIE_on;
-static unsigned long PIE_freq = DEFAULT_RTC_INT_FREQ;
-static unsigned long PIE_count;
-
-static unsigned long hpet_rtc_int_freq; /* RTC interrupt frequency */
-static unsigned int hpet_t1_cmp; /* cached comparator register */
-
-/*
- * Timer 1 for RTC, we do not use periodic interrupt feature,
- * even if HPET supports periodic interrupts on Timer 1.
- * The reason being, to set up a periodic interrupt in HPET, we need to
- * stop the main counter. And if we do that everytime someone diables/enables
- * RTC, we will have adverse effect on main kernel timer running on Timer 0.
- * So, for the time being, simulate the periodic interrupt in software.
- *
- * hpet_rtc_timer_init() is called for the first time and during subsequent
- * interuppts reinit happens through hpet_rtc_timer_reinit().
- */
-int hpet_rtc_timer_init(void)
-{
-	unsigned int cfg, cnt;
-	unsigned long flags;
-
-	if (!is_hpet_enabled())
-		return 0;
-	/*
-	 * Set the counter 1 and enable the interrupts.
-	 */
-	if (PIE_on && (PIE_freq > DEFAULT_RTC_INT_FREQ))
-		hpet_rtc_int_freq = PIE_freq;
-	else
-		hpet_rtc_int_freq = DEFAULT_RTC_INT_FREQ;
-
-	local_irq_save(flags);
-
-	cnt = hpet_readl(HPET_COUNTER);
-	cnt += ((hpet_tick*HZ)/hpet_rtc_int_freq);
-	hpet_writel(cnt, HPET_T1_CMP);
-	hpet_t1_cmp = cnt;
-
-	cfg = hpet_readl(HPET_T1_CFG);
-	cfg &= ~HPET_TN_PERIODIC;
-	cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
-	hpet_writel(cfg, HPET_T1_CFG);
-
-	local_irq_restore(flags);
-
-	return 1;
-}
-
-static void hpet_rtc_timer_reinit(void)
-{
-	unsigned int cfg, cnt, ticks_per_int, lost_ints;
-
-	if (unlikely(!(PIE_on | AIE_on | UIE_on))) {
-		cfg = hpet_readl(HPET_T1_CFG);
-		cfg &= ~HPET_TN_ENABLE;
-		hpet_writel(cfg, HPET_T1_CFG);
-		return;
-	}
-
-	if (PIE_on && (PIE_freq > DEFAULT_RTC_INT_FREQ))
-		hpet_rtc_int_freq = PIE_freq;
-	else
-		hpet_rtc_int_freq = DEFAULT_RTC_INT_FREQ;
-
-	/* It is more accurate to use the comparator value than current count.*/
-	ticks_per_int = hpet_tick * HZ / hpet_rtc_int_freq;
-	hpet_t1_cmp += ticks_per_int;
-	hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
-
-	/*
-	 * If the interrupt handler was delayed too long, the write above tries
-	 * to schedule the next interrupt in the past and the hardware would
-	 * not interrupt until the counter had wrapped around.
-	 * So we have to check that the comparator wasn't set to a past time.
-	 */
-	cnt = hpet_readl(HPET_COUNTER);
-	if (unlikely((int)(cnt - hpet_t1_cmp) > 0)) {
-		lost_ints = (cnt - hpet_t1_cmp) / ticks_per_int + 1;
-		/* Make sure that, even with the time needed to execute
-		 * this code, the next scheduled interrupt has been moved
-		 * back to the future: */
-		lost_ints++;
-
-		hpet_t1_cmp += lost_ints * ticks_per_int;
-		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
-
-		if (PIE_on)
-			PIE_count += lost_ints;
-
-		printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
-		       hpet_rtc_int_freq);
-	}
-}
-
-/*
- * The functions below are called from rtc driver.
- * Return 0 if HPET is not being used.
- * Otherwise do the necessary changes and return 1.
- */
-int hpet_mask_rtc_irq_bit(unsigned long bit_mask)
-{
-	if (!is_hpet_enabled())
-		return 0;
-
-	if (bit_mask & RTC_UIE)
-		UIE_on = 0;
-	if (bit_mask & RTC_PIE)
-		PIE_on = 0;
-	if (bit_mask & RTC_AIE)
-		AIE_on = 0;
-
-	return 1;
-}
-
-int hpet_set_rtc_irq_bit(unsigned long bit_mask)
-{
-	int timer_init_reqd = 0;
-
-	if (!is_hpet_enabled())
-		return 0;
-
-	if (!(PIE_on | AIE_on | UIE_on))
-		timer_init_reqd = 1;
-
-	if (bit_mask & RTC_UIE) {
-		UIE_on = 1;
-	}
-	if (bit_mask & RTC_PIE) {
-		PIE_on = 1;
-		PIE_count = 0;
-	}
-	if (bit_mask & RTC_AIE) {
-		AIE_on = 1;
-	}
-
-	if (timer_init_reqd)
-		hpet_rtc_timer_init();
-
-	return 1;
-}
-
-int hpet_set_alarm_time(unsigned char hrs, unsigned char min, unsigned char sec)
-{
-	if (!is_hpet_enabled())
-		return 0;
-
-	alarm_time.tm_hour = hrs;
-	alarm_time.tm_min = min;
-	alarm_time.tm_sec = sec;
-
-	return 1;
-}
-
-int hpet_set_periodic_freq(unsigned long freq)
-{
-	if (!is_hpet_enabled())
-		return 0;
-
-	PIE_freq = freq;
-	PIE_count = 0;
-
-	return 1;
-}
-
-int hpet_rtc_dropped_irq(void)
-{
-	if (!is_hpet_enabled())
-		return 0;
-
-	return 1;
-}
-
-irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
-{
-	struct rtc_time curr_time;
-	unsigned long rtc_int_flag = 0;
-	int call_rtc_interrupt = 0;
-
-	hpet_rtc_timer_reinit();
-
-	if (UIE_on | AIE_on) {
-		rtc_get_rtc_time(&curr_time);
-	}
-	if (UIE_on) {
-		if (curr_time.tm_sec != prev_update_sec) {
-			/* Set update int info, call real rtc int routine */
-			call_rtc_interrupt = 1;
-			rtc_int_flag = RTC_UF;
-			prev_update_sec = curr_time.tm_sec;
-		}
-	}
-	if (PIE_on) {
-		PIE_count++;
-		if (PIE_count >= hpet_rtc_int_freq/PIE_freq) {
-			/* Set periodic int info, call real rtc int routine */
-			call_rtc_interrupt = 1;
-			rtc_int_flag |= RTC_PF;
-			PIE_count = 0;
-		}
-	}
-	if (AIE_on) {
-		if ((curr_time.tm_sec == alarm_time.tm_sec) &&
-		    (curr_time.tm_min == alarm_time.tm_min) &&
-		    (curr_time.tm_hour == alarm_time.tm_hour)) {
-			/* Set alarm int info, call real rtc int routine */
-			call_rtc_interrupt = 1;
-			rtc_int_flag |= RTC_AF;
-		}
-	}
-	if (call_rtc_interrupt) {
-		rtc_int_flag |= (RTC_IRQF | (RTC_NUM_INTS << 8));
-		rtc_interrupt(rtc_int_flag, dev_id);
-	}
-	return IRQ_HANDLED;
-}
-#endif
-
diff -puN arch/i386/mach-default/setup.c~clockevents-i383-drivers arch/i386/mach-default/setup.c
--- a/arch/i386/mach-default/setup.c~clockevents-i383-drivers
+++ a/arch/i386/mach-default/setup.c
@@ -79,7 +79,12 @@ void __init trap_init_hook(void)
 {
 }
 
-static struct irqaction irq0  = { timer_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "timer", NULL, NULL};
+static struct irqaction irq0  = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.mask = CPU_MASK_NONE,
+	.name = "timer"
+};
 
 /**
  * time_init_hook - do any specific initialisations for the system timer.
@@ -90,6 +95,7 @@ static struct irqaction irq0  = { timer_
  **/
 void __init time_init_hook(void)
 {
+	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
 
diff -puN drivers/acpi/processor_idle.c~clockevents-i383-drivers drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~clockevents-i383-drivers
+++ a/drivers/acpi/processor_idle.c
@@ -39,6 +39,7 @@
 #include <linux/moduleparam.h>
 #include <linux/sched.h>	/* need_resched() */
 #include <linux/latency.h>
+#include <linux/clockchips.h>
 
 /*
  * Include the apic definitions for x86 to have the APIC timer related defines
@@ -277,12 +278,40 @@ static void acpi_timer_check_state(int s
 
 static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
 {
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	unsigned long reason;
+
+	reason = pr->power.timer_broadcast_on_state < INT_MAX ?
+		CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;
+
+	clockevents_notify(reason, &pr->id);
+#else
 	cpumask_t mask = cpumask_of_cpu(pr->id);
 
 	if (pr->power.timer_broadcast_on_state < INT_MAX)
 		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
 	else
 		on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
+#endif
+}
+
+/* Power(C) State timer broadcast control */
+static void acpi_state_timer_broadcast(struct acpi_processor *pr,
+				       struct acpi_processor_cx *cx,
+				       int broadcast)
+{
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+
+	int state = cx - pr->power.states;
+
+	if (state >= pr->power.timer_broadcast_on_state) {
+		unsigned long reason;
+
+		reason = broadcast ?  CLOCK_EVT_NOTIFY_BROADCAST_ENTER :
+			CLOCK_EVT_NOTIFY_BROADCAST_EXIT;
+		clockevents_notify(reason, &pr->id);
+	}
+#endif
 }
 
 #else
@@ -290,6 +319,11 @@ static void acpi_propagate_timer_broadca
 static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 				   struct acpi_processor_cx *cstate) { }
 static void acpi_propagate_timer_broadcast(struct acpi_processor *pr) { }
+static void acpi_state_timer_broadcast(struct acpi_processor *pr,
+				       struct acpi_processor_cx *cx,
+				       int broadcast)
+{
+}
 
 #endif
 
@@ -439,6 +473,7 @@ static void acpi_processor_idle(void)
 		/* Get start time (ticks) */
 		t1 = inl(acpi_fadt.xpm_tmr_blk.address);
 		/* Invoke C2 */
+		acpi_state_timer_broadcast(pr, cx, 1);
 		acpi_cstate_enter(cx);
 		/* Get end time (ticks) */
 		t2 = inl(acpi_fadt.xpm_tmr_blk.address);
@@ -453,6 +488,7 @@ static void acpi_processor_idle(void)
 		/* Compute time (ticks) that we were actually asleep */
 		sleep_ticks =
 		    ticks_elapsed(t1, t2) - cx->latency_ticks - C2_OVERHEAD;
+		acpi_state_timer_broadcast(pr, cx, 0);
 		break;
 
 	case ACPI_STATE_C3:
@@ -475,6 +511,7 @@ static void acpi_processor_idle(void)
 		/* Get start time (ticks) */
 		t1 = inl(acpi_fadt.xpm_tmr_blk.address);
 		/* Invoke C3 */
+		acpi_state_timer_broadcast(pr, cx, 1);
 		acpi_cstate_enter(cx);
 		/* Get end time (ticks) */
 		t2 = inl(acpi_fadt.xpm_tmr_blk.address);
@@ -495,6 +532,7 @@ static void acpi_processor_idle(void)
 		/* Compute time (ticks) that we were actually asleep */
 		sleep_ticks =
 		    ticks_elapsed(t1, t2) - cx->latency_ticks - C3_OVERHEAD;
+		acpi_state_timer_broadcast(pr, cx, 0);
 		break;
 
 	default:
diff -puN include/asm-i386/apic.h~clockevents-i383-drivers include/asm-i386/apic.h
--- a/include/asm-i386/apic.h~clockevents-i383-drivers
+++ a/include/asm-i386/apic.h
@@ -113,14 +113,9 @@ extern void smp_local_timer_interrupt (v
 extern void setup_boot_APIC_clock (void);
 extern void setup_secondary_APIC_clock (void);
 extern int APIC_init_uniprocessor (void);
-extern void disable_APIC_timer(void);
-extern void enable_APIC_timer(void);
 
 extern void enable_NMI_through_LVT0 (void * dummy);
 
-void smp_send_timer_broadcast_ipi(void);
-void switch_APIC_timer_to_ipi(void *cpumask);
-void switch_ipi_to_APIC_timer(void *cpumask);
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
 extern int timer_over_8254;
diff -puN include/asm-i386/hpet.h~clockevents-i383-drivers include/asm-i386/hpet.h
--- a/include/asm-i386/hpet.h~clockevents-i383-drivers
+++ a/include/asm-i386/hpet.h
@@ -90,16 +90,19 @@
 #define HPET_MIN_PERIOD (100000UL)
 #define HPET_TICK_RATE  (HZ * 100000UL)
 
-extern unsigned long hpet_tick;  	/* hpet clks count per tick */
 extern unsigned long hpet_address;	/* hpet memory map physical address */
-extern int hpet_use_timer;
+extern int is_hpet_enabled(void);
 
+#ifdef CONFIG_X86_64
+extern unsigned long hpet_tick;	/* hpet clks count per tick */
+extern int hpet_use_timer;
 extern int hpet_rtc_timer_init(void);
 extern int hpet_enable(void);
-extern int hpet_reenable(void);
-extern int is_hpet_enabled(void);
 extern int is_hpet_capable(void);
 extern int hpet_readl(unsigned long a);
+#else
+extern int hpet_enable(void);
+#endif
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 extern int hpet_mask_rtc_irq_bit(unsigned long bit_mask);
@@ -110,5 +113,10 @@ extern int hpet_rtc_dropped_irq(void);
 extern int hpet_rtc_timer_init(void);
 extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
 #endif /* CONFIG_HPET_EMULATE_RTC */
+
+#else
+
+static inline int hpet_enable(void) { return 0; }
+
 #endif /* CONFIG_HPET_TIMER */
 #endif /* _I386_HPET_H */
diff -puN include/asm-i386/i8253.h~clockevents-i383-drivers include/asm-i386/i8253.h
--- a/include/asm-i386/i8253.h~clockevents-i383-drivers
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
+	global_clock_event->event_handler(global_clock_event);
+}
+
 #endif	/* __ASM_I8253_H__ */
diff -puN include/asm-i386/mach-default/do_timer.h~clockevents-i383-drivers include/asm-i386/mach-default/do_timer.h
--- a/include/asm-i386/mach-default/do_timer.h~clockevents-i383-drivers
+++ a/include/asm-i386/mach-default/do_timer.h
@@ -1,86 +1,16 @@
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
-}
-
-
-/* you can safely undefine this if you don't have the Neptune chipset */
-
-#define BUGGY_NEPTUN_TIMER
-
-/**
- * do_timer_overflow - process a detected timer overflow condition
- * @count:	hardware timer interrupt count on overflow
- *
- * Description:
- *	This call is invoked when the jiffies count has not incremented but
- *	the hardware timer interrupt has.  It means that a timer tick interrupt
- *	came along while the previous one was pending, thus a tick was missed
- **/
-static inline int do_timer_overflow(int count)
-{
-	int i;
-
-	spin_lock(&i8259A_lock);
-	/*
-	 * This is tricky when I/O APICs are used;
-	 * see do_timer_interrupt().
-	 */
-	i = inb(0x20);
-	spin_unlock(&i8259A_lock);
-	
-	/* assumption about timer being IRQ0 */
-	if (i & 0x01) {
-		/*
-		 * We cannot detect lost timer interrupts ... 
-		 * well, that's why we call them lost, don't we? :)
-		 * [hmm, on the Pentium and Alpha we can ... sort of]
-		 */
-		count -= LATCH;
-	} else {
-#ifdef BUGGY_NEPTUN_TIMER
-		/*
-		 * for the Neptun bug we know that the 'latch'
-		 * command doesn't latch the high and low value
-		 * of the counter atomically. Thus we have to 
-		 * substract 256 from the counter 
-		 * ... funny, isnt it? :)
-		 */
-		
-		count -= 256;
-#else
-		printk("do_slow_gettimeoffset(): hardware timer problem?\n");
-#endif
-	}
-	return count;
+	pit_interrupt_hook();
 }
diff -puN include/asm-i386/mach-voyager/do_timer.h~clockevents-i383-drivers include/asm-i386/mach-voyager/do_timer.h
--- a/include/asm-i386/mach-voyager/do_timer.h~clockevents-i383-drivers
+++ a/include/asm-i386/mach-voyager/do_timer.h
@@ -1,25 +1,18 @@
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
+	pit_interrupt_hook();
 	voyager_timer_interrupt();
 }
 
-static inline int do_timer_overflow(int count)
-{
-	/* can't read the ISR, just assume 1 tick
-	   overflow */
-	if(count > LATCH || count < 0) {
-		printk(KERN_ERR "VOYAGER PROBLEM: count is %d, latch is %d\n", count, LATCH);
-		count = LATCH;
-	}
-	count -= LATCH;
-
-	return count;
-}
diff -puN include/asm-i386/mpspec.h~clockevents-i383-drivers include/asm-i386/mpspec.h
--- a/include/asm-i386/mpspec.h~clockevents-i383-drivers
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
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
clocksource-add-verification-watchdog-helper-fix.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
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
