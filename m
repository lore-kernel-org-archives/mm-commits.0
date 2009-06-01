From: akpm@linux-foundation.org
Subject: [merged] mtd-delete-final-remnants-of-mtd-ioctls-from-fs-compat_ioctlc.patch removed from -mm tree
Date: Mon, 01 Jun 2009 12:57:10 -0700
Message-ID: <200906011957.n51JvAWg021597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375AbZFAT5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 15:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kpc.mtd@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: delete final remnants of MTD ioctls from fs/compat_ioctl.c
has been removed from the -mm tree.  Its filename was
     mtd-delete-final-remnants-of-mtd-ioctls-from-fs-compat_ioctlc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: delete final remnants of MTD ioctls from fs/compat_ioctl.c
From: Kevin Cernekee <kpc.mtd@gmail.com>

Move all MTD compat_ioctl logic into drivers/mtd/mtdchar.c

Depends on this patch set:

http://lkml.org/lkml/2009/4/9/52
http://lkml.org/lkml/2009/4/9/53
http://lkml.org/lkml/2009/4/9/54
http://lkml.org/lkml/2009/4/9/55

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdchar.c |    3 ++-
 fs/compat_ioctl.c     |   22 ----------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff -puN drivers/mtd/mtdchar.c~mtd-delete-final-remnants-of-mtd-ioctls-from-fs-compat_ioctlc drivers/mtd/mtdchar.c
--- a/drivers/mtd/mtdchar.c~mtd-delete-final-remnants-of-mtd-ioctls-from-fs-compat_ioctlc
+++ a/drivers/mtd/mtdchar.c
@@ -836,6 +836,7 @@ struct mtd_oob_buf32 {
 static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
 	unsigned long arg)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct mtd_file_info *mfi = file->private_data;
 	struct mtd_info *mtd = mfi->mtd;
 	void __user *argp = (void __user *)arg;
@@ -873,7 +874,7 @@ static long mtd_compat_ioctl(struct file
 		break;
 	}
 	default:
-		ret = -ENOIOCTLCMD;
+		ret = mtd_ioctl(inode, file, cmd, arg);
 	}
 
 	unlock_kernel();
diff -puN fs/compat_ioctl.c~mtd-delete-final-remnants-of-mtd-ioctls-from-fs-compat_ioctlc fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~mtd-delete-final-remnants-of-mtd-ioctls-from-fs-compat_ioctlc
+++ a/fs/compat_ioctl.c
@@ -94,7 +94,6 @@
 #include <linux/atm_tcp.h>
 #include <linux/sonet.h>
 #include <linux/atm_suni.h>
-#include <linux/mtd/mtd.h>
 
 #include <linux/usb.h>
 #include <linux/usbdevice_fs.h>
@@ -2392,27 +2391,6 @@ COMPATIBLE_IOCTL(USBDEVFS_SUBMITURB32)
 COMPATIBLE_IOCTL(USBDEVFS_REAPURB32)
 COMPATIBLE_IOCTL(USBDEVFS_REAPURBNDELAY32)
 COMPATIBLE_IOCTL(USBDEVFS_CLEAR_HALT)
-/* MTD */
-COMPATIBLE_IOCTL(MEMGETINFO)
-COMPATIBLE_IOCTL(MEMERASE)
-COMPATIBLE_IOCTL(MEMLOCK)
-COMPATIBLE_IOCTL(MEMUNLOCK)
-COMPATIBLE_IOCTL(MEMGETREGIONCOUNT)
-COMPATIBLE_IOCTL(MEMGETREGIONINFO)
-COMPATIBLE_IOCTL(MEMSETOOBSEL)
-COMPATIBLE_IOCTL(MEMGETOOBSEL)
-COMPATIBLE_IOCTL(MEMGETBADBLOCK)
-COMPATIBLE_IOCTL(MEMSETBADBLOCK)
-COMPATIBLE_IOCTL(OTPSELECT)
-COMPATIBLE_IOCTL(OTPGETREGIONCOUNT)
-COMPATIBLE_IOCTL(OTPGETREGIONINFO)
-COMPATIBLE_IOCTL(OTPLOCK)
-COMPATIBLE_IOCTL(ECCGETLAYOUT)
-COMPATIBLE_IOCTL(ECCGETSTATS)
-COMPATIBLE_IOCTL(MTDFILEMODE)
-COMPATIBLE_IOCTL(MEMERASE64)
-COMPATIBLE_IOCTL(MEMREADOOB64)
-COMPATIBLE_IOCTL(MEMWRITEOOB64)
 /* NBD */
 ULONG_IOCTL(NBD_SET_SOCK)
 ULONG_IOCTL(NBD_SET_BLKSIZE)
_

Patches currently in -mm which might be from kpc.mtd@gmail.com are

linux-next.patch

