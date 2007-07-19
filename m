From: akpm@linux-foundation.org
Subject: - x86_64-convert-to-cleckevents.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:49 -0700
Message-ID: <200707192010.l6JKAnjD020707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932309AbXGSUbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:31:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: convert to clockevents
has been removed from the -mm tree.  Its filename was
     x86_64-convert-to-cleckevents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: convert to clockevents
From: Thomas Gleixner <tglx@linutronix.de>

Convert x86_64 to the clockevents code. Share code with i386 for
hpet and PIT.

Build and whitespace fixups from:
 Venki Pallipadi <venkatesh.pallipadi@intel.com>
and
 Chris Wright <chrisw@sous-sol.org>

Based on an initial patch from Chris Wright <chrisw@sous-sol.org>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c      |   50 ++
 arch/i386/kernel/i8253.c     |    3 
 arch/x86_64/Kconfig          |   12 
 arch/x86_64/kernel/Makefile  |    4 
 arch/x86_64/kernel/apic.c    |  563 ++++++++++++++++++---------------
 arch/x86_64/kernel/hpet.c    |  493 ----------------------------
 arch/x86_64/kernel/i8259.c   |   46 --
 arch/x86_64/kernel/smpboot.c |    4 
 arch/x86_64/kernel/time.c    |  253 +-------------
 arch/x86_64/kernel/tsc.c     |   90 +++++
 include/asm-i386/hpet.h      |  125 ++-----
 include/asm-i386/tsc.h       |    4 
 include/asm-x86_64/apic.h    |    6 
 include/asm-x86_64/hpet.h    |   77 ----
 include/asm-x86_64/i8253.h   |    8 
 include/asm-x86_64/proto.h   |    3 
 16 files changed, 557 insertions(+), 1184 deletions(-)

diff -puN arch/i386/kernel/hpet.c~x86_64-convert-to-cleckevents arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~x86_64-convert-to-cleckevents
+++ a/arch/i386/kernel/hpet.c
@@ -1,11 +1,14 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
+#include <linux/ioport.h>
 #include <linux/sysdev.h>
 #include <linux/pm.h>
 
+#include <asm/fixmap.h>
 #include <asm/hpet.h>
 #include <asm/io.h>
 
@@ -21,6 +24,27 @@ extern struct clock_event_device *global
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
 unsigned long hpet_address;
+
+#ifdef CONFIG_X86_64
+
+#include <asm/pgtable.h>
+#include <asm/vsyscall.h>
+
+static inline void hpet_set_mapping(void)
+{
+	set_fixmap_nocache(FIX_HPET_BASE, hpet_address);
+	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
+}
+
+static inline void __iomem *hpet_get_virt_address(void)
+{
+	return (void __iomem *)fix_to_virt(FIX_HPET_BASE);
+}
+
+static inline void hpet_clear_mapping(void) { }
+
+#else
+
 static void __iomem * hpet_virt_address;
 
 static inline unsigned long hpet_readl(unsigned long a)
@@ -33,6 +57,23 @@ static inline void hpet_writel(unsigned 
 	writel(d, hpet_virt_address + a);
 }
 
+static inline void hpet_set_mapping(void)
+{
+	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+}
+
+static inline void __iomem *hpet_get_virt_address(void)
+{
+	return hpet_virt_address;
+}
+
+static inline void hpet_clear_mapping(void)
+{
+	iounmap(hpet_virt_address);
+	hpet_virt_address = NULL;
+}
+#endif
+
 /*
  * HPET command line enable / disable
  */
