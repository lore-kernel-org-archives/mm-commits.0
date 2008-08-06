From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:34 -0700
Message-ID: <200808062056.m76KuYsD014681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbYHFVKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:10:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, a.zummo@towertech.it, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     blackfin RTC driver: disable the write complete irq upon close
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


