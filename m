From: akpm@linux-foundation.org
Subject: [merged] mips-add-rtc-support-for-loongson1b.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:25 -0700
Message-ID: <20120326193125.7D06DA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:54545 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552Ab2CZTb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2012 15:31:27 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id i8so288307laa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhzhl555@gmail.com, a.zummo@towertech.it, linus.walleij@linaro.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MIPS: add RTC support for loongson1B
has been removed from the -mm tree.  Its filename was
     mips-add-rtc-support-for-loongson1b.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: zhao zhang <zhzhl555@gmail.com>
Subject: MIPS: add RTC support for loongson1B

Add RTC support(TOY counter0) for loongson1B SOC

Signed-off-by: zhao zhang <zhzhl555@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig    |   10 +
 drivers/rtc/Makefile   |    1 
 drivers/rtc/rtc-ls1x.c |  211 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 222 insertions(+)

diff -puN drivers/rtc/Kconfig~mips-add-rtc-support-for-loongson1b drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~mips-add-rtc-support-for-loongson1b
+++ a/drivers/rtc/Kconfig
@@ -1070,4 +1070,14 @@ config RTC_DRV_PUV3
 	  This drive can also be built as a module. If so, the module
 	  will be called rtc-puv3.
 
+config RTC_DRV_LOONGSON1
+	tristate "loongson1 RTC support"
+	depends on MACH_LOONGSON1
+	help
+	  This is a driver for the loongson1 on-chip Counter0 (Time-Of-Year
+	  counter) to be used as a RTC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-ls1x.
+
 endif # RTC_CLASS
diff -puN drivers/rtc/Makefile~mips-add-rtc-support-for-loongson1b drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~mips-add-rtc-support-for-loongson1b
+++ a/drivers/rtc/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl
 obj-$(CONFIG_RTC_DRV_ISL12022)	+= rtc-isl12022.o
 obj-$(CONFIG_RTC_DRV_JZ4740)	+= rtc-jz4740.o
 obj-$(CONFIG_RTC_DRV_LPC32XX)	+= rtc-lpc32xx.o
+obj-$(CONFIG_RTC_DRV_LOONGSON1)	+= rtc-ls1x.o
 obj-$(CONFIG_RTC_DRV_M41T80)	+= rtc-m41t80.o
 obj-$(CONFIG_RTC_DRV_M41T93)	+= rtc-m41t93.o
 obj-$(CONFIG_RTC_DRV_M41T94)	+= rtc-m41t94.o
