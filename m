From: akpm@linux-foundation.org
Subject: + rtc-add-freescale-stmp37xx-378x-driver.patch added to -mm tree
Date: Fri, 26 Jun 2009 16:03:09 -0700
Message-ID: <200906262303.n5QN39il023609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbZFZXDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 19:03:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dpervushin@embeddedalley.com, a.zummo@towertech.it


The patch titled
     rtc: add Freescale stmp37xx/378x driver
has been added to the -mm tree.  Its filename is
     rtc-add-freescale-stmp37xx-378x-driver.patch

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
Subject: rtc: add Freescale stmp37xx/378x driver
From: dmitry pervushin <dpervushin@embeddedalley.com>

Add support for RTC on the Freescale STMP37xx/378x platform.

Signed-off-by: dmitry pervushin <dpervushin@embeddedalley.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig        |   10 +
 drivers/rtc/Makefile       |    1 
 drivers/rtc/rtc-stmp3xxx.c |  304 +++++++++++++++++++++++++++++++++++
 3 files changed, 315 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-freescale-stmp37xx-378x-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-freescale-stmp37xx-378x-driver
+++ a/drivers/rtc/Kconfig
@@ -801,4 +801,14 @@ config RTC_DRV_COH901331
 	  will be called "rtc-coh901331".
 
 
+config RTC_DRV_STMP
+	tristate "Freescale STMP3xxx RTC"
+	depends on ARCH_STMP3XXX
+	help
+	  If you say yes here you will get support for the onboard
+	  STMP3xxx RTC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-stmp3xxx.
+
 endif # RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-add-freescale-stmp37xx-378x-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-freescale-stmp37xx-378x-driver
+++ a/drivers/rtc/Makefile
@@ -82,3 +82,4 @@ obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205
 obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pcf50633.o
 obj-$(CONFIG_RTC_DRV_PS3)	+= rtc-ps3.o
 obj-$(CONFIG_RTC_DRV_COH901331)	+= rtc-coh901331.o
