From: akpm@linux-foundation.org
Subject: + watchdog-w83977f_wdt-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:54 -0700
Message-ID: <200805200828.m4K8Sspu013218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761405AbYETI3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: w83977f_wdt: clean up, coding style and switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-w83977f_wdt-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch

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
Subject: watchdog: w83977f_wdt: clean up, coding style and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/w83977f_wdt.c |  225 +++++++++++++++----------------
 1 file changed, 111 insertions(+), 114 deletions(-)

diff -puN drivers/watchdog/w83977f_wdt.c~watchdog-w83977f_wdt-clean-up-coding-style-and-switch-to-unlocked_ioctl drivers/watchdog/w83977f_wdt.c
--- a/drivers/watchdog/w83977f_wdt.c~watchdog-w83977f_wdt-clean-up-coding-style-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/w83977f_wdt.c
@@ -26,10 +26,10 @@
 #include <linux/watchdog.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define WATCHDOG_VERSION  "1.00"
 #define WATCHDOG_NAME     "W83977F WDT"
@@ -53,13 +53,17 @@ static	char expect_close;
 static	DEFINE_SPINLOCK(spinlock);
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout,"Watchdog timeout in seconds (15..7635), default=" __MODULE_STRING(DEFAULT_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds (15..7635), default="
+				__MODULE_STRING(DEFAULT_TIMEOUT) ")");
 module_param(testmode, int, 0);
-MODULE_PARM_DESC(testmode,"Watchdog testmode (1 = no reboot), default=0");
+MODULE_PARM_DESC(testmode, "Watchdog testmode (1 = no reboot), default=0");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Start the watchdog
@@ -72,8 +76,8 @@ static int wdt_start(void)
 	spin_lock_irqsave(&spinlock, flags);
 
 	/* Unlock the SuperIO chip */
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
 
 	/*
 	 * Select device Aux2 (device=8) to set watchdog regs F2, F3 and F4.
@@ -81,50 +85,49 @@ static int wdt_start(void)
 	 * F3 is set to enable watchdog LED blink at timeout.
 	 * F4 is used to just clear the TIMEOUT'ed state (bit 0).
 	 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
-	outb_p(0xF2,IO_INDEX_PORT);
-	outb_p(timeoutW,IO_DATA_PORT);
-	outb_p(0xF3,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
-	outb_p(0xF4,IO_INDEX_PORT);
-	outb_p(0x00,IO_DATA_PORT);
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
+	outb_p(0xF2, IO_INDEX_PORT);
+	outb_p(timeoutW, IO_DATA_PORT);
+	outb_p(0xF3, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
+	outb_p(0xF4, IO_INDEX_PORT);
+	outb_p(0x00, IO_DATA_PORT);
 
 	/* Set device Aux2 active */
-	outb_p(0x30,IO_INDEX_PORT);
-	outb_p(0x01,IO_DATA_PORT);
+	outb_p(0x30, IO_INDEX_PORT);
+	outb_p(0x01, IO_DATA_PORT);
 
-	/* 
+	/*
 	 * Select device Aux1 (dev=7) to set GP16 as the watchdog output
 	 * (in reg E6) and GP13 as the watchdog LED output (in reg E3).
 	 * Map GP16 at pin 119.
 	 * In test mode watch the bit 0 on F4 to indicate "triggered" or
 	 * check watchdog LED on SBC.
 	 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x07,IO_DATA_PORT);
-	if (!testmode)
-	{
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x07, IO_DATA_PORT);
+	if (!testmode) {
 		unsigned pin_map;
 
-		outb_p(0xE6,IO_INDEX_PORT);
-		outb_p(0x0A,IO_DATA_PORT);
-		outb_p(0x2C,IO_INDEX_PORT);
+		outb_p(0xE6, IO_INDEX_PORT);
+		outb_p(0x0A, IO_DATA_PORT);
+		outb_p(0x2C, IO_INDEX_PORT);
 		pin_map = inb_p(IO_DATA_PORT);
 		pin_map |= 0x10;
 		pin_map &= ~(0x20);
-		outb_p(0x2C,IO_INDEX_PORT);
-		outb_p(pin_map,IO_DATA_PORT);
+		outb_p(0x2C, IO_INDEX_PORT);
+		outb_p(pin_map, IO_DATA_PORT);
 	}
-	outb_p(0xE3,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
+	outb_p(0xE3, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
 
 	/* Set device Aux1 active */
-	outb_p(0x30,IO_INDEX_PORT);
-	outb_p(0x01,IO_DATA_PORT);
+	outb_p(0x30, IO_INDEX_PORT);
+	outb_p(0x01, IO_DATA_PORT);
 
 	/* Lock the SuperIO chip */
-	outb_p(LOCK_DATA,IO_INDEX_PORT);
+	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
@@ -144,42 +147,41 @@ static int wdt_stop(void)
 	spin_lock_irqsave(&spinlock, flags);
 
 	/* Unlock the SuperIO chip */
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
 
