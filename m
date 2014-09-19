From: akpm@linux-foundation.org
Subject: + nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs.patch
 added to -mm tree
Date: Fri, 19 Sep 2014 15:59:28 -0700
Message-ID: <541cb550.q8oqzJkviXjknmde%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbaISW73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 18:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.rohner@gmx.net, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()
has been added to the -mm tree.  Its filename is
     nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andreas Rohner <andreas.rohner@gmx.net>
Subject: nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()

Under normal circumstances nilfs_sync_fs() writes out the super block,
which causes a flush of the underlying block device.  But this depends on
the THE_NILFS_SB_DIRTY flag, which is only set if the pointer to the last
segment crosses a segment boundary.  So if only a small amount of data is
written before the call to nilfs_sync_fs(), no flush of the block device
occurs.

In the above case an additional call to blkdev_issue_flush() is needed. 
To prevent unnecessary overhead, the new flag nilfs->ns_flushed_device is
introduced, which is cleared whenever new logs are written and set
whenever the block device is flushed.  For convenience the function
nilfs_flush_device() is added, which contains the above logic.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c      |    8 +++-----
 fs/nilfs2/ioctl.c     |    8 +++-----
 fs/nilfs2/segment.c   |    3 +++
 fs/nilfs2/super.c     |    6 ++++++
 fs/nilfs2/the_nilfs.h |   22 ++++++++++++++++++++++
 5 files changed, 37 insertions(+), 10 deletions(-)

diff -puN fs/nilfs2/file.c~nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs
+++ a/fs/nilfs2/file.c
@@ -56,11 +56,9 @@ int nilfs_sync_file(struct file *file, l
 	mutex_unlock(&inode->i_mutex);
 
 	nilfs = inode->i_sb->s_fs_info;
-	if (!err && nilfs_test_opt(nilfs, BARRIER)) {
-		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
-		if (err != -EIO)
-			err = 0;
-	}
+	if (!err)
+		err = nilfs_flush_device(nilfs);
+
 	return err;
 }
 
diff -puN fs/nilfs2/ioctl.c~nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs
+++ a/fs/nilfs2/ioctl.c
@@ -1022,11 +1022,9 @@ static int nilfs_ioctl_sync(struct inode
 		return ret;
 
 	nilfs = inode->i_sb->s_fs_info;
-	if (nilfs_test_opt(nilfs, BARRIER)) {
-		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
-		if (ret == -EIO)
-			return ret;
-	}
+	ret = nilfs_flush_device(nilfs);
+	if (ret < 0)
+		return ret;
 
 	if (argp != NULL) {
 		down_read(&nilfs->ns_segctor_sem);
diff -puN fs/nilfs2/segment.c~nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs
+++ a/fs/nilfs2/segment.c
@@ -1833,6 +1833,7 @@ static void nilfs_segctor_complete_write
 	nilfs_set_next_segment(nilfs, segbuf);
 
 	if (update_sr) {
+		nilfs->ns_flushed_device = 0;
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
 				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
 
@@ -2216,6 +2217,8 @@ int nilfs_construct_dsync_segment(struct
 	sci->sc_dsync_end = end;
 
 	err = nilfs_segctor_do_construct(sci, SC_LSEG_DSYNC);
+	if (!err)
+		nilfs->ns_flushed_device = 0;
 
 	nilfs_transaction_unlock(sb);
 	return err;
diff -puN fs/nilfs2/super.c~nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs
+++ a/fs/nilfs2/super.c
@@ -310,6 +310,9 @@ int nilfs_commit_super(struct super_bloc
 					    nilfs->ns_sbsize));
 	}
 	clear_nilfs_sb_dirty(nilfs);
+	nilfs->ns_flushed_device = 1;
+	/* make sure store to ns_flushed_device cannot be reordered */
+	smp_wmb();
 	return nilfs_sync_super(sb, flag);
 }
 
@@ -514,6 +517,9 @@ static int nilfs_sync_fs(struct super_bl
 	}
 	up_write(&nilfs->ns_sem);
 
+	if (!err)
+		err = nilfs_flush_device(nilfs);
+
 	return err;
 }
 
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs
+++ a/fs/nilfs2/the_nilfs.h
@@ -46,6 +46,7 @@ enum {
 /**
  * struct the_nilfs - struct to supervise multiple nilfs mount points
  * @ns_flags: flags
+ * @ns_flushed_device: flag indicating if all volatile data was flushed
  * @ns_bdev: block device
  * @ns_sem: semaphore for shared states
  * @ns_snapshot_mount_mutex: mutex to protect snapshot mounts
@@ -103,6 +104,7 @@ enum {
  */
 struct the_nilfs {
 	unsigned long		ns_flags;
+	int			ns_flushed_device;
 
 	struct block_device    *ns_bdev;
 	struct rw_semaphore	ns_sem;
@@ -371,4 +373,24 @@ static inline int nilfs_segment_is_activ
 	return n == nilfs->ns_segnum || n == nilfs->ns_nextnum;
 }
 
+static inline int nilfs_flush_device(struct the_nilfs *nilfs)
+{
+	int err;
+
+	if (!nilfs_test_opt(nilfs, BARRIER) || nilfs->ns_flushed_device)
+		return 0;
+
+	nilfs->ns_flushed_device = 1;
+	/*
+	 * the store to ns_flushed_device must not be reordered after
+	 * blkdev_issue_flush().
+	 */
+	smp_wmb();
+
+	err = blkdev_issue_flush(nilfs->ns_bdev, GFP_KERNEL, NULL);
+	if (err != -EIO)
+		err = 0;
+	return err;
+}
+
 #endif /* _THE_NILFS_H */
_

Patches currently in -mm which might be from andreas.rohner@gmx.net are

nilfs2-fix-data-loss-with-mmap.patch
nilfs2-fix-data-loss-with-mmap-fix.patch
nilfs2-add-missing-blkdev_issue_flush-to-nilfs_sync_fs.patch

