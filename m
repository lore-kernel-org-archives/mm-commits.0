From: akpm@linux-foundation.org
Subject: - atmel_tc-clocksource-clockevent-code.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:23:51 -0800
Message-ID: <200803062223.m26MNphD020925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752846AbYCFWZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:25:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, johnstul@us.ibm.com, linux@maxim.org.za, nicolas.ferre@rfo.atmel.com, tglx@linutronix.de, mm-commits@vger.


The patch titled
     atmel_tc clocksource/clockevent code
has been removed from the -mm tree.  Its filename was
     atmel_tc-clocksource-clockevent-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_tc clocksource/clockevent code
From: David Brownell <david-b@pacbell.net>

Clocksource and clockevent device based on the Atmel TC blocks.

The clockevent device handles both periodic and oneshot modes, so this enables
NO_HZ and high res timers on some platforms that previously couldn't use those
mechanisms.

This works on both AVR32 and AT91 chips, given relevant patches for tclib
support (always) and clockevents (or else this will only look like a higher
precision clocksource).  It's an updated and modularized version of an
AT91-only patch that has circulated for some time now.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/Makefile     |    1 
 drivers/clocksource/tcb_clksrc.c |  303 +++++++++++++++++++++++++++++
 drivers/misc/Kconfig             |   25 ++
 3 files changed, 329 insertions(+)

diff -puN drivers/clocksource/Makefile~atmel_tc-clocksource-clockevent-code drivers/clocksource/Makefile
--- a/drivers/clocksource/Makefile~atmel_tc-clocksource-clockevent-code
+++ a/drivers/clocksource/Makefile
@@ -1,3 +1,4 @@
+obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+= tcb_clksrc.o
 obj-$(CONFIG_X86_CYCLONE_TIMER)	+= cyclone.o
 obj-$(CONFIG_X86_PM_TIMER)	+= acpi_pm.o
 obj-$(CONFIG_SCx200HR_TIMER)	+= scx200_hrt.o
