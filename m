From: akpm@linux-foundation.org
Subject: [merged]
 rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:18:00 -0700
Message-ID: <553550e8.kWDNjf1/Dw5HC978%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbbDTTLj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baruch@tkos.co.il, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: driver for Conexant Digicolor CX92755 on-chip RTC
has been removed from the -mm tree.  Its filename was
     rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baruch Siach <baruch@tkos.co.il>
Subject: rtc: driver for Conexant Digicolor CX92755 on-chip RTC

Add driver for the RTC hardware block on the Conexant CX92755 SoC, from
the Digicolor series of SoCs.  Tested on the Equinox evaluation board for
the CX92755 chip.

[akpm@linux-foundation.org: build command arrays at compile-time]
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig         |   10 +
 drivers/rtc/Makefile        |    1 
 drivers/rtc/rtc-digicolor.c |  227 ++++++++++++++++++++++++++++++++++
 3 files changed, 238 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc
+++ a/drivers/rtc/Kconfig
@@ -1111,6 +1111,16 @@ config RTC_DRV_DAVINCI
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-davinci.
 
+config RTC_DRV_DIGICOLOR
+	tristate "Conexant Digicolor RTC"
+	depends on ARCH_DIGICOLOR
+	help
+	  If you say yes here you get support for the RTC on Conexant
+	  Digicolor platforms. This currently includes the CX92755 SoC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-digicolor.
+
 config RTC_DRV_IMXDI
 	tristate "Freescale IMX DryIce Real Time Clock"
 	depends on ARCH_MXC
diff -puN drivers/rtc/Makefile~rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc
+++ a/drivers/rtc/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_RTC_DRV_DA9052)	+= rtc-da90
 obj-$(CONFIG_RTC_DRV_DA9055)	+= rtc-da9055.o
 obj-$(CONFIG_RTC_DRV_DA9063)	+= rtc-da9063.o
 obj-$(CONFIG_RTC_DRV_DAVINCI)	+= rtc-davinci.o
+obj-$(CONFIG_RTC_DRV_DIGICOLOR)	+= rtc-digicolor.o
 obj-$(CONFIG_RTC_DRV_DM355EVM)	+= rtc-dm355evm.o
 obj-$(CONFIG_RTC_DRV_VRTC)	+= rtc-mrst.o
 obj-$(CONFIG_RTC_DRV_DS1216)	+= rtc-ds1216.o
diff -puN /dev/null drivers/rtc/rtc-digicolor.c
--- /dev/null
+++ a/drivers/rtc/rtc-digicolor.c
@@ -0,0 +1,227 @@
+/*
+ * Real Time Clock driver for Conexant Digicolor
+ *
+ * Copyright (C) 2015 Paradox Innovation Ltd.
+ *
+ * Author: Baruch Siach <baruch@tkos.co.il>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/of.h>
+
+#define DC_RTC_CONTROL		0x0
+#define DC_RTC_TIME		0x8
+#define DC_RTC_REFERENCE	0xc
+#define DC_RTC_ALARM		0x10
+#define DC_RTC_INTFLAG_CLEAR	0x14
+#define DC_RTC_INTENABLE	0x16
+
+#define DC_RTC_CMD_MASK		0xf
+#define DC_RTC_GO_BUSY		BIT(7)
+
+#define CMD_NOP			0
+#define CMD_RESET		1
+#define CMD_WRITE		3
+#define CMD_READ		4
+
+#define CMD_DELAY_US		(10*1000)
+#define CMD_TIMEOUT_US		(500*CMD_DELAY_US)
+
+struct dc_rtc {
+	struct rtc_device	*rtc_dev;
+	void __iomem		*regs;
+};
+
+static int dc_rtc_cmds(struct dc_rtc *rtc, const u8 *cmds, int len)
+{
+	u8 val;
+	int i, ret;
+
+	for (i = 0; i < len; i++) {
+		writeb_relaxed((cmds[i] & DC_RTC_CMD_MASK) | DC_RTC_GO_BUSY,
+			       rtc->regs + DC_RTC_CONTROL);
+		ret = readb_relaxed_poll_timeout(
+			rtc->regs + DC_RTC_CONTROL, val,
+			!(val & DC_RTC_GO_BUSY), CMD_DELAY_US, CMD_TIMEOUT_US);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int dc_rtc_read(struct dc_rtc *rtc, unsigned long *val)
+{
+	static const u8 read_cmds[] = {CMD_READ, CMD_NOP};
+	u32 reference, time1, time2;
+	int ret;
+
+	ret = dc_rtc_cmds(rtc, read_cmds, ARRAY_SIZE(read_cmds));
+	if (ret < 0)
+		return ret;
+
+	reference = readl_relaxed(rtc->regs + DC_RTC_REFERENCE);
+	time1 = readl_relaxed(rtc->regs + DC_RTC_TIME);
+	/* Read twice to ensure consistency */
+	while (1) {
+		time2 = readl_relaxed(rtc->regs + DC_RTC_TIME);
+		if (time1 == time2)
+			break;
+		time1 = time2;
+	}
+
+	*val = reference + time1;
+	return 0;
+}
+
+static int dc_rtc_write(struct dc_rtc *rtc, u32 val)
+{
+	static const u8 write_cmds[] = {CMD_WRITE, CMD_NOP, CMD_RESET, CMD_NOP};
+
+	writel_relaxed(val, rtc->regs + DC_RTC_REFERENCE);
+	return dc_rtc_cmds(rtc, write_cmds, ARRAY_SIZE(write_cmds));
+}
+
+static int dc_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct dc_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long now;
+	int ret;
+
+	ret = dc_rtc_read(rtc, &now);
+	if (ret < 0)
+		return ret;
+	rtc_time64_to_tm(now, tm);
+
+	return 0;
+}
+
+static int dc_rtc_set_mmss(struct device *dev, unsigned long secs)
+{
+	struct dc_rtc *rtc = dev_get_drvdata(dev);
+
+	return dc_rtc_write(rtc, secs);
+}
+
+static int dc_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct dc_rtc *rtc = dev_get_drvdata(dev);
+	u32 alarm_reg, reference;
+	unsigned long now;
+	int ret;
+
+	alarm_reg = readl_relaxed(rtc->regs + DC_RTC_ALARM);
+	reference = readl_relaxed(rtc->regs + DC_RTC_REFERENCE);
+	rtc_time64_to_tm(reference + alarm_reg, &alarm->time);
+
+	ret = dc_rtc_read(rtc, &now);
+	if (ret < 0)
+		return ret;
+
+	alarm->pending = alarm_reg + reference > now;
+	alarm->enabled = readl_relaxed(rtc->regs + DC_RTC_INTENABLE);
+
+	return 0;
+}
+
+static int dc_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct dc_rtc *rtc = dev_get_drvdata(dev);
+	time64_t alarm_time;
+	u32 reference;
+
+	alarm_time = rtc_tm_to_time64(&alarm->time);
+
+	reference = readl_relaxed(rtc->regs + DC_RTC_REFERENCE);
+	writel_relaxed(alarm_time - reference, rtc->regs + DC_RTC_ALARM);
+
+	writeb_relaxed(!!alarm->enabled, rtc->regs + DC_RTC_INTENABLE);
+
+	return 0;
+}
+
+static int dc_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct dc_rtc *rtc = dev_get_drvdata(dev);
+
+	writeb_relaxed(!!enabled, rtc->regs + DC_RTC_INTENABLE);
+
+	return 0;
+}
+
+static struct rtc_class_ops dc_rtc_ops = {
+	.read_time		= dc_rtc_read_time,
+	.set_mmss		= dc_rtc_set_mmss,
+	.read_alarm		= dc_rtc_read_alarm,
+	.set_alarm		= dc_rtc_set_alarm,
+	.alarm_irq_enable	= dc_rtc_alarm_irq_enable,
+};
+
+static irqreturn_t dc_rtc_irq(int irq, void *dev_id)
+{
+	struct dc_rtc *rtc = dev_id;
+
+	writeb_relaxed(1, rtc->regs + DC_RTC_INTFLAG_CLEAR);
+	rtc_update_irq(rtc->rtc_dev, 1, RTC_AF | RTC_IRQF);
+
+	return IRQ_HANDLED;
+}
+
+static int __init dc_rtc_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct dc_rtc *rtc;
+	int irq, ret;
+
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rtc->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rtc->regs))
+		return PTR_ERR(rtc->regs);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+	ret = devm_request_irq(&pdev->dev, irq, dc_rtc_irq, 0, pdev->name, rtc);
+	if (ret < 0)
+		return ret;
+
+	platform_set_drvdata(pdev, rtc);
+	rtc->rtc_dev = devm_rtc_device_register(&pdev->dev, pdev->name,
+						&dc_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtc_dev))
+		return PTR_ERR(rtc->rtc_dev);
+
+	return 0;
+}
+
+static const struct of_device_id dc_dt_ids[] = {
+	{ .compatible = "cnxt,cx92755-rtc" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, dc_dt_ids);
+
+static struct platform_driver dc_rtc_driver = {
+	.driver = {
+		.name = "digicolor_rtc",
+		.of_match_table = of_match_ptr(dc_dt_ids),
+	},
+};
+module_platform_driver_probe(dc_rtc_driver, dc_rtc_probe);
+
+MODULE_AUTHOR("Baruch Siach <baruch@tkos.co.il>");
+MODULE_DESCRIPTION("Conexant Digicolor Realtime Clock Driver (RTC)");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from baruch@tkos.co.il are

origin.patch
linux-next.patch

