From: akpm@linux-foundation.org
Subject: - mpc83xx_wdt-rename-to-mpc8xxx_wdt.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:37 -0700
Message-ID: <200807162137.m6GLbb8P014400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667AbYGPViX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:38:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, galak@kernel.crashing.org, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     mpc83xx_wdt: rename to mpc8xxx_wdt
has been removed from the -mm tree.  Its filename was
     mpc83xx_wdt-rename-to-mpc8xxx_wdt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mpc83xx_wdt: rename to mpc8xxx_wdt
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Rename the driver because now we support some MPC86xx processors.

There are no changes to the mpc83xx_wdt.c file, yet.  When possible, we do
file renames and changes separately (because Linus once asked so, because
it helps git to track the renamed files).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig       |   11 -
 drivers/watchdog/Makefile      |    2 
 drivers/watchdog/mpc83xx_wdt.c |  294 -------------------------------
 drivers/watchdog/mpc8xxx_wdt.c |  294 +++++++++++++++++++++++++++++++
 4 files changed, 304 insertions(+), 297 deletions(-)

diff -puN drivers/watchdog/Kconfig~mpc83xx_wdt-rename-to-mpc8xxx_wdt drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~mpc83xx_wdt-rename-to-mpc8xxx_wdt
+++ a/drivers/watchdog/Kconfig
@@ -695,9 +695,16 @@ config 8xx_WDT
 	tristate "MPC8xx Watchdog Timer"
 	depends on 8xx
 
-config 83xx_WDT
-	tristate "MPC83xx/MPC86xx Watchdog Timer"
+config 8xxx_WDT
+	tristate "MPC8xxx Platform Watchdog Timer"
 	depends on PPC_83xx || PPC_86xx
+	help
+	  This driver is for a SoC level watchdog that exists on some
+	  Freescale PowerPC processors. So far this driver supports:
+	  - MPC83xx watchdogs
+	  - MPC86xx watchdogs
+
+	  For BookE processors (MPC85xx) use the BOOKE_WDT driver instead.
 
 config MV64X60_WDT
 	tristate "MV64X60 (Marvell Discovery) Watchdog Timer"
diff -puN drivers/watchdog/Makefile~mpc83xx_wdt-rename-to-mpc8xxx_wdt drivers/watchdog/Makefile
--- a/drivers/watchdog/Makefile~mpc83xx_wdt-rename-to-mpc8xxx_wdt
+++ a/drivers/watchdog/Makefile
@@ -103,7 +103,7 @@ obj-$(CONFIG_TXX9_WDT) += txx9wdt.o
 # POWERPC Architecture
 obj-$(CONFIG_8xx_WDT) += mpc8xx_wdt.o
 obj-$(CONFIG_MPC5200_WDT) += mpc5200_wdt.o
-obj-$(CONFIG_83xx_WDT) += mpc83xx_wdt.o
+obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
 obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
 obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
 
