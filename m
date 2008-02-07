From: akpm@linux-foundation.org
Subject: - quota-improve-inode-list-scanning-in-add_dquot_ref.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:21 -0800
Message-ID: <200802070024.m170O2r2006577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761837AbYBGAo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, gentuu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     quota: improve inode list scanning in add_dquot_ref()
has been removed from the -mm tree.  Its filename was
     quota-improve-inode-list-scanning-in-add_dquot_ref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: improve inode list scanning in add_dquot_ref()
From: Jan Kara <jack@suse.cz>

We restarted scan of sb->s_inodes list whenever we had to drop inode_lock
in add_dquot_ref().  This leads to overall quadratic running time and thus
add_dquot_ref() can take several minutes when called on a life filesystem. 
We fix the problem by using the fact that inode cannot be removed from
s_inodes list while we hold a reference to it and thus we can safely
restart the scan if we don't drop the reference.  Here we use the fact that
inodes freshly added to s_inodes list are already guaranteed to have quotas
properly initialized and the ordering of inodes on s_inodes list does not
change so we cannot skip any inode.

Thanks goes to Nick <gentuu@gmail.com> for analyzing the problem and
testing the fix.

[akpm@linux-foundation.org: iput(NULL) is legal]
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Nick <gentuu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN fs/dquot.c~quota-improve-inode-list-scanning-in-add_dquot_ref fs/dquot.c
--- a/fs/dquot.c~quota-improve-inode-list-scanning-in-add_dquot_ref
+++ a/fs/dquot.c
@@ -696,9 +696,8 @@ static int dqinit_needed(struct inode *i
 /* This routine is guarded by dqonoff_mutex mutex */
 static void add_dquot_ref(struct super_block *sb, int type)
 {
-	struct inode *inode;
+	struct inode *inode, *old_inode = NULL;
 
-restart:
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (!atomic_read(&inode->i_writecount))
@@ -711,12 +710,18 @@ restart:
 		__iget(inode);
 		spin_unlock(&inode_lock);
 
+		iput(old_inode);
 		sb->dq_op->initialize(inode, type);
-		iput(inode);
-		/* As we may have blocked we had better restart... */
-		goto restart;
+		/* We hold a reference to 'inode' so it couldn't have been
+		 * removed from s_inodes list while we dropped the inode_lock.
+		 * We cannot iput the inode now as we can be holding the last
+		 * reference and we cannot iput it under inode_lock. So we
+		 * keep the reference and iput it later. */
+		old_inode = inode;
+		spin_lock(&inode_lock);
 	}
 	spin_unlock(&inode_lock);
+	iput(old_inode);
 }
 
 /* Return 0 if dqput() won't block (note that 1 doesn't necessarily mean blocking) */
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
use-pgoff_t-instead-of-unsigned-long.patch
write_inode_now-avoid-unnecessary-synchronous-write.patch
udf-fix-coding-style-of-superc.patch
udf-remove-some-ugly-macros.patch
udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch
udf-check-if-udf_load_logicalvol-failed.patch
udf-convert-macros-related-to-bitmaps-to-functions.patch
udf-move-calculating-of-nr_groups-into-helper-function.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
udf-fix-coding-style.patch
udf-create-common-function-for-tag-checksumming.patch
udf-create-common-function-for-changing-free-space-counter.patch
udf-replace-loops-coded-with-goto-to-real-loops.patch
udf-convert-byte-order-of-constant-instead-of-variable.patch
udf-remove-udf_i_-macros-and-open-code-them.patch
udf-cache-struct-udf_inode_info.patch
udf-fix-udf_debug-macro.patch
udf-improve-readability-of-udf_load_partition.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
udf-avoid-unnecessary-synchronous-writes.patch
udf-cleanup-directory-offset-handling.patch
udf-fix-adding-entry-to-a-directory.patch
change-udf-maintainer.patch
isofs-implement-dmode-option.patch
isofs-implement-dmode-option-fix.patch
mount-options-fix-ext2.patch
mount-options-fix-isofs.patch
mount-options-fix-udf.patch
buffer_head-fix-private_list-handling.patch
