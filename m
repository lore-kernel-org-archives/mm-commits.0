From: akpm@linux-foundation.org
Subject: - watchdog-w83977f_wdt-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:17 -0700
Message-ID: <200807162137.m6GLbHCR014368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758144AbYGPVqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: w83977f_wdt: clean up, coding style and switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-w83977f_wdt-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

