From: akpm@linux-foundation.org
Subject: + rtc-driver-for-pcap2-pmic.patch added to -mm tree
Date: Fri, 26 Jun 2009 13:23:23 -0700
Message-ID: <200906262023.n5QKNNrR013690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756880AbZFZUX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 16:23:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drwyrm@gmail.com, a.zummo@towertech.it, gmzhuo@gmail.com


The patch titled
     rtc: driver for PCAP2 PMIC
has been added to the -mm tree.  Its filename is
     rtc-driver-for-pcap2-pmic.patch

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
Subject: rtc: driver for PCAP2 PMIC
From: Daniel Ribeiro <drwyrm@gmail.com>

Signed-off-by: guiming zhuo <gmzhuo@gmail.com>
Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig    |    7 +
 drivers/rtc/Makefile   |    1 
 drivers/rtc/rtc-pcap.c |  222 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 230 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-driver-for-pcap2-pmic drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-driver-for-pcap2-pmic
+++ a/drivers/rtc/Kconfig
@@ -778,4 +778,11 @@ config RTC_DRV_PS3
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ps3.
 
+config RTC_DRV_PCAP
+	tristate "PCAP RTC"
+	depends on EZX_PCAP
+	help
+	  If you say Y here you will get support for the RTC found on
+	  the PCAP2 ASIC used on some Motorola phones.
+
 endif # RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-driver-for-pcap2-pmic drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-driver-for-pcap2-pmic
+++ a/drivers/rtc/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max
 obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
 obj-$(CONFIG_RTC_DRV_MV)	+= rtc-mv.o
 obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
+obj-$(CONFIG_RTC_DRV_PCAP)	+= rtc-pcap.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
 obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
 obj-$(CONFIG_RTC_DRV_PL030)	+= rtc-pl030.o
