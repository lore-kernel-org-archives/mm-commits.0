From: akpm@linux-foundation.org
Subject: - driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:36 -0700
Message-ID: <200707172305.l6HN5aJi011936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760557AbXGQXQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hcegtvedt@atmel.com, a.zummo@towertech.it, david-b@pacbell.net, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Driver for the Atmel on-chip RTC on AT32AP700x devices
has been removed from the -mm tree.  Its filename was
     driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Driver for the Atmel on-chip RTC on AT32AP700x devices
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Tested on the AT32AP7000/ATSTK1000.  Driver does only suport time, wake up
and a very simple alarm, because of hardware limitations.

Hardware documentation can be found in the AT32AP7000 data sheet, which can
be downloaded from

http://www.atmel.com/dyn/products/datasheets.asp?family_id=682


 - Strike some alarm setup code that's no longer needed.
   (This patch seems to have gotten lost somewhere...)

 - Make the driver name (and its module alias) match what
   the platform setup code uses, so the driver can bind
   and hotplug.

[akpm@linux-foundation.org: fix several checkpatch.pl warnings]
Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig          |    7 
 drivers/rtc/Makefile         |    1 
 drivers/rtc/rtc-at32ap700x.c |  317 +++++++++++++++++++++++++++++++++
 3 files changed, 325 insertions(+)

diff -puN drivers/rtc/Kconfig~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices
+++ a/drivers/rtc/Kconfig
@@ -379,6 +379,13 @@ config RTC_DRV_PL031
 	  To compile this driver as a module, choose M here: the
 	  module will be called rtc-pl031.
 
+config RTC_DRV_AT32AP700X
+	tristate "AT32AP700X series RTC"
+	depends on RTC_CLASS && PLATFORM_AT32AP
+	help
+	  Driver for the internal RTC (Realtime Clock) on Atmel AVR32
+	  AT32AP700x family processors.
+
 config RTC_DRV_AT91RM9200
 	tristate "AT91RM9200"
 	depends on RTC_CLASS && ARCH_AT91RM9200
diff -puN drivers/rtc/Makefile~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices
+++ a/drivers/rtc/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
 obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
 obj-$(CONFIG_RTC_DRV_TEST)	+= rtc-test.o
+obj-$(CONFIG_RTC_DRV_AT32AP700X)	+= rtc-at32ap700x.o
 obj-$(CONFIG_RTC_DRV_DS1307)	+= rtc-ds1307.o
 obj-$(CONFIG_RTC_DRV_DS1672)	+= rtc-ds1672.o
 obj-$(CONFIG_RTC_DRV_DS1742)	+= rtc-ds1742.o
