From: akpm@linux-foundation.org
Subject: - txx9-watchdog-driver.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:40:37 -0800
Message-ID: <200712172340.lBHNebjG008305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763667AbXLQXwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:52:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, ralf@linux-mips.org, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     TXx9 watchdog driver
has been removed from the -mm tree.  Its filename was
     txx9-watchdog-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: TXx9 watchdog driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

This is a driver for watchdog timer built into TXx9 MIPS SoCs.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig   |    6 
 drivers/watchdog/Makefile  |    1 
 drivers/watchdog/txx9wdt.c |  276 +++++++++++++++++++++++++++++++++++
 3 files changed, 283 insertions(+)

diff -puN drivers/watchdog/Kconfig~txx9-watchdog-driver drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~txx9-watchdog-driver
+++ a/drivers/watchdog/Kconfig
@@ -642,6 +642,12 @@ config AR7_WDT
 	help
 	  Hardware driver for the TI AR7 Watchdog Timer.
 
+config TXX9_WDT
+	tristate "Toshiba TXx9 Watchdog Timer"
+	depends on CPU_TX39XX || CPU_TX49XX
+	help
+	  Hardware driver for the built-in watchdog timer on TXx9 MIPS SoCs.
+
 # PARISC Architecture
 
 # POWERPC Architecture
diff -puN drivers/watchdog/Makefile~txx9-watchdog-driver drivers/watchdog/Makefile
--- a/drivers/watchdog/Makefile~txx9-watchdog-driver
+++ a/drivers/watchdog/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_INDYDOG) += indydog.o
 obj-$(CONFIG_WDT_MTX1)	+= mtx-1_wdt.o
 obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
 obj-$(CONFIG_AR7_WDT) += ar7_wdt.o
+obj-$(CONFIG_TXX9_WDT) += txx9wdt.o
 
 # PARISC Architecture
 
