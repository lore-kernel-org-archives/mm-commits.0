From: akpm@linux-foundation.org
Subject: + rtc-marvell-soc-rtc-driver.patch added to -mm tree
Date: Fri, 11 Jul 2008 17:55:35 -0700
Message-ID: <200807120055.m6C0tZgi013347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882AbYGLAzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 20:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: saeed@marvell.com, a.zummo@towertech.it, buytenh@marvell.com, david-b@pacbell.net, nico@marvell.com


The patch titled
     rtc: Marvell SoC RTC driver
has been added to the -mm tree.  Its filename is
     rtc-marvell-soc-rtc-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: Marvell SoC RTC driver
From: Saeed Bishara <saeed@marvell.com>

Driver for the on-chip RTC found in some of Marvell's SoCs
such as the Kirkwood 88F6281 and 88F6192 devices.

Signed-off-by: Saeed Bishara <saeed@marvell.com>
Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig  |   10 ++
 drivers/rtc/Makefile |    1 
 drivers/rtc/rtc-mv.c |  176 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 187 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-marvell-soc-rtc-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-marvell-soc-rtc-driver
+++ a/drivers/rtc/Kconfig
@@ -583,4 +583,14 @@ config RTC_DRV_PPC
 	 the RTC. This exposes that functionality through the generic RTC
 	 class.
 
+config RTC_DRV_MV
+	tristate "Marvell SoC RTC"
+	help
+	  If you say yes here you will get support for the in-chip RTC
+	  that can be found in some of Marvell's SoC devices, such as
+	  the Kirkwood 88F6281 and 88F6192.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-mv.
+
 endif # RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-marvell-soc-rtc-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-marvell-soc-rtc-driver
+++ a/drivers/rtc/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t
 obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
+obj-$(CONFIG_RTC_DRV_MV)	+= rtc-mv.o
 obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
 obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
diff -puN /dev/null drivers/rtc/rtc-mv.c
--- /dev/null
+++ a/drivers/rtc/rtc-mv.c
@@ -0,0 +1,176 @@
+/*
+ * Driver for the RTC in Marvell SoCs.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/bcd.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/rtc.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
+#define DRV_VERSION "0.1"
+
+#define RTC_TIME_REG_OFFS	0
+#define RTC_SECONDS_OFFS	0
+#define RTC_MINUTES_OFFS	8
+#define RTC_HOURS_OFFS		16
+#define RTC_WDAY_OFFS		24
+#define RTC_HOURS_12H_MODE		(1 << 22) /* 12 hours mode */
+
+#define RTC_DATE_REG_OFFS	4
+#define RTC_MDAY_OFFS		0
+#define RTC_MONTH_OFFS		8
+#define RTC_YEAR_OFFS		16
+
+
+struct rtc_plat_data {
+	struct rtc_device *rtc;
+	void __iomem *ioaddr;
+};
+
+static int mv_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	u32	rtc_reg;
+
+	rtc_reg = (BIN2BCD(tm->tm_sec) << RTC_SECONDS_OFFS) |
+		(BIN2BCD(tm->tm_min) << RTC_MINUTES_OFFS) |
+		(BIN2BCD(tm->tm_hour) << RTC_HOURS_OFFS) |
+		(BIN2BCD(tm->tm_wday) << RTC_WDAY_OFFS);
+
+	writel(rtc_reg, ioaddr + RTC_TIME_REG_OFFS);
+
+	rtc_reg = (BIN2BCD(tm->tm_mday) << RTC_MDAY_OFFS) |
+		(BIN2BCD(tm->tm_mon + 1) << RTC_MONTH_OFFS) |
+		(BIN2BCD(tm->tm_year % 100) << RTC_YEAR_OFFS);
+
+	writel(rtc_reg, ioaddr + RTC_DATE_REG_OFFS);
+	return 0;
+}
+
+static int mv_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	u32	rtc_time, rtc_date;
+	unsigned int year, month, day, hour, minute, second, wday;
+
+	rtc_time = readl(ioaddr + RTC_TIME_REG_OFFS);
+	rtc_date = readl(ioaddr + RTC_DATE_REG_OFFS);
+
+	second = rtc_time & 0x7f;
+	minute = (rtc_time >> RTC_MINUTES_OFFS) & 0x7f;
+	hour = (rtc_time >> RTC_HOURS_OFFS) & 0x3f; /* assume 24 hours mode */
+	wday = (rtc_time >> RTC_WDAY_OFFS) & 0x7;
+
+	day = rtc_date & 0x3f;
+	month = (rtc_date >> RTC_MONTH_OFFS) & 0x3f;
+	year = (rtc_date >> RTC_YEAR_OFFS) & 0xff;
+
+	tm->tm_sec = BCD2BIN(second);
+	tm->tm_min = BCD2BIN(minute);
+	tm->tm_hour = BCD2BIN(hour);
+	tm->tm_mday = BCD2BIN(day);
+	tm->tm_wday = BCD2BIN(wday);
+	tm->tm_mon = BCD2BIN(month) - 1;
+	/* hw counts from year 2000, but tm_year is relative to 1900 */
+	tm->tm_year = BCD2BIN(year) + 100;
+
+	if (rtc_valid_tm(tm) < 0) {
+		dev_err(dev, "retrieved date/time is not valid.\n");
+		rtc_time_to_tm(0, tm);
+	}
+	return 0;
+}
+
+static const struct rtc_class_ops mv_rtc_ops = {
+	.read_time	= mv_rtc_read_time,
+	.set_time	= mv_rtc_set_time,
+};
+
+static int __devinit mv_rtc_probe(struct platform_device *pdev)
+{
+	struct rtc_device *rtc;
+	struct resource *res;
+	struct rtc_plat_data *pdata = NULL;
+	void __iomem *ioaddr = NULL;
+	resource_size_t size;
+	u32 rtc_time;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	size = res->end - res->start + 1;
+	if (!devm_request_mem_region(&pdev->dev, res->start, size,
+				     pdev->name))
+		return -EBUSY;
+
+	ioaddr = devm_ioremap(&pdev->dev, res->start, size);
+	if (!ioaddr)
+		return -ENOMEM;
+
+	pdata->ioaddr = ioaddr;
+
+	/* make sure the 24 hours mode is enabled */
+	rtc_time = readl(ioaddr + RTC_TIME_REG_OFFS);
+	if (rtc_time & RTC_HOURS_12H_MODE) {
+		dev_err(&pdev->dev, "12 Hours mode not supported.\n");
+		return -EBUSY;
+	}
+
+	rtc = rtc_device_register(pdev->name, &pdev->dev,
+				  &mv_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	pdata->rtc = rtc;
+	platform_set_drvdata(pdev, pdata);
+	return 0;
+}
+
+static int __devexit mv_rtc_remove(struct platform_device *pdev)
+{
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+
+	rtc_device_unregister(pdata->rtc);
+	return 0;
+}
+
+static struct platform_driver mv_rtc_driver = {
+	.probe		= mv_rtc_probe,
+	.remove		= __devexit_p(mv_rtc_remove),
+	.driver		= {
+		.name	= "rtc-mv",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static __init int mv_init(void)
+{
+	return platform_driver_register(&mv_rtc_driver);
+}
+
+static __exit void mv_exit(void)
+{
+	platform_driver_unregister(&mv_rtc_driver);
+}
+
+module_init(mv_init);
+module_exit(mv_exit);
+
+MODULE_AUTHOR("Saeed Bishara <saeed@marvell.com>");
+MODULE_DESCRIPTION("Marvell RTC driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:rtc-mv");
_

Patches currently in -mm which might be from saeed@marvell.com are

linux-next.patch
rtc-marvell-soc-rtc-driver.patch

