From: akpm@linux-foundation.org
Subject: - quota-introduce-dquot_quota_sys_file-flag.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:27:23 -0800
Message-ID: <200811262027.mAQKRNl8000489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366AbYKZUh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:37:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: introduce DQUOT_QUOTA_SYS_FILE flag
has been removed from the -mm tree.  Its filename was
     quota-introduce-dquot_quota_sys_file-flag.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: introduce DQUOT_QUOTA_SYS_FILE flag
From: Jan Kara <jack@suse.cz>

If filesystem can handle quota files as system files hidden from users, we
can skip a lot of cache invalidation, syncing, inode flags setting etc. 
when turning quotas on, off and quota_sync.  Allow filesystem to indicate
that it is hiding quota files from users by DQUOT_QUOTA_SYS_FILE flag.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c            |   45 ++++++++++++++++++++++++++--------------
 fs/quota.c            |    3 ++
 include/linux/quota.h |    7 ++++++
 3 files changed, 40 insertions(+), 15 deletions(-)

diff -puN fs/dquot.c~quota-introduce-dquot_quota_sys_file-flag fs/dquot.c
--- a/fs/dquot.c~quota-introduce-dquot_quota_sys_file-flag
+++ a/fs/dquot.c
@@ -1625,6 +1625,11 @@ int vfs_quota_disable(struct super_block
 		dqopt->ops[cnt] = NULL;
 	}
 	mutex_unlock(&dqopt->dqonoff_mutex);
+
+	/* Skip syncing and setting flags if quota files are hidden */
+	if (dqopt->flags & DQUOT_QUOTA_SYS_FILE)
+		goto put_inodes;
+
 	/* Sync the superblock so that buffers with quota data are written to
 	 * disk (and so userspace sees correct data afterwards). */
 	if (sb->s_op->sync_fs)
@@ -1649,6 +1654,12 @@ int vfs_quota_disable(struct super_block
 				mark_inode_dirty(toputinode[cnt]);
 			}
 			mutex_unlock(&dqopt->dqonoff_mutex);
+		}
+	if (sb->s_bdev)
+		invalidate_bdev(sb->s_bdev);
+put_inodes:
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
+		if (toputinode[cnt]) {
 			/* On remount RO, we keep the inode pointer so that we
 			 * can reenable quota on the subsequent remount RW. We
 			 * have to check 'flags' variable and not use sb_has_
@@ -1661,8 +1672,6 @@ int vfs_quota_disable(struct super_block
 			else if (!toputinode[cnt]->i_nlink)
 				ret = -EBUSY;
 		}
-	if (sb->s_bdev)
-		invalidate_bdev(sb->s_bdev);
 	return ret;
 }
 
@@ -1709,25 +1718,31 @@ static int vfs_load_quota_inode(struct i
 		goto out_fmt;
 	}
 
-	/* As we bypass the pagecache we must now flush the inode so that
-	 * we see all the changes from userspace... */
-	write_inode_now(inode, 1);
-	/* And now flush the block cache so that kernel sees the changes */
-	invalidate_bdev(sb->s_bdev);
+	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE)) {
+		/* As we bypass the pagecache we must now flush the inode so
+		 * that we see all the changes from userspace... */
+		write_inode_now(inode, 1);
+		/* And now flush the block cache so that kernel sees the
+		 * changes */
+		invalidate_bdev(sb->s_bdev);
+	}
 	mutex_lock(&inode->i_mutex);
 	mutex_lock(&dqopt->dqonoff_mutex);
 	if (sb_has_quota_loaded(sb, type)) {
 		error = -EBUSY;
 		goto out_lock;
 	}
-	/* We don't want quota and atime on quota files (deadlocks possible)
-	 * Also nobody should write to the file - we use special IO operations
-	 * which ignore the immutable bit. */
-	down_write(&dqopt->dqptr_sem);
-	oldflags = inode->i_flags & (S_NOATIME | S_IMMUTABLE | S_NOQUOTA);
-	inode->i_flags |= S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
-	up_write(&dqopt->dqptr_sem);
-	sb->dq_op->drop(inode);
+
+	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE)) {
+		/* We don't want quota and atime on quota files (deadlocks
+		 * possible) Also nobody should write to the file - we use
+		 * special IO operations which ignore the immutable bit. */
+		down_write(&dqopt->dqptr_sem);
+		oldflags = inode->i_flags & (S_NOATIME | S_IMMUTABLE | S_NOQUOTA);
+		inode->i_flags |= S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
+		up_write(&dqopt->dqptr_sem);
+		sb->dq_op->drop(inode);
+	}
 
 	error = -EIO;
 	dqopt->files[type] = igrab(inode);
diff -puN fs/quota.c~quota-introduce-dquot_quota_sys_file-flag fs/quota.c
--- a/fs/quota.c~quota-introduce-dquot_quota_sys_file-flag
+++ a/fs/quota.c
@@ -160,6 +160,9 @@ static void quota_sync_sb(struct super_b
 	int cnt;
 
 	sb->s_qcop->quota_sync(sb, type);
+
+	if (sb_dqopt(sb)->flags & DQUOT_QUOTA_SYS_FILE)
+		return;
 	/* This is not very clever (and fast) but currently I don't know about
 	 * any other simple way of getting quota data to disk and we must get
 	 * them there for userspace to be visible... */
diff -puN include/linux/quota.h~quota-introduce-dquot_quota_sys_file-flag include/linux/quota.h
--- a/include/linux/quota.h~quota-introduce-dquot_quota_sys_file-flag
+++ a/include/linux/quota.h
@@ -332,6 +332,13 @@ enum {
 #define DQUOT_SUSPENDED		(1 << _DQUOT_SUSPENDED)
 #define DQUOT_STATE_FLAGS	(DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED | \
 				 DQUOT_SUSPENDED)
+/* Other quota flags */
+#define DQUOT_QUOTA_SYS_FILE	(1 << 6)	/* Quota file is a special
+						 * system file and user cannot
+						 * touch it. Filesystem is
+						 * responsible for setting
+						 * S_NOQUOTA, S_NOATIME flags
+						 */
 
 static inline unsigned int dquot_state_flag(unsigned int flags, int type)
 {
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
quota-introduce-dquot_quota_sys_file-flag.patch
quota-move-quotaio_vh-from-include-linux-to-fs.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-split-off-quota-tree-handling-into-a-separate-file.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch

