From: akpm@linux-foundation.org
Subject: + bfin-delay-irq-registration-until-driver-is-ready.patch added to -mm tree
Date: Fri, 26 Jun 2009 16:02:03 -0700
Message-ID: <200906262302.n5QN23ar022432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379AbZFZXCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 19:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.zummo@towertech.it


The patch titled
     bfin: delay IRQ registration until driver is ready
has been added to the -mm tree.  Its filename is
     bfin-delay-irq-registration-until-driver-is-ready.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bfin: delay IRQ registration until driver is ready
From: Mike Frysinger <vapier@gentoo.org>

Make sure we do not actually request the RTC IRQ until the device driver
is fully ready to handle and process any interrupt.  This way a spurious
interrupt won't crash the system (which may happen if the bootloader was
poking the RTC right before booting Linux).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~bfin-delay-irq-registration-until-driver-is-ready drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~bfin-delay-irq-registration-until-driver-is-ready
+++ a/drivers/rtc/rtc-bfin.c
@@ -1,8 +1,8 @@
 /*
  * Blackfin On-Chip Real Time Clock Driver
- *  Supports BF52[257]/BF53[123]/BF53[467]/BF54[24789]
+ *  Supports BF51x/BF52x/BF53[123]/BF53[467]/BF54x
  *
- * Copyright 2004-2008 Analog Devices Inc.
+ * Copyright 2004-2009 Analog Devices Inc.
  *
  * Enter bugs at http://blackfin.uclinux.org/
  *
@@ -363,7 +363,7 @@ static int __devinit bfin_rtc_probe(stru
 	struct bfin_rtc *rtc;
 	struct device *dev = &pdev->dev;
 	int ret = 0;
-	unsigned long timeout;
+	unsigned long timeout = jiffies + HZ;
 
 	dev_dbg_stamp(dev);
 
@@ -374,31 +374,30 @@ static int __devinit bfin_rtc_probe(stru
 	platform_set_drvdata(pdev, rtc);
 	device_init_wakeup(dev, 1);
 
+	/* Register our RTC with the RTC framework */
+	rtc->rtc_dev = rtc_device_register(pdev->name, dev, &bfin_rtc_ops, THIS_MODULE);
+	if (unlikely(IS_ERR(rtc->rtc_dev))) {
+		ret = PTR_ERR(rtc->rtc_dev);
+		goto err;
+	}
+
 	/* Grab the IRQ and init the hardware */
 	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, 0, pdev->name, dev);
 	if (unlikely(ret))
-		goto err;
+		goto err_reg;
 	/* sometimes the bootloader touched things, but the write complete was not
 	 * enabled, so let's just do a quick timeout here since the IRQ will not fire ...
 	 */
-	timeout = jiffies + HZ;
 	while (bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_PENDING)
 		if (time_after(jiffies, timeout))
 			break;
 	bfin_rtc_reset(dev, RTC_ISTAT_WRITE_COMPLETE);
 	bfin_write_RTC_SWCNT(0);
 
-	/* Register our RTC with the RTC framework */
-	rtc->rtc_dev = rtc_device_register(pdev->name, dev, &bfin_rtc_ops, THIS_MODULE);
-	if (unlikely(IS_ERR(rtc->rtc_dev))) {
-		ret = PTR_ERR(rtc->rtc_dev);
-		goto err_irq;
-	}