diff -puN /dev/null drivers/rtc/rtc-ls1x.c
--- /dev/null
+++ a/drivers/rtc/rtc-ls1x.c
@@ -0,0 +1,211 @@
+/*
+ * Copyright (c) 2011 Zhao Zhang <zhzhl555@gmail.com>
+ *
+ * Derived from driver/rtc/rtc-au1xxx.c
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/rtc.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/types.h>
+#include <linux/io.h>
+#include <asm/mach-loongson1/loongson1.h>
+
+#define LS1X_RTC_REG_OFFSET	(LS1X_RTC_BASE + 0x20)
+#define LS1X_RTC_REGS(x) \
+		((void __iomem *)KSEG1ADDR(LS1X_RTC_REG_OFFSET + (x)))
+
+/*RTC programmable counters 0 and 1*/
+#define SYS_COUNTER_CNTRL		(LS1X_RTC_REGS(0x20))
+#define SYS_CNTRL_ERS			(1 << 23)
+#define SYS_CNTRL_RTS			(1 << 20)
+#define SYS_CNTRL_RM2			(1 << 19)
+#define SYS_CNTRL_RM1			(1 << 18)
+#define SYS_CNTRL_RM0			(1 << 17)
+#define SYS_CNTRL_RS			(1 << 16)
+#define SYS_CNTRL_BP			(1 << 14)
+#define SYS_CNTRL_REN			(1 << 13)
+#define SYS_CNTRL_BRT			(1 << 12)
+#define SYS_CNTRL_TEN			(1 << 11)
+#define SYS_CNTRL_BTT			(1 << 10)
+#define SYS_CNTRL_E0			(1 << 8)
+#define SYS_CNTRL_ETS			(1 << 7)
+#define SYS_CNTRL_32S			(1 << 5)
+#define SYS_CNTRL_TTS			(1 << 4)
+#define SYS_CNTRL_TM2			(1 << 3)
+#define SYS_CNTRL_TM1			(1 << 2)
+#define SYS_CNTRL_TM0			(1 << 1)
+#define SYS_CNTRL_TS			(1 << 0)
+
+/* Programmable Counter 0 Registers */
+#define SYS_TOYTRIM		(LS1X_RTC_REGS(0))
+#define SYS_TOYWRITE0		(LS1X_RTC_REGS(4))
+#define SYS_TOYWRITE1		(LS1X_RTC_REGS(8))
+#define SYS_TOYREAD0		(LS1X_RTC_REGS(0xC))
+#define SYS_TOYREAD1		(LS1X_RTC_REGS(0x10))
+#define SYS_TOYMATCH0		(LS1X_RTC_REGS(0x14))
+#define SYS_TOYMATCH1		(LS1X_RTC_REGS(0x18))
+#define SYS_TOYMATCH2		(LS1X_RTC_REGS(0x1C))
+
+/* Programmable Counter 1 Registers */
+#define SYS_RTCTRIM		(LS1X_RTC_REGS(0x40))
+#define SYS_RTCWRITE0		(LS1X_RTC_REGS(0x44))
+#define SYS_RTCREAD0		(LS1X_RTC_REGS(0x48))
+#define SYS_RTCMATCH0		(LS1X_RTC_REGS(0x4C))
+#define SYS_RTCMATCH1		(LS1X_RTC_REGS(0x50))
+#define SYS_RTCMATCH2		(LS1X_RTC_REGS(0x54))
+
+#define LS1X_SEC_OFFSET		(4)
+#define LS1X_MIN_OFFSET		(10)
+#define LS1X_HOUR_OFFSET	(16)
+#define LS1X_DAY_OFFSET		(21)
+#define LS1X_MONTH_OFFSET	(26)
+
+
+#define LS1X_SEC_MASK		(0x3f)
+#define LS1X_MIN_MASK		(0x3f)
+#define LS1X_HOUR_MASK		(0x1f)
+#define LS1X_DAY_MASK		(0x1f)
+#define LS1X_MONTH_MASK		(0x3f)
+#define LS1X_YEAR_MASK		(0xffffffff)
+
+#define ls1x_get_sec(t)		(((t) >> LS1X_SEC_OFFSET) & LS1X_SEC_MASK)
+#define ls1x_get_min(t)		(((t) >> LS1X_MIN_OFFSET) & LS1X_MIN_MASK)
+#define ls1x_get_hour(t)	(((t) >> LS1X_HOUR_OFFSET) & LS1X_HOUR_MASK)
+#define ls1x_get_day(t)		(((t) >> LS1X_DAY_OFFSET) & LS1X_DAY_MASK)
+#define ls1x_get_month(t)	(((t) >> LS1X_MONTH_OFFSET) & LS1X_MONTH_MASK)
+
+#define RTC_CNTR_OK (SYS_CNTRL_E0 | SYS_CNTRL_32S)
+
+static int ls1x_rtc_read_time(struct device *dev, struct rtc_time *rtm)
+{
+	unsigned long v, t;
+
+	v = readl(SYS_TOYREAD0);
+	t = readl(SYS_TOYREAD1);
+
+	memset(rtm, 0, sizeof(struct rtc_time));
+	t  = mktime((t & LS1X_YEAR_MASK), ls1x_get_month(v),
+			ls1x_get_day(v), ls1x_get_hour(v),
+			ls1x_get_min(v), ls1x_get_sec(v));
+	rtc_time_to_tm(t, rtm);
+
+	return rtc_valid_tm(rtm);
+}
+
+static int ls1x_rtc_set_time(struct device *dev, struct  rtc_time *rtm)
+{
+	unsigned long v, t, c;
+	int ret = -ETIMEDOUT;
+
+	v = ((rtm->tm_mon + 1)  << LS1X_MONTH_OFFSET)
+		| (rtm->tm_mday << LS1X_DAY_OFFSET)
+		| (rtm->tm_hour << LS1X_HOUR_OFFSET)
+		| (rtm->tm_min  << LS1X_MIN_OFFSET)
+		| (rtm->tm_sec  << LS1X_SEC_OFFSET);
+
+	writel(v, SYS_TOYWRITE0);
+	c = 0x10000;
+	/* add timeout check counter, for more safe */
+	while ((readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_TS) && --c)
+		usleep_range(1000, 3000);
+
+	if (!c) {
+		dev_err(dev, "set time timeout!\n");
+		goto err;
+	}
+
+	t = rtm->tm_year + 1900;
+	writel(t, SYS_TOYWRITE1);
+	c = 0x10000;
+	while ((readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_TS) && --c)
+		usleep_range(1000, 3000);
+
+	if (!c) {
+		dev_err(dev, "set time timeout!\n");
+		goto err;
+	}
+	return 0;
+err:
+	return ret;
+}
+
+static struct rtc_class_ops  ls1x_rtc_ops = {
+	.read_time	= ls1x_rtc_read_time,
+	.set_time	= ls1x_rtc_set_time,
+};
+
+static int __devinit ls1x_rtc_probe(struct platform_device *pdev)
+{
+	struct rtc_device *rtcdev;
+	unsigned long v;
+	int ret;
+
+	v = readl(SYS_COUNTER_CNTRL);
+	if (!(v & RTC_CNTR_OK)) {
+		dev_err(&pdev->dev, "rtc counters not working\n");
+		ret = -ENODEV;
+		goto err;
+	}
+	ret = -ETIMEDOUT;
+	/* set to 1 HZ if needed */
+	if (readl(SYS_TOYTRIM) != 32767) {
+		v = 0x100000;
+		while ((readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_TTS) && --v)
+			usleep_range(1000, 3000);
+
+		if (!v) {
+			dev_err(&pdev->dev, "time out\n");
+			goto err;
+		}
+		writel(32767, SYS_TOYTRIM);
+	}
+	/* this loop coundn't be endless */
+	while (readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_TTS)
+		usleep_range(1000, 3000);
+
+	rtcdev = rtc_device_register("ls1x-rtc", &pdev->dev,
+					&ls1x_rtc_ops , THIS_MODULE);
+	if (IS_ERR(rtcdev)) {
+		ret = PTR_ERR(rtcdev);
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, rtcdev);
+	return 0;
+err:
+	return ret;
+}
+
+static int __devexit ls1x_rtc_remove(struct platform_device *pdev)
+{
+	struct rtc_device *rtcdev = platform_get_drvdata(pdev);
+
+	rtc_device_unregister(rtcdev);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver  ls1x_rtc_driver = {
+	.driver		= {
+		.name	= "ls1x-rtc",
+		.owner	= THIS_MODULE,
+	},
+	.remove		= __devexit_p(ls1x_rtc_remove),
+	.probe		= ls1x_rtc_probe,
+};
+
+module_platform_driver(ls1x_rtc_driver);
+
+MODULE_AUTHOR("zhao zhang <zhzhl555@gmail.com>");
+MODULE_LICENSE("GPL");
+
_

Patches currently in -mm which might be from zhzhl555@gmail.com are

origin.patch

