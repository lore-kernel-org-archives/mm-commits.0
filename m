From: akpm@linux-foundation.org
Subject: - watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:27 -0700
Message-ID: <200807162137.m6GLbRjT014386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756774AbYGPVqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: wdt501/pci: Clean up, coding style and switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: wdt501/pci: Clean up, coding style and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

[akpm@linux-foundation.org: drivers/watchdog/wdt_pci.c needs udelay.h]
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/wdt.c     |  176 ++++++++++----------
 drivers/watchdog/wdt_pci.c |  301 ++++++++++++++++++++---------------
 2 files changed, 266 insertions(+), 211 deletions(-)

diff -puN drivers/watchdog/wdt.c~watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl drivers/watchdog/wdt.c
--- a/drivers/watchdog/wdt.c~watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/wdt.c
@@ -24,9 +24,10 @@
  *					Matt Crocker).
  *		Alan Cox	:	Added wdt= boot option
  *		Alan Cox	:	Cleaned up copy/user stuff
- *		Tim Hockin	:	Added insmod parameters, comment cleanup
- *					Parameterized timeout
- *		Tigran Aivazian	:	Restructured wdt_init() to handle failures
+ *		Tim Hockin	:	Added insmod parameters, comment
+ *					cleanup, parameterized timeout
+ *		Tigran Aivazian	:	Restructured wdt_init() to handle
+ *					failures
  *		Joel Becker	:	Added WDIOC_GET/SETTIMEOUT
  *		Matt Domsch	:	Added nowayout module option
  */
@@ -42,9 +43,9 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 #include "wd501p.h"
 
