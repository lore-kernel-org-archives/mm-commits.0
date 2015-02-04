From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs.patch
 added to -mm tree
Date: Wed, 04 Feb 2015 14:49:20 -0800
Message-ID: <54d2a1f0.PQOFizHIqWyUKdnA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317AbbBDWtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2015 17:49:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.clement@free-electrons.com, a.zummo@towertech.it, alior@marvell.com, andrew@lunn.ch, arno@natisbad.org, boris.brezillon@free-electrons.com, ezequiel.garcia@free-electrons.com, jason@lakedaemon.net, mark.rutland@arm.com, maxime.ripard@free-electrons.com, nadavh@marvell.com, sebastian.hesselbarth@gmail.com, tawfik@marvell.com, thomas.petazzoni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-armada38x: add a new RTC driver for recent mvebu SoCs
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: drivers/rtc/rtc-armada38x: add a new RTC driver for recent mvebu SoCs

The new mvebu SoCs come with a new RTC driver. This patch adds the
support for this new IP which is currently found in the Armada 38x
SoCs.

This RTC provides two alarms, but only the first one is used in the
driver. The RTC also allows using periodic interrupts.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Reviewed-by: Arnaud Ebalard <arno@natisbad.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lior Amsalem <alior@marvell.com>
Cc: Tawfik Bayouk <tawfik@marvell.com>
Cc: Nadav Haklai <nadavh@marvell.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig         |   10 +
 drivers/rtc/Makefile        |    1 
 drivers/rtc/rtc-armada38x.c |  320 ++++++++++++++++++++++++++++++++++
 3 files changed, 331 insertions(+)

diff -puN drivers/rtc/Kconfig~drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs
+++ a/drivers/rtc/Kconfig
@@ -1280,6 +1280,16 @@ config RTC_DRV_MV
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-mv.
 
+config RTC_DRV_ARMADA38X
+	tristate "Armada 38x Marvell SoC RTC"
+	depends on ARCH_MVEBU
+	help
+	  If you say yes here you will get support for the in-chip RTC
+	  that can be found in the Armada 38x Marvell's SoC device
+
+	  This driver can also be built as a module. If so, the module
+	  will be called armada38x-rtc.
+
 config RTC_DRV_PS3
 	tristate "PS3 RTC"
 	depends on PPC_PS3
diff -puN drivers/rtc/Makefile~drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs
+++ a/drivers/rtc/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_RTC_DRV_88PM80X)	+= rtc-88p
 obj-$(CONFIG_RTC_DRV_AB3100)	+= rtc-ab3100.o
 obj-$(CONFIG_RTC_DRV_AB8500)	+= rtc-ab8500.o
 obj-$(CONFIG_RTC_DRV_ABB5ZES3)	+= rtc-ab-b5ze-s3.o
+obj-$(CONFIG_RTC_DRV_ARMADA38X)	+= rtc-armada38x.o
 obj-$(CONFIG_RTC_DRV_AS3722)	+= rtc-as3722.o
 obj-$(CONFIG_RTC_DRV_AT32AP700X)+= rtc-at32ap700x.o
 obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-at91rm9200.o
