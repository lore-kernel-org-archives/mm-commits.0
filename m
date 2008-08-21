From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-dont-let-rtc-programming-in-bootloaders-randomly-cause-5-second-boot-delays.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:10 -0700
Message-ID: <200808210349.m7L3nAcq015617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380AbYHUDt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, a.zummo@towertech.it, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Blackfin RTC Driver: dont let RTC programming in bootloaders randomly cause ~5 second boot delays
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-dont-let-rtc-programming-in-bootloaders-randomly-cause-5-second-boot-delays.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin RTC Driver: dont let RTC programming in bootloaders randomly cause ~5 second boot delays
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-dont-let-rtc-programming-in-bootloaders-randomly-cause-5-second-boot-delays drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-dont-let-rtc-programming-in-bootloaders-randomly-cause-5-second-boot-delays
+++ a/drivers/rtc/rtc-bfin.c
@@ -363,6 +363,7 @@ static int __devinit bfin_rtc_probe(stru
 	struct bfin_rtc *rtc;
 	struct device *dev = &pdev->dev;
 	int ret = 0;
+	unsigned long timeout;
 
 	dev_dbg_stamp(dev);
 
@@ -377,6 +378,13 @@ static int __devinit bfin_rtc_probe(stru
 	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, pdev->name, dev);
 	if (unlikely(ret))
 		goto err;
+	/* sometimes the bootloader touched things, but the write complete was not
+	 * enabled, so let's just do a quick timeout here since the IRQ will not fire ...
+	 */
+	timeout = jiffies + HZ;
+	while (bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_PENDING)
+		if (time_after(jiffies, timeout))
+			break;
 	bfin_rtc_reset(dev, RTC_ISTAT_WRITE_COMPLETE);
 	bfin_write_RTC_SWCNT(0);
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

linux-next.patch

