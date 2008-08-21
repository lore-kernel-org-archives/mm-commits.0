From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-move-irq-request-free-out-of-open-release-and-into-probe-remove-so-that-the-non-dev-interfaces-like-sysfs-work-as-expected.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:03 -0700
Message-ID: <200808210349.m7L3n3u8015608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279AbYHUDtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, a.zummo@towertech.it, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Blackfin RTC Driver: move irq request/free out of open/release and into probe/remove so that the non-dev interfaces (like sysfs) work as expected
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-move-irq-request-free-out-of-open-release-and-into-probe-remove-so-that-the-non-dev-interfaces-like-sysfs-work-as-expected.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