diff -puN drivers/watchdog/mpc83xx_wdt.c~mpc83xx_wdt-rename-to-mpc8xxx_wdt /dev/null
--- a/drivers/watchdog/mpc83xx_wdt.c
+++ /dev/null
@@ -1,294 +0,0 @@
-/*
- * mpc83xx_wdt.c - MPC83xx/MPC86xx watchdog userspace interface
- *
- * Authors: Dave Updegraff <dave@cray.org>
- * 	    Kumar Gala <galak@kernel.crashing.org>
- * 		Attribution: from 83xx_wst: Florian Schirmer <jolt@tuxbox.org>
- * 				..and from sc520_wdt
- * Copyright (c) 2008  MontaVista Software, Inc.
- *                     Anton Vorontsov <avorontsov@ru.mvista.com>
- *
- * Note: it appears that you can only actually ENABLE or DISABLE the thing
- * once after POR. Once enabled, you cannot disable, and vice versa.
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/miscdevice.h>
-#include <linux/of_platform.h>
-#include <linux/module.h>
-#include <linux/watchdog.h>
-#include <linux/io.h>
-#include <linux/uaccess.h>
-#include <sysdev/fsl_soc.h>
-
-struct mpc83xx_wdt {
-	__be32 res0;
-	__be32 swcrr; /* System watchdog control register */
-#define SWCRR_SWTC 0xFFFF0000 /* Software Watchdog Time Count. */
-#define SWCRR_SWEN 0x00000004 /* Watchdog Enable bit. */
-#define SWCRR_SWRI 0x00000002 /* Software Watchdog Reset/Interrupt Select bit.*/
-#define SWCRR_SWPR 0x00000001 /* Software Watchdog Counter Prescale bit. */
-	__be32 swcnr; /* System watchdog count register */
-	u8 res1[2];
-	__be16 swsrr; /* System watchdog service register */
-	u8 res2[0xF0];
-};
-
-struct mpc83xx_wdt_type {
-	int prescaler;
-	bool hw_enabled;
-};
-
-static struct mpc83xx_wdt __iomem *wd_base;
-
-static u16 timeout = 0xffff;
-module_param(timeout, ushort, 0);
-MODULE_PARM_DESC(timeout,
-	"Watchdog timeout in ticks. (0<timeout<65536, default=65535");
-
-static int reset = 1;
-module_param(reset, bool, 0);
-MODULE_PARM_DESC(reset,
-	"Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");
-
-static int nowayout = WATCHDOG_NOWAYOUT;
-module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
-		 "(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
-/*
- * We always prescale, but if someone really doesn't want to they can set this
- * to 0
- */
-static int prescale = 1;
-static unsigned int timeout_sec;
-
-static unsigned long wdt_is_open;
-static DEFINE_SPINLOCK(wdt_spinlock);
-
-static void mpc83xx_wdt_keepalive(void)
-{
-	/* Ping the WDT */
-	spin_lock(&wdt_spinlock);
-	out_be16(&wd_base->swsrr, 0x556c);
-	out_be16(&wd_base->swsrr, 0xaa39);
-	spin_unlock(&wdt_spinlock);
-}
-
-static void mpc83xx_wdt_timer_ping(unsigned long arg);
-static DEFINE_TIMER(wdt_timer, mpc83xx_wdt_timer_ping, 0, 0);
-
-static void mpc83xx_wdt_timer_ping(unsigned long arg)
-{
-	mpc83xx_wdt_keepalive();
-	/* We're pinging it twice faster than needed, just to be sure. */
-	mod_timer(&wdt_timer, jiffies + HZ * timeout_sec / 2);
-}
-
-static void mpc83xx_wdt_pr_warn(const char *msg)
-{
-	pr_crit("mpc83xx_wdt: %s, expect the %s soon!\n", msg,
-		reset ? "reset" : "machine check exception");
-}
-
-static ssize_t mpc83xx_wdt_write(struct file *file, const char __user *buf,
-				 size_t count, loff_t *ppos)
-{
-	if (count)
-		mpc83xx_wdt_keepalive();
-	return count;
-}
-
-static int mpc83xx_wdt_open(struct inode *inode, struct file *file)
-{
-	u32 tmp = SWCRR_SWEN;
-	if (test_and_set_bit(0, &wdt_is_open))
-		return -EBUSY;
-
-	/* Once we start the watchdog we can't stop it */
-	if (nowayout)
-		__module_get(THIS_MODULE);
-
-	/* Good, fire up the show */
-	if (prescale)
-		tmp |= SWCRR_SWPR;
-	if (reset)
-		tmp |= SWCRR_SWRI;
-
-	tmp |= timeout << 16;
-
-	out_be32(&wd_base->swcrr, tmp);
-
-	del_timer_sync(&wdt_timer);
-
-	return nonseekable_open(inode, file);
-}
-
-static int mpc83xx_wdt_release(struct inode *inode, struct file *file)
-{
-	if (!nowayout)
-		mpc83xx_wdt_timer_ping(0);
-	else
-		mpc83xx_wdt_pr_warn("watchdog closed");
-	clear_bit(0, &wdt_is_open);
-	return 0;
-}
-
-static long mpc83xx_wdt_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING,
-		.firmware_version = 1,
-		.identity = "MPC83xx",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_KEEPALIVE:
-		mpc83xx_wdt_keepalive();
-		return 0;
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout_sec, p);
-	default:
-		return -ENOTTY;
-	}
-}
-
-static const struct file_operations mpc83xx_wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= mpc83xx_wdt_write,
-	.unlocked_ioctl	= mpc83xx_wdt_ioctl,
-	.open		= mpc83xx_wdt_open,
-	.release	= mpc83xx_wdt_release,
-};
-
-static struct miscdevice mpc83xx_wdt_miscdev = {
-	.minor	= WATCHDOG_MINOR,
-	.name	= "watchdog",
-	.fops	= &mpc83xx_wdt_fops,
-};
-
-static int __devinit mpc83xx_wdt_probe(struct of_device *ofdev,
-				       const struct of_device_id *match)
-{
-	int ret;
-	struct device_node *np = ofdev->node;
-	struct mpc83xx_wdt_type *wdt_type = match->data;
-	u32 freq = fsl_get_sys_freq();
-	bool enabled;
-
-	if (!freq || freq == -1)
-		return -EINVAL;
-
-	wd_base = of_iomap(np, 0);
-	if (!wd_base)
-		return -ENOMEM;
-
-	enabled = in_be32(&wd_base->swcrr) & SWCRR_SWEN;
-	if (!enabled && wdt_type->hw_enabled) {
-		pr_info("mpc83xx_wdt: could not be enabled in software\n");
-		ret = -ENOSYS;
-		goto err_unmap;
-	}
-
-	ret = misc_register(&mpc83xx_wdt_miscdev);
-	if (ret) {
-		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
-		goto err_unmap;
-	}
-
-	/* Calculate the timeout in seconds */
-	if (prescale)
-		timeout_sec = (timeout * wdt_type->prescaler) / freq;
-	else
-		timeout_sec = timeout / freq;
-
-	pr_info("WDT driver for MPC83xx initialized. mode:%s timeout=%d "
-		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
-		timeout_sec);
-
-	/*
-	 * If the watchdog was previously enabled or we're running on
-	 * MPC86xx, we should ping the wdt from the kernel until the
-	 * userspace handles it.
-	 */
-	if (enabled)
-		mpc83xx_wdt_timer_ping(0);
-	return 0;
-err_unmap:
-	iounmap(wd_base);
-	return ret;
-}
-
-static int __devexit mpc83xx_wdt_remove(struct of_device *ofdev)
-{
-	mpc83xx_wdt_pr_warn("watchdog removed");
-	del_timer_sync(&wdt_timer);
-	misc_deregister(&mpc83xx_wdt_miscdev);
-	iounmap(wd_base);
-
-	return 0;
-}
-
-static const struct of_device_id mpc83xx_wdt_match[] = {
-	{
-		.compatible = "mpc83xx_wdt",
-		.data = &(struct mpc83xx_wdt_type) {
-			.prescaler = 0x10000,
-		},
-	},
-	{
-		.compatible = "fsl,mpc8610-wdt",
-		.data = &(struct mpc83xx_wdt_type) {
-			.prescaler = 0x10000,
-			.hw_enabled = true,
-		},
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(of, mpc83xx_wdt_match);
-
-static struct of_platform_driver mpc83xx_wdt_driver = {
-	.match_table	= mpc83xx_wdt_match,
-	.probe		= mpc83xx_wdt_probe,
-	.remove		= __devexit_p(mpc83xx_wdt_remove),
-	.driver		= {
-		.name	= "mpc83xx_wdt",
-		.owner	= THIS_MODULE,
-	},
-};
-
-static int __init mpc83xx_wdt_init(void)
-{
-	return of_register_platform_driver(&mpc83xx_wdt_driver);
-}
-
-static void __exit mpc83xx_wdt_exit(void)
-{
-	of_unregister_platform_driver(&mpc83xx_wdt_driver);
-}
-
-subsys_initcall(mpc83xx_wdt_init);
-module_exit(mpc83xx_wdt_exit);
-
-MODULE_AUTHOR("Dave Updegraff, Kumar Gala");
-MODULE_DESCRIPTION("Driver for watchdog timer in MPC83xx/MPC86xx uProcessors");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff -puN /dev/null drivers/watchdog/mpc8xxx_wdt.c
--- /dev/null
+++ a/drivers/watchdog/mpc8xxx_wdt.c
@@ -0,0 +1,294 @@
+/*
+ * mpc83xx_wdt.c - MPC83xx/MPC86xx watchdog userspace interface
+ *
+ * Authors: Dave Updegraff <dave@cray.org>
+ * 	    Kumar Gala <galak@kernel.crashing.org>
+ * 		Attribution: from 83xx_wst: Florian Schirmer <jolt@tuxbox.org>
+ * 				..and from sc520_wdt
+ * Copyright (c) 2008  MontaVista Software, Inc.
+ *                     Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * Note: it appears that you can only actually ENABLE or DISABLE the thing
+ * once after POR. Once enabled, you cannot disable, and vice versa.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/timer.h>
+#include <linux/miscdevice.h>
+#include <linux/of_platform.h>
+#include <linux/module.h>
+#include <linux/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <sysdev/fsl_soc.h>
+
+struct mpc83xx_wdt {
+	__be32 res0;
+	__be32 swcrr; /* System watchdog control register */
+#define SWCRR_SWTC 0xFFFF0000 /* Software Watchdog Time Count. */
+#define SWCRR_SWEN 0x00000004 /* Watchdog Enable bit. */
+#define SWCRR_SWRI 0x00000002 /* Software Watchdog Reset/Interrupt Select bit.*/
+#define SWCRR_SWPR 0x00000001 /* Software Watchdog Counter Prescale bit. */
+	__be32 swcnr; /* System watchdog count register */
+	u8 res1[2];
+	__be16 swsrr; /* System watchdog service register */
+	u8 res2[0xF0];
+};
+
+struct mpc83xx_wdt_type {
+	int prescaler;
+	bool hw_enabled;
+};
+
+static struct mpc83xx_wdt __iomem *wd_base;
+
+static u16 timeout = 0xffff;
+module_param(timeout, ushort, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in ticks. (0<timeout<65536, default=65535");
+
+static int reset = 1;
+module_param(reset, bool, 0);
+MODULE_PARM_DESC(reset,
+	"Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+		 "(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+/*
+ * We always prescale, but if someone really doesn't want to they can set this
+ * to 0
+ */
+static int prescale = 1;
+static unsigned int timeout_sec;
+
+static unsigned long wdt_is_open;
+static DEFINE_SPINLOCK(wdt_spinlock);
+
+static void mpc83xx_wdt_keepalive(void)
+{
+	/* Ping the WDT */
+	spin_lock(&wdt_spinlock);
+	out_be16(&wd_base->swsrr, 0x556c);
+	out_be16(&wd_base->swsrr, 0xaa39);
+	spin_unlock(&wdt_spinlock);
+}
+
+static void mpc83xx_wdt_timer_ping(unsigned long arg);
+static DEFINE_TIMER(wdt_timer, mpc83xx_wdt_timer_ping, 0, 0);
+
+static void mpc83xx_wdt_timer_ping(unsigned long arg)
+{
+	mpc83xx_wdt_keepalive();
+	/* We're pinging it twice faster than needed, just to be sure. */
+	mod_timer(&wdt_timer, jiffies + HZ * timeout_sec / 2);
+}
+
+static void mpc83xx_wdt_pr_warn(const char *msg)
+{
+	pr_crit("mpc83xx_wdt: %s, expect the %s soon!\n", msg,
+		reset ? "reset" : "machine check exception");
+}
+
+static ssize_t mpc83xx_wdt_write(struct file *file, const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	if (count)
+		mpc83xx_wdt_keepalive();
+	return count;
+}
+
+static int mpc83xx_wdt_open(struct inode *inode, struct file *file)
+{
+	u32 tmp = SWCRR_SWEN;
+	if (test_and_set_bit(0, &wdt_is_open))
+		return -EBUSY;
+
+	/* Once we start the watchdog we can't stop it */
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	/* Good, fire up the show */
+	if (prescale)
+		tmp |= SWCRR_SWPR;
+	if (reset)
+		tmp |= SWCRR_SWRI;
+
+	tmp |= timeout << 16;
+
+	out_be32(&wd_base->swcrr, tmp);
+
+	del_timer_sync(&wdt_timer);
+
+	return nonseekable_open(inode, file);
+}
+
+static int mpc83xx_wdt_release(struct inode *inode, struct file *file)
+{
+	if (!nowayout)
+		mpc83xx_wdt_timer_ping(0);
+	else
+		mpc83xx_wdt_pr_warn("watchdog closed");
+	clear_bit(0, &wdt_is_open);
+	return 0;
+}
+
+static long mpc83xx_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	static struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING,
+		.firmware_version = 1,
+		.identity = "MPC83xx",
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		mpc83xx_wdt_keepalive();
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout_sec, p);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static const struct file_operations mpc83xx_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= mpc83xx_wdt_write,
+	.unlocked_ioctl	= mpc83xx_wdt_ioctl,
+	.open		= mpc83xx_wdt_open,
+	.release	= mpc83xx_wdt_release,
+};
+
+static struct miscdevice mpc83xx_wdt_miscdev = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &mpc83xx_wdt_fops,
+};
+
+static int __devinit mpc83xx_wdt_probe(struct of_device *ofdev,
+				       const struct of_device_id *match)
+{
+	int ret;
+	struct device_node *np = ofdev->node;
+	struct mpc83xx_wdt_type *wdt_type = match->data;
+	u32 freq = fsl_get_sys_freq();
+	bool enabled;
+
+	if (!freq || freq == -1)
+		return -EINVAL;
+
+	wd_base = of_iomap(np, 0);
+	if (!wd_base)
+		return -ENOMEM;
+
+	enabled = in_be32(&wd_base->swcrr) & SWCRR_SWEN;
+	if (!enabled && wdt_type->hw_enabled) {
+		pr_info("mpc83xx_wdt: could not be enabled in software\n");
+		ret = -ENOSYS;
+		goto err_unmap;
+	}
+
+	ret = misc_register(&mpc83xx_wdt_miscdev);
+	if (ret) {
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			WATCHDOG_MINOR, ret);
+		goto err_unmap;
+	}
+
+	/* Calculate the timeout in seconds */
+	if (prescale)
+		timeout_sec = (timeout * wdt_type->prescaler) / freq;
+	else
+		timeout_sec = timeout / freq;
+
+	pr_info("WDT driver for MPC83xx initialized. mode:%s timeout=%d "
+		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
+		timeout_sec);
+
+	/*
+	 * If the watchdog was previously enabled or we're running on
+	 * MPC86xx, we should ping the wdt from the kernel until the
+	 * userspace handles it.
+	 */
+	if (enabled)
+		mpc83xx_wdt_timer_ping(0);
+	return 0;
+err_unmap:
+	iounmap(wd_base);
+	return ret;
+}
+
+static int __devexit mpc83xx_wdt_remove(struct of_device *ofdev)
+{
+	mpc83xx_wdt_pr_warn("watchdog removed");
+	del_timer_sync(&wdt_timer);
+	misc_deregister(&mpc83xx_wdt_miscdev);
+	iounmap(wd_base);
+
+	return 0;
+}
+
+static const struct of_device_id mpc83xx_wdt_match[] = {
+	{
+		.compatible = "mpc83xx_wdt",
+		.data = &(struct mpc83xx_wdt_type) {
+			.prescaler = 0x10000,
+		},
+	},
+	{
+		.compatible = "fsl,mpc8610-wdt",
+		.data = &(struct mpc83xx_wdt_type) {
+			.prescaler = 0x10000,
+			.hw_enabled = true,
+		},
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, mpc83xx_wdt_match);
+
+static struct of_platform_driver mpc83xx_wdt_driver = {
+	.match_table	= mpc83xx_wdt_match,
+	.probe		= mpc83xx_wdt_probe,
+	.remove		= __devexit_p(mpc83xx_wdt_remove),
+	.driver		= {
+		.name	= "mpc83xx_wdt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init mpc83xx_wdt_init(void)
+{
+	return of_register_platform_driver(&mpc83xx_wdt_driver);
+}
+
+static void __exit mpc83xx_wdt_exit(void)
+{
+	of_unregister_platform_driver(&mpc83xx_wdt_driver);
+}
+
+subsys_initcall(mpc83xx_wdt_init);
+module_exit(mpc83xx_wdt_exit);
+
+MODULE_AUTHOR("Dave Updegraff, Kumar Gala");
+MODULE_DESCRIPTION("Driver for watchdog timer in MPC83xx/MPC86xx uProcessors");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
git-watchdog.patch
mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch
powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch

