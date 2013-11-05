From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-as3722-add-rtc-driver.patch added to -mm tree
Date: Tue, 05 Nov 2013 15:33:37 -0800
Message-ID: <52798051./0H5v21i8d5pO5Cl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3KEXdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 18:33:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linus.walleij@linaro.org, florian.lobmaier@ams.com, broonie@kernel.org, ldewangan@nvidia.com

Subject: + drivers-rtc-rtc-as3722-add-rtc-driver.patch added to -mm tree
To: ldewangan@nvidia.com,broonie@kernel.org,florian.lobmaier@ams.com,linus.walleij@linaro.org
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 15:33:37 -0800


The patch titled
     Subject: drivers/rtc/rtc-as3722: add RTC driver
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-as3722-add-rtc-driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-as3722-add-rtc-driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-as3722-add-rtc-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-as3722: add RTC driver

The ams AS3722 is a compact system PMU suitable for mobile phones, tablets
etc.

Add a driver to support accessing the RTC found on the ams AS3722 PMIC
using RTC framework.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |   10 +
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-as3722.c |  280 +++++++++++++++++++++++++++++++++++++
 3 files changed, 291 insertions(+)

diff -puN drivers/rtc/Kconfig~drivers-rtc-rtc-as3722-add-rtc-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-rtc-as3722-add-rtc-driver
+++ a/drivers/rtc/Kconfig
@@ -153,6 +153,16 @@ config RTC_DRV_88PM80X
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-88pm80x.
 
+config RTC_DRV_AS3722
+	tristate "ams AS3722 RTC driver"
+	depends on MFD_AS3722
+	help
+	  If you say yes here you get support for the RTC of ams AS3722 PMIC
+	  chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-as3722.
+
 config RTC_DRV_DS1307
 	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00, EPSON RX-8025"
 	help
diff -puN drivers/rtc/Makefile~drivers-rtc-rtc-as3722-add-rtc-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~drivers-rtc-rtc-as3722-add-rtc-driver
+++ a/drivers/rtc/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_RTC_DRV_88PM860X)  += rtc-8
 obj-$(CONFIG_RTC_DRV_88PM80X)	+= rtc-88pm80x.o
 obj-$(CONFIG_RTC_DRV_AB3100)	+= rtc-ab3100.o
 obj-$(CONFIG_RTC_DRV_AB8500)	+= rtc-ab8500.o
+obj-$(CONFIG_RTC_DRV_AS3722)	+= rtc-as3722.o
 obj-$(CONFIG_RTC_DRV_AT32AP700X)+= rtc-at32ap700x.o
 obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-at91rm9200.o
 obj-$(CONFIG_RTC_DRV_AT91SAM9)	+= rtc-at91sam9.o
