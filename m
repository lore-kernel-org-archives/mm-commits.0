From: akpm@linux-foundation.org
Subject: + arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920.patch added to -mm tree
Date: Mon, 30 Nov 2009 14:23:28 -0800
Message-ID: <200911302223.nAUMNSSb032412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbZK3WYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 17:24:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, jack_wang@usish.com, rmk@arm.linux.org.uk, specter118@gmail.com


The patch titled
     ]ARM: NUC900: add RTC driver support for nuc910 and nuc920
has been added to the -mm tree.  Its filename is
     arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920.patch

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
Subject: ]ARM: NUC900: add RTC driver support for nuc910 and nuc920
From: Wan ZongShun <mcuos.com@gmail.com>

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Hu Ruihuan <specter118@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: "jack wang" <jack_wang@usish.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    6 
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-nuc900.c |  331 +++++++++++++++++++++++++++++++++++++
 3 files changed, 338 insertions(+)

diff -puN drivers/rtc/Kconfig~arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920
+++ a/drivers/rtc/Kconfig
@@ -601,6 +601,12 @@ config RTC_DRV_AB3100
 	  Select this to enable the ST-Ericsson AB3100 Mixed Signal IC RTC
 	  support. This chip contains a battery- and capacitor-backed RTC.
 
+config RTC_DRV_NUC900
+	tristate "NUC910/NUC920 RTC driver"
+	depends on RTC_CLASS && ARCH_W90X900
+	help
+	  If you say yes here you get support for the RTC subsystem of the
+	  NUC910/NUC920 used in embedded systems.
 
 comment "on-CPU RTC drivers"
 
diff -puN drivers/rtc/Makefile~arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920 drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920
+++ a/drivers/rtc/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max
 obj-$(CONFIG_RTC_DRV_MC13783)	+= rtc-mc13783.o
 obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
 obj-$(CONFIG_RTC_DRV_MV)	+= rtc-mv.o
+obj-$(CONFIG_RTC_DRV_NUC900)	+= rtc-nuc900.o
 obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
 obj-$(CONFIG_RTC_DRV_PCAP)	+= rtc-pcap.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
