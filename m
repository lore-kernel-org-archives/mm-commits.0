From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:40 -0700
Message-ID: <200808062056.m76Kue7W014690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758448AbYHFU51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, a.zummo@towertech.it, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     blackfin RTC driver: drop PIE/stopwatch code since the hardware can only do a max of 1HZ and this same functionality is provided by UIE
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin RTC driver: drop PIE/stopwatch code since the hardware can only do a max of 1HZ and this same functionality is provided by UIE
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   46 +++++++++++----------------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie
+++ a/drivers/rtc/rtc-bfin.c
@@ -32,6 +32,15 @@
  * writes to clear status registers complete immediately.
  */
 
+/* It may seem odd that there is no SWCNT code in here (which would be exposed
+ * via the periodic interrupt event, or PIE).  Since the Blackfin RTC peripheral
+ * runs in units of seconds (N/HZ) but the Linux framework runs in units of HZ
+ * (2^N HZ), there is no point in keeping code that only provides 1 HZ PIEs.
+ * The same exact behavior can be accomplished by using the update interrupt
+ * event (UIE).  Maybe down the line the RTC peripheral will suck less in which
+ * case we can re-introduce PIE support.
+ */
+
 #include <linux/bcd.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -151,7 +160,6 @@ static void bfin_rtc_reset(struct device
 	bfin_rtc_sync_pending(dev);
 	bfin_write_RTC_PREN(0x1);
 	bfin_write_RTC_ICTL(rtc_ictl);
-	bfin_write_RTC_SWCNT(0);
 	bfin_write_RTC_ALARM(0);
 	bfin_write_RTC_ISTAT(0xFFFF);
 	rtc->rtc_wrote_regs = 0;
@@ -194,14 +202,6 @@ static irqreturn_t bfin_rtc_interrupt(in
 		}
 	}
 
-	if (rtc_ictl & RTC_ISTAT_STOPWATCH) {
-		if (rtc_istat & RTC_ISTAT_STOPWATCH) {
-			bfin_write_RTC_ISTAT(RTC_ISTAT_STOPWATCH);
-			events |= RTC_PF | RTC_IRQF;
-			bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
-		}
-	}
-
 	if (rtc_ictl & RTC_ISTAT_SEC) {
 		if (rtc_istat & RTC_ISTAT_SEC) {
 			bfin_write_RTC_ISTAT(RTC_ISTAT_SEC);
@@ -361,33 +361,14 @@ static int bfin_rtc_proc(struct device *
 	seq_printf(seq,
 		"alarm_IRQ\t: %s\n"
 		"wkalarm_IRQ\t: %s\n"
-		"seconds_IRQ\t: %s\n"
-		"periodic_IRQ\t: %s\n",
+		"seconds_IRQ\t: %s\n",
 		yesno(ictl & RTC_ISTAT_ALARM),
 		yesno(ictl & RTC_ISTAT_ALARM_DAY),
-		yesno(ictl & RTC_ISTAT_SEC),
-		yesno(ictl & RTC_ISTAT_STOPWATCH));
+		yesno(ictl & RTC_ISTAT_SEC));
 	return 0;
 #undef yesno
 }
 
-static int bfin_irq_set_state(struct device *dev, int enabled)
-{
-	struct bfin_rtc *rtc = dev_get_drvdata(dev);
-
-	dev_dbg_stamp(dev);
-
-	bfin_rtc_sync_pending(dev);
-
-	if (enabled) {
-		bfin_rtc_int_set(RTC_ISTAT_STOPWATCH);
-		bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
-	} else
-		bfin_rtc_int_clear(~RTC_ISTAT_STOPWATCH);
-
-	return 0;
-}
-
 static struct rtc_class_ops bfin_rtc_ops = {
 	.open          = bfin_rtc_open,
 	.release       = bfin_rtc_release,
@@ -397,7 +378,6 @@ static struct rtc_class_ops bfin_rtc_ops
 	.read_alarm    = bfin_rtc_read_alarm,
 	.set_alarm     = bfin_rtc_set_alarm,
 	.proc          = bfin_rtc_proc,
-	.irq_set_state = bfin_irq_set_state,
 };
 
 static int __devinit bfin_rtc_probe(struct platform_device *pdev)
@@ -416,7 +396,9 @@ static int __devinit bfin_rtc_probe(stru
 		ret = PTR_ERR(rtc->rtc_dev);
 		goto err;
 	}
-	rtc->rtc_dev->irq_freq = 1;
+
+	/* see comment at top of file about stopwatch/PIE */
+	bfin_write_RTC_SWCNT(0);
 
 	platform_set_drvdata(pdev, rtc);
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are