diff -puN /dev/null drivers/rtc/rtc-at32ap700x.c
--- /dev/null
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -0,0 +1,317 @@
+/*
+ * An RTC driver for the AVR32 AT32AP700x processor series.
+ *
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/io.h>
+
+/*
+ * This is a bare-bones RTC. It runs during most system sleep states, but has
+ * no battery backup and gets reset during system restart.  It must be
+ * initialized from an external clock (network, I2C, etc) before it can be of
+ * much use.
+ *
+ * The alarm functionality is limited by the hardware, not supporting
+ * periodic interrupts.
+ */
+
+#define RTC_CTRL		0x00
+#define RTC_CTRL_EN		   0
+#define RTC_CTRL_PCLR		   1
+#define RTC_CTRL_TOPEN		   2
+#define RTC_CTRL_PSEL		   8
+
+#define RTC_VAL			0x04
+
+#define RTC_TOP			0x08
+
+#define RTC_IER			0x10
+#define RTC_IER_TOPI		   0
+
+#define RTC_IDR			0x14
+#define RTC_IDR_TOPI		   0
+
+#define RTC_IMR			0x18
+#define RTC_IMR_TOPI		   0
+
+#define RTC_ISR			0x1c
+#define RTC_ISR_TOPI		   0
+
+#define RTC_ICR			0x20
+#define RTC_ICR_TOPI		   0
+
+#define RTC_BIT(name)		(1 << RTC_##name)
+#define RTC_BF(name, value)	((value) << RTC_##name)
+
+#define rtc_readl(dev, reg)				\
+	__raw_readl((dev)->regs + RTC_##reg)
+#define rtc_writel(dev, reg, value)			\
+	__raw_writel((value), (dev)->regs + RTC_##reg)
+
+struct rtc_at32ap700x {
+	struct rtc_device	*rtc;
+	void __iomem		*regs;
+	unsigned long		alarm_time;
+	unsigned long		irq;
+	/* Protect against concurrent register access. */
+	spinlock_t		lock;
+};
+
+static int at32_rtc_readtime(struct device *dev, struct rtc_time *tm)
+{
+	struct rtc_at32ap700x *rtc = dev_get_drvdata(dev);
+	unsigned long now;
+
+	now = rtc_readl(rtc, VAL);
+	rtc_time_to_tm(now, tm);
+
+	return 0;
+}
+
+static int at32_rtc_settime(struct device *dev, struct rtc_time *tm)
+{
+	struct rtc_at32ap700x *rtc = dev_get_drvdata(dev);
+	unsigned long now;
+	int ret;
+
+	ret = rtc_tm_to_time(tm, &now);
+	if (ret == 0)
+		rtc_writel(rtc, VAL, now);
+
+	return ret;
+}
+
+static int at32_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rtc_at32ap700x *rtc = dev_get_drvdata(dev);
+
+	rtc_time_to_tm(rtc->alarm_time, &alrm->time);
+	alrm->pending = rtc_readl(rtc, IMR) & RTC_BIT(IMR_TOPI) ? 1 : 0;
+
+	return 0;
+}
+
+static int at32_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rtc_at32ap700x *rtc = dev_get_drvdata(dev);
+	unsigned long rtc_unix_time;
+	unsigned long alarm_unix_time;
+	int ret;
+
+	rtc_unix_time = rtc_readl(rtc, VAL);
+
+	ret = rtc_tm_to_time(&alrm->time, &alarm_unix_time);
+	if (ret)
+		return ret;
+
+	if (alarm_unix_time < rtc_unix_time)
+		return -EINVAL;
+
+	spin_lock_irq(&rtc->lock);
+	rtc->alarm_time = alarm_unix_time;
+	rtc_writel(rtc, TOP, rtc->alarm_time);
+	if (alrm->pending)
+		rtc_writel(rtc, CTRL, rtc_readl(rtc, CTRL)
+				| RTC_BIT(CTRL_TOPEN));
+	else
+		rtc_writel(rtc, CTRL, rtc_readl(rtc, CTRL)
+				& ~RTC_BIT(CTRL_TOPEN));
+	spin_unlock_irq(&rtc->lock);
+
+	return ret;
+}
+
+static int at32_rtc_ioctl(struct device *dev, unsigned int cmd,
+			unsigned long arg)
+{
+	struct rtc_at32ap700x *rtc = dev_get_drvdata(dev);
+	int ret = 0;
+
+	spin_lock_irq(&rtc->lock);
+
+	switch (cmd) {
+	case RTC_AIE_ON:
+		if (rtc_readl(rtc, VAL) > rtc->alarm_time) {
+			ret = -EINVAL;
+			break;
+		}
+		rtc_writel(rtc, CTRL, rtc_readl(rtc, CTRL)
+				| RTC_BIT(CTRL_TOPEN));
+		rtc_writel(rtc, ICR, RTC_BIT(ICR_TOPI));
+		rtc_writel(rtc, IER, RTC_BIT(IER_TOPI));
+		break;
+	case RTC_AIE_OFF:
+		rtc_writel(rtc, CTRL, rtc_readl(rtc, CTRL)
+				& ~RTC_BIT(CTRL_TOPEN));
+		rtc_writel(rtc, IDR, RTC_BIT(IDR_TOPI));
+		rtc_writel(rtc, ICR, RTC_BIT(ICR_TOPI));
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+	spin_unlock_irq(&rtc->lock);
+
+	return ret;
+}
+
+static irqreturn_t at32_rtc_interrupt(int irq, void *dev_id)
+{
+	struct rtc_at32ap700x *rtc = (struct rtc_at32ap700x *)dev_id;
+	unsigned long isr = rtc_readl(rtc, ISR);
+	unsigned long events = 0;
+	int ret = IRQ_NONE;
+
+	spin_lock(&rtc->lock);
+
+	if (isr & RTC_BIT(ISR_TOPI)) {
+		rtc_writel(rtc, ICR, RTC_BIT(ICR_TOPI));
+		rtc_writel(rtc, IDR, RTC_BIT(IDR_TOPI));
+		rtc_writel(rtc, CTRL, rtc_readl(rtc, CTRL)
+				& ~RTC_BIT(CTRL_TOPEN));
+		rtc_writel(rtc, VAL, rtc->alarm_time);
+		events = RTC_AF | RTC_IRQF;
+		rtc_update_irq(rtc->rtc, 1, events);
+		ret = IRQ_HANDLED;
+	}
+
+	spin_unlock(&rtc->lock);
+
+	return ret;
+}
+
+static struct rtc_class_ops at32_rtc_ops = {
+	.ioctl		= at32_rtc_ioctl,
+	.read_time	= at32_rtc_readtime,
+	.set_time	= at32_rtc_settime,
+	.read_alarm	= at32_rtc_readalarm,
+	.set_alarm	= at32_rtc_setalarm,
+};
+
+static int __init at32_rtc_probe(struct platform_device *pdev)
+{
+	struct resource	*regs;
+	struct rtc_at32ap700x *rtc;
+	int irq = -1;
+	int ret;
+
+	rtc = kzalloc(sizeof(struct rtc_at32ap700x), GFP_KERNEL);
+	if (!rtc) {
+		dev_dbg(&pdev->dev, "out of memory\n");
+		return -ENOMEM;
+	}
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_dbg(&pdev->dev, "no mmio resource defined\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_dbg(&pdev->dev, "could not get irq\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	ret = request_irq(irq, at32_rtc_interrupt, IRQF_SHARED, "rtc", rtc);
+	if (ret) {
+		dev_dbg(&pdev->dev, "could not request irq %d\n", irq);
+		goto out;
+	}
+
+	rtc->irq = irq;
+	rtc->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	if (!rtc->regs) {
+		ret = -ENOMEM;
+		dev_dbg(&pdev->dev, "could not map I/O memory\n");
+		goto out_free_irq;
+	}
+	spin_lock_init(&rtc->lock);
+
+	/*
+	 * Maybe init RTC: count from zero at 1 Hz, disable wrap irq.
+	 *
+	 * Do not reset VAL register, as it can hold an old time
+	 * from last JTAG reset.
+	 */
+	if (!(rtc_readl(rtc, CTRL) & RTC_BIT(CTRL_EN))) {
+		rtc_writel(rtc, CTRL, RTC_BIT(CTRL_PCLR));
+		rtc_writel(rtc, IDR, RTC_BIT(IDR_TOPI));
+		rtc_writel(rtc, CTRL, RTC_BF(CTRL_PSEL, 0xe)
+				| RTC_BIT(CTRL_EN));
+	}
+
+	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+				&at32_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtc)) {
+		dev_dbg(&pdev->dev, "could not register rtc device\n");
+		ret = PTR_ERR(rtc->rtc);
+		goto out_iounmap;
+	}
+
+	platform_set_drvdata(pdev, rtc);
+
+	dev_info(&pdev->dev, "Atmel RTC for AT32AP700x at %08lx irq %ld\n",
+			(unsigned long)rtc->regs, rtc->irq);
+
+	return 0;
+
+out_iounmap:
+	iounmap(rtc->regs);
+out_free_irq:
+	free_irq(irq, rtc);
+out:
+	kfree(rtc);
+	return ret;
+}
+
+static int __exit at32_rtc_remove(struct platform_device *pdev)
+{
+	struct rtc_at32ap700x *rtc = platform_get_drvdata(pdev);
+
+	free_irq(rtc->irq, rtc);
+	iounmap(rtc->regs);
+	rtc_device_unregister(rtc->rtc);
+	kfree(rtc);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+MODULE_ALIAS("at32ap700x_rtc");
+
+static struct platform_driver at32_rtc_driver = {
+	.remove		= __exit_p(at32_rtc_remove),
+	.driver		= {
+		.name	= "at32ap700x_rtc",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init at32_rtc_init(void)
+{
+	return platform_driver_probe(&at32_rtc_driver, at32_rtc_probe);
+}
+module_init(at32_rtc_init);
+
+static void __exit at32_rtc_exit(void)
+{
+	platform_driver_unregister(&at32_rtc_driver);
+}
+module_exit(at32_rtc_exit);
+
+MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_DESCRIPTION("Real time clock for AVR32 AT32AP700x");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

origin.patch
git-watchdog.patch
