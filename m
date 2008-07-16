From: akpm@linux-foundation.org
Subject: - watchdog-machzwd-clean-up-coding-style-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:23 -0700
Message-ID: <200807162136.m6GLaNJZ014193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757687AbYGPVqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: machzwd: clean up, coding style, unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-machzwd-clean-up-coding-style-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: machzwd: clean up, coding style, unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/machzwd.c |  108 ++++++++++++-----------------------
 1 file changed, 40 insertions(+), 68 deletions(-)

diff -puN drivers/watchdog/machzwd.c~watchdog-machzwd-clean-up-coding-style-unlocked_ioctl drivers/watchdog/machzwd.c
--- a/drivers/watchdog/machzwd.c~watchdog-machzwd-clean-up-coding-style-unlocked_ioctl
+++ a/drivers/watchdog/machzwd.c
@@ -40,9 +40,9 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 /* ports */
@@ -95,7 +95,9 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #define PFX "machzwd"
 
@@ -114,7 +116,7 @@ static struct watchdog_info zf_info = {
  * 3 = GEN_SCI
  * defaults to GEN_RESET (0)
  */
-static int action = 0;
+static int action;
 module_param(action, int, 0);
 MODULE_PARM_DESC(action, "after watchdog resets, generate: 0 = RESET(*)  1 = SMI  2 = NMI  3 = SCI");
 
@@ -123,10 +125,9 @@ static void zf_ping(unsigned long data);
 static int zf_action = GEN_RESET;
 static unsigned long zf_is_open;
 static char zf_expect_close;
-static DEFINE_SPINLOCK(zf_lock);
 static DEFINE_SPINLOCK(zf_port_lock);
 static DEFINE_TIMER(zf_timer, zf_ping, 0, 0);
-static unsigned long next_heartbeat = 0;
+static unsigned long next_heartbeat;
 
 
 /* timeout for user land heart beat (10 seconds) */
@@ -171,13 +172,13 @@ static inline void zf_set_control(unsign
 
 static inline void zf_set_timer(unsigned short new, unsigned char n)
 {
-	switch(n){
-		case WD1:
-			zf_writew(COUNTER_1, new);
-		case WD2:
-			zf_writeb(COUNTER_2, new > 0xff ? 0xff : new);
-		default:
-			return;
+	switch (n) {
+	case WD1:
+		zf_writew(COUNTER_1, new);
+	case WD2:
+		zf_writeb(COUNTER_2, new > 0xff ? 0xff : new);
+	default:
+		return;
 	}
 }
 
@@ -241,10 +242,8 @@ static void zf_ping(unsigned long data)
 
 	zf_writeb(COUNTER_2, 0xff);
 
-	if(time_before(jiffies, next_heartbeat)){
-
+	if (time_before(jiffies, next_heartbeat)) {
 		dprintk("time_before: %ld\n", next_heartbeat - jiffies);
-
 		/*
 		 * reset event is activated by transition from 0 to 1 on
 		 * RESET_WD1 bit and we assume that it is already zero...
@@ -261,24 +260,21 @@ static void zf_ping(unsigned long data)
 		spin_unlock_irqrestore(&zf_port_lock, flags);
 
 		mod_timer(&zf_timer, jiffies + ZF_HW_TIMEO);
-	}else{
+	} else
 		printk(KERN_CRIT PFX ": I will reset your machine\n");
-	}
 }
 
 static ssize_t zf_write(struct file *file, const char __user *buf, size_t count,
 								loff_t *ppos)
 {
 	/* See if we got the magic character */
-	if(count){
-
+	if (count) {
 		/*
 		 * no need to check for close confirmation
 		 * no way to disable watchdog ;)
 		 */
 		if (!nowayout) {
 			size_t ofs;
-
 			/*
 			 * note: just in case someone wrote the magic character
 			 * five months ago...
@@ -286,11 +282,11 @@ static ssize_t zf_write(struct file *fil
 			zf_expect_close = 0;
 
 			/* now scan */
-			for (ofs = 0; ofs != count; ofs++){
+			for (ofs = 0; ofs != count; ofs++) {
 				char c;
 				if (get_user(c, buf + ofs))
 					return -EFAULT;
-				if (c == 'V'){
+				if (c == 'V') {
 					zf_expect_close = 42;
 					dprintk("zf_expect_close = 42\n");
 				}
@@ -303,14 +299,11 @@ static ssize_t zf_write(struct file *fil
 		 */
 		next_heartbeat = jiffies + ZF_USER_TIMEO;
 		dprintk("user ping at %ld\n", jiffies);
-
 	}
-
 	return count;
 }
 
-static int zf_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long zf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -319,55 +312,38 @@ static int zf_ioctl(struct inode *inode,
 		if (copy_to_user(argp, &zf_info, sizeof(zf_info)))
 			return -EFAULT;
 		break;
-
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
-
 	case WDIOC_KEEPALIVE:
 		zf_ping(0);
 		break;
-
 	default:
 		return -ENOTTY;
 	}
-
 	return 0;
 }
 
 static int zf_open(struct inode *inode, struct file *file)
 {
-	spin_lock(&zf_lock);
-	if(test_and_set_bit(0, &zf_is_open)) {
-		spin_unlock(&zf_lock);
+	if (test_and_set_bit(0, &zf_is_open))
 		return -EBUSY;
-	}
-
 	if (nowayout)
 		__module_get(THIS_MODULE);
-
-	spin_unlock(&zf_lock);
-
 	zf_timer_on();
-
 	return nonseekable_open(inode, file);
 }
 
 static int zf_close(struct inode *inode, struct file *file)
 {
-	if(zf_expect_close == 42){
+	if (zf_expect_close == 42)
 		zf_timer_off();
-	} else {
+	else {
 		del_timer(&zf_timer);
 		printk(KERN_ERR PFX ": device file closed unexpectedly. Will not stop the WDT!\n");
 	}
-
-	spin_lock(&zf_lock);
 	clear_bit(0, &zf_is_open);
-	spin_unlock(&zf_lock);
-
 	zf_expect_close = 0;
-
 	return 0;
 }
 
@@ -378,23 +354,18 @@ static int zf_close(struct inode *inode,
 static int zf_notify_sys(struct notifier_block *this, unsigned long code,
 								void *unused)
 {
-	if(code == SYS_DOWN || code == SYS_HALT){
+	if (code == SYS_DOWN || code == SYS_HALT)
 		zf_timer_off();
-	}
-
 	return NOTIFY_DONE;
 }
 
-
-
-
 static const struct file_operations zf_fops = {
-	.owner          = THIS_MODULE,
-	.llseek         = no_llseek,
-	.write          = zf_write,
-	.ioctl          = zf_ioctl,
-	.open           = zf_open,
-	.release        = zf_close,
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= zf_write,
+	.unlocked_ioctl = zf_ioctl,
+	.open		= zf_open,
+	.release	= zf_close,
 };
 
 static struct miscdevice zf_miscdev = {
@@ -402,7 +373,7 @@ static struct miscdevice zf_miscdev = {
 	.name = "watchdog",
 	.fops = &zf_fops,
 };
- 
+
 
 /*
  * The device needs to learn about soft shutdowns in order to
@@ -423,22 +394,23 @@ static int __init zf_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO PFX ": MachZ ZF-Logic Watchdog driver initializing.\n");
+	printk(KERN_INFO PFX
+		": MachZ ZF-Logic Watchdog driver initializing.\n");
 
 	ret = zf_get_ZFL_version();
-	if ((!ret) || (ret == 0xffff)) {
+	if (!ret || ret == 0xffff) {
 		printk(KERN_WARNING PFX ": no ZF-Logic found\n");
 		return -ENODEV;
 	}
 
-	if((action <= 3) && (action >= 0)){
-		zf_action = zf_action>>action;
-	} else
+	if (action <= 3 && action >= 0)
+		zf_action = zf_action >> action;
+	else
 		action = 0;
 
 	zf_show_action(action);
 
-	if(!request_region(ZF_IOBASE, 3, "MachZ ZFL WDT")){
+	if (!request_region(ZF_IOBASE, 3, "MachZ ZFL WDT")) {
 		printk(KERN_ERR "cannot reserve I/O ports at %d\n",
 							ZF_IOBASE);
 		ret = -EBUSY;
@@ -446,14 +418,14 @@ static int __init zf_init(void)
 	}
 
 	ret = register_reboot_notifier(&zf_notifier);
-	if(ret){
+	if (ret) {
 		printk(KERN_ERR "can't register reboot notifier (err=%d)\n",
 									ret);
 		goto no_reboot;
 	}
 
 	ret = misc_register(&zf_miscdev);
-	if (ret){
+	if (ret) {
 		printk(KERN_ERR "can't misc_register on minor=%d\n",
 							WATCHDOG_MINOR);
 		goto no_misc;
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

