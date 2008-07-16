From: akpm@linux-foundation.org
Subject: - watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:03 -0700
Message-ID: <200807162137.m6GLb3MM014342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757987AbYGPVhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: scx200_wdt: clean up and switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
-	if (down_trylock(&open_semaphore))
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

origin.patch
linux-next.patch
ia64-hp-sim-simserialc-adapt-to-new-tty-framework.patch
remove-is_tty.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
hamradio-add-missing-sanity-check-to-tty-operation.patch
git-watchdog.patch
serial-8250_gscc-add-module_license.patch
serial-add-support-for-a-no-name-4-ports-multiserial-card.patch
istallion-remove-unused-variable.patch
stallion-removed-unused-variable.patch
spidev-bkl-removal.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
unexport-proc_clear_tty.patch

