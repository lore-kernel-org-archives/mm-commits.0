From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-move-irq-request-free-out-of-open-release-and-into-probe-remove-so-that-the-non-dev-interfaces-like-sysfs-work-as-expected.patch added to -mm tree
Date: Mon, 18 Aug 2008 14:57:07 -0700
Message-ID: <200808182157.m7ILv7GC014946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbYHRV5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 17:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, a.zummo@towertech.it, cooloney@kernel.org


The patch titled
     Blackfin RTC Driver: move irq request/free out of open/release and into probe/remove so that the non-dev interfaces (like sysfs) work as expected
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-move-irq-request-free-out-of-open-release-and-into-probe-remove-so-that-the-non-dev-interfaces-like-sysfs-work-as-expected.patch

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
Subject: Blackfin RTC Driver: move irq request/free out of open/release and into probe/remove so that the non-dev interfaces (like sysfs) work as expected
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   51 +++++++++++++++------------------------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-move-irq-request-free-out-of-open-release-and-into-probe-remove-so-that-the-non-dev-interfaces-like-sysfs-work-as-expected drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-move-irq-request-free-out-of-open-release-and-into-probe-remove-so-that-the-non-dev-interfaces-like-sysfs-work-as-expected
+++ a/drivers/rtc/rtc-bfin.c
@@ -218,26 +218,6 @@ static irqreturn_t bfin_rtc_interrupt(in
 		return IRQ_NONE;
 }
 
-static int bfin_rtc_open(struct device *dev)
-{
-	int ret;
-
-	dev_dbg_stamp(dev);
-
-	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, to_platform_device(dev)->name, dev);
-	if (!ret)
-		bfin_rtc_reset(dev, RTC_ISTAT_WRITE_COMPLETE);
-
-	return ret;
-}
-
-static void bfin_rtc_release(struct device *dev)
-{
-	dev_dbg_stamp(dev);
-	bfin_rtc_reset(dev, 0);
-	free_irq(IRQ_RTC, dev);
-}
-
 static void bfin_rtc_int_set(u16 rtc_int)
 {
 	bfin_write_RTC_ISTAT(rtc_int);
@@ -370,8 +350,6 @@ static int bfin_rtc_proc(struct device *
 }
 
 static struct rtc_class_ops bfin_rtc_ops = {
-	.open          = bfin_rtc_open,
-	.release       = bfin_rtc_release,
 	.ioctl         = bfin_rtc_ioctl,
 	.read_time     = bfin_rtc_read_time,
 	.set_time      = bfin_rtc_set_time,
@@ -383,29 +361,37 @@ static struct rtc_class_ops bfin_rtc_ops
 static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 {
 	struct bfin_rtc *rtc;
+	struct device *dev = &pdev->dev;
 	int ret = 0;
 
-	dev_dbg_stamp(&pdev->dev);
+	dev_dbg_stamp(dev);
 
+	/* Allocate memory for our RTC struct */
 	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
 	if (unlikely(!rtc))
 		return -ENOMEM;
+	platform_set_drvdata(pdev, rtc);
 
-	rtc->rtc_dev = rtc_device_register(pdev->name, &pdev->dev, &bfin_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc->rtc_dev);
+	/* Grab the IRQ and init the hardware */
+	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, pdev->name, dev);
+	if (unlikely(ret))
 		goto err;
-	}
-
-	/* see comment at top of file about stopwatch/PIE */
+	bfin_rtc_reset(dev, RTC_ISTAT_WRITE_COMPLETE);
 	bfin_write_RTC_SWCNT(0);
 
-	platform_set_drvdata(pdev, rtc);
+	/* Register our RTC with the RTC framework */
+	rtc->rtc_dev = rtc_device_register(pdev->name, dev, &bfin_rtc_ops, THIS_MODULE);
+	if (unlikely(IS_ERR(rtc))) {
+		ret = PTR_ERR(rtc->rtc_dev);
+		goto err_irq;
+	}
 
-	device_init_wakeup(&pdev->dev, 1);
+	device_init_wakeup(dev, 1);
 
 	return 0;
 
+ err_irq:
+	free_irq(IRQ_RTC, dev);
  err:
 	kfree(rtc);
 	return ret;
@@ -414,7 +400,10 @@ static int __devinit bfin_rtc_probe(stru
 static int __devexit bfin_rtc_remove(struct platform_device *pdev)
 {
 	struct bfin_rtc *rtc = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
 
+	bfin_rtc_reset(dev, 0);
+	free_irq(IRQ_RTC, dev);
 	rtc_device_unregister(rtc->rtc_dev);
 	platform_set_drvdata(pdev, NULL);
 	kfree(rtc);
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
blackfin-rtc-driver-move-irq-request-free-out-of-open-release-and-into-probe-remove-so-that-the-non-dev-interfaces-like-sysfs-work-as-expected.patch
blackfin-rtc-driver-do-all-initialization-before-we-register-the-rtc-and-make-it-available.patch
blackfin-rtc-driver-dont-let-rtc-programming-in-bootloaders-randomly-cause-5-second-boot-delays.patch
linux-next.patch

