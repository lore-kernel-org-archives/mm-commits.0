From: akpm@linux-foundation.org
Subject: + sysace-hdio_getgeo-has-its-own-method-for-ages.patch added to -mm tree
Date: Wed, 01 Aug 2007 14:02:02 -0700
Message-ID: <200708012102.l71L22m7016966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbXHAVC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 17:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, grant.likely@secretlab.ca, jens.axboe@oracle.com


The patch titled
     sysace: HDIO_GETGEO has it's own method for ages
has been added to the -mm tree.  Its filename is
     sysace-hdio_getgeo-has-its-own-method-for-ages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysace: HDIO_GETGEO has it's own method for ages
From: Christoph Hellwig <hch@lst.de>

The way this driver tries to implement HDIO_GETGEO it'll never be called. 
Then again on ppc it probably will never be called anyway because it's
utterly pointless.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/xsysace.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff -puN drivers/block/xsysace.c~sysace-hdio_getgeo-has-its-own-method-for-ages drivers/block/xsysace.c
--- a/drivers/block/xsysace.c~sysace-hdio_getgeo-has-its-own-method-for-ages
+++ a/drivers/block/xsysace.c
@@ -902,26 +902,17 @@ static int ace_release(struct inode *ino
 	return 0;
 }
 
-static int ace_ioctl(struct inode *inode, struct file *filp,
-		     unsigned int cmd, unsigned long arg)
+static int ace_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
-	struct ace_device *ace = inode->i_bdev->bd_disk->private_data;
-	struct hd_geometry __user *geo = (struct hd_geometry __user *)arg;
-	struct hd_geometry g;
-	dev_dbg(ace->dev, "ace_ioctl()\n");
-
-	switch (cmd) {
-	case HDIO_GETGEO:
-		g.heads = ace->cf_id.heads;
-		g.sectors = ace->cf_id.sectors;
-		g.cylinders = ace->cf_id.cyls;
-		g.start = 0;
-		return copy_to_user(geo, &g, sizeof(g)) ? -EFAULT : 0;
+	struct ace_device *ace = bdev->bd_disk->private_data;
 
-	default:
-		return -ENOTTY;
-	}
-	return -ENOTTY;
+	dev_dbg(ace->dev, "ace_getgeo()\n");
+
+	geo->heads = ace->cf_id.heads;
+	geo->sectors = ace->cf_id.sectors;
+	geo->cylinders = ace->cf_id.cyls;
+
+	return 0;
 }
 
 static struct block_device_operations ace_fops = {
@@ -930,7 +921,7 @@ static struct block_device_operations ac
 	.release = ace_release,
 	.media_changed = ace_media_changed,
 	.revalidate_disk = ace_revalidate_disk,
-	.ioctl = ace_ioctl,
+	.getgeo = ace_getgeo,
 };
 
 /* --------------------------------------------------------------------
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-scsi-misc.patch
sysace-hdio_getgeo-has-its-own-method-for-ages.patch
partially-fix-up-the-lookup_one_noperm-mess.patch
git-unionfs-fixup.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
sysv-convert-to-new-aops.patch
kill-declare_mutex_locked.patch
remove-unneded-lock_kernel-in-driver-block-loopc.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
