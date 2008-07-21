From: akpm@linux-foundation.org
Subject: + rtc-cmos-avoid-spurious-irqs.patch added to -mm tree
Date: Sun, 20 Jul 2008 22:26:00 -0700
Message-ID: <200807210526.m6L5Q0ad019115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbYGUF0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 01:26:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, avictor.za@gmail.com, stable@kernel.org, unruh@physics.ubc.ca


The patch titled
     rtc-cmos: avoid spurious irqs
has been added to the -mm tree.  Its filename is
     rtc-cmos-avoid-spurious-irqs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cmos: avoid spurious irqs
From: David Brownell <dbrownell@users.sourceforge.net>

This fixes kernel http://bugzilla.kernel.org/show_bug.cgi?id=11112 (bogus
RTC update IRQs reported) for rtc-cmos, in two ways:

  - When HPET is stealing the IRQs, use the first IRQ to grab
    the seconds counter which will be monitored (instead of
    using whatever was previously in that memory);

  - In sane IRQ handling modes, scrub out old IRQ status before
    enabling IRQs.

That latter is done by tightening up IRQ handling for rtc-cmos everywhere,
also ensuring that when HPET is used it's the only thing triggering IRQ
reports to userspace; net object shrink.

Also fix a bogus HPET message related to its RTC emulation.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Report-by: W Unruh <unruh@physics.ubc.ca>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/hpet.c |   10 +-
 drivers/rtc/rtc-cmos.c |  140 +++++++++++++++++----------------------
 2 files changed, 70 insertions(+), 80 deletions(-)

diff -puN arch/x86/kernel/hpet.c~rtc-cmos-avoid-spurious-irqs arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~rtc-cmos-avoid-spurious-irqs
+++ a/arch/x86/kernel/hpet.c
@@ -468,7 +468,7 @@ void hpet_disable(void)
 #define RTC_NUM_INTS		1
 
 static unsigned long hpet_rtc_flags;
-static unsigned long hpet_prev_update_sec;
+static int hpet_prev_update_sec;
 static struct rtc_time hpet_alarm_time;
 static unsigned long hpet_pie_count;
 static unsigned long hpet_t1_cmp;
@@ -575,6 +575,9 @@ int hpet_set_rtc_irq_bit(unsigned long b
 
 	hpet_rtc_flags |= bit_mask;
 
+	if ((bit_mask & RTC_UIE) && !(oldbits & RTC_UIE))
+		hpet_prev_update_sec = -1;
+
 	if (!oldbits)
 		hpet_rtc_timer_init();
 
@@ -652,7 +655,7 @@ static void hpet_rtc_timer_reinit(void)
 		if (hpet_rtc_flags & RTC_PIE)
 			hpet_pie_count += lost_ints;
 		if (printk_ratelimit())
-			printk(KERN_WARNING "rtc: lost %d interrupts\n",
+			printk(KERN_WARNING "hpet1: lost %d rtc interrupts\n",
 				lost_ints);
 	}
 }
@@ -670,7 +673,8 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 
 	if (hpet_rtc_flags & RTC_UIE &&
 	    curr_time.tm_sec != hpet_prev_update_sec) {
-		rtc_int_flag = RTC_UF;
+		if (hpet_prev_update_sec >= 0)
+			rtc_int_flag = RTC_UF;
 		hpet_prev_update_sec = curr_time.tm_sec;
 	}
 
diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-avoid-spurious-irqs drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-avoid-spurious-irqs
+++ a/drivers/rtc/rtc-cmos.c
@@ -235,11 +235,56 @@ static int cmos_read_alarm(struct device
 	return 0;
 }
 
+static void cmos_checkintr(struct cmos_rtc *cmos, unsigned char rtc_control)
+{
+	unsigned char	rtc_intr;
+
+	/* NOTE after changing RTC_xIE bits we always read INTR_FLAGS;
+	 * allegedly some older rtcs need that to handle irqs properly
+	 */
+	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
+
+	if (is_hpet_enabled())
+		return;
+
+	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+	if (is_intr(rtc_intr))
+		rtc_update_irq(cmos->rtc, 1, rtc_intr);
+}
+
+static void cmos_irq_enable(struct cmos_rtc *cmos, unsigned char mask)
+{
+	unsigned char	rtc_control;
+
+	/* flush any pending IRQ status, notably for update irqs,
+	 * before we enable new IRQs
+	 */
+	rtc_control = CMOS_READ(RTC_CONTROL);
+	cmos_checkintr(cmos, rtc_control);
+
+	rtc_control |= mask;
+	CMOS_WRITE(rtc_control, RTC_CONTROL);
+	hpet_set_rtc_irq_bit(mask);
+
+	cmos_checkintr(cmos, rtc_control);
+}
+
+static void cmos_irq_disable(struct cmos_rtc *cmos, unsigned char mask)
+{
+	unsigned char	rtc_control;
+
+	rtc_control = CMOS_READ(RTC_CONTROL);
+	rtc_control &= ~mask;
+	CMOS_WRITE(rtc_control, RTC_CONTROL);
+	hpet_mask_rtc_irq_bit(mask);
+
+	cmos_checkintr(cmos, rtc_control);
+}
+
 static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	mon, mday, hrs, min, sec;
-	unsigned char	rtc_control, rtc_intr;
 
 	if (!is_valid_irq(cmos->irq))
 		return -EIO;
@@ -266,15 +311,7 @@ static int cmos_set_alarm(struct device 
 	spin_lock_irq(&rtc_lock);
 
 	/* next rtc irq must not be from previous alarm setting */
-	rtc_control = CMOS_READ(RTC_CONTROL);
-	rtc_control &= ~RTC_AIE;
-	CMOS_WRITE(rtc_control, RTC_CONTROL);
-	hpet_mask_rtc_irq_bit(RTC_AIE);
-
-	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
-	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
-	if (is_intr(rtc_intr))
-		rtc_update_irq(cmos->rtc, 1, rtc_intr);
+	cmos_irq_disable(cmos, RTC_AIE);
 
 	/* update alarm */
 	CMOS_WRITE(hrs, RTC_HOURS_ALARM);
@@ -293,16 +330,8 @@ static int cmos_set_alarm(struct device 
 	 */
 	hpet_set_alarm_time(t->time.tm_hour, t->time.tm_min, t->time.tm_sec);
 
-	if (t->enabled) {
-		rtc_control |= RTC_AIE;
-		CMOS_WRITE(rtc_control, RTC_CONTROL);
-		hpet_set_rtc_irq_bit(RTC_AIE);
-
-		rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
-		rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
-		if (is_intr(rtc_intr))
-			rtc_update_irq(cmos->rtc, 1, rtc_intr);
-	}
+	if (t->enabled)
+		cmos_irq_enable(cmos, RTC_AIE);
 
 	spin_unlock_irq(&rtc_lock);
 
@@ -335,28 +364,17 @@ static int cmos_irq_set_freq(struct devi
 static int cmos_irq_set_state(struct device *dev, int enabled)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	unsigned char	rtc_control, rtc_intr;
 	unsigned long	flags;
 
 	if (!is_valid_irq(cmos->irq))
 		return -ENXIO;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	rtc_control = CMOS_READ(RTC_CONTROL);
-
-	if (enabled) {
-		rtc_control |= RTC_PIE;
-		hpet_set_rtc_irq_bit(RTC_PIE);
-	} else {
-		rtc_control &= ~RTC_PIE;
-		hpet_mask_rtc_irq_bit(RTC_PIE);
-	}
-	CMOS_WRITE(rtc_control, RTC_CONTROL);
 
-	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
-	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
-	if (is_intr(rtc_intr))
-		rtc_update_irq(cmos->rtc, 1, rtc_intr);
+	if (enabled)
+		cmos_irq_enable(cmos, RTC_PIE);
+	else
+		cmos_irq_disable(cmos, RTC_PIE);
 
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return 0;
@@ -368,7 +386,6 @@ static int
 cmos_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	unsigned char	rtc_control, rtc_intr;
 	unsigned long	flags;
 
 	switch (cmd) {
@@ -385,32 +402,20 @@ cmos_rtc_ioctl(struct device *dev, unsig
 	}
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	rtc_control = CMOS_READ(RTC_CONTROL);
 	switch (cmd) {
 	case RTC_AIE_OFF:	/* alarm off */
-		rtc_control &= ~RTC_AIE;
-		hpet_mask_rtc_irq_bit(RTC_AIE);
+		cmos_irq_disable(cmos, RTC_AIE);
 		break;
 	case RTC_AIE_ON:	/* alarm on */
-		rtc_control |= RTC_AIE;
-		hpet_set_rtc_irq_bit(RTC_AIE);
+		cmos_irq_enable(cmos, RTC_AIE);
 		break;
 	case RTC_UIE_OFF:	/* update off */
-		rtc_control &= ~RTC_UIE;
-		hpet_mask_rtc_irq_bit(RTC_UIE);
+		cmos_irq_disable(cmos, RTC_UIE);
 		break;
 	case RTC_UIE_ON:	/* update on */
-		rtc_control |= RTC_UIE;
-		hpet_set_rtc_irq_bit(RTC_UIE);
+		cmos_irq_enable(cmos, RTC_UIE);
 		break;
 	}
-	CMOS_WRITE(rtc_control, RTC_CONTROL);
-
-	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
-	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
-	if (is_intr(rtc_intr))
-		rtc_update_irq(cmos->rtc, 1, rtc_intr);
-
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return 0;
 }
@@ -571,7 +576,6 @@ static irqreturn_t cmos_interrupt(int ir
 	 * alarm woke the system.
 	 */
 	if (irqstat & RTC_AIE) {
-		rtc_control = CMOS_READ(RTC_CONTROL);
 		rtc_control &= ~RTC_AIE;
 		CMOS_WRITE(rtc_control, RTC_CONTROL);
 		hpet_mask_rtc_irq_bit(RTC_AIE);
@@ -685,17 +689,10 @@ cmos_do_probe(struct device *dev, struct
 	hpet_set_periodic_freq(cmos_rtc.rtc->irq_freq);
 	CMOS_WRITE(RTC_REF_CLCK_32KHZ | 0x06, RTC_FREQ_SELECT);
 
-	/* disable irqs.
-	 *
-	 * NOTE after changing RTC_xIE bits we always read INTR_FLAGS;
-	 * allegedly some older rtcs need that to handle irqs properly
-	 */
-	rtc_control = CMOS_READ(RTC_CONTROL);
-	rtc_control &= ~(RTC_PIE | RTC_AIE | RTC_UIE);
-	CMOS_WRITE(rtc_control, RTC_CONTROL);
-	hpet_mask_rtc_irq_bit(RTC_PIE | RTC_AIE | RTC_UIE);
+	/* disable irqs */
+	cmos_irq_disable(&cmos_rtc, RTC_PIE | RTC_AIE | RTC_UIE);
 
-	CMOS_READ(RTC_INTR_FLAGS);
+	rtc_control = CMOS_READ(RTC_CONTROL);
 
 	spin_unlock_irq(&rtc_lock);
 
@@ -768,15 +765,8 @@ cleanup0:
 
 static void cmos_do_shutdown(void)
 {
-	unsigned char	rtc_control;
-
 	spin_lock_irq(&rtc_lock);
-	rtc_control = CMOS_READ(RTC_CONTROL);
-	rtc_control &= ~RTC_IRQMASK;
-	CMOS_WRITE(rtc_control, RTC_CONTROL);
-	hpet_mask_rtc_irq_bit(RTC_IRQMASK);
-
-	CMOS_READ(RTC_INTR_FLAGS);
+	cmos_irq_disable(&cmos_rtc, RTC_IRQMASK);
 	spin_unlock_irq(&rtc_lock);
 }
 
@@ -817,7 +807,6 @@ static int cmos_suspend(struct device *d
 	spin_lock_irq(&rtc_lock);
 	cmos->suspend_ctrl = tmp = CMOS_READ(RTC_CONTROL);
 	if (tmp & (RTC_PIE|RTC_AIE|RTC_UIE)) {
-		unsigned char	irqstat;
 		unsigned char	mask;
 
 		if (do_wake)
@@ -828,10 +817,7 @@ static int cmos_suspend(struct device *d
 		CMOS_WRITE(tmp, RTC_CONTROL);
 		hpet_mask_rtc_irq_bit(mask);
 
-		irqstat = CMOS_READ(RTC_INTR_FLAGS);
-		irqstat &= (tmp & RTC_IRQMASK) | RTC_IRQF;
-		if (is_intr(irqstat))
-			rtc_update_irq(cmos->rtc, 1, irqstat);
+		cmos_checkintr(cmos, tmp);
 	}
 	spin_unlock_irq(&rtc_lock);
 
@@ -875,7 +861,7 @@ static int cmos_resume(struct device *de
 
 			mask = CMOS_READ(RTC_INTR_FLAGS);
 			mask &= (tmp & RTC_IRQMASK) | RTC_IRQF;
-			if (!is_intr(mask))
+			if (!is_hpet_enabled() || !is_intr(mask))
 				break;
 
 			/* force one-shot behavior if HPET blocked
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
gpio-pcf857x-add-lock-and-handle-more-chips.patch
linux-next.patch
add-have_clk-to-kconfig-for-driver-dependencies.patch
drivers-input-touchscreen-ads7846c-optimize-order-of-calculating-rt-in-ads7846_rx.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
pm-boot-time-suspend-selftest-update.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
spi-spi_mpc83xx-clockrate-fixes.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
spi-kconfig-simplifications.patch
spi-make-spi_board_infomodalias-a-char-array.patch
spidev-bkl-removal.patch
spi-au1550_spi-proper-platform-device.patch
spi-au1550_spi-improve-pio-transfer-mode.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
rtc-remove-bkl-for-ioctl.patch
rtc-ds1305-ds1306-driver.patch
rtc-ds1305-ds1306-driver-fix.patch
rtc-bcd-codeshrink.patch
rtc-rtc-omap-footprint-shrinkage.patch
rtc-cmos-improve-hpet-irq-glue.patch
rtc-at91rm9200-avoid-spurious-irqs.patch
rtc-cmos-avoid-spurious-irqs.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-check-spi_setup-return-code-cleanup.patch
gpio-sysfs-interface-updated.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch

