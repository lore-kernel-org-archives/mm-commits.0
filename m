From: akpm@linux-foundation.org
Subject: - rtc-cmos-improve-hpet-irq-glue.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:22 -0700
Message-ID: <200807242330.m6ONUMBI011500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756906AbYGXXbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, a.zummo@towertech.it, bwalle@suse.de, crmafra@ift.unesp.br, tomi@nomi.cz, mm-commits@vger.kernel.org


The patch titled
     rtc-cmos: improve HPET IRQ glue
has been removed from the -mm tree.  Its filename was
     rtc-cmos-improve-hpet-irq-glue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cmos: improve HPET IRQ glue
From: David Brownell <dbrownell@users.sourceforge.net>

Resolve http://bugzilla.kernel.org/show_bug.cgi?id=11051 and other bugs
related to the way the HPET glue code in rtc-cmos was incomplete and
inconsistent:

 * Switch the approach so that the basic driver code flow isn't
   changed by having HPET ... instead, just have HPET shadow the
   RTC_CONTROL irq enables and RTC_FREQ_SELECT data.  It's only
   coping with IRQ thievery, after all.

 * Do that consistently (!!) to avoid problems when the HPET code
   is out of sync with the real RTC intent.  Examples include:

   - cmos_procfs(), which now reports correct data

   - cmos_irq_set_state() ... also removing the previous PIE_{ON,OFF}
     ioctl support so only one code path manages "periodic" IRQs

   - cmos_do_shutdown() ... currently a "just in case" change.

   - cmos_suspend() and cmos_resume() ... also handling a bug that
     was specific to HPET's IRQ thievery, where the alarm wasn't
     disabled after waking the system

 * Always call that HPET code under the RTC spinlock (it doesn't do
   its own locking)

