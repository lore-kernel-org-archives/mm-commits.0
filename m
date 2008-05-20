From: akpm@linux-foundation.org
Subject: + watchdog-pc87413_wdt-clean-up-coding-style-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:23 -0700
Message-ID: <200805200828.m4K8SNbR013158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761058AbYETI3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: pc87413_wdt: clean up, coding style, unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-pc87413_wdt-clean-up-coding-style-unlocked_ioctl.patch

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
Subject: watchdog: pc87413_wdt: clean up, coding style, unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/pc87413_wdt.c |  211 ++++++++++++-------------------
 1 file changed, 87 insertions(+), 124 deletions(-)

diff -puN drivers/watchdog/pc87413_wdt.c~watchdog-pc87413_wdt-clean-up-coding-style-unlocked_ioctl drivers/watchdog/pc87413_wdt.c
--- a/drivers/watchdog/pc87413_wdt.c~watchdog-pc87413_wdt-clean-up-coding-style-unlocked_ioctl
+++ a/drivers/watchdog/pc87413_wdt.c
@@ -31,9 +31,9 @@
 #include <linux/spinlock.h>
 #include <linux/moduleparam.h>
 #include <linux/version.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 /* #define DEBUG 1 */
@@ -56,12 +56,12 @@
 
 static int io = 0x2E;		         /* Address used on Portwell Boards */
 
-static int timeout = DEFAULT_TIMEOUT;    /* timeout value */
-static unsigned long timer_enabled = 0;  /* is the timer enabled? */
+static int timeout = DEFAULT_TIMEOUT;   /* timeout value */
+static unsigned long timer_enabled;	/* is the timer enabled? */
 
-static char expect_close;                /* is the close expected? */
+static char expect_close;		/* is the close expected? */
 
-static DEFINE_SPINLOCK(io_lock);/* to guard the watchdog from io races */
+static DEFINE_SPINLOCK(io_lock);	/* to guard us from io races */
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 
@@ -69,7 +69,7 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 
 /* Select pins for Watchdog output */
 
-static inline void pc87413_select_wdt_out (void)
+static inline void pc87413_select_wdt_out(void)
 {
 	unsigned int cr_data = 0;
 
@@ -77,7 +77,7 @@ static inline void pc87413_select_wdt_ou
 
 	outb_p(SIOCFG2, WDT_INDEX_IO_PORT);
 
-	cr_data = inb (WDT_DATA_IO_PORT);
+	cr_data = inb(WDT_DATA_IO_PORT);
 
 	cr_data |= 0x80; /* Set Bit7 to 1*/
 	outb_p(SIOCFG2, WDT_INDEX_IO_PORT);
@@ -85,8 +85,9 @@ static inline void pc87413_select_wdt_ou
 	outb_p(cr_data, WDT_DATA_IO_PORT);
 
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Select multiple pin,pin55,as WDT output:"
-	                      " Bit7 to 1: %d\n", cr_data);
+	printk(KERN_INFO DPFX
+		"Select multiple pin,pin55,as WDT output: Bit7 to 1: %d\n",
+								cr_data);
 #endif
 }
 
@@ -94,7 +95,7 @@ static inline void pc87413_select_wdt_ou
 
 static inline void pc87413_enable_swc(void)
 {
-	unsigned int cr_data=0;
+	unsigned int cr_data = 0;
 
 	/* Step 2: Enable SWC functions */
 
@@ -129,12 +130,11 @@ static inline unsigned int pc87413_get_s
 	addr_l = inb(WDT_DATA_IO_PORT);
 
 	swc_base_addr = (addr_h << 8) + addr_l;
-
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Read SWC I/O Base Address: low %d, high %d,"
-	                      " res %d\n", addr_l, addr_h, swc_base_addr);
+	printk(KERN_INFO DPFX
+		"Read SWC I/O Base Address: low %d, high %d, res %d\n",
+						addr_l, addr_h, swc_base_addr);
 #endif
-
 	return swc_base_addr;
 }
 
@@ -143,9 +143,7 @@ static inline unsigned int pc87413_get_s
 static inline void pc87413_swc_bank3(unsigned int swc_base_addr)
 {
 	/* Step 4: Select Bank3 of SWC */
-
 	outb_p(inb(swc_base_addr + 0x0f) | 0x03, swc_base_addr + 0x0f);
-
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "Select Bank3 of SWC\n");
 #endif
@@ -157,9 +155,7 @@ static inline void pc87413_programm_wdto
 					 char pc87413_time)
 {
 	/* Step 5: Programm WDTO, Twd. */
-
 	outb_p(pc87413_time, swc_base_addr + WDTO);
-
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "Set WDTO to %d minutes\n", pc87413_time);
 #endif
