From: akpm@linux-foundation.org
Subject: + watchdog-sb_wdog-clean-up-and-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:37 -0700
Message-ID: <200805200828.m4K8SbEK013188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761454AbYETI3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: sb_wdog: Clean up and switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-sb_wdog-clean-up-and-switch-to-unlocked_ioctl.patch

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
Subject: watchdog: sb_wdog: Clean up and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/sb_wdog.c |   78 +++++++++++++++++------------------
 1 file changed, 40 insertions(+), 38 deletions(-)

diff -puN drivers/watchdog/sb_wdog.c~watchdog-sb_wdog-clean-up-and-switch-to-unlocked_ioctl drivers/watchdog/sb_wdog.c
--- a/drivers/watchdog/sb_wdog.c~watchdog-sb_wdog-clean-up-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/sb_wdog.c
@@ -57,6 +57,7 @@
 #include <asm/sibyte/sb1250_int.h>
 #include <asm/sibyte/sb1250_scd.h>
 
+static DEFINE_SPINLOCK(sbwd_lock);
 
 /*
  * set the initial count value of a timer
@@ -65,8 +66,10 @@
  */
 void sbwdog_set(char __iomem *wdog, unsigned long t)
 {
+	spin_lock(&sbwd_lock);
 	__raw_writeb(0, wdog - 0x10);
 	__raw_writeq(t & 0x7fffffUL, wdog);
+	spin_unlock(&sbwd_lock);
 }
 
 /*
@@ -77,7 +80,9 @@ void sbwdog_set(char __iomem *wdog, unsi
  */
 void sbwdog_pet(char __iomem *wdog)
 {
+	spin_lock(&sbwd_lock);
 	__raw_writeb(__raw_readb(wdog) | 1, wdog);
+	spin_unlock(&sbwd_lock);
 }
 
 static unsigned long sbwdog_gate; /* keeps it to one thread only */
