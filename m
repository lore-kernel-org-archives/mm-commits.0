From: akpm@linux-foundation.org
Subject: + watchdog-stg7240_wdt-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:34 -0700
Message-ID: <200805200828.m4K8SYgn013179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761426AbYETI3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: stg7240_wdt: unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-stg7240_wdt-unlocked_ioctl.patch

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
Subject: watchdog: stg7240_wdt: unlocked_ioctl
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/sbc7240_wdt.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/watchdog/sbc7240_wdt.c~watchdog-stg7240_wdt-unlocked_ioctl drivers/watchdog/sbc7240_wdt.c
--- a/drivers/watchdog/sbc7240_wdt.c~watchdog-stg7240_wdt-unlocked_ioctl
+++ a/drivers/watchdog/sbc7240_wdt.c
@@ -27,10 +27,10 @@
 #include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/atomic.h>
-#include <asm/io.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define SBC7240_PREFIX "sbc7240_wdt: "
 
@@ -159,7 +159,7 @@ static int fop_close(struct inode *inode
 	return 0;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_KEEPALIVEPING|
 		   WDIOF_SETTIMEOUT|
 		   WDIOF_MAGICCLOSE,
@@ -168,14 +168,12 @@ static struct watchdog_info ident = {
 };
 
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		return copy_to_user
-			((void __user *)arg, &ident, sizeof(ident))
-			 ? -EFAULT : 0;
+		return copy_to_user((void __user *)arg, &ident, sizeof(ident))
+						 ? -EFAULT : 0;
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, (int __user *)arg);
@@ -225,7 +223,7 @@ static const struct file_operations wdt_
 	.write = fop_write,
 	.open = fop_open,
 	.release = fop_close,
-	.ioctl = fop_ioctl,
+	.unlocked_ioctl = fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
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

