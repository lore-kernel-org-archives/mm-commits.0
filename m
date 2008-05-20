From: akpm@linux-foundation.org
Subject: + watchdog-wdt977-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:29:01 -0700
Message-ID: <200805200829.m4K8T1N5013236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761630AbYETI3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: wdt977: clean up, coding style and switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-wdt977-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch

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
Subject: watchdog: wdt977: clean up, coding style and switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/wdt977.c |  148 ++++++++++++++++++------------------
 1 file changed, 74 insertions(+), 74 deletions(-)

diff -puN drivers/watchdog/wdt977.c~watchdog-wdt977-clean-up-coding-style-and-switch-to-unlocked_ioctl drivers/watchdog/wdt977.c
--- a/drivers/watchdog/wdt977.c~watchdog-wdt977-clean-up-coding-style-and-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/wdt977.c
@@ -19,7 +19,8 @@
  *      07-Jul-2003 Daniele Bellucci: Audit return code of misc_register in
  *                                    nwwatchdog_init.
  *      25-Oct-2005 Woody Suwalski: Convert addresses to #defs, add spinlocks
- *				    remove limitiation to be used on Netwinders only
+ *				    remove limitiation to be used on
+ *				    Netwinders only
  */
 
 #include <linux/module.h>
@@ -33,11 +34,11 @@
 #include <linux/watchdog.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
 #include <asm/system.h>
 #include <asm/mach-types.h>
-#include <asm/uaccess.h>
 
 #define WATCHDOG_VERSION  "0.04"
 #define WATCHDOG_NAME     "Wdt977"
@@ -45,7 +46,7 @@
 #define DRIVER_VERSION    WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
 
 #define IO_INDEX_PORT	0x370		/* on some systems it can be 0x3F0 */
-#define IO_DATA_PORT	(IO_INDEX_PORT+1)
+#define IO_DATA_PORT	(IO_INDEX_PORT + 1)
 
 #define UNLOCK_DATA	0x87
 #define LOCK_DATA	0xAA