diff -puN /dev/null drivers/watchdog/txx9wdt.c
--- /dev/null
+++ a/drivers/watchdog/txx9wdt.c
@@ -0,0 +1,276 @@
+/*
+ * txx9wdt: A Hardware Watchdog Driver for TXx9 SoCs
+ *
+ * Copyright (C) 2007 Atsushi Nemoto <anemo@mba.ocn.ne.jp>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/uaccess.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <asm/txx9tmr.h>
+
+#define TIMER_MARGIN	60		/* Default is 60 seconds */
+
+static int timeout = TIMER_MARGIN;	/* in seconds */
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. "
+	"(0<timeout<((2^" __MODULE_STRING(TXX9_TIMER_BITS) ")/(IMCLK/256)), "
+	"default=" __MODULE_STRING(TIMER_MARGIN) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started "
+	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+#define WD_TIMER_CCD	7	/* 1/256 */
+#define WD_TIMER_CLK	(clk_get_rate(txx9_imclk) / (2 << WD_TIMER_CCD))
+#define WD_MAX_TIMEOUT	((0xffffffff >> (32 - TXX9_TIMER_BITS)) / WD_TIMER_CLK)
+
+static unsigned long txx9wdt_alive;
+static int expect_close;
+static struct txx9_tmr_reg __iomem *txx9wdt_reg;
+static struct clk *txx9_imclk;
+
+static void txx9wdt_ping(void)
+{
+	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
+}
+
+static void txx9wdt_start(void)
+{
+	__raw_writel(WD_TIMER_CLK * timeout, &txx9wdt_reg->cpra);
+	__raw_writel(WD_TIMER_CCD, &txx9wdt_reg->ccdr);
+	__raw_writel(0, &txx9wdt_reg->tisr);	/* clear pending interrupt */
+	__raw_writel(TXx9_TMTCR_TCE | TXx9_TMTCR_CCDE | TXx9_TMTCR_TMODE_WDOG,
+		     &txx9wdt_reg->tcr);
+	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
+}
+
+static void txx9wdt_stop(void)
+{
+	__raw_writel(TXx9_TMWTMR_WDIS, &txx9wdt_reg->wtmr);
+	__raw_writel(__raw_readl(&txx9wdt_reg->tcr) & ~TXx9_TMTCR_TCE,
+		     &txx9wdt_reg->tcr);
+}
+
+static int txx9wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &txx9wdt_alive))
+		return -EBUSY;
+
+	if (__raw_readl(&txx9wdt_reg->tcr) & TXx9_TMTCR_TCE) {
+		clear_bit(0, &txx9wdt_alive);
+		return -EBUSY;
+	}
+
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	txx9wdt_start();
+	return nonseekable_open(inode, file);
+}
+
+static int txx9wdt_release(struct inode *inode, struct file *file)
+{
+	if (expect_close)
+		txx9wdt_stop();
+	else {
+		printk(KERN_CRIT "txx9wdt: "
+		       "Unexpected close, not stopping watchdog!\n");
+		txx9wdt_ping();
+	}
+	clear_bit(0, &txx9wdt_alive);
+	expect_close = 0;
+	return 0;
+}
+
+static ssize_t txx9wdt_write(struct file *file, const char __user *data,
+			     size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			expect_close = 0;
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = 1;
+			}
+		}
+		txx9wdt_ping();
+	}
+	return len;
+}
+
+static int txx9wdt_ioctl(struct inode *inode, struct file *file,
+	unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_timeout;
+	static struct watchdog_info ident = {
+		.options =		WDIOF_SETTIMEOUT |
+					WDIOF_KEEPALIVEPING |
+					WDIOF_MAGICCLOSE,
+		.firmware_version =	0,
+		.identity =		"Hardware Watchdog for TXx9",
+	};
+
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		txx9wdt_ping();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (new_timeout < 1 || new_timeout > WD_MAX_TIMEOUT)
+			return -EINVAL;
+		timeout = new_timeout;
+		txx9wdt_stop();
+		txx9wdt_start();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	}
+}
+
+static int txx9wdt_notify_sys(struct notifier_block *this, unsigned long code,
+	void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		txx9wdt_stop();
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations txx9wdt_fops = {
+	.owner =	THIS_MODULE,
+	.llseek =	no_llseek,
+	.write =	txx9wdt_write,
+	.ioctl =	txx9wdt_ioctl,
+	.open =		txx9wdt_open,
+	.release =	txx9wdt_release,
+};
+
+static struct miscdevice txx9wdt_miscdev = {
+	.minor =	WATCHDOG_MINOR,
+	.name =		"watchdog",
+	.fops =		&txx9wdt_fops,
+};
+
+static struct notifier_block txx9wdt_notifier = {
+	.notifier_call = txx9wdt_notify_sys
+};
+
+static int __init txx9wdt_probe(struct platform_device *dev)
+{
+	struct resource *res;
+	int ret;
+
+	txx9_imclk = clk_get(NULL, "imbus_clk");
+	if (IS_ERR(txx9_imclk)) {
+		ret = PTR_ERR(txx9_imclk);
+		txx9_imclk = NULL;
+		goto exit;
+	}
+	ret = clk_enable(txx9_imclk);
+	if (ret) {
+		clk_put(txx9_imclk);
+		txx9_imclk = NULL;
+		goto exit;
+	}
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res)
+		goto exit_busy;
+	if (!devm_request_mem_region(&dev->dev,
+				     res->start, res->end - res->start + 1,
+				     "txx9wdt"))
+		goto exit_busy;
+	txx9wdt_reg = devm_ioremap(&dev->dev,
+				   res->start, res->end - res->start + 1);
+	if (!txx9wdt_reg)
+		goto exit_busy;
+
+	ret = misc_register(&txx9wdt_miscdev);
+	if (ret)
+		goto exit;
+
+	ret = register_reboot_notifier(&txx9wdt_notifier);
+	if (ret) {
+		misc_deregister(&txx9wdt_miscdev);
+		goto exit;
+	}
+
+	printk(KERN_INFO "Hardware Watchdog Timer for TXx9: "
+	       "timeout=%d sec (max %ld) (nowayout= %d)\n",
+	       timeout, WD_MAX_TIMEOUT, nowayout);
+
+	return 0;
+exit_busy:
+	ret = -EBUSY;
+exit:
+	if (txx9_imclk) {
+		clk_disable(txx9_imclk);
+		clk_put(txx9_imclk);
+	}
+	return ret;
+}
+
+static int __exit txx9wdt_remove(struct platform_device *dev)
+{
+	misc_deregister(&txx9wdt_miscdev);
+	unregister_reboot_notifier(&txx9wdt_notifier);
+	clk_disable(txx9_imclk);
+	clk_put(txx9_imclk);
+	return 0;
+}
+
+static struct platform_driver txx9wdt_driver = {
+	.remove = __exit_p(txx9wdt_remove),
+	.driver = {
+		.name = "txx9wdt",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init watchdog_init(void)
+{
+	return platform_driver_probe(&txx9wdt_driver, txx9wdt_probe);
+}
+
+static void __exit watchdog_exit(void)
+{
+	platform_driver_unregister(&txx9wdt_driver);
+}
+
+module_init(watchdog_init);
+module_exit(watchdog_exit);
+
+MODULE_DESCRIPTION("TXx9 Watchdog Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-mips.patch
git-watchdog.patch
git-x86.patch