@@ -73,7 +114,7 @@ int is_hpet_enabled(void)
 #ifdef CONFIG_HPET
 static void hpet_reserve_platform_timers(unsigned long id)
 {
-	struct hpet __iomem *hpet = hpet_virt_address;
+	struct hpet __iomem *hpet = hpet_get_virt_address();
 	struct hpet_timer __iomem *timer = &hpet->hpet_timers[2];
 	unsigned int nrtimers, i;
 	struct hpet_data hd;
@@ -82,7 +123,7 @@ static void hpet_reserve_platform_timers
 
 	memset(&hd, 0, sizeof (hd));
 	hd.hd_phys_address = hpet_address;
-	hd.hd_address = hpet_virt_address;
+	hd.hd_address = hpet;
 	hd.hd_nirqs = nrtimers;
 	hd.hd_flags = HPET_DATA_PLATFORM;
 	hpet_reserve_timer(&hd, 0);
@@ -237,7 +278,7 @@ int __init hpet_enable(void)
 	if (!is_hpet_capable())
 		return 0;
 
-	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+	hpet_set_mapping();
 
 	/*
 	 * Read the period and check for a sane value:
@@ -333,8 +374,7 @@ int __init hpet_enable(void)
 	return 0;
 
 out_nohpet:
-	iounmap(hpet_virt_address);
-	hpet_virt_address = NULL;
+	hpet_clear_mapping();
 	boot_hpet_disable = 1;
 	return 0;
 }
diff -puN arch/i386/kernel/i8253.c~x86_64-convert-to-cleckevents arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~x86_64-convert-to-cleckevents
+++ a/arch/i386/kernel/i8253.c
@@ -120,6 +120,7 @@ void __init setup_pit_timer(void)
 	global_clock_event = &pit_clockevent;
 }
 
+#ifndef CONFIG_X86_64
 /*
  * Since the PIT overflows every tick, its not very useful
  * to just read by itself. So use jiffies to emulate a free
@@ -204,3 +205,5 @@ static int __init init_pit_clocksource(v
 	return clocksource_register(&clocksource_pit);
 }
 arch_initcall(init_pit_clocksource);
+
+#endif
diff -puN arch/x86_64/Kconfig~x86_64-convert-to-cleckevents arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-convert-to-cleckevents
+++ a/arch/x86_64/Kconfig
@@ -28,6 +28,18 @@ config GENERIC_TIME
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
+config NONIRQ_WAKEUP
+	bool
+	default y
+
 config GENERIC_TIME_VSYSCALL
 	bool
 	default y
diff -puN arch/x86_64/kernel/Makefile~x86_64-convert-to-cleckevents arch/x86_64/kernel/Makefile
--- a/arch/x86_64/kernel/Makefile~x86_64-convert-to-cleckevents
+++ a/arch/x86_64/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y	:= process.o signal.o entry.o trap
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
 		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
 		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o bugs.o \
-		perfctr-watchdog.o sched-clock.o
+		perfctr-watchdog.o sched-clock.o i8253.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
@@ -50,6 +50,8 @@ obj-y				+= pcspeaker.o
 
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
 
+i8253-y				+= ../../i386/kernel/i8253.o
+hpet-y				+= ../../i386/kernel/hpet.o
 therm_throt-y                   += ../../i386/kernel/cpu/mcheck/therm_throt.o
 bootflag-y			+= ../../i386/kernel/bootflag.o
 legacy_serial-y			+= ../../i386/kernel/legacy_serial.o
diff -puN arch/x86_64/kernel/apic.c~x86_64-convert-to-cleckevents arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-convert-to-cleckevents
+++ a/arch/x86_64/kernel/apic.c
@@ -25,6 +25,8 @@
 #include <linux/sysdev.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
+#include <linux/clockchips.h>
+#include <linux/acpi_pmtmr.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -38,10 +40,10 @@
 #include <asm/timex.h>
 #include <asm/hpet.h>
 #include <asm/apic.h>
+#include <asm/i8253.h>
 
 int apic_mapped;
 int apic_verbosity;
-int apic_runs_main_timer;
 int apic_calibrate_pmtmr __initdata;
 
 int disable_apic_timer __initdata;
@@ -50,20 +52,36 @@ int disable_apic_timer __initdata;
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 
+/* Local APIC timer verification ok */
+static int local_apic_timer_verify_ok;
+
 static struct resource *ioapic_resources;
 static struct resource lapic_resource = {
 	.name = "Local APIC",
 	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
 };
 
-/*
- * cpu_mask that denotes the CPUs that needs timer interrupt coming in as
- * IPIs in place of local APIC timers
- */
-static cpumask_t timer_interrupt_broadcast_ipi_mask;
+static unsigned int calibration_result;
 
-/* Using APIC to generate smp_local_timer_interrupt? */
-int using_apic_timer __read_mostly = 0;
+static int lapic_next_event(unsigned long delta,
+			    struct clock_event_device *evt);
+static void lapic_timer_setup(enum clock_event_mode mode,
+			      struct clock_event_device *evt);
+
+static void lapic_timer_broadcast(cpumask_t mask);
+
+static struct clock_event_device lapic_clockevent = {
+	.name		= "lapic",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
+			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
+	.shift		= 32,
+	.set_mode	= lapic_timer_setup,
+	.set_next_event	= lapic_next_event,
+	.broadcast	= lapic_timer_broadcast,
+	.rating		= 100,
+	.irq		= -1,
+};
+static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
 static void apic_pm_activate(void);
 
@@ -92,8 +110,9 @@ unsigned int safe_apic_wait_icr_idle(voi
 void enable_NMI_through_LVT0 (void * dummy)
 {
 	unsigned int v;
-	
-	v = APIC_DM_NMI;                        /* unmask and set to NMI */
+
+	/* unmask and set to NMI */
+	v = APIC_DM_NMI;
 	apic_write(APIC_LVT0, v);
 }
 
@@ -120,7 +139,7 @@ void ack_bad_irq(unsigned int irq)
 	 * holds up an irq slot - in excessive cases (when multiple
 	 * unexpected vectors occur) that might lock up the APIC
 	 * completely.
-  	 * But don't ack when the APIC is disabled. -AK
+	 * But don't ack when the APIC is disabled. -AK
 	 */
 	if (!disable_apic)
 		ack_APIC_irq();
@@ -616,7 +635,7 @@ early_param("apic", apic_set_verbosity);
  * Detect and enable local APICs on non-SMP boards.
  * Original code written by Keir Fraser.
  * On AMD64 we trust the BIOS - if it says no APIC it is likely
- * not correctly set up (usually the APIC timer won't work etc.) 
+ * not correctly set up (usually the APIC timer won't work etc.)
  */
 
 static int __init detect_init_APIC (void)
@@ -759,14 +778,14 @@ void __init init_apic_mappings(void)
 
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
@@ -779,211 +798,298 @@ static void __setup_APIC_LVTT(unsigned i
 				& ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE))
 				| APIC_TDR_DIV_16);
 
-	apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
+	if (!oneshot)
+		apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
 }
 
-static void setup_APIC_timer(unsigned int clocks)
+static int lapic_next_event(unsigned long delta,
+			    struct clock_event_device *evt)
+{
+	apic_write(APIC_TMICT, delta);
+	return 0;
+}
+
+static void lapic_timer_setup(enum clock_event_mode mode,
+			      struct clock_event_device *evt)
 {
 	unsigned long flags;
+	unsigned int v;
+
+	/* Lapic used for broadcast ? */
+	if (!local_apic_timer_verify_ok)
+		return;
 
 	local_irq_save(flags);
 
-	/* wait for irq slice */
- 	if (hpet_address && hpet_use_timer) {
- 		int trigger = hpet_readl(HPET_T0_CMP);
- 		while (hpet_readl(HPET_COUNTER) >= trigger)
- 			/* do nothing */ ;
- 		while (hpet_readl(HPET_COUNTER) <  trigger)
- 			/* do nothing */ ;
- 	} else {
-		int c1, c2;
-		outb_p(0x00, 0x43);
-		c2 = inb_p(0x40);
-		c2 |= inb_p(0x40) << 8;
-		do {
-			c1 = c2;
-			outb_p(0x00, 0x43);
-			c2 = inb_p(0x40);
-			c2 |= inb_p(0x40) << 8;
-		} while (c2 - c1 < 300);
-	}
-	__setup_APIC_LVTT(clocks);
-	/* Turn off PIT interrupt if we use APIC timer as main timer.
-	   Only works with the PM timer right now
-	   TBD fix it for HPET too. */
-	if ((pmtmr_ioport != 0) &&
-		smp_processor_id() == boot_cpu_id &&
-		apic_runs_main_timer == 1 &&
-		!cpu_isset(boot_cpu_id, timer_interrupt_broadcast_ipi_mask)) {
-		stop_timer_interrupt();
-		apic_runs_main_timer++;
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
+		apic_write(APIC_LVTT, v);
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
 	}
+
 	local_irq_restore(flags);
 }
 
 /*
- * In this function we calibrate APIC bus clocks to the external
- * timer. Unfortunately we cannot use jiffies and the timer irq
- * to calibrate, since some later bootup code depends on getting
- * the first irq? Ugh.
- *
- * We want to do the calibration only once since we
- * want to have local timer irqs syncron. CPUs connected
- * by the same APIC bus have the very same bus frequency.
- * And we want to have irqs off anyways, no accidental
- * APIC irq that way.
+ * Local APIC timer broadcast function
  */
-
-#define TICK_COUNT 100000000
-
-static int __init calibrate_APIC_clock(void)
+static void lapic_timer_broadcast(cpumask_t mask)
 {
-	unsigned apic, apic_start;
-	unsigned long tsc, tsc_start;
-	int result;
-	/*
-	 * Put whatever arbitrary (but long enough) timeout
-	 * value into the APIC clock, we just want to get the
-	 * counter running for calibration.
-	 */
-	__setup_APIC_LVTT(4000000000);
-
-	apic_start = apic_read(APIC_TMCCT);
-#ifdef CONFIG_X86_PM_TIMER
-	if (apic_calibrate_pmtmr && pmtmr_ioport) {
-		pmtimer_wait(5000);  /* 5ms wait */
-		apic = apic_read(APIC_TMCCT);
-		result = (apic_start - apic) * 1000L / 5;
-	} else
+#ifdef CONFIG_SMP
+	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
 #endif
-	{
-		rdtscll(tsc_start);
+}
 
-		do {
-			apic = apic_read(APIC_TMCCT);
-			rdtscll(tsc);
-		} while ((tsc - tsc_start) < TICK_COUNT &&
-				(apic_start - apic) < TICK_COUNT);
+static void __devinit setup_APIC_timer(void)
+{
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
-		result = (apic_start - apic) * 1000L * tsc_khz /
-					(tsc - tsc_start);
-	}
-	printk("result %d\n", result);
+	memcpy(levt, &lapic_clockevent, sizeof(*levt));
+	levt->cpumask = cpumask_of_cpu(smp_processor_id());
+
+	clockevents_register_device(levt);
+}
+
+/*
+ * In this functions we calibrate APIC bus clocks to the external timer.
+ *
+ * We want to do the calibration only once since we want to have local timer
+ * irqs syncron. CPUs connected by the same APIC bus have the very same bus
+ * frequency.
+ *
+ * This was previously done by reading the PIT/HPET and waiting for a wrap
+ * around to find out, that a tick has elapsed. I have a box, where the PIT
+ * readout is broken, so it never gets out of the wait loop again. This was
+ * also reported by others.
+ *
+ * Monitoring the jiffies value is inaccurate and the clockevents
+ * infrastructure allows us to do a simple substitution of the interrupt
+ * handler.
+ *
+ * The calibration routine also uses the pm_timer when possible, as the PIT
+ * happens to run way too slow (factor 2.3 on my VAIO CoreDuo, which goes
+ * back to normal later in the boot process).
+ */
 
+#define LAPIC_CAL_LOOPS		(HZ/10)
 
-	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
-		result / 1000 / 1000, result / 1000 % 1000);
+static __initdata int lapic_cal_loops = -1;
+static __initdata long lapic_cal_t1, lapic_cal_t2;
+static __initdata unsigned long long lapic_cal_tsc1, lapic_cal_tsc2;
+static __initdata unsigned long lapic_cal_pm1, lapic_cal_pm2;
+static __initdata unsigned long lapic_cal_j1, lapic_cal_j2;
 
-	return result * APIC_DIVISOR / HZ;
+/*
+ * Temporary interrupt handler.
+ */
+static void __init lapic_cal_handler(struct clock_event_device *dev)
+{
+	unsigned long long tsc = 0;
+	long tapic = apic_read(APIC_TMCCT);
+	unsigned long pm = acpi_pm_read_early();
+
+	if (cpu_has_tsc)
+		rdtscll(tsc);
+
+	switch (lapic_cal_loops++) {
+	case 0:
+		lapic_cal_t1 = tapic;
+		lapic_cal_tsc1 = tsc;
+		lapic_cal_pm1 = pm;
+		lapic_cal_j1 = jiffies;
+		break;
+
+	case LAPIC_CAL_LOOPS:
+		lapic_cal_t2 = tapic;
+		lapic_cal_tsc2 = tsc;
+		if (pm < lapic_cal_pm1)
+			pm += ACPI_PM_OVRRUN;
+		lapic_cal_pm2 = pm;
+		lapic_cal_j2 = jiffies;
+		break;
+	}
 }
 
-static unsigned int calibration_result;
-
 void __init setup_boot_APIC_clock (void)
 {
-	if (disable_apic_timer) { 
-		printk(KERN_INFO "Disabling APIC timer\n"); 
-		return; 
-	} 
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
+	const long pm_100ms = PMTMR_TICKS_PER_SEC/10;
+	const long pm_thresh = pm_100ms/100;
+	void (*real_handler)(struct clock_event_device *dev);
+	unsigned long deltaj;
+	long delta, deltapm;
+	int pm_referenced = 0;
+
+	/*
+	 * The local apic timer can be disabled via the kernel
+	 * commandline or from the test above. Register the lapic
+	 * timer as a dummy clock event source on SMP systems, so the
+	 * broadcast mechanism is used. On UP systems simply ignore it.
+	 */
+	if (disable_apic_timer) {
+		printk(KERN_INFO "Disabling APIC timer\n");
+		/* No broadcast on UP ! */
+		if (num_possible_cpus() > 1)
+			setup_APIC_timer();
+		return;
+	}
 
 	printk(KERN_INFO "Using local APIC timer interrupts.\n");
-	using_apic_timer = 1;
 
-	local_irq_disable();
+	/* Replace the global interrupt handler */
+	real_handler = global_clock_event->event_handler;
+	global_clock_event->event_handler = lapic_cal_handler;
 
-	calibration_result = calibrate_APIC_clock();
 	/*
-	 * Now set up the timer for real.
+	 * Setup the APIC counter to 1e9. There is no way the lapic
+	 * can underflow in the 100ms detection time frame
 	 */
-	setup_APIC_timer(calibration_result);
+	__setup_APIC_LVTT(1000000000, 0, 0);
 
+	/* Let the interrupts run */
 	local_irq_enable();
-}
 
-void __cpuinit setup_secondary_APIC_clock(void)
-{
-	local_irq_disable(); /* FIXME: Do we need this? --RR */
-	setup_APIC_timer(calibration_result);
-	local_irq_enable();
-}
+	while (lapic_cal_loops <= LAPIC_CAL_LOOPS)
+		cpu_relax();
 
-void disable_APIC_timer(void)
-{
-	if (using_apic_timer) {
-		unsigned long v;
+	local_irq_disable();
 
-		v = apic_read(APIC_LVTT);
-		/*
-		 * When an illegal vector value (0-15) is written to an LVT
-		 * entry and delivery mode is Fixed, the APIC may signal an
-		 * illegal vector error, with out regard to whether the mask
-		 * bit is set or whether an interrupt is actually seen on input.
-		 *
-		 * Boot sequence might call this function when the LVTT has
-		 * '0' vector value. So make sure vector field is set to
-		 * valid value.
-		 */
-		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
-		apic_write(APIC_LVTT, v);
+	/* Restore the real event handler */
+	global_clock_event->event_handler = real_handler;
+
+	/* Build delta t1-t2 as apic timer counts down */
+	delta = lapic_cal_t1 - lapic_cal_t2;
+	apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
+
+	/* Check, if the PM timer is available */
+	deltapm = lapic_cal_pm2 - lapic_cal_pm1;
+	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
+
+	if (deltapm) {
+		unsigned long mult;
+		u64 res;
+
+		mult = clocksource_hz2mult(PMTMR_TICKS_PER_SEC, 22);
+
+		if (deltapm > (pm_100ms - pm_thresh) &&
+		    deltapm < (pm_100ms + pm_thresh)) {
+			apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
+		} else {
+			res = (((u64) deltapm) *  mult) >> 22;
+			do_div(res, 1000000);
+			printk(KERN_WARNING "APIC calibration not consistent "
+			       "with PM Timer: %ldms instead of 100ms\n",
+			       (long)res);
+			/* Correct the lapic counter value */
+			res = (((u64) delta ) * pm_100ms);
+			do_div(res, deltapm);
+			printk(KERN_INFO "APIC delta adjusted to PM-Timer: "
+			       "%lu (%ld)\n", (unsigned long) res, delta);
+			delta = (long) res;
+		}
+		pm_referenced = 1;
 	}
-}
 
-void enable_APIC_timer(void)
-{
-	int cpu = smp_processor_id();
+	/* Calculate the scaled math multiplication factor */
+	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS, 32);
+	lapic_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+	lapic_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &lapic_clockevent);
 
-	if (using_apic_timer &&
-	    !cpu_isset(cpu, timer_interrupt_broadcast_ipi_mask)) {
-		unsigned long v;
+	calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
 
-		v = apic_read(APIC_LVTT);
-		apic_write(APIC_LVTT, v & ~APIC_LVT_MASKED);
+	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
+	apic_printk(APIC_VERBOSE, "..... mult: %ld\n", lapic_clockevent.mult);
+	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
+		    calibration_result);
+
+	if (cpu_has_tsc) {
+		delta = (long)(lapic_cal_tsc2 - lapic_cal_tsc1);
+		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
+			    "%ld.%04ld MHz.\n",
+			    (delta / LAPIC_CAL_LOOPS) / (1000000 / HZ),
+			    (delta / LAPIC_CAL_LOOPS) % (1000000 / HZ));
 	}
-}
 
-void switch_APIC_timer_to_ipi(void *cpumask)
-{
-	cpumask_t mask = *(cpumask_t *)cpumask;
-	int cpu = smp_processor_id();
+	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
+		    "%u.%04u MHz.\n",
+		    calibration_result / (1000000 / HZ),
+		    calibration_result % (1000000 / HZ));
 
-	if (cpu_isset(cpu, mask) &&
-	    !cpu_isset(cpu, timer_interrupt_broadcast_ipi_mask)) {
-		disable_APIC_timer();
-		cpu_set(cpu, timer_interrupt_broadcast_ipi_mask);
-	}
-}
-EXPORT_SYMBOL(switch_APIC_timer_to_ipi);
+	local_apic_timer_verify_ok = 1;
 
-void smp_send_timer_broadcast_ipi(void)
-{
-	int cpu = smp_processor_id();
-	cpumask_t mask;
+	/* We trust the pm timer based calibration */
+	if (!pm_referenced) {
+		apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
 
-	cpus_and(mask, cpu_online_map, timer_interrupt_broadcast_ipi_mask);
+		/*
+		 * Setup the apic timer manually
+		 */
+		levt->event_handler = lapic_cal_handler;
+		lapic_timer_setup(CLOCK_EVT_MODE_PERIODIC, levt);
+		lapic_cal_loops = -1;
 
-	if (cpu_isset(cpu, mask)) {
-		cpu_clear(cpu, mask);
-		add_pda(apic_timer_irqs, 1);
-		smp_local_timer_interrupt();
-	}
+		/* Let the interrupts run */
+		local_irq_enable();
+
+		while (lapic_cal_loops <= LAPIC_CAL_LOOPS)
+			cpu_relax();
+
+		local_irq_disable();
+
+		/* Stop the lapic timer */
+		lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, levt);
+
+		local_irq_enable();
 
-	if (!cpus_empty(mask)) {
-		send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
+		/* Jiffies delta */
+		deltaj = lapic_cal_j2 - lapic_cal_j1;
+		apic_printk(APIC_VERBOSE, "... jiffies delta = %lu\n", deltaj);
+
+		/* Check, if the jiffies result is consistent */
+		if (deltaj >= LAPIC_CAL_LOOPS-2 && deltaj <= LAPIC_CAL_LOOPS+2)
+			apic_printk(APIC_VERBOSE, "... jiffies result ok\n");
+		else
+			local_apic_timer_verify_ok = 0;
+	} else
+		local_irq_enable();
+
+	if (!local_apic_timer_verify_ok) {
+		printk(KERN_WARNING
+		       "APIC timer disabled due to verification failure.\n");
+		/* No broadcast on UP ! */
+		if (num_possible_cpus() == 1)
+			return;
+	} else {
+		/*
+		 * If nmi_watchdog is set to IO_APIC, we need the
+		 * PIT/HPET going.  Otherwise register lapic as a dummy
+		 * device.
+		 */
+		if (nmi_watchdog != NMI_IO_APIC)
+			lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
 	}
+
+	/* Setup the lapic or request the broadcast */
+	setup_APIC_timer();
 }
 
