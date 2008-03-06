From: akpm@linux-foundation.org
Subject: - atmel_tc-clocksource-clockevent-code-update.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:23:54 -0800
Message-ID: <200803062223.m26MNst9020928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756503AbYCFWZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:25:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, johnstul@us.ibm.com, linux@maxim.org.za, nicolas.ferre@rfo.atmel.com, tglx@linutronix.de, mm-commits@vger.


The patch titled
     atmel_tc clocksource/clockevent code (update)
has been removed from the -mm tree.  Its filename was
     atmel_tc-clocksource-clockevent-code-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_tc clocksource/clockevent code (update)
From: David Brownell <david-b@pacbell.net>

  * Update to use new tclib API
  * Replace open-coded do-while loop using goto with a real do-while loop
  * Minor irq handler optimization: Load register base address from
    dev_id instead of a global variable.
  * Aggressively turn off clocks when the clockevent isn't being used
  * Include the clockevent code on AT91RM9200 as well. The rating is
    lower than the System Timer, so the clock will usually stay off.
  * Don't assume that the number of clocks is always equal to the
    number of irqs.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/tcb_clksrc.c |  142 ++++++++++++++---------------
 1 file changed, 72 insertions(+), 70 deletions(-)

diff -puN drivers/clocksource/tcb_clksrc.c~atmel_tc-clocksource-clockevent-code-update drivers/clocksource/tcb_clksrc.c
--- a/drivers/clocksource/tcb_clksrc.c~atmel_tc-clocksource-clockevent-code-update
+++ a/drivers/clocksource/tcb_clksrc.c
@@ -45,11 +45,10 @@ static cycle_t tc_get_cycles(void)
 	u32		lower, upper;
 
 	raw_local_irq_save(flags);
-retry:
-	upper = __raw_readl(tcaddr + ATMEL_TC_REG(1, CV));
-	lower = __raw_readl(tcaddr + ATMEL_TC_REG(0, CV));
-	if (upper != __raw_readl(tcaddr + ATMEL_TC_REG(1, CV)))
-		goto retry;
+	do {
+		upper = __raw_readl(tcaddr + ATMEL_TC_REG(1, CV));
+		lower = __raw_readl(tcaddr + ATMEL_TC_REG(0, CV));
+	} while (upper != __raw_readl(tcaddr + ATMEL_TC_REG(1, CV)));
 
 	raw_local_irq_restore(flags);
 	return (upper << 16) | lower;
@@ -65,18 +64,17 @@ static struct clocksource clksrc = {
 };
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-#define USE_TC_CLKEVT
-#endif
 
-#ifdef CONFIG_ARCH_AT91RM9200
-/* The AT91rm9200 system timer is a oneshot-capable 32k timer that's
- * always running ... configuring a TC channel to work the same way
- * would just waste some power.
- */
-#undef USE_TC_CLKEVT
-#endif
+struct tc_clkevt_device {
+	struct clock_event_device	clkevt;
+	struct clk			*clk;
+	void __iomem			*regs;
+};
 
-#ifdef USE_TC_CLKEVT
+static struct tc_clkevt_device *to_tc_clkevt(struct clock_event_device *clkevt)
+{
+	return container_of(clkevt, struct tc_clkevt_device, clkevt);
+}
 
 /* For now, we always use the 32K clock ... this optimizes for NO_HZ,
  * because using one of the divided clocks would usually mean the
@@ -89,8 +87,15 @@ static u32 timer_clock;
 
 static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 {
-	__raw_writel(0xff, tcaddr + ATMEL_TC_REG(2, IDR));
-	__raw_writel(ATMEL_TC_CLKDIS, tcaddr + ATMEL_TC_REG(2, CCR));
+	struct tc_clkevt_device *tcd = to_tc_clkevt(d);
+	void __iomem		*regs = tcd->regs;
+
+	if (tcd->clkevt.mode == CLOCK_EVT_MODE_PERIODIC
+			|| tcd->clkevt.mode == CLOCK_EVT_MODE_ONESHOT) {
+		__raw_writel(0xff, regs + ATMEL_TC_REG(2, IDR));
+		__raw_writel(ATMEL_TC_CLKDIS, regs + ATMEL_TC_REG(2, CCR));
+		clk_disable(tcd->clk);
+	}
 
 	switch (m) {
 
@@ -98,26 +103,30 @@ static void tc_mode(enum clock_event_mod
 	 * of oneshot, we get lower overhead and improved accuracy.
 	 */
 	case CLOCK_EVT_MODE_PERIODIC:
