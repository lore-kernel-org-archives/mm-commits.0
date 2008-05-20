From: akpm@linux-foundation.org
Subject: + watchdog-rm9k_wdt-clean-up.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:28 -0700
Message-ID: <200805200828.m4K8SSsu013167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761224AbYETI3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: rm9k_wdt: clean up
has been added to the -mm tree.  Its filename is
     watchdog-rm9k_wdt-clean-up.patch

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
Subject: watchdog: rm9k_wdt: clean up
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/rm9k_wdt.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/watchdog/rm9k_wdt.c~watchdog-rm9k_wdt-clean-up drivers/watchdog/rm9k_wdt.c
--- a/drivers/watchdog/rm9k_wdt.c~watchdog-rm9k_wdt-clean-up
+++ a/drivers/watchdog/rm9k_wdt.c
@@ -29,10 +29,10 @@
 #include <linux/notifier.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <asm/io.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/atomic.h>
 #include <asm/processor.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/rm9k-ocd.h>
 
@@ -53,10 +53,12 @@ static void wdt_gpi_stop(void);
 static void wdt_gpi_set_timeout(unsigned int);
 static int wdt_gpi_open(struct inode *, struct file *);
 static int wdt_gpi_release(struct inode *, struct file *);
-static ssize_t wdt_gpi_write(struct file *, const char __user *, size_t, loff_t *);
+static ssize_t wdt_gpi_write(struct file *, const char __user *, size_t,
+								loff_t *);
 static long wdt_gpi_ioctl(struct file *, unsigned int, unsigned long);
 static int wdt_gpi_notify(struct notifier_block *, unsigned long, void *);
-static const struct resource *wdt_gpi_get_resource(struct platform_device *, const char *, unsigned int);
+static const struct resource *wdt_gpi_get_resource(struct platform_device *,
+						const char *, unsigned int);
 static int __init wdt_gpi_probe(struct device *);
 static int __exit wdt_gpi_remove(struct device *);
 
@@ -68,7 +70,7 @@ static int locked;
 
 
 /* These are set from device resources */
-static void __iomem * wd_regs;
+static void __iomem *wd_regs;
 static unsigned int wd_irq, wd_ctr;
 
 
@@ -216,7 +218,8 @@ static int wdt_gpi_release(struct inode 
 		if (expect_close) {
 			wdt_gpi_stop();
 			free_irq(wd_irq, &miscdev);
-			printk(KERN_INFO "%s: watchdog stopped\n", wdt_gpi_name);
+			printk(KERN_INFO "%s: watchdog stopped\n",
+							wdt_gpi_name);
 		} else {
 			printk(KERN_CRIT "%s: unexpected close() -"
 				" watchdog left running\n",
@@ -241,8 +244,7 @@ wdt_gpi_write(struct file *f, const char
 	return s ? 1 : 0;
 }
 
-static long
-wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static long wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	long res = -ENOTTY;
 	const long size = _IOC_SIZE(cmd);
@@ -271,7 +273,8 @@ wdt_gpi_ioctl(struct file *f, unsigned i
 	case WDIOC_GETSUPPORT:
 		wdinfo.options = nowayout ?
 			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING :
-			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE;
+			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+			WDIOF_MAGICCLOSE;
 		res = __copy_to_user(argp, &wdinfo, size) ?  -EFAULT : size;
 		break;
 
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