-void switch_ipi_to_APIC_timer(void *cpumask)
+void __cpuinit setup_secondary_APIC_clock(void)
 {
-	cpumask_t mask = *(cpumask_t *)cpumask;
-	int cpu = smp_processor_id();
-
-	if (cpu_isset(cpu, mask) &&
-	    cpu_isset(cpu, timer_interrupt_broadcast_ipi_mask)) {
-		cpu_clear(cpu, timer_interrupt_broadcast_ipi_mask);
-		enable_APIC_timer();
-	}
+	setup_APIC_timer();
 }
-EXPORT_SYMBOL(switch_ipi_to_APIC_timer);
 
 int setup_profiling_timer(unsigned int multiplier)
 {
@@ -995,11 +1101,10 @@ void setup_APIC_extended_lvt(unsigned ch
 {
 	unsigned long reg = (lvt_off << 4) + K8_APIC_EXT_LVT_BASE;
 	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
+
 	apic_write(reg, v);
 }
 
-#undef APIC_DIVISOR
-
 /*
  * Local timer interrupt handler. It does both profiling and
  * process statistics/rescheduling.
@@ -1010,24 +1115,36 @@ void setup_APIC_extended_lvt(unsigned ch
  * value into /proc/profile.
  */
 
-void smp_local_timer_interrupt(void)
+void local_apic_timer_interrupt(void)
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
-	 *
-	 * We might want to decouple profiling from the 'long path',
-	 * and do the profiling totally in assembly.
+	 * Normally we should not be here till LAPIC has been initialized but
+	 * in some cases like kdump, its possible that there is a pending LAPIC
+	 * timer interrupt from previous kernel's context and is delivered in
+	 * new kernel the moment interrupts are enabled.
 	 *
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
@@ -1043,11 +1160,6 @@ void smp_apic_timer_interrupt(struct pt_
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
@@ -1059,7 +1171,7 @@ void smp_apic_timer_interrupt(struct pt_
 	 */
 	exit_idle();
 	irq_enter();
-	smp_local_timer_interrupt();
+	local_apic_timer_interrupt();
 	irq_exit();
 	set_irq_regs(old_regs);
 }
@@ -1127,21 +1239,6 @@ asmlinkage void smp_spurious_interrupt(v
 	v = apic_read(APIC_ISR + ((SPURIOUS_APIC_VECTOR & ~0x1f) >> 1));
 	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
 		ack_APIC_irq();
-
-#if 0
-	static unsigned long last_warning; 
-	static unsigned long skipped; 
-
-	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
-	if (time_before(last_warning+30*HZ,jiffies)) { 
-		printk(KERN_INFO "spurious APIC interrupt on CPU#%d, %ld skipped.\n",
-		       smp_processor_id(), skipped);
-		last_warning = jiffies; 
-		skipped = 0;
-	} else { 
-		skipped++; 
-	} 
-#endif 
 	irq_exit();
 }
 
@@ -1173,11 +1270,11 @@ asmlinkage void smp_error_interrupt(void
 	   7: Illegal register address
 	*/
 	printk (KERN_DEBUG "APIC error on CPU%d: %02x(%02x)\n",
-	        smp_processor_id(), v , v1);
+		smp_processor_id(), v , v1);
 	irq_exit();
 }
 
-int disable_apic; 
+int disable_apic;
 
 /*
  * This initializes the IO-APIC and APIC hardware if this is
@@ -1185,11 +1282,11 @@ int disable_apic; 
  */
 int __init APIC_init_uniprocessor (void)
 {
-	if (disable_apic) { 
+	if (disable_apic) {
 		printk(KERN_INFO "Apic disabled\n");
-		return -1; 
+		return -1;
 	}
-	if (!cpu_has_apic) { 
+	if (!cpu_has_apic) {
 		disable_apic = 1;
 		printk(KERN_INFO "Apic disabled by BIOS\n");
 		return -1;
@@ -1211,8 +1308,8 @@ int __init APIC_init_uniprocessor (void)
 	return 0;
 }
 
-static __init int setup_disableapic(char *str) 
-{ 
+static __init int setup_disableapic(char *str)
+{
 	disable_apic = 1;
 	clear_bit(X86_FEATURE_APIC, boot_cpu_data.x86_capability);
 	return 0;
@@ -1220,10 +1317,10 @@ static __init int setup_disableapic(char
 early_param("disableapic", setup_disableapic);
 
 /* same as disableapic, for compatibility */
-static __init int setup_nolapic(char *str) 
-{ 
+static __init int setup_nolapic(char *str)
+{
 	return setup_disableapic(str);
-} 
+}
 early_param("nolapic", setup_nolapic);
 
 static int __init parse_lapic_timer_c2_ok(char *arg)
@@ -1233,36 +1330,12 @@ static int __init parse_lapic_timer_c2_o
 }
 early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
 
-static __init int setup_noapictimer(char *str) 
-{ 
+static __init int setup_noapictimer(char *str)
+{
 	if (str[0] != ' ' && str[0] != 0)
 		return 0;
 	disable_apic_timer = 1;
 	return 1;
-} 
-
-static __init int setup_apicmaintimer(char *str)
-{
-	apic_runs_main_timer = 1;
-	nohpet = 1;
-	return 1;
 }
-__setup("apicmaintimer", setup_apicmaintimer);
-
-static __init int setup_noapicmaintimer(char *str)
-{
-	apic_runs_main_timer = -1;
-	return 1;
-}
-__setup("noapicmaintimer", setup_noapicmaintimer);
-
-static __init int setup_apicpmtimer(char *s)
-{
-	apic_calibrate_pmtmr = 1;
-	notsc_setup(NULL);
-	return setup_apicmaintimer(NULL);
-}
-__setup("apicpmtimer", setup_apicpmtimer);
-
-__setup("noapictimer", setup_noapictimer); 
+__setup("noapictimer", setup_noapictimer);
 
diff -puN arch/x86_64/kernel/hpet.c~x86_64-convert-to-cleckevents /dev/null
--- a/arch/x86_64/kernel/hpet.c
+++ /dev/null
@@ -1,493 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/mc146818rtc.h>
-#include <linux/time.h>
-#include <linux/clocksource.h>
-#include <linux/ioport.h>
-#include <linux/acpi.h>
-#include <linux/hpet.h>
-#include <asm/pgtable.h>
-#include <asm/vsyscall.h>
-#include <asm/timex.h>
-#include <asm/hpet.h>
-
-#define HPET_MASK	0xFFFFFFFF
-#define HPET_SHIFT	22
-
-/* FSEC = 10^-15 NSEC = 10^-9 */
-#define FSEC_PER_NSEC	1000000
-
-int nohpet __initdata;
-
-unsigned long hpet_address;
-unsigned long hpet_period;	/* fsecs / HPET clock */
-unsigned long hpet_tick;	/* HPET clocks / interrupt */
-
-int hpet_use_timer;		/* Use counter of hpet for time keeping,
-				 * otherwise PIT
-				 */
-
-#ifdef	CONFIG_HPET
-static __init int late_hpet_init(void)
-{
-	struct hpet_data	hd;
-	unsigned int 		ntimer;
-
-	if (!hpet_address)
-        	return 0;
-
-	memset(&hd, 0, sizeof(hd));
-
-	ntimer = hpet_readl(HPET_ID);
-	ntimer = (ntimer & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT;
-	ntimer++;
-
-	/*
-	 * Register with driver.
-	 * Timer0 and Timer1 is used by platform.
-	 */
-	hd.hd_phys_address = hpet_address;
-	hd.hd_address = (void __iomem *)fix_to_virt(FIX_HPET_BASE);
-	hd.hd_nirqs = ntimer;
-	hd.hd_flags = HPET_DATA_PLATFORM;
-	hpet_reserve_timer(&hd, 0);
-#ifdef	CONFIG_HPET_EMULATE_RTC
-	hpet_reserve_timer(&hd, 1);
-#endif
-	hd.hd_irq[0] = HPET_LEGACY_8254;
-	hd.hd_irq[1] = HPET_LEGACY_RTC;
-	if (ntimer > 2) {
-		struct hpet		*hpet;
-		struct hpet_timer	*timer;
-		int			i;
-
-		hpet = (struct hpet *) fix_to_virt(FIX_HPET_BASE);
-		timer = &hpet->hpet_timers[2];
-		for (i = 2; i < ntimer; timer++, i++)
-			hd.hd_irq[i] = (timer->hpet_config &
-					Tn_INT_ROUTE_CNF_MASK) >>
-				Tn_INT_ROUTE_CNF_SHIFT;
-
-	}
-
-	hpet_alloc(&hd);
-	return 0;
-}
-fs_initcall(late_hpet_init);
-#endif
-
-int hpet_timer_stop_set_go(unsigned long tick)
-{
-	unsigned int cfg;
-
-/*
- * Stop the timers and reset the main counter.
- */
-
-	cfg = hpet_readl(HPET_CFG);
-	cfg &= ~(HPET_CFG_ENABLE | HPET_CFG_LEGACY);
-	hpet_writel(cfg, HPET_CFG);
-	hpet_writel(0, HPET_COUNTER);
-	hpet_writel(0, HPET_COUNTER + 4);
-
-/*
- * Set up timer 0, as periodic with first interrupt to happen at hpet_tick,
- * and period also hpet_tick.
- */
-	if (hpet_use_timer) {
-		hpet_writel(HPET_TN_ENABLE | HPET_TN_PERIODIC | HPET_TN_SETVAL |
-		    HPET_TN_32BIT, HPET_T0_CFG);
-		hpet_writel(hpet_tick, HPET_T0_CMP); /* next interrupt */
-		hpet_writel(hpet_tick, HPET_T0_CMP); /* period */
-		cfg |= HPET_CFG_LEGACY;
-	}
-/*
- * Go!
- */
-
-	cfg |= HPET_CFG_ENABLE;
-	hpet_writel(cfg, HPET_CFG);
-
-	return 0;
-}
-
-static cycle_t read_hpet(void)
-{
-	return (cycle_t)hpet_readl(HPET_COUNTER);
-}
-
-static cycle_t __vsyscall_fn vread_hpet(void)
-{
-	return readl((void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
-}
-
-struct clocksource clocksource_hpet = {
-	.name		= "hpet",
-	.rating		= 250,
-	.read		= read_hpet,
-	.mask		= (cycle_t)HPET_MASK,
-	.mult		= 0, /* set below */
-	.shift		= HPET_SHIFT,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-	.vread		= vread_hpet,
-};
-
-int hpet_arch_init(void)
-{
-	unsigned int id;
-	u64 tmp;
-
-	if (!hpet_address)
-		return -1;
-	set_fixmap_nocache(FIX_HPET_BASE, hpet_address);
-	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
-
-/*
- * Read the period, compute tick and quotient.
- */
-
-	id = hpet_readl(HPET_ID);
-
-	if (!(id & HPET_ID_VENDOR) || !(id & HPET_ID_NUMBER))
-		return -1;
-
-	hpet_period = hpet_readl(HPET_PERIOD);
-	if (hpet_period < 100000 || hpet_period > 100000000)
-		return -1;
-
-	hpet_tick = (FSEC_PER_TICK + hpet_period / 2) / hpet_period;
-
-	hpet_use_timer = (id & HPET_ID_LEGSUP);
-
-	/*
-	 * hpet period is in femto seconds per cycle
-	 * so we need to convert this to ns/cyc units
-	 * aproximated by mult/2^shift
-	 *
-	 *  fsec/cyc * 1nsec/1000000fsec = nsec/cyc = mult/2^shift
-	 *  fsec/cyc * 1ns/1000000fsec * 2^shift = mult
-	 *  fsec/cyc * 2^shift * 1nsec/1000000fsec = mult
-	 *  (fsec/cyc << shift)/1000000 = mult
-	 *  (hpet_period << shift)/FSEC_PER_NSEC = mult
-	 */
-	tmp = (u64)hpet_period << HPET_SHIFT;
-	do_div(tmp, FSEC_PER_NSEC);
-	clocksource_hpet.mult = (u32)tmp;
-	clocksource_register(&clocksource_hpet);
-
-	return hpet_timer_stop_set_go(hpet_tick);
-}
-
-int hpet_reenable(void)
-{
-	return hpet_timer_stop_set_go(hpet_tick);
-}
-
-/*
- * calibrate_tsc() calibrates the processor TSC in a very simple way, comparing
- * it to the HPET timer of known frequency.
- */
-
-#define TICK_COUNT 100000000
-#define TICK_MIN   5000
-#define MAX_TRIES  5
-
-/*
- * Some platforms take periodic SMI interrupts with 5ms duration. Make sure none
- * occurs between the reads of the hpet & TSC.
- */
-static void __init read_hpet_tsc(int *hpet, int *tsc)
-{
-	int tsc1, tsc2, hpet1, i;
-
-	for (i = 0; i < MAX_TRIES; i++) {
-		tsc1 = get_cycles_sync();
-		hpet1 = hpet_readl(HPET_COUNTER);
-		tsc2 = get_cycles_sync();
-		if (tsc2 - tsc1 > TICK_MIN)
-			break;
-	}
-	*hpet = hpet1;
-	*tsc = tsc2;
-}
-
-unsigned int __init hpet_calibrate_tsc(void)
-{
-	int tsc_start, hpet_start;
-	int tsc_now, hpet_now;
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	read_hpet_tsc(&hpet_start, &tsc_start);
-
-	do {
-		local_irq_disable();
-		read_hpet_tsc(&hpet_now, &tsc_now);
-		local_irq_restore(flags);
-	} while ((tsc_now - tsc_start) < TICK_COUNT &&
-		(hpet_now - hpet_start) < TICK_COUNT);
-
-	return (tsc_now - tsc_start) * 1000000000L
-		/ ((hpet_now - hpet_start) * hpet_period / 1000);
-}
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
-int is_hpet_enabled(void)
-{
-	return hpet_address != 0;
-}
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
-		if (printk_ratelimit())
-			printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
-			       hpet_rtc_int_freq);
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
-irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id, struct pt_regs *regs)
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
-static int __init nohpet_setup(char *s)
-{
-	nohpet = 1;
-	return 1;
-}
-
-__setup("nohpet", nohpet_setup);
diff -puN arch/x86_64/kernel/i8259.c~x86_64-convert-to-cleckevents arch/x86_64/kernel/i8259.c
--- a/arch/x86_64/kernel/i8259.c~x86_64-convert-to-cleckevents
+++ a/arch/x86_64/kernel/i8259.c
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
diff -puN arch/x86_64/kernel/smpboot.c~x86_64-convert-to-cleckevents arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~x86_64-convert-to-cleckevents
+++ a/arch/x86_64/kernel/smpboot.c
@@ -223,8 +223,6 @@ void __cpuinit smp_callin(void)
 	local_irq_disable();
 	Dprintk("Stack at about %p\n",&cpuid);
 
-	disable_APIC_timer();
-
 	/*
 	 * Save our processor parameters
 	 */
@@ -348,8 +346,6 @@ void __cpuinit start_secondary(void)
 		enable_8259A_irq(0);
 	}
 
-	enable_APIC_timer();
-
 	/*
 	 * The sibling maps must be set before turing the online map on for
 	 * this cpu
diff -puN arch/x86_64/kernel/time.c~x86_64-convert-to-cleckevents arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~x86_64-convert-to-cleckevents
+++ a/arch/x86_64/kernel/time.c
@@ -28,11 +28,11 @@
 #include <linux/cpu.h>
 #include <linux/kallsyms.h>
 #include <linux/acpi.h>
+#include <linux/clockchips.h>
 #ifdef CONFIG_ACPI
 #include <acpi/achware.h>	/* for PM timer frequency */
 #include <acpi/acpi_bus.h>
 #endif
-#include <asm/8253pit.h>
 #include <asm/i8253.h>
 #include <asm/pgtable.h>
 #include <asm/vsyscall.h>
@@ -47,12 +47,8 @@
 #include <asm/nmi.h>
 #include <asm/vgtod.h>
 
-static char *timename = NULL;
-
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
-DEFINE_SPINLOCK(i8253_lock);
-EXPORT_SYMBOL(i8253_lock);
 
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
@@ -153,49 +149,14 @@ int update_persistent_clock(struct times
 	return set_rtc_mmss(now.tv_sec);
 }
 
-void main_timer_handler(void)
-{
-/*
- * Here we are in the timer irq handler. We have irqs locally disabled (so we
- * don't need spin_lock_irqsave()) but we don't know if the timer_bh is running
- * on the other CPU, so we need a lock. We also need to lock the vsyscall
- * variables, because both do_timer() and us change them -arca+vojtech
- */
-
-	write_seqlock(&xtime_lock);
-
-/*
- * Do the timer stuff.
- */
-
-	do_timer(1);
-#ifndef CONFIG_SMP
-	update_process_times(user_mode(get_irq_regs()));
-#endif
-
-/*
- * In the SMP case we use the local APIC timer interrupt to do the profiling,
- * except when we simulate SMP mode on a uniprocessor system, in that case we
- * have to call the local interrupt handler.
- */
-
-	if (!using_apic_timer)
-		smp_local_timer_interrupt();
-
-	write_sequnlock(&xtime_lock);
-}
-
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
-	if (apic_runs_main_timer > 1)
-		return IRQ_HANDLED;
-	main_timer_handler();
-	if (using_apic_timer)
-		smp_send_timer_broadcast_ipi();
+	global_clock_event->event_handler(global_clock_event);
+
 	return IRQ_HANDLED;
 }
 
-static unsigned long get_cmos_time(void)
+unsigned long read_persistent_clock(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
 	unsigned long flags;
@@ -222,7 +183,7 @@ static unsigned long get_cmos_time(void)
 	/*
 	 * We know that x86-64 always uses BCD format, no need to check the
 	 * config register.
- 	 */
+	 */
 
 	BCD_TO_BIN(sec);
 	BCD_TO_BIN(min);
@@ -235,11 +196,11 @@ static unsigned long get_cmos_time(void)
 		BCD_TO_BIN(century);
 		year += century * 100;
 		printk(KERN_INFO "Extended CMOS year: %d\n", century * 100);
-	} else { 
+	} else {
 		/*
 		 * x86-64 systems only exists since 2002.
 		 * This will work up to Dec 31, 2100
-	 	 */
+		 */
 		year += 2000;
 	}
 
@@ -257,17 +218,17 @@ static unsigned int __init tsc_calibrate
        unsigned long flags;
 
        for (i = 0; i < 4; i++)
-               if (avail_to_resrv_perfctr_nmi_bit(i))
-                       break;
+		if (avail_to_resrv_perfctr_nmi_bit(i))
+			break;
        no_ctr_free = (i == 4);
        if (no_ctr_free) {
-               i = 3;
-               rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
-               wrmsrl(MSR_K7_EVNTSEL3, 0);
-               rdmsrl(MSR_K7_PERFCTR3, pmc3);
+		i = 3;
+		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		rdmsrl(MSR_K7_PERFCTR3, pmc3);
        } else {
-               reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-               reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
        }
        local_irq_save(flags);
        /* start meauring cycles, incrementing from 0 */
@@ -275,119 +236,38 @@ static unsigned int __init tsc_calibrate
        wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
        rdtscl(tsc_start);
        do {
-               rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
-               tsc_now = get_cycles_sync();
+		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
+		tsc_now = get_cycles_sync();
        } while ((tsc_now - tsc_start) < TICK_COUNT);
 
        local_irq_restore(flags);
        if (no_ctr_free) {
-               wrmsrl(MSR_K7_EVNTSEL3, 0);
-               wrmsrl(MSR_K7_PERFCTR3, pmc3);
-               wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		wrmsrl(MSR_K7_PERFCTR3, pmc3);
+		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
        } else {
-               release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-               release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
        }
 
        return pmc_now * tsc_khz / (tsc_now - tsc_start);
 }
 
-/*
- * pit_calibrate_tsc() uses the speaker output (channel 2) of
- * the PIT. This is better than using the timer interrupt output,
- * because we can read the value of the speaker with just one inb(),
- * where we need three i/o operations for the interrupt channel.
- * We count how many ticks the TSC does in 50 ms.
- */
-
-static unsigned int __init pit_calibrate_tsc(void)
-{
-	unsigned long start, end;
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8253_lock, flags);
-
-	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
-
-	outb(0xb0, 0x43);
-	outb((PIT_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
-	outb((PIT_TICK_RATE / (1000 / 50)) >> 8, 0x42);
-	start = get_cycles_sync();
-	while ((inb(0x61) & 0x20) == 0);
-	end = get_cycles_sync();
-
-	spin_unlock_irqrestore(&i8253_lock, flags);
-	
-	return (end - start) / 50;
-}
-
-#define PIT_MODE 0x43
-#define PIT_CH0  0x40
-
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
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
-	.name 		= "timer"
+	.name		= "timer"
 };
 
 void __init time_init(void)
 {
-	if (nohpet)
-		hpet_address = 0;
-	xtime.tv_sec = get_cmos_time();
-	xtime.tv_nsec = 0;
-
-	set_normalized_timespec(&wall_to_monotonic,
-	                        -xtime.tv_sec, -xtime.tv_nsec);
-
-	if (hpet_arch_init())
-		hpet_address = 0;
-
-	if (hpet_use_timer) {
-		/* set tick_nsec to use the proper rate for HPET */
-	  	tick_nsec = TICK_NSEC_HPET;
-		tsc_khz = hpet_calibrate_tsc();
-		timename = "HPET";
-	} else {
-		pit_init();
-		tsc_khz = pit_calibrate_tsc();
-		timename = "PIT";
-	}
+	if (!hpet_enable())
+		setup_pit_timer();
+
+	setup_irq(0, &irq0);
+
+	tsc_calibrate();
 
 	cpu_khz = tsc_khz;
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
@@ -406,79 +286,4 @@ void __init time_init(void)
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
 		cpu_khz / 1000, cpu_khz % 1000);
 	init_tsc_clocksource();
-
-	setup_irq(0, &irq0);
 }
-
-
-static long clock_cmos_diff;
-static unsigned long sleep_start;
-
-/*
- * sysfs support for the timer.
- */
-
-static int timer_suspend(struct sys_device *dev, pm_message_t state)
-{
-	/*
-	 * Estimate time zone so that set_time can update the clock
-	 */
-	long cmos_time =  get_cmos_time();
-
-	clock_cmos_diff = -cmos_time;
-	clock_cmos_diff += get_seconds();
-	sleep_start = cmos_time;
-	return 0;
-}
-
-static int timer_resume(struct sys_device *dev)
-{
-	unsigned long flags;
-	unsigned long sec;
-	unsigned long ctime = get_cmos_time();
-	long sleep_length = (ctime - sleep_start) * HZ;
-
-	if (sleep_length < 0) {
-		printk(KERN_WARNING "Time skew detected in timer resume!\n");
-		/* The time after the resume must not be earlier than the time
-		 * before the suspend or some nasty things will happen
-		 */
-		sleep_length = 0;
-		ctime = sleep_start;
-	}
-	if (hpet_address)
-		hpet_reenable();
-	else
-		i8254_timer_resume();
-
-	sec = ctime + clock_cmos_diff;
-	write_seqlock_irqsave(&xtime_lock,flags);
-	xtime.tv_sec = sec;
-	xtime.tv_nsec = 0;
-	jiffies += sleep_length;
-	write_sequnlock_irqrestore(&xtime_lock,flags);
-	touch_softlockup_watchdog();
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
diff -puN arch/x86_64/kernel/tsc.c~x86_64-convert-to-cleckevents arch/x86_64/kernel/tsc.c
--- a/arch/x86_64/kernel/tsc.c~x86_64-convert-to-cleckevents
+++ a/arch/x86_64/kernel/tsc.c
@@ -6,7 +6,9 @@
 #include <linux/time.h>
 #include <linux/acpi.h>
 #include <linux/cpufreq.h>
+#include <linux/acpi_pmtmr.h>
 
+#include <asm/hpet.h>
 #include <asm/timex.h>
 
 static int notsc __initdata = 0;
@@ -90,6 +92,94 @@ core_initcall(cpufreq_tsc);
 
 #endif
 
+#define MAX_RETRIES	5
+#define SMI_TRESHOLD	50000
+
+/*
+ * Read TSC and the reference counters. Take care of SMI disturbance
+ */
+static unsigned long __init tsc_read_refs(unsigned long *pm,
+					  unsigned long *hpet)
+{
+	unsigned long t1, t2;
+	int i;
+
+	for (i = 0; i < MAX_RETRIES; i++) {
+		t1 = get_cycles_sync();
+		if (hpet)
+			*hpet = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
+		else
+			*pm = acpi_pm_read_early();
+		t2 = get_cycles_sync();
+		if ((t2 - t1) < SMI_TRESHOLD)
+			return t2;
+	}
+	return ULONG_MAX;
+}
+
+/**
+ * tsc_calibrate - calibrate the tsc on boot
+ */
+void __init tsc_calibrate(void)
+{
+	unsigned long flags, tsc1, tsc2, tr1, tr2, pm1, pm2, hpet1, hpet2;
+	int hpet = is_hpet_enabled();
+
+	local_irq_save(flags);
+
+	tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
+
+	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
+
+	outb(0xb0, 0x43);
+	outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
+	outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
+	tr1 = get_cycles_sync();
+	while ((inb(0x61) & 0x20) == 0);
+	tr2 = get_cycles_sync();
+
+	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
+
+	local_irq_restore(flags);
+
+	/*
+	 * Preset the result with the raw and inaccurate PIT
+	 * calibration value
+	 */
+	tsc_khz = (tr2 - tr1) / 50;
+
+	/* hpet or pmtimer available ? */
+	if (!hpet && !pm1 && !pm2) {
+		printk(KERN_INFO "TSC calibrated against PIT\n");
+		return;
+	}
+
+	/* Check, whether the sampling was disturbed by an SMI */
+	if (tsc1 == ULONG_MAX || tsc2 == ULONG_MAX) {
+		printk(KERN_WARNING "TSC calibration disturbed by SMI, "
+		       "using PIT calibration result\n");
+		return;
+	}
+
+	tsc2 = (tsc2 - tsc1) * 1000000L;
+
+	if (hpet) {
+		printk(KERN_INFO "TSC calibrated against HPET\n");
+		if (hpet2 < hpet1)
+			hpet2 += 0x100000000;
+		hpet2 -= hpet1;
+		tsc1 = (hpet2 * hpet_readl(HPET_PERIOD)) / 1000000;
+	} else {
+		printk(KERN_INFO "TSC calibrated against PM_TIMER\n");
+		if (pm2 < pm1)
+			pm2 += ACPI_PM_OVRRUN;
+		pm2 -= pm1;
+		tsc1 = (pm2 * 1000000000) / PMTMR_TICKS_PER_SEC;
+	}
+
+	tsc_khz = tsc2 / tsc1;
+}
+
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
diff -puN include/asm-i386/hpet.h~x86_64-convert-to-cleckevents include/asm-i386/hpet.h
--- a/include/asm-i386/hpet.h~x86_64-convert-to-cleckevents
+++ a/include/asm-i386/hpet.h
@@ -4,112 +4,87 @@
 
 #ifdef CONFIG_HPET_TIMER
 
-#include <linux/errno.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/param.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/time.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/smp.h>
-
-#include <asm/io.h>
-#include <asm/smp.h>
-#include <asm/irq.h>
-#include <asm/msr.h>
-#include <asm/delay.h>
-#include <asm/mpspec.h>
-#include <asm/uaccess.h>
-#include <asm/processor.h>
-
-#include <linux/timex.h>
-
 /*
  * Documentation on HPET can be found at:
  *      http://www.intel.com/ial/home/sp/pcmmspec.htm
  *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
  */
 
-#define HPET_MMAP_SIZE	1024
+#define HPET_MMAP_SIZE		1024
 
-#define HPET_ID		0x000
-#define HPET_PERIOD	0x004
-#define HPET_CFG	0x010
-#define HPET_STATUS	0x020
-#define HPET_COUNTER	0x0f0
-#define HPET_T0_CFG	0x100
-#define HPET_T0_CMP	0x108
-#define HPET_T0_ROUTE	0x110
-#define HPET_T1_CFG	0x120
-#define HPET_T1_CMP	0x128
-#define HPET_T1_ROUTE	0x130
-#define HPET_T2_CFG	0x140
-#define HPET_T2_CMP	0x148
-#define HPET_T2_ROUTE	0x150
-
-#define HPET_ID_LEGSUP	0x00008000
-#define HPET_ID_NUMBER	0x00001f00
-#define HPET_ID_REV	0x000000ff
+#define HPET_ID			0x000
+#define HPET_PERIOD		0x004
+#define HPET_CFG		0x010
+#define HPET_STATUS		0x020
+#define HPET_COUNTER		0x0f0
+#define HPET_T0_CFG		0x100
+#define HPET_T0_CMP		0x108
+#define HPET_T0_ROUTE		0x110
+#define HPET_T1_CFG		0x120
+#define HPET_T1_CMP		0x128
+#define HPET_T1_ROUTE		0x130
+#define HPET_T2_CFG		0x140
+#define HPET_T2_CMP		0x148
+#define HPET_T2_ROUTE		0x150
+
+#define HPET_ID_REV		0x000000ff
+#define HPET_ID_NUMBER		0x00001f00
+#define HPET_ID_64BIT		0x00002000
+#define HPET_ID_LEGSUP		0x00008000
+#define HPET_ID_VENDOR		0xffff0000
 #define	HPET_ID_NUMBER_SHIFT	8
+#define HPET_ID_VENDOR_SHIFT	16
+
+#define HPET_ID_VENDOR_8086	0x8086
 
-#define HPET_CFG_ENABLE	0x001
-#define HPET_CFG_LEGACY	0x002
+#define HPET_CFG_ENABLE		0x001
+#define HPET_CFG_LEGACY		0x002
 #define	HPET_LEGACY_8254	2
 #define	HPET_LEGACY_RTC		8
 
-#define HPET_TN_ENABLE		0x004
-#define HPET_TN_PERIODIC	0x008
-#define HPET_TN_PERIODIC_CAP	0x010
-#define HPET_TN_SETVAL		0x040
-#define HPET_TN_32BIT		0x100
-
-/* Use our own asm for 64 bit multiply/divide */
-#define ASM_MUL64_REG(eax_out,edx_out,reg_in,eax_in) 			\
-		__asm__ __volatile__("mull %2" 				\
-				:"=a" (eax_out), "=d" (edx_out) 	\
-				:"r" (reg_in), "0" (eax_in))
-
-#define ASM_DIV64_REG(eax_out,edx_out,reg_in,eax_in,edx_in) 		\
-		__asm__ __volatile__("divl %2" 				\
-				:"=a" (eax_out), "=d" (edx_out) 	\
-				:"r" (reg_in), "0" (eax_in), "1" (edx_in))
+#define HPET_TN_LEVEL		0x0002
+#define HPET_TN_ENABLE		0x0004
+#define HPET_TN_PERIODIC	0x0008
+#define HPET_TN_PERIODIC_CAP	0x0010
+#define HPET_TN_64BIT_CAP	0x0020
+#define HPET_TN_SETVAL		0x0040
+#define HPET_TN_32BIT		0x0100
+#define HPET_TN_ROUTE		0x3e00
+#define HPET_TN_FSB		0x4000
+#define HPET_TN_FSB_CAP		0x8000
+#define HPET_TN_ROUTE_SHIFT	9
 
-#define KERNEL_TICK_USEC 	(1000000UL/HZ)	/* tick value in microsec */
 /* Max HPET Period is 10^8 femto sec as in HPET spec */
-#define HPET_MAX_PERIOD (100000000UL)
+#define HPET_MAX_PERIOD		100000000UL
 /*
  * Min HPET period is 10^5 femto sec just for safety. If it is less than this,
  * then 32 bit HPET counter wrapsaround in less than 0.5 sec.
  */
-#define HPET_MIN_PERIOD (100000UL)
-#define HPET_TICK_RATE  (HZ * 100000UL)
+#define HPET_MIN_PERIOD		100000UL
 
-extern unsigned long hpet_address;	/* hpet memory map physical address */
+/* hpet memory map physical address */
+extern unsigned long hpet_address;
 extern int is_hpet_enabled(void);
+extern int hpet_enable(void);
 
 #ifdef CONFIG_X86_64
-extern unsigned long hpet_tick;	/* hpet clks count per tick */
-extern int hpet_use_timer;
-extern int hpet_rtc_timer_init(void);
-extern int hpet_enable(void);
-extern int is_hpet_capable(void);
-extern int hpet_readl(unsigned long a);
-#else
-extern int hpet_enable(void);
+/* hpet_readl/writel defines */
+#include <asm/vsyscall.h>
 #endif
 
 #ifdef CONFIG_HPET_EMULATE_RTC
+
+#include <linux/interrupt.h>
+
 extern int hpet_mask_rtc_irq_bit(unsigned long bit_mask);
 extern int hpet_set_rtc_irq_bit(unsigned long bit_mask);
-extern int hpet_set_alarm_time(unsigned char hrs, unsigned char min, unsigned char sec);
+extern int hpet_set_alarm_time(unsigned char hrs, unsigned char min,
+			       unsigned char sec);
 extern int hpet_set_periodic_freq(unsigned long freq);
 extern int hpet_rtc_dropped_irq(void);
 extern int hpet_rtc_timer_init(void);
 extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
+
 #endif /* CONFIG_HPET_EMULATE_RTC */
 
 #else
diff -puN include/asm-i386/tsc.h~x86_64-convert-to-cleckevents include/asm-i386/tsc.h
--- a/include/asm-i386/tsc.h~x86_64-convert-to-cleckevents
+++ a/include/asm-i386/tsc.h
@@ -71,4 +71,8 @@ extern void init_tsc_clocksource(void);
 extern void check_tsc_sync_source(int cpu);
 extern void check_tsc_sync_target(void);
 
+#ifdef CONFIG_X86_64
+extern void tsc_calibrate(void);
+#endif
+
 #endif
diff -puN include/asm-x86_64/apic.h~x86_64-convert-to-cleckevents include/asm-x86_64/apic.h
--- a/include/asm-x86_64/apic.h~x86_64-convert-to-cleckevents
+++ a/include/asm-x86_64/apic.h
@@ -79,8 +79,6 @@ extern void smp_local_timer_interrupt (v
 extern void setup_boot_APIC_clock (void);
 extern void setup_secondary_APIC_clock (void);
 extern int APIC_init_uniprocessor (void);
-extern void disable_APIC_timer(void);
-extern void enable_APIC_timer(void);
 extern void setup_apic_routing(void);
 
 extern void setup_APIC_extended_lvt(unsigned char lvt_off, unsigned char vector,
@@ -95,10 +93,6 @@ extern int apic_is_clustered_box(void);
 #define K8_APIC_EXT_INT_MSG_EXT 0x7
 #define K8_APIC_EXT_LVT_ENTRY_THRESHOLD    0
 
-void smp_send_timer_broadcast_ipi(void);
-void switch_APIC_timer_to_ipi(void *cpumask);
-void switch_ipi_to_APIC_timer(void *cpumask);
-
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
 extern unsigned boot_cpu_id;
diff -puN include/asm-x86_64/hpet.h~x86_64-convert-to-cleckevents include/asm-x86_64/hpet.h
--- a/include/asm-x86_64/hpet.h~x86_64-convert-to-cleckevents
+++ a/include/asm-x86_64/hpet.h
@@ -1,77 +1,2 @@
-#ifndef _ASM_X8664_HPET_H
-#define _ASM_X8664_HPET_H 1
 
-/*
- * Documentation on HPET can be found at:
- *      http://www.intel.com/ial/home/sp/pcmmspec.htm
- *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
- */
-
-#define HPET_MMAP_SIZE	1024
-
-#define HPET_ID		0x000
-#define HPET_PERIOD	0x004
-#define HPET_CFG	0x010
-#define HPET_STATUS	0x020
-#define HPET_COUNTER	0x0f0
-#define HPET_Tn_OFFSET	0x20
-#define HPET_Tn_CFG(n)	 (0x100 + (n) * HPET_Tn_OFFSET)
-#define HPET_Tn_ROUTE(n) (0x104 + (n) * HPET_Tn_OFFSET)
-#define HPET_Tn_CMP(n)	 (0x108 + (n) * HPET_Tn_OFFSET)
-#define HPET_T0_CFG	HPET_Tn_CFG(0)
-#define HPET_T0_CMP	HPET_Tn_CMP(0)
-#define HPET_T1_CFG	HPET_Tn_CFG(1)
-#define HPET_T1_CMP	HPET_Tn_CMP(1)
-
-#define HPET_ID_VENDOR	0xffff0000
-#define HPET_ID_LEGSUP	0x00008000
-#define HPET_ID_64BIT	0x00002000
-#define HPET_ID_NUMBER	0x00001f00
-#define HPET_ID_REV	0x000000ff
-#define	HPET_ID_NUMBER_SHIFT	8
-
-#define HPET_ID_VENDOR_SHIFT	16
-#define HPET_ID_VENDOR_8086	0x8086
-
-#define HPET_CFG_ENABLE	0x001
-#define HPET_CFG_LEGACY	0x002
-#define	HPET_LEGACY_8254	2
-#define	HPET_LEGACY_RTC		8
-
-#define HPET_TN_LEVEL		0x0002
-#define HPET_TN_ENABLE		0x0004
-#define HPET_TN_PERIODIC	0x0008
-#define HPET_TN_PERIODIC_CAP	0x0010
-#define HPET_TN_64BIT_CAP	0x0020
-#define HPET_TN_SETVAL		0x0040
-#define HPET_TN_32BIT		0x0100
-#define HPET_TN_ROUTE		0x3e00
-#define HPET_TN_FSB		0x4000
-#define HPET_TN_FSB_CAP		0x8000
-
-#define HPET_TN_ROUTE_SHIFT	9
-
-#define HPET_TICK_RATE (HZ * 100000UL)
-
-extern int is_hpet_enabled(void);
-extern int hpet_rtc_timer_init(void);
-extern int hpet_arch_init(void);
-extern int hpet_timer_stop_set_go(unsigned long tick);
-extern int hpet_reenable(void);
-extern unsigned int hpet_calibrate_tsc(void);
-
-extern int hpet_use_timer;
-extern unsigned long hpet_address;
-extern unsigned long hpet_period;
-extern unsigned long hpet_tick;
-
-#ifdef CONFIG_HPET_EMULATE_RTC
-extern int hpet_mask_rtc_irq_bit(unsigned long bit_mask);
-extern int hpet_set_rtc_irq_bit(unsigned long bit_mask);
-extern int hpet_set_alarm_time(unsigned char hrs, unsigned char min, unsigned char sec);
-extern int hpet_set_periodic_freq(unsigned long freq);
-extern int hpet_rtc_dropped_irq(void);
-extern int hpet_rtc_timer_init(void);
-#endif /* CONFIG_HPET_EMULATE_RTC */
-
-#endif
+#include <asm-i386/hpet.h>
diff -puN include/asm-x86_64/i8253.h~x86_64-convert-to-cleckevents include/asm-x86_64/i8253.h
--- a/include/asm-x86_64/i8253.h~x86_64-convert-to-cleckevents
+++ a/include/asm-x86_64/i8253.h
@@ -1,6 +1,2 @@
-#ifndef __ASM_I8253_H__
-#define __ASM_I8253_H__
-
-extern spinlock_t i8253_lock;
-
-#endif	/* __ASM_I8253_H__ */
+#include <asm-i386/i8253.h>
+#include <asm/8253pit.h>
diff -puN include/asm-x86_64/proto.h~x86_64-convert-to-cleckevents include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~x86_64-convert-to-cleckevents
+++ a/include/asm-x86_64/proto.h
@@ -51,9 +51,6 @@ extern void reserve_bootmem_generic(unsi
 
 extern void load_gs_index(unsigned gs);
 
-extern void stop_timer_interrupt(void);
-extern void main_timer_handler(void);
-
 extern unsigned long end_pfn_map; 
 
 extern void show_trace(struct task_struct *, struct pt_regs *, unsigned long * rsp);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
