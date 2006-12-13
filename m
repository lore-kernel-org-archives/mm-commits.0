From: akpm@osdl.org
Subject: + clockevents-i386-hpet-driver.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:44:20 -0800
Message-ID: <200612132244.kBDMiKLW022882@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52397 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbWLMWod (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:44:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     clockevents: i386, HPET driver
has been added to the -mm tree.  Its filename is
     clockevents-i386-hpet-driver.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clockevents: i386, HPET driver
From: Thomas Gleixner <tglx@linutronix.de>

Convert HPET to clockevents.  Integrate the HPET clocksource and the timer
related code into one file.

Existing non-high-res functionality is unchanged.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/Makefile    |    1 
 arch/i386/kernel/hpet.c      |  489 +++++++++++++++++++++++++++++++-
 arch/i386/kernel/i8259.c     |    6 
 arch/i386/kernel/time.c      |   20 -
 arch/i386/kernel/time_hpet.c |  492 ---------------------------------
 include/asm-i386/hpet.h      |   15 -
 6 files changed, 484 insertions(+), 539 deletions(-)

diff -puN arch/i386/kernel/Makefile~clockevents-i386-hpet-driver arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~clockevents-i386-hpet-driver
+++ a/arch/i386/kernel/Makefile
@@ -32,7 +32,6 @@ obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-y				+= sysenter.o vsyscall.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat.o
-obj-$(CONFIG_HPET_TIMER) 	+= time_hpet.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_stub.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
 obj-$(CONFIG_VM86)		+= vm86.o
diff -puN arch/i386/kernel/hpet.c~clockevents-i386-hpet-driver arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~clockevents-i386-hpet-driver
+++ a/arch/i386/kernel/hpet.c
@@ -1,4 +1,5 @@
 #include <linux/clocksource.h>
+#include <linux/clockchips.h>
 #include <linux/errno.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
@@ -6,17 +7,272 @@
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
+static void hpet_next_event(unsigned long delta,
+			    struct clock_event_device *evt);
+
+/*
+ * The hpet clock event device
+ */
+static struct clock_event_device hpet_clockevent = {
+	.name = "hpet",
+	.capabilities	= CLOCK_CAP_TICK | CLOCK_CAP_PROFILE | CLOCK_CAP_UPDATE
+			| CLOCK_CAP_NEXTEVT,
+	.set_mode	= hpet_set_mode,
+	.set_next_event = hpet_next_event,
+	.shift		= 32,
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
+
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
+	case CLOCK_EVT_PERIODIC:
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
+	case CLOCK_EVT_ONESHOT:
+		cfg = hpet_readl(HPET_T0_CFG);
+		cfg &= ~HPET_TN_PERIODIC;
+		cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
+		hpet_writel(cfg, HPET_T0_CFG);
+		break;
+
+	case CLOCK_EVT_SHUTDOWN:
+		cfg = hpet_readl(HPET_T0_CFG);
+		cfg &= ~HPET_TN_ENABLE;
+		hpet_writel(cfg, HPET_T0_CFG);
+		break;
+	}
+}
+
+static void hpet_next_event(unsigned long delta,
+			    struct clock_event_device *evt)
+{
+	unsigned long cnt;
 
+	do {
+		cnt = hpet_readl(HPET_COUNTER);
+		cnt += delta;
+		hpet_writel(cnt, HPET_T0_CMP);
+	} while ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0);
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
+		register_global_clockevent(&hpet_clockevent);
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
@@ -24,29 +280,17 @@ static struct clocksource clocksource_hp
 	.rating		= 250,
 	.read		= read_hpet,
 	.mask		= HPET_MASK,
-	.mult		= 0, /* set below */
 	.shift		= HPET_SHIFT,
 	.is_continuous	= 1,
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
@@ -62,11 +306,216 @@ static int __init init_hpet_clocksource(
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
+		printk(KERN_WARNING "rtc: lost %d interrupts\n", lost_ints);
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
diff -puN arch/i386/kernel/i8259.c~clockevents-i386-hpet-driver arch/i386/kernel/i8259.c
--- a/arch/i386/kernel/i8259.c~clockevents-i386-hpet-driver
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
diff -puN arch/i386/kernel/time.c~clockevents-i386-hpet-driver arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c~clockevents-i386-hpet-driver
+++ a/arch/i386/kernel/time.c
@@ -260,30 +260,16 @@ void notify_arch_cmos_timer(void)
 	mod_timer(&sync_cmos_timer, jiffies + 1);
 }
 
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
diff -puN arch/i386/kernel/time_hpet.c~clockevents-i386-hpet-driver /dev/null
--- a/arch/i386/kernel/time_hpet.c
+++ /dev/null
@@ -1,492 +0,0 @@
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
diff -puN include/asm-i386/hpet.h~clockevents-i386-hpet-driver include/asm-i386/hpet.h
--- a/include/asm-i386/hpet.h~clockevents-i386-hpet-driver
+++ a/include/asm-i386/hpet.h
@@ -90,15 +90,19 @@
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
-extern int is_hpet_enabled(void);
 extern int is_hpet_capable(void);
 extern int hpet_readl(unsigned long a);
+#else
+extern int hpet_enable(void);
+#endif
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 extern int hpet_mask_rtc_irq_bit(unsigned long bit_mask);
@@ -109,5 +113,10 @@ extern int hpet_rtc_dropped_irq(void);
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

