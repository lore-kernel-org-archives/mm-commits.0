From: akpm@linux-foundation.org
Subject: + mpc83xx_wdt-add-support-for-mpc86xx-cpus.patch added to -mm tree
Date: Tue, 03 Jun 2008 16:40:51 -0700
Message-ID: <200806032340.m53Neq9G025884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286AbYFCXlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 19:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, galak@kernel.crashing.org, wim@iguana.be


The patch titled
     mpc83xx_wdt: add support for MPC86xx CPUs
has been added to the -mm tree.  Its filename is
     mpc83xx_wdt-add-support-for-mpc86xx-cpus.patch

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
Subject: mpc83xx_wdt: add support for MPC86xx CPUs
From: Anton Vorontsov <avorontsov@ru.mvista.com>

On MPC86xx the watchdog could be enabled only at power-on-reset, and could
not be disabled afterwards.  We must ping the watchdog from the kernel
until the userspace handles it.

MPC83xx CPUs are only differ in a way that watchdog could be disabled
once, but after it was enabled via software it becomes just the same as
MPC86xx.

Thus, to support MPC86xx I added the kernel timer which pings the watchdog
until the userspace opens it.

Since we implemented the timer, now we're able to implement proper
handling for the CONFIG_WATCHDOG_NOWAYOUT case, for MPC83xx and MPC86xx.

Also move the probe code into subsys_initcall, because we want start
pinging the watchdog ASAP, and misc devices are available in
subsys_initcall.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig       |    4 -
 drivers/watchdog/mpc83xx_wdt.c |   80 +++++++++++++++++++++++++++----
 2 files changed, 74 insertions(+), 10 deletions(-)

diff -puN drivers/watchdog/Kconfig~mpc83xx_wdt-add-support-for-mpc86xx-cpus drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~mpc83xx_wdt-add-support-for-mpc86xx-cpus
+++ a/drivers/watchdog/Kconfig
@@ -704,8 +704,8 @@ config 8xx_WDT
 	depends on 8xx
 
 config 83xx_WDT
-	tristate "MPC83xx Watchdog Timer"
-	depends on PPC_83xx
+	tristate "MPC83xx/MPC86xx Watchdog Timer"
+	depends on PPC_83xx || PPC_86xx
 
 config MV64X60_WDT
 	tristate "MV64X60 (Marvell Discovery) Watchdog Timer"
diff -puN drivers/watchdog/mpc83xx_wdt.c~mpc83xx_wdt-add-support-for-mpc86xx-cpus drivers/watchdog/mpc83xx_wdt.c
--- a/drivers/watchdog/mpc83xx_wdt.c~mpc83xx_wdt-add-support-for-mpc86xx-cpus
+++ a/drivers/watchdog/mpc83xx_wdt.c
@@ -1,10 +1,12 @@
 /*
- * mpc83xx_wdt.c - MPC83xx watchdog userspace interface
+ * mpc83xx_wdt.c - MPC83xx/MPC86xx watchdog userspace interface
  *
  * Authors: Dave Updegraff <dave@cray.org>
  * 	    Kumar Gala <galak@kernel.crashing.org>
  * 		Attribution: from 83xx_wst: Florian Schirmer <jolt@tuxbox.org>
  * 				..and from sc520_wdt
+ * Copyright (c) 2008  MontaVista Software, Inc.
+ *                     Anton Vorontsov <avorontsov@ru.mvista.com>
  *
  * Note: it appears that you can only actually ENABLE or DISABLE the thing
  * once after POR. Once enabled, you cannot disable, and vice versa.
@@ -18,6 +20,7 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/timer.h>
 #include <linux/miscdevice.h>
 #include <linux/of_platform.h>
 #include <linux/module.h>
@@ -39,6 +42,11 @@ struct mpc83xx_wdt {
 	u8 res2[0xF0];
 };
 
+struct mpc83xx_wdt_type {
+	int prescaler;
+	bool hw_enabled;
+};
+
 static struct mpc83xx_wdt __iomem *wd_base;
 
 static u16 timeout = 0xffff;
@@ -51,6 +59,11 @@ module_param(reset, bool, 0);
 MODULE_PARM_DESC(reset,
 	"Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");
 
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+		 "(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
 /*
  * We always prescale, but if someone really doesn't want to they can set this
  * to 0
@@ -70,6 +83,22 @@ static void mpc83xx_wdt_keepalive(void)
 	spin_unlock(&wdt_spinlock);
 }
 
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
 static ssize_t mpc83xx_wdt_write(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
@@ -85,7 +114,8 @@ static int mpc83xx_wdt_open(struct inode
 		return -EBUSY;
 
 	/* Once we start the watchdog we can't stop it */
