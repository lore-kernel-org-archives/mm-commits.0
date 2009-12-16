From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1553-fix-races-around-device-registration.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:34:27 -0800
Message-ID: <200912162034.nBGKYR3A013023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763210AbZLPUen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1553: fix races around device registration
has been removed from the -mm tree.  Its filename was
     rtc-ds1553-fix-races-around-device-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-ds1553: fix races around device registration
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

* Call dev_set_drvdata before rtc device creation
* Use its own spinlock instead of rtc->irq_lock
* Check pdata->rtc before calling rtc_update_irq
* Use {alarm,update}_irq_enable and remove ioctl routine
* Use devres APIs and simplify error/remove path

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1553.c |  141 ++++++++++++++++---------------------
 1 file changed, 64 insertions(+), 77 deletions(-)

diff -puN drivers/rtc/rtc-ds1553.c~rtc-ds1553-fix-races-around-device-registration drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-ds1553-fix-races-around-device-registration
+++ a/drivers/rtc/rtc-ds1553.c
@@ -18,7 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
-#define DRV_VERSION "0.2"
+#define DRV_VERSION "0.3"
 
 #define RTC_REG_SIZE		0x2000
 #define RTC_OFFSET		0x1ff0
@@ -61,7 +61,6 @@
 struct rtc_plat_data {
 	struct rtc_device *rtc;
 	void __iomem *ioaddr;
-	resource_size_t baseaddr;
 	unsigned long last_jiffies;
 	int irq;
 	unsigned int irqen;
@@ -69,6 +68,7 @@ struct rtc_plat_data {
 	int alrm_min;
 	int alrm_hour;
 	int alrm_mday;
+	spinlock_t lock;
 };
 
 static int ds1553_rtc_set_time(struct device *dev, struct rtc_time *tm)
@@ -139,7 +139,7 @@ static void ds1553_rtc_update_alarm(stru
 	void __iomem *ioaddr = pdata->ioaddr;
 	unsigned long flags;
 
-	spin_lock_irqsave(&pdata->rtc->irq_lock, flags);
+	spin_lock_irqsave(&pdata->lock, flags);
 	writeb(pdata->alrm_mday < 0 || (pdata->irqen & RTC_UF) ?
 	       0x80 : bin2bcd(pdata->alrm_mday),
 	       ioaddr + RTC_DATE_ALARM);
@@ -154,7 +154,7 @@ static void ds1553_rtc_update_alarm(stru
 	       ioaddr + RTC_SECONDS_ALARM);
 	writeb(pdata->irqen ? RTC_INTS_AE : 0, ioaddr + RTC_INTERRUPTS);
 	readb(ioaddr + RTC_FLAGS);	/* clear interrupts */
-	spin_unlock_irqrestore(&pdata->rtc->irq_lock, flags);
+	spin_unlock_irqrestore(&pdata->lock, flags);
 }
 
 static int ds1553_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
@@ -194,56 +194,61 @@ static irqreturn_t ds1553_rtc_interrupt(
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
 
-static int ds1553_rtc_ioctl(struct device *dev, unsigned int cmd,
-			    unsigned long arg)
+static int ds1553_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	if (pdata->irq <= 0)
-		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		pdata->irqen &= ~RTC_AF;
-		ds1553_rtc_update_alarm(pdata);
-		break;
-	case RTC_AIE_ON:
+		return -EINVAL;
+	if (enabled)
 		pdata->irqen |= RTC_AF;
-		ds1553_rtc_update_alarm(pdata);
-		break;
-	case RTC_UIE_OFF:
-		pdata->irqen &= ~RTC_UF;
-		ds1553_rtc_update_alarm(pdata);
-		break;
-	case RTC_UIE_ON:
+	else
+		pdata->irqen &= ~RTC_AF;
+	ds1553_rtc_update_alarm(pdata);
+	return 0;
+}
+
+static int ds1553_rtc_update_irq_enable(struct device *dev,
+	unsigned int enabled)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+
+	if (pdata->irq <= 0)
+		return -EINVAL;
+	if (enabled)
 		pdata->irqen |= RTC_UF;
-		ds1553_rtc_update_alarm(pdata);
-		break;
-	default:
-		return -ENOIOCTLCMD;
-	}
+	else
+		pdata->irqen &= ~RTC_UF;
+	ds1553_rtc_update_alarm(pdata);
 	return 0;
 }
 
 static const struct rtc_class_ops ds1553_rtc_ops = {
-	.read_time	= ds1553_rtc_read_time,
-	.set_time	= ds1553_rtc_set_time,
-	.read_alarm	= ds1553_rtc_read_alarm,
-	.set_alarm	= ds1553_rtc_set_alarm,
-	.ioctl		= ds1553_rtc_ioctl,
+	.read_time		= ds1553_rtc_read_time,
+	.set_time		= ds1553_rtc_set_time,
+	.read_alarm		= ds1553_rtc_read_alarm,
+	.set_alarm		= ds1553_rtc_set_alarm,
+	.alarm_irq_enable	= ds1553_rtc_alarm_irq_enable,
+	.update_irq_enable	= ds1553_rtc_update_irq_enable,
 };
 
 static ssize_t ds1553_nvram_read(struct kobject *kobj,
@@ -291,26 +296,23 @@ static int __devinit ds1553_rtc_probe(st
 	struct rtc_device *rtc;
 	struct resource *res;
 	unsigned int cen, sec;
-	struct rtc_plat_data *pdata = NULL;
-	void __iomem *ioaddr = NULL;
+	struct rtc_plat_data *pdata;
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
+
+	ioaddr = devm_ioremap(&pdev->dev, res->start, RTC_REG_SIZE);
+	if (!ioaddr)
+		return -ENOMEM;
 	pdata->ioaddr = ioaddr;
 	pdata->irq = platform_get_irq(pdev, 0);
 
@@ -326,9 +328,13 @@ static int __devinit ds1553_rtc_probe(st
 	if (readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_BLF)
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
+	spin_lock_init(&pdata->lock);
+	pdata->last_jiffies = jiffies;
+	platform_set_drvdata(pdev, pdata);
 	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
-		if (request_irq(pdata->irq, ds1553_rtc_interrupt,
+		if (devm_request_irq(&pdev->dev, pdata->irq,
+				ds1553_rtc_interrupt,
 				IRQF_DISABLED, pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
 			pdata->irq = 0;
@@ -337,27 +343,13 @@ static int __devinit ds1553_rtc_probe(st
 
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				  &ds1553_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		goto out;
-	}
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
-	pdata->last_jiffies = jiffies;
-	platform_set_drvdata(pdev, pdata);
+
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
 	if (ret)
-		goto out;
-	return 0;
- out:
-	if (pdata->rtc)
-		rtc_device_unregister(pdata->rtc);
-	if (pdata->irq > 0)
-		free_irq(pdata->irq, pdev);
-	if (ioaddr)
-		iounmap(ioaddr);
-	if (pdata->baseaddr)
-		release_mem_region(pdata->baseaddr, RTC_REG_SIZE);
-	kfree(pdata);
+		rtc_device_unregister(rtc);
 	return ret;
 }
 
@@ -367,13 +359,8 @@ static int __devexit ds1553_rtc_remove(s
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
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