@@ -62,13 +63,16 @@ static	char expect_close;
 static	DEFINE_SPINLOCK(spinlock);
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout,"Watchdog timeout in seconds (60..15300), default=" __MODULE_STRING(DEFAULT_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds (60..15300), default="
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
@@ -95,14 +99,16 @@ static int wdt977_start(void)
 	outb_p(0xF2, IO_INDEX_PORT);
 	outb_p(timeoutM, IO_DATA_PORT);
 	outb_p(0xF3, IO_INDEX_PORT);
-	outb_p(0x00, IO_DATA_PORT);	/* another setting is 0E for kbd/mouse/LED */
+	outb_p(0x00, IO_DATA_PORT);	/* another setting is 0E for
+					   kbd/mouse/LED */
 	outb_p(0xF4, IO_INDEX_PORT);
 	outb_p(0x00, IO_DATA_PORT);
 
-	/* at last select device Aux1 (dev=7) and set GP16 as a watchdog output */
-	/* in test mode watch the bit 1 on F4 to indicate "triggered" */
-	if (!testmode)
-	{
+	/* At last select device Aux1 (dev=7) and set GP16 as a
+	 * watchdog output. In test mode watch the bit 1 on F4 to
+	 * indicate "triggered"
+	 */
+	if (!testmode) {
 		outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
 		outb_p(0x07, IO_DATA_PORT);
 		outb_p(0xE6, IO_INDEX_PORT);
@@ -147,7 +153,8 @@ static int wdt977_stop(void)
 	outb_p(0xF2, IO_INDEX_PORT);
 	outb_p(0x00, IO_DATA_PORT);
 
-	/* at last select device Aux1 (dev=7) and set GP16 as a watchdog output */
+	/* at last select device Aux1 (dev=7) and set
+	   GP16 as a watchdog output */
 	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
 	outb_p(0x07, IO_DATA_PORT);
 	outb_p(0xE6, IO_INDEX_PORT);
@@ -202,16 +209,18 @@ static int wdt977_set_timeout(int t)
 	tmrval = (t + 59) / 60;
 
 	if (machine_is_netwinder()) {
-		/* we have a hw bug somewhere, so each 977 minute is actually only 30sec
-		 *  this limits the max timeout to half of device max of 255 minutes...
+		/* we have a hw bug somewhere, so each 977 minute is actually
+		 * only 30sec. This limits the max timeout to half of device
+		 * max of 255 minutes...
 		 */
 		tmrval += tmrval;
 	}
 
-	if ((tmrval < 1) || (tmrval > 255))
+	if (tmrval < 1 || tmrval > 255)
 		return -EINVAL;
 
-	/* timeout is the timeout in seconds, timeoutM is the timeout in minutes) */
+	/* timeout is the timeout in seconds, timeoutM is
+	   the timeout in minutes) */
 	timeout = t;
 	timeoutM = tmrval;
 	return 0;
@@ -243,7 +252,7 @@ static int wdt977_get_status(int *status
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
-	*status=0;
+	*status = 0;
 	if (new_status & 1)
 		*status |= WDIOF_CARDRESET;
 
@@ -258,7 +267,7 @@ static int wdt977_get_status(int *status
 static int wdt977_open(struct inode *inode, struct file *file)
 {
 	/* If the watchdog is alive we don't need to start it again */
-	if( test_and_set_bit(0,&timer_alive) )
+	if (test_and_set_bit(0, &timer_alive))
 		return -EBUSY;
 
 	if (nowayout)
@@ -274,13 +283,13 @@ static int wdt977_release(struct inode *
 	 *	Shut off the timer.
 	 * 	Lock it in if it's a module and we set nowayout
 	 */
-	if (expect_close == 42)
-	{
+	if (expect_close == 42) {
 		wdt977_stop();
-		clear_bit(0,&timer_alive);
+		clear_bit(0, &timer_alive);
 	} else {
 		wdt977_keepalive();
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 	}
 	expect_close = 0;
 	return 0;
@@ -301,17 +310,14 @@ static int wdt977_release(struct inode *
 static ssize_t wdt977_write(struct file *file, const char __user *buf,
 			    size_t count, loff_t *ppos)
 {
-	if (count)
-	{
-		if (!nowayout)
-		{
+	if (count) {
+		if (!nowayout) {
 			size_t i;
 
 			/* In case it was set long ago */
 			expect_close = 0;
 
-			for (i = 0; i != count; i++)
-			{
+			for (i = 0; i != count; i++) {
 				char c;
 				if (get_user(c, buf + i))
 					return -EFAULT;
@@ -326,6 +332,14 @@ static ssize_t wdt977_write(struct file 
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT |
+				WDIOF_MAGICCLOSE |
+				WDIOF_KEEPALIVEPING,
+	.firmware_version =	1,
+	.identity =		WATCHDOG_NAME,
+};
+
 /*
  *      wdt977_ioctl:
  *      @inode: inode of the device
@@ -337,16 +351,8 @@ static ssize_t wdt977_write(struct file 
  *      according to their available features.
  */
 
-static struct watchdog_info ident = {
-	.options =		WDIOF_SETTIMEOUT |
-				WDIOF_MAGICCLOSE |
-				WDIOF_KEEPALIVEPING,
-	.firmware_version =	1,
-	.identity =		WATCHDOG_NAME,
-};
-
-static int wdt977_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long wdt977_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int status;
 	int new_options, retval = -EINVAL;
@@ -358,8 +364,7 @@ static int wdt977_ioctl(struct inode *in
 
 	uarg.i = (int __user *)arg;
 
-	switch(cmd)
-	{
+	switch (cmd) {
 	default:
 		return -ENOTTY;
 
@@ -379,7 +384,7 @@ static int wdt977_ioctl(struct inode *in
 		return 0;
 
 	case WDIOC_SETOPTIONS:
-		if (get_user (new_options, uarg.i))
+		if (get_user(new_options, uarg.i))
 			return -EFAULT;
 
 		if (new_options & WDIOS_DISABLECARD) {
@@ -413,23 +418,21 @@ static int wdt977_ioctl(struct inode *in
 static int wdt977_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt977_stop();
 	return NOTIFY_DONE;
 }
 
-static const struct file_operations wdt977_fops=
-{
+static const struct file_operations wdt977_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdt977_write,
-	.ioctl		= wdt977_ioctl,
+	.unlocked_ioctl	= wdt977_ioctl,
 	.open		= wdt977_open,
 	.release	= wdt977_release,
 };
 
-static struct miscdevice wdt977_miscdev=
-{
+static struct miscdevice wdt977_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &wdt977_fops,
@@ -443,51 +446,48 @@ static int __init wd977_init(void)
 {
 	int rc;
 
-	//if (!machine_is_netwinder())
-	//	return -ENODEV;
-
 	printk(KERN_INFO PFX DRIVER_VERSION);
 
-	/* Check that the timeout value is within it's range ; if not reset to the default */
-	if (wdt977_set_timeout(timeout))
-	{
+	/* Check that the timeout value is within its range;
+	   if not reset to the default */
+	if (wdt977_set_timeout(timeout)) {
 		wdt977_set_timeout(DEFAULT_TIMEOUT);
-		printk(KERN_INFO PFX "timeout value must be 60<timeout<15300, using %d\n",
-			DEFAULT_TIMEOUT);
+		printk(KERN_INFO PFX
+		      "timeout value must be 60 < timeout < 15300, using %d\n",
+							DEFAULT_TIMEOUT);
 	}
 
 	/* on Netwinder the IOports are already reserved by
 	 * arch/arm/mach-footbridge/netwinder-hw.c
 	 */
-	if (!machine_is_netwinder())
-	{
-		if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME))
-		{
-			printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				IO_INDEX_PORT);
+	if (!machine_is_netwinder()) {
+		if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME)) {
+			printk(KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								IO_INDEX_PORT);
 			rc = -EIO;
 			goto err_out;
 		}
 	}
 
 	rc = register_reboot_notifier(&wdt977_notifier);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt977_miscdev);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt977_miscdev.minor, rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						wdt977_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
-		timeout, nowayout, testmode);
+	printk(KERN_INFO PFX
+		"initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
+						timeout, nowayout, testmode);
 
 	return 0;
 
@@ -495,7 +495,7 @@ err_out_reboot:
 	unregister_reboot_notifier(&wdt977_notifier);
 err_out_region:
 	if (!machine_is_netwinder())
-	        release_region(IO_INDEX_PORT,2);
+		release_region(IO_INDEX_PORT, 2);
 err_out:
 	return rc;
 }
@@ -505,7 +505,7 @@ static void __exit wd977_exit(void)
 	wdt977_stop();
 	misc_deregister(&wdt977_miscdev);
 	unregister_reboot_notifier(&wdt977_notifier);
-	release_region(IO_INDEX_PORT,2);
+	release_region(IO_INDEX_PORT, 2);
 }
 
 module_init(wd977_init);
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

