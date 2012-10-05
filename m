From: akpm@linux-foundation.org
Subject: [merged] rtc-snvs-add-freescale-rtc-snvs-driver.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:16:38 -0700
Message-ID: <20121005201639.33DE25C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:47280 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab2JEUQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:16:41 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so139871wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:16:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shawn.guo@linaro.org, a.zummo@towertech.it, kim.phillips@freescale.com, s.hauer@pengutronix.de, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: snvs: add Freescale rtc-snvs driver
has been removed from the -mm tree.  Its filename was
     rtc-snvs-add-freescale-rtc-snvs-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shawn Guo <shawn.guo@linaro.org>
Subject: rtc: snvs: add Freescale rtc-snvs driver

Add an RTC driver for Freescale Secure Non-Volatile Storage (SNVS)
Low Power (LP) RTC.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kim Phillips <kim.phillips@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/crypto/fsl-sec4.txt |   51 +
 Documentation/devicetree/bindings/rtc/snvs-rtc.txt    |    1 
 drivers/rtc/Kconfig                                   |   11 
 drivers/rtc/Makefile                                  |    1 
 drivers/rtc/rtc-snvs.c                                |  350 ++++++++++
 5 files changed, 414 insertions(+)

diff -puN Documentation/devicetree/bindings/crypto/fsl-sec4.txt~rtc-snvs-add-freescale-rtc-snvs-driver Documentation/devicetree/bindings/crypto/fsl-sec4.txt
--- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt~rtc-snvs-add-freescale-rtc-snvs-driver
+++ a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
@@ -9,6 +9,7 @@ Copyright (C) 2008-2011 Freescale Semico
    -Run Time Integrity Check (RTIC) Node
    -Run Time Integrity Check (RTIC) Memory Node
    -Secure Non-Volatile Storage (SNVS) Node
+   -Secure Non-Volatile Storage (SNVS) Low Power (LP) RTC Node
    -Full Example
 
 NOTE: the SEC 4 is also known as Freescale's Cryptographic Accelerator
@@ -294,6 +295,27 @@ Secure Non-Volatile Storage (SNVS) Node
           address and length of the SEC4 configuration
           registers.
 
+   - #address-cells
+       Usage: required
+       Value type: <u32>
+       Definition: A standard property.  Defines the number of cells
+           for representing physical addresses in child nodes.  Must
+           have a value of 1.
+
+   - #size-cells
+       Usage: required
+       Value type: <u32>
+       Definition: A standard property.  Defines the number of cells
+           for representing the size of physical addresses in
+           child nodes.  Must have a value of 1.
+
+   - ranges
+       Usage: required
+       Value type: <prop-encoded-array>
+       Definition: A standard property.  Specifies the physical address
+           range of the SNVS register space.  A triplet that includes
+           the child address, parent address, & length.
+
    - interrupts
       Usage: required
       Value type: <prop_encoded-array>
@@ -314,11 +336,34 @@ EXAMPLE
 	sec_mon@314000 {
 		compatible = "fsl,sec-v4.0-mon";
 		reg = <0x314000 0x1000>;
+		ranges = <0 0x314000 0x1000>;
 		interrupt-parent = <&mpic>;
 		interrupts = <93 2>;
 	};
 
 =====================================================================
