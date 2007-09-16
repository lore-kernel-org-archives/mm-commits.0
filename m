From: akpm@linux-foundation.org
Subject: - quote-fix-infinite-loop.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:25:14 -0700
Message-ID: <200709160925.l8G9PEVK009094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbXIPJ0V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:26:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, xavier.bru@bull.net, mm-commits@vger.kernel.org


The patch titled
     quota: fix infinite loop
has been removed from the -mm tree.  Its filename was
     quote-fix-infinite-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: quota: fix infinite loop
From: Jan Kara <jack@suse.cz>

If we fail to start a transaction when releasing dquot, we have to call
dquot_release() anyway to mark dquot structure as inactive.  Otherwise we
end in an infinite loop inside dqput().

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: xb <xavier.bru@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c     |   11 ++++++++++-
 fs/ext4/super.c     |   11 ++++++++++-
 fs/reiserfs/super.c |   13 +++++++++++--
 3 files changed, 31 insertions(+), 4 deletions(-)

diff -puN fs/ext3/super.c~quote-fix-infinite-loop fs/ext3/super.c
--- a/fs/ext3/super.c~quote-fix-infinite-loop
+++ a/fs/ext3/super.c
@@ -2578,8 +2578,11 @@ static int ext3_release_dquot(struct dqu
 
 	handle = ext3_journal_start(dquot_to_inode(dquot),
 					EXT3_QUOTA_DEL_BLOCKS(dquot->dq_sb));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		/* Release dquot anyway to avoid endless cycle in dqput() */
+		dquot_release(dquot);
 		return PTR_ERR(handle);
+	}
 	ret = dquot_release(dquot);
 	err = ext3_journal_stop(handle);
 	if (!ret)
@@ -2712,6 +2715,12 @@ static ssize_t ext3_quota_write(struct s
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
 
+	if (!handle) {
+		printk(KERN_WARNING "EXT3-fs: Quota write (off=%Lu, len=%Lu)"
+			" cancelled because transaction is not started.\n",
+			(unsigned long long)off, (unsigned long long)len);
+		return -EIO;
+	}
 	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	while (towrite > 0) {
 		tocopy = sb->s_blocksize - offset < towrite ?
diff -puN fs/ext4/super.c~quote-fix-infinite-loop fs/ext4/super.c
--- a/fs/ext4/super.c~quote-fix-infinite-loop
+++ a/fs/ext4/super.c
@@ -2698,8 +2698,11 @@ static int ext4_release_dquot(struct dqu
 
 	handle = ext4_journal_start(dquot_to_inode(dquot),
 					EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		/* Release dquot anyway to avoid endless cycle in dqput() */
+		dquot_release(dquot);
 		return PTR_ERR(handle);
+	}
 	ret = dquot_release(dquot);
 	err = ext4_journal_stop(handle);
 	if (!ret)
@@ -2832,6 +2835,12 @@ static ssize_t ext4_quota_write(struct s
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
 
+	if (!handle) {
+		printk(KERN_WARNING "EXT4-fs: Quota write (off=%Lu, len=%Lu)"
+			" cancelled because transaction is not started.\n",
+			(unsigned long long)off, (unsigned long long)len);
+		return -EIO;
+	}
 	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	while (towrite > 0) {
 		tocopy = sb->s_blocksize - offset < towrite ?
diff -puN fs/reiserfs/super.c~quote-fix-infinite-loop fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~quote-fix-infinite-loop
+++ a/fs/reiserfs/super.c
@@ -1915,8 +1915,11 @@ static int reiserfs_release_dquot(struct
 	ret =
 	    journal_begin(&th, dquot->dq_sb,
 			  REISERFS_QUOTA_DEL_BLOCKS(dquot->dq_sb));
-	if (ret)
+	if (ret) {
+		/* Release dquot anyway to avoid endless cycle in dqput() */
+		dquot_release(dquot);
 		goto out;
+	}
 	ret = dquot_release(dquot);
 	err =
 	    journal_end(&th, dquot->dq_sb,
@@ -2067,6 +2070,12 @@ static ssize_t reiserfs_quota_write(stru
 	size_t towrite = len;
 	struct buffer_head tmp_bh, *bh;
 
+	if (!current->journal_info) {
+		printk(KERN_WARNING "reiserfs: Quota write (off=%Lu, len=%Lu)"
+			" cancelled because transaction is not started.\n",
+			(unsigned long long)off, (unsigned long long)len);
+		return -EIO;
+	}
 	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	while (towrite > 0) {
 		tocopy = sb->s_blocksize - offset < towrite ?
@@ -2098,7 +2107,7 @@ static ssize_t reiserfs_quota_write(stru
 		data += tocopy;
 		blk++;
 	}
-      out:
+out:
 	if (len == towrite)
 		return err;
 	if (inode->i_size < off + len - towrite)
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
send-quota-messages-via-netlink.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
