From: akpm@linux-foundation.org
Subject: - efirtc-push-down-the-bkl.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:16 -0700
Message-ID: <200807252301.m6PN1GHn003693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbYGYXCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     efirtc: push down the BKL
has been removed from the -mm tree.  Its filename was
     efirtc-push-down-the-bkl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: efirtc: push down the BKL
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Push it down as far as the EFI method calls.  Someone who knows EFI can do
the other bits.  Also fix another wrong unknown ioctl return.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/efirtc.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff -puN drivers/char/efirtc.c~efirtc-push-down-the-bkl drivers/char/efirtc.c
--- a/drivers/char/efirtc.c~efirtc-push-down-the-bkl
+++ a/drivers/char/efirtc.c
@@ -37,8 +37,9 @@
 #include <linux/rtc.h>
 #include <linux/proc_fs.h>
 #include <linux/efi.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define EFI_RTC_VERSION		"0.4"
@@ -51,8 +52,8 @@
 
 static DEFINE_SPINLOCK(efi_rtc_lock);
 
-static int efi_rtc_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg);
+static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg);
 
 #define is_leap(year) \
           ((year) % 4 == 0 && ((year) % 100 != 0 || (year) % 400 == 0))
@@ -146,9 +147,8 @@ convert_from_efi_time(efi_time_t *eft, s
 	}
 }
 
-static int
-efi_rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 
 	efi_status_t	status;
@@ -175,13 +175,13 @@ efi_rtc_ioctl(struct inode *inode, struc
 			return -EINVAL;
 
 		case RTC_RD_TIME:
-
+			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.get_time(&eft, &cap);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
-
+			unlock_kernel();
 			if (status != EFI_SUCCESS) {
 				/* should never happen */
 				printk(KERN_ERR "efitime: can't read time\n");
@@ -203,11 +203,13 @@ efi_rtc_ioctl(struct inode *inode, struc
 
 			convert_to_efi_time(&wtime, &eft);
 
+			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.set_time(&eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
+			unlock_kernel();
 
 			return status == EFI_SUCCESS ? 0 : -EINVAL;
 
@@ -223,6 +225,7 @@ efi_rtc_ioctl(struct inode *inode, struc
 
 			convert_to_efi_time(&wtime, &eft);
 
+			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 			/*
 			 * XXX Fixme:
@@ -233,16 +236,19 @@ efi_rtc_ioctl(struct inode *inode, struc
 			status = efi.set_wakeup_time((efi_bool_t)enabled, &eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
+			unlock_kernel();
 
 			return status == EFI_SUCCESS ? 0 : -EINVAL;
 
 		case RTC_WKALM_RD:
 
+			lock_kernel();
 			spin_lock_irqsave(&efi_rtc_lock, flags);
 
 			status = efi.get_wakeup_time((efi_bool_t *)&enabled, (efi_bool_t *)&pending, &eft);
 
 			spin_unlock_irqrestore(&efi_rtc_lock,flags);
+			unlock_kernel();
 
 			if (status != EFI_SUCCESS) return -EINVAL;
 
@@ -256,7 +262,7 @@ efi_rtc_ioctl(struct inode *inode, struc
 			return copy_to_user(&ewp->time, &wtime,
 					    sizeof(struct rtc_time)) ? -EFAULT : 0;
 	}
-	return -EINVAL;
+	return -ENOTTY;
 }
 
 /*
@@ -265,8 +271,7 @@ efi_rtc_ioctl(struct inode *inode, struc
  *	up things on a close.
  */
 
-static int
-efi_rtc_open(struct inode *inode, struct file *file)
+static int efi_rtc_open(struct inode *inode, struct file *file)
 {
 	/*
 	 * nothing special to do here
@@ -277,8 +282,7 @@ efi_rtc_open(struct inode *inode, struct
 	return 0;
 }
 
-static int
-efi_rtc_close(struct inode *inode, struct file *file)
+static int efi_rtc_close(struct inode *inode, struct file *file)
 {
 	return 0;
 }
@@ -289,13 +293,12 @@ efi_rtc_close(struct inode *inode, struc
 
 static const struct file_operations efi_rtc_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= efi_rtc_ioctl,
+	.unlocked_ioctl	= efi_rtc_ioctl,
 	.open		= efi_rtc_open,
 	.release	= efi_rtc_close,
 };
 
-static struct miscdevice efi_rtc_dev=
-{
+static struct miscdevice efi_rtc_dev= {
 	EFI_RTC_MINOR,
 	"efirtc",
 	&efi_rtc_fops
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
hugetlb-fix-config_sysctl=n-build.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

