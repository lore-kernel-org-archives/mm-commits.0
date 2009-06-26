From: akpm@linux-foundation.org
Subject: + rtc-u300-coh-901-331-rtc-driver-v3.patch added to -mm tree
Date: Fri, 26 Jun 2009 16:00:15 -0700
Message-ID: <200906262300.n5QN0GAY020377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952AbZFZXA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 19:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.ml.walleij@gmail.com, a.zummo@towertech.it, linus.walleij@stericsson.com


The patch titled
     rtc: U300 COH 901 331 RTC driver v3
has been added to the -mm tree.  Its filename is
     rtc-u300-coh-901-331-rtc-driver-v3.patch

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
Subject: rtc: U300 COH 901 331 RTC driver v3
From: Linus Walleij <linus.ml.walleij@gmail.com>

This adds a driver for the RTC COH 901 331 found in the ST-Ericsson U300
series mobile platforms to the RTC subsystem.  It integrates to the ARM
kernel support recently added to RMKs ARM tree and will be enabled in the
U300 defconfig in due time.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig         |   12 +
 drivers/rtc/Makefile        |    1 
 drivers/rtc/rtc-coh901331.c |  311 ++++++++++++++++++++++++++++++++++
 3 files changed, 324 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-u300-coh-901-331-rtc-driver-v3 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-u300-coh-901-331-rtc-driver-v3
+++ a/drivers/rtc/Kconfig
@@ -789,4 +789,16 @@ config RTC_DRV_PS3
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ps3.
 
+config RTC_DRV_COH901331
+	tristate "ST-Ericsson COH 901 331 RTC"
+	depends on ARCH_U300
+	help
+	  If you say Y here you will get access to ST-Ericsson
+	  COH 901 331 RTC clock found in some ST-Ericsson Mobile
+	  Platforms.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called "rtc-coh901331".
+
+
 endif # RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-u300-coh-901-331-rtc-driver-v3 drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-u300-coh-901-331-rtc-driver-v3
+++ a/drivers/rtc/Makefile
@@ -81,3 +81,4 @@ obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm83
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
 obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pcf50633.o
 obj-$(CONFIG_RTC_DRV_PS3)	+= rtc-ps3.o
