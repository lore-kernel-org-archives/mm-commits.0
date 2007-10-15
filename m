From: akpm@linux-foundation.org
Subject: - x86_64-convert-to-clockevents.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:18:16 -0700
Message-ID: <200710150918.l9F9IGLx027384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757471AbXJOJZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86_64: convert to clock events
has been removed from the -mm tree.  Its filename was
     x86_64-convert-to-clockevents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: convert to clock events
From: Thomas Gleixner <tglx@linutronix.de>

Finally switch to the clockevents code.  Share code with i386 for hpet and
PIT.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/Makefile_64  |    4 -
 arch/x86/kernel/apic_64.c    |   90 +++++++++++++++------------
 arch/x86/kernel/i8259_64.c   |   46 --------------
 arch/x86/kernel/smpboot_64.c |    4 -
 arch/x86/kernel/time_64.c    |  107 ++++-----------------------------
 arch/x86_64/Kconfig          |   10 ++-
 include/asm-x86/hpet_64.h    |   17 -----
 7 files changed, 75 insertions(+), 203 deletions(-)

diff -puN arch/x86/kernel/Makefile_64~x86_64-convert-to-clockevents arch/x86/kernel/Makefile_64
--- a/arch/x86/kernel/Makefile_64~x86_64-convert-to-clockevents
+++ a/arch/x86/kernel/Makefile_64
@@ -9,7 +9,7 @@ obj-y	:= process_64.o signal_64.o entry_
 		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
 		setup64.o bootflag.o e820_64.o reboot_64.o quirks.o i8237.o \
 		pci-dma_64.o pci-nommu_64.o alternative.o hpet_64.o tsc_64.o bugs_64.o \
-		perfctr-watchdog.o sched-clock.o
+		perfctr-watchdog.o sched-clock.o i8253.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_X86_MCE)		+= mce_64.o therm_throt.o
@@ -48,6 +48,8 @@ obj-y				+= pcspeaker.o
 
 CFLAGS_vsyscall_64.o		:= $(PROFILING) -g0
 
+i8253-y				+= ../../i386/kernel/i8253.o
+hpet-y				+= ../../i386/kernel/hpet.o
 therm_throt-y                   += cpu/mcheck/therm_throt.o
 intel_cacheinfo-y		+= cpu/intel_cacheinfo.o
 addon_cpuid_features-y		+= cpu/addon_cpuid_features.o
diff -puN arch/x86/kernel/apic_64.c~x86_64-convert-to-clockevents arch/x86/kernel/apic_64.c
--- a/arch/x86/kernel/apic_64.c~x86_64-convert-to-clockevents
+++ a/arch/x86/kernel/apic_64.c
@@ -837,25 +837,12 @@ static void __setup_APIC_LVTT(unsigned i
 
 static void setup_APIC_timer(void)
 {
-	unsigned long flags;
-	int irqen;
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
-	local_irq_save(flags);
+	memcpy(levt, &lapic_clockevent, sizeof(*levt));
+	levt->cpumask = cpumask_of_cpu(smp_processor_id());
 
-	irqen = ! cpu_isset(smp_processor_id(),
-			    timer_interrupt_broadcast_ipi_mask);
-	__setup_APIC_LVTT(calibration_result, 0, irqen);
-	/* Turn off PIT interrupt if we use APIC timer as main timer.
-	   Only works with the PM timer right now
-	   TBD fix it for HPET too. */
-	if ((pmtmr_ioport != 0) &&
-		smp_processor_id() == boot_cpu_id &&
-		apic_runs_main_timer == 1 &&
-		!cpu_isset(boot_cpu_id, timer_interrupt_broadcast_ipi_mask)) {
-		stop_timer_interrupt();
-		apic_runs_main_timer++;
-	}
-	local_irq_restore(flags);
+	clockevents_register_device(levt);
 }
 
 /*
@@ -930,18 +917,34 @@ static void __init calibrate_APIC_clock(
 
 void __init setup_boot_APIC_clock (void)
 {
+	/*
+	 * The local apic timer can be disabled via the kernel commandline.
+	 * Register the lapic timer as a dummy clock event source on SMP
+	 * systems, so the broadcast mechanism is used. On UP systems simply
+	 * ignore it.
+	 */
 	if (disable_apic_timer) {
 		printk(KERN_INFO "Disabling APIC timer\n");
+		/* No broadcast on UP ! */
+		if (num_possible_cpus() > 1)
+			setup_APIC_timer();
 		return;
 	}
 
 	printk(KERN_INFO "Using local APIC timer interrupts.\n");
-	using_apic_timer = 1;
-
 	calibrate_APIC_clock();
+
 	/*
-	 * Now set up the timer for real.
+	 * If nmi_watchdog is set to IO_APIC, we need the
+	 * PIT/HPET going.  Otherwise register lapic as a dummy
+	 * device.
 	 */
+	if (nmi_watchdog != NMI_IO_APIC)
+		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+	else
+		printk(KERN_WARNING "APIC timer registered as dummy,"
+		       " due to nmi_watchdog=1!\n");
+
 	setup_APIC_timer();
 }
 
