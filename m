From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:20:40 -0700
Message-ID: <200807292220.m6TMKeR1024685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbYG2WU7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, a.zummo@towertech.it, cooloney@kernel.org, david-b@pacbell.net


The patch titled
     blackfin RTC driver: disable the write complete irq upon close
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch

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
Subject: blackfin RTC driver: disable the write complete irq upon close
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-disable-the-write-complete-irq-upon-close drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-disable-the-write-complete-irq-upon-close
+++ a/drivers/rtc/rtc-bfin.c
@@ -144,13 +144,13 @@ static void bfin_rtc_sync_pending(struct
  * Initialize the RTC.  Enable pre-scaler to scale RTC clock
  * to 1Hz and clear interrupt/status registers.
  */
-static void bfin_rtc_reset(struct device *dev)
+static void bfin_rtc_reset(struct device *dev, u16 rtc_ictl)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	dev_dbg_stamp(dev);
 	bfin_rtc_sync_pending(dev);
 	bfin_write_RTC_PREN(0x1);
-	bfin_write_RTC_ICTL(RTC_ISTAT_WRITE_COMPLETE);
+	bfin_write_RTC_ICTL(rtc_ictl);
 	bfin_write_RTC_SWCNT(0);
 	bfin_write_RTC_ALARM(0);
 	bfin_write_RTC_ISTAT(0xFFFF);
@@ -226,7 +226,7 @@ static int bfin_rtc_open(struct device *
 
 	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, to_platform_device(dev)->name, dev);
 	if (!ret)
-		bfin_rtc_reset(dev);
+		bfin_rtc_reset(dev, RTC_ISTAT_WRITE_COMPLETE);
 
 	return ret;
 }
@@ -234,7 +234,7 @@ static int bfin_rtc_open(struct device *
 static void bfin_rtc_release(struct device *dev)
 {
 	dev_dbg_stamp(dev);
-	bfin_rtc_reset(dev);
+	bfin_rtc_reset(dev, 0);
 	free_irq(IRQ_RTC, dev);
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

