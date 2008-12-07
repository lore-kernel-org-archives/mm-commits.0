From: akpm@linux-foundation.org
Subject: - vfs-kill-fmode_ndelay_now.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:38 -0800
Message-ID: <200812070005.mB705cHM021510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbYLGAFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     vfs: kill FMODE_NDELAY_NOW
has been removed from the -mm tree.  Its filename was
     vfs-kill-fmode_ndelay_now.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: kill FMODE_NDELAY_NOW
From: Christoph Hellwig <hch@lst.de>

Update FMODE_NDELAY before each ioctl call so that we can kill the magic
FMODE_NDELAY_NOW.  It would be even better to do this directly in setfl(),
but for that we'd need to have FMODE_NDELAY for all files, not just block
special files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/compat_ioctl.c |    8 +++++++-
 drivers/scsi/sd.c    |    2 +-
 drivers/scsi/sr.c    |    2 +-
 fs/block_dev.c       |   10 +++++++++-
 include/linux/fs.h   |    1 -
 5 files changed, 18 insertions(+), 5 deletions(-)

diff -puN block/compat_ioctl.c~vfs-kill-fmode_ndelay_now block/compat_ioctl.c
--- a/block/compat_ioctl.c~vfs-kill-fmode_ndelay_now
+++ a/block/compat_ioctl.c
@@ -699,8 +699,14 @@ long compat_blkdev_ioctl(struct file *fi
 	struct backing_dev_info *bdi;
 	loff_t size;
 
+	/*
+	 * O_NDELAY can be altered using fcntl(.., F_SETFL, ..), so we have
+	 * to updated it before every ioctl.
+	 */
 	if (file->f_flags & O_NDELAY)
-		mode |= FMODE_NDELAY_NOW;
+		mode |= FMODE_NDELAY;
+	else
+		mode &= ~FMODE_NDELAY;
 
 	switch (cmd) {
 	case HDIO_GETGEO:
diff -puN drivers/scsi/sd.c~vfs-kill-fmode_ndelay_now drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~vfs-kill-fmode_ndelay_now
+++ a/drivers/scsi/sd.c
@@ -757,7 +757,7 @@ static int sd_ioctl(struct block_device 
 	 * access to the device is prohibited.
 	 */
 	error = scsi_nonblockable_ioctl(sdp, cmd, p,
-					(mode & FMODE_NDELAY_NOW) != 0);
+					(mode & FMODE_NDELAY) != 0);
 	if (!scsi_block_when_processing_errors(sdp) || !error)
 		return error;
 
diff -puN drivers/scsi/sr.c~vfs-kill-fmode_ndelay_now drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~vfs-kill-fmode_ndelay_now
+++ a/drivers/scsi/sr.c
@@ -521,7 +521,7 @@ static int sr_block_ioctl(struct block_d
 	 * if it doesn't recognise the ioctl
 	 */
 	ret = scsi_nonblockable_ioctl(sdev, cmd, argp,
-					(mode & FMODE_NDELAY_NOW) != 0);
+					(mode & FMODE_NDELAY) != 0);
 	if (ret != -ENODEV)
 		return ret;
 	return scsi_ioctl(sdev, cmd, argp);
diff -puN fs/block_dev.c~vfs-kill-fmode_ndelay_now fs/block_dev.c
--- a/fs/block_dev.c~vfs-kill-fmode_ndelay_now
+++ a/fs/block_dev.c
@@ -1218,8 +1218,16 @@ static long block_ioctl(struct file *fil
 {
 	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	fmode_t mode = file->f_mode;
+
+	/*
+	 * O_NDELAY can be altered using fcntl(.., F_SETFL, ..), so we have
+	 * to updated it before every ioctl.
+	 */
 	if (file->f_flags & O_NDELAY)
-		mode |= FMODE_NDELAY_NOW;
+		mode |= FMODE_NDELAY;
+	else
+		mode &= ~FMODE_NDELAY;
+
 	return blkdev_ioctl(bdev, mode, cmd, arg);
 }
 
diff -puN include/linux/fs.h~vfs-kill-fmode_ndelay_now include/linux/fs.h
--- a/include/linux/fs.h~vfs-kill-fmode_ndelay_now
+++ a/include/linux/fs.h
@@ -70,7 +70,6 @@ struct inodes_stat_t {
 #define FMODE_NDELAY	((__force fmode_t)32)
 #define FMODE_EXCL	((__force fmode_t)64)
 #define FMODE_WRITE_IOCTL	((__force fmode_t)128)
-#define FMODE_NDELAY_NOW	((__force fmode_t)256)
 
 #define RW_MASK		1
 #define RWA_MASK	2
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-namespacec-drop-code-after-return.patch
introduce-new-lsm-hooks-where-vfsmount-is-available.patch
vfs-expand-some-comments-d_path-seq_path.patch
vfs-lseekfd-0-seek_cur-race-condition.patch
block-do_mounts-add-device-info-to-mount-message.patch
loop-add-ioctl-to-resize-a-loop-device.patch
filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch
filesystem-freeze-implement-generic-freeze-feature.patch
filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch

