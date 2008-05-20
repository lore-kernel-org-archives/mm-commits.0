From: akpm@linux-foundation.org
Subject: + watchdog-ar7-watchdog.patch added to -mm tree
Date: Tue, 20 May 2008 01:27:45 -0700
Message-ID: <200805200827.m4K8Rj8P013048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759610AbYETI2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: aR7 watchdog
has been added to the -mm tree.  Its filename is
     watchdog-ar7-watchdog.patch

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
Subject: watchdog: aR7 watchdog
From: Alan Cox <alan@redhat.com>

Fix locking
Use unlocked_ioctl
Remove semaphores

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ar7_wdt.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff -puN drivers/watchdog/ar7_wdt.c~watchdog-ar7-watchdog drivers/watchdog/ar7_wdt.c
--- a/drivers/watchdog/ar7_wdt.c~watchdog-ar7-watchdog
+++ a/drivers/watchdog/ar7_wdt.c
@@ -69,7 +69,8 @@ struct ar7_wdt {
 	u32 prescale;
 };
 
-static struct semaphore open_semaphore;
+static unsigned long wdt_is_open;
+static spinlock_t wdt_lock;
 static unsigned expect_close;
 
 /* XXX currently fixed, allows max margin ~68.72 secs */
@@ -154,8 +155,10 @@ static void ar7_wdt_update_margin(int ne
 	u32 change;
 
 	change = new_margin * (ar7_vbus_freq() / prescale_value);
-	if (change < 1) change = 1;
-	if (change > 0xffff) change = 0xffff;
+	if (change < 1)
+		change = 1;
+	if (change > 0xffff)
+		change = 0xffff;
 	ar7_wdt_change(change);
 	margin = change * prescale_value / ar7_vbus_freq();
 	printk(KERN_INFO DRVNAME
@@ -179,7 +182,7 @@ static void ar7_wdt_disable_wdt(void)
 static int ar7_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (!down_nowait(&open_semaphore))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 	ar7_wdt_enable_wdt();
 	expect_close = 0;
@@ -195,9 +198,7 @@ static int ar7_wdt_release(struct inode 
 		"will not disable the watchdog timer\n");
 	else if (!nowayout)
 		ar7_wdt_disable_wdt();
-
-	up(&open_semaphore);
-
+	clear_bit(0, &wdt_is_open);
 	return 0;
 }
 
@@ -222,7 +223,9 @@ static ssize_t ar7_wdt_write(struct file
 	if (len) {
 		size_t i;
 
+		spin_lock(&wdt_lock);
 		ar7_wdt_kick(1);
+		spin_unlock(&wdt_lock);
 
 		expect_close = 0;
 		for (i = 0; i < len; ++i) {
@@ -237,8 +240,8 @@ static ssize_t ar7_wdt_write(struct file
 	return len;
 }
 
-static int ar7_wdt_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long ar7_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	static struct watchdog_info ident = {
 		.identity = LONGNAME,
@@ -269,8 +272,10 @@ static int ar7_wdt_ioctl(struct inode *i
 		if (new_margin < 1)
 			return -EINVAL;
 
+		spin_lock(&wdt_lock);
 		ar7_wdt_update_margin(new_margin);
 		ar7_wdt_kick(1);
+		spin_unlock(&wdt_lock);
 
 	case WDIOC_GETTIMEOUT:
 		if (put_user(margin, (int *)arg))
@@ -282,7 +287,7 @@ static int ar7_wdt_ioctl(struct inode *i
 static const struct file_operations ar7_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ar7_wdt_write,
-	.ioctl		= ar7_wdt_ioctl,
+	.unlocked_ioctl	= ar7_wdt_ioctl,
 	.open		= ar7_wdt_open,
 	.release	= ar7_wdt_release,
 };
@@ -297,6 +302,8 @@ static int __init ar7_wdt_init(void)
 {
 	int rc;
 
+	spin_lock_init(&wdt_lock);
+
 	ar7_wdt_get_regs();
 
 	if (!request_mem_region(ar7_regs_wdt, sizeof(struct ar7_wdt),
@@ -312,8 +319,6 @@ static int __init ar7_wdt_init(void)
 	ar7_wdt_prescale(prescale_value);
 	ar7_wdt_update_margin(margin);
 
-	sema_init(&open_semaphore, 1);
-
 	rc = register_reboot_notifier(&ar7_wdt_notifier);
 	if (rc) {
 		printk(KERN_ERR DRVNAME
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

