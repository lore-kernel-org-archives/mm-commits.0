From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1511-fix-races-around-device-registration.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:34:21 -0800
Message-ID: <200912162034.nBGKYL4k013017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763207AbZLPUei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, andy.sharp@lsi.com, david-b@pacbell.net, thomas.hommel@gefanuc.com, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1511: fix races around device registration
has been removed from the -mm tree.  Its filename was
     rtc-ds1511-fix-races-around-device-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-ds1511: fix races around device registration
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

- Call dev_set_drvdata before rtc device creation.

- Use its own spinlock instead of rtc->irq_lock.  Because pdata->rtc
  must be initialized to use the irq_lock (pdata->rtc->irq_lock).  There
  is a small window which rtc methods can be called before pdata->rtc is
  initialized.

  And there is no need use the irq_lock to protect hardware registers. 
  The driver's own spinlock shoule be enough.

- Check pdata->rtc before calling rtc_update_irq.

- Use {alarm,update}_irq_enable and remove ioctl routine.

- Use devres APIs and simplify error/remove path.

These fixes are ported from ds1553 driver and just compile-tested only.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Andrew Sharp <andy.sharp@lsi.com>
Cc: Thomas Hommel <thomas.hommel@gefanuc.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1511.c |  146 ++++++++++++++-----------------------
 1 file changed, 59 insertions(+), 87 deletions(-)

diff -puN drivers/rtc/rtc-ds1511.c~rtc-ds1511-fix-races-around-device-registration drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~rtc-ds1511-fix-races-around-device-registration
+++ a/drivers/rtc/rtc-ds1511.c
@@ -87,7 +87,6 @@ enum ds1511reg {
 struct rtc_plat_data {
 	struct rtc_device *rtc;
 	void __iomem *ioaddr;		/* virtual base address */
-	unsigned long baseaddr;		/* physical base address */
 	int size;				/* amount of memory mapped */
 	int irq;
 	unsigned int irqen;
@@ -95,6 +94,7 @@ struct rtc_plat_data {
 	int alrm_min;
 	int alrm_hour;
 	int alrm_mday;
+	spinlock_t lock;
 };
 
 static DEFINE_SPINLOCK(ds1511_lock);
@@ -302,7 +302,7 @@ ds1511_rtc_update_alarm(struct rtc_plat_
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&pdata->rtc->irq_lock, flags);
+	spin_lock_irqsave(&pdata->lock, flags);
 	rtc_write(pdata->alrm_mday < 0 || (pdata->irqen & RTC_UF) ?
 	       0x80 : bin2bcd(pdata->alrm_mday) & 0x3f,
 	       RTC_ALARM_DATE);
@@ -317,7 +317,7 @@ ds1511_rtc_update_alarm(struct rtc_plat_
 	       RTC_ALARM_SEC);
 	rtc_write(rtc_read(RTC_CMD) | (pdata->irqen ? RTC_TIE : 0), RTC_CMD);
 	rtc_read(RTC_CMD1);	/* clear interrupts */
-	spin_unlock_irqrestore(&pdata->rtc->irq_lock, flags);
+	spin_unlock_irqrestore(&pdata->lock, flags);
 }
 
  static int
@@ -362,61 +362,63 @@ ds1511_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-	unsigned long events = RTC_IRQF;
+	unsigned long events = 0;
 
+	spin_lock(&pdata->lock);
 	/*
 	 * read and clear interrupt
 	 */
-	if (!(rtc_read(RTC_CMD1) & DS1511_IRQF)) {
-		return IRQ_NONE;
+	if (rtc_read(RTC_CMD1) & DS1511_IRQF) {
+		events = RTC_IRQF;
+		if (rtc_read(RTC_ALARM_SEC) & 0x80)
+			events |= RTC_UF;
+		else
+			events |= RTC_AF;
+		if (likely(pdata->rtc))
+			rtc_update_irq(pdata->rtc, 1, events);
 	}
-	if (rtc_read(RTC_ALARM_SEC) & 0x80) {
-		events |= RTC_UF;
-	} else {
-		events |= RTC_AF;
-	}
-	rtc_update_irq(pdata->rtc, 1, events);
-	return IRQ_HANDLED;
+	spin_unlock(&pdata->lock);
+	return events ? IRQ_HANDLED : IRQ_NONE;
 }
 
- static int
-ds1511_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+static int ds1511_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq <= 0) {
-		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
-	}
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		pdata->irqen &= ~RTC_AF;
-		ds1511_rtc_update_alarm(pdata);
-		break;
-	case RTC_AIE_ON:
+	if (pdata->irq <= 0)
+		return -EINVAL;
+	if (enabled)
 		pdata->irqen |= RTC_AF;
-		ds1511_rtc_update_alarm(pdata);
-		break;
-	case RTC_UIE_OFF:
-		pdata->irqen &= ~RTC_UF;
-		ds1511_rtc_update_alarm(pdata);
-		break;
-	case RTC_UIE_ON:
+	else
+		pdata->irqen &= ~RTC_AF;
+	ds1511_rtc_update_alarm(pdata);
+	return 0;
+}
+
+static int ds1511_rtc_update_irq_enable(struct device *dev,
+	unsigned int enabled)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+
+	if (pdata->irq <= 0)
+		return -EINVAL;
+	if (enabled)
 		pdata->irqen |= RTC_UF;
-		ds1511_rtc_update_alarm(pdata);
-		break;
-	default:
-		return -ENOIOCTLCMD;
-	}
+	else
+		pdata->irqen &= ~RTC_UF;
+	ds1511_rtc_update_alarm(pdata);
 	return 0;
 }
 
 static const struct rtc_class_ops ds1511_rtc_ops = {
-	.read_time	= ds1511_rtc_read_time,
-	.set_time	= ds1511_rtc_set_time,
-	.read_alarm	= ds1511_rtc_read_alarm,
-	.set_alarm	= ds1511_rtc_set_alarm,
-	.ioctl		= ds1511_rtc_ioctl,
+	.read_time		= ds1511_rtc_read_time,
+	.set_time		= ds1511_rtc_set_time,
+	.read_alarm		= ds1511_rtc_read_alarm,
+	.set_alarm		= ds1511_rtc_set_alarm,
+	.alarm_irq_enable	= ds1511_rtc_alarm_irq_enable,
+	.update_irq_enable	= ds1511_rtc_update_irq_enable,
 };
 
  static ssize_t
@@ -492,29 +494,23 @@ ds1511_rtc_probe(struct platform_device 
 {
 	struct rtc_device *rtc;
 	struct resource *res;
-	struct rtc_plat_data *pdata = NULL;
+	struct rtc_plat_data *pdata;
 	int ret = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		return -ENODEV;
 	}
-	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
 		return -ENOMEM;
-	}
 	pdata->size = res->end - res->start + 1;
-	if (!request_mem_region(res->start, pdata->size, pdev->name)) {
-		ret = -EBUSY;
-		goto out;
-	}
-	pdata->baseaddr = res->start;
-	pdata->size = pdata->size;
-	ds1511_base = ioremap(pdata->baseaddr, pdata->size);
-	if (!ds1511_base) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
+			pdev->name))
+		return -EBUSY;
+	ds1511_base = devm_ioremap(&pdev->dev, res->start, pdata->size);
+	if (!ds1511_base)
+		return -ENOMEM;
 	pdata->ioaddr = ds1511_base;
 	pdata->irq = platform_get_irq(pdev, 0);
 
@@ -540,13 +536,15 @@ ds1511_rtc_probe(struct platform_device 
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 	}
 
+	spin_lock_init(&pdata->lock);
+	platform_set_drvdata(pdev, pdata);
 	/*
 	 * if the platform has an interrupt in mind for this device,
 	 * then by all means, set it
 	 */
 	if (pdata->irq > 0) {
 		rtc_read(RTC_CMD1);
-		if (request_irq(pdata->irq, ds1511_interrupt,
+		if (devm_request_irq(&pdev->dev, pdata->irq, ds1511_interrupt,
 			IRQF_DISABLED | IRQF_SHARED, pdev->name, pdev) < 0) {
 
 			dev_warn(&pdev->dev, "interrupt not available.\n");
@@ -556,33 +554,13 @@ ds1511_rtc_probe(struct platform_device 
 
 	rtc = rtc_device_register(pdev->name, &pdev->dev, &ds1511_rtc_ops,
 		THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		goto out;
-	}
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
-	platform_set_drvdata(pdev, pdata);
+
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
-	if (ret) {
-		goto out;
-	}
-	return 0;
- out:
-	if (pdata->rtc) {
+	if (ret)
 		rtc_device_unregister(pdata->rtc);
-	}
-	if (pdata->irq > 0) {
-		free_irq(pdata->irq, pdev);
-	}
-	if (ds1511_base) {
-		iounmap(ds1511_base);
-		ds1511_base = NULL;
-	}
-	if (pdata->baseaddr) {
-		release_mem_region(pdata->baseaddr, pdata->size);
-	}
-
-	kfree(pdata);
 	return ret;
 }
 
@@ -593,19 +571,13 @@ ds1511_rtc_remove(struct platform_device
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	pdata->rtc = NULL;
 	if (pdata->irq > 0) {
 		/*
 		 * disable the alarm interrupt
 		 */
 		rtc_write(rtc_read(RTC_CMD) & ~RTC_TIE, RTC_CMD);
 		rtc_read(RTC_CMD1);
-		free_irq(pdata->irq, pdev);
 	}
-	iounmap(pdata->ioaddr);
-	ds1511_base = NULL;
-	release_mem_region(pdata->baseaddr, pdata->size);
-	kfree(pdata);
 	return 0;
 }
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch

