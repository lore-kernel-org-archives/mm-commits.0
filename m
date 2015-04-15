From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-less-function-calls-in-ocfs2_figure_merge_contig_type-after-error-detection.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:07:54 -0700
Message-ID: <552eb70a.yRzyCVNp11cPj5m1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbbDOTHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:07:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: less function calls in ocfs2_figure_merge_contig_type() after error detection
has been removed from the -mm tree.  Its filename was
     ocfs2-less-function-calls-in-ocfs2_figure_merge_contig_type-after-error-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: ocfs2: less function calls in ocfs2_figure_merge_contig_type() after error detection

ocfs2_free_path() was called in some cases by
ocfs2_figure_merge_contig_type() during error handling even if the passed
variables "left_path" and "right_path" contained still a null pointer.

Corresponding implementation details could be improved by adjustments for
jump labels according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-less-function-calls-in-ocfs2_figure_merge_contig_type-after-error-detection fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-less-function-calls-in-ocfs2_figure_merge_contig_type-after-error-detection
+++ a/fs/ocfs2/alloc.c
@@ -4332,17 +4332,17 @@ ocfs2_figure_merge_contig_type(struct oc
 	} else if (path->p_tree_depth > 0) {
 		status = ocfs2_find_cpos_for_left_leaf(sb, path, &left_cpos);
 		if (status)
-			goto out;
+			goto exit;
 
 		if (left_cpos != 0) {
 			left_path = ocfs2_new_path_from_path(path);
 			if (!left_path)
-				goto out;
+				goto exit;
 
 			status = ocfs2_find_path(et->et_ci, left_path,
 						 left_cpos);
 			if (status)
-				goto out;
+				goto free_left_path;
 
 			new_el = path_leaf_el(left_path);
 
@@ -4359,7 +4359,7 @@ ocfs2_figure_merge_contig_type(struct oc
 					    le16_to_cpu(new_el->l_next_free_rec),
 					    le16_to_cpu(new_el->l_count));
 				status = -EINVAL;
-				goto out;
+				goto free_left_path;
 			}
 			rec = &new_el->l_recs[
 				le16_to_cpu(new_el->l_next_free_rec) - 1];
@@ -4386,18 +4386,18 @@ ocfs2_figure_merge_contig_type(struct oc
 		 path->p_tree_depth > 0) {
 		status = ocfs2_find_cpos_for_right_leaf(sb, path, &right_cpos);
 		if (status)
-			goto out;
+			goto free_left_path;
 
 		if (right_cpos == 0)
-			goto out;
+			goto free_left_path;
 
 		right_path = ocfs2_new_path_from_path(path);
 		if (!right_path)
-			goto out;
+			goto free_left_path;
 
 		status = ocfs2_find_path(et->et_ci, right_path, right_cpos);
 		if (status)
-			goto out;
+			goto free_right_path;
 
 		new_el = path_leaf_el(right_path);
 		rec = &new_el->l_recs[0];
@@ -4411,7 +4411,7 @@ ocfs2_figure_merge_contig_type(struct oc
 					    (unsigned long long)le64_to_cpu(eb->h_blkno),
 					    le16_to_cpu(new_el->l_next_free_rec));
 				status = -EINVAL;
-				goto out;
+				goto free_right_path;
 			}
 			rec = &new_el->l_recs[1];
 		}
@@ -4428,9 +4428,11 @@ ocfs2_figure_merge_contig_type(struct oc
 			ret = contig_type;
 	}
 
-out:
-	ocfs2_free_path(left_path);
+free_right_path:
 	ocfs2_free_path(right_path);
+free_left_path:
+	ocfs2_free_path(left_path);
+exit:
 	return ret;
 }
 
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

origin.patch
linux-next.patch