diff -puN /dev/null drivers/rtc/rtc-nuc900.c
--- /dev/null
+++ a/drivers/rtc/rtc-nuc900.c
@@ -0,0 +1,331 @@
+/*
+ * Copyright (c) 2008-2009 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/bcd.h>
+
+/* RTC Control Registers */
+#define REG_RTC_INIR		0x00
+#define REG_RTC_AER		0x04
+#define REG_RTC_FCR		0x08
+#define REG_RTC_TLR		0x0C
+#define REG_RTC_CLR		0x10
+#define REG_RTC_TSSR		0x14
+#define REG_RTC_DWR		0x18
+#define REG_RTC_TAR		0x1C
+#define REG_RTC_CAR		0x20
+#define REG_RTC_LIR		0x24
+#define REG_RTC_RIER		0x28
+#define REG_RTC_RIIR		0x2C
+#define REG_RTC_TTR		0x30
+
+#define RTCSET			0x01
+#define AERRWENB		0x10000
+#define INIRRESET		0xa5eb1357
+#define AERPOWERON		0xA965
+#define AERPOWEROFF		0x0000
+#define LEAPYEAR		0x0001
+#define TICKENB			0x80
+#define TICKINTENB		0x0002
+#define ALARMINTENB		0x0001
+#define MODE24			0x0001
+
+struct nuc900_rtc {
+	int			irq_num;
+	void __iomem		*rtc_reg;
+	struct rtc_device	*rtcdev;
+};
+
+struct nuc900_bcd_time {
+	int bcd_sec;
+	int bcd_min;
+	int bcd_hour;
+	int bcd_mday;
+	int bcd_mon;
+	int bcd_year;
+};
+
+static irqreturn_t nuc900_rtc_interrupt(int irq, void *_rtc)
+{
+	struct nuc900_rtc *rtc = _rtc;
+	unsigned long events = 0, rtc_irq;
+
+	rtc_irq = __raw_readl(rtc->rtc_reg + REG_RTC_RIIR);
+
+	if (rtc_irq & ALARMINTENB) {
+		rtc_irq &= ~ALARMINTENB;
+		__raw_writel(rtc_irq, rtc->rtc_reg + REG_RTC_RIIR);
+		events |= RTC_AF | RTC_IRQF;
+	}
+
+	if (rtc_irq & TICKINTENB) {
+		rtc_irq &= ~TICKINTENB;
+		__raw_writel(rtc_irq, rtc->rtc_reg + REG_RTC_RIIR);
+		events |= RTC_UF | RTC_IRQF;
+	}
+
+	rtc_update_irq(rtc->rtcdev, 1, events);
+
+	return IRQ_HANDLED;
+}
+
+static void check_rtc_power(struct nuc900_rtc *nuc900_rtc)
+{
+	unsigned int i;
+	__raw_writel(INIRRESET, nuc900_rtc->rtc_reg + REG_RTC_INIR);
+
+	mdelay(10);
+
+	__raw_writel(AERPOWERON, nuc900_rtc->rtc_reg + REG_RTC_AER);
+
+	for (i = 0; i < 1000000; i++) {
+		if (__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_AER) & AERRWENB)
+			break;
+	}
+}
+
+static void nuc900_rtc_bcd2bin(unsigned int timereg,
+				unsigned int calreg, struct rtc_time *tm)
+{
+	tm->tm_mday	= bcd2bin(calreg >> 0);
+	tm->tm_mon	= bcd2bin(calreg >> 8);
+	tm->tm_year	= bcd2bin(calreg >> 16) + 100;
+
+	tm->tm_sec	= bcd2bin(timereg >> 0);
+	tm->tm_min	= bcd2bin(timereg >> 8);
+	tm->tm_hour	= bcd2bin(timereg >> 16);
+
+	rtc_valid_tm(tm);
+}
+
+static void nuc900_rtc_bin2bcd(struct rtc_time *settm,
+						struct nuc900_bcd_time *gettm)
+{
+	gettm->bcd_mday = bin2bcd(settm->tm_mday) << 0;
+	gettm->bcd_mon  = bin2bcd(settm->tm_mon) << 8;
+	gettm->bcd_year = bin2bcd(settm->tm_year - 100) << 16;
+
+	gettm->bcd_sec  = bin2bcd(settm->tm_sec) << 0;
+	gettm->bcd_min  = bin2bcd(settm->tm_min) << 8;
+	gettm->bcd_hour = bin2bcd(settm->tm_hour) << 16;
+}
+
+static int nuc900_update_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
+
+	if (enabled)
+		__raw_writel(__raw_readl(rtc->rtc_reg + REG_RTC_RIER)|
+				(TICKINTENB), rtc->rtc_reg + REG_RTC_RIER);
+	else
+		__raw_writel(__raw_readl(rtc->rtc_reg + REG_RTC_RIER)&
+				(~TICKINTENB), rtc->rtc_reg + REG_RTC_RIER);
+
+	return 0;
+}
+
+static int nuc900_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
+
+	if (enabled)
+		__raw_writel(__raw_readl(rtc->rtc_reg + REG_RTC_RIER)|
+				(ALARMINTENB), rtc->rtc_reg + REG_RTC_RIER);
+	else
+		__raw_writel(__raw_readl(rtc->rtc_reg + REG_RTC_RIER)&
+				(~ALARMINTENB), rtc->rtc_reg + REG_RTC_RIER);
+
+	return 0;
+}
+
+static int nuc900_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
+	unsigned int timeval, clrval;
+
+	timeval = __raw_readl(rtc->rtc_reg + REG_RTC_TLR);
+	clrval	= __raw_readl(rtc->rtc_reg + REG_RTC_CLR);
+
+	nuc900_rtc_bcd2bin(timeval, clrval, tm);
+
+	return 0;
+}
+
+static int nuc900_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
+	struct nuc900_bcd_time gettm;
+	unsigned long val;
+
+	nuc900_rtc_bin2bcd(tm, &gettm);
+
+	check_rtc_power(rtc);
+
+	val = gettm.bcd_mday | gettm.bcd_mon | gettm.bcd_year;
+	__raw_writel(val, rtc->rtc_reg + REG_RTC_CLR);
+
+	val = gettm.bcd_sec | gettm.bcd_min | gettm.bcd_hour;
+	__raw_writel(val, rtc->rtc_reg + REG_RTC_TLR);
+
+	return 0;
+}
+
+static int nuc900_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
+	unsigned int timeval, carval;
+
+	timeval = __raw_readl(rtc->rtc_reg + REG_RTC_TAR);
+	carval	= __raw_readl(rtc->rtc_reg + REG_RTC_CAR);
+
+	nuc900_rtc_bcd2bin(timeval, carval, &alrm->time);
+
+	return 0;
+}
+
+static int nuc900_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
+	struct nuc900_bcd_time tm;
+	unsigned long val;
+
+	nuc900_rtc_bin2bcd(&alrm->time, &tm);
+
+	check_rtc_power(rtc);
+
+	val = tm.bcd_mday | tm.bcd_mon | tm.bcd_year;
+	__raw_writel(val, rtc->rtc_reg + REG_RTC_CAR);
+
+	val = tm.bcd_sec | tm.bcd_min | tm.bcd_hour;
+	__raw_writel(val, rtc->rtc_reg + REG_RTC_TAR);
+
+	return 0;
+}
+
+static struct rtc_class_ops nuc900_rtc_ops = {
+	.read_time = nuc900_rtc_read_time,
+	.set_time = nuc900_rtc_set_time,
+	.read_alarm = nuc900_rtc_read_alarm,
+	.set_alarm = nuc900_rtc_set_alarm,
+	.alarm_irq_enable = nuc900_alarm_irq_enable,
+	.update_irq_enable = nuc900_update_irq_enable,
+};
+
+static int __devinit nuc900_rtc_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct nuc900_rtc *nuc900_rtc;
+	int err = 0;
+
+	nuc900_rtc = kzalloc(sizeof(struct nuc900_rtc), GFP_KERNEL);
+	if (!nuc900_rtc) {
+		dev_err(&pdev->dev, "kzalloc nuc900_rtc failed\n");
+		return -ENOMEM;
+	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "platform_get_resource failed\n");
+		err = -ENXIO;
+		goto fail1;
+	}
+
+	if (!request_mem_region(res->start, resource_size(res),
+				pdev->name)) {
+		dev_err(&pdev->dev, "request_mem_region failed\n");
+		err = -EBUSY;
+		goto fail1;
+	}
+
+	nuc900_rtc->rtc_reg = ioremap(res->start, resource_size(res));
+	if (!nuc900_rtc->rtc_reg) {
+		dev_err(&pdev->dev, "ioremap rtc_reg failed\n");
+		err = -ENOMEM;
+		goto fail2;
+	}
+
+	nuc900_rtc->irq_num = platform_get_irq(pdev, 0);
+	if (request_irq(nuc900_rtc->irq_num, nuc900_rtc_interrupt,
+				IRQF_DISABLED, "nuc900rtc", nuc900_rtc)) {
+		dev_err(&pdev->dev, "NUC900 RTC request irq failed\n");
+		err = -EBUSY;
+		goto fail3;
+	}
+
+	nuc900_rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
+						&nuc900_rtc_ops, THIS_MODULE);
+	if (IS_ERR(nuc900_rtc->rtcdev)) {
+		dev_err(&pdev->dev, "rtc device register faild\n");
+		err = PTR_ERR(nuc900_rtc->rtcdev);
+		goto fail4;
+	}
+
+	platform_set_drvdata(pdev, nuc900_rtc);
+	__raw_writel(__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_TSSR) | MODE24,
+					nuc900_rtc->rtc_reg + REG_RTC_TSSR);
+
+	return 0;
+
+fail4:	free_irq(nuc900_rtc->irq_num, nuc900_rtc);
+fail3:	iounmap(nuc900_rtc->rtc_reg);
+fail2:	release_mem_region(res->start, resource_size(res));
+fail1:	kfree(nuc900_rtc);
+	return err;
+}
+
+static int __devexit nuc900_rtc_remove(struct platform_device *pdev)
+{
+	struct nuc900_rtc *nuc900_rtc = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	rtc_device_unregister(nuc900_rtc->rtcdev);
+	free_irq(nuc900_rtc->irq_num, nuc900_rtc);
+	iounmap(nuc900_rtc->rtc_reg);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+
+	kfree(nuc900_rtc);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver nuc900_rtc_driver = {
+	.remove		= __devexit_p(nuc900_rtc_remove),
+	.driver		= {
+		.name	= "nuc900-rtc",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init nuc900_rtc_init(void)
+{
+	return platform_driver_probe(&nuc900_rtc_driver, nuc900_rtc_probe);
+}
+
+static void __exit nuc900_rtc_exit(void)
+{
+	platform_driver_unregister(&nuc900_rtc_driver);
+}
+
+module_init(nuc900_rtc_init);
+module_exit(nuc900_rtc_exit);
+
+MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
+MODULE_DESCRIPTION("nuc910/nuc920 RTC driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:nuc900-rtc");
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

linux-next.patch
arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920.patch

