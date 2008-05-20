From: akpm@linux-foundation.org
Subject: + watchdog-sbc8360-clean-up.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:35 -0700
Message-ID: <200805200828.m4K8SZ0r013182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761454AbYETI3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: sbc8360: clean up
has been added to the -mm tree.  Its filename is
     watchdog-sbc8360-clean-up.patch

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
Subject: watchdog: sbc8360: clean up
From: Alan Cox <alan@redhat.com>

Needs a proper ioctl method adding and stuff

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/sbc8360.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff -puN drivers/watchdog/sbc8360.c~watchdog-sbc8360-clean-up drivers/watchdog/sbc8360.c
--- a/drivers/watchdog/sbc8360.c~watchdog-sbc8360-clean-up
+++ a/drivers/watchdog/sbc8360.c
@@ -48,13 +48,12 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/moduleparam.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static unsigned long sbc8360_is_open;
-static DEFINE_SPINLOCK(sbc8360_lock);
 static char expect_close;
 
 #define PFX "sbc8360: "
@@ -204,7 +203,8 @@ module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Index into timeout table (0-63) (default=27 (60s))");
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout,
-		 "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+		 "Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Kernel methods.
@@ -232,8 +232,8 @@ static void sbc8360_ping(void)
 }
 
 /* Userspace pings kernel driver, or requests clean close */
-static ssize_t sbc8360_write(struct file *file, const char __user * buf,
-			     size_t count, loff_t * ppos)
+static ssize_t sbc8360_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -257,16 +257,12 @@ static ssize_t sbc8360_write(struct file
 
 static int sbc8360_open(struct inode *inode, struct file *file)
 {
-	spin_lock(&sbc8360_lock);
-	if (test_and_set_bit(0, &sbc8360_is_open)) {
-		spin_unlock(&sbc8360_lock);
+	if (test_and_set_bit(0, &sbc8360_is_open))
 		return -EBUSY;
-	}
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
 	/* Activate and ping once to start the countdown */
-	spin_unlock(&sbc8360_lock);
 	sbc8360_activate();
 	sbc8360_ping();
 	return nonseekable_open(inode, file);
@@ -274,16 +270,14 @@ static int sbc8360_open(struct inode *in
 
 static int sbc8360_close(struct inode *inode, struct file *file)
 {
-	spin_lock(&sbc8360_lock);
 	if (expect_close == 42)
 		outb(0, SBC8360_ENABLE);
 	else
 		printk(KERN_CRIT PFX
-		       "SBC8360 device closed unexpectedly.  SBC8360 will not stop!\n");
+			"SBC8360 device closed unexpectedly.  SBC8360 will not stop!\n");
 
 	clear_bit(0, &sbc8360_is_open);
 	expect_close = 0;
-	spin_unlock(&sbc8360_lock);
 	return 0;
 }
 
@@ -382,13 +376,13 @@ static int __init sbc8360_init(void)
 
 	return 0;
 
-      out_nomisc:
+out_nomisc:
 	unregister_reboot_notifier(&sbc8360_notifier);
-      out_noreboot:
+out_noreboot:
 	release_region(SBC8360_BASETIME, 1);
-      out_nobasetimereg:
+out_nobasetimereg:
 	release_region(SBC8360_ENABLE, 1);
-      out:
+out:
 	return res;
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

