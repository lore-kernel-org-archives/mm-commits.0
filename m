From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:28:14 -0800
Message-ID: <200712042028.lB4KSEHr003487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50159 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbXLDU3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:29:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.frysinger@analog.com, alessandro.zummo@towertech.it, bryan.wu@analog.com


The patch titled
     Blackfin RTC driver: the frequency function is in units of Hz, not units of seconds, so lock our driver down to 1 Hz
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin RTC driver: the frequency function is in units of Hz, not units of seconds, so lock our driver down to 1 Hz
From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz
+++ a/drivers/rtc/rtc-bfin.c
@@ -72,7 +72,7 @@ struct bfin_rtc {
 #define SEC_BITS_OFF    0
 
 /* Some helper functions to convert between the common RTC notion of time
- * and the internal Blackfin notion that is stored in 32bits.
+ * and the internal Blackfin notion that is encoded in 32bits.
  */
 static inline u32 rtc_time_to_bfin(unsigned long now)
 {
@@ -112,6 +112,11 @@ static inline void rtc_bfin_to_tm(u32 rt
  * If anyone can point out the obvious solution here, i'm listening :).  This
  * shouldn't be an issue on an SMP or preempt system as this function should
  * only be called with the rtc lock held.
+ *
+ * Other options:
+ *  - disable PREN so the sync happens at 32.768kHZ ... but this changes the
+ *    inc rate for all RTC registers from 1HZ to 32.768kHZ ...
+ *  - use the write complete IRQ
  */
 static void rtc_bfin_sync_pending(void)
 {
@@ -356,12 +361,18 @@ static int bfin_rtc_proc(struct device *
 	return 0;
 }
 
+/**
+ *	bfin_irq_set_freq - make sure hardware supports requested freq
+ *	@dev: pointer to RTC device structure
+ *	@freq: requested frequency rate
+ *
+ *	The Blackfin RTC can only generate periodic events at 1 per
+ *	second (1 Hz), so reject any attempt at changing it.
+ */
 static int bfin_irq_set_freq(struct device *dev, int freq)
 {
-	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	stampit();
-	rtc->rtc_dev->irq_freq = freq;
-	return 0;
+	return -ENOTTY;
 }
 
 static struct rtc_class_ops bfin_rtc_ops = {
@@ -394,14 +405,13 @@ static int __devinit bfin_rtc_probe(stru
 		ret = PTR_ERR(rtc->rtc_dev);
 		goto err;
 	}
-	rtc->rtc_dev->irq_freq = 0;
-	rtc->rtc_dev->max_user_freq = (2 << 16); /* stopwatch is an unsigned 16 bit reg */
+	rtc->rtc_dev->irq_freq = 1;
 
 	platform_set_drvdata(pdev, rtc);
 
 	return 0;
 
-err:
+ err:
 	kfree(rtc);
 	return ret;
 }
_

Patches currently in -mm which might be from michael.frysinger@analog.com are

spi-spi_bfin-dont-bypass-spi-framework.patch
blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
