From: akpm@linux-foundation.org
Subject: + watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:08 -0700
Message-ID: <200805200828.m4K8S8qw013128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758719AbYETI20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: ixp2000_wdt: clean up and unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl.patch

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
Subject: watchdog: ixp2000_wdt: clean up and unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ixp2000_wdt.c |   50 ++++++++++++++-----------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff -puN drivers/watchdog/ixp2000_wdt.c~watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl drivers/watchdog/ixp2000_wdt.c
--- a/drivers/watchdog/ixp2000_wdt.c~watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl
+++ a/drivers/watchdog/ixp2000_wdt.c
@@ -25,42 +25,45 @@
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int heartbeat = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
+static spinlock_t wdt_lock;
 
 #define	WDT_IN_USE		0
 #define	WDT_OK_TO_CLOSE		1
 
 static unsigned long wdt_tick_rate;
 
-static void
-wdt_enable(void)
+static void wdt_enable(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_RESET0, *(IXP2000_RESET0) | WDT_RESET_ENABLE);
 	ixp2000_reg_write(IXP2000_TWDE, WDT_ENABLE);
 	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
 	ixp2000_reg_write(IXP2000_T4_CTL, TIMER_DIVIDER_256 | TIMER_ENABLE);
+	spin_unlock(&wdt_lock);
 }
 
-static void
-wdt_disable(void)
+static void wdt_disable(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_T4_CTL, 0);
+	spin_unlock(&wdt_lock);
 }
 
-static void
-wdt_keepalive(void)
+static void wdt_keepalive(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
+	spin_unlock(&wdt_lock);
 }
 
-static int
-ixp2000_wdt_open(struct inode *inode, struct file *file)
+static int ixp2000_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
 		return -EBUSY;
@@ -72,8 +75,8 @@ ixp2000_wdt_open(struct inode *inode, st
 	return nonseekable_open(inode, file);
 }
 
-static ssize_t
-ixp2000_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t ixp2000_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -103,9 +106,8 @@ static struct watchdog_info ident = {
 	.identity	= "IXP2000 Watchdog",
 };
 
-static int
-ixp2000_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-			unsigned long arg)
+static long ixp2000_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -151,16 +153,13 @@ ixp2000_wdt_ioctl(struct inode *inode, s
 	return ret;
 }
 
-static int
-ixp2000_wdt_release(struct inode *inode, struct file *file)
+static int ixp2000_wdt_release(struct inode *inode, struct file *file)
 {
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
-	} else {
+	else
 		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
 					"timer will not stop\n");
-	}
-
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
@@ -168,18 +167,16 @@ ixp2000_wdt_release(struct inode *inode,
 }
 
 
-static const struct file_operations ixp2000_wdt_fops =
-{
+static const struct file_operations ixp2000_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= ixp2000_wdt_write,
-	.ioctl		= ixp2000_wdt_ioctl,
+	.unlocked_ioctl	= ixp2000_wdt_ioctl,
 	.open		= ixp2000_wdt_open,
 	.release	= ixp2000_wdt_release,
 };
 
-static struct miscdevice ixp2000_wdt_miscdev =
-{
+static struct miscdevice ixp2000_wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &ixp2000_wdt_fops,
@@ -191,9 +188,8 @@ static int __init ixp2000_wdt_init(void)
 		printk(KERN_INFO "Unable to use IXP2000 watchdog due to IXP2800 erratum #25.\n");
 		return -EIO;
 	}
-
 	wdt_tick_rate = (*IXP2000_T1_CLD * HZ) / 256;
-
+	spin_lock_init(&wdt_lock);
 	return misc_register(&ixp2000_wdt_miscdev);
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