Also clean up the HPET glue:

 * Add some comments explaining what's going on.

 * Switch to having just one #ifdef for the HPET glue, and inline
   functions (not #defines) to avoid some compiler warnings.

 * Have the probe message also report when HPET IRQs are involved

This still leaves various holes in the HPET glue, like the emulated update
IRQs being out of sync with the RTC, alarms never using day or month
matches, and many extra IRQs (at 64 Hz).

[akpm@linux-foundation.org: fix build]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Tomas Janousek <tomi@nomi.cz>
Cc: Bernhard Walle <bwalle@suse.de>
Cc: Carlos R. Mafra <crmafra@ift.unesp.br>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |  193 ++++++++++++++++++++++++++-------------
 1 file changed, 131 insertions(+), 62 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-improve-hpet-irq-glue drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-improve-hpet-irq-glue
+++ a/drivers/rtc/rtc-cmos.c
@@ -36,28 +36,9 @@
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
 
-#ifdef CONFIG_HPET_EMULATE_RTC
-#include <asm/hpet.h>
-#endif
-
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
 
-#ifndef CONFIG_HPET_EMULATE_RTC
-#define is_hpet_enabled()			0
-#define hpet_set_alarm_time(hrs, min, sec) 	do { } while (0)
-#define hpet_set_periodic_freq(arg) 		0
-#define hpet_mask_rtc_irq_bit(arg) 		do { } while (0)
-#define hpet_set_rtc_irq_bit(arg) 		do { } while (0)
-#define hpet_rtc_timer_init() 			do { } while (0)
-#define hpet_register_irq_handler(h) 		0
-#define hpet_unregister_irq_handler(h)		do { } while (0)
-static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
-{
-	return 0;
-}
-#endif
-
 struct cmos_rtc {
 	struct rtc_device	*rtc;
 	struct device		*dev;
@@ -96,6 +77,72 @@ static inline int is_intr(u8 rtc_intr)
 
 /*----------------------------------------------------------------*/
 
+/* Much modern x86 hardware has HPETs (10+ MHz timers) which, because
+ * many BIOS programmers don't set up "sane mode" IRQ routing, are mostly
+ * used in a broken "legacy replacement" mode.  The breakage includes
+ * HPET #1 hijacking the IRQ for this RTC, and being unavailable for
+ * other (better) use.
+ *
+ * When that broken mode is in use, platform glue provides a partial
+ * emulation of hardware RTC IRQ facilities using HPET #1.  We don't
+ * want to use HPET for anything except those IRQs though...
+ */
+#ifdef CONFIG_HPET_EMULATE_RTC
+#include <asm/hpet.h>
+#else
+
+static inline int is_hpet_enabled(void)
+{
+	return 0;
+}
+
+static inline int hpet_mask_rtc_irq_bit(unsigned long mask)
+{
+	return 0;
+}
+
+static inline int hpet_set_rtc_irq_bit(unsigned long mask)
+{
+	return 0;
+}
+
+static inline int
+hpet_set_alarm_time(unsigned char hrs, unsigned char min, unsigned char sec)
+{
+	return 0;
+}
+
+static inline int hpet_set_periodic_freq(unsigned long freq)
+{
+	return 0;
+}
+
+static inline int hpet_rtc_dropped_irq(void)
+{
+	return 0;
+}
+
+static inline int hpet_rtc_timer_init(void)
+{
+	return 0;
+}
+
+extern irq_handler_t hpet_rtc_interrupt;
+
+static inline int hpet_register_irq_handler(irq_handler_t handler)
+{
+	return 0;
+}
+
+static inline int hpet_unregister_irq_handler(irq_handler_t handler)
+{
+	return 0;
+}
+
+#endif
+
+/*----------------------------------------------------------------*/
+
 static int cmos_read_time(struct device *dev, struct rtc_time *t)
 {
 	/* REVISIT:  if the clock has a "century" register, use
@@ -216,13 +263,14 @@ static int cmos_set_alarm(struct device 
 	sec = t->time.tm_sec;
 	sec = (sec < 60) ? BIN2BCD(sec) : 0xff;
 
-	hpet_set_alarm_time(t->time.tm_hour, t->time.tm_min, t->time.tm_sec);
 	spin_lock_irq(&rtc_lock);
 
 	/* next rtc irq must not be from previous alarm setting */
 	rtc_control = CMOS_READ(RTC_CONTROL);
 	rtc_control &= ~RTC_AIE;
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
+	hpet_mask_rtc_irq_bit(RTC_AIE);
+
 	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
 	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
 	if (is_intr(rtc_intr))
@@ -240,9 +288,16 @@ static int cmos_set_alarm(struct device 
 			CMOS_WRITE(mon, cmos->mon_alrm);
 	}
 
+	/* FIXME the HPET alarm glue currently ignores day_alrm
+	 * and mon_alrm ...
+	 */
+	hpet_set_alarm_time(t->time.tm_hour, t->time.tm_min, t->time.tm_sec);
+
 	if (t->enabled) {
 		rtc_control |= RTC_AIE;
 		CMOS_WRITE(rtc_control, RTC_CONTROL);
+		hpet_set_rtc_irq_bit(RTC_AIE);
+
 		rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
 		rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
 		if (is_intr(rtc_intr))
@@ -270,8 +325,8 @@ static int cmos_irq_set_freq(struct devi
 	f = 16 - f;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	if (!hpet_set_periodic_freq(freq))
-		CMOS_WRITE(RTC_REF_CLCK_32KHZ | f, RTC_FREQ_SELECT);
+	hpet_set_periodic_freq(freq);
+	CMOS_WRITE(RTC_REF_CLCK_32KHZ | f, RTC_FREQ_SELECT);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	return 0;
@@ -289,11 +344,13 @@ static int cmos_irq_set_state(struct dev
 	spin_lock_irqsave(&rtc_lock, flags);
 	rtc_control = CMOS_READ(RTC_CONTROL);
 
-	if (enabled)
+	if (enabled) {
 		rtc_control |= RTC_PIE;
-	else
+		hpet_set_rtc_irq_bit(RTC_PIE);
+	} else {
 		rtc_control &= ~RTC_PIE;
-
+		hpet_mask_rtc_irq_bit(RTC_PIE);
+	}
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
 
 	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
@@ -319,11 +376,10 @@ cmos_rtc_ioctl(struct device *dev, unsig
 	case RTC_AIE_ON:
 	case RTC_UIE_OFF:
 	case RTC_UIE_ON:
-	case RTC_PIE_OFF:
-	case RTC_PIE_ON:
 		if (!is_valid_irq(cmos->irq))
 			return -EINVAL;
 		break;
+	/* PIE ON/OFF is handled by cmos_irq_set_state() */
 	default:
 		return -ENOIOCTLCMD;
 	}
@@ -347,17 +403,8 @@ cmos_rtc_ioctl(struct device *dev, unsig
 		rtc_control |= RTC_UIE;
 		hpet_set_rtc_irq_bit(RTC_UIE);
 		break;
-	case RTC_PIE_OFF:	/* periodic off */
-		rtc_control &= ~RTC_PIE;
-		hpet_mask_rtc_irq_bit(RTC_PIE);
-		break;
-	case RTC_PIE_ON:	/* periodic on */
-		rtc_control |= RTC_PIE;
-		hpet_set_rtc_irq_bit(RTC_PIE);
-		break;
 	}
-	if (!is_hpet_enabled())
-		CMOS_WRITE(rtc_control, RTC_CONTROL);
+	CMOS_WRITE(rtc_control, RTC_CONTROL);
 
 	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
 	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
@@ -505,18 +552,19 @@ static irqreturn_t cmos_interrupt(int ir
 	u8		rtc_control;
 
 	spin_lock(&rtc_lock);
-	/*
-	 * In this case it is HPET RTC interrupt handler
-	 * calling us, with the interrupt information
-	 * passed as arg1, instead of irq.
+
+	/* When the HPET interrupt handler calls us, the interrupt
+	 * status is passed as arg1 instead of the irq number.  But
+	 * always clear irq status, even when HPET is in the way.
+	 *
+	 * Note that HPET and RTC are almost certainly out of phase,
+	 * giving different IRQ status ...
 	 */
+	irqstat = CMOS_READ(RTC_INTR_FLAGS);
+	rtc_control = CMOS_READ(RTC_CONTROL);
 	if (is_hpet_enabled())
 		irqstat = (unsigned long)irq & 0xF0;
-	else {
-		irqstat = CMOS_READ(RTC_INTR_FLAGS);
-		rtc_control = CMOS_READ(RTC_CONTROL);
-		irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
-	}
+	irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
 
 	/* All Linux RTC alarms should be treated as if they were oneshot.
 	 * Similar code may be needed in system wakeup paths, in case the
@@ -526,6 +574,8 @@ static irqreturn_t cmos_interrupt(int ir
 		rtc_control = CMOS_READ(RTC_CONTROL);
 		rtc_control &= ~RTC_AIE;
 		CMOS_WRITE(rtc_control, RTC_CONTROL);
+		hpet_mask_rtc_irq_bit(RTC_AIE);
+
 		CMOS_READ(RTC_INTR_FLAGS);
 	}
 	spin_unlock(&rtc_lock);
@@ -632,8 +682,8 @@ cmos_do_probe(struct device *dev, struct
 	 * do something about other clock frequencies.
 	 */
 	cmos_rtc.rtc->irq_freq = 1024;
-	if (!hpet_set_periodic_freq(cmos_rtc.rtc->irq_freq))
-		CMOS_WRITE(RTC_REF_CLCK_32KHZ | 0x06, RTC_FREQ_SELECT);
+	hpet_set_periodic_freq(cmos_rtc.rtc->irq_freq);
+	CMOS_WRITE(RTC_REF_CLCK_32KHZ | 0x06, RTC_FREQ_SELECT);
 
 	/* disable irqs.
 	 *
@@ -643,6 +693,8 @@ cmos_do_probe(struct device *dev, struct
 	rtc_control = CMOS_READ(RTC_CONTROL);
 	rtc_control &= ~(RTC_PIE | RTC_AIE | RTC_UIE);
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
+	hpet_mask_rtc_irq_bit(RTC_PIE | RTC_AIE | RTC_UIE);
+
 	CMOS_READ(RTC_INTR_FLAGS);
 
 	spin_unlock_irq(&rtc_lock);
@@ -690,7 +742,7 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup2;
 	}
 
-	pr_info("%s: alarms up to one %s%s\n",
+	pr_info("%s: alarms up to one %s%s%s\n",
 			cmos_rtc.rtc->dev.bus_id,
 			is_valid_irq(rtc_irq)
 				?  (cmos_rtc.mon_alrm
@@ -698,8 +750,8 @@ cmos_do_probe(struct device *dev, struct
 					: (cmos_rtc.day_alrm
 						? "month" : "day"))
 				: "no",
-			cmos_rtc.century ? ", y3k" : ""
-			);
+			cmos_rtc.century ? ", y3k" : "",
+			is_hpet_enabled() ? ", hpet irqs" : "");
 
 	return 0;
 
@@ -720,8 +772,10 @@ static void cmos_do_shutdown(void)
 
 	spin_lock_irq(&rtc_lock);
 	rtc_control = CMOS_READ(RTC_CONTROL);
-	rtc_control &= ~(RTC_PIE|RTC_AIE|RTC_UIE);
+	rtc_control &= ~RTC_IRQMASK;
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
+	hpet_mask_rtc_irq_bit(RTC_IRQMASK);
+
 	CMOS_READ(RTC_INTR_FLAGS);
 	spin_unlock_irq(&rtc_lock);
 }
@@ -764,12 +818,16 @@ static int cmos_suspend(struct device *d
 	cmos->suspend_ctrl = tmp = CMOS_READ(RTC_CONTROL);
 	if (tmp & (RTC_PIE|RTC_AIE|RTC_UIE)) {
 		unsigned char	irqstat;
+		unsigned char	mask;
 
 		if (do_wake)
-			tmp &= ~(RTC_PIE|RTC_UIE);
+			mask = RTC_IRQMASK & ~RTC_AIE;
 		else
-			tmp &= ~(RTC_PIE|RTC_AIE|RTC_UIE);
+			mask = RTC_IRQMASK;
+		tmp &= ~mask;
 		CMOS_WRITE(tmp, RTC_CONTROL);
+		hpet_mask_rtc_irq_bit(mask);
+
 		irqstat = CMOS_READ(RTC_INTR_FLAGS);
 		irqstat &= (tmp & RTC_IRQMASK) | RTC_IRQF;
 		if (is_intr(irqstat))
@@ -799,7 +857,8 @@ static int cmos_resume(struct device *de
 	unsigned char	tmp = cmos->suspend_ctrl;
 
 	/* re-enable any irqs previously active */
-	if (tmp & (RTC_PIE|RTC_AIE|RTC_UIE)) {
+	if (tmp & RTC_IRQMASK) {
+		unsigned char	mask;
 
 		if (cmos->enabled_wake) {
 			if (cmos->wake_off)
@@ -810,18 +869,28 @@ static int cmos_resume(struct device *de
 		}
 
 		spin_lock_irq(&rtc_lock);
-		CMOS_WRITE(tmp, RTC_CONTROL);
-		tmp = CMOS_READ(RTC_INTR_FLAGS);
-		tmp &= (cmos->suspend_ctrl & RTC_IRQMASK) | RTC_IRQF;
-		if (is_intr(tmp))
-			rtc_update_irq(cmos->rtc, 1, tmp);
+		do {
+			CMOS_WRITE(tmp, RTC_CONTROL);
+			hpet_set_rtc_irq_bit(tmp & RTC_IRQMASK);
+
+			mask = CMOS_READ(RTC_INTR_FLAGS);
+			mask &= (tmp & RTC_IRQMASK) | RTC_IRQF;
+			if (!is_intr(mask))
+				break;
+
+			/* force one-shot behavior if HPET blocked
+			 * the wake alarm's irq
+			 */
+			rtc_update_irq(cmos->rtc, 1, mask);
+			tmp &= ~RTC_AIE;
+			hpet_mask_rtc_irq_bit(RTC_AIE);
+		} while (mask & RTC_AIE);
 		spin_unlock_irq(&rtc_lock);
 	}
 
 	pr_debug("%s: resume, ctrl %02x\n",
 			cmos_rtc.rtc->dev.bus_id,
-			cmos->suspend_ctrl);