diff -puN /dev/null drivers/clocksource/tcb_clksrc.c
--- /dev/null
+++ a/drivers/clocksource/tcb_clksrc.c
@@ -0,0 +1,303 @@
+#include <linux/init.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/atmel_tc.h>
+
+
+/*
+ * We're configured to use a specific TC block, one that's not hooked
+ * up to external hardware, to provide a time solution:
+ *
+ *   - Two channels combine to create a free-running 32 bit counter
+ *     with a base rate of 5+ MHz, packaged as a clocksource (with
+ *     resolution better than 200 nsec).
+ *
+ *   - The third channel may be used to provide a 16-bit clockevent
+ *     source, used in either periodic or oneshot mode.  This runs
+ *     at 32 KiHZ, and can handle delays of up to two seconds.
+ *
+ * A boot clocksource and clockevent source are also currently needed,
+ * unless the relevant platforms (ARM/AT91, AVR32/AT32) are changed so
+ * this code can be used when init_timers() is called, well before most
+ * devices are set up.  (Some low end AT91 parts, which can run uClinux,
+ * have only the timers in one TC block... they currently don't support
+ * the tclib code, because of that initialization issue.)
+ *
+ * REVISIT behavior during system suspend states... we should disable
+ * all clocks and save the power.  Easily done for clockevent devices,
+ * but clocksources won't necessarily get the needed notifications.
+ * For deeper system sleep states, this will be mandatory...
+ */
+
+static void __iomem *tcaddr;
+
+static cycle_t tc_get_cycles(void)
+{
+	unsigned long	flags;
+	u32		lower, upper;
+
+	raw_local_irq_save(flags);
+retry:
+	upper = __raw_readl(tcaddr + ATMEL_TC_REG(1, CV));
+	lower = __raw_readl(tcaddr + ATMEL_TC_REG(0, CV));
+	if (upper != __raw_readl(tcaddr + ATMEL_TC_REG(1, CV)))
+		goto retry;
+
+	raw_local_irq_restore(flags);
+	return (upper << 16) | lower;
+}
+
+static struct clocksource clksrc = {
+	.name           = "tcb_clksrc",
+	.rating         = 200,
+	.read           = tc_get_cycles,
+	.mask           = CLOCKSOURCE_MASK(32),
+	.shift          = 18,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+#define USE_TC_CLKEVT
+#endif
+
+#ifdef CONFIG_ARCH_AT91RM9200
+/* The AT91rm9200 system timer is a oneshot-capable 32k timer that's
+ * always running ... configuring a TC channel to work the same way
+ * would just waste some power.
+ */
+#undef USE_TC_CLKEVT
+#endif
+
+#ifdef USE_TC_CLKEVT
+
+/* For now, we always use the 32K clock ... this optimizes for NO_HZ,
+ * because using one of the divided clocks would usually mean the
+ * tick rate can never be less than several dozen Hz (vs 0.5 Hz).
+ *
+ * A divided clock could be good for high resolution timers, since
+ * 30.5 usec resolution can seem "low".
+ */
+static u32 timer_clock;
+
+static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
+{
+	__raw_writel(0xff, tcaddr + ATMEL_TC_REG(2, IDR));
+	__raw_writel(ATMEL_TC_CLKDIS, tcaddr + ATMEL_TC_REG(2, CCR));
+
+	switch (m) {
+
+	/* By not making the gentime core emulate periodic mode on top
+	 * of oneshot, we get lower overhead and improved accuracy.
+	 */
+	case CLOCK_EVT_MODE_PERIODIC:
+		/* slow clock, count up to RC, then irq and restart */
+		__raw_writel(timer_clock
+				| ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO,
+				tcaddr + ATMEL_TC_REG(2, CMR));
+		__raw_writel((32768 + HZ/2) / HZ, tcaddr + ATMEL_TC_REG(2, RC));
+
+		/* Enable clock and interrupts on RC compare */
+		__raw_writel(ATMEL_TC_CPCS, tcaddr + ATMEL_TC_REG(2, IER));
+
+		/* go go gadget! */
+		__raw_writel(ATMEL_TC_CLKEN | ATMEL_TC_SWTRG,
+				tcaddr + ATMEL_TC_REG(2, CCR));
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* slow clock, count up to RC, then irq and stop */
+		__raw_writel(timer_clock | ATMEL_TC_CPCSTOP
+				| ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO,
+				tcaddr + ATMEL_TC_REG(2, CMR));
+		__raw_writel(ATMEL_TC_CPCS, tcaddr + ATMEL_TC_REG(2, IER));
+
+		/* set_next_event() configures and starts the timer */
+		break;
+
+	default:
+		break;
+	}
+}
+
+static int tc_next_event(unsigned long delta, struct clock_event_device *d)
+{
+	__raw_writel(delta, tcaddr + ATMEL_TC_REG(2, RC));
+
+	/* go go gadget! */
+	__raw_writel(ATMEL_TC_CLKEN | ATMEL_TC_SWTRG,
+			tcaddr + ATMEL_TC_REG(2, CCR));
+	return 0;
+}
+
+static struct clock_event_device clkevt = {
+	.name		= "tc_clkevt",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.shift		= 32,
+	.rating		= 125,
+	.cpumask	= CPU_MASK_CPU0,
+	.set_next_event	= tc_next_event,
+	.set_mode	= tc_mode,
+};
+
+static irqreturn_t ch2_irq(int irq, void *handle)
+{
+	unsigned int	sr = __raw_readl(tcaddr + ATMEL_TC_REG(2, SR));
+
+	if (sr & ATMEL_TC_CPCS) {
+		clkevt.event_handler(&clkevt);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static struct irqaction tc_irqaction = {
+	.name		= "tc_clkevt",
+	.flags		= IRQF_TIMER | IRQF_DISABLED,
+	.handler	= ch2_irq,
+};
+
+static void __init setup_clkevents(struct platform_device *pdev,
+		struct clk *t0_clk, int clk32k_divisor_idx)
+{
+	struct clk	*t2_clk = clk_get(&pdev->dev, "t2_clk");
+	int		irq;
+
+	/* SOCs have either one IRQ and one clock for the whole
+	 * TC block; or one each per channel.  We use channel 2.
+	 */
+	if (IS_ERR(t2_clk)) {
+		t2_clk = t0_clk;
+		irq = platform_get_irq(pdev, 0);
+	} else {
+		irq = platform_get_irq(pdev, 2);
+		clk_enable(t2_clk);
+	}
+
+	timer_clock = clk32k_divisor_idx;
+
+	clkevt.mult = div_sc(32768, NSEC_PER_SEC, clkevt.shift);
+	clkevt.max_delta_ns = clockevent_delta2ns(0xffff, &clkevt);
+	clkevt.min_delta_ns = clockevent_delta2ns(1, &clkevt) + 1;
+
+	setup_irq(irq, &tc_irqaction);
+
+	clockevents_register_device(&clkevt);
+}
+
+#else /* !USE_TC_CLKEVT */
+
+static void __init setup_clkevents(struct platform_device *pdev,
+		struct clk *t0_clk, int clk32k_divisor_idx)
+{
+	/* NOTHING */
+}
+
+#endif
+
+static int __init tcb_clksrc_init(void)
+{
+	static char bootinfo[] __initdata
+		= KERN_DEBUG "%s: tc%d at %d.%03d MHz\n";
+
+	struct platform_device *pdev;
+	struct clk *t0_clk, *t1_clk;
+	u32 rate, divided_rate = 0;
+	int best_divisor_idx = -1;
+	int clk32k_divisor_idx = -1;
+	int i;
+	struct resource *iomem;
+
+	pdev = atmel_tc_alloc(CONFIG_ATMEL_TCB_CLKSRC_BLOCK, &iomem);
+	if (pdev == NULL) {
+		pr_debug("can't alloc TC for clocksource\n");
+		return -ENODEV;
+	}
+	rename_region(iomem, clksrc.name);
+	tcaddr = ioremap(iomem->start, 256);
+
+	t0_clk = clk_get(&pdev->dev, "t0_clk");
+	if (IS_ERR(t0_clk)) {
+		atmel_tc_free(pdev);
+		return PTR_ERR(t0_clk);
+	}
+	clk_enable(t0_clk);
+
+	/* How fast will we be counting?  Pick something over 5 MHz.  */
+	rate = (u32) clk_get_rate(t0_clk);
+	for (i = 0; i < 5; i++) {
+		unsigned divisor = atmel_tc_divisors[i];
+		unsigned tmp;
+
+		/* remember 32 KiHz clock for later */
+		if (!divisor) {
+			clk32k_divisor_idx = i;
+			continue;
+		}
+
+		tmp = rate / divisor;
+		pr_debug("TC: %u / %-3u [%d] --> %u\n", rate, divisor, i, tmp);
+		if (best_divisor_idx > 0) {
+			if (tmp < 5 * 1000 * 1000)
+				continue;
+		}
+		divided_rate = tmp;
+		best_divisor_idx = i;
+	}
+
+	clksrc.mult = clocksource_hz2mult(divided_rate, clksrc.shift);
+
+	printk(bootinfo, clksrc.name, CONFIG_ATMEL_TCB_CLKSRC_BLOCK,
+			divided_rate / 1000000,
+			((divided_rate + 500000) % 1000000) / 1000);
+
+	/* Some platforms (like at91rm9200, at91sam9260, etc) have one clock
+	 * (and IRQ) per timer.  Others (at91sam9263, ap700x, etc) don't.
+	 */
+	t1_clk = clk_get(&pdev->dev, "t1_clk");
+	if (IS_ERR(t1_clk))
+		t1_clk = t0_clk;
+	else
+		clk_enable(t1_clk);
+
+	/* channel 0:  waveform mode, input mclk/8, clock TIOA0 on overflow */
+	__raw_writel(best_divisor_idx			/* likely divide-by-8 */
+			| ATMEL_TC_WAVE
+			| ATMEL_TC_WAVESEL_UP		/* free-run */
+			| ATMEL_TC_ACPA_SET		/* TIOA0 rises at 0 */
+			| ATMEL_TC_ACPC_CLEAR,		/* (duty cycle 50%) */
+			tcaddr + ATMEL_TC_REG(0, CMR));
+	__raw_writel(0x0000, tcaddr + ATMEL_TC_REG(0, RA));
+	__raw_writel(0x8000, tcaddr + ATMEL_TC_REG(0, RC));
+	__raw_writel(0xff, tcaddr + ATMEL_TC_REG(0, IDR));	/* no irqs */
+	__raw_writel(ATMEL_TC_CLKEN, tcaddr + ATMEL_TC_REG(0, CCR));
+
+	/* channel 1:  waveform mode, input TIOA0 */
+	__raw_writel(ATMEL_TC_XC1			/* input: TIOA0 */
+			| ATMEL_TC_WAVE
+			| ATMEL_TC_WAVESEL_UP,		/* free-run */
+			tcaddr + ATMEL_TC_REG(1, CMR));
+	__raw_writel(0xff, tcaddr + ATMEL_TC_REG(1, IDR));	/* no irqs */
+	__raw_writel(ATMEL_TC_CLKEN, tcaddr + ATMEL_TC_REG(1, CCR));
+
+	/* chain channel 0 to channel 1, then reset all the timers */
+	__raw_writel(ATMEL_TC_TC1XC1S_TIOA0, tcaddr + ATMEL_TC_BMR);
+	__raw_writel(ATMEL_TC_SYNC, tcaddr + ATMEL_TC_BCR);
+
+	/* and away we go! */
+	clocksource_register(&clksrc);
+
+	/* channel 2:  periodic and oneshot timer support */
+	setup_clkevents(pdev, t0_clk, clk32k_divisor_idx);
+
+	return 0;
+}
+arch_initcall(tcb_clksrc_init);
diff -puN drivers/misc/Kconfig~atmel_tc-clocksource-clockevent-code drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~atmel_tc-clocksource-clockevent-code
+++ a/drivers/misc/Kconfig
@@ -30,6 +30,31 @@ config ATMEL_TCLIB
 	  blocks found on many Atmel processors.  This facilitates using
 	  these blocks by different drivers despite processor differences.
 
+config ATMEL_TCB_CLKSRC
+	bool "TC Block Clocksource"
+	depends on ATMEL_TCLIB && GENERIC_TIME
+	default y
+	help
+	  Select this to get a high precision clocksource based on a
+	  TC block with a 5+ MHz base clock rate.  Two timer channels
+	  are combined to make a single 32-bit timer.
+
+	  When GENERIC_CLOCKEVENTS is defined, the third timer channel
+	  may be used as a clock event device supporting oneshot mode
+	  (delays of up to two seconds) based on the 32 KiHz clock.
+
+config ATMEL_TCB_CLKSRC_BLOCK
+	int
+	depends on ATMEL_TCB_CLKSRC
+	prompt "TC Block" if ARCH_AT91RM9200 || ARCH_AT91SAM9260 || CPU_AT32AP700X
+	default 0
+	range 0 1
+	help
+	  Some chips provide more than one TC block, so you have the
+	  choice of which one to use for the clock framework.  The other
+	  TC can be used for other purposes, such as PWM generation and
+	  interval timing.
+
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
 	depends on X86 && PCI && INPUT && EXPERIMENTAL
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-acpi.patch
git-arm-master.patch
git-avr32.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
spi-pxa2xx_spi-sparse-fixes.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
rtc-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