-	/* 
+	/*
 	 * Select device Aux2 (device=8) to set watchdog regs F2, F3 and F4.
 	 * F2 is reset to its default value (watchdog timer disabled).
 	 * F3 is reset to its default state.
 	 * F4 clears the TIMEOUT'ed state (bit 0) - back to default.
 	 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
-	outb_p(0xF2,IO_INDEX_PORT);
-	outb_p(0xFF,IO_DATA_PORT);
-	outb_p(0xF3,IO_INDEX_PORT);
-	outb_p(0x00,IO_DATA_PORT);
-	outb_p(0xF4,IO_INDEX_PORT);
-	outb_p(0x00,IO_DATA_PORT);
-	outb_p(0xF2,IO_INDEX_PORT);
-	outb_p(0x00,IO_DATA_PORT);
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
+	outb_p(0xF2, IO_INDEX_PORT);
+	outb_p(0xFF, IO_DATA_PORT);
+	outb_p(0xF3, IO_INDEX_PORT);
+	outb_p(0x00, IO_DATA_PORT);
+	outb_p(0xF4, IO_INDEX_PORT);
+	outb_p(0x00, IO_DATA_PORT);
+	outb_p(0xF2, IO_INDEX_PORT);
+	outb_p(0x00, IO_DATA_PORT);
 
 	/*
-	 * Select device Aux1 (dev=7) to set GP16 (in reg E6) and 
+	 * Select device Aux1 (dev=7) to set GP16 (in reg E6) and
 	 * Gp13 (in reg E3) as inputs.
 	 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x07,IO_DATA_PORT);
-	if (!testmode)
-	{
-		outb_p(0xE6,IO_INDEX_PORT);
-		outb_p(0x01,IO_DATA_PORT);
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x07, IO_DATA_PORT);
+	if (!testmode) {
+		outb_p(0xE6, IO_INDEX_PORT);
+		outb_p(0x01, IO_DATA_PORT);
 	}
-	outb_p(0xE3,IO_INDEX_PORT);
-	outb_p(0x01,IO_DATA_PORT);
+	outb_p(0xE3, IO_INDEX_PORT);
+	outb_p(0x01, IO_DATA_PORT);
 
 	/* Lock the SuperIO chip */
-	outb_p(LOCK_DATA,IO_INDEX_PORT);
+	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
@@ -200,17 +202,17 @@ static int wdt_keepalive(void)
 	spin_lock_irqsave(&spinlock, flags);
 
 	/* Unlock the SuperIO chip */
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
 
 	/* Select device Aux2 (device=8) to kick watchdog reg F2 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
-	outb_p(0xF2,IO_INDEX_PORT);
-	outb_p(timeoutW,IO_DATA_PORT);
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
+	outb_p(0xF2, IO_INDEX_PORT);
+	outb_p(timeoutW, IO_DATA_PORT);
 
 	/* Lock the SuperIO chip */
-	outb_p(LOCK_DATA,IO_INDEX_PORT);
+	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
@@ -227,7 +229,7 @@ static int wdt_set_timeout(int t)
 
 	/*
 	 * Convert seconds to watchdog counter time units, rounding up.
-	 * On PCM-5335 watchdog units are 30 seconds/step with 15 sec startup 
+	 * On PCM-5335 watchdog units are 30 seconds/step with 15 sec startup
 	 * value. This information is supplied in the PCM-5335 manual and was
 	 * checked by me on a real board. This is a bit strange because W83977f
 	 * datasheet says counter unit is in minutes!
@@ -241,7 +243,7 @@ static int wdt_set_timeout(int t)
 		return -EINVAL;
 
 	/*
-	 * timeout is the timeout in seconds, 
+	 * timeout is the timeout in seconds,
 	 * timeoutW is the timeout in watchdog counter units.
 	 */
 	timeoutW = tmrval;
@@ -261,17 +263,17 @@ static int wdt_get_status(int *status)
 	spin_lock_irqsave(&spinlock, flags);
 
 	/* Unlock the SuperIO chip */
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
 
 	/* Select device Aux2 (device=8) to read watchdog reg F4 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
-	outb_p(0xF4,IO_INDEX_PORT);
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
+	outb_p(0xF4, IO_INDEX_PORT);
 	new_status = inb_p(IO_DATA_PORT);
 
 	/* Lock the SuperIO chip */
-	outb_p(LOCK_DATA,IO_INDEX_PORT);
+	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
@@ -290,7 +292,7 @@ static int wdt_get_status(int *status)
 static int wdt_open(struct inode *inode, struct file *file)
 {
 	/* If the watchdog is alive we don't need to start it again */
-	if( test_and_set_bit(0, &timer_alive) )
+	if (test_and_set_bit(0, &timer_alive))
 		return -EBUSY;
 
 	if (nowayout)
@@ -306,13 +308,13 @@ static int wdt_release(struct inode *ino
 	 * Shut off the timer.
 	 * Lock it in if it's a module and we set nowayout
 	 */
-	if (expect_close == 42)
-	{
+	if (expect_close == 42) {
 		wdt_stop();
 		clear_bit(0, &timer_alive);
 	} else {
 		wdt_keepalive();
-		printk(KERN_CRIT PFX "unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"unexpected close, not stopping watchdog!\n");
 	}
 	expect_close = 0;
 	return 0;
@@ -333,24 +335,22 @@ static ssize_t wdt_write(struct file *fi
 			    size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count)
-	{
-		if (!nowayout)
-		{
+	if (count) {
+		if (!nowayout) {
 			size_t ofs;
 
-			/* note: just in case someone wrote the magic character long ago */
+			/* note: just in case someone wrote the
+			   magic character long ago */
 			expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
-			for(ofs = 0; ofs != count; ofs++)
-			{
+			/* scan to see whether or not we got the
+			   magic character */
+			for (ofs = 0; ofs != count; ofs++) {
 				char c;
 				if (get_user(c, buf + ofs))
 					return -EFAULT;
-				if (c == 'V') {
+				if (c == 'V')
 					expect_close = 42;
-				}
 			}
 		}
 
@@ -377,8 +377,7 @@ static struct watchdog_info ident = {
 	.identity = WATCHDOG_NAME,
 };
 
-static int wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int status;
 	int new_options, retval = -EINVAL;
@@ -390,13 +389,13 @@ static int wdt_ioctl(struct inode *inode
 
 	uarg.i = (int __user *)arg;
 
-	switch(cmd)
-	{
+	switch (cmd) {
 	default:
 		return -ENOTTY;
 
 	case WDIOC_GETSUPPORT:
-		return copy_to_user(uarg.ident, &ident, sizeof(ident)) ? -EFAULT : 0;
+		return copy_to_user(uarg.ident, &ident,
+						sizeof(ident)) ? -EFAULT : 0;
 
 	case WDIOC_GETSTATUS:
 		wdt_get_status(&status);
@@ -410,7 +409,7 @@ static int wdt_ioctl(struct inode *inode
 		return 0;
 
 	case WDIOC_SETOPTIONS:
-		if (get_user (new_options, uarg.i))
+		if (get_user(new_options, uarg.i))
 			return -EFAULT;
 
 		if (new_options & WDIOS_DISABLECARD) {
@@ -444,23 +443,21 @@ static int wdt_ioctl(struct inode *inode
 static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if (code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_stop();
 	return NOTIFY_DONE;
 }
 
-static const struct file_operations wdt_fops=
-{
+static const struct file_operations wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdt_write,
-	.ioctl		= wdt_ioctl,
+	.unlocked_ioctl	= wdt_ioctl,
 	.open		= wdt_open,
 	.release	= wdt_release,
 };
 
-static struct miscdevice wdt_miscdev=
-{
+static struct miscdevice wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &wdt_fops,
@@ -474,20 +471,20 @@ static int __init w83977f_wdt_init(void)
 {
 	int rc;
 
-        printk(KERN_INFO PFX DRIVER_VERSION);
+	printk(KERN_INFO PFX DRIVER_VERSION);
 
 	/*
-	 * Check that the timeout value is within it's range ; 
+	 * Check that the timeout value is within it's range;
 	 * if not reset to the default
 	 */
 	if (wdt_set_timeout(timeout)) {
 		wdt_set_timeout(DEFAULT_TIMEOUT);
-		printk(KERN_INFO PFX "timeout value must be 15<=timeout<=7635, using %d\n",
-			DEFAULT_TIMEOUT);
+		printk(KERN_INFO PFX
+		    "timeout value must be 15 <= timeout <= 7635, using %d\n",
+							DEFAULT_TIMEOUT);
 	}
 
-	if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME))
-	{
+	if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME)) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			IO_INDEX_PORT);
 		rc = -EIO;
@@ -495,30 +492,30 @@ static int __init w83977f_wdt_init(void)
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt_miscdev);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d testmode=%d)\n",
-		timeout, nowayout, testmode);
+	printk(KERN_INFO PFX
+		"initialized. timeout=%d sec (nowayout=%d testmode=%d)\n",
+					timeout, nowayout, testmode);
 
 	return 0;
 
 err_out_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 err_out_region:
-	release_region(IO_INDEX_PORT,2);
+	release_region(IO_INDEX_PORT, 2);
 err_out:
 	return rc;
 }
@@ -528,7 +525,7 @@ static void __exit w83977f_wdt_exit(void
 	wdt_stop();
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
-	release_region(IO_INDEX_PORT,2);
+	release_region(IO_INDEX_PORT, 2);
 }
 
 module_init(w83977f_wdt_init);
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

