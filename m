From: akpm@linux-foundation.org
Subject: + drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch added to -mm
 tree
Date: Thu, 10 Apr 2014 16:24:53 -0700
Message-ID: <53472845.inYNTM79J5LLPeUd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268AbaDJXYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Apr 2014 19:24:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, rsahu@apm.com, jcm@redhat.com, catalin.marinas@arm.com, a.zummo@towertech.it, lho@apm.com

Subject: + drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch added to -mm tree
To: lho@apm.com,a.zummo@towertech.it,catalin.marinas@arm.com,jcm@redhat.com,rsahu@apm.com,will.deacon@arm.com
From: akpm@linux-foundation.org
Date: Thu, 10 Apr 2014 16:24:53 -0700


The patch titled
     Subject: drivers/rtc: add APM X-Gene SoC RTC driver
has been added to the -mm tree.  Its filename is
     drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Loc Ho <lho@apm.com>
Subject: drivers/rtc: add APM X-Gene SoC RTC driver

Add support for the APM X-Gene SoC RTC driver.

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
Signed-off-by: Loc Ho <lho@apm.com>
Cc: Jon Masters <jcm@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig     |    9 +
 drivers/rtc/Makefile    |    1 
 drivers/rtc/rtc-xgene.c |  278 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 288 insertions(+)

diff -puN drivers/rtc/Kconfig~drivers-rtc-add-apm-x-gene-soc-rtc-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-add-apm-x-gene-soc-rtc-driver
+++ a/drivers/rtc/Kconfig
@@ -1327,6 +1327,15 @@ config RTC_DRV_MOXART
 	   This driver can also be built as a module. If so, the module
 	   will be called rtc-moxart
 
+config RTC_DRV_XGENE
+	tristate "APM X-Gene RTC"
+	help
+	  If you say yes here you get support for the APM X-Gene SoC real time
+	  clock.
+
+	  This driver can also be built as a module, if so, the module
+	  will be called "rtc-xgene".
+
 comment "HID Sensor RTC drivers"
 
 config RTC_DRV_HID_SENSOR_TIME
diff -puN drivers/rtc/Makefile~drivers-rtc-add-apm-x-gene-soc-rtc-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~drivers-rtc-add-apm-x-gene-soc-rtc-driver
+++ a/drivers/rtc/Makefile
@@ -135,5 +135,6 @@ obj-$(CONFIG_RTC_DRV_VT8500)	+= rtc-vt85
 obj-$(CONFIG_RTC_DRV_WM831X)	+= rtc-wm831x.o
 obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
+obj-$(CONFIG_RTC_DRV_XGENE)	+= rtc-xgene.o
 obj-$(CONFIG_RTC_DRV_SIRFSOC)	+= rtc-sirfsoc.o
 obj-$(CONFIG_RTC_DRV_MOXART)	+= rtc-moxart.o
diff -puN /dev/null drivers/rtc/rtc-xgene.c
--- /dev/null
+++ a/drivers/rtc/rtc-xgene.c
@@ -0,0 +1,278 @@
+/*
+ * APM X-Gene SoC Real Time Clock Driver
+ *
+ * Copyright (c) 2014, Applied Micro Circuits Corporation
+ * Author: Rameshwar Prasad Sahu <rsahu@apm.com>
+ *         Loc Ho <lho@apm.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/rtc.h>
+
+/* RTC CSR Registers */
+#define RTC_CCVR		0x00
+#define RTC_CMR			0x04
+#define RTC_CLR			0x08
+#define RTC_CCR			0x0C
+#define  RTC_CCR_IE		BIT(0)
+#define  RTC_CCR_MASK		BIT(1)
+#define  RTC_CCR_EN		BIT(2)
+#define  RTC_CCR_WEN		BIT(3)
+#define RTC_STAT		0x10
+#define  RTC_STAT_BIT		BIT(0)
+#define RTC_RSTAT		0x14
+#define RTC_EOI			0x18
+#define RTC_VER			0x1C
+
+struct xgene_rtc_dev {
+	struct rtc_device *rtc;
+	struct device *dev;
+	unsigned long alarm_time;
+	void __iomem *csr_base;
+	struct clk *clk;
+	unsigned int irq_wake;
+};
+
+static int xgene_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct xgene_rtc_dev *pdata = dev_get_drvdata(dev);
+
+	rtc_time_to_tm(readl(pdata->csr_base + RTC_CCVR), tm);
+	return rtc_valid_tm(tm);
+}
+
+static int xgene_rtc_set_mmss(struct device *dev, unsigned long secs)
+{
+	struct xgene_rtc_dev *pdata = dev_get_drvdata(dev);
+
+	/*
+	 * NOTE: After the following write, the RTC_CCVR is only reflected
+	 *       after the update cycle of 1 seconds.
+	 */
+	writel((u32) secs, pdata->csr_base + RTC_CLR);
+	readl(pdata->csr_base + RTC_CLR); /* Force a barrier */
+
+	return 0;
+}
+
+static int xgene_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct xgene_rtc_dev *pdata = dev_get_drvdata(dev);
+
+	rtc_time_to_tm(pdata->alarm_time, &alrm->time);
+	alrm->enabled = readl(pdata->csr_base + RTC_CCR) & RTC_CCR_IE;
+
+	return 0;
+}
+
+static int xgene_rtc_alarm_irq_enable(struct device *dev, u32 enabled)
+{
+	struct xgene_rtc_dev *pdata = dev_get_drvdata(dev);
+	u32 ccr;
+
+	ccr = readl(pdata->csr_base + RTC_CCR);
+	if (enabled) {
+		ccr &= ~RTC_CCR_MASK;
+		ccr |= RTC_CCR_IE;
+	} else {
+		ccr &= ~RTC_CCR_IE;
+		ccr |= RTC_CCR_MASK;
+	}
+	writel(ccr, pdata->csr_base + RTC_CCR);
+
+	return 0;
+}
+
+static int xgene_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct xgene_rtc_dev *pdata = dev_get_drvdata(dev);
+	unsigned long rtc_time;
+	unsigned long alarm_time;
+
+	rtc_time = readl(pdata->csr_base + RTC_CCVR);
+	rtc_tm_to_time(&alrm->time, &alarm_time);
+
+	pdata->alarm_time = alarm_time;
+	writel((u32) pdata->alarm_time, pdata->csr_base + RTC_CMR);
+
+	xgene_rtc_alarm_irq_enable(dev, alrm->enabled);
+
+	return 0;
+}
+
+static const struct rtc_class_ops xgene_rtc_ops = {
+	.read_time	= xgene_rtc_read_time,
+	.set_mmss	= xgene_rtc_set_mmss,
+	.read_alarm	= xgene_rtc_read_alarm,
+	.set_alarm	= xgene_rtc_set_alarm,
+	.alarm_irq_enable = xgene_rtc_alarm_irq_enable,
+};
+
+static irqreturn_t xgene_rtc_interrupt(int irq, void *id)
+{
+	struct xgene_rtc_dev *pdata = (struct xgene_rtc_dev *) id;
+
+	/* Check if interrupt asserted */
+	if (!(readl(pdata->csr_base + RTC_STAT) & RTC_STAT_BIT))
+		return IRQ_NONE;
+
+	/* Clear interrupt */
+	readl(pdata->csr_base + RTC_EOI);
+
+	rtc_update_irq(pdata->rtc, 1, RTC_IRQF | RTC_AF);
+
+	return IRQ_HANDLED;
+}
+
+static int xgene_rtc_probe(struct platform_device *pdev)
+{
+	struct xgene_rtc_dev *pdata;
+	struct resource *res;
+	int ret;
+	int irq;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, pdata);
+	pdata->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pdata->csr_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pdata->csr_base))
+		return PTR_ERR(pdata->csr_base);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "No IRQ resource\n");
+		return irq;
+	}
+	ret = devm_request_irq(&pdev->dev, irq, xgene_rtc_interrupt, 0,
+			       dev_name(&pdev->dev), pdata);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not request IRQ\n");
+		return ret;
+	}
+
+	pdata->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(pdata->clk)) {
+		dev_err(&pdev->dev, "Couldn't get the clock for RTC\n");
+		return -ENODEV;
+	}
+	clk_prepare_enable(pdata->clk);
+
+	/* Turn on the clock and the crystal */
+	writel(RTC_CCR_EN, pdata->csr_base + RTC_CCR);
+
+	device_init_wakeup(&pdev->dev, 1);
+
+	pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					 &xgene_rtc_ops, THIS_MODULE);
+	if (IS_ERR(pdata->rtc)) {
+		clk_disable_unprepare(pdata->clk);
+		return PTR_ERR(pdata->rtc);
+	}
+
+	/* HW does not support update faster than 1 seconds */
+	pdata->rtc->uie_unsupported = 1;
+
+	return 0;
+}
+
+static int xgene_rtc_remove(struct platform_device *pdev)
+{
+	struct xgene_rtc_dev *pdata = platform_get_drvdata(pdev);
+
+	xgene_rtc_alarm_irq_enable(&pdev->dev, 0);
+	device_init_wakeup(&pdev->dev, 0);
+	clk_disable_unprepare(pdata->clk);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int xgene_rtc_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct xgene_rtc_dev *pdata = platform_get_drvdata(pdev);
+	int irq;
+
+	irq = platform_get_irq(pdev, 0);
+	if (device_may_wakeup(&pdev->dev)) {
+		if (!enable_irq_wake(irq))
+			pdata->irq_wake = 1;
+	} else {
+		xgene_rtc_alarm_irq_enable(dev, 0);
+		clk_disable(pdata->clk);
+	}
+
+	return 0;
+}
+
+static int xgene_rtc_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct xgene_rtc_dev *pdata = platform_get_drvdata(pdev);
+	int irq;
+
+	irq = platform_get_irq(pdev, 0);
+	if (device_may_wakeup(&pdev->dev)) {
+		if (pdata->irq_wake) {
+			disable_irq_wake(irq);
+			pdata->irq_wake = 0;
+		}
+	} else {
+		clk_enable(pdata->clk);
+		xgene_rtc_alarm_irq_enable(dev, 1);
+	}
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(xgene_rtc_pm_ops, xgene_rtc_suspend, xgene_rtc_resume);
+
+#ifdef CONFIG_OF
+static const struct of_device_id xgene_rtc_of_match[] = {
+	{.compatible = "apm,xgene-rtc" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, xgene_rtc_of_match);
+#endif
+
+static struct platform_driver xgene_rtc_driver = {
+	.probe		= xgene_rtc_probe,
+	.remove		= xgene_rtc_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "xgene-rtc",
+		.pm = &xgene_rtc_pm_ops,
+		.of_match_table	= of_match_ptr(xgene_rtc_of_match),
+	},
+};
+
+module_platform_driver(xgene_rtc_driver);
+
+MODULE_DESCRIPTION("APM X-Gene SoC RTC driver");
+MODULE_AUTHOR("Rameshwar Sahu <rsahu@apm.com>");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from lho@apm.com are

origin.patch
documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch
drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch
arm64-add-apm-x-gene-soc-rtc-dts-entry.patch
linux-next.patch