@@ -86,8 +91,9 @@ static char __iomem *user_dog = (char __
 static unsigned long timeout = 0x7fffffUL;	/* useconds: 8.3ish secs. */
 static int expect_close;
 
-static struct watchdog_info ident = {
-	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+static const struct watchdog_info ident = {
+	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT |
+						WDIOF_KEEPALIVEPING,
 	.identity	= "SiByte Watchdog",
 };
 
@@ -97,9 +103,8 @@ static struct watchdog_info ident = {
 static int sbwdog_open(struct inode *inode, struct file *file)
 {
 	nonseekable_open(inode, file);
-	if (test_and_set_bit(0, &sbwdog_gate)) {
+	if (test_and_set_bit(0, &sbwdog_gate))
 		return -EBUSY;
-	}
 	__module_get(THIS_MODULE);
 
 	/*
@@ -120,8 +125,9 @@ static int sbwdog_release(struct inode *
 		__raw_writeb(0, user_dog);
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT "%s: Unexpected close, not stopping watchdog!\n",
-			ident.identity);
+		printk(KERN_CRIT
+			"%s: Unexpected close, not stopping watchdog!\n",
+						ident.identity);
 		sbwdog_pet(user_dog);
 	}
 	clear_bit(0, &sbwdog_gate);
@@ -147,12 +153,10 @@ static ssize_t sbwdog_write(struct file 
 		for (i = 0; i != len; i++) {
 			char c;
 
-			if (get_user(c, data + i)) {
+			if (get_user(c, data + i))
 				return -EFAULT;
-			}
-			if (c == 'V') {
+			if (c == 'V')
 				expect_close = 42;
-			}
 		}
 		sbwdog_pet(user_dog);
 	}
@@ -160,8 +164,8 @@ static ssize_t sbwdog_write(struct file 
 	return len;
 }
 
-static int sbwdog_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long sbwdog_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int ret = -ENOTTY;
 	unsigned long time;
@@ -180,9 +184,8 @@ static int sbwdog_ioctl(struct inode *in
 
 	case WDIOC_SETTIMEOUT:
 		ret = get_user(time, p);
-		if (ret) {
+		if (ret)
 			break;
-		}
 
 		time *= 1000000;
 		if (time > 0x7fffffUL) {
@@ -226,18 +229,16 @@ sbwdog_notify_sys(struct notifier_block 
 	return NOTIFY_DONE;
 }
 
-static const struct file_operations sbwdog_fops =
-{
+static const struct file_operations sbwdog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= sbwdog_write,
-	.ioctl		= sbwdog_ioctl,
+	.unlocked_ioctl	= sbwdog_ioctl,
 	.open		= sbwdog_open,
 	.release	= sbwdog_release,
 };
 
-static struct miscdevice sbwdog_miscdev =
-{
+static struct miscdevice sbwdog_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &sbwdog_fops,
@@ -267,13 +268,12 @@ irqreturn_t sbwdog_interrupt(int irq, vo
 	/*
 	 * if it's the second watchdog timer, it's for those users
 	 */
-	if (wd_cfg_reg == user_dog) {
+	if (wd_cfg_reg == user_dog)
 		printk(KERN_CRIT
 			"%s in danger of initiating system reset in %ld.%01ld seconds\n",
 			ident.identity, wd_init / 1000000, (wd_init / 100000) % 10);
-	} else {
+	else
 		cfg |= 1;
-	}
 
 	__raw_writeb(cfg, wd_cfg_reg);
 
@@ -289,28 +289,31 @@ static int __init sbwdog_init(void)
 	 */
 	ret = register_reboot_notifier(&sbwdog_notifier);
 	if (ret) {
-		printk (KERN_ERR "%s: cannot register reboot notifier (err=%d)\n",
-			ident.identity, ret);
+		printk(KERN_ERR
+			"%s: cannot register reboot notifier (err=%d)\n",
+						ident.identity, ret);
 		return ret;
 	}
 
 	/*
 	 * get the resources
 	 */
-	ret = misc_register(&sbwdog_miscdev);
-	if (ret == 0) {
-		printk(KERN_INFO "%s: timeout is %ld.%ld secs\n", ident.identity,
-			timeout / 1000000, (timeout / 100000) % 10);
-	}
 
 	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
 		ident.identity, (void *)user_dog);
 	if (ret) {
-		printk(KERN_ERR "%s: failed to request irq 1 - %d\n", ident.identity,
-			ret);
-		misc_deregister(&sbwdog_miscdev);
+		printk(KERN_ERR "%s: failed to request irq 1 - %d\n",
+						ident.identity, ret);
+		return ret;
 	}
 
+	ret = misc_register(&sbwdog_miscdev);
+	if (ret == 0) {
+		printk(KERN_INFO "%s: timeout is %ld.%ld secs\n",
+				ident.identity,
+				timeout / 1000000, (timeout / 100000) % 10);
+	} else
+		free_irq(1, (void *)user_dog);
 	return ret;
 }
 
@@ -327,7 +330,7 @@ MODULE_DESCRIPTION("SiByte Watchdog");
 
 module_param(timeout, ulong, 0);
 MODULE_PARM_DESC(timeout,
-	"Watchdog timeout in microseconds (max/default 8388607 or 8.3ish secs)");
+      "Watchdog timeout in microseconds (max/default 8388607 or 8.3ish secs)");
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
@@ -336,16 +339,15 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
  * example code that can be put in a platform code area to utilize the
  * first watchdog timer for the kernels own purpose.
 
- void
-platform_wd_setup(void)
+void platform_wd_setup(void)
 {
 	int ret;
 
-	ret = request_irq(0, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
 		"Kernel Watchdog", IOADDR(A_SCD_WDOG_CFG_0));
 	if (ret) {
-		printk(KERN_CRIT "Watchdog IRQ zero(0) failed to be requested - %d\n",
-			ret);
+		printk(KERN_CRIT
+		  "Watchdog IRQ zero(0) failed to be requested - %d\n", ret);
 	}
 }
 
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

