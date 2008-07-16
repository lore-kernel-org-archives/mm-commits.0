From: akpm@linux-foundation.org
Subject: - watchdog-eurotechwdt-unlocked_ioctl-code-lock-check-and-tidy.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:59 -0700
Message-ID: <200807162135.m6GLZxU1014144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756897AbYGPVgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:36:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: eurotechwdt: unlocked_ioctl, code lock check and tidy
has been removed from the -mm tree.  Its filename was
     watchdog-eurotechwdt-unlocked_ioctl-code-lock-check-and-tidy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

