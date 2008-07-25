From: akpm@linux-foundation.org
Subject: - ip2-push-bkl-down-for-the-firmware-interface.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:19 -0700
Message-ID: <200807252301.m6PN1Js5003697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbYGYXCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ip2: push BKL down for the firmware interface
has been removed from the -mm tree.  Its filename was
     ip2-push-bkl-down-for-the-firmware-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ip2: push BKL down for the firmware interface
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

(The tty side is already done)

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~ip2-push-bkl-down-for-the-firmware-interface drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~ip2-push-bkl-down-for-the-firmware-interface
+++ a/drivers/char/ip2/ip2main.c
@@ -203,7 +203,7 @@ static int set_serial_info(i2ChanStrPtr,
 
 static ssize_t ip2_ipl_read(struct file *, char __user *, size_t, loff_t *);
 static ssize_t ip2_ipl_write(struct file *, const char __user *, size_t, loff_t *);
-static int ip2_ipl_ioctl(struct inode *, struct file *, UINT, ULONG);
+static long ip2_ipl_ioctl(struct file *, UINT, ULONG);
 static int ip2_ipl_open(struct inode *, struct file *);
 
 static int DumpTraceBuffer(char __user *, int);
@@ -236,7 +236,7 @@ static const struct file_operations ip2_
 	.owner		= THIS_MODULE,
 	.read		= ip2_ipl_read,
 	.write		= ip2_ipl_write,
-	.ioctl		= ip2_ipl_ioctl,
+	.unlocked_ioctl	= ip2_ipl_ioctl,
 	.open		= ip2_ipl_open,
 }; 
 
@@ -2845,10 +2845,10 @@ ip2_ipl_write(struct file *pFile, const 
 /*                                                                            */
 /*                                                                            */
 /******************************************************************************/
-static int
-ip2_ipl_ioctl ( struct inode *pInode, struct file *pFile, UINT cmd, ULONG arg )
+static long
+ip2_ipl_ioctl (struct file *pFile, UINT cmd, ULONG arg )
 {
-	unsigned int iplminor = iminor(pInode);
+	unsigned int iplminor = iminor(pFile->f_path.dentry->d_inode);
 	int rc = 0;
 	void __user *argp = (void __user *)arg;
 	ULONG __user *pIndex = argp;
@@ -2859,6 +2859,8 @@ ip2_ipl_ioctl ( struct inode *pInode, st
 	printk (KERN_DEBUG "IP2IPL: ioctl cmd %d, arg %ld\n", cmd, arg );
 #endif
 
+	lock_kernel();
+
 	switch ( iplminor ) {
 	case 0:	    // IPL device
 		rc = -EINVAL;
@@ -2919,6 +2921,7 @@ ip2_ipl_ioctl ( struct inode *pInode, st
 		rc = -ENODEV;
 		break;
 	}
+	unlock_kernel();
 	return rc;
 }
 
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

