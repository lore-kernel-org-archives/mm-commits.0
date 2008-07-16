From: akpm@linux-foundation.org
Subject: - watchdog-cpu5_wdt-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:53 -0700
Message-ID: <200807162135.m6GLZrjn014131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629AbYGPVlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: cpu5_wdt: switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-cpu5_wdt-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: cpu5_wdt: switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/cpu5wdt.c |  144 +++++++++++++++++------------------
 1 file changed, 70 insertions(+), 74 deletions(-)

diff -puN drivers/watchdog/cpu5wdt.c~watchdog-cpu5_wdt-switch-to-unlocked_ioctl drivers/watchdog/cpu5wdt.c
--- a/drivers/watchdog/cpu5wdt.c~watchdog-cpu5_wdt-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/cpu5wdt.c
@@ -30,16 +30,16 @@
 #include <linux/timer.h>
 #include <linux/completion.h>
 #include <linux/jiffies.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
-
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <linux/watchdog.h>
 
 /* adjustable parameters */
 
-static int verbose = 0;
+static int verbose;
 static int port = 0x91;
 static int ticks = 10000;
+static spinlock_t cpu5wdt_lock;
 
 #define PFX			"cpu5wdt: "
 
@@ -70,12 +70,13 @@ static struct {
 
 static void cpu5wdt_trigger(unsigned long unused)
 {
-	if ( verbose > 2 )
+	if (verbose > 2)
 		printk(KERN_DEBUG PFX "trigger at %i ticks\n", ticks);
 
-	if( cpu5wdt_device.running )
+	if (cpu5wdt_device.running)
 		ticks--;
 
+	spin_lock(&cpu5wdt_lock);
 	/* keep watchdog alive */
 	outb(1, port + CPU5WDT_TRIGGER_REG);
 
@@ -86,6 +87,7 @@ static void cpu5wdt_trigger(unsigned lon
 		/* ticks doesn't matter anyway */
 		complete(&cpu5wdt_device.stop);
 	}
+	spin_unlock(&cpu5wdt_lock);
 
 }
 
@@ -93,14 +95,17 @@ static void cpu5wdt_reset(void)
 {
 	ticks = cpu5wdt_device.default_ticks;
 
-	if ( verbose )
+	if (verbose)
 		printk(KERN_DEBUG PFX "reset (%i ticks)\n", (int) ticks);
 
 }
 
 static void cpu5wdt_start(void)
 {
-	if ( !cpu5wdt_device.queue ) {
+	unsigned long flags;
+
+	spin_lock_irqsave(&cpu5wdt_lock, flags);
+	if (!cpu5wdt_device.queue) {
 		cpu5wdt_device.queue = 1;
 		outb(0, port + CPU5WDT_TIME_A_REG);
 		outb(0, port + CPU5WDT_TIME_B_REG);
@@ -111,18 +116,20 @@ static void cpu5wdt_start(void)
 	}
 	/* if process dies, counter is not decremented */
 	cpu5wdt_device.running++;
+	spin_unlock_irqrestore(&cpu5wdt_lock, flags);
 }
 
 static int cpu5wdt_stop(void)
 {
-	if ( cpu5wdt_device.running )
-		cpu5wdt_device.running = 0;
+	unsigned long flags;
 
+	spin_lock_irqsave(&cpu5wdt_lock, flags);
+	if (cpu5wdt_device.running)
+		cpu5wdt_device.running = 0;
 	ticks = cpu5wdt_device.default_ticks;
-
-	if ( verbose )
+	spin_unlock_irqrestore(&cpu5wdt_lock, flags);
+	if (verbose)
 		printk(KERN_CRIT PFX "stop not possible\n");
-
 	return -EIO;
 }
 
@@ -130,9 +137,8 @@ static int cpu5wdt_stop(void)
 
 static int cpu5wdt_open(struct inode *inode, struct file *file)
 {
-	if ( test_and_set_bit(0, &cpu5wdt_device.inuse) )
+	if (test_and_set_bit(0, &cpu5wdt_device.inuse))
 		return -EBUSY;
-
 	return nonseekable_open(inode, file);
 }
 
@@ -142,67 +148,58 @@ static int cpu5wdt_release(struct inode 
 	return 0;
 }
 
-static int cpu5wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long cpu5wdt_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
 	unsigned int value;
-	static struct watchdog_info ident =
-	{
+	static struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "CPU5 WDT",
 	};
 
-	switch(cmd) {
-		case WDIOC_KEEPALIVE:
-			cpu5wdt_reset();
-			break;
-		case WDIOC_GETSTATUS:
-			value = inb(port + CPU5WDT_STATUS_REG);
-			value = (value >> 2) & 1;
-			if ( copy_to_user(argp, &value, sizeof(int)) )
-				return -EFAULT;
-			break;
-		case WDIOC_GETBOOTSTATUS:
-			if ( copy_to_user(argp, &value, sizeof(int)) )
-				return -EFAULT;
-			break;
-		case WDIOC_GETSUPPORT:
-			if ( copy_to_user(argp, &ident, sizeof(ident)) )
-				return -EFAULT;
-			break;
-		case WDIOC_SETOPTIONS:
-			if ( copy_from_user(&value, argp, sizeof(int)) )
-				return -EFAULT;
-			switch(value) {
-				case WDIOS_ENABLECARD:
-					cpu5wdt_start();
-					break;
-				case WDIOS_DISABLECARD:
-					return cpu5wdt_stop();
-				default:
-					return -EINVAL;
-			}
-			break;
-		default:
-    			return -ENOTTY;
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		cpu5wdt_reset();
+		break;
+	case WDIOC_GETSTATUS:
+		value = inb(port + CPU5WDT_STATUS_REG);
+		value = (value >> 2) & 1;
+		return put_user(value, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+	case WDIOC_SETOPTIONS:
+		if (get_user(value, p))
+			return -EFAULT;
+		if (value & WDIOS_ENABLECARD)
+			cpu5wdt_start();
+		if (value & WDIOS_DISABLECARD)
+			cpu5wdt_stop();
+		break;
+	default:
+		return -ENOTTY;
 	}
 	return 0;
 }
 
-static ssize_t cpu5wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t cpu5wdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
-	if ( !count )
+	if (!count)
 		return -EIO;
-
 	cpu5wdt_reset();
-
 	return count;
 }
 
 static const struct file_operations cpu5wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= cpu5wdt_ioctl,
+	.unlocked_ioctl	= cpu5wdt_ioctl,
 	.open		= cpu5wdt_open,
 	.write		= cpu5wdt_write,
 	.release	= cpu5wdt_release,
@@ -221,37 +218,36 @@ static int __devinit cpu5wdt_init(void)
 	unsigned int val;
 	int err;
 
-	if ( verbose )
-		printk(KERN_DEBUG PFX "port=0x%x, verbose=%i\n", port, verbose);
+	if (verbose)
+		printk(KERN_DEBUG PFX
+				"port=0x%x, verbose=%i\n", port, verbose);
 
-	if ( !request_region(port, CPU5WDT_EXTENT, PFX) ) {
+	init_completion(&cpu5wdt_device.stop);
+	spin_lock_init(&cpu5wdt_lock);
+	cpu5wdt_device.queue = 0;
+	setup_timer(&cpu5wdt_device.timer, cpu5wdt_trigger, 0);
+	cpu5wdt_device.default_ticks = ticks;
+
+	if (!request_region(port, CPU5WDT_EXTENT, PFX)) {
 		printk(KERN_ERR PFX "request_region failed\n");
 		err = -EBUSY;
 		goto no_port;
 	}
 
-	if ( (err = misc_register(&cpu5wdt_misc)) < 0 ) {
-		printk(KERN_ERR PFX "misc_register failed\n");
-		goto no_misc;
-	}
-
 	/* watchdog reboot? */
 	val = inb(port + CPU5WDT_STATUS_REG);
 	val = (val >> 2) & 1;
-	if ( !val )
+	if (!val)
 		printk(KERN_INFO PFX "sorry, was my fault\n");
 
-	init_completion(&cpu5wdt_device.stop);
-	cpu5wdt_device.queue = 0;
-
-	clear_bit(0, &cpu5wdt_device.inuse);
-
-	setup_timer(&cpu5wdt_device.timer, cpu5wdt_trigger, 0);
+	err = misc_register(&cpu5wdt_misc);
+	if (err < 0) {
+		printk(KERN_ERR PFX "misc_register failed\n");
+		goto no_misc;
+	}
 
-	cpu5wdt_device.default_ticks = ticks;
 
 	printk(KERN_INFO PFX "init success\n");
-
 	return 0;
 
 no_misc:
@@ -267,7 +263,7 @@ static int __devinit cpu5wdt_init_module
 
 static void __devexit cpu5wdt_exit(void)
 {
-	if ( cpu5wdt_device.queue ) {
+	if (cpu5wdt_device.queue) {
 		cpu5wdt_device.queue = 0;
 		wait_for_completion(&cpu5wdt_device.stop);
 	}
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