diff -puN /dev/null drivers/rtc/rtc-armada38x.c
--- /dev/null
+++ a/drivers/rtc/rtc-armada38x.c
@@ -0,0 +1,320 @@
+/*
+ * RTC driver for the Armada 38x Marvell SoCs
+ *
+ * Copyright (C) 2015 Marvell
+ *
+ * Gregory Clement <gregory.clement@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+
+#define RTC_STATUS	    0x0
+#define RTC_STATUS_ALARM1	    BIT(0)
+#define RTC_STATUS_ALARM2	    BIT(1)
+#define RTC_IRQ1_CONF	    0x4
+#define RTC_IRQ1_AL_EN		    BIT(0)
+#define RTC_IRQ1_FREQ_EN	    BIT(1)
+#define RTC_IRQ1_FREQ_1HZ	    BIT(2)
+#define RTC_TIME	    0xC
+#define RTC_ALARM1	    0x10
+
+#define SOC_RTC_INTERRUPT   0x8
+#define SOC_RTC_ALARM1		BIT(0)
+#define SOC_RTC_ALARM2		BIT(1)
+#define SOC_RTC_ALARM1_MASK	BIT(2)
+#define SOC_RTC_ALARM2_MASK	BIT(3)
+
+struct armada38x_rtc {
+	struct rtc_device   *rtc_dev;
+	void __iomem	    *regs;
+	void __iomem	    *regs_soc;
+	spinlock_t	    lock;
+	int		    irq;
+};
+
+/*
+ * According to the datasheet, the OS should wait 5us after every
+ * register write to the RTC hard macro so that the required update
+ * can occur without holding off the system bus
+ */
+static void rtc_delayed_write(u32 val, struct armada38x_rtc *rtc, int offset)
+{
+	writel(val, rtc->regs + offset);
+	udelay(5);
+}
+
+static int armada38x_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct armada38x_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long time, time_check, flags;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	time = readl(rtc->regs + RTC_TIME);
+	/*
+	 * WA for failing time set attempts. As stated in HW ERRATA if
+	 * more than one second between two time reads is detected
+	 * then read once again.
+	 */
+	time_check = readl(rtc->regs + RTC_TIME);
+	if ((time_check - time) > 1)
+		time_check = readl(rtc->regs + RTC_TIME);
+
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	rtc_time_to_tm(time_check, tm);
+
+	return 0;
+}
+
+static int armada38x_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct armada38x_rtc *rtc = dev_get_drvdata(dev);
+	int ret = 0;
+	unsigned long time, flags;
+
+	ret = rtc_tm_to_time(tm, &time);
+
+	if (ret)
+		goto out;
+	/*
+	 * Setting the RTC time not always succeeds. According to the
+	 * errata we need to first write on the status register and
+	 * then wait for 100ms before writing to the time register to be
+	 * sure that the data will be taken into account.
+	 */
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	rtc_delayed_write(0, rtc, RTC_STATUS);
+
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	msleep(100);
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	rtc_delayed_write(time, rtc, RTC_TIME);
+
+	spin_unlock_irqrestore(&rtc->lock, flags);
+out:
+	return ret;
+}
+
+static int armada38x_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct armada38x_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long time, flags;
+	u32 val;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	time = readl(rtc->regs + RTC_ALARM1);
+	val = readl(rtc->regs + RTC_IRQ1_CONF) & RTC_IRQ1_AL_EN;
+
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	alrm->enabled = val ? 1 : 0;
+	rtc_time_to_tm(time,  &alrm->time);
+
+	return 0;
+}
+
+static int armada38x_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct armada38x_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long time, flags;
+	int ret = 0;
+	u32 val;
+
+	ret = rtc_tm_to_time(&alrm->time, &time);
+
+	if (ret)
+		goto out;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	rtc_delayed_write(time, rtc, RTC_ALARM1);
+
+	if (alrm->enabled) {
+			rtc_delayed_write(RTC_IRQ1_AL_EN, rtc, RTC_IRQ1_CONF);
+			val = readl(rtc->regs_soc + SOC_RTC_INTERRUPT);
+			writel(val | SOC_RTC_ALARM1_MASK,
+			       rtc->regs_soc + SOC_RTC_INTERRUPT);
+	}
+
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+out:
+	return ret;
+}
+
+static int armada38x_rtc_alarm_irq_enable(struct device *dev,
+					 unsigned int enabled)
+{
+	struct armada38x_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	if (enabled)
+		rtc_delayed_write(RTC_IRQ1_AL_EN, rtc, RTC_IRQ1_CONF);
+	else
+		rtc_delayed_write(0, rtc, RTC_IRQ1_CONF);
+
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	return 0;
+}
+
+static irqreturn_t armada38x_rtc_alarm_irq(int irq, void *data)
+{
+	struct armada38x_rtc *rtc = data;
+	u32 val;
+	int event = RTC_IRQF | RTC_AF;
+
+	dev_dbg(&rtc->rtc_dev->dev, "%s:irq(%d)\n", __func__, irq);
+
+	spin_lock(&rtc->lock);
+
+	val = readl(rtc->regs_soc + SOC_RTC_INTERRUPT);
+
+	writel(val & ~SOC_RTC_ALARM1, rtc->regs_soc + SOC_RTC_INTERRUPT);
+	val = readl(rtc->regs + RTC_IRQ1_CONF);
+	/* disable all the interrupts for alarm 1 */
+	rtc_delayed_write(0, rtc, RTC_IRQ1_CONF);
+	/* Ack the event */
+	rtc_delayed_write(RTC_STATUS_ALARM1, rtc, RTC_STATUS);
+
+	spin_unlock(&rtc->lock);
+
+	if (val & RTC_IRQ1_FREQ_EN) {
+		if (val & RTC_IRQ1_FREQ_1HZ)
+			event |= RTC_UF;
+		else
+			event |= RTC_PF;
+	}
+
+	rtc_update_irq(rtc->rtc_dev, 1, event);
+
+	return IRQ_HANDLED;
+}
+
+static struct rtc_class_ops armada38x_rtc_ops = {
+	.read_time = armada38x_rtc_read_time,
+	.set_time = armada38x_rtc_set_time,
+	.read_alarm = armada38x_rtc_read_alarm,
+	.set_alarm = armada38x_rtc_set_alarm,
+	.alarm_irq_enable = armada38x_rtc_alarm_irq_enable,
+};
+
+static __init int armada38x_rtc_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct armada38x_rtc *rtc;
+	int ret;
+
+	rtc = devm_kzalloc(&pdev->dev, sizeof(struct armada38x_rtc),
+			    GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
+	spin_lock_init(&rtc->lock);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rtc");
+	rtc->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rtc->regs))
+		return PTR_ERR(rtc->regs);
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rtc-soc");
+	rtc->regs_soc = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rtc->regs_soc))
+		return PTR_ERR(rtc->regs_soc);
+
+	rtc->irq = platform_get_irq(pdev, 0);
+
+	if (rtc->irq < 0) {
+		dev_err(&pdev->dev, "no irq\n");
+		return rtc->irq;
+	}
+	if (devm_request_irq(&pdev->dev, rtc->irq, armada38x_rtc_alarm_irq,
+				0, pdev->name, rtc) < 0) {
+		dev_warn(&pdev->dev, "Interrupt not available.\n");
+		rtc->irq = -1;
+		/*
+		 * If there is no interrupt available then we can't
+		 * use the alarm
+		 */
+		armada38x_rtc_ops.set_alarm = NULL;
+		armada38x_rtc_ops.alarm_irq_enable = NULL;
+	}
+	platform_set_drvdata(pdev, rtc);
+	if (rtc->irq != -1)
+		device_init_wakeup(&pdev->dev, 1);
+
+	rtc->rtc_dev = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&armada38x_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtc_dev)) {
+		ret = PTR_ERR(rtc->rtc_dev);
+		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int armada38x_rtc_suspend(struct device *dev)
+{
+	if (device_may_wakeup(dev)) {
+		struct armada38x_rtc *rtc = dev_get_drvdata(dev);
+
+		return enable_irq_wake(rtc->irq);
+	}
+
+	return 0;
+}
+
+static int armada38x_rtc_resume(struct device *dev)
+{
+	if (device_may_wakeup(dev)) {
+		struct armada38x_rtc *rtc = dev_get_drvdata(dev);
+
+		return disable_irq_wake(rtc->irq);
+	}
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(armada38x_rtc_pm_ops,
+			 armada38x_rtc_suspend, armada38x_rtc_resume);
+
+#ifdef CONFIG_OF
+static const struct of_device_id armada38x_rtc_of_match_table[] = {
+	{ .compatible = "marvell,armada-380-rtc", },
+	{}
+};
+#endif
+
+static struct platform_driver armada38x_rtc_driver = {
+	.driver		= {
+		.name	= "armada38x-rtc",
+		.pm	= &armada38x_rtc_pm_ops,
+		.of_match_table = of_match_ptr(armada38x_rtc_of_match_table),
+	},
+};
+
+module_platform_driver_probe(armada38x_rtc_driver, armada38x_rtc_probe);
+
+MODULE_DESCRIPTION("Marvell Armada 38x RTC driver");
+MODULE_AUTHOR("Gregory CLEMENT <gregory.clement@free-electrons.com>");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from gregory.clement@free-electrons.com are

rtc-armada38x-add-the-device-tree-binding-documentation.patch
drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs.patch
maintainers-add-the-rtc-driver-for-the-armada38x.patch
arm-mvebu-add-device-tree-description-of-rtc-on-armada-38x.patch
arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig.patch
linux-next.patch

