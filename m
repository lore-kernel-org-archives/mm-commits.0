From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:32 -0700
Message-ID: <200808062056.m76KuWD2014678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753646AbYHFVBa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:01:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, a.zummo@towertech.it, bryan.wu@analog.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     blackfin RTC driver: don't bother passing the rtc struct down to bfin_rtc_int_{set,clear} since it isnt needed (shaves off ~100bytes)
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin RTC driver: don't bother passing the rtc struct down to bfin_rtc_int_{set,clear} since it isnt needed (shaves off ~100bytes)
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes
+++ a/drivers/rtc/rtc-bfin.c
@@ -238,12 +238,12 @@ static void bfin_rtc_release(struct devi
 	free_irq(IRQ_RTC, dev);
 }
 
-static void bfin_rtc_int_set(struct bfin_rtc *rtc, u16 rtc_int)
+static void bfin_rtc_int_set(u16 rtc_int)
 {
 	bfin_write_RTC_ISTAT(rtc_int);
 	bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() | rtc_int);
 }
-static void bfin_rtc_int_clear(struct bfin_rtc *rtc, u16 rtc_int)
+static void bfin_rtc_int_clear(u16 rtc_int)
 {
 	bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() & rtc_int);
 }
@@ -252,7 +252,7 @@ static void bfin_rtc_int_set_alarm(struc
 	/* Blackfin has different bits for whether the alarm is
 	 * more than 24 hours away.
 	 */
-	bfin_rtc_int_set(rtc, (rtc->rtc_alarm.tm_yday == -1 ? RTC_ISTAT_ALARM : RTC_ISTAT_ALARM_DAY));
+	bfin_rtc_int_set(rtc->rtc_alarm.tm_yday == -1 ? RTC_ISTAT_ALARM : RTC_ISTAT_ALARM_DAY);
 }
 static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 {
@@ -266,21 +266,21 @@ static int bfin_rtc_ioctl(struct device 
 	switch (cmd) {
 	case RTC_PIE_ON:
 		dev_dbg_stamp(dev);
-		bfin_rtc_int_set(rtc, RTC_ISTAT_STOPWATCH);
+		bfin_rtc_int_set(RTC_ISTAT_STOPWATCH);
 		bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
 		break;
 	case RTC_PIE_OFF:
 		dev_dbg_stamp(dev);
-		bfin_rtc_int_clear(rtc, ~RTC_ISTAT_STOPWATCH);
+		bfin_rtc_int_clear(~RTC_ISTAT_STOPWATCH);
 		break;
 
 	case RTC_UIE_ON:
 		dev_dbg_stamp(dev);
-		bfin_rtc_int_set(rtc, RTC_ISTAT_SEC);
+		bfin_rtc_int_set(RTC_ISTAT_SEC);
 		break;
 	case RTC_UIE_OFF:
 		dev_dbg_stamp(dev);
-		bfin_rtc_int_clear(rtc, ~RTC_ISTAT_SEC);
+		bfin_rtc_int_clear(~RTC_ISTAT_SEC);
 		break;
 
 	case RTC_AIE_ON:
@@ -289,7 +289,7 @@ static int bfin_rtc_ioctl(struct device 
 		break;
 	case RTC_AIE_OFF:
 		dev_dbg_stamp(dev);
-		bfin_rtc_int_clear(rtc, ~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
+		bfin_rtc_int_clear(~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
 		break;
 
 	default:
@@ -435,12 +435,10 @@ static int __devexit bfin_rtc_remove(str
 #ifdef CONFIG_PM
 static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
