From: akpm@linux-foundation.org
Subject: [patch 015/119] ocfs2: clean up dead code in alloc.c
Date: Wed, 31 Jan 2018 16:14:55 -0800
Message-ID: <20180201001455.69W1MqV9t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33716 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbeBAAO5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:14:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: Changwei Ge <ge.changwei@h3c.com>
Subject: ocfs2: clean up dead code in alloc.c

Some stack variables are no longer used but still assigned.  Trim them.

Link: http://lkml.kernel.org/r/1516105069-12643-1-git-send-email-ge.changwei@h3c.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-clean-dead-code-up-in-allocc fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-clean-dead-code-up-in-allocc
+++ a/fs/ocfs2/alloc.c
@@ -2598,11 +2598,8 @@ static void ocfs2_unlink_subtree(handle_
 	int i;
 	struct buffer_head *root_bh = left_path->p_node[subtree_index].bh;
 	struct ocfs2_extent_list *root_el = left_path->p_node[subtree_index].el;
-	struct ocfs2_extent_list *el;
 	struct ocfs2_extent_block *eb;
 
-	el = path_leaf_el(left_path);
-
 	eb = (struct ocfs2_extent_block *)right_path->p_node[subtree_index + 1].bh->b_data;
 
 	for(i = 1; i < le16_to_cpu(root_el->l_next_free_rec); i++)
@@ -3938,7 +3935,7 @@ static void ocfs2_adjust_rightmost_recor
 					   struct ocfs2_path *path,
 					   struct ocfs2_extent_rec *insert_rec)
 {
-	int ret, i, next_free;
+	int i, next_free;
 	struct buffer_head *bh;
 	struct ocfs2_extent_list *el;
 	struct ocfs2_extent_rec *rec;
@@ -3955,7 +3952,6 @@ static void ocfs2_adjust_rightmost_recor
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
 				    "Owner %llu has a bad extent list\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
-			ret = -EIO;
 			return;
 		}
 
@@ -5057,7 +5053,6 @@ int ocfs2_split_extent(handle_t *handle,
 	struct buffer_head *last_eb_bh = NULL;
 	struct ocfs2_extent_rec *rec = &el->l_recs[split_index];
 	struct ocfs2_merge_ctxt ctxt;
-	struct ocfs2_extent_list *rightmost_el;
 
 	if (le32_to_cpu(rec->e_cpos) > le32_to_cpu(split_rec->e_cpos) ||
 	    ((le32_to_cpu(rec->e_cpos) + le16_to_cpu(rec->e_leaf_clusters)) <
@@ -5093,9 +5088,7 @@ int ocfs2_split_extent(handle_t *handle,
 		}
 
 		eb = (struct ocfs2_extent_block *) last_eb_bh->b_data;
-		rightmost_el = &eb->h_list;
-	} else
-		rightmost_el = path_root_el(path);
+	}
 
 	if (rec->e_cpos == split_rec->e_cpos &&
 	    rec->e_leaf_clusters == split_rec->e_leaf_clusters)
_
