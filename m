From: akpm@linux-foundation.org
Subject: [merged] bfin-delay-irq-registration-until-driver-is-ready.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:27:38 -0700
Message-ID: <200907011728.n61HS9lI003032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbZGAR2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     bfin: delay IRQ registration until driver is ready
has been removed from the -mm tree.  Its filename was
     bfin-delay-irq-registration-until-driver-is-ready.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/rtc/rtc-bfin.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

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
 
@@ -374,32 +374,32 @@ static int __devinit bfin_rtc_probe(stru
 	platform_set_drvdata(pdev, rtc);
 	device_init_wakeup(dev, 1);
 
+	/* Register our RTC with the RTC framework */
+	rtc->rtc_dev = rtc_device_register(pdev->name, dev, &bfin_rtc_ops,
+						THIS_MODULE);
+	if (unlikely(IS_ERR(rtc->rtc_dev))) {
+		ret = PTR_ERR(rtc->rtc_dev);
+		goto err;
+	}
+
 	/* Grab the IRQ and init the hardware */
 	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, pdev->name, dev);
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
-
 	return 0;
 
- err_irq:
-	free_irq(IRQ_RTC, dev);
- err:
+err_reg:
+	rtc_device_unregister(rtc->rtc_dev);
+err:
 	kfree(rtc);
 	return ret;
 }
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset.patch
flat-fix-uninitialized-ptr-with-shared-libs.patch
serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch
rtc-bfin-do-not-share-rtc-irq.patch