+obj-$(CONFIG_RTC_DRV_STMP)	+= rtc-stmp3xxx.o
diff -puN /dev/null drivers/rtc/rtc-stmp3xxx.c
--- /dev/null
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -0,0 +1,304 @@
+/*
+ * Freescale STMP37XX/STMP378X Real Time Clock driver
+ *
+ * Copyright (c) 2007 Sigmatel, Inc.
+ * Peter Hartley, <peter.hartley@sigmatel.com>
+ *
+ * Copyright 2008 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2008 Embedded Alley Solutions, Inc All Rights Reserved.
+ */
+
+/*
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/rtc.h>
+
+#include <mach/platform.h>
+#include <mach/stmp3xxx.h>
+#include <mach/regs-rtc.h>
+
+struct stmp3xxx_rtc_data {
+	struct rtc_device *rtc;
+	unsigned irq_count;
+	void __iomem *io;
+	int irq_alarm, irq_1msec;
+};
+
+static void stmp3xxx_wait_time(struct stmp3xxx_rtc_data *rtc_data)
+{
+	/*
+	 * The datasheet doesn't say which way round the
+	 * NEW_REGS/STALE_REGS bitfields go. In fact it's 0x1=P0,
+	 * 0x2=P1, .., 0x20=P5, 0x40=ALARM, 0x80=SECONDS
+	 */
+	while (__raw_readl(rtc_data->io + HW_RTC_STAT) &
+			BF(0x80, RTC_STAT_STALE_REGS))
+		cpu_relax();
+}
+
+/* Time read/write */
+static int stmp3xxx_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
+{
+	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
+
+	stmp3xxx_wait_time(rtc_data);
+	rtc_time_to_tm(__raw_readl(rtc_data->io + HW_RTC_SECONDS), rtc_tm);
+	return 0;
+}
+
+static int stmp3xxx_rtc_set_mmss(struct device *dev, unsigned long t)
+{
+	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
+
+	__raw_writel(t, rtc_data->io + HW_RTC_SECONDS);
+	stmp3xxx_wait_time(rtc_data);
+	return 0;
+}
+
+/* interrupt(s) handler */
+static irqreturn_t stmp3xxx_rtc_interrupt(int irq, void *dev_id)
+{
+	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev_id);
+	u32 status;
+	u32 events = 0;
+
+	status = __raw_readl(rtc_data->io + HW_RTC_CTRL) &
+			(BM_RTC_CTRL_ALARM_IRQ | BM_RTC_CTRL_ONEMSEC_IRQ);
+
+	if (status & BM_RTC_CTRL_ALARM_IRQ) {
+		stmp3xxx_clearl(BM_RTC_CTRL_ALARM_IRQ,
+				rtc_data->io + HW_RTC_CTRL);
+		events |= RTC_AF | RTC_IRQF;
+	}
+
+	if (status & BM_RTC_CTRL_ONEMSEC_IRQ) {
+		stmp3xxx_clearl(BM_RTC_CTRL_ONEMSEC_IRQ,
+				rtc_data->io + HW_RTC_CTRL);
+		if (++rtc_data->irq_count % 1000 == 0) {
+			events |= RTC_UF | RTC_IRQF;
+			rtc_data->irq_count = 0;
+		}
+	}
+
+	if (events)
+		rtc_update_irq(rtc_data->rtc, 1, events);
+
+	return IRQ_HANDLED;
+}
+
+static int stmp3xxx_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
+	void __iomem *p = rtc_data->io + HW_RTC_PERSISTENT0,
+		     *ctl = rtc_data->io + HW_RTC_CTRL;
+
+	if (enabled) {
+		stmp3xxx_setl(BM_RTC_PERSISTENT0_ALARM_EN |
+			      BM_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
+		stmp3xxx_setl(BM_RTC_CTRL_ALARM_IRQ_EN, ctl);
+	} else {
+		stmp3xxx_clearl(BM_RTC_PERSISTENT0_ALARM_EN |
+			      BM_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
+		stmp3xxx_clearl(BM_RTC_CTRL_ALARM_IRQ_EN, ctl);
+	}
+	return 0;
+}
+
+static int stmp3xxx_update_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
+
+	if (enabled)
+		stmp3xxx_setl(BM_RTC_CTRL_ONEMSEC_IRQ_EN,
+				rtc_data->io + HW_RTC_CTRL);
+	else
+		stmp3xxx_clearl(BM_RTC_CTRL_ONEMSEC_IRQ_EN,
+				rtc_data->io + HW_RTC_CTRL);
+	return 0;
+}
+
+static int stmp3xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
+
+	rtc_time_to_tm(__raw_readl(rtc_data->io + HW_RTC_ALARM), &alm->time);
+	return 0;
+}
+
+static int stmp3xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	unsigned long t;
+	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
+
+	rtc_tm_to_time(&alm->time, &t);
+	__raw_writel(t, rtc_data->io + HW_RTC_ALARM);
+	return 0;
+}
+
+static struct rtc_class_ops stmp3xxx_rtc_ops = {
+	.alarm_irq_enable =
+			  stmp3xxx_alarm_irq_enable,
+	.update_irq_enable =
+			  stmp3xxx_update_irq_enable,
+	.read_time	= stmp3xxx_rtc_gettime,
+	.set_mmss	= stmp3xxx_rtc_set_mmss,
+	.read_alarm	= stmp3xxx_rtc_read_alarm,
+	.set_alarm	= stmp3xxx_rtc_set_alarm,
+};
+
+static int stmp3xxx_rtc_remove(struct platform_device *pdev)
+{
+	struct stmp3xxx_rtc_data *rtc_data = platform_get_drvdata(pdev);
+
+	if (!rtc_data)
+		return 0;
+
+	stmp3xxx_clearl(BM_RTC_CTRL_ONEMSEC_IRQ_EN | BM_RTC_CTRL_ALARM_IRQ_EN,
+			rtc_data->io + HW_RTC_CTRL);
+	free_irq(rtc_data->irq_alarm, &pdev->dev);
+	free_irq(rtc_data->irq_1msec, &pdev->dev);
+	rtc_device_unregister(rtc_data->rtc);
+	iounmap(rtc_data->io);
+	kfree(rtc_data);
+
+	return 0;
+}
+
+static int stmp3xxx_rtc_probe(struct platform_device *pdev)
+{
+	struct stmp3xxx_rtc_data *rtc_data;
+	struct resource *r;
+	int err;
+
+	rtc_data = kzalloc(sizeof *rtc_data, GFP_KERNEL);
+	if (!rtc_data)
+		return -ENOMEM;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "failed to get resource\n");
+		err = -ENXIO;
+		goto out_free;
+	}
+
+	rtc_data->io = ioremap(r->start, resource_size(r));
+	if (!rtc_data->io) {
+		dev_err(&pdev->dev, "ioremap failed\n");
+		err = -EIO;
+		goto out_free;
+	}
+
+	rtc_data->irq_alarm = platform_get_irq(pdev, 0);
+	rtc_data->irq_1msec = platform_get_irq(pdev, 1);
+
+	if (!(__raw_readl(HW_RTC_STAT + rtc_data->io) &
+			BM_RTC_STAT_RTC_PRESENT)) {
+		dev_err(&pdev->dev, "no device onboard\n");
+		err = -ENODEV;
+		goto out_remap;
+	}
+
+	stmp3xxx_reset_block(rtc_data->io, true);
+	stmp3xxx_clearl(BM_RTC_PERSISTENT0_ALARM_EN |
+			BM_RTC_PERSISTENT0_ALARM_WAKE_EN |
+			BM_RTC_PERSISTENT0_ALARM_WAKE,
+			rtc_data->io + HW_RTC_PERSISTENT0);
+	rtc_data->rtc = rtc_device_register(pdev->name, &pdev->dev,
+				&stmp3xxx_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc_data->rtc)) {
+		err = PTR_ERR(rtc_data->rtc);
+		goto out_remap;
+	}
+
+	rtc_data->irq_count = 0;
+	err = request_irq(rtc_data->irq_alarm, stmp3xxx_rtc_interrupt,
+			IRQF_DISABLED, "RTC alarm", &pdev->dev);
+	if (err) {
+		dev_err(&pdev->dev, "Cannot claim IRQ%d\n",
+			rtc_data->irq_alarm);
+		goto out_irq_alarm;
+	}
+	err = request_irq(rtc_data->irq_1msec, stmp3xxx_rtc_interrupt,
+			IRQF_DISABLED, "RTC tick", &pdev->dev);
+	if (err) {
+		dev_err(&pdev->dev, "Cannot claim IRQ%d\n",
+			rtc_data->irq_1msec);
+		goto out_irq1;
+	}
+
+	platform_set_drvdata(pdev, rtc_data);
+
+	return 0;
+
+out_irq1:
+	free_irq(rtc_data->irq_alarm, &pdev->dev);
+out_irq_alarm:
+	stmp3xxx_clearl(BM_RTC_CTRL_ONEMSEC_IRQ_EN | BM_RTC_CTRL_ALARM_IRQ_EN,
+			rtc_data->io + HW_RTC_CTRL);
+	rtc_device_unregister(rtc_data->rtc);
+out_remap:
+	iounmap(rtc_data->io);
+out_free:
+	kfree(rtc_data);
+	return err;
+}
+
+#ifdef CONFIG_PM
+static int stmp3xxx_rtc_suspend(struct platform_device *dev, pm_message_t state)
+{
+	return 0;
+}
+
+static int stmp3xxx_rtc_resume(struct platform_device *dev)
+{
+	struct stmp3xxx_rtc_data *rtc_data = platform_get_drvdata(dev);
+
+	stmp3xxx_reset_block(rtc_data->io, true);
+	stmp3xxx_clearl(BM_RTC_PERSISTENT0_ALARM_EN |
+			BM_RTC_PERSISTENT0_ALARM_WAKE_EN |
+			BM_RTC_PERSISTENT0_ALARM_WAKE,
+			rtc_data->io + HW_RTC_PERSISTENT0);
+	return 0;
+}
+#else
+#define stmp3xxx_rtc_suspend	NULL
+#define stmp3xxx_rtc_resume	NULL
+#endif
+
+static struct platform_driver stmp3xxx_rtcdrv = {
+	.probe		= stmp3xxx_rtc_probe,
+	.remove		= stmp3xxx_rtc_remove,
+	.suspend	= stmp3xxx_rtc_suspend,
+	.resume		= stmp3xxx_rtc_resume,
+	.driver		= {
+		.name	= "stmp3xxx-rtc",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init stmp3xxx_rtc_init(void)
+{
+	return platform_driver_register(&stmp3xxx_rtcdrv);
+}
+
+static void __exit stmp3xxx_rtc_exit(void)
+{
+	platform_driver_unregister(&stmp3xxx_rtcdrv);
+}
+
+module_init(stmp3xxx_rtc_init);
+module_exit(stmp3xxx_rtc_exit);
+
+MODULE_DESCRIPTION("STMP3xxx RTC Driver");
+MODULE_AUTHOR("dmitry pervushin <dpervushin@embeddedalley.com>");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dpervushin@embeddedalley.com are

rtc-add-freescale-stmp37xx-378x-driver.patch