diff -puN /dev/null drivers/rtc/rtc-pcap.c
--- /dev/null
+++ a/drivers/rtc/rtc-pcap.c
@@ -0,0 +1,222 @@
+/*
+ *  pcap rtc code for Motorola EZX phones
+ *
+ *  Copyright (c) 2008 guiming zhuo <gmzhuo@gmail.com>
+ *  Copyright (c) 2009 Daniel Ribeiro <drwyrm@gmail.com>
+ *
+ *  Based on Motorola's rtc.c Copyright (c) 2003-2005 Motorola
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/mfd/ezx-pcap.h>
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+
+struct pcap_rtc {
+	struct pcap_chip *pcap;
+	struct rtc_device *rtc;
+};
+
+static irqreturn_t pcap_rtc_irq(int irq, void *_pcap_rtc)
+{
+	struct pcap_rtc *pcap_rtc = _pcap_rtc;
+	unsigned long rtc_events = 0;
+
+	if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ))
+		rtc_events |= RTC_IRQF | RTC_UF;
+	else if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA))
+		rtc_events |= RTC_IRQF | RTC_AF;
+
+	rtc_update_irq(pcap_rtc->rtc, 1, rtc_events);
+	return IRQ_HANDLED;
+}
+
+static int pcap_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
+	struct rtc_time *tm = &alrm->time;
+	unsigned long secs;
+	u32 tmp;
+
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_TODA, &tmp);
+	secs = tmp & PCAP_RTC_TOD_MASK;
+
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, &tmp);
+	secs += (tmp & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
+
+	rtc_time_to_tm(secs, tm);
+
+	return 0;
+}
+
+static int pcap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
+	struct rtc_time *tm = &alrm->time;
+	unsigned long secs;
+	u32 tmp;
+
+	rtc_tm_to_time(tm, &secs);
+
+	tmp = secs % SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TODA, tmp);
+
+	tmp = secs / SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, tmp);
+
+	return 0;
+}
+
+static int pcap_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
+	unsigned long secs;
+	u32 tmp;
+
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_TOD, &tmp);
+	secs = tmp & PCAP_RTC_TOD_MASK;
+
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAY, &tmp);
+	secs += (tmp & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
+
+	rtc_time_to_tm(secs, tm);
+
+	return rtc_valid_tm(tm);
+}
+
+static int pcap_rtc_set_mmss(struct device *dev, unsigned long secs)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
+	u32 tmp;
+
+	tmp = secs % SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TOD, tmp);
+
+	tmp = secs / SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_DAY, tmp);
+
+	return 0;
+}
+
+static inline int pcap_rtc_irq_enable(struct device *dev, int pirq,
+							unsigned int en)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
+
+	if (en)
+		enable_irq(pcap_to_irq(pcap_rtc->pcap, pirq));
+	else
+		disable_irq(pcap_to_irq(pcap_rtc->pcap, pirq));
+
+	return 0;
+}
+
+static int pcap_rtc_alarm_irq_enable(struct device *dev, unsigned int en)
+{
+	return pcap_rtc_irq_enable(dev, PCAP_IRQ_TODA, en);
+}
+
+static int pcap_rtc_update_irq_enable(struct device *dev, unsigned int en)
+{
+	return pcap_rtc_irq_enable(dev, PCAP_IRQ_1HZ, en);
+}
+
+static const struct rtc_class_ops pcap_rtc_ops = {
+	.read_time = pcap_rtc_read_time,
+	.read_alarm = pcap_rtc_read_alarm,
+	.set_alarm = pcap_rtc_set_alarm,
+	.set_mmss = pcap_rtc_set_mmss,
+	.alarm_irq_enable = pcap_rtc_alarm_irq_enable,
+	.update_irq_enable = pcap_rtc_update_irq_enable,
+};
+
+static int __devinit pcap_rtc_probe(struct platform_device *pdev)
+{
+	struct pcap_rtc *pcap_rtc;
+	int timer_irq, alarm_irq;
+	int err = -ENOMEM;
+
+	pcap_rtc = kmalloc(sizeof(struct pcap_rtc), GFP_KERNEL);
+	if (!pcap_rtc)
+		return err;
+
+	pcap_rtc->pcap = platform_get_drvdata(pdev);
+
+	pcap_rtc->rtc = rtc_device_register("pcap", &pdev->dev,
+				  &pcap_rtc_ops, THIS_MODULE);
+	if (IS_ERR(pcap_rtc->rtc)) {
+		err = PTR_ERR(pcap_rtc->rtc);
+		goto fail_rtc;
+	}
+
+	platform_set_drvdata(pdev, pcap_rtc);
+
+	timer_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ);
+	alarm_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA);
+
+	err = request_irq(timer_irq, pcap_rtc_irq, 0, "RTC Timer", pcap_rtc);
+	if (err)
+		goto fail_timer;
+
+	err = request_irq(alarm_irq, pcap_rtc_irq, 0, "RTC Alarm", pcap_rtc);
+	if (err)
+		goto fail_alarm;
+
+	return 0;
+fail_alarm:
+	free_irq(timer_irq, pcap_rtc);
+fail_timer:
+	rtc_device_unregister(pcap_rtc->rtc);
+fail_rtc:
+	kfree(pcap_rtc);
+	return err;
+}
+
+static int __devexit pcap_rtc_remove(struct platform_device *pdev)
+{
+	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
+
+	free_irq(pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ), pcap_rtc);
+	free_irq(pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA), pcap_rtc);
+	rtc_device_unregister(pcap_rtc->rtc);
+	kfree(pcap_rtc);
+
+	return 0;
+}
+
+static struct platform_driver pcap_rtc_driver = {
+	.remove = __devexit_p(pcap_rtc_remove),
+	.driver = {
+		.name  = "pcap-rtc",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init rtc_pcap_init(void)
+{
+	return platform_driver_probe(&pcap_rtc_driver, pcap_rtc_probe);
+}
+
+static void __exit rtc_pcap_exit(void)
+{
+	platform_driver_unregister(&pcap_rtc_driver);
+}
+
+module_init(rtc_pcap_init);
+module_exit(rtc_pcap_exit);
+
+MODULE_DESCRIPTION("Motorola pcap rtc driver");
+MODULE_AUTHOR("guiming zhuo <gmzhuo@gmail.com>");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from drwyrm@gmail.com are

rtc-driver-for-pcap2-pmic.patch

