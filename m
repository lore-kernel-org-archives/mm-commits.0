From: akpm@linux-foundation.org
Subject: - rtc-add-support-for-the-st-m48t59-rtc.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:48 -0700
Message-ID: <200707172305.l6HN5mSH011955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933401AbXGQXPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rongkai.zhan@windriver.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc: add support for the ST M48T59 RTC
has been removed from the -mm tree.  Its filename was
     rtc-add-support-for-the-st-m48t59-rtc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: add support for the ST M48T59 RTC
From: Mark Zhan <rongkai.zhan@windriver.com>

[akpm@linux-foundation.org: x86_64 build fix]
[akpm@linux-foundation.org: The acpi guys changed the bin_attribute code]
Signed-off-by: Mark Zhan <rongkai.zhan@windriver.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig        |   10 
 drivers/rtc/Makefile       |    1 
 drivers/rtc/rtc-m48t59.c   |  491 +++++++++++++++++++++++++++++++++++
 include/linux/rtc/m48t59.h |   57 ++++
 4 files changed, 559 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-support-for-the-st-m48t59-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-support-for-the-st-m48t59-rtc
+++ a/drivers/rtc/Kconfig
@@ -310,6 +310,16 @@ config RTC_DRV_M48T86
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-m48t86.
 
+config RTC_DRV_M48T59
+	tristate "ST M48T59"
+	depends on RTC_CLASS
+	help
+	  If you say Y here you will get support for the
+	  ST M48T59 RTC chip.
+
+	  This driver can also be built as a module, if so, the module
+	  will be called "rtc-m48t59".
+
 config RTC_DRV_V3020
 	tristate "EM Microelectronic V3020"
 	depends on RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-add-support-for-the-st-m48t59-rtc drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-support-for-the-st-m48t59-rtc
+++ a/drivers/rtc/Makefile
@@ -43,3 +43,4 @@ obj-$(CONFIG_RTC_DRV_V3020)	+= rtc-v3020
 obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-at91rm9200.o
 obj-$(CONFIG_RTC_DRV_SH)	+= rtc-sh.o
 obj-$(CONFIG_RTC_DRV_BFIN)	+= rtc-bfin.o
+obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t59.o
diff -puN /dev/null drivers/rtc/rtc-m48t59.c
--- /dev/null
+++ a/drivers/rtc/rtc-m48t59.c
@@ -0,0 +1,491 @@
+/*
+ * ST M48T59 RTC driver
+ *
+ * Copyright (c) 2007 Wind River Systems, Inc.
+ *
+ * Author: Mark Zhan <rongkai.zhan@windriver.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/rtc/m48t59.h>
+#include <linux/bcd.h>
+
+#ifndef NO_IRQ
+#define NO_IRQ	(-1)
+#endif
+
+#define M48T59_READ(reg)	pdata->read_byte(dev, reg)
+#define M48T59_WRITE(val, reg)	pdata->write_byte(dev, reg, val)
+
+#define M48T59_SET_BITS(mask, reg)	\
+	M48T59_WRITE((M48T59_READ(reg) | (mask)), (reg))
+#define M48T59_CLEAR_BITS(mask, reg)	\
+	M48T59_WRITE((M48T59_READ(reg) & ~(mask)), (reg))
+
+struct m48t59_private {
+	void __iomem *ioaddr;
+	unsigned int size; /* iomem size */
+	unsigned int irq;
+	struct rtc_device *rtc;
+	spinlock_t lock; /* serialize the NVRAM and RTC access */
+};
+
+/*
+ * This is the generic access method when the chip is memory-mapped
+ */
+static void
+m48t59_mem_writeb(struct device *dev, u32 ofs, u8 val)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+
+	writeb(val, m48t59->ioaddr+ofs);
+}
+
+static u8
+m48t59_mem_readb(struct device *dev, u32 ofs)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+
+	return readb(m48t59->ioaddr+ofs);
+}
+
+/*
+ * NOTE: M48T59 only uses BCD mode
+ */
+static int m48t59_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&m48t59->lock, flags);
+	/* Issue the READ command */
+	M48T59_SET_BITS(M48T59_CNTL_READ, M48T59_CNTL);
+
+	tm->tm_year	= BCD2BIN(M48T59_READ(M48T59_YEAR));
+	/* tm_mon is 0-11 */
+	tm->tm_mon	= BCD2BIN(M48T59_READ(M48T59_MONTH)) - 1;
+	tm->tm_mday	= BCD2BIN(M48T59_READ(M48T59_MDAY));
+
+	val = M48T59_READ(M48T59_WDAY);
+	if ((val & M48T59_WDAY_CEB) && (val & M48T59_WDAY_CB)) {
+		dev_dbg(dev, "Century bit is enabled\n");
+		tm->tm_year += 100;	/* one century */
+	}
+
+	tm->tm_wday	= BCD2BIN(val & 0x07);
+	tm->tm_hour	= BCD2BIN(M48T59_READ(M48T59_HOUR) & 0x3F);
+	tm->tm_min	= BCD2BIN(M48T59_READ(M48T59_MIN) & 0x7F);
+	tm->tm_sec	= BCD2BIN(M48T59_READ(M48T59_SEC) & 0x7F);
+
+	/* Clear the READ bit */
+	M48T59_CLEAR_BITS(M48T59_CNTL_READ, M48T59_CNTL);
+	spin_unlock_irqrestore(&m48t59->lock, flags);
+
+	dev_dbg(dev, "RTC read time %04d-%02d-%02d %02d/%02d/%02d\n",
+		tm->tm_year + 1900, tm->tm_mon, tm->tm_mday,
+		tm->tm_hour, tm->tm_min, tm->tm_sec);
+	return 0;
+}
+
+static int m48t59_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+	unsigned long flags;
+	u8 val = 0;
+
+	dev_dbg(dev, "RTC set time %04d-%02d-%02d %02d/%02d/%02d\n",
+		tm->tm_year + 1900, tm->tm_mon, tm->tm_mday,
+		tm->tm_hour, tm->tm_min, tm->tm_sec);
+
+	spin_lock_irqsave(&m48t59->lock, flags);
+	/* Issue the WRITE command */
+	M48T59_SET_BITS(M48T59_CNTL_WRITE, M48T59_CNTL);
+
+	M48T59_WRITE((BIN2BCD(tm->tm_sec) & 0x7F), M48T59_SEC);
+	M48T59_WRITE((BIN2BCD(tm->tm_min) & 0x7F), M48T59_MIN);
+	M48T59_WRITE((BIN2BCD(tm->tm_hour) & 0x3F), M48T59_HOUR);
+	M48T59_WRITE((BIN2BCD(tm->tm_mday) & 0x3F), M48T59_MDAY);
+	/* tm_mon is 0-11 */
+	M48T59_WRITE((BIN2BCD(tm->tm_mon + 1) & 0x1F), M48T59_MONTH);
+	M48T59_WRITE(BIN2BCD(tm->tm_year % 100), M48T59_YEAR);
+
+	if (tm->tm_year/100)
+		val = (M48T59_WDAY_CEB | M48T59_WDAY_CB);
+	val |= (BIN2BCD(tm->tm_wday) & 0x07);
+	M48T59_WRITE(val, M48T59_WDAY);
+
+	/* Clear the WRITE bit */
+	M48T59_CLEAR_BITS(M48T59_CNTL_WRITE, M48T59_CNTL);
+	spin_unlock_irqrestore(&m48t59->lock, flags);
+	return 0;
+}
+
+/*
+ * Read alarm time and date in RTC
+ */
+static int m48t59_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+	struct rtc_time *tm = &alrm->time;
+	unsigned long flags;
+	u8 val;
+
+	/* If no irq, we don't support ALARM */
+	if (m48t59->irq == NO_IRQ)
+		return -EIO;
+
+	spin_lock_irqsave(&m48t59->lock, flags);
+	/* Issue the READ command */
+	M48T59_SET_BITS(M48T59_CNTL_READ, M48T59_CNTL);
+
+	tm->tm_year = BCD2BIN(M48T59_READ(M48T59_YEAR));
+	/* tm_mon is 0-11 */
+	tm->tm_mon = BCD2BIN(M48T59_READ(M48T59_MONTH)) - 1;
+
+	val = M48T59_READ(M48T59_WDAY);
+	if ((val & M48T59_WDAY_CEB) && (val & M48T59_WDAY_CB))
+		tm->tm_year += 100;	/* one century */
+
+	tm->tm_mday = BCD2BIN(M48T59_READ(M48T59_ALARM_DATE));
+	tm->tm_hour = BCD2BIN(M48T59_READ(M48T59_ALARM_HOUR));
+	tm->tm_min = BCD2BIN(M48T59_READ(M48T59_ALARM_MIN));
+	tm->tm_sec = BCD2BIN(M48T59_READ(M48T59_ALARM_SEC));
+
+	/* Clear the READ bit */
+	M48T59_CLEAR_BITS(M48T59_CNTL_READ, M48T59_CNTL);
+	spin_unlock_irqrestore(&m48t59->lock, flags);
+
+	dev_dbg(dev, "RTC read alarm time %04d-%02d-%02d %02d/%02d/%02d\n",
+		tm->tm_year + 1900, tm->tm_mon, tm->tm_mday,
+		tm->tm_hour, tm->tm_min, tm->tm_sec);
+	return 0;
+}
+
+/*
+ * Set alarm time and date in RTC
+ */
+static int m48t59_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+	struct rtc_time *tm = &alrm->time;
+	u8 mday, hour, min, sec;
+	unsigned long flags;
+
+	/* If no irq, we don't support ALARM */
+	if (m48t59->irq == NO_IRQ)
+		return -EIO;
+
+	/*
+	 * 0xff means "always match"
+	 */
+	mday = tm->tm_mday;
+	mday = (mday >= 1 && mday <= 31) ? BIN2BCD(mday) : 0xff;
+	if (mday == 0xff)
+		mday = M48T59_READ(M48T59_MDAY);
+
+	hour = tm->tm_hour;
+	hour = (hour < 24) ? BIN2BCD(hour) : 0x00;
+
+	min = tm->tm_min;
+	min = (min < 60) ? BIN2BCD(min) : 0x00;
+
+	sec = tm->tm_sec;
+	sec = (sec < 60) ? BIN2BCD(sec) : 0x00;
+
+	spin_lock_irqsave(&m48t59->lock, flags);
+	/* Issue the WRITE command */
+	M48T59_SET_BITS(M48T59_CNTL_WRITE, M48T59_CNTL);
+
+	M48T59_WRITE(mday, M48T59_ALARM_DATE);
+	M48T59_WRITE(hour, M48T59_ALARM_HOUR);
+	M48T59_WRITE(min, M48T59_ALARM_MIN);
+	M48T59_WRITE(sec, M48T59_ALARM_SEC);
+
+	/* Clear the WRITE bit */
+	M48T59_CLEAR_BITS(M48T59_CNTL_WRITE, M48T59_CNTL);
+	spin_unlock_irqrestore(&m48t59->lock, flags);
+
+	dev_dbg(dev, "RTC set alarm time %04d-%02d-%02d %02d/%02d/%02d\n",
+		tm->tm_year + 1900, tm->tm_mon, tm->tm_mday,
+		tm->tm_hour, tm->tm_min, tm->tm_sec);
+	return 0;
+}
+
+/*
+ * Handle commands from user-space
+ */
+static int m48t59_rtc_ioctl(struct device *dev, unsigned int cmd,
+			unsigned long arg)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&m48t59->lock, flags);
+	switch (cmd) {
+	case RTC_AIE_OFF:	/* alarm interrupt off */
+		M48T59_WRITE(0x00, M48T59_INTR);
+		break;
+	case RTC_AIE_ON:	/* alarm interrupt on */
+		M48T59_WRITE(M48T59_INTR_AFE, M48T59_INTR);
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+	spin_unlock_irqrestore(&m48t59->lock, flags);
+
+	return ret;
+}
+
+static int m48t59_rtc_proc(struct device *dev, struct seq_file *seq)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&m48t59->lock, flags);
+	val = M48T59_READ(M48T59_FLAGS);
+	spin_unlock_irqrestore(&m48t59->lock, flags);
+
+	seq_printf(seq, "battery\t\t: %s\n",
+		 (val & M48T59_FLAGS_BF) ? "low" : "normal");
+	return 0;
+}
+
+/*
+ * IRQ handler for the RTC
+ */
+static irqreturn_t m48t59_rtc_interrupt(int irq, void *dev_id)
+{
+	struct device *dev = (struct device *)dev_id;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+	u8 event;
+
+	spin_lock(&m48t59->lock);
+	event = M48T59_READ(M48T59_FLAGS);
+	spin_unlock(&m48t59->lock);
+
+	if (event & M48T59_FLAGS_AF) {
+		rtc_update_irq(m48t59->rtc, 1, (RTC_AF | RTC_IRQF));
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static const struct rtc_class_ops m48t59_rtc_ops = {
+	.ioctl		= m48t59_rtc_ioctl,
+	.read_time	= m48t59_rtc_read_time,
+	.set_time	= m48t59_rtc_set_time,
+	.read_alarm	= m48t59_rtc_readalarm,
+	.set_alarm	= m48t59_rtc_setalarm,
+	.proc		= m48t59_rtc_proc,
+};
+
+static ssize_t m48t59_nvram_read(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t pos, size_t size)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+	ssize_t cnt = 0;
+	unsigned long flags;
+
+	for (; size > 0 && pos < M48T59_NVRAM_SIZE; cnt++, size--) {
+		spin_lock_irqsave(&m48t59->lock, flags);
+		*buf++ = M48T59_READ(cnt);
+		spin_unlock_irqrestore(&m48t59->lock, flags);
+	}
+
+	return cnt;
+}
+
+static ssize_t m48t59_nvram_write(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t pos, size_t size)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+	ssize_t cnt = 0;
+	unsigned long flags;
+
+	for (; size > 0 && pos < M48T59_NVRAM_SIZE; cnt++, size--) {
+		spin_lock_irqsave(&m48t59->lock, flags);
+		M48T59_WRITE(*buf++, cnt);
+		spin_unlock_irqrestore(&m48t59->lock, flags);
+	}
+
+	return cnt;
+}
+
+static struct bin_attribute m48t59_nvram_attr = {
+	.attr = {
+		.name = "nvram",
+		.mode = S_IRUGO | S_IWUGO,
+		.owner = THIS_MODULE,
+	},
+	.read = m48t59_nvram_read,
+	.write = m48t59_nvram_write,
+};
+
+static int __devinit m48t59_rtc_probe(struct platform_device *pdev)
+{
+	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_private *m48t59 = NULL;
+	struct resource *res;
+	int ret = -ENOMEM;
+
+	/* This chip could be memory-mapped or I/O-mapped */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+		if (!res)
+			return -EINVAL;
+	}
+
+	if (res->flags & IORESOURCE_IO) {
+		/* If we are I/O-mapped, the platform should provide
+		 * the operations accessing chip registers.
+		 */
+		if (!pdata || !pdata->write_byte || !pdata->read_byte)
+			return -EINVAL;
+	} else if (res->flags & IORESOURCE_MEM) {
+		/* we are memory-mapped */
+		if (!pdata) {
+			pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+			if (!pdata)
+				return -ENOMEM;
+			/* Ensure we only kmalloc platform data once */
+			pdev->dev.platform_data = pdata;
+		}
+
+		/* Try to use the generic memory read/write ops */
+		if (!pdata->write_byte)
+			pdata->write_byte = m48t59_mem_writeb;
+		if (!pdata->read_byte)
+			pdata->read_byte = m48t59_mem_readb;
+	}
+
+	m48t59 = kzalloc(sizeof(*m48t59), GFP_KERNEL);
+	if (!m48t59)
+		return -ENOMEM;
+
+	m48t59->size = res->end - res->start + 1;
+	m48t59->ioaddr = ioremap(res->start, m48t59->size);
+	if (!m48t59->ioaddr)
+		goto out;
+
+	/* Try to get irq number. We also can work in
+	 * the mode without IRQ.
+	 */
+	m48t59->irq = platform_get_irq(pdev, 0);
+	if (m48t59->irq < 0)
+		m48t59->irq = NO_IRQ;
+
+	if (m48t59->irq != NO_IRQ) {
+		ret = request_irq(m48t59->irq, m48t59_rtc_interrupt,
+			IRQF_SHARED, "rtc-m48t59", &pdev->dev);
+		if (ret)
+			goto out;
+	}
+
+	m48t59->rtc = rtc_device_register("m48t59", &pdev->dev,
+				&m48t59_rtc_ops, THIS_MODULE);
+	if (IS_ERR(m48t59->rtc)) {
+		ret = PTR_ERR(m48t59->rtc);
+		goto out;
+	}
+
+	ret = sysfs_create_bin_file(&pdev->dev.kobj, &m48t59_nvram_attr);
+	if (ret)
+		goto out;
+
+	spin_lock_init(&m48t59->lock);
+	platform_set_drvdata(pdev, m48t59);
+	return 0;
+
+out:
+	if (!IS_ERR(m48t59->rtc))
+		rtc_device_unregister(m48t59->rtc);
+	if (m48t59->irq != NO_IRQ)
+		free_irq(m48t59->irq, &pdev->dev);
+	if (m48t59->ioaddr)
+		iounmap(m48t59->ioaddr);
+	if (m48t59)
+		kfree(m48t59);
+	return ret;
+}
+
+static int __devexit m48t59_rtc_remove(struct platform_device *pdev)
+{
+	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
+
+	sysfs_remove_bin_file(&pdev->dev.kobj, &m48t59_nvram_attr);
+	if (!IS_ERR(m48t59->rtc))
+		rtc_device_unregister(m48t59->rtc);
+	if (m48t59->ioaddr)
+		iounmap(m48t59->ioaddr);
+	if (m48t59->irq != NO_IRQ)
+		free_irq(m48t59->irq, &pdev->dev);
+	platform_set_drvdata(pdev, NULL);
+	kfree(m48t59);
+	return 0;
+}
+
+static struct platform_driver m48t59_rtc_platdrv = {
+	.driver		= {
+		.name	= "rtc-m48t59",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= m48t59_rtc_probe,
+	.remove		= __devexit_p(m48t59_rtc_remove),
+};
+
+static int __init m48t59_rtc_init(void)
+{
+	return platform_driver_register(&m48t59_rtc_platdrv);
+}
+
+static void __exit m48t59_rtc_exit(void)
+{
+	platform_driver_unregister(&m48t59_rtc_platdrv);
+}
+
+module_init(m48t59_rtc_init);
+module_exit(m48t59_rtc_exit);
+
+MODULE_AUTHOR("Mark Zhan <rongkai.zhan@windriver.com>");
+MODULE_DESCRIPTION("M48T59 RTC driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/rtc/m48t59.h
--- /dev/null
+++ a/include/linux/rtc/m48t59.h
@@ -0,0 +1,57 @@
+/*
+ * include/linux/rtc/m48t59.h
+ *
+ * Definitions for the platform data of m48t59 RTC chip driver.
+ *
+ * Copyright (c) 2007 Wind River Systems, Inc.
+ *
+ * Mark Zhan <rongkai.zhan@windriver.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_RTC_M48T59_H_
+#define _LINUX_RTC_M48T59_H_
+
+/*
+ * M48T59 Register Offset
+ */
+#define M48T59_YEAR		0x1fff
+#define M48T59_MONTH		0x1ffe
+#define M48T59_MDAY		0x1ffd	/* Day of Month */
+#define M48T59_WDAY		0x1ffc	/* Day of Week */
+#define M48T59_WDAY_CB			0x20	/* Century Bit */
+#define M48T59_WDAY_CEB			0x10	/* Century Enable Bit */
+#define M48T59_HOUR		0x1ffb
+#define M48T59_MIN		0x1ffa
+#define M48T59_SEC		0x1ff9
+#define M48T59_CNTL		0x1ff8
+#define M48T59_CNTL_READ		0x40
+#define M48T59_CNTL_WRITE		0x80
+#define M48T59_WATCHDOG		0x1ff7
+#define M48T59_INTR		0x1ff6
+#define M48T59_INTR_AFE			0x80	/* Alarm Interrupt Enable */
+#define M48T59_INTR_ABE			0x20
+#define M48T59_ALARM_DATE	0x1ff5
+#define M48T59_ALARM_HOUR	0x1ff4
+#define M48T59_ALARM_MIN	0x1ff3
+#define M48T59_ALARM_SEC	0x1ff2
+#define M48T59_UNUSED		0x1ff1
+#define M48T59_FLAGS		0x1ff0
+#define M48T59_FLAGS_WDT		0x80	/* watchdog timer expired */
+#define M48T59_FLAGS_AF			0x40	/* alarm */
+#define M48T59_FLAGS_BF			0x10	/* low battery */
+
+#define M48T59_NVRAM_SIZE	0x1ff0
+
+struct m48t59_plat_data {
+	/* The method to access M48T59 registers,
+	 * NOTE: The 'ofs' should be 0x00~0x1fff
+	 */
+	void (*write_byte)(struct device *dev, u32 ofs, u8 val);
+	unsigned char (*read_byte)(struct device *dev, u32 ofs);
+};
+
+#endif /* _LINUX_RTC_M48T59_H_ */
_

Patches currently in -mm which might be from rongkai.zhan@windriver.com are

origin.patch
