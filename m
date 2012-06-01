From: akpm@linux-foundation.org
Subject: [merged] nilfs2-flush-disk-caches-in-syncing.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:18 -0700
Message-ID: <20120601193318.5993AA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56227 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034Ab2FATdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:19 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so246756qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: flush disk caches in syncing
has been removed from the -mm tree.  Its filename was
     nilfs2-flush-disk-caches-in-syncing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: flush disk caches in syncing

There are two cases that the cache flush is needed to avoid data loss
against unexpected hang or power failure.  One is sync file function (i.e.
 nilfs_sync_file) and another is checkpointing ioctl.

This issues a cache flush request to device for such cases if barrier
mount option is enabled, and makes sure data really is on persistent
storage on their completion.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c  |   24 ++++++++++++++----------
 fs/nilfs2/ioctl.c |    8 +++++++-
 2 files changed, 21 insertions(+), 11 deletions(-)

diff -puN fs/nilfs2/file.c~nilfs2-flush-disk-caches-in-syncing fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~nilfs2-flush-disk-caches-in-syncing
+++ a/fs/nilfs2/file.c
@@ -37,6 +37,7 @@ int nilfs_sync_file(struct file *file, l
 	 * This function should be implemented when the writeback function
 	 * will be implemented.
 	 */
+	struct the_nilfs *nilfs;
 	struct inode *inode = file->f_mapping->host;
 	int err;
 
@@ -45,18 +46,21 @@ int nilfs_sync_file(struct file *file, l
 		return err;
 	mutex_lock(&inode->i_mutex);
 
-	if (!nilfs_inode_dirty(inode)) {
-		mutex_unlock(&inode->i_mutex);
-		return 0;
+	if (nilfs_inode_dirty(inode)) {
+		if (datasync)
+			err = nilfs_construct_dsync_segment(inode->i_sb, inode,
+							    0, LLONG_MAX);
+		else
+			err = nilfs_construct_segment(inode->i_sb);
 	}
-
-	if (datasync)
-		err = nilfs_construct_dsync_segment(inode->i_sb, inode, 0,
-						    LLONG_MAX);
-	else
-		err = nilfs_construct_segment(inode->i_sb);
-
 	mutex_unlock(&inode->i_mutex);
+
+	nilfs = inode->i_sb->s_fs_info;
+	if (!err && nilfs_test_opt(nilfs, BARRIER)) {
+		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		if (err != -EIO)
+			err = 0;
+	}
 	return err;
 }
 
diff -puN fs/nilfs2/ioctl.c~nilfs2-flush-disk-caches-in-syncing fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-flush-disk-caches-in-syncing
+++ a/fs/nilfs2/ioctl.c
@@ -692,8 +692,14 @@ static int nilfs_ioctl_sync(struct inode
 	if (ret < 0)
 		return ret;
 
+	nilfs = inode->i_sb->s_fs_info;
+	if (nilfs_test_opt(nilfs, BARRIER)) {
+		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		if (ret == -EIO)
+			return ret;
+	}
+
 	if (argp != NULL) {
-		nilfs = inode->i_sb->s_fs_info;
 		down_read(&nilfs->ns_segctor_sem);
 		cno = nilfs->ns_cno - 1;
 		up_read(&nilfs->ns_segctor_sem);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

