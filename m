From: akpm@linux-foundation.org
Subject: - rtc-au1000-on-chip-counter0-as-rtc-driver.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:09 -0800
Message-ID: <200901072219.n07MJ9sd018533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763007AbZAGWhp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mano@roarinelk.homelinux.net, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: Au1000 On-Chip Counter0-as-RTC driver.
has been removed from the -mm tree.  Its filename was
     rtc-au1000-on-chip-counter0-as-rtc-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: Au1000 On-Chip Counter0-as-RTC driver.
From: Manuel Lauss <mano@roarinelk.homelinux.net>

Simple driver which uses the Au1xxx Time-Of-Year counter (counter0)
as a 1Hz RTC.

[akpm@linux-foundation.org: repair Kconfig]
Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |   10 ++
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-au1xxx.c |  153 +++++++++++++++++++++++++++++++++++++
 3 files changed, 164 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-au1000-on-chip-counter0-as-rtc-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-au1000-on-chip-counter0-as-rtc-driver
+++ a/drivers/rtc/Kconfig
@@ -638,6 +638,16 @@ config RTC_DRV_AT91SAM9_GPBR
 	  will be used. The default of zero is normally OK to use, but
 	  on some systems other software needs to use that register.
 
+config RTC_DRV_AU1XXX
+	tristate "Au1xxx Counter0 RTC support"
+	depends on SOC_AU1X00
+	help
+	  This is a driver for the Au1xxx on-chip Counter0 (Time-Of-Year
+	  counter) to be used as a RTC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-au1xxx.
+
 config RTC_DRV_BFIN
 	tristate "Blackfin On-Chip RTC"
 	depends on BLACKFIN && !BF561
diff -puN drivers/rtc/Makefile~rtc-au1000-on-chip-counter0-as-rtc-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-au1000-on-chip-counter0-as-rtc-driver
+++ a/drivers/rtc/Makefile
@@ -20,6 +20,7 @@ rtc-core-$(CONFIG_RTC_INTF_SYSFS) += rtc
 obj-$(CONFIG_RTC_DRV_AT32AP700X)+= rtc-at32ap700x.o
 obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-at91rm9200.o
 obj-$(CONFIG_RTC_DRV_AT91SAM9)	+= rtc-at91sam9.o
+obj-$(CONFIG_RTC_DRV_AU1XXX)	+= rtc-au1xxx.o
 obj-$(CONFIG_RTC_DRV_BFIN)	+= rtc-bfin.o
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_DS1216)	+= rtc-ds1216.o
diff -puN /dev/null drivers/rtc/rtc-au1xxx.c
--- /dev/null
+++ a/drivers/rtc/rtc-au1xxx.c
@@ -0,0 +1,153 @@
+/*
+ * Au1xxx counter0 (aka Time-Of-Year counter) RTC interface driver.
+ *
+ * Copyright (C) 2008 Manuel Lauss <mano@roarinelk.homelinux.net>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+/* All current Au1xxx SoCs have 2 counters fed by an external 32.768 kHz
+ * crystal. Counter 0, which keeps counting during sleep/powerdown, is
+ * used to count seconds since the beginning of the unix epoch.
+ *
+ * The counters must be configured and enabled by bootloader/board code;
+ * no checks as to whether they really get a proper 32.768kHz clock are
+ * made as this would take far too long.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/rtc.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <asm/mach-au1x00/au1000.h>
+
+/* 32kHz clock enabled and detected */
+#define CNTR_OK (SYS_CNTRL_E0 | SYS_CNTRL_32S)
+
+static int au1xtoy_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	unsigned long t;
+
+	t = au_readl(SYS_TOYREAD);
+
+	rtc_time_to_tm(t, tm);
+
+	return rtc_valid_tm(tm);
+}
+
+static int au1xtoy_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	unsigned long t;
+
+	rtc_tm_to_time(tm, &t);
+
+	au_writel(t, SYS_TOYWRITE);
+	au_sync();
+
+	/* wait for the pending register write to succeed.  This can
+	 * take up to 6 seconds...
+	 */
+	while (au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_C0S)
+		msleep(1);
+
+	return 0;
+}
+
+static struct rtc_class_ops au1xtoy_rtc_ops = {
+	.read_time	= au1xtoy_rtc_read_time,
+	.set_time	= au1xtoy_rtc_set_time,
+};
+
+static int __devinit au1xtoy_rtc_probe(struct platform_device *pdev)
+{
+	struct rtc_device *rtcdev;
+	unsigned long t;
+	int ret;
+
+	t = au_readl(SYS_COUNTER_CNTRL);
+	if (!(t & CNTR_OK)) {
+		dev_err(&pdev->dev, "counters not working; aborting.\n");
+		ret = -ENODEV;
+		goto out_err;
+	}
+
+	ret = -ETIMEDOUT;
+
+	/* set counter0 tickrate to 1Hz if necessary */
+	if (au_readl(SYS_TOYTRIM) != 32767) {
+		/* wait until hardware gives access to TRIM register */
+		t = 0x00100000;
+		while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_T0S) && t--)
+			msleep(1);
+
+		if (!t) {
+			/* timed out waiting for register access; assume
+			 * counters are unusable.
+			 */
+			dev_err(&pdev->dev, "timeout waiting for access\n");
+			goto out_err;
+		}
+
+		/* set 1Hz TOY tick rate */
+		au_writel(32767, SYS_TOYTRIM);
+		au_sync();
+	}
+
+	/* wait until the hardware allows writes to the counter reg */
+	while (au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_C0S)
+		msleep(1);
+
+	rtcdev = rtc_device_register("rtc-au1xxx", &pdev->dev,
+				     &au1xtoy_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtcdev)) {
+		ret = PTR_ERR(rtcdev);
+		goto out_err;
+	}
+
+	platform_set_drvdata(pdev, rtcdev);
+
+	return 0;
+
+out_err:
+	return ret;
+}
+
+static int __devexit au1xtoy_rtc_remove(struct platform_device *pdev)
+{
+	struct rtc_device *rtcdev = platform_get_drvdata(pdev);
+
+	rtc_device_unregister(rtcdev);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver au1xrtc_driver = {
+	.driver		= {
+		.name	= "rtc-au1xxx",
+		.owner	= THIS_MODULE,
+	},
+	.remove		= __devexit_p(au1xtoy_rtc_remove),
+};
+
+static int __init au1xtoy_rtc_init(void)
+{
+	return platform_driver_probe(&au1xrtc_driver, au1xtoy_rtc_probe);
+}
+
+static void __exit au1xtoy_rtc_exit(void)
+{
+	platform_driver_unregister(&au1xrtc_driver);
+}
+
+module_init(au1xtoy_rtc_init);
+module_exit(au1xtoy_rtc_exit);
+
+MODULE_DESCRIPTION("Au1xxx TOY-counter-based RTC driver");
+MODULE_AUTHOR("Manuel Lauss <manuel.lauss@gmail.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rtc-au1xxx");
_

Patches currently in -mm which might be from mano@roarinelk.homelinux.net are

origin.patch
linux-next.patch

