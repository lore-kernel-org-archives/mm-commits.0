From: akpm@linux-foundation.org
Subject: +
 ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch added to -mm tree
Date: Tue, 28 Apr 2015 14:38:31 -0700
Message-ID: <553ffdd7.O6BdUosgDSGfF4cM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030711AbbD1Vic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 17:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: extend transaction for ocfs2_remove_rightmost_path() and ocfs2_update_edge_lengths() before to avoid inconsistency between inode and et
has been added to the -mm tree.  Its filename is
     ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: extend transaction for ocfs2_remove_rightmost_path() and ocfs2_update_edge_lengths() before to avoid inconsistency between inode and et

The following functions will be called while truncating an extent:
ocfs2_remove_btree_range
  -> ocfs2_start_trans
  -> ocfs2_remove_extent
     -> ocfs2_truncate_rec
       -> ocfs2_extend_rotate_transaction
         -> jbd2_journal_restart if jbd2_journal_extend fail
       -> ocfs2_rotate_tree_left
         -> ocfs2_remove_rightmost_path
             -> ocfs2_extend_rotate_transaction
               -> ocfs2_unlink_subtree
                -> ocfs2_update_edge_lengths
                  -> ocfs2_extend_trans
                    -> jbd2_journal_restart if jbd2_journal_extend fail
  -> ocfs2_et_update_clusters
  -> ocfs2_commit_trans

jbd2_journal_restart() may be called and it may happened that the buffers
dirtied in ocfs2_truncate_rec() are committed while buffers dirtied in
ocfs2_et_update_clusters() are not, the total clusters on extent tree and
i_clusters in ocfs2_dinode is inconsistency.  So the clusters got from
ocfs2_dinode is incorrect, and it also cause read-only problem when call
ocfs2_commit_truncate() with the error message: "Inode %llu has empty
extent block at %llu".

We should extend enough credits for function ocfs2_remove_rightmost_path
and ocfs2_update_edge_lengths to avoid this inconsistency.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   82 +++++++++++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 28 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et
+++ a/fs/ocfs2/alloc.c
@@ -2526,21 +2526,6 @@ static int ocfs2_update_edge_lengths(han
 	struct ocfs2_extent_block *eb;
 	u32 range;
 
-	/*
-	 * In normal tree rotation process, we will never touch the
-	 * tree branch above subtree_index and ocfs2_extend_rotate_transaction
-	 * doesn't reserve the credits for them either.
-	 *
-	 * But we do have a special case here which will update the rightmost
-	 * records for all the bh in the path.
-	 * So we have to allocate extra credits and access them.
-	 */
-	ret = ocfs2_extend_trans(handle, subtree_index);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ret = ocfs2_journal_access_path(et->et_ci, handle, path);
 	if (ret) {
 		mlog_errno(ret);
@@ -2967,7 +2952,7 @@ static int __ocfs2_rotate_tree_left(hand
 		     right_path->p_node[subtree_root].bh->b_blocknr,
 		     right_path->p_tree_depth);
 
-		ret = ocfs2_extend_rotate_transaction(handle, subtree_root,
+		ret = ocfs2_extend_rotate_transaction(handle, 0,
 						      orig_credits, left_path);
 		if (ret) {
 			mlog_errno(ret);
@@ -3040,21 +3025,9 @@ static int ocfs2_remove_rightmost_path(h
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
 
-
 	ret = ocfs2_et_sanity_check(et);
 	if (ret)
 		goto out;
-	/*
-	 * There's two ways we handle this depending on
-	 * whether path is the only existing one.
-	 */
-	ret = ocfs2_extend_rotate_transaction(handle, 0,
-					      handle->h_buffer_credits,
-					      path);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
 
 	ret = ocfs2_journal_access_path(et->et_ci, handle, path);
 	if (ret) {
@@ -3628,6 +3601,14 @@ static int ocfs2_merge_rec_left(struct o
 		 */
 		if (le16_to_cpu(right_rec->e_leaf_clusters) == 0 &&
 		    le16_to_cpu(el->l_next_free_rec) == 1) {
+			/* extend credit for ocfs2_remove_rightmost_path */
+			ret = ocfs2_extend_rotate_transaction(handle, 0,
+					handle->h_buffer_credits,
+					right_path);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
 
 			ret = ocfs2_remove_rightmost_path(handle, et,
 							  right_path,
@@ -3666,6 +3647,14 @@ static int ocfs2_try_to_merge_extent(han
 	BUG_ON(ctxt->c_contig_type == CONTIG_NONE);
 
 	if (ctxt->c_split_covers_rec && ctxt->c_has_empty_extent) {
+		/* extend credit for ocfs2_remove_rightmost_path */
+		ret = ocfs2_extend_rotate_transaction(handle, 0,
+				handle->h_buffer_credits,
+				path);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 		/*
 		 * The merge code will need to create an empty
 		 * extent to take the place of the newly
@@ -3714,6 +3703,15 @@ static int ocfs2_try_to_merge_extent(han
 		 */
 		BUG_ON(!ocfs2_is_empty_extent(&el->l_recs[0]));
 
+		/* extend credit for ocfs2_remove_rightmost_path */
+		ret = ocfs2_extend_rotate_transaction(handle, 0,
+					handle->h_buffer_credits,
+					path);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
 		/* The merge left us with an empty extent, remove it. */
 		ret = ocfs2_rotate_tree_left(handle, et, path, dealloc);
 		if (ret) {
@@ -3735,6 +3733,15 @@ static int ocfs2_try_to_merge_extent(han
 			goto out;
 		}
 
+		/* extend credit for ocfs2_remove_rightmost_path */
+		ret = ocfs2_extend_rotate_transaction(handle, 0,
+				handle->h_buffer_credits,
+				path);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
 		ret = ocfs2_rotate_tree_left(handle, et, path, dealloc);
 		/*
 		 * Error from this last rotate is not critical, so
@@ -3770,6 +3777,16 @@ static int ocfs2_try_to_merge_extent(han
 		}
 
 		if (ctxt->c_split_covers_rec) {
+			/* extend credit for ocfs2_remove_rightmost_path */
+			ret = ocfs2_extend_rotate_transaction(handle, 0,
+					handle->h_buffer_credits,
+					path);
+			if (ret) {
+				mlog_errno(ret);
+				ret = 0;
+				goto out;
+			}
+
 			/*
 			 * The merge may have left an empty extent in
 			 * our leaf. Try to rotate it away.
@@ -5337,6 +5354,15 @@ static int ocfs2_truncate_rec(handle_t *
 	struct ocfs2_extent_block *eb;
 
 	if (ocfs2_is_empty_extent(&el->l_recs[0]) && index > 0) {
+		/* extend credit for ocfs2_remove_rightmost_path */
+		ret = ocfs2_extend_rotate_transaction(handle, 0,
+				handle->h_buffer_credits,
+				path);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
 		ret = ocfs2_rotate_tree_left(handle, et, path, dealloc);
 		if (ret) {
 			mlog_errno(ret);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-return-error-while-ocfs2_figure_merge_contig_type-failing.patch
ocfs2-remove-bug_onempty_extent-in-__ocfs2_rotate_tree_left.patch
ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch
ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

