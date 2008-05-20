From: akpm@linux-foundation.org
Subject: + watchdog-cpu5_wdt-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:27:49 -0700
Message-ID: <200805200827.m4K8RnX4013064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757704AbYETI2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: cpu5_wdt: switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-cpu5_wdt-switch-to-unlocked_ioctl.patch

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