+		clk_enable(tcd->clk);
+
 		/* slow clock, count up to RC, then irq and restart */
 		__raw_writel(timer_clock
 				| ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO,
-				tcaddr + ATMEL_TC_REG(2, CMR));
+				regs + ATMEL_TC_REG(2, CMR));
 		__raw_writel((32768 + HZ/2) / HZ, tcaddr + ATMEL_TC_REG(2, RC));
 
 		/* Enable clock and interrupts on RC compare */
-		__raw_writel(ATMEL_TC_CPCS, tcaddr + ATMEL_TC_REG(2, IER));
+		__raw_writel(ATMEL_TC_CPCS, regs + ATMEL_TC_REG(2, IER));
 
 		/* go go gadget! */
 		__raw_writel(ATMEL_TC_CLKEN | ATMEL_TC_SWTRG,
-				tcaddr + ATMEL_TC_REG(2, CCR));
+				regs + ATMEL_TC_REG(2, CCR));
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
+		clk_enable(tcd->clk);
+
 		/* slow clock, count up to RC, then irq and stop */
 		__raw_writel(timer_clock | ATMEL_TC_CPCSTOP
 				| ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO,
-				tcaddr + ATMEL_TC_REG(2, CMR));
-		__raw_writel(ATMEL_TC_CPCS, tcaddr + ATMEL_TC_REG(2, IER));
+				regs + ATMEL_TC_REG(2, CMR));
+		__raw_writel(ATMEL_TC_CPCS, regs + ATMEL_TC_REG(2, IER));
 
 		/* set_next_event() configures and starts the timer */
 		break;
@@ -137,22 +146,28 @@ static int tc_next_event(unsigned long d
 	return 0;
 }
 
-static struct clock_event_device clkevt = {
-	.name		= "tc_clkevt",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
-	.rating		= 125,
-	.cpumask	= CPU_MASK_CPU0,
-	.set_next_event	= tc_next_event,
-	.set_mode	= tc_mode,
+static struct tc_clkevt_device clkevt = {
+	.clkevt	= {
+		.name		= "tc_clkevt",
+		.features	= CLOCK_EVT_FEAT_PERIODIC
+					| CLOCK_EVT_FEAT_ONESHOT,
+		.shift		= 32,
+		/* Should be lower than at91rm9200's system timer */
+		.rating		= 125,
+		.cpumask	= CPU_MASK_CPU0,
+		.set_next_event	= tc_next_event,
+		.set_mode	= tc_mode,
+	},
 };
 
 static irqreturn_t ch2_irq(int irq, void *handle)
 {
-	unsigned int	sr = __raw_readl(tcaddr + ATMEL_TC_REG(2, SR));
+	struct tc_clkevt_device	*dev = handle;
+	unsigned int		sr;
 
+	sr = __raw_readl(dev->regs + ATMEL_TC_REG(2, SR));
 	if (sr & ATMEL_TC_CPCS) {
-		clkevt.event_handler(&clkevt);
+		dev->clkevt.event_handler(&dev->clkevt);
 		return IRQ_HANDLED;
 	}
 
@@ -165,37 +180,32 @@ static struct irqaction tc_irqaction = {
 	.handler	= ch2_irq,
 };
 
-static void __init setup_clkevents(struct platform_device *pdev,
+static void __init setup_clkevents(struct atmel_tc *tc,
 		struct clk *t0_clk, int clk32k_divisor_idx)
 {
-	struct clk	*t2_clk = clk_get(&pdev->dev, "t2_clk");
-	int		irq;
-
-	/* SOCs have either one IRQ and one clock for the whole
-	 * TC block; or one each per channel.  We use channel 2.
-	 */
-	if (IS_ERR(t2_clk)) {
-		t2_clk = t0_clk;
-		irq = platform_get_irq(pdev, 0);
-	} else {
-		irq = platform_get_irq(pdev, 2);
-		clk_enable(t2_clk);
-	}
+	struct platform_device *pdev = tc->pdev;
+	struct clk *t2_clk = tc->clk[2];
+	int irq = tc->irq[2];
+
+	clkevt.regs = tc->regs;
+	clkevt.clk = t2_clk;
+	tc_irqaction.dev_id = &clkevt;
 
 	timer_clock = clk32k_divisor_idx;
 
-	clkevt.mult = div_sc(32768, NSEC_PER_SEC, clkevt.shift);
-	clkevt.max_delta_ns = clockevent_delta2ns(0xffff, &clkevt);
-	clkevt.min_delta_ns = clockevent_delta2ns(1, &clkevt) + 1;
+	clkevt.clkevt.mult = div_sc(32768, NSEC_PER_SEC, clkevt.clkevt.shift);
+	clkevt.clkevt.max_delta_ns
+		= clockevent_delta2ns(0xffff, &clkevt.clkevt);
+	clkevt.clkevt.min_delta_ns = clockevent_delta2ns(1, &clkevt.clkevt) + 1;
 
 	setup_irq(irq, &tc_irqaction);
 
-	clockevents_register_device(&clkevt);
+	clockevents_register_device(&clkevt.clkevt);
 }
 
-#else /* !USE_TC_CLKEVT */
+#else /* !CONFIG_GENERIC_CLOCKEVENTS */
 
-static void __init setup_clkevents(struct platform_device *pdev,
+static void __init setup_clkevents(struct atmel_tc *tc,
 		struct clk *t0_clk, int clk32k_divisor_idx)
 {
 	/* NOTHING */
@@ -209,26 +219,22 @@ static int __init tcb_clksrc_init(void)
 		= KERN_DEBUG "%s: tc%d at %d.%03d MHz\n";
 
 	struct platform_device *pdev;
+	struct atmel_tc *tc;
 	struct clk *t0_clk, *t1_clk;
 	u32 rate, divided_rate = 0;
 	int best_divisor_idx = -1;
 	int clk32k_divisor_idx = -1;
 	int i;
-	struct resource *iomem;
 
-	pdev = atmel_tc_alloc(CONFIG_ATMEL_TCB_CLKSRC_BLOCK, &iomem);
-	if (pdev == NULL) {
+	tc = atmel_tc_alloc(CONFIG_ATMEL_TCB_CLKSRC_BLOCK, clksrc.name);
+	if (!tc) {
 		pr_debug("can't alloc TC for clocksource\n");
 		return -ENODEV;
 	}
-	rename_region(iomem, clksrc.name);
-	tcaddr = ioremap(iomem->start, 256);
+	tcaddr = tc->regs;
+	pdev = tc->pdev;
 
-	t0_clk = clk_get(&pdev->dev, "t0_clk");
-	if (IS_ERR(t0_clk)) {
-		atmel_tc_free(pdev);
-		return PTR_ERR(t0_clk);
-	}
+	t0_clk = tc->clk[0];
 	clk_enable(t0_clk);
 
 	/* How fast will we be counting?  Pick something over 5 MHz.  */
@@ -259,14 +265,10 @@ static int __init tcb_clksrc_init(void)
 			divided_rate / 1000000,
 			((divided_rate + 500000) % 1000000) / 1000);
 
-	/* Some platforms (like at91rm9200, at91sam9260, etc) have one clock
-	 * (and IRQ) per timer.  Others (at91sam9263, ap700x, etc) don't.
+	/* tclib will give us three clocks no matter what the
+	 * underlying platform supports.
 	 */
-	t1_clk = clk_get(&pdev->dev, "t1_clk");
-	if (IS_ERR(t1_clk))
-		t1_clk = t0_clk;
-	else
-		clk_enable(t1_clk);
+	clk_enable(tc->clk[1]);
 
 	/* channel 0:  waveform mode, input mclk/8, clock TIOA0 on overflow */
 	__raw_writel(best_divisor_idx			/* likely divide-by-8 */
@@ -296,7 +298,7 @@ static int __init tcb_clksrc_init(void)
 	clocksource_register(&clksrc);
 
 	/* channel 2:  periodic and oneshot timer support */
-	setup_clkevents(pdev, t0_clk, clk32k_divisor_idx);
+	setup_clkevents(tc, t0_clk, clk32k_divisor_idx);
 
 	return 0;
 }
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