@@ -60,15 +61,19 @@ static char expect_close;
 static int heartbeat = WD_TIMO;
 static int wd_heartbeat;
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (0<heartbeat<65536, default=" __MODULE_STRING(WD_TIMO) ")");
+MODULE_PARM_DESC(heartbeat,
+	"Watchdog heartbeat in seconds. (0 < heartbeat < 65536, default="
+				__MODULE_STRING(WD_TIMO) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /* You must set these - there is no sane way to probe for this board. */
-static int io=0x240;
-static int irq=11;
+static int io = 0x240;
+static int irq = 11;
 
 static DEFINE_SPINLOCK(wdt_lock);
 
@@ -82,7 +87,8 @@ MODULE_PARM_DESC(irq, "WDT irq (default=
 static int tachometer;
 
 module_param(tachometer, int, 0);
-MODULE_PARM_DESC(tachometer, "WDT501-P Fan Tachometer support (0=disable, default=0)");
+MODULE_PARM_DESC(tachometer,
+		"WDT501-P Fan Tachometer support (0=disable, default=0)");
 #endif /* CONFIG_WDT_501 */
 
 /*
@@ -91,9 +97,9 @@ MODULE_PARM_DESC(tachometer, "WDT501-P F
 
 static void wdt_ctr_mode(int ctr, int mode)
 {
-	ctr<<=6;
-	ctr|=0x30;
-	ctr|=(mode<<1);
+	ctr <<= 6;
+	ctr |= 0x30;
+	ctr |= (mode << 1);
 	outb_p(ctr, WDT_CR);
 }
 
@@ -114,12 +120,15 @@ static int wdt_start(void)
 	unsigned long flags;
 	spin_lock_irqsave(&wdt_lock, flags);
 	inb_p(WDT_DC);			/* Disable watchdog */
-	wdt_ctr_mode(0,3);		/* Program CTR0 for Mode 3: Square Wave Generator */
-	wdt_ctr_mode(1,2);		/* Program CTR1 for Mode 2: Rate Generator */
-	wdt_ctr_mode(2,0);		/* Program CTR2 for Mode 0: Pulse on Terminal Count */
+	wdt_ctr_mode(0, 3);		/* Program CTR0 for Mode 3:
+						Square Wave Generator */
+	wdt_ctr_mode(1, 2);		/* Program CTR1 for Mode 2:
+						Rate Generator */
+	wdt_ctr_mode(2, 0);		/* Program CTR2 for Mode 0:
+						Pulse on Terminal Count */
 	wdt_ctr_load(0, 8948);		/* Count at 100Hz */
-	wdt_ctr_load(1,wd_heartbeat);	/* Heartbeat */
-	wdt_ctr_load(2,65535);		/* Length of reset pulse */
+	wdt_ctr_load(1, wd_heartbeat);	/* Heartbeat */
+	wdt_ctr_load(2, 65535);		/* Length of reset pulse */
 	outb_p(0, WDT_DC);		/* Enable watchdog */
 	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
@@ -131,13 +140,13 @@ static int wdt_start(void)
  *	Stop the watchdog driver.
  */
 
-static int wdt_stop (void)
+static int wdt_stop(void)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&wdt_lock, flags);
 	/* Turn the card off */
 	inb_p(WDT_DC);			/* Disable watchdog */
-	wdt_ctr_load(2,0);		/* 0 length reset pulses now */
+	wdt_ctr_load(2, 0);		/* 0 length reset pulses now */
 	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
@@ -145,8 +154,8 @@ static int wdt_stop (void)
 /**
  *	wdt_ping:
  *
- *	Reload counter one with the watchdog heartbeat. We don't bother reloading
- *	the cascade counter.
+ *	Reload counter one with the watchdog heartbeat. We don't bother
+ *	reloading the cascade counter.
  */
 
 static int wdt_ping(void)
@@ -155,8 +164,9 @@ static int wdt_ping(void)
 	spin_lock_irqsave(&wdt_lock, flags);
 	/* Write a watchdog value */
 	inb_p(WDT_DC);			/* Disable watchdog */
-	wdt_ctr_mode(1,2);		/* Re-Program CTR1 for Mode 2: Rate Generator */
-	wdt_ctr_load(1,wd_heartbeat);	/* Heartbeat */
+	wdt_ctr_mode(1, 2);		/* Re-Program CTR1 for Mode 2:
+							Rate Generator */
+	wdt_ctr_load(1, wd_heartbeat);	/* Heartbeat */
 	outb_p(0, WDT_DC);		/* Enable watchdog */
 	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
@@ -166,13 +176,14 @@ static int wdt_ping(void)
  *	wdt_set_heartbeat:
  *	@t:		the new heartbeat value that needs to be set.
  *
- *	Set a new heartbeat value for the watchdog device. If the heartbeat value is
- *	incorrect we keep the old value and return -EINVAL. If successfull we
- *	return 0.
+ *	Set a new heartbeat value for the watchdog device. If the heartbeat
+ *	value is incorrect we keep the old value and return -EINVAL. If
+ *	successful we return 0.
  */
+
 static int wdt_set_heartbeat(int t)
 {
-	if ((t < 1) || (t > 65535))
+	if (t < 1 || t > 65535)
 		return -EINVAL;
 
 	heartbeat = t;
@@ -200,7 +211,7 @@ static int wdt_get_status(int *status)
 	new_status = inb_p(WDT_SR);
 	spin_unlock_irqrestore(&wdt_lock, flags);
 
-	*status=0;
+	*status = 0;
 	if (new_status & WDC_SR_ISOI0)
 		*status |= WDIOF_EXTERN1;
 	if (new_status & WDC_SR_ISII1)
@@ -266,7 +277,7 @@ static irqreturn_t wdt_interrupt(int irq
 
 #ifdef CONFIG_WDT_501
 	if (!(status & WDC_SR_TGOOD))
-		printk(KERN_CRIT "Overheat alarm.(%d)\n",inb_p(WDT_RT));
+		printk(KERN_CRIT "Overheat alarm.(%d)\n", inb_p(WDT_RT));
 	if (!(status & WDC_SR_PSUOVER))
 		printk(KERN_CRIT "PSU over voltage.\n");
 	if (!(status & WDC_SR_PSUUNDR))
@@ -304,9 +315,10 @@ static irqreturn_t wdt_interrupt(int irq
  *	write of data will do, as we we don't define content meaning.
  */
 
-static ssize_t wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t wdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
-	if(count) {
+	if (count) {
 		if (!nowayout) {
 			size_t i;
 
@@ -328,7 +340,6 @@ static ssize_t wdt_write(struct file *fi
 
 /**
  *	wdt_ioctl:
- *	@inode: inode of the device
  *	@file: file handle to the device
  *	@cmd: watchdog command
  *	@arg: argument pointer
@@ -338,8 +349,7 @@ static ssize_t wdt_write(struct file *fi
  *	querying capabilities and current status.
  */
 
-static int wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -362,32 +372,28 @@ static int wdt_ioctl(struct inode *inode
 		ident.options |= WDIOF_FANFAULT;
 #endif /* CONFIG_WDT_501 */
 
-	switch(cmd)
-	{
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident))?-EFAULT:0;
-
-		case WDIOC_GETSTATUS:
-			wdt_get_status(&status);
-			return put_user(status, p);
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			wdt_ping();
-			return 0;
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_heartbeat, p))
-				return -EFAULT;
-
-			if (wdt_set_heartbeat(new_heartbeat))
-				return -EINVAL;
-
-			wdt_ping();
-			/* Fall */
-		case WDIOC_GETTIMEOUT:
-			return put_user(heartbeat, p);
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+		wdt_get_status(&status);
+		return put_user(status, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		wdt_ping();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
+		if (wdt_set_heartbeat(new_heartbeat))
+			return -EINVAL;
+		wdt_ping();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
 	}
 }
 
@@ -405,7 +411,7 @@ static int wdt_ioctl(struct inode *inode
 
 static int wdt_open(struct inode *inode, struct file *file)
 {
-	if(test_and_set_bit(0, &wdt_is_open))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 	/*
 	 *	Activate
@@ -432,7 +438,8 @@ static int wdt_release(struct inode *ino
 		wdt_stop();
 		clear_bit(0, &wdt_is_open);
 	} else {
-		printk(KERN_CRIT "wdt: WDT device closed unexpectedly.  WDT will not stop!\n");
+		printk(KERN_CRIT
+		 "wdt: WDT device closed unexpectedly.  WDT will not stop!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -451,14 +458,15 @@ static int wdt_release(struct inode *ino
  *	farenheit. It was designed by an imperial measurement luddite.
  */
 
-static ssize_t wdt_temp_read(struct file *file, char __user *buf, size_t count, loff_t *ptr)
+static ssize_t wdt_temp_read(struct file *file, char __user *buf,
+						size_t count, loff_t *ptr)
 {
 	int temperature;
 
 	if (wdt_get_temperature(&temperature))
 		return -EFAULT;
 
-	if (copy_to_user (buf, &temperature, 1))
+	if (copy_to_user(buf, &temperature, 1))
 		return -EFAULT;
 
 	return 1;
@@ -506,10 +514,8 @@ static int wdt_temp_release(struct inode
 static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT) {
-		/* Turn the card off */
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_stop();
-	}
 	return NOTIFY_DONE;
 }
 
@@ -522,7 +528,7 @@ static const struct file_operations wdt_
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdt_write,
-	.ioctl		= wdt_ioctl,
+	.unlocked_ioctl	= wdt_ioctl,
 	.open		= wdt_open,
 	.release	= wdt_release,
 };
@@ -576,7 +582,7 @@ static void __exit wdt_exit(void)
 #endif /* CONFIG_WDT_501 */
 	unregister_reboot_notifier(&wdt_notifier);
 	free_irq(irq, NULL);
-	release_region(io,8);
+	release_region(io, 8);
 }
 
 /**
@@ -591,44 +597,49 @@ static int __init wdt_init(void)
 {
 	int ret;
 
-	/* Check that the heartbeat value is within it's range ; if not reset to the default */
+	/* Check that the heartbeat value is within it's range;
+	   if not reset to the default */
 	if (wdt_set_heartbeat(heartbeat)) {
 		wdt_set_heartbeat(WD_TIMO);
-		printk(KERN_INFO "wdt: heartbeat value must be 0<heartbeat<65536, using %d\n",
+		printk(KERN_INFO "wdt: heartbeat value must be 0 < heartbeat < 65536, using %d\n",
 			WD_TIMO);
 	}
 
 	if (!request_region(io, 8, "wdt501p")) {
-		printk(KERN_ERR "wdt: I/O address 0x%04x already in use\n", io);
+		printk(KERN_ERR
+			"wdt: I/O address 0x%04x already in use\n", io);
 		ret = -EBUSY;
 		goto out;
 	}
 
 	ret = request_irq(irq, wdt_interrupt, IRQF_DISABLED, "wdt501p", NULL);
-	if(ret) {
+	if (ret) {
 		printk(KERN_ERR "wdt: IRQ %d is not free.\n", irq);
 		goto outreg;
 	}
 
 	ret = register_reboot_notifier(&wdt_notifier);
-	if(ret) {
-		printk(KERN_ERR "wdt: cannot register reboot notifier (err=%d)\n", ret);
+	if (ret) {
+		printk(KERN_ERR
+		      "wdt: cannot register reboot notifier (err=%d)\n", ret);
 		goto outirq;
 	}
 
 #ifdef CONFIG_WDT_501
 	ret = misc_register(&temp_miscdev);
 	if (ret) {
-		printk(KERN_ERR "wdt: cannot register miscdev on minor=%d (err=%d)\n",
-			TEMP_MINOR, ret);
+		printk(KERN_ERR
+			"wdt: cannot register miscdev on minor=%d (err=%d)\n",
+							TEMP_MINOR, ret);
 		goto outrbt;
 	}
 #endif /* CONFIG_WDT_501 */
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR "wdt: cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR
+			"wdt: cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto outmisc;
 	}
 
@@ -636,7 +647,8 @@ static int __init wdt_init(void)
 	printk(KERN_INFO "WDT500/501-P driver 0.10 at 0x%04x (Interrupt %d). heartbeat=%d sec (nowayout=%d)\n",
 		io, irq, heartbeat, nowayout);
 #ifdef CONFIG_WDT_501
-	printk(KERN_INFO "wdt: Fan Tachometer is %s\n", (tachometer ? "Enabled" : "Disabled"));
+	printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
+				(tachometer ? "Enabled" : "Disabled"));
 #endif /* CONFIG_WDT_501 */
 
 out:
@@ -651,7 +663,7 @@ outrbt:
 outirq:
 	free_irq(irq, NULL);
 outreg:
-	release_region(io,8);
+	release_region(io, 8);
 	goto out;
 }
 
diff -puN drivers/watchdog/wdt_pci.c~watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl drivers/watchdog/wdt_pci.c
--- a/drivers/watchdog/wdt_pci.c~watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/wdt_pci.c
@@ -29,9 +29,11 @@
  *		JP Nollmann	:	Added support for PCI wdt501p
  *		Alan Cox	:	Split ISA and PCI cards into two drivers
  *		Jeff Garzik	:	PCI cleanups
- *		Tigran Aivazian	:	Restructured wdtpci_init_one() to handle failures
+ *		Tigran Aivazian	:	Restructured wdtpci_init_one() to handle
+ *					failures
  *		Joel Becker 	:	Added WDIOC_GET/SETTIMEOUT
- *		Zwane Mwaikambo	:	Magic char closing, locking changes, cleanups
+ *		Zwane Mwaikambo	:	Magic char closing, locking changes,
+ *					cleanups
  *		Matt Domsch	:	nowayout module option
  */
 
@@ -42,14 +44,15 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/ioport.h>
+#include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define WDT_IS_PCI
@@ -73,7 +76,7 @@
 /* We can only use 1 card due to the /dev/watchdog restriction */
 static int dev_count;
 
-static struct semaphore open_sem;
+static unsigned long open_lock;
 static DEFINE_SPINLOCK(wdtpci_lock);
 static char expect_close;
 
@@ -86,18 +89,23 @@ static int irq;
 static int heartbeat = WD_TIMO;
 static int wd_heartbeat;
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (0<heartbeat<65536, default=" __MODULE_STRING(WD_TIMO) ")");
+MODULE_PARM_DESC(heartbeat,
+		"Watchdog heartbeat in seconds. (0<heartbeat<65536, default="
+				__MODULE_STRING(WD_TIMO) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #ifdef CONFIG_WDT_501_PCI
 /* Support for the Fan Tachometer on the PCI-WDT501 */
 static int tachometer;
 
 module_param(tachometer, int, 0);
-MODULE_PARM_DESC(tachometer, "PCI-WDT501 Fan Tachometer support (0=disable, default=0)");
+MODULE_PARM_DESC(tachometer,
+	"PCI-WDT501 Fan Tachometer support (0=disable, default=0)");
 #endif /* CONFIG_WDT_501_PCI */
 
 /*
@@ -106,16 +114,19 @@ MODULE_PARM_DESC(tachometer, "PCI-WDT501
 
 static void wdtpci_ctr_mode(int ctr, int mode)
 {
-	ctr<<=6;
-	ctr|=0x30;
-	ctr|=(mode<<1);
-	outb_p(ctr, WDT_CR);
+	ctr <<= 6;
+	ctr |= 0x30;
+	ctr |= (mode << 1);
+	outb(ctr, WDT_CR);
+	udelay(8);
 }
 
 static void wdtpci_ctr_load(int ctr, int val)
 {
-	outb_p(val&0xFF, WDT_COUNT0+ctr);
-	outb_p(val>>8, WDT_COUNT0+ctr);
+	outb(val & 0xFF, WDT_COUNT0 + ctr);
+	udelay(8);
+	outb(val >> 8, WDT_COUNT0 + ctr);
+	udelay(8);
 }
 
 /**
@@ -134,23 +145,35 @@ static int wdtpci_start(void)
 	 * "pet" the watchdog, as Access says.
 	 * This resets the clock outputs.
 	 */
-	inb_p(WDT_DC);			/* Disable watchdog */
-	wdtpci_ctr_mode(2,0);		/* Program CTR2 for Mode 0: Pulse on Terminal Count */
-	outb_p(0, WDT_DC);		/* Enable watchdog */
-
-	inb_p(WDT_DC);			/* Disable watchdog */
-	outb_p(0, WDT_CLOCK);		/* 2.0833MHz clock */
-	inb_p(WDT_BUZZER);		/* disable */
-	inb_p(WDT_OPTONOTRST);		/* disable */
-	inb_p(WDT_OPTORST);		/* disable */
-	inb_p(WDT_PROGOUT);		/* disable */
-	wdtpci_ctr_mode(0,3);		/* Program CTR0 for Mode 3: Square Wave Generator */
-	wdtpci_ctr_mode(1,2);		/* Program CTR1 for Mode 2: Rate Generator */
-	wdtpci_ctr_mode(2,1);		/* Program CTR2 for Mode 1: Retriggerable One-Shot */
-	wdtpci_ctr_load(0,20833);	/* count at 100Hz */
-	wdtpci_ctr_load(1,wd_heartbeat);/* Heartbeat */
+	inb(WDT_DC);			/* Disable watchdog */
+	udelay(8);
+	wdtpci_ctr_mode(2, 0);		/* Program CTR2 for Mode 0:
+						Pulse on Terminal Count */
+	outb(0, WDT_DC);		/* Enable watchdog */
+	udelay(8);
+	inb(WDT_DC);			/* Disable watchdog */
+	udelay(8);
+	outb(0, WDT_CLOCK);		/* 2.0833MHz clock */
+	udelay(8);
+	inb(WDT_BUZZER);		/* disable */
+	udelay(8);
+	inb(WDT_OPTONOTRST);		/* disable */
+	udelay(8);
+	inb(WDT_OPTORST);		/* disable */
+	udelay(8);
+	inb(WDT_PROGOUT);		/* disable */
+	udelay(8);
+	wdtpci_ctr_mode(0, 3);		/* Program CTR0 for Mode 3:
+						Square Wave Generator */
+	wdtpci_ctr_mode(1, 2);		/* Program CTR1 for Mode 2:
+						Rate Generator */
+	wdtpci_ctr_mode(2, 1);		/* Program CTR2 for Mode 1:
+						Retriggerable One-Shot */
+	wdtpci_ctr_load(0, 20833);	/* count at 100Hz */
+	wdtpci_ctr_load(1, wd_heartbeat);/* Heartbeat */
 	/* DO NOT LOAD CTR2 on PCI card! -- JPN */
-	outb_p(0, WDT_DC);		/* Enable watchdog */
+	outb(0, WDT_DC);		/* Enable watchdog */
+	udelay(8);
 
 	spin_unlock_irqrestore(&wdtpci_lock, flags);
 	return 0;
@@ -162,14 +185,15 @@ static int wdtpci_start(void)
  *	Stop the watchdog driver.
  */
 
-static int wdtpci_stop (void)
+static int wdtpci_stop(void)
 {
 	unsigned long flags;
 
 	/* Turn the card off */
 	spin_lock_irqsave(&wdtpci_lock, flags);
-	inb_p(WDT_DC);			/* Disable watchdog */
-	wdtpci_ctr_load(2,0);		/* 0 length reset pulses now */
+	inb(WDT_DC);			/* Disable watchdog */
+	udelay(8);
+	wdtpci_ctr_load(2, 0);		/* 0 length reset pulses now */
 	spin_unlock_irqrestore(&wdtpci_lock, flags);
 	return 0;
 }
@@ -177,20 +201,23 @@ static int wdtpci_stop (void)
 /**
  *	wdtpci_ping:
  *
- *	Reload counter one with the watchdog heartbeat. We don't bother reloading
- *	the cascade counter.
+ *	Reload counter one with the watchdog heartbeat. We don't bother
+ *	reloading the cascade counter.
  */
 
 static int wdtpci_ping(void)
 {
 	unsigned long flags;
 
-	/* Write a watchdog value */
 	spin_lock_irqsave(&wdtpci_lock, flags);
-	inb_p(WDT_DC);			/* Disable watchdog */
-	wdtpci_ctr_mode(1,2);		/* Re-Program CTR1 for Mode 2: Rate Generator */
-	wdtpci_ctr_load(1,wd_heartbeat);/* Heartbeat */
-	outb_p(0, WDT_DC);		/* Enable watchdog */
+	/* Write a watchdog value */
+	inb(WDT_DC);			/* Disable watchdog */
+	udelay(8);
+	wdtpci_ctr_mode(1, 2);		/* Re-Program CTR1 for Mode 2:
+							Rate Generator */
+	wdtpci_ctr_load(1, wd_heartbeat);/* Heartbeat */
+	outb(0, WDT_DC);		/* Enable watchdog */
+	udelay(8);
 	spin_unlock_irqrestore(&wdtpci_lock, flags);
 	return 0;
 }
@@ -199,14 +226,14 @@ static int wdtpci_ping(void)
  *	wdtpci_set_heartbeat:
  *	@t:		the new heartbeat value that needs to be set.
  *
- *	Set a new heartbeat value for the watchdog device. If the heartbeat value is
- *	incorrect we keep the old value and return -EINVAL. If successfull we
- *	return 0.
+ *	Set a new heartbeat value for the watchdog device. If the heartbeat
+ *	value is incorrect we keep the old value and return -EINVAL.
+ *	If successful we return 0.
  */
 static int wdtpci_set_heartbeat(int t)
 {
 	/* Arbitrary, can't find the card's limits */
-	if ((t < 1) || (t > 65535))
+	if (t < 1 || t > 65535)
 		return -EINVAL;
 
 	heartbeat = t;
@@ -227,9 +254,14 @@ static int wdtpci_set_heartbeat(int t)
 
 static int wdtpci_get_status(int *status)
 {
-	unsigned char new_status=inb_p(WDT_SR);
+	unsigned char new_status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdtpci_lock, flags);
+	new_status = inb(WDT_SR);
+	spin_unlock_irqrestore(&wdtpci_lock, flags);
 
-	*status=0;
+	*status = 0;
 	if (new_status & WDC_SR_ISOI0)
 		*status |= WDIOF_EXTERN1;
 	if (new_status & WDC_SR_ISII1)
@@ -259,8 +291,12 @@ static int wdtpci_get_status(int *status
 
 static int wdtpci_get_temperature(int *temperature)
 {
-	unsigned short c=inb_p(WDT_RT);
-
+	unsigned short c;
+	unsigned long flags;
+	spin_lock_irqsave(&wdtpci_lock, flags);
+	c = inb(WDT_RT);
+	udelay(8);
+	spin_unlock_irqrestore(&wdtpci_lock, flags);
 	*temperature = (c * 11 / 15) + 7;
 	return 0;
 }
@@ -282,17 +318,25 @@ static irqreturn_t wdtpci_interrupt(int 
 	 *	Read the status register see what is up and
 	 *	then printk it.
 	 */
-	unsigned char status=inb_p(WDT_SR);
+	unsigned char status;
+
+	spin_lock(&wdtpci_lock);
+
+	status = inb(WDT_SR);
+	udelay(8);
 
 	printk(KERN_CRIT PFX "status %d\n", status);
 
 #ifdef CONFIG_WDT_501_PCI
-	if (!(status & WDC_SR_TGOOD))
- 		printk(KERN_CRIT PFX "Overheat alarm.(%d)\n",inb_p(WDT_RT));
+	if (!(status & WDC_SR_TGOOD)) {
+		u8 alarm = inb(WDT_RT);
+		printk(KERN_CRIT PFX "Overheat alarm.(%d)\n", alarm);
+		udelay(8);
+	}
 	if (!(status & WDC_SR_PSUOVER))
- 		printk(KERN_CRIT PFX "PSU over voltage.\n");
+		printk(KERN_CRIT PFX "PSU over voltage.\n");
 	if (!(status & WDC_SR_PSUUNDR))
- 		printk(KERN_CRIT PFX "PSU under voltage.\n");
+		printk(KERN_CRIT PFX "PSU under voltage.\n");
 	if (tachometer) {
 		if (!(status & WDC_SR_FANGOOD))
 			printk(KERN_CRIT PFX "Possible fan fault.\n");
@@ -310,6 +354,7 @@ static irqreturn_t wdtpci_interrupt(int 
 		printk(KERN_CRIT PFX "Reset in 5ms.\n");
 #endif
 	}
+	spin_unlock(&wdtpci_lock);
 	return IRQ_HANDLED;
 }
 
@@ -325,7 +370,8 @@ static irqreturn_t wdtpci_interrupt(int 
  *	write of data will do, as we we don't define content meaning.
  */
 
-static ssize_t wdtpci_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t wdtpci_write(struct file *file, const char __user *buf,
+					size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -335,7 +381,7 @@ static ssize_t wdtpci_write(struct file 
 
 			for (i = 0; i != count; i++) {
 				char c;
-				if(get_user(c, buf+i))
+				if (get_user(c, buf+i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_close = 42;
@@ -343,13 +389,11 @@ static ssize_t wdtpci_write(struct file 
 		}
 		wdtpci_ping();
 	}
-
 	return count;
 }
 
 /**
  *	wdtpci_ioctl:
- *	@inode: inode of the device
  *	@file: file handle to the device
  *	@cmd: watchdog command
  *	@arg: argument pointer
@@ -359,8 +403,8 @@ static ssize_t wdtpci_write(struct file 
  *	querying capabilities and current status.
  */
 
-static int wdtpci_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long wdtpci_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int new_heartbeat;
 	int status;
@@ -383,33 +427,29 @@ static int wdtpci_ioctl(struct inode *in
 		ident.options |= WDIOF_FANFAULT;
 #endif /* CONFIG_WDT_501_PCI */
 
-	switch(cmd)
-	{
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident))?-EFAULT:0;
-
-		case WDIOC_GETSTATUS:
-			wdtpci_get_status(&status);
-			return put_user(status, p);
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			wdtpci_ping();
-			return 0;
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_heartbeat, p))
-				return -EFAULT;
-
-			if (wdtpci_set_heartbeat(new_heartbeat))
-				return -EINVAL;
-
-			wdtpci_ping();
-			/* Fall */
-		case WDIOC_GETTIMEOUT:
-			return put_user(heartbeat, p);
-	}
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+		wdtpci_get_status(&status);
+		return put_user(status, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		wdtpci_ping();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
+		if (wdtpci_set_heartbeat(new_heartbeat))
+			return -EINVAL;
+		wdtpci_ping();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+		}
 }
 
 /**
@@ -426,12 +466,11 @@ static int wdtpci_ioctl(struct inode *in
 
 static int wdtpci_open(struct inode *inode, struct file *file)
 {
-	if (down_trylock(&open_sem))
+	if (test_and_set_bit(0, &open_lock))
 		return -EBUSY;
 
-	if (nowayout) {
+	if (nowayout)
 		__module_get(THIS_MODULE);
-	}
 	/*
 	 *	Activate
 	 */
@@ -460,7 +499,7 @@ static int wdtpci_release(struct inode *
 		wdtpci_ping();
 	}
 	expect_close = 0;
-	up(&open_sem);
+	clear_bit(0, &open_lock);
 	return 0;
 }
 
@@ -476,14 +515,15 @@ static int wdtpci_release(struct inode *
  *	fahrenheit. It was designed by an imperial measurement luddite.
  */
 
-static ssize_t wdtpci_temp_read(struct file *file, char __user *buf, size_t count, loff_t *ptr)
+static ssize_t wdtpci_temp_read(struct file *file, char __user *buf,
+						size_t count, loff_t *ptr)
 {
 	int temperature;
 
 	if (wdtpci_get_temperature(&temperature))
 		return -EFAULT;
 
-	if (copy_to_user (buf, &temperature, 1))
+	if (copy_to_user(buf, &temperature, 1))
 		return -EFAULT;
 
 	return 1;
@@ -529,12 +569,10 @@ static int wdtpci_temp_release(struct in
  */
 
 static int wdtpci_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
+							void *unused)
 {
-	if (code==SYS_DOWN || code==SYS_HALT) {
-		/* Turn the card off */
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdtpci_stop();
-	}
 	return NOTIFY_DONE;
 }
 
@@ -547,7 +585,7 @@ static const struct file_operations wdtp
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdtpci_write,
-	.ioctl		= wdtpci_ioctl,
+	.unlocked_ioctl	= wdtpci_ioctl,
 	.open		= wdtpci_open,
 	.release	= wdtpci_release,
 };
@@ -584,80 +622,85 @@ static struct notifier_block wdtpci_noti
 };
 
 
-static int __devinit wdtpci_init_one (struct pci_dev *dev,
-				   const struct pci_device_id *ent)
+static int __devinit wdtpci_init_one(struct pci_dev *dev,
+					const struct pci_device_id *ent)
 {
 	int ret = -EIO;
 
 	dev_count++;
 	if (dev_count > 1) {
-		printk (KERN_ERR PFX "this driver only supports 1 device\n");
+		printk(KERN_ERR PFX "This driver only supports one device\n");
 		return -ENODEV;
 	}
 
-	if (pci_enable_device (dev)) {
-		printk (KERN_ERR PFX "Not possible to enable PCI Device\n");
+	if (pci_enable_device(dev)) {
+		printk(KERN_ERR PFX "Not possible to enable PCI Device\n");
 		return -ENODEV;
 	}
 
-	if (pci_resource_start (dev, 2) == 0x0000) {
-		printk (KERN_ERR PFX "No I/O-Address for card detected\n");
+	if (pci_resource_start(dev, 2) == 0x0000) {
+		printk(KERN_ERR PFX "No I/O-Address for card detected\n");
 		ret = -ENODEV;
 		goto out_pci;
 	}
 
-	sema_init(&open_sem, 1);
-
 	irq = dev->irq;
-	io = pci_resource_start (dev, 2);
+	io = pci_resource_start(dev, 2);
 
-	if (request_region (io, 16, "wdt_pci") == NULL) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n", io);
+	if (request_region(io, 16, "wdt_pci") == NULL) {
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n", io);
 		goto out_pci;
 	}
 
-	if (request_irq (irq, wdtpci_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	if (request_irq(irq, wdtpci_interrupt, IRQF_DISABLED | IRQF_SHARED,
 			 "wdt_pci", &wdtpci_miscdev)) {
-		printk (KERN_ERR PFX "IRQ %d is not free\n", irq);
+		printk(KERN_ERR PFX "IRQ %d is not free\n", irq);
 		goto out_reg;
 	}
 
-	printk ("PCI-WDT500/501 (PCI-WDG-CSM) driver 0.10 at 0x%04x (Interrupt %d)\n",
-		io, irq);
+	printk(KERN_INFO
+	 "PCI-WDT500/501 (PCI-WDG-CSM) driver 0.10 at 0x%04x (Interrupt %d)\n",
+								io, irq);
 
-	/* Check that the heartbeat value is within it's range ; if not reset to the default */
+	/* Check that the heartbeat value is within its range;
+	   if not reset to the default */
 	if (wdtpci_set_heartbeat(heartbeat)) {
 		wdtpci_set_heartbeat(WD_TIMO);
-		printk(KERN_INFO PFX "heartbeat value must be 0<heartbeat<65536, using %d\n",
-			WD_TIMO);
+		printk(KERN_INFO PFX
+		  "heartbeat value must be 0 < heartbeat < 65536, using %d\n",
+								WD_TIMO);
 	}
 
-	ret = register_reboot_notifier (&wdtpci_notifier);
+	ret = register_reboot_notifier(&wdtpci_notifier);
 	if (ret) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		goto out_irq;
 	}
 
 #ifdef CONFIG_WDT_501_PCI
-	ret = misc_register (&temp_miscdev);
+	ret = misc_register(&temp_miscdev);
 	if (ret) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			TEMP_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+					TEMP_MINOR, ret);
 		goto out_rbt;
 	}
 #endif /* CONFIG_WDT_501_PCI */
 
-	ret = misc_register (&wdtpci_miscdev);
+	ret = misc_register(&wdtpci_miscdev);
 	if (ret) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						WATCHDOG_MINOR, ret);
 		goto out_misc;
 	}
 
 	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 #ifdef CONFIG_WDT_501_PCI
-	printk(KERN_INFO "wdt: Fan Tachometer is %s\n", (tachometer ? "Enabled" : "Disabled"));
+	printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
+				(tachometer ? "Enabled" : "Disabled"));
 #endif /* CONFIG_WDT_501_PCI */
 
 	ret = 0;
@@ -673,14 +716,14 @@ out_rbt:
 out_irq:
 	free_irq(irq, &wdtpci_miscdev);
 out_reg:
-	release_region (io, 16);
+	release_region(io, 16);
 out_pci:
 	pci_disable_device(dev);
 	goto out;
 }
 
 
-static void __devexit wdtpci_remove_one (struct pci_dev *pdev)
+static void __devexit wdtpci_remove_one(struct pci_dev *pdev)
 {
 	/* here we assume only one device will ever have
 	 * been picked up and registered by probe function */
@@ -728,7 +771,7 @@ static struct pci_driver wdtpci_driver =
 
 static void __exit wdtpci_cleanup(void)
 {
-	pci_unregister_driver (&wdtpci_driver);
+	pci_unregister_driver(&wdtpci_driver);
 }
 
 
@@ -742,7 +785,7 @@ static void __exit wdtpci_cleanup(void)
 
 static int __init wdtpci_init(void)
 {
-	return pci_register_driver (&wdtpci_driver);
+	return pci_register_driver(&wdtpci_driver);
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

