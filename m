From: akpm@linux-foundation.org
Subject: + watchdog-eurotechwdt-unlocked_ioctl-code-lock-check-and-tidy.patch added to -mm tree
Date: Tue, 20 May 2008 01:27:53 -0700
Message-ID: <200805200827.m4K8RrTM013075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759791AbYETI2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: eurotechwdt: unlocked_ioctl, code lock check and tidy
has been added to the -mm tree.  Its filename is
     watchdog-eurotechwdt-unlocked_ioctl-code-lock-check-and-tidy.patch

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
Subject: watchdog: eurotechwdt: unlocked_ioctl, code lock check and tidy
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/eurotechwdt.c |   57 +++++++++++++++++++------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff -puN drivers/watchdog/eurotechwdt.c~watchdog-eurotechwdt-unlocked_ioctl-code-lock-check-and-tidy drivers/watchdog/eurotechwdt.c
--- a/drivers/watchdog/eurotechwdt.c~watchdog-eurotechwdt-unlocked_ioctl-code-lock-check-and-tidy
+++ a/drivers/watchdog/eurotechwdt.c
@@ -56,14 +56,15 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static unsigned long eurwdt_is_open;
 static int eurwdt_timeout;
 static char eur_expect_close;
+static spinlock_t eurwdt_lock;
 
 /*
  * You must set these - there is no sane way to probe for this board.
@@ -78,7 +79,9 @@ static char *ev = "int";
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Some symbolic names
@@ -137,7 +140,8 @@ static void eurwdt_activate_timer(void)
 {
 	eurwdt_disable_timer();
 	eurwdt_write_reg(WDT_CTRL_REG, 0x01);	/* activate the WDT */
-	eurwdt_write_reg(WDT_OUTPIN_CFG, !strcmp("int", ev) ? WDT_EVENT_INT : WDT_EVENT_REBOOT);
+	eurwdt_write_reg(WDT_OUTPIN_CFG,
+		!strcmp("int", ev) ? WDT_EVENT_INT : WDT_EVENT_REBOOT);
 
 	/* Setting interrupt line */
 	if (irq == 2 || irq > 15 || irq < 0) {
@@ -206,21 +210,21 @@ size_t count, loff_t *ppos)
 
 			for (i = 0; i != count; i++) {
 				char c;
-				if(get_user(c, buf+i))
+				if (get_user(c, buf+i))
 					return -EFAULT;
 				if (c == 'V')
 					eur_expect_close = 42;
 			}
 		}
+		spin_lock(&eurwdt_lock);
 		eurwdt_ping();	/* the default timeout */
+		spin_unlock(&eurwdt_lock);
 	}
-
 	return count;
 }
 
 /**
  * eurwdt_ioctl:
- * @inode: inode of the device
  * @file: file handle to the device
  * @cmd: watchdog command
  * @arg: argument pointer
@@ -229,13 +233,14 @@ size_t count, loff_t *ppos)
  * according to their available features.
  */
 
-static int eurwdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long eurwdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	static struct watchdog_info ident = {
-		.options	  = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.options	  = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity	  = "WDT Eurotech CPU-1220/1410",
 	};