@@ -1053,22 +1056,34 @@ void setup_APIC_extended_lvt(unsigned ch
 
 void smp_local_timer_interrupt(void)
 {
-	profile_tick(CPU_PROFILING);
-#ifdef CONFIG_SMP
-	update_process_times(user_mode(get_irq_regs()));
-#endif
-	if (apic_runs_main_timer > 1 && smp_processor_id() == boot_cpu_id)
-		main_timer_handler();
+	int cpu = smp_processor_id();
+	struct clock_event_device *evt = &per_cpu(lapic_events, cpu);
+
 	/*
-	 * We take the 'long' return path, and there every subsystem
-	 * grabs the appropriate locks (kernel lock/ irq lock).
+	 * Normally we should not be here till LAPIC has been initialized but
+	 * in some cases like kdump, its possible that there is a pending LAPIC
+	 * timer interrupt from previous kernel's context and is delivered in
+	 * new kernel the moment interrupts are enabled.
 	 *
-	 * We might want to decouple profiling from the 'long path',
-	 * and do the profiling totally in assembly.
-	 *
-	 * Currently this isn't too much of an issue (performance wise),
-	 * we can take more than 100K local irqs per second on a 100 MHz P5.
+	 * Interrupts are enabled early and LAPIC is setup much later, hence
+	 * its possible that when we get here evt->event_handler is NULL.
+	 * Check for event_handler being NULL and discard the interrupt as
+	 * spurious.
+	 */
+	if (!evt->event_handler) {
+		printk(KERN_WARNING
+		       "Spurious LAPIC timer interrupt on cpu %d\n", cpu);
+		/* Switch it off */
+		lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, evt);
+		return;
+	}
+
+	/*
+	 * the NMI deadlock-detector uses this.
 	 */
+	add_pda(apic_timer_irqs, 1);
+
+	evt->event_handler(evt);
 }
 
 /*
@@ -1084,11 +1099,6 @@ void smp_apic_timer_interrupt(struct pt_
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
 	/*
-	 * the NMI deadlock-detector uses this.
-	 */
-	add_pda(apic_timer_irqs, 1);
-
-	/*
 	 * NOTE! We'd better ACK the irq immediately,
 	 * because timer handling can be slow.
 	 */
@@ -1281,7 +1291,7 @@ static __init int setup_noapictimer(char
 static __init int setup_apicmaintimer(char *str)
 {
 	apic_runs_main_timer = 1;
-	nohpet = 1;
+
 	return 1;
 }
 __setup("apicmaintimer", setup_apicmaintimer);
@@ -1297,7 +1307,7 @@ static __init int setup_apicpmtimer(char
 {
 	apic_calibrate_pmtmr = 1;
 	notsc_setup(NULL);
-	return setup_apicmaintimer(NULL);
+	return 0;
 }
 __setup("apicpmtimer", setup_apicpmtimer);
 
diff -puN arch/x86/kernel/i8259_64.c~x86_64-convert-to-clockevents arch/x86/kernel/i8259_64.c
--- a/arch/x86/kernel/i8259_64.c~x86_64-convert-to-clockevents
+++ a/arch/x86/kernel/i8259_64.c
@@ -444,46 +444,6 @@ void __init init_ISA_irqs (void)
 	}
 }
 
-static void setup_timer_hardware(void)
-{
-	outb_p(0x34,0x43);		/* binary, mode 2, LSB/MSB, ch 0 */
-	udelay(10);
-	outb_p(LATCH & 0xff , 0x40);	/* LSB */
-	udelay(10);
-	outb(LATCH >> 8 , 0x40);	/* MSB */
-}
-
-static int timer_resume(struct sys_device *dev)
-{
-	setup_timer_hardware();
-	return 0;
-}
-
-void i8254_timer_resume(void)
-{
-	setup_timer_hardware();
-}
-
-static struct sysdev_class timer_sysclass = {
-	set_kset_name("timer_pit"),
-	.resume		= timer_resume,
-};
-
-static struct sys_device device_timer = {
-	.id		= 0,
-	.cls		= &timer_sysclass,
-};
-
-static int __init init_timer_sysfs(void)
-{
-	int error = sysdev_class_register(&timer_sysclass);
-	if (!error)
-		error = sysdev_register(&device_timer);
-	return error;
-}
-
-device_initcall(init_timer_sysfs);
-
 void __init init_IRQ(void)
 {
 	int i;
@@ -533,12 +493,6 @@ void __init init_IRQ(void)
 	set_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	set_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
-	/*
-	 * Set the clock to HZ Hz, we already have a valid
-	 * vector now:
-	 */
-	setup_timer_hardware();
-
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 }
diff -puN arch/x86/kernel/smpboot_64.c~x86_64-convert-to-clockevents arch/x86/kernel/smpboot_64.c
--- a/arch/x86/kernel/smpboot_64.c~x86_64-convert-to-clockevents
+++ a/arch/x86/kernel/smpboot_64.c
@@ -224,8 +224,6 @@ void __cpuinit smp_callin(void)
 	local_irq_disable();
 	Dprintk("Stack at about %p\n",&cpuid);
 
-	disable_APIC_timer();
-
 	/*
 	 * Save our processor parameters
 	 */
@@ -349,8 +347,6 @@ void __cpuinit start_secondary(void)
 		enable_8259A_irq(0);
 	}
 
-	enable_APIC_timer();
-
 	/*
 	 * The sibling maps must be set before turing the online map on for
 	 * this cpu
diff -puN arch/x86/kernel/time_64.c~x86_64-convert-to-clockevents arch/x86/kernel/time_64.c
--- a/arch/x86/kernel/time_64.c~x86_64-convert-to-clockevents
+++ a/arch/x86/kernel/time_64.c
@@ -28,6 +28,8 @@
 #include <linux/cpu.h>
 #include <linux/kallsyms.h>
 #include <linux/acpi.h>
+#include <linux/clockchips.h>
+
 #ifdef CONFIG_ACPI
 #include <acpi/achware.h>	/* for PM timer frequency */
 #include <acpi/acpi_bus.h>
@@ -46,12 +48,8 @@
 #include <asm/nmi.h>
 #include <asm/vgtod.h>
 