+Secure Non-Volatile Storage (SNVS) Low Power (LP) RTC Node
+
+  A SNVS child node that defines SNVS LP RTC.
+
+  - compatible
+      Usage: required
+      Value type: <string>
+      Definition: Must include "fsl,sec-v4.0-mon-rtc-lp".
+
+  - reg
+      Usage: required
+      Value type: <prop-encoded-array>
+      Definition: A standard property.  Specifies the physical
+          address and length of the SNVS LP configuration registers.
+
+EXAMPLE
+	sec_mon_rtc_lp@314000 {
+		compatible = "fsl,sec-v4.0-mon-rtc-lp";
+		reg = <0x34 0x58>;
+	};
+
+=====================================================================
 FULL EXAMPLE
 
 	crypto: crypto@300000 {
@@ -390,8 +435,14 @@ FULL EXAMPLE
 	sec_mon: sec_mon@314000 {
 		compatible = "fsl,sec-v4.0-mon";
 		reg = <0x314000 0x1000>;
+		ranges = <0 0x314000 0x1000>;
 		interrupt-parent = <&mpic>;
 		interrupts = <93 2>;
+
+		sec_mon_rtc_lp@34 {
+			compatible = "fsl,sec-v4.0-mon-rtc-lp";
+			reg = <0x34 0x58>;
+		};
 	};
 
 =====================================================================
diff -puN /dev/null Documentation/devicetree/bindings/rtc/snvs-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/snvs-rtc.txt
@@ -0,0 +1 @@
+See Documentation/devicetree/bindings/crypto/fsl-sec4.txt for details.
diff -puN drivers/rtc/Kconfig~rtc-snvs-add-freescale-rtc-snvs-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-snvs-add-freescale-rtc-snvs-driver
+++ a/drivers/rtc/Kconfig
@@ -1109,4 +1109,15 @@ config RTC_DRV_MXC
 	   This driver can also be built as a module, if so, the module
 	   will be called "rtc-mxc".
 
+config RTC_DRV_SNVS
+	tristate "Freescale SNVS RTC support"
+	depends on HAS_IOMEM
+	depends on OF
+	help
+	   If you say yes here you get support for the Freescale SNVS
+	   Low Power (LP) RTC module.
+
+	   This driver can also be built as a module, if so, the module
+	   will be called "rtc-snvs".
+
 endif # RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-snvs-add-freescale-rtc-snvs-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-snvs-add-freescale-rtc-snvs-driver
+++ a/drivers/rtc/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_RTC_DRV_S35390A)	+= rtc-s35
 obj-$(CONFIG_RTC_DRV_S3C)	+= rtc-s3c.o
 obj-$(CONFIG_RTC_DRV_SA1100)	+= rtc-sa1100.o
 obj-$(CONFIG_RTC_DRV_SH)	+= rtc-sh.o
+obj-$(CONFIG_RTC_DRV_SNVS)	+= rtc-snvs.o
 obj-$(CONFIG_RTC_DRV_SPEAR)	+= rtc-spear.o
 obj-$(CONFIG_RTC_DRV_STARFIRE)	+= rtc-starfire.o
 obj-$(CONFIG_RTC_DRV_STK17TA8)	+= rtc-stk17ta8.o