+obj-$(CONFIG_RTC_DRV_COH901331)	+= rtc-coh901331.o
diff -puN /dev/null drivers/rtc/rtc-coh901331.c
--- /dev/null
+++ a/drivers/rtc/rtc-coh901331.c
@@ -0,0 +1,311 @@
+/*
+ * Copyright (C) 2007-2009 ST-Ericsson AB
+ * License terms: GNU General Public License (GPL) version 2
+ * Real Time Clock interface for ST-Ericsson AB COH 901 331 RTC.
+ * Author: Linus Walleij <linus.walleij@stericsson.com>
+ * Based on rtc-pl031.c by Deepak Saxena <dsaxena@plexity.net>
+ * Copyright 2006 (c) MontaVista Software, Inc.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/rtc.h>
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+
+/*
+ * Registers in the COH 901 331
+ */
+/* Alarm value 32bit (R/W) */
+#define COH901331_ALARM		0x00U
+/* Used to set current time 32bit (R/W) */
+#define COH901331_SET_TIME	0x04U
+/* Indication if current time is valid 32bit (R/-) */
+#define COH901331_VALID		0x08U
+/* Read the current time 32bit (R/-) */
+#define COH901331_CUR_TIME	0x0cU
+/* Event register for the "alarm" interrupt */
+#define COH901331_IRQ_EVENT	0x10U
+/* Mask register for the "alarm" interrupt */
+#define COH901331_IRQ_MASK	0x14U
+/* Force register for the "alarm" interrupt */
+#define COH901331_IRQ_FORCE	0x18U
+
+/*
+ * Reference to RTC block clock
+ * Notice that the frequent clk_enable()/clk_disable() on this
+ * clock is mainly to be able to turn on/off other clocks in the
+ * hierarchy as needed, the RTC clock is always on anyway.
+ */
+struct coh901331_port {
+	struct rtc_device *rtc;
+	struct clk *clk;
+	u32 phybase;
+	u32 physize;
+	void __iomem *virtbase;
+	int irq;
+#ifdef CONFIG_PM
+	u32 irqmaskstore;
+#endif
+};
+
+static irqreturn_t coh901331_interrupt(int irq, void *data)
+{
+	struct coh901331_port *rtap = data;
+
+	clk_enable(rtap->clk);
+	/* Ack IRQ */
+	writel(1, rtap->virtbase + COH901331_IRQ_EVENT);
+	clk_disable(rtap->clk);
+	/* Set alarm flag */
+	rtc_update_irq(rtap->rtc, 1, RTC_AF);
+
+	return IRQ_HANDLED;
+}
+
+static int coh901331_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct coh901331_port *rtap = dev_get_drvdata(dev);
+
+	clk_enable(rtap->clk);
+	/* Check if the time is valid */
+	if (readl(rtap->virtbase + COH901331_VALID)) {
+		rtc_time_to_tm(readl(rtap->virtbase + COH901331_CUR_TIME), tm);
+		clk_disable(rtap->clk);
+		return rtc_valid_tm(tm);
+	}
+	clk_disable(rtap->clk);
+	return -EINVAL;
+}
+
+static int coh901331_set_mmss(struct device *dev, unsigned long secs)
+{
+	struct coh901331_port *rtap = dev_get_drvdata(dev);
+
+	clk_enable(rtap->clk);
+	writel(secs, rtap->virtbase + COH901331_SET_TIME);
+	clk_disable(rtap->clk);
+
+	return 0;
+}
+
+static int coh901331_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct coh901331_port *rtap = dev_get_drvdata(dev);
+
+	clk_enable(rtap->clk);
+	rtc_time_to_tm(readl(rtap->virtbase + COH901331_ALARM), &alarm->time);
+	alarm->pending = readl(rtap->virtbase + COH901331_IRQ_EVENT) & 1U;
+	alarm->enabled = readl(rtap->virtbase + COH901331_IRQ_MASK) & 1U;
+	clk_disable(rtap->clk);
+
+	return 0;
+}
+
+static int coh901331_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct coh901331_port *rtap = dev_get_drvdata(dev);
+	unsigned long time;
+
+	rtc_tm_to_time(&alarm->time, &time);
+	clk_enable(rtap->clk);
+	writel(time, rtap->virtbase + COH901331_ALARM);
+	writel(alarm->enabled, rtap->virtbase + COH901331_IRQ_MASK);
+	clk_disable(rtap->clk);
+
+	return 0;
+}
+
+static int coh901331_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct coh901331_port *rtap = dev_get_drvdata(dev);
+
+	clk_enable(rtap->clk);
+	if (enabled)
+		writel(1, rtap->virtbase + COH901331_IRQ_MASK);
+	else
+		writel(0, rtap->virtbase + COH901331_IRQ_MASK);
+	clk_disable(rtap->clk);
+}
+
+static struct rtc_class_ops coh901331_ops = {
+	.read_time = coh901331_read_time,
+	.set_mmss = coh901331_set_mmss,
+	.read_alarm = coh901331_read_alarm,
+	.set_alarm = coh901331_set_alarm,
+	.alarm_irq_enable = coh901331_alarm_irq_enable,
+};
+
+static int __exit coh901331_remove(struct platform_device *pdev)
+{
+	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+
+	if (rtap) {
+		free_irq(rtap->irq, rtap);
+		rtc_device_unregister(rtap->rtc);
+		clk_put(rtap->clk);
+		iounmap(rtap->virtbase);
+		release_mem_region(rtap->phybase, rtap->physize);
+		platform_set_drvdata(pdev, NULL);
+		kfree(rtap);
+	}
+
+	return 0;
+}
+
+
+static int __init coh901331_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct coh901331_port *rtap;
+	struct resource *res;
+
+	rtap = kzalloc(sizeof(struct coh901331_port), GFP_KERNEL);
+	if (!rtap)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -ENOENT;
+		goto out_no_resource;
+	}
+	rtap->phybase = res->start;
+	rtap->physize = resource_size(res);
+
+	if (request_mem_region(rtap->phybase, rtap->physize,
+			       "rtc-coh901331") == NULL) {
+		ret = -EBUSY;
+		goto out_no_memregion;
+	}
+
+	rtap->virtbase = ioremap(rtap->phybase, rtap->physize);
+	if (!rtap->virtbase) {
+		ret = -ENOMEM;
+		goto out_no_remap;
+	}
+
+	rtap->irq = platform_get_irq(pdev, 0);
+	if (request_irq(rtap->irq, coh901331_interrupt, IRQF_DISABLED,
+			"RTC COH 901 331 Alarm", rtap)) {
+		ret = -EIO;
+		goto out_no_irq;
+	}
+
+	rtap->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(rtap->clk)) {
+		ret = PTR_ERR(rtap->clk);
+		dev_err(&pdev->dev, "could not get clock\n");
+		goto out_no_clk;
+	}
+
+	/* We enable/disable the clock only to assure it works */
+	ret = clk_enable(rtap->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "could not enable clock\n");
+		goto out_no_clk_enable;
+	}
+	clk_disable(rtap->clk);
+
+	rtap->rtc = rtc_device_register("coh901331", &pdev->dev, &coh901331_ops,
+					 THIS_MODULE);
+	if (IS_ERR(rtap->rtc)) {
+		ret = PTR_ERR(rtap->rtc);
+		goto out_no_rtc;
+	}
+
+	platform_set_drvdata(pdev, rtap);
+
+	return 0;
+
+ out_no_rtc:
+ out_no_clk_enable:
+	clk_put(rtap->clk);
+ out_no_clk:
+	free_irq(rtap->irq, rtap);
+ out_no_irq:
+	iounmap(rtap->virtbase);
+ out_no_remap:
+	platform_set_drvdata(pdev, NULL);
+ out_no_memregion:
+	release_mem_region(rtap->phybase, SZ_4K);
+ out_no_resource:
+	kfree(rtap);
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int coh901331_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+
+	/*
+	 * If this RTC alarm will be used for waking the system up,
+	 * don't disable it of course. Else we just disable the alarm
+	 * and await suspension.
+	 */
+	if (device_may_wakeup(&pdev->dev)) {
+		enable_irq_wake(rtap->irq);
+	} else {
+		clk_enable(rtap->clk);
+		rtap->irqmaskstore = readl(rtap->virtbase + COH901331_IRQ_MASK);
+		writel(0, rtap->virtbase + COH901331_IRQ_MASK);
+		clk_disable(rtap->clk);
+	}
+	return 0;
+}
+
+static int coh901331_resume(struct platform_device *pdev)
+{
+	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+
+	if (device_may_wakeup(&pdev->dev))
+		disable_irq_wake(rtap->irq);
+	else
+		clk_enable(rtap->clk);
+		writel(rtap->irqmaskstore, rtap->virtbase + COH901331_IRQ_MASK);
+		clk_disable(rtap->clk);
+	return 0;
+}
+#else
+#define coh901331_suspend NULL
+#define coh901331_resume NULL
+#endif
+
+static void coh901331_shutdown(struct platform_device *pdev)
+{
+	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+
+	clk_enable(rtap->clk);
+	writel(0, rtap->virtbase + COH901331_IRQ_MASK);
+	clk_disable(rtap->clk);
+}
+
+static struct platform_driver coh901331_driver = {
+	.driver = {
+		.name = "rtc-coh901331",
+		.owner = THIS_MODULE,
+	},
+	.remove = __exit_p(coh901331_remove),
+	.suspend = coh901331_suspend,
+	.resume = coh901331_resume,
+	.shutdown = coh901331_shutdown,
+};
+
+static int __init coh901331_init(void)
+{
+	return platform_driver_probe(&coh901331_driver, coh901331_probe);
+}
+
+static void __exit coh901331_exit(void)
+{
+	platform_driver_unregister(&coh901331_driver);
+}
+
+module_init(coh901331_init);
+module_exit(coh901331_exit);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
+MODULE_DESCRIPTION("ST-Ericsson AB COH 901 331 RTC Driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from linus.ml.walleij@gmail.com are

rtc-u300-coh-901-331-rtc-driver-v3.patch