-static char *timename = NULL;
-
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
-DEFINE_SPINLOCK(i8253_lock);
-EXPORT_SYMBOL(i8253_lock);
 
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
@@ -194,6 +192,13 @@ static irqreturn_t timer_interrupt(int i
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
+{
+	global_clock_event->event_handler(global_clock_event);
+
+	return IRQ_HANDLED;
+}
+
 unsigned long read_persistent_clock(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
@@ -291,42 +296,8 @@ static unsigned int __init tsc_calibrate
 	return pmc_now * tsc_khz / (tsc_now - tsc_start);
 }
 
-static void __pit_init(int val, u8 mode)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8253_lock, flags);
-	outb_p(mode, PIT_MODE);
-	outb_p(val & 0xff, PIT_CH0);	/* LSB */
-	outb_p(val >> 8, PIT_CH0);	/* MSB */
-	spin_unlock_irqrestore(&i8253_lock, flags);
-}
-
-void __init pit_init(void)
-{
-	__pit_init(LATCH, 0x34); /* binary, mode 2, LSB/MSB, ch 0 */
-}
-
-void pit_stop_interrupt(void)
-{
-	__pit_init(0, 0x30); /* mode 0 */
-}
-
-void stop_timer_interrupt(void)
-{
-	char *name;
-	if (hpet_address) {
-		name = "HPET";
-		hpet_timer_stop_set_go(0);
-	} else {
-		name = "PIT";
-		pit_stop_interrupt();
-	}
-	printk(KERN_INFO "timer: %s interrupt stopped.\n", name);
-}
-
 static struct irqaction irq0 = {
-	.handler	= timer_interrupt,
+	.handler	= timer_event_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
 	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
@@ -334,20 +305,10 @@ static struct irqaction irq0 = {
 
 void __init time_init(void)
 {
-	if (nohpet)
-		hpet_address = 0;
-
-	if (hpet_arch_init())
-		hpet_address = 0;
+	if (!hpet_enable())
+		setup_pit_timer();
 
-	if (hpet_use_timer) {
-		/* set tick_nsec to use the proper rate for HPET */
-		tick_nsec = TICK_NSEC_HPET;
-		timename = "HPET";
-	} else {
-		pit_init();
-		timename = "PIT";
-	}
+	setup_irq(0, &irq0);
 
 	tsc_calibrate();
 
@@ -368,46 +329,4 @@ void __init time_init(void)
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
 		cpu_khz / 1000, cpu_khz % 1000);
 	init_tsc_clocksource();
-
-	setup_irq(0, &irq0);
-}
-
-/*
- * sysfs support for the timer.
- */
-
-static int timer_suspend(struct sys_device *dev, pm_message_t state)
-{
-	return 0;
 }
-
-static int timer_resume(struct sys_device *dev)
-{
-	if (hpet_address)
-		hpet_reenable();
-	else
-		i8254_timer_resume();
-	return 0;
-}
-
-static struct sysdev_class timer_sysclass = {
-	.resume = timer_resume,
-	.suspend = timer_suspend,
-	set_kset_name("timer"),
-};
-
-/* XXX this sysfs stuff should probably go elsewhere later -john */
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
diff -puN arch/x86_64/Kconfig~x86_64-convert-to-clockevents arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-convert-to-clockevents
+++ a/arch/x86_64/Kconfig
@@ -28,7 +28,15 @@ config GENERIC_TIME
 	bool
 	default y
 
-config GENERIC_CLOCKEVENTS_MIGR
+config GENERIC_CLOCKEVENTS
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+	default y
+
+config NONIRQ_WAKEUP
 	bool
 	default y
 
diff -puN include/asm-x86/hpet_64.h~x86_64-convert-to-clockevents include/asm-x86/hpet_64.h
--- a/include/asm-x86/hpet_64.h~x86_64-convert-to-clockevents
+++ a/include/asm-x86/hpet_64.h
@@ -1,18 +1 @@
-#ifndef _ASM_X8664_HPET_H
-#define _ASM_X8664_HPET_H 1
-
 #include <asm/hpet_32.h>
-
-#define HPET_TICK_RATE (HZ * 100000UL)
-
-extern int hpet_rtc_timer_init(void);
-extern int hpet_arch_init(void);
-extern int hpet_timer_stop_set_go(unsigned long tick);
-extern int hpet_reenable(void);
-extern unsigned int hpet_calibrate_tsc(void);
-
-extern int hpet_use_timer;
-extern unsigned long hpet_period;
-extern unsigned long hpet_tick;
-
-#endif
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