@@ -170,9 +166,7 @@ static inline void pc87413_programm_wdto
 static inline void pc87413_enable_wden(unsigned int swc_base_addr)
 {
 	/* Step 6: Enable WDEN */
-
-	outb_p(inb (swc_base_addr + WDCTL) | 0x01, swc_base_addr + WDCTL);
-
+	outb_p(inb(swc_base_addr + WDCTL) | 0x01, swc_base_addr + WDCTL);
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "Enable WDEN\n");
 #endif
@@ -182,9 +176,7 @@ static inline void pc87413_enable_wden(u
 static inline void pc87413_enable_sw_wd_tren(unsigned int swc_base_addr)
 {
 	/* Enable SW_WD_TREN */
-
-	outb_p(inb (swc_base_addr + WDCFG) | 0x80, swc_base_addr + WDCFG);
-
+	outb_p(inb(swc_base_addr + WDCFG) | 0x80, swc_base_addr + WDCFG);
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "Enable SW_WD_TREN\n");
 #endif
@@ -195,9 +187,7 @@ static inline void pc87413_enable_sw_wd_
 static inline void pc87413_disable_sw_wd_tren(unsigned int swc_base_addr)
 {
 	/* Disable SW_WD_TREN */
-
-	outb_p(inb (swc_base_addr + WDCFG) & 0x7f, swc_base_addr + WDCFG);
-
+	outb_p(inb(swc_base_addr + WDCFG) & 0x7f, swc_base_addr + WDCFG);
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "pc87413 - Disable SW_WD_TREN\n");
 #endif
@@ -208,9 +198,7 @@ static inline void pc87413_disable_sw_wd
 static inline void pc87413_enable_sw_wd_trg(unsigned int swc_base_addr)
 {
 	/* Enable SW_WD_TRG */
-
-	outb_p(inb (swc_base_addr + WDCTL) | 0x80, swc_base_addr + WDCTL);
-
+	outb_p(inb(swc_base_addr + WDCTL) | 0x80, swc_base_addr + WDCTL);
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "pc87413 - Enable SW_WD_TRG\n");
 #endif
@@ -221,9 +209,7 @@ static inline void pc87413_enable_sw_wd_
 static inline void pc87413_disable_sw_wd_trg(unsigned int swc_base_addr)
 {
 	/* Disable SW_WD_TRG */
-
-	outb_p(inb (swc_base_addr + WDCTL) & 0x7f, swc_base_addr + WDCTL);
-
+	outb_p(inb(swc_base_addr + WDCTL) & 0x7f, swc_base_addr + WDCTL);
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "Disable SW_WD_TRG\n");
 #endif
@@ -314,8 +300,8 @@ static int pc87413_open(struct inode *in
 	/* Reload and activate timer */
 	pc87413_refresh();
 
-	printk(KERN_INFO MODNAME "Watchdog enabled. Timeout set to"
-	                         " %d minute(s).\n", timeout);
+	printk(KERN_INFO MODNAME
+		"Watchdog enabled. Timeout set to %d minute(s).\n", timeout);
 
 	return nonseekable_open(inode, file);
 }
@@ -338,17 +324,15 @@ static int pc87413_release(struct inode 
 
 	if (expect_close == 42) {
 		pc87413_disable();
-		printk(KERN_INFO MODNAME "Watchdog disabled,"
-		                         " sleeping again...\n");
+		printk(KERN_INFO MODNAME
+				"Watchdog disabled, sleeping again...\n");
 	} else {
-		printk(KERN_CRIT MODNAME "Unexpected close, not stopping"
-		                         " watchdog!\n");
+		printk(KERN_CRIT MODNAME
+				"Unexpected close, not stopping watchdog!\n");
 		pc87413_refresh();
 	}
-
 	clear_bit(0, &timer_enabled);
 	expect_close = 0;
-
 	return 0;
 }
 
@@ -386,7 +370,8 @@ static ssize_t pc87413_write(struct file
 			/* reset expect flag */
 			expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			   magic character */
 			for (i = 0; i != len; i++) {
 				char c;
 				if (get_user(c, data+i))
@@ -404,7 +389,6 @@ static ssize_t pc87413_write(struct file
 
 /**
  *	pc87413_ioctl:
- *	@inode: inode of the device
  *	@file: file handle to the device
  *	@cmd: watchdog command
  *	@arg: argument pointer
@@ -414,8 +398,8 @@ static ssize_t pc87413_write(struct file
  *	querying capabilities and current status.
  */
 
-static int pc87413_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long pc87413_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int new_timeout;
 
@@ -426,75 +410,58 @@ static int pc87413_ioctl(struct inode *i
 
 	static struct watchdog_info ident = {
 		.options          = WDIOF_KEEPALIVEPING |
-		                    WDIOF_SETTIMEOUT |
-		                    WDIOF_MAGICCLOSE,
+				    WDIOF_SETTIMEOUT |
+				    WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity         = "PC87413(HF/F) watchdog"
 	};
 
 	uarg.i = (int __user *)arg;
 
-	switch(cmd) {
-		default:
-			return -ENOTTY;
-
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(uarg.ident, &ident,
-				sizeof(ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-			return put_user(pc87413_status(), uarg.i);
-
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, uarg.i);
-
-		case WDIOC_KEEPALIVE:
-			pc87413_refresh();
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(uarg.ident, &ident,
+					sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+		return put_user(pc87413_status(), uarg.i);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, uarg.i);
+	case WDIOC_KEEPALIVE:
+		pc87413_refresh();
 #ifdef DEBUG
-	                printk(KERN_INFO DPFX "keepalive\n");
+		printk(KERN_INFO DPFX "keepalive\n");
 #endif
-			return 0;
-
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_timeout, uarg.i))
-				return -EFAULT;
-
-			// the API states this is given in secs
-			new_timeout /= 60;
-
-			if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
-				return -EINVAL;
-
-			timeout = new_timeout;
-			pc87413_refresh();
-
-			// fall through and return the new timeout...
-
-		case WDIOC_GETTIMEOUT:
-
-		        new_timeout = timeout * 60;
-
-			return put_user(new_timeout, uarg.i);
-
-		case WDIOC_SETOPTIONS:
-		{
-			int options, retval = -EINVAL;
-
-			if (get_user(options, uarg.i))
-				return -EFAULT;
-
-			if (options & WDIOS_DISABLECARD) {
-			        pc87413_disable();
-				retval = 0;
-			}
-
-			if (options & WDIOS_ENABLECARD) {
-				pc87413_enable();
-				retval = 0;
-			}
-
-			return retval;
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, uarg.i))
+			return -EFAULT;
+		/* the API states this is given in secs */
+		new_timeout /= 60;
+		if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
+			return -EINVAL;
+		timeout = new_timeout;
+		pc87413_refresh();
+		/* fall through and return the new timeout... */
+	case WDIOC_GETTIMEOUT:
+		new_timeout = timeout * 60;
+		return put_user(new_timeout, uarg.i);
+	case WDIOC_SETOPTIONS:
+	{
+		int options, retval = -EINVAL;
+		if (get_user(options, uarg.i))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			pc87413_disable();
+			retval = 0;
 		}
+		if (options & WDIOS_ENABLECARD) {
+			pc87413_enable();
+			retval = 0;
+		}
+		return retval;
+	}
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -517,10 +484,8 @@ static int pc87413_notify_sys(struct not
 			      void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
-	{
 		/* Turn the card off */
 		pc87413_disable();
-	}
 	return NOTIFY_DONE;
 }
 
@@ -530,18 +495,16 @@ static const struct file_operations pc87
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= pc87413_write,
-	.ioctl		= pc87413_ioctl,
+	.unlocked_ioctl	= pc87413_ioctl,
 	.open		= pc87413_open,
 	.release	= pc87413_release,
 };
 
-static struct notifier_block pc87413_notifier =
-{
+static struct notifier_block pc87413_notifier = {
 	.notifier_call  = pc87413_notify_sys,
 };
 
-static struct miscdevice pc87413_miscdev=
-{
+static struct miscdevice pc87413_miscdev = {
 	.minor          = WATCHDOG_MINOR,
 	.name           = "watchdog",
 	.fops           = &pc87413_fops
@@ -561,29 +524,26 @@ static int __init pc87413_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n", WDT_INDEX_IO_PORT);
+	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n",
+							WDT_INDEX_IO_PORT);
 
 	/* request_region(io, 2, "pc87413"); */
 
 	ret = register_reboot_notifier(&pc87413_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 	}
 
 	ret = misc_register(&pc87413_miscdev);
-
 	if (ret != 0) {
 		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&pc87413_notifier);
 		return ret;
 	}
-
 	printk(KERN_INFO PFX "initialized. timeout=%d min \n", timeout);
-
 	pc87413_enable();
-
 	return 0;
 }
 
@@ -600,8 +560,7 @@ static int __init pc87413_init(void)
 static void __exit pc87413_exit(void)
 {
 	/* Stop the timer before we leave */
-	if (!nowayout)
-	{
+	if (!nowayout) {
 		pc87413_disable();
 		printk(KERN_INFO MODNAME "Watchdog disabled.\n");
 	}
@@ -626,8 +585,12 @@ module_param(io, int, 0);
 MODULE_PARM_DESC(io, MODNAME " I/O port (default: " __MODULE_STRING(io) ").");
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in minutes (default=" __MODULE_STRING(timeout) ").");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in minutes (default="
+				__MODULE_STRING(timeout) ").");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
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

