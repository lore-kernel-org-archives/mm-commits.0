From: akpm@linux-foundation.org
Subject: - ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:31 -0700
Message-ID: <200807252301.m6PN1Vep003714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbYGYXC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ppdev: wrap ioctl handler in driver and push lock down
has been removed from the -mm tree.  Its filename was
     ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ppdev: wrap ioctl handler in driver and push lock down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ppdev.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/char/ppdev.c~ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down drivers/char/ppdev.c
--- a/drivers/char/ppdev.c~ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down
+++ a/drivers/char/ppdev.c
@@ -67,7 +67,7 @@
 #include <linux/major.h>
 #include <linux/ppdev.h>
 #include <linux/smp_lock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define PP_VERSION "ppdev: user-space parallel port driver"
 #define CHRDEV "ppdev"
@@ -328,10 +328,9 @@ static enum ieee1284_phase init_phase (i
 	return IEEE1284_PH_FWD_IDLE;
 }
 
-static int pp_ioctl(struct inode *inode, struct file *file,
-		    unsigned int cmd, unsigned long arg)
+static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	unsigned int minor = iminor(inode);
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	struct pp_struct *pp = file->private_data;
 	struct parport * port;
 	void __user *argp = (void __user *)arg;
@@ -634,6 +633,15 @@ static int pp_ioctl(struct inode *inode,
 	return 0;
 }
 
+static long pp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+	lock_kernel();
+	ret = pp_do_ioctl(file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 static int pp_open (struct inode * inode, struct file * file)
 {
 	unsigned int minor = iminor(inode);
@@ -745,7 +753,7 @@ static const struct file_operations pp_f
 	.read		= pp_read,
 	.write		= pp_write,
 	.poll		= pp_poll,
-	.ioctl		= pp_ioctl,
+	.unlocked_ioctl	= pp_ioctl,
 	.open		= pp_open,
 	.release	= pp_release,
 };
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

