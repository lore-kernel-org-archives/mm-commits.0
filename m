From: akpm@linux-foundation.org
Subject: - rtc-driver-for-marvells-socs-88f6281-and-88f6192.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:26 -0800
Message-ID: <200901072219.n07MJQsX018759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758776AbZAGWU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:20:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: saeed@marvell.com, a.zummo@towertech.it, buytenh@marvell.com, david-b@pacbell.net, nico@marvell.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     rtc: driver for Marvell's SoCs 88F6281 and 88F6192
has been removed from the -mm tree.  Its filename was
     rtc-driver-for-marvells-socs-88f6281-and-88f6192.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: driver for Marvell's SoCs 88F6281 and 88F6192
From: Saeed Bishara <saeed@marvell.com>

Driver for the on-chip RTC found in some of Marvell's SoCs such as the
Kirkwood 88F6281 and 88F6192 devices.

Signed-off-by: Saeed Bishara <saeed@marvell.com>
Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig  |   11 ++
 drivers/rtc/Makefile |    1 
 drivers/rtc/rtc-mv.c |  163 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 175 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-driver-for-marvells-socs-88f6281-and-88f6192 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-driver-for-marvells-socs-88f6281-and-88f6192
+++ a/drivers/rtc/Kconfig
@@ -712,4 +712,15 @@ config RTC_DRV_TX4939
 	  Driver for the internal RTC (Realtime Clock) module found on
 	  Toshiba TX4939 SoC.
 
+config RTC_DRV_MV
+	tristate "Marvell SoC RTC"
+	depends on ARCH_KIRKWOOD
+	help
+	  If you say yes here you will get support for the in-chip RTC
+	  that can be found in some of Marvell's SoC devices, such as
+	  the Kirkwood 88F6281 and 88F6192.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-mv.
+
 endif # RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-driver-for-marvells-socs-88f6281-and-88f6192 drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-driver-for-marvells-socs-88f6281-and-88f6192
+++ a/drivers/rtc/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_RTC_DRV_SUN4V)	+= rtc-sun4v
 obj-$(CONFIG_RTC_DRV_STARFIRE)	+= rtc-starfire.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
+obj-$(CONFIG_RTC_DRV_MV)	+= rtc-mv.o
 obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
 obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
diff -puN /dev/null drivers/rtc/rtc-mv.c
--- /dev/null
+++ a/drivers/rtc/rtc-mv.c
@@ -0,0 +1,163 @@
+/*
+ * Driver for the RTC in Marvell SoCs.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
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
+	rtc_reg = (bin2bcd(tm->tm_sec) << RTC_SECONDS_OFFS) |
+		(bin2bcd(tm->tm_min) << RTC_MINUTES_OFFS) |
+		(bin2bcd(tm->tm_hour) << RTC_HOURS_OFFS) |
+		(bin2bcd(tm->tm_wday) << RTC_WDAY_OFFS);
+	writel(rtc_reg, ioaddr + RTC_TIME_REG_OFFS);
+
+	rtc_reg = (bin2bcd(tm->tm_mday) << RTC_MDAY_OFFS) |
+		(bin2bcd(tm->tm_mon + 1) << RTC_MONTH_OFFS) |
+		(bin2bcd(tm->tm_year % 100) << RTC_YEAR_OFFS);
+	writel(rtc_reg, ioaddr + RTC_DATE_REG_OFFS);
+
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
+	tm->tm_sec = bcd2bin(second);
+	tm->tm_min = bcd2bin(minute);
+	tm->tm_hour = bcd2bin(hour);
+	tm->tm_mday = bcd2bin(day);
+	tm->tm_wday = bcd2bin(wday);
+	tm->tm_mon = bcd2bin(month) - 1;
+	/* hw counts from year 2000, but tm_year is relative to 1900 */
+	tm->tm_year = bcd2bin(year) + 100;
+
+	return rtc_valid_tm(tm);
+}
+
+static const struct rtc_class_ops mv_rtc_ops = {
+	.read_time	= mv_rtc_read_time,
+	.set_time	= mv_rtc_set_time,
+};
+
+static int __init mv_rtc_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct rtc_plat_data *pdata;
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
+	size = resource_size(res);
+	if (!devm_request_mem_region(&pdev->dev, res->start, size,
+				     pdev->name))
+		return -EBUSY;
+
+	pdata->ioaddr = devm_ioremap(&pdev->dev, res->start, size);
+	if (!pdata->ioaddr)
+		return -ENOMEM;
+
+	/* make sure the 24 hours mode is enabled */
+	rtc_time = readl(pdata->ioaddr + RTC_TIME_REG_OFFS);
+	if (rtc_time & RTC_HOURS_12H_MODE) {
+		dev_err(&pdev->dev, "24 Hours mode not supported.\n");
+		return -EINVAL;
+	}
+
+	platform_set_drvdata(pdev, pdata);
+	pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+					 &mv_rtc_ops, THIS_MODULE);
+	if (IS_ERR(pdata->rtc))
+		return PTR_ERR(pdata->rtc);
+
+	return 0;
+}
+
+static int __exit mv_rtc_remove(struct platform_device *pdev)
+{
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+
+	rtc_device_unregister(pdata->rtc);
+	return 0;
+}
+
+static struct platform_driver mv_rtc_driver = {
+	.remove		= __exit_p(mv_rtc_remove),
+	.driver		= {
+		.name	= "rtc-mv",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static __init int mv_init(void)
+{
+	return platform_driver_probe(&mv_rtc_driver, mv_rtc_probe);
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
+MODULE_ALIAS("platform:rtc-mv");
_

Patches currently in -mm which might be from saeed@marvell.com are

origin.patch