-	__module_get(THIS_MODULE);
+	if (nowayout)
+		__module_get(THIS_MODULE);
 
 	/* Good, fire up the show */
 	if (prescale)
@@ -97,13 +127,17 @@ static int mpc83xx_wdt_open(struct inode
 
 	out_be32(&wd_base->swcrr, tmp);
 
+	del_timer_sync(&wdt_timer);
+
 	return nonseekable_open(inode, file);
 }
 
 static int mpc83xx_wdt_release(struct inode *inode, struct file *file)
 {
-	printk(KERN_CRIT "Unexpected close, not stopping watchdog!\n");
-	mpc83xx_wdt_keepalive();
+	if (!nowayout)
+		mpc83xx_wdt_timer_ping(0);
+	else
+		mpc83xx_wdt_pr_warn("watchdog closed");
 	clear_bit(0, &wdt_is_open);
 	return 0;
 }
@@ -154,15 +188,25 @@ static int __devinit mpc83xx_wdt_probe(s
 				       const struct of_device_id *match)
 {
 	int ret;
+	struct device_node *np = ofdev->node;
+	struct mpc83xx_wdt_type *wdt_type = match->data;
 	u32 freq = fsl_get_sys_freq();
+	bool enabled;
 
 	if (!freq || freq == -1)
 		return -EINVAL;
 
-	wd_base = of_iomap(ofdev->node, 0);
+	wd_base = of_iomap(np, 0);
 	if (!wd_base)
 		return -ENOMEM;
 
+	enabled = in_be32(&wd_base->swcrr) & SWCRR_SWEN;
+	if (!enabled && wdt_type->hw_enabled) {
+		pr_info("mpc83xx_wdt: could not be enabled in software\n");
+		ret = -ENOSYS;
+		goto err_unmap;
+	}
+
 	ret = misc_register(&mpc83xx_wdt_miscdev);
 	if (ret) {
 		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
@@ -172,13 +216,21 @@ static int __devinit mpc83xx_wdt_probe(s
 
 	/* Calculate the timeout in seconds */
 	if (prescale)
-		timeout_sec = (timeout * 0x10000) / freq;
+		timeout_sec = (timeout * wdt_type->prescaler) / freq;
 	else
 		timeout_sec = timeout / freq;
 
 	pr_info("WDT driver for MPC83xx initialized. mode:%s timeout=%d "
 		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
 		timeout_sec);
+
+	/*
+	 * If the watchdog was previously enabled or we're running on
+	 * MPC86xx, we should ping the wdt from the kernel until the
+	 * userspace handles it.
+	 */
+	if (enabled)
+		mpc83xx_wdt_timer_ping(0);
 	return 0;
 err_unmap:
 	iounmap(wd_base);
@@ -187,6 +239,8 @@ err_unmap:
 
 static int __devexit mpc83xx_wdt_remove(struct of_device *ofdev)
 {
+	mpc83xx_wdt_pr_warn("watchdog removed");
+	del_timer_sync(&wdt_timer);
 	misc_deregister(&mpc83xx_wdt_miscdev);
 	iounmap(wd_base);
 
@@ -196,6 +250,16 @@ static int __devexit mpc83xx_wdt_remove(
 static const struct of_device_id mpc83xx_wdt_match[] = {
 	{
 		.compatible = "mpc83xx_wdt",
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
 	},
 	{},
 };
@@ -221,10 +285,10 @@ static void __exit mpc83xx_wdt_exit(void
 	of_unregister_platform_driver(&mpc83xx_wdt_driver);
 }
 
-module_init(mpc83xx_wdt_init);
+subsys_initcall(mpc83xx_wdt_init);
 module_exit(mpc83xx_wdt_exit);
 
 MODULE_AUTHOR("Dave Updegraff, Kumar Gala");
-MODULE_DESCRIPTION("Driver for watchdog timer in MPC83xx uProcessor");
+MODULE_DESCRIPTION("Driver for watchdog timer in MPC83xx/MPC86xx uProcessors");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
serial-fix-driver_name-conflicts.patch
linux-next.patch
git-leds.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch
mpc83xx_wdt-add-support-for-mpc86xx-cpus.patch
mpc83xx_wdt-rename-to-mpc8xxx_wdt.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch
mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch
hgafb-fix-module-removal.patch
fsl_soc-remove-mpc83xx_wdt-code.patch
86xx-mpc8610_hpcd-add-watchdog-node.patch

