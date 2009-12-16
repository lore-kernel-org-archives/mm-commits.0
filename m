From: akpm@linux-foundation.org
Subject: [merged] rtc-stk17ta8-fix-races-around-device-registration.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:34:33 -0800
Message-ID: <200912162034.nBGKYXn2013029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763212AbZLPUev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, alessandro.zummo@towertech.it, david-b@pacbell.net, thomas.hommel@gefanuc.com, mm-commits@vger.kernel.org


The patch titled
     rtc-stk17ta8: fix races around device registration
has been removed from the -mm tree.  Its filename was
     rtc-stk17ta8-fix-races-around-device-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-stk17ta8: fix races around device registration
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

- Call dev_set_drvdata before rtc device creation.

- Use its own spinlock instead of rtc->irq_lock.  Because pdata->rtc
  must be initialized to use the irq_lock (pdata->rtc->irq_lock).  There
  is a small window which rtc methods can be called before pdata->rtc is
  initialized.

  And there is no need use the irq_lock to protect hardware registers.
  The driver's own spinlock shoule be enough.

- Check pdata->rtc before calling rtc_update_irq.

- Use alarm_irq_enable and remove ioctl routine.

- Use devres APIs and simplify error/remove path.

These fixes are ported from ds1553 driver and just compile-tested only.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Thomas Hommel <thomas.hommel@gefanuc.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stk17ta8.c |  114 +++++++++++++----------------------
 1 file changed, 45 insertions(+), 69 deletions(-)

diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-stk17ta8-fix-races-around-device-registration drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-stk17ta8-fix-races-around-device-registration
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -62,7 +62,6 @@
 struct rtc_plat_data {
 	struct rtc_device *rtc;
 	void __iomem *ioaddr;
-	unsigned long baseaddr;
 	unsigned long last_jiffies;
 	int irq;
 	unsigned int irqen;
@@ -70,6 +69,7 @@ struct rtc_plat_data {
 	int alrm_min;
 	int alrm_hour;
 	int alrm_mday;
+	spinlock_t lock;
 };
 
 static int stk17ta8_rtc_set_time(struct device *dev, struct rtc_time *tm)
@@ -142,7 +142,7 @@ static void stk17ta8_rtc_update_alarm(st
 	unsigned long irqflags;
 	u8 flags;
 
-	spin_lock_irqsave(&pdata->rtc->irq_lock, irqflags);
+	spin_lock_irqsave(&pdata->lock, irqflags);
 
 	flags = readb(ioaddr + RTC_FLAGS);
 	writeb(flags | RTC_WRITE, ioaddr + RTC_FLAGS);
@@ -162,7 +162,7 @@ static void stk17ta8_rtc_update_alarm(st
 	writeb(pdata->irqen ? RTC_INTS_AIE : 0, ioaddr + RTC_INTERRUPTS);
 	readb(ioaddr + RTC_FLAGS);	/* clear interrupts */
 	writeb(flags & ~RTC_WRITE, ioaddr + RTC_FLAGS);
-	spin_unlock_irqrestore(&pdata->rtc->irq_lock, irqflags);
+	spin_unlock_irqrestore(&pdata->lock, irqflags);
 }
 
 static int stk17ta8_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
@@ -202,48 +202,45 @@ static irqreturn_t stk17ta8_rtc_interrup
 	struct platform_device *pdev = dev_id;
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
-	unsigned long events = RTC_IRQF;
+	unsigned long events = 0;
 
+	spin_lock(&pdata->lock);
 	/* read and clear interrupt */
-	if (!(readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_AF))
-		return IRQ_NONE;
-	if (readb(ioaddr + RTC_SECONDS_ALARM) & 0x80)
-		events |= RTC_UF;
-	else
-		events |= RTC_AF;
-	rtc_update_irq(pdata->rtc, 1, events);
-	return IRQ_HANDLED;
+	if (readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_AF) {
+		events = RTC_IRQF;
+		if (readb(ioaddr + RTC_SECONDS_ALARM) & 0x80)
+			events |= RTC_UF;
+		else
+			events |= RTC_AF;
+		if (likely(pdata->rtc))
+			rtc_update_irq(pdata->rtc, 1, events);
+	}
+	spin_unlock(&pdata->lock);
+	return events ? IRQ_HANDLED : IRQ_NONE;
 }
 
-static int stk17ta8_rtc_ioctl(struct device *dev, unsigned int cmd,
-			    unsigned long arg)
+static int stk17ta8_rtc_alarm_irq_enable(struct device *dev,
+	unsigned int enabled)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	if (pdata->irq <= 0)
-		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		pdata->irqen &= ~RTC_AF;
-		stk17ta8_rtc_update_alarm(pdata);
-		break;
-	case RTC_AIE_ON:
+		return -EINVAL;
+	if (enabled)
 		pdata->irqen |= RTC_AF;
-		stk17ta8_rtc_update_alarm(pdata);
-		break;
-	default:
-		return -ENOIOCTLCMD;
-	}
+	else
+		pdata->irqen &= ~RTC_AF;
+	stk17ta8_rtc_update_alarm(pdata);
 	return 0;
 }
 
 static const struct rtc_class_ops stk17ta8_rtc_ops = {
-	.read_time	= stk17ta8_rtc_read_time,
-	.set_time	= stk17ta8_rtc_set_time,
-	.read_alarm	= stk17ta8_rtc_read_alarm,
-	.set_alarm	= stk17ta8_rtc_set_alarm,
-	.ioctl		= stk17ta8_rtc_ioctl,
+	.read_time		= stk17ta8_rtc_read_time,
+	.set_time		= stk17ta8_rtc_set_time,
+	.read_alarm		= stk17ta8_rtc_read_alarm,
+	.set_alarm		= stk17ta8_rtc_set_alarm,
+	.alarm_irq_enable	= stk17ta8_rtc_alarm_irq_enable,
 };
 
 static ssize_t stk17ta8_nvram_read(struct kobject *kobj,
@@ -292,26 +289,22 @@ static int __devinit stk17ta8_rtc_probe(
 	unsigned int cal;
 	unsigned int flags;
 	struct rtc_plat_data *pdata;
-	void __iomem *ioaddr = NULL;
+	void __iomem *ioaddr;
 	int ret = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
 
-	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	if (!request_mem_region(res->start, RTC_REG_SIZE, pdev->name)) {
-		ret = -EBUSY;
-		goto out;
-	}
-	pdata->baseaddr = res->start;
-	ioaddr = ioremap(pdata->baseaddr, RTC_REG_SIZE);
-	if (!ioaddr) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!devm_request_mem_region(&pdev->dev, res->start, RTC_REG_SIZE,
+			pdev->name))
+		return -EBUSY;
+	ioaddr = devm_ioremap(&pdev->dev, res->start, RTC_REG_SIZE);
+	if (!ioaddr)
+		return -ENOMEM;
 	pdata->ioaddr = ioaddr;
 	pdata->irq = platform_get_irq(pdev, 0);
 
@@ -327,9 +320,13 @@ static int __devinit stk17ta8_rtc_probe(
 	if (readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_PF)
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
+	spin_lock_init(&pdata->lock);
+	pdata->last_jiffies = jiffies;
+	platform_set_drvdata(pdev, pdata);
 	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
-		if (request_irq(pdata->irq, stk17ta8_rtc_interrupt,
+		if (devm_request_irq(&pdev->dev, pdata->irq,
+				stk17ta8_rtc_interrupt,
 				IRQF_DISABLED | IRQF_SHARED,
 				pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
@@ -337,30 +334,14 @@ static int __devinit stk17ta8_rtc_probe(
 		}
 	}
 
-	pdata->last_jiffies = jiffies;
-	platform_set_drvdata(pdev, pdata);
-
 	pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				  &stk17ta8_rtc_ops, THIS_MODULE);
-	if (IS_ERR(pdata->rtc)) {
-		ret = PTR_ERR(pdata->rtc);
-		goto out;
-	}
+	if (IS_ERR(pdata->rtc))
+		return PTR_ERR(pdata->rtc);
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
-	if (ret) {
+	if (ret)
 		rtc_device_unregister(pdata->rtc);
-		goto out;
-	}
-	return 0;
- out:
-	if (pdata->irq > 0)
-		free_irq(pdata->irq, pdev);
-	if (ioaddr)
-		iounmap(ioaddr);
-	if (pdata->baseaddr)
-		release_mem_region(pdata->baseaddr, RTC_REG_SIZE);
-	kfree(pdata);
 	return ret;
 }
 
@@ -370,13 +351,8 @@ static int __devexit stk17ta8_rtc_remove
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	if (pdata->irq > 0) {
+	if (pdata->irq > 0)
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
-		free_irq(pdata->irq, pdev);
-	}
-	iounmap(pdata->ioaddr);
-	release_mem_region(pdata->baseaddr, RTC_REG_SIZE);
-	kfree(pdata);
 	return 0;
 }
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch

