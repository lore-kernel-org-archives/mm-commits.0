From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:20:38 -0700
Message-ID: <200807292220.m6TMKces024682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbYG2WU6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:20:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, a.zummo@towertech.it, bryan.wu@analog.com, cooloney@kernel.org, david-b@pacbell.net


The patch titled
     blackfin RTC driver: don't bother passing the rtc struct down to bfin_rtc_int_{set,clear} since it isnt needed (shaves off ~100bytes)
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch

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
-
 	if (device_may_wakeup(&pdev->dev))
 		enable_irq_wake(IRQ_RTC);
 	else
-		bfin_rtc_int_clear(rtc, -1);
+		bfin_rtc_int_clear(-1);
 
 	return 0;
 }
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

blackfin-nfc-driver-fix-bug-do-not-clobber-the-status-from-the-first-256-bytes-if-operating-on-512-pages.patch
blackfin-nfc-driver-fix-bug-hw-ecc-calc-by-making-sure-we-extract-11-bits-from-each-register-instead-of-10.patch
blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses.patch
blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions.patch
blackfin-nfc-driver-enable-blackfin-nand-hwecc-support-by-default.patch
blackfin-nfc-driver-use-standard-dev_err-rather-than-printk.patch
blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function.patch
blackfin-rtc-driver-add-support-for-power-management-framework.patch
blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch
blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch
blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping.patch
blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell.patch
blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie.patch

