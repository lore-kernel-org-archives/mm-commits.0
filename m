From: akpm@linux-foundation.org
Subject: +
 ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch added to -mm tree
Date: Tue, 28 Apr 2015 14:38:33 -0700
Message-ID: <553ffdd9.OU40npKBB4Amro7i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030960AbbD1Vie (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 17:38:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not set fs read-only if rec[0] is empty while committing truncate
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch

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
Subject: ocfs2: do not set fs read-only if rec[0] is empty while committing truncate

While appending an extent to a file, it will call these functions:
ocfs2_insert_extent

  -> call ocfs2_grow_tree() if there's no free rec
     -> ocfs2_add_branch add a new branch to extent tree,
        now rec[0] in the leaf of rightmost path is empty
  -> ocfs2_do_insert_extent
     -> ocfs2_rotate_tree_right
       -> ocfs2_extend_rotate_transaction
          -> jbd2_journal_restart if jbd2_journal_extend fail
     -> ocfs2_insert_path
        -> ocfs2_extend_trans
          -> jbd2_journal_restart if jbd2_journal_extend fail
        -> ocfs2_insert_at_leaf
     -> ocfs2_et_update_clusters
Function jbd2_journal_restart() may be called and it may happened that
buffers dirtied in ocfs2_add_branch() are committed
while buffers dirtied in ocfs2_insert_at_leaf() and
ocfs2_et_update_clusters() are not.
So an empty rec[0] is left in rightmost path which will cause
read-only filesystem when call ocfs2_commit_truncate()
with the error message: "Inode %lu has an empty extent record".

This is not a serious problem, so remove the rightmost path when call
ocfs2_commit_truncate().

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate
+++ a/fs/ocfs2/alloc.c
@@ -3104,6 +3104,30 @@ out:
 	return ret;
 }
 
+static int ocfs2_remove_rightmost_empty_extent(struct ocfs2_super *osb,
+				struct ocfs2_extent_tree *et,
+				struct ocfs2_path *path,
+				struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	handle_t *handle;
+	int ret;
+	int credits = path->p_tree_depth * 2 + 1;
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ret = ocfs2_remove_rightmost_path(handle, et, path, dealloc);
+	if (ret)
+		mlog_errno(ret);
+
+	ocfs2_commit_trans(osb, handle);
+	return ret;
+}
+
 /*
  * Left rotation of btree records.
  *
@@ -7134,15 +7158,23 @@ start:
 		 * to check it up here before changing the tree.
 		*/
 		if (root_el->l_tree_depth && rec->e_int_clusters == 0) {
-			ocfs2_error(inode->i_sb, "Inode %lu has an empty "
+			mlog(ML_ERROR, "Inode %lu has an empty "
 				    "extent record, depth %u\n", inode->i_ino,
 				    le16_to_cpu(root_el->l_tree_depth));
-			status = -EROFS;
-			goto bail;
+			status = ocfs2_remove_rightmost_empty_extent(osb,
+					&et, path, &dealloc);
+			if (status) {
+				mlog_errno(status);
+				goto bail;
+			}
+
+			ocfs2_reinit_path(path, 1);
+			goto start;
+		} else {
+			trunc_cpos = le32_to_cpu(rec->e_cpos);
+			trunc_len = 0;
+			blkno = 0;
 		}
-		trunc_cpos = le32_to_cpu(rec->e_cpos);
-		trunc_len = 0;
-		blkno = 0;
 	} else if (le32_to_cpu(rec->e_cpos) >= new_highest_cpos) {
 		/*
 		 * Truncate entire record.
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-return-error-while-ocfs2_figure_merge_contig_type-failing.patch
ocfs2-remove-bug_onempty_extent-in-__ocfs2_rotate_tree_left.patch
ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch
ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

