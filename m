From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:20:44 -0700
Message-ID: <200807292220.m6TMKiJI024692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006AbYG2WVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:21:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, a.zummo@towertech.it, cooloney@kernel.org, david-b@pacbell.net


The patch titled
     blackfin RTC driver: convert PIE handling to irq_set_state() as pointed out by David Brownell
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell.patch

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
Subject: blackfin RTC driver: convert PIE handling to irq_set_state() as pointed out by David Brownell
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell
+++ a/drivers/rtc/rtc-bfin.c
@@ -264,16 +264,6 @@ static int bfin_rtc_ioctl(struct device 
 	bfin_rtc_sync_pending(dev);
 
 	switch (cmd) {
-	case RTC_PIE_ON:
-		dev_dbg_stamp(dev);
-		bfin_rtc_int_set(RTC_ISTAT_STOPWATCH);
-		bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
-		break;
-	case RTC_PIE_OFF:
-		dev_dbg_stamp(dev);
-		bfin_rtc_int_clear(~RTC_ISTAT_STOPWATCH);
-		break;
-
 	case RTC_UIE_ON:
 		dev_dbg_stamp(dev);
 		bfin_rtc_int_set(RTC_ISTAT_SEC);
@@ -381,6 +371,23 @@ static int bfin_rtc_proc(struct device *
 #undef yesno
 }
 
+static int bfin_irq_set_state(struct device *dev, int enabled)
+{
+	struct bfin_rtc *rtc = dev_get_drvdata(dev);
+
+	dev_dbg_stamp(dev);
+
+	bfin_rtc_sync_pending(dev);
+
+	if (enabled) {
+		bfin_rtc_int_set(RTC_ISTAT_STOPWATCH);
+		bfin_write_RTC_SWCNT(rtc->rtc_dev->irq_freq);
+	} else
+		bfin_rtc_int_clear(~RTC_ISTAT_STOPWATCH);
+
+	return 0;
+}
+
 static struct rtc_class_ops bfin_rtc_ops = {
 	.open          = bfin_rtc_open,
 	.release       = bfin_rtc_release,
@@ -390,6 +397,7 @@ static struct rtc_class_ops bfin_rtc_ops
 	.read_alarm    = bfin_rtc_read_alarm,
 	.set_alarm     = bfin_rtc_set_alarm,
 	.proc          = bfin_rtc_proc,
+	.irq_set_state = bfin_irq_set_state,
 };
 
 static int __devinit bfin_rtc_probe(struct platform_device *pdev)
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

