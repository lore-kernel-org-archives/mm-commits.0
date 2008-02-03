From: akpm@linux-foundation.org
Subject: - jbd-remove-useless-loop-in-journal_write_commit_record.patch removed from -mm tree
Date: Sun, 03 Feb 2008 12:23:00 -0800
Message-ID: <200802032022.m13KMfr7030031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35908 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbYBCU0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:26:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     jbd: remove useless loop in journal_write_commit_record()
has been removed from the -mm tree.  Its filename was
     jbd-remove-useless-loop-in-journal_write_commit_record.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: remove useless loop in journal_write_commit_record()
From: Jan Kara <jack@suse.cz>

Commit block was intended to have several copies of the header.  But due to
a bug it never had them and actually, nobody checks that.  So just remove
the useless loop.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN fs/jbd/commit.c~jbd-remove-useless-loop-in-journal_write_commit_record fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-remove-useless-loop-in-journal_write_commit_record
+++ a/fs/jbd/commit.c
@@ -104,7 +104,8 @@ static int journal_write_commit_record(j
 {
 	struct journal_head *descriptor;
 	struct buffer_head *bh;
-	int i, ret;
+	journal_header_t *header;
+	int ret;
 	int barrier_done = 0;
 
 	if (is_journal_aborted(journal))
@@ -116,13 +117,10 @@ static int journal_write_commit_record(j
 
 	bh = jh2bh(descriptor);
 
-	/* AKPM: buglet - add `i' to tmp! */
-	for (i = 0; i < bh->b_size; i += 512) {
-		journal_header_t *tmp = (journal_header_t*)bh->b_data;
-		tmp->h_magic = cpu_to_be32(JFS_MAGIC_NUMBER);
-		tmp->h_blocktype = cpu_to_be32(JFS_COMMIT_BLOCK);
-		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
-	}
+	header = (journal_header_t*)(bh->b_data);
+	header->h_magic = cpu_to_be32(JFS_MAGIC_NUMBER);
+	header->h_blocktype = cpu_to_be32(JFS_COMMIT_BLOCK);
+	header->h_sequence = cpu_to_be32(commit_transaction->t_tid);
 
 	JBUFFER_TRACE(descriptor, "write commit block");
 	set_buffer_dirty(bh);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
ext3-fix-lock-inversion-in-direct-io.patch
ext3-fix-lock-inversion-in-direct-io-fix.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
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
