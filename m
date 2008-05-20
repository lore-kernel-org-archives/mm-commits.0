From: akpm@linux-foundation.org
Subject: + watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:43 -0700
Message-ID: <200805200828.m4K8ShjT013197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761528AbYETI3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: scx200_wdt: clean up and switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl.patch

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
Subject: watchdog: scx200_wdt: clean up and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/sc520_wdt.c  |    4 +-
 drivers/watchdog/scx200_wdt.c |   59 ++++++++++++++++----------------
 2 files changed, 32 insertions(+), 31 deletions(-)

diff -puN drivers/watchdog/sc520_wdt.c~watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl drivers/watchdog/sc520_wdt.c
--- a/drivers/watchdog/sc520_wdt.c~watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/sc520_wdt.c
@@ -279,7 +279,7 @@ static int fop_close(struct inode *inode
 	return 0;
 }
 
-static int fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -345,7 +345,7 @@ static const struct file_operations wdt_
 	.write		= fop_write,
 	.open		= fop_open,
 	.release	= fop_close,
-	.ioctl		= fop_ioctl,
+	.unlocked_ioctl	= fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
diff -puN drivers/watchdog/scx200_wdt.c~watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl drivers/watchdog/scx200_wdt.c
--- a/drivers/watchdog/scx200_wdt.c~watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/scx200_wdt.c
@@ -27,9 +27,8 @@
 #include <linux/fs.h>
 #include <linux/ioport.h>
 #include <linux/scx200.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define NAME "scx200_wdt"
 
@@ -47,8 +46,9 @@ module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
 
 static u16 wdto_restart;
-static struct semaphore open_semaphore;
 static char expect_close;
+static unsigned long open_lock;
+static DEFINE_SPINLOCK(scx_lock);
 
 /* Bits of the WDCNFG register */
 #define W_ENABLE 0x00fa		/* Enable watchdog */
@@ -59,7 +59,9 @@ static char expect_close;
 
 static void scx200_wdt_ping(void)
 {
+	spin_lock(&scx_lock);
 	outw(wdto_restart, scx200_cb_base + SCx200_WDT_WDTO);
+	spin_unlock(&scx_lock);
 }
 
 static void scx200_wdt_update_margin(void)
@@ -73,9 +75,11 @@ static void scx200_wdt_enable(void)
 	printk(KERN_DEBUG NAME ": enabling watchdog timer, wdto_restart = %d\n",
 	       wdto_restart);
 
+	spin_lock(&scx_lock);
 	outw(0, scx200_cb_base + SCx200_WDT_WDTO);
 	outb(SCx200_WDT_WDSTS_WDOVF, scx200_cb_base + SCx200_WDT_WDSTS);
 	outw(W_ENABLE, scx200_cb_base + SCx200_WDT_WDCNFG);
+	spin_unlock(&scx_lock);
 
 	scx200_wdt_ping();
 }
@@ -84,15 +88,17 @@ static void scx200_wdt_disable(void)
 {
 	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
 
+	spin_lock(&scx_lock);
 	outw(0, scx200_cb_base + SCx200_WDT_WDTO);
 	outb(SCx200_WDT_WDSTS_WDOVF, scx200_cb_base + SCx200_WDT_WDSTS);
 	outw(W_DISABLE, scx200_cb_base + SCx200_WDT_WDCNFG);
+	spin_unlock(&scx_lock);
 }
 
 static int scx200_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (!down_nowait(&open_semaphore))
+	if (test_and_set_bit(0, &open_lock))
 		return -EBUSY;
 	scx200_wdt_enable();
 
@@ -101,13 +107,12 @@ static int scx200_wdt_open(struct inode 
 
 static int scx200_wdt_release(struct inode *inode, struct file *file)
 {
-	if (expect_close != 42) {
+	if (expect_close != 42)
 		printk(KERN_WARNING NAME ": watchdog device closed unexpectedly, will not disable the watchdog timer\n");
-	} else if (!nowayout) {
+	else if (!nowayout)
 		scx200_wdt_disable();
-	}
 	expect_close = 0;
-	up(&open_semaphore);
+	clear_bit(0, &open_lock);
 
 	return 0;
 }
@@ -122,8 +127,7 @@ static int scx200_wdt_notify_sys(struct 
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block scx200_wdt_notifier =
-{
+static struct notifier_block scx200_wdt_notifier = {
 	.notifier_call = scx200_wdt_notify_sys,
 };
 
@@ -131,8 +135,7 @@ static ssize_t scx200_wdt_write(struct f
 				     size_t len, loff_t *ppos)
 {
 	/* check for a magic close character */
-	if (len)
-	{
+	if (len) {
 		size_t i;
 
 		scx200_wdt_ping();
@@ -152,15 +155,15 @@ static ssize_t scx200_wdt_write(struct f
 	return 0;
 }
 
-static int scx200_wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long scx200_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.identity = "NatSemi SCx200 Watchdog",
 		.firmware_version = 1,
-		.options = (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING),
+		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	};
 	int new_margin;
 
@@ -168,7 +171,7 @@ static int scx200_wdt_ioctl(struct inode
 	default:
 		return -ENOTTY;
 	case WDIOC_GETSUPPORT:
-		if(copy_to_user(argp, &ident, sizeof(ident)))
+		if (copy_to_user(argp, &ident, sizeof(ident)))
 			return -EFAULT;
 		return 0;
 	case WDIOC_GETSTATUS:
@@ -195,18 +198,18 @@ static int scx200_wdt_ioctl(struct inode
 }
 
 static const struct file_operations scx200_wdt_fops = {
-	.owner	 = THIS_MODULE,
-	.llseek	 = no_llseek,
-	.write   = scx200_wdt_write,
-	.ioctl   = scx200_wdt_ioctl,
-	.open    = scx200_wdt_open,
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = scx200_wdt_write,
+	.unlocked_ioctl = scx200_wdt_ioctl,
+	.open = scx200_wdt_open,
 	.release = scx200_wdt_release,
 };
 
 static struct miscdevice scx200_wdt_miscdev = {
 	.minor = WATCHDOG_MINOR,
-	.name  = "watchdog",
-	.fops  = &scx200_wdt_fops,
+	.name = "watchdog",
+	.fops = &scx200_wdt_fops,
 };
 
 static int __init scx200_wdt_init(void)
@@ -229,8 +232,6 @@ static int __init scx200_wdt_init(void)
 	scx200_wdt_update_margin();
 	scx200_wdt_disable();
 
-	sema_init(&open_semaphore, 1);
-
 	r = register_reboot_notifier(&scx200_wdt_notifier);
 	if (r) {
 		printk(KERN_ERR NAME ": unable to register reboot notifier");
@@ -263,7 +264,7 @@ module_exit(scx200_wdt_cleanup);
 
 /*
     Local variables:
-        compile-command: "make -k -C ../.. SUBDIRS=drivers/char modules"
-        c-basic-offset: 8
+	compile-command: "make -k -C ../.. SUBDIRS=drivers/char modules"
+	c-basic-offset: 8
     End:
 */
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

