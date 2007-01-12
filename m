From: akpm@osdl.org
Subject: - revert-bd_mount_mutex-back-to-a-semaphore.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:18:10 -0800
Message-ID: <200701122218.l0CMIAZt030775@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39116 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161149AbXALWSt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:18:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dgc@sgi.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Revert bd_mount_mutex back to a semaphore
has been removed from the -mm tree.  Its filename was
     revert-bd_mount_mutex-back-to-a-semaphore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Revert bd_mount_mutex back to a semaphore
From: David Chinner <dgc@sgi.com>

Revert bd_mount_mutex back to a semaphore so that xfs_freeze -f /mnt/newtest;
xfs_freeze -u /mnt/newtest works safely and doesn't produce lockdep warnings.

(XFS unlocks the semaphore from a different task, by design.  The mutex
code warns about this)

Signed-off-by: Dave Chinner <dgc@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/block_dev.c       |    2 +-
 fs/buffer.c          |    6 +++---
 fs/gfs2/ops_fstype.c |    4 ++--
 fs/super.c           |    4 ++--
 include/linux/fs.h   |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/block_dev.c~revert-bd_mount_mutex-back-to-a-semaphore fs/block_dev.c
--- a/fs/block_dev.c~revert-bd_mount_mutex-back-to-a-semaphore
+++ a/fs/block_dev.c
@@ -411,7 +411,7 @@ static void init_once(void * foo, struct
 	{
 		memset(bdev, 0, sizeof(*bdev));
 		mutex_init(&bdev->bd_mutex);
-		mutex_init(&bdev->bd_mount_mutex);
+		sema_init(&bdev->bd_mount_sem, 1);
 		INIT_LIST_HEAD(&bdev->bd_inodes);
 		INIT_LIST_HEAD(&bdev->bd_list);
 #ifdef CONFIG_SYSFS
diff -puN fs/buffer.c~revert-bd_mount_mutex-back-to-a-semaphore fs/buffer.c
--- a/fs/buffer.c~revert-bd_mount_mutex-back-to-a-semaphore
+++ a/fs/buffer.c
@@ -180,7 +180,7 @@ int fsync_bdev(struct block_device *bdev
  * freeze_bdev  --  lock a filesystem and force it into a consistent state
  * @bdev:	blockdevice to lock
  *
- * This takes the block device bd_mount_mutex to make sure no new mounts
+ * This takes the block device bd_mount_sem to make sure no new mounts
  * happen on bdev until thaw_bdev() is called.
  * If a superblock is found on this device, we take the s_umount semaphore
  * on it to make sure nobody unmounts until the snapshot creation is done.
@@ -189,7 +189,7 @@ struct super_block *freeze_bdev(struct b
 {
 	struct super_block *sb;
 
-	mutex_lock(&bdev->bd_mount_mutex);
+	down(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
 	if (sb && !(sb->s_flags & MS_RDONLY)) {
 		sb->s_frozen = SB_FREEZE_WRITE;
@@ -231,7 +231,7 @@ void thaw_bdev(struct block_device *bdev
 		drop_super(sb);
 	}
 
-	mutex_unlock(&bdev->bd_mount_mutex);
+	up(&bdev->bd_mount_sem);
 }
 EXPORT_SYMBOL(thaw_bdev);
 
diff -puN fs/gfs2/ops_fstype.c~revert-bd_mount_mutex-back-to-a-semaphore fs/gfs2/ops_fstype.c
--- a/fs/gfs2/ops_fstype.c~revert-bd_mount_mutex-back-to-a-semaphore
+++ a/fs/gfs2/ops_fstype.c
@@ -867,9 +867,9 @@ static int gfs2_get_sb_meta(struct file_
 		error = -EBUSY;
 		goto error;
 	}
-	mutex_lock(&sb->s_bdev->bd_mount_mutex);
+	down(&sb->s_bdev->bd_mount_sem);
 	new = sget(fs_type, test_bdev_super, set_bdev_super, sb->s_bdev);
-	mutex_unlock(&sb->s_bdev->bd_mount_mutex);
+	up(&sb->s_bdev->bd_mount_sem);
 	if (IS_ERR(new)) {
 		error = PTR_ERR(new);
 		goto error;
diff -puN fs/super.c~revert-bd_mount_mutex-back-to-a-semaphore fs/super.c
--- a/fs/super.c~revert-bd_mount_mutex-back-to-a-semaphore
+++ a/fs/super.c
@@ -753,9 +753,9 @@ int get_sb_bdev(struct file_system_type 
 	 * will protect the lockfs code from trying to start a snapshot
 	 * while we are mounting
 	 */
-	mutex_lock(&bdev->bd_mount_mutex);
+	down(&bdev->bd_mount_sem);
 	s = sget(fs_type, test_bdev_super, set_bdev_super, bdev);
-	mutex_unlock(&bdev->bd_mount_mutex);
+	up(&bdev->bd_mount_sem);
 	if (IS_ERR(s))
 		goto error_s;
 
diff -puN include/linux/fs.h~revert-bd_mount_mutex-back-to-a-semaphore include/linux/fs.h
--- a/include/linux/fs.h~revert-bd_mount_mutex-back-to-a-semaphore
+++ a/include/linux/fs.h
@@ -459,7 +459,7 @@ struct block_device {
 	struct inode *		bd_inode;	/* will die */
 	int			bd_openers;
 	struct mutex		bd_mutex;	/* open/close mutex */
-	struct mutex		bd_mount_mutex;	/* mount mutex */
+	struct semaphore	bd_mount_sem;
 	struct list_head	bd_inodes;
 	void *			bd_holder;
 	int			bd_holders;
_

Patches currently in -mm which might be from dgc@sgi.com are

xfs-remove-useless-wmb-memory-barrier.patch
make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch
make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch
