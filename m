From: akpm@linux-foundation.org
Subject: + nilfs2-flush-disk-caches-in-syncing.patch added to -mm tree
Date: Tue, 08 May 2012 15:53:43 -0700
Message-ID: <20120508225343.42F1FA037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:57056 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2EHWxp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:53:45 -0400
Received: by eaaq10 with SMTP id q10so344432eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:53:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     Subject: nilfs2: flush disk caches in syncing
has been added to the -mm tree.  Its filename is
     nilfs2-flush-disk-caches-in-syncing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: nilfs2: flush disk caches in syncing

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-flush-disk-caches-in-syncing.patch