diff -puN /dev/null drivers/rtc/rtc-as3722.c
--- /dev/null
+++ a/drivers/rtc/rtc-as3722.c
@@ -0,0 +1,280 @@
+/*
+ * rtc-as3722.c - Real Time Clock driver for ams AS3722 PMICs
+ *
+ * Copyright (C) 2013 ams AG
+ * Copyright (c) 2013, NVIDIA Corporation. All rights reserved.
+ *
+ * Author: Florian Lobmaier <florian.lobmaier@ams.com>
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#include <linux/bcd.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/ioctl.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mfd/as3722.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/time.h>
+
+#define AS3722_RTC_START_YEAR	  2000
+struct as3722_rtc {
+	struct rtc_device	*rtc;
+	struct device		*dev;
+	struct as3722		*as3722;
+	int			alarm_irq;
+	bool			irq_enable;
+};
+
+static void as3722_time_to_reg(u8 *rbuff, struct rtc_time *tm)
+{
+	rbuff[0] = bin2bcd(tm->tm_sec);
+	rbuff[1] = bin2bcd(tm->tm_min);
+	rbuff[2] = bin2bcd(tm->tm_hour);
+	rbuff[3] = bin2bcd(tm->tm_mday);
+	rbuff[4] = bin2bcd(tm->tm_mon);
+	rbuff[5] = bin2bcd(tm->tm_year - (AS3722_RTC_START_YEAR - 1900));
+}
+
+static void as3722_reg_to_time(u8 *rbuff, struct rtc_time *tm)
+{
+	tm->tm_sec = bcd2bin(rbuff[0] & 0x7F);
+	tm->tm_min = bcd2bin(rbuff[1] & 0x7F);
+	tm->tm_hour = bcd2bin(rbuff[2] & 0x3F);
+	tm->tm_mday = bcd2bin(rbuff[3] & 0x3F);
+	tm->tm_mon = bcd2bin(rbuff[4] & 0x1F);
+	tm->tm_year = (AS3722_RTC_START_YEAR - 1900) + bcd2bin(rbuff[5] & 0x7F);
+	return;
+}
+
+static int as3722_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct as3722_rtc *as3722_rtc = dev_get_drvdata(dev);
+	struct as3722 *as3722 = as3722_rtc->as3722;
+	u8 as_time_array[6];
+	int ret;
+
+	ret = as3722_block_read(as3722, AS3722_RTC_SECOND_REG,
+			6, as_time_array);
+	if (ret < 0) {
+		dev_err(dev, "RTC_SECOND reg block read failed %d\n", ret);
+		return ret;
+	}
+	as3722_reg_to_time(as_time_array, tm);
+	return 0;
+}
+
+static int as3722_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct as3722_rtc *as3722_rtc = dev_get_drvdata(dev);
+	struct as3722 *as3722 = as3722_rtc->as3722;
+	u8 as_time_array[6];
+	int ret;
+
+	if (tm->tm_year < (AS3722_RTC_START_YEAR - 1900))
+		return -EINVAL;
+
+	as3722_time_to_reg(as_time_array, tm);
+	ret = as3722_block_write(as3722, AS3722_RTC_SECOND_REG, 6,
+			as_time_array);
+	if (ret < 0)
+		dev_err(dev, "RTC_SECOND reg block write failed %d\n", ret);
+	return ret;
+}
+
+static int as3722_rtc_alarm_irq_enable(struct device *dev,
+		unsigned int enabled)
+{
+	struct as3722_rtc *as3722_rtc = dev_get_drvdata(dev);
+
+	if (enabled && !as3722_rtc->irq_enable) {
+		enable_irq(as3722_rtc->alarm_irq);
+		as3722_rtc->irq_enable = true;
+	} else if (!enabled && as3722_rtc->irq_enable)  {
+		disable_irq(as3722_rtc->alarm_irq);
+		as3722_rtc->irq_enable = false;
+	}
+	return 0;
+}
+
+static int as3722_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct as3722_rtc *as3722_rtc = dev_get_drvdata(dev);
+	struct as3722 *as3722 = as3722_rtc->as3722;
+	u8 as_time_array[6];
+	int ret;
+
+	ret = as3722_block_read(as3722, AS3722_RTC_ALARM_SECOND_REG, 6,
+			as_time_array);
+	if (ret < 0) {
+		dev_err(dev, "RTC_ALARM_SECOND block read failed %d\n", ret);
+		return ret;
+	}
+
+	as3722_reg_to_time(as_time_array, &alrm->time);
+	return 0;
+}
+
+static int as3722_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct as3722_rtc *as3722_rtc = dev_get_drvdata(dev);
+	struct as3722 *as3722 = as3722_rtc->as3722;
+	u8 as_time_array[6];
+	int ret;
+
+	if (alrm->time.tm_year < (AS3722_RTC_START_YEAR - 1900))
+		return -EINVAL;
+
+	ret = as3722_rtc_alarm_irq_enable(dev, 0);
+	if (ret < 0) {
+		dev_err(dev, "Disable RTC alarm failed\n");
+		return ret;
+	}
+
+	as3722_time_to_reg(as_time_array, &alrm->time);
+	ret = as3722_block_write(as3722, AS3722_RTC_ALARM_SECOND_REG, 6,
+			as_time_array);
+	if (ret < 0) {
+		dev_err(dev, "RTC_ALARM_SECOND block write failed %d\n", ret);
+		return ret;
+	}
+
+	if (alrm->enabled)
+		ret = as3722_rtc_alarm_irq_enable(dev, alrm->enabled);
+	return ret;
+}
+
+static irqreturn_t as3722_alarm_irq(int irq, void *data)
+{
+	struct as3722_rtc *as3722_rtc = data;
+
+	rtc_update_irq(as3722_rtc->rtc, 1, RTC_IRQF | RTC_AF);
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops as3722_rtc_ops = {
+	.read_time = as3722_rtc_read_time,
+	.set_time = as3722_rtc_set_time,
+	.read_alarm = as3722_rtc_read_alarm,
+	.set_alarm = as3722_rtc_set_alarm,
+	.alarm_irq_enable = as3722_rtc_alarm_irq_enable,
+};
+
+static int as3722_rtc_probe(struct platform_device *pdev)
+{
+	struct as3722 *as3722 = dev_get_drvdata(pdev->dev.parent);
+	struct as3722_rtc *as3722_rtc;
+	int ret;
+
+	as3722_rtc = devm_kzalloc(&pdev->dev, sizeof(*as3722_rtc), GFP_KERNEL);
+	if (!as3722_rtc)
+		return -ENOMEM;
+
+	as3722_rtc->as3722 = as3722;
+	as3722_rtc->dev = &pdev->dev;
+	platform_set_drvdata(pdev, as3722_rtc);
+
+	/* Enable the RTC to make sure it is running. */
+	ret = as3722_update_bits(as3722, AS3722_RTC_CONTROL_REG,
+			AS3722_RTC_ON | AS3722_RTC_ALARM_WAKEUP_EN,
+			AS3722_RTC_ON | AS3722_RTC_ALARM_WAKEUP_EN);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "RTC_CONTROL reg write failed: %d\n", ret);
+		return ret;
+	}
+
+	device_init_wakeup(&pdev->dev, 1);
+
+	as3722_rtc->rtc = rtc_device_register("as3722", &pdev->dev,
+				&as3722_rtc_ops, THIS_MODULE);
+	if (IS_ERR(as3722_rtc->rtc)) {
+		ret = PTR_ERR(as3722_rtc->rtc);
+		dev_err(&pdev->dev, "RTC register failed: %d\n", ret);
+		return ret;
+	}
+
+	as3722_rtc->alarm_irq = platform_get_irq(pdev, 0);
+	dev_info(&pdev->dev, "RTC interrupt %d\n", as3722_rtc->alarm_irq);
+
+	ret = request_threaded_irq(as3722_rtc->alarm_irq, NULL,
+			as3722_alarm_irq, IRQF_ONESHOT | IRQF_EARLY_RESUME,
+			"rtc-alarm", as3722_rtc);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
+				as3722_rtc->alarm_irq, ret);
+		goto scrub;
+	}
+	disable_irq(as3722_rtc->alarm_irq);
+	return 0;
+scrub:
+	rtc_device_unregister(as3722_rtc->rtc);
+	return ret;
+}
+
+static int as3722_rtc_remove(struct platform_device *pdev)
+{
+	struct as3722_rtc *as3722_rtc = platform_get_drvdata(pdev);
+
+	free_irq(as3722_rtc->alarm_irq, as3722_rtc);
+	rtc_device_unregister(as3722_rtc->rtc);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int as3722_rtc_suspend(struct device *dev)
+{
+	struct as3722_rtc *as3722_rtc = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(as3722_rtc->alarm_irq);
+
+	return 0;
+}
+
+static int as3722_rtc_resume(struct device *dev)
+{
+	struct as3722_rtc *as3722_rtc = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(as3722_rtc->alarm_irq);
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops as3722_rtc_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(as3722_rtc_suspend, as3722_rtc_resume)
+};
+
+static struct platform_driver as3722_rtc_driver = {
+	.probe = as3722_rtc_probe,
+	.remove = as3722_rtc_remove,
+	.driver = {
+		.name = "as3722-rtc",
+		.pm = &as3722_rtc_pm_ops,
+	},
+};
+module_platform_driver(as3722_rtc_driver);
+
+MODULE_DESCRIPTION("RTC driver for AS3722 PMICs");
+MODULE_ALIAS("platform:as3722-rtc");
+MODULE_AUTHOR("Florian Lobmaier <florian.lobmaier@ams.com>");
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

drivers-rtc-rtc-as3722-add-rtc-driver.patch
linux-next.patch

