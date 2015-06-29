From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-return-error-while-ocfs2_figure_merge_contig_type-failing.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:36:35 -0700
Message-ID: <5591ac53.cYxBc0evcRpXFIam%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbbF2Ugg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: return error when ocfs2_figure_merge_contig_type() fails
has been removed from the -mm tree.  Its filename was
     ocfs2-return-error-while-ocfs2_figure_merge_contig_type-failing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: return error when ocfs2_figure_merge_contig_type() fails

ocfs2_figure_merge_contig_type() still returns CONTIG_NONE when some error
occurs which will cause an unpredictable error.  So return a proper errno
when ocfs2_figure_merge_contig_type() fails.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-return-error-while-ocfs2_figure_merge_contig_type-failing fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-return-error-while-ocfs2_figure_merge_contig_type-failing
+++ a/fs/ocfs2/alloc.c
@@ -4311,13 +4311,13 @@ out:
 	return ret;
 }
 
-static enum ocfs2_contig_type
-ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
+static int ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
 			       struct ocfs2_path *path,
 			       struct ocfs2_extent_list *el, int index,
-			       struct ocfs2_extent_rec *split_rec)
+			       struct ocfs2_extent_rec *split_rec,
+			       struct ocfs2_merge_ctxt *ctxt)
 {
-	int status;
+	int status = 0;
 	enum ocfs2_contig_type ret = CONTIG_NONE;
 	u32 left_cpos, right_cpos;
 	struct ocfs2_extent_rec *rec = NULL;
@@ -4336,8 +4336,11 @@ ocfs2_figure_merge_contig_type(struct oc
 
 		if (left_cpos != 0) {
 			left_path = ocfs2_new_path_from_path(path);
-			if (!left_path)
+			if (!left_path) {
+				status = -ENOMEM;
+				mlog_errno(status);
 				goto exit;
+			}
 
 			status = ocfs2_find_path(et->et_ci, left_path,
 						 left_cpos);
@@ -4392,8 +4395,11 @@ ocfs2_figure_merge_contig_type(struct oc
 			goto free_left_path;
 
 		right_path = ocfs2_new_path_from_path(path);
-		if (!right_path)
+		if (!right_path) {
+			status = -ENOMEM;
+			mlog_errno(status);
 			goto free_left_path;
+		}
 
 		status = ocfs2_find_path(et->et_ci, right_path, right_cpos);
 		if (status)
@@ -4433,7 +4439,10 @@ free_right_path:
 free_left_path:
 	ocfs2_free_path(left_path);
 exit:
-	return ret;
+	if (status == 0)
+		ctxt->c_contig_type = ret;
+
+	return status;
 }
 
 static void ocfs2_figure_contig_type(struct ocfs2_extent_tree *et,
@@ -5039,9 +5048,14 @@ int ocfs2_split_extent(handle_t *handle,
 		goto out;
 	}
 
-	ctxt.c_contig_type = ocfs2_figure_merge_contig_type(et, path, el,
-							    split_index,
-							    split_rec);
+	ret = ocfs2_figure_merge_contig_type(et, path, el,
+					     split_index,
+					     split_rec,
+					     &ctxt);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
 
 	/*
 	 * The core merge / split code wants to know how much room is
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch
ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