@@ -243,7 +248,7 @@ static int eurwdt_ioctl(struct inode *in
 	int time;
 	int options, retval = -EINVAL;
 
-	switch(cmd) {
+	switch (cmd) {
 	default:
 		return -ENOTTY;
 
@@ -255,7 +260,9 @@ static int eurwdt_ioctl(struct inode *in
 		return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
+		spin_lock(&eurwdt_lock);
 		eurwdt_ping();
+		spin_unlock(&eurwdt_lock);
 		return 0;
 
 	case WDIOC_SETTIMEOUT:
@@ -266,8 +273,10 @@ static int eurwdt_ioctl(struct inode *in
 		if (time < 0 || time > 255)
 			return -EINVAL;
 
+		spin_lock(&eurwdt_lock);
 		eurwdt_timeout = time;
 		eurwdt_set_timeout(time);
+		spin_unlock(&eurwdt_lock);
 		/* Fall */
 
 	case WDIOC_GETTIMEOUT:
@@ -276,6 +285,7 @@ static int eurwdt_ioctl(struct inode *in
 	case WDIOC_SETOPTIONS:
 		if (get_user(options, p))
 			return -EFAULT;
+		spin_lock(&eurwdt_lock);
 		if (options & WDIOS_DISABLECARD) {
 			eurwdt_disable_timer();
 			retval = 0;
@@ -285,6 +295,7 @@ static int eurwdt_ioctl(struct inode *in
 			eurwdt_ping();
 			retval = 0;
 		}
+		spin_unlock(&eurwdt_lock);
 		return retval;
 	}
 }
@@ -322,10 +333,11 @@ static int eurwdt_open(struct inode *ino
 
 static int eurwdt_release(struct inode *inode, struct file *file)
 {
-	if (eur_expect_close == 42) {
+	if (eur_expect_close == 42)
 		eurwdt_disable_timer();
-	} else {
-		printk(KERN_CRIT "eurwdt: Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT
+			"eurwdt: Unexpected close, not stopping watchdog!\n");
 		eurwdt_ping();
 	}
 	clear_bit(0, &eurwdt_is_open);
@@ -362,11 +374,11 @@ static int eurwdt_notify_sys(struct noti
 
 
 static const struct file_operations eurwdt_fops = {
-	.owner	= THIS_MODULE,
-	.llseek	= no_llseek,
-	.write	= eurwdt_write,
-	.ioctl	= eurwdt_ioctl,
-	.open	= eurwdt_open,
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= eurwdt_write,
+	.unlocked_ioctl	= eurwdt_ioctl,
+	.open		= eurwdt_open,
 	.release	= eurwdt_release,
 };
 
@@ -419,7 +431,7 @@ static int __init eurwdt_init(void)
 	int ret;
 
 	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
-	if(ret) {
+	if (ret) {
 		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
 		goto out;
 	}
@@ -432,10 +444,13 @@ static int __init eurwdt_init(void)
 
 	ret = register_reboot_notifier(&eurwdt_notifier);
 	if (ret) {
-		printk(KERN_ERR "eurwdt: can't register reboot notifier (err=%d)\n", ret);
+		printk(KERN_ERR
+		    "eurwdt: can't register reboot notifier (err=%d)\n", ret);
 		goto outreg;
 	}
 
+	spin_lock_init(&eurwdt_lock);
+
 	ret = misc_register(&eurwdt_miscdev);
 	if (ret) {
 		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
_

Patches currently in -mm which might be from alan@redhat.com are

linux-next.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
watchdog-clean-acquirewdt-and-check-for-bkl-dependancies.patch
watchdog-clean-up-and-check-advantech-watchdog.patch
watchdog-ali-watchdog-locking-and-style.patch
watchdog-ar7-watchdog.patch
watchdog-atp-watchdog.patch
watchdog-at91-watchdog-to-unlocked_ioctl.patch
watchdog-cpu5_wdt-switch-to-unlocked_ioctl.patch
watchdog-davinci_wdt-unlocked_ioctl-and-check-locking.patch
watchdog-ep93xx_wdt-unlocked_ioctl.patch
watchdog-eurotechwdt-unlocked_ioctl-code-lock-check-and-tidy.patch
watchdog-hpwdt-couple-of-include-cleanups.patch
watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-i6300esb-style-unlocked_ioctl-cleanup.patch
watchdog-ibmasr-coding-style-locking-verify.patch
watchdog-indydog-clean-up-and-tidy.patch
watchdog-iop-watchdog-switch-to-unlocked_ioctl.patch
watchdog-it8712f-unlocked_ioctl.patch
watchdog-bfin-watchdog-cleanup-and-unlocked_ioctl.patch
watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl.patch
watchdog-ixp4xx_wdt-unlocked_ioctl.patch
watchdog-ks8695_wdt-clean-up-coding-style-unlocked_ioctl.patch
watchdog-machzwd-clean-up-coding-style-unlocked_ioctl.patch
watchdog-mixcomwd-coding-style-locking-unlocked_ioctl.patch
watchdog-mpc-watchdog-clean-up-and-locking.patch
watchdog-mpcore-watchdog-unlocked_ioctl-and-bkl-work.patch
watchdog-mtx-1_wdt-clean-up-coding-style-unlocked-ioctl.patch
watchdog-mv64x60_wdt-clean-up-and-locking-checks.patch
watchdog-omap_wdt-locking-unlocked_ioctl-tidy.patch
watchdog-pc87413_wdt-clean-up-coding-style-unlocked_ioctl.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage.patch
watchdog-pnx4008_wdt-unlocked_ioctl-setup.patch
watchdog-rm9k_wdt-clean-up.patch
watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl.patch
watchdog-sa1100_wdt-switch-to-unlocked_ioctl.patch
watchdog-sbc60xxwdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-stg7240_wdt-unlocked_ioctl.patch
watchdog-sbc8360-clean-up.patch
watchdog-sbc_epx_c3_wdt-switch-to-unlocked_ioctl.patch
watchdog-sb_wdog-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-sc1200_wdt-clean-up-fix-locking-and-use-unlocked_ioctl.patch
watchdog-sc520_wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-shwdt-coding-style-cleanup-switch-to-unlocked_ioctl.patch
watchdog-smsc37b787_wdt-coding-style-switch-to-unlocked_ioctl.patch
watchdog-softdog-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-txx9-fix-locking-switch-to-unlocked_ioctl.patch
watchdog-w83627hf-coding-style-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-w83877f_wdt-clean-up-code-coding-style-switch-to-unlocked_ioctl.patch
watchdog-w83977f_wdt-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-wafer5823wdt-clean-up-coding-style-switch-to-unlocked_ioctl.patch
watchdog-wdrtas-clean-up-coding-style-switch-to-unlocked_ioctl.patch
watchdog-wdt285-switch-to-unlocked_ioctl-and-tidy-up-oddments-of-coding-style.patch
watchdog-wdt977-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
mm-fix-atomic_t-overflow-in-vm.patch
serial-8250_gscc-add-module_license.patch
remove-is_tty.patch
riscom8-remove-redundant-null-pointer-test.patch
unexport-proc_clear_tty.patch