diff -puN /dev/null drivers/rtc/rtc-snvs.c
--- /dev/null
+++ a/drivers/rtc/rtc-snvs.c
@@ -0,0 +1,350 @@
+/*
+ * Copyright (C) 2011-2012 Freescale Semiconductor, Inc.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+
+/* These register offsets are relative to LP (Low Power) range */
+#define SNVS_LPCR		0x04
+#define SNVS_LPSR		0x18
+#define SNVS_LPSRTCMR		0x1c
+#define SNVS_LPSRTCLR		0x20
+#define SNVS_LPTAR		0x24
+#define SNVS_LPPGDR		0x30
+
+#define SNVS_LPCR_SRTC_ENV	(1 << 0)
+#define SNVS_LPCR_LPTA_EN	(1 << 1)
+#define SNVS_LPCR_LPWUI_EN	(1 << 3)
+#define SNVS_LPSR_LPTA		(1 << 0)
+
+#define SNVS_LPPGDR_INIT	0x41736166
+#define CNTR_TO_SECS_SH		15
+
+struct snvs_rtc_data {
+	struct rtc_device *rtc;
+	void __iomem *ioaddr;
+	int irq;
+	spinlock_t lock;
+};
+
+static u32 rtc_read_lp_counter(void __iomem *ioaddr)
+{
+	u64 read1, read2;
+
+	do {
+		read1 = readl(ioaddr + SNVS_LPSRTCMR);
+		read1 <<= 32;
+		read1 |= readl(ioaddr + SNVS_LPSRTCLR);
+
+		read2 = readl(ioaddr + SNVS_LPSRTCMR);
+		read2 <<= 32;
+		read2 |= readl(ioaddr + SNVS_LPSRTCLR);
+	} while (read1 != read2);
+
+	/* Convert 47-bit counter to 32-bit raw second count */
+	return (u32) (read1 >> CNTR_TO_SECS_SH);
+}
+
+static void rtc_write_sync_lp(void __iomem *ioaddr)
+{
+	u32 count1, count2, count3;
+	int i;
+
+	/* Wait for 3 CKIL cycles */
+	for (i = 0; i < 3; i++) {
+		do {
+			count1 = readl(ioaddr + SNVS_LPSRTCLR);
+			count2 = readl(ioaddr + SNVS_LPSRTCLR);
+		} while (count1 != count2);
+
+		/* Now wait until counter value changes */
+		do {
+			do {
+				count2 = readl(ioaddr + SNVS_LPSRTCLR);
+				count3 = readl(ioaddr + SNVS_LPSRTCLR);
+			} while (count2 != count3);
+		} while (count3 == count1);
+	}
+}
+
+static int snvs_rtc_enable(struct snvs_rtc_data *data, bool enable)
+{
+	unsigned long flags;
+	int timeout = 1000;
+	u32 lpcr;
+
+	spin_lock_irqsave(&data->lock, flags);
+
+	lpcr = readl(data->ioaddr + SNVS_LPCR);
+	if (enable)
+		lpcr |= SNVS_LPCR_SRTC_ENV;
+	else
+		lpcr &= ~SNVS_LPCR_SRTC_ENV;
+	writel(lpcr, data->ioaddr + SNVS_LPCR);
+
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	while (--timeout) {
+		lpcr = readl(data->ioaddr + SNVS_LPCR);
+
+		if (enable) {
+			if (lpcr & SNVS_LPCR_SRTC_ENV)
+				break;
+		} else {
+			if (!(lpcr & SNVS_LPCR_SRTC_ENV))
+				break;
+		}
+	}
+
+	if (!timeout)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int snvs_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct snvs_rtc_data *data = dev_get_drvdata(dev);
+	unsigned long time = rtc_read_lp_counter(data->ioaddr);
+
+	rtc_time_to_tm(time, tm);
+
+	return 0;
+}
+
+static int snvs_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct snvs_rtc_data *data = dev_get_drvdata(dev);
+	unsigned long time;
+
+	rtc_tm_to_time(tm, &time);
+
+	/* Disable RTC first */
+	snvs_rtc_enable(data, false);
+
+	/* Write 32-bit time to 47-bit timer, leaving 15 LSBs blank */
+	writel(time << CNTR_TO_SECS_SH, data->ioaddr + SNVS_LPSRTCLR);
+	writel(time >> (32 - CNTR_TO_SECS_SH), data->ioaddr + SNVS_LPSRTCMR);
+
+	/* Enable RTC again */
+	snvs_rtc_enable(data, true);
+
+	return 0;
+}
+
+static int snvs_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct snvs_rtc_data *data = dev_get_drvdata(dev);
+	u32 lptar, lpsr;
+
+	lptar = readl(data->ioaddr + SNVS_LPTAR);
+	rtc_time_to_tm(lptar, &alrm->time);
+
+	lpsr = readl(data->ioaddr + SNVS_LPSR);
+	alrm->pending = (lpsr & SNVS_LPSR_LPTA) ? 1 : 0;
+
+	return 0;
+}
+
+static int snvs_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
+{
+	struct snvs_rtc_data *data = dev_get_drvdata(dev);
+	u32 lpcr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+
+	lpcr = readl(data->ioaddr + SNVS_LPCR);
+	if (enable)
+		lpcr |= (SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN);
+	else
+		lpcr &= ~(SNVS_LPCR_LPTA_EN | SNVS_LPCR_LPWUI_EN);
+	writel(lpcr, data->ioaddr + SNVS_LPCR);
+
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	rtc_write_sync_lp(data->ioaddr);
+
+	return 0;
+}
+
+static int snvs_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct snvs_rtc_data *data = dev_get_drvdata(dev);
+	struct rtc_time *alrm_tm = &alrm->time;
+	unsigned long time;
+	unsigned long flags;
+	u32 lpcr;
+
+	rtc_tm_to_time(alrm_tm, &time);
+
+	spin_lock_irqsave(&data->lock, flags);
+
+	/* Have to clear LPTA_EN before programming new alarm time in LPTAR */
+	lpcr = readl(data->ioaddr + SNVS_LPCR);
+	lpcr &= ~SNVS_LPCR_LPTA_EN;
+	writel(lpcr, data->ioaddr + SNVS_LPCR);
+
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	writel(time, data->ioaddr + SNVS_LPTAR);
+
+	/* Clear alarm interrupt status bit */
+	writel(SNVS_LPSR_LPTA, data->ioaddr + SNVS_LPSR);
+
+	return snvs_rtc_alarm_irq_enable(dev, alrm->enabled);
+}
+
+static const struct rtc_class_ops snvs_rtc_ops = {
+	.read_time = snvs_rtc_read_time,
+	.set_time = snvs_rtc_set_time,
+	.read_alarm = snvs_rtc_read_alarm,
+	.set_alarm = snvs_rtc_set_alarm,
+	.alarm_irq_enable = snvs_rtc_alarm_irq_enable,
+};
+
+static irqreturn_t snvs_rtc_irq_handler(int irq, void *dev_id)
+{
+	struct device *dev = dev_id;
+	struct snvs_rtc_data *data = dev_get_drvdata(dev);
+	u32 lpsr;
+	u32 events = 0;
+
+	lpsr = readl(data->ioaddr + SNVS_LPSR);
+
+	if (lpsr & SNVS_LPSR_LPTA) {
+		events |= (RTC_AF | RTC_IRQF);
+
+		/* RTC alarm should be one-shot */
+		snvs_rtc_alarm_irq_enable(dev, 0);
+
+		rtc_update_irq(data->rtc, 1, events);
+	}
+
+	/* clear interrupt status */
+	writel(lpsr, data->ioaddr + SNVS_LPSR);
+
+	return events ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static int __devinit snvs_rtc_probe(struct platform_device *pdev)
+{
+	struct snvs_rtc_data *data;
+	struct resource *res;
+	int ret;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	data->ioaddr = devm_request_and_ioremap(&pdev->dev, res);
+	if (!data->ioaddr)
+		return -EADDRNOTAVAIL;
+
+	data->irq = platform_get_irq(pdev, 0);
+	if (data->irq < 0)
+		return data->irq;
+
+	platform_set_drvdata(pdev, data);
+
+	spin_lock_init(&data->lock);
+
+	/* Initialize glitch detect */
+	writel(SNVS_LPPGDR_INIT, data->ioaddr + SNVS_LPPGDR);
+
+	/* Clear interrupt status */
+	writel(0xffffffff, data->ioaddr + SNVS_LPSR);
+
+	/* Enable RTC */
+	snvs_rtc_enable(data, true);
+
+	device_init_wakeup(&pdev->dev, true);
+
+	ret = devm_request_irq(&pdev->dev, data->irq, snvs_rtc_irq_handler,
+			       IRQF_SHARED, "rtc alarm", &pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to request irq %d: %d\n",
+			data->irq, ret);
+		return ret;
+	}
+
+	data->rtc = rtc_device_register(pdev->name, &pdev->dev,
+					&snvs_rtc_ops, THIS_MODULE);
+	if (IS_ERR(data->rtc)) {
+		ret = PTR_ERR(data->rtc);
+		dev_err(&pdev->dev, "failed to register rtc: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __devexit snvs_rtc_remove(struct platform_device *pdev)
+{
+	struct snvs_rtc_data *data = platform_get_drvdata(pdev);
+
+	rtc_device_unregister(data->rtc);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int snvs_rtc_suspend(struct device *dev)
+{
+	struct snvs_rtc_data *data = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(data->irq);
+
+	return 0;
+}
+
+static int snvs_rtc_resume(struct device *dev)
+{
+	struct snvs_rtc_data *data = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(data->irq);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(snvs_rtc_pm_ops, snvs_rtc_suspend, snvs_rtc_resume);
+
+static const struct of_device_id __devinitconst snvs_dt_ids[] = {
+	{ .compatible = "fsl,sec-v4.0-mon-rtc-lp", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, snvs_dt_ids);
+
+static struct platform_driver snvs_rtc_driver = {
+	.driver = {
+		.name	= "snvs_rtc",
+		.owner	= THIS_MODULE,
+		.pm	= &snvs_rtc_pm_ops,
+		.of_match_table = snvs_dt_ids,
+	},
+	.probe		= snvs_rtc_probe,
+	.remove		= __devexit_p(snvs_rtc_remove),
+};
+module_platform_driver(snvs_rtc_driver);
+
+MODULE_AUTHOR("Freescale Semiconductor, Inc.");
+MODULE_DESCRIPTION("Freescale SNVS RTC Driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from shawn.guo@linaro.org are

origin.patch
linux-next.patch

