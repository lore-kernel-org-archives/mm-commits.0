Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6A7C0018A
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbjKFRee (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbjKFRed (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:34:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DC8D70
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:34:30 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0169C433C8;
        Mon,  6 Nov 2023 17:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699292070;
        bh=VXZ6g6Y87kiM7DIF5r/M1IZ+uAq1X/5lLObwtYkM4CE=;
        h=Date:To:From:Subject:From;
        b=mH1LFaNa4fn+rH3nyRX0eo/Eux3mLoGGtLUNwLV/61IU44cACuLBvAwE2GVBOXsGx
         0sqd/rvUdPYCiUbJjS69KHCykyWpSy/SL5iCnjNSx02RhV+5wJxr81XcH1xn7rCUQw
         tUu11nNNqIhZu8UDkYgk2UGH3acJ0lyzKc+1/9F4=
Date:   Mon, 06 Nov 2023 09:34:29 -0800
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-maple-state-end-for-write-operations.patch added to mm-unstable branch
Message-Id: <20231106173429.F0169C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: use maple state end for write operations
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-maple-state-end-for-write-operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-maple-state-end-for-write-operations.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: use maple state end for write operations
Date: Wed, 1 Nov 2023 13:16:27 -0400

ma_wr_state was previously tracking the end of the node for writing. 
Since the implementation of the ma_state end tracking, this is duplicated
work.  This patch removes the maple write state tracking of the end of the
node and uses the maple state end instead.

Link: https://lkml.kernel.org/r/20231101171629.3612299-11-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    1 
 lib/maple_tree.c           |   46 ++++++++++++++++++-----------------
 2 files changed, 24 insertions(+), 23 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-use-maple-state-end-for-write-operations
+++ a/include/linux/maple_tree.h
@@ -441,7 +441,6 @@ struct ma_wr_state {
 	unsigned long r_max;		/* range max */
 	enum maple_type type;		/* mas->node type */
 	unsigned char offset_end;	/* The offset where the write ends */
-	unsigned char node_end;		/* mas->node end */
 	unsigned long *pivots;		/* mas->node->pivots pointer */
 	unsigned long end_piv;		/* The pivot at the offset end */
 	void __rcu **slots;		/* mas->node->slots pointer */
--- a/lib/maple_tree.c~maple_tree-use-maple-state-end-for-write-operations
+++ a/lib/maple_tree.c
@@ -2158,11 +2158,11 @@ static noinline_for_kasan void mas_store
 	}
 
 	slot = offset_end + 1;
-	if (slot > wr_mas->node_end)
+	if (slot > mas->end)
 		goto b_end;
 
 	/* Copy end data to the end of the node. */
-	mas_mab_cp(mas, slot, wr_mas->node_end + 1, b_node, ++b_end);
+	mas_mab_cp(mas, slot, mas->end + 1, b_node, ++b_end);
 	b_node->b_end--;
 	return;
 
@@ -2253,8 +2253,8 @@ static inline void mas_wr_node_walk(stru
 
 	wr_mas->node = mas_mn(wr_mas->mas);
 	wr_mas->pivots = ma_pivots(wr_mas->node, wr_mas->type);
-	count = wr_mas->node_end = ma_data_end(wr_mas->node, wr_mas->type,
-					       wr_mas->pivots, mas->max);
+	count = mas->end = ma_data_end(wr_mas->node, wr_mas->type,
+				       wr_mas->pivots, mas->max);
 	offset = mas->offset;
 
 	while (offset < count && mas->index > wr_mas->pivots[offset])
@@ -3904,10 +3904,10 @@ static inline int mas_wr_spanning_store(
 
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(&l_wr_mas, &b_node, l_wr_mas.node_end);
+	mas_store_b_node(&l_wr_mas, &b_node, l_mas.end);
 	/* Copy r_mas into b_node. */
-	if (r_mas.offset <= r_wr_mas.node_end)
-		mas_mab_cp(&r_mas, r_mas.offset, r_wr_mas.node_end,
+	if (r_mas.offset <= r_mas.end)
+		mas_mab_cp(&r_mas, r_mas.offset, r_mas.end,
 			   &b_node, b_node.b_end + 1);
 	else
 		b_node.b_end++;
@@ -3949,7 +3949,7 @@ static inline bool mas_wr_node_store(str
 	if (mas->last == wr_mas->end_piv)
 		offset_end++; /* don't copy this offset */
 	else if (unlikely(wr_mas->r_max == ULONG_MAX))
-		mas_bulk_rebalance(mas, wr_mas->node_end, wr_mas->type);
+		mas_bulk_rebalance(mas, mas->end, wr_mas->type);
 
 	/* set up node. */
 	if (in_rcu) {
@@ -3985,12 +3985,12 @@ static inline bool mas_wr_node_store(str
 	 * this range wrote to the end of the node or it overwrote the rest of
 	 * the data
 	 */
-	if (offset_end > wr_mas->node_end)
+	if (offset_end > mas->end)
 		goto done;
 
 	dst_offset = mas->offset + 1;
 	/* Copy to the end of node if necessary. */
-	copy_size = wr_mas->node_end - offset_end + 1;
+	copy_size = mas->end - offset_end + 1;
 	memcpy(dst_slots + dst_offset, wr_mas->slots + offset_end,
 	       sizeof(void *) * copy_size);
 	memcpy(dst_pivots + dst_offset, wr_mas->pivots + offset_end,
@@ -4077,10 +4077,10 @@ static inline void mas_wr_extend_null(st
 	} else {
 		/* Check next slot(s) if we are overwriting the end */
 		if ((mas->last == wr_mas->end_piv) &&
-		    (wr_mas->node_end != wr_mas->offset_end) &&
+		    (mas->end != wr_mas->offset_end) &&
 		    !wr_mas->slots[wr_mas->offset_end + 1]) {
 			wr_mas->offset_end++;
-			if (wr_mas->offset_end == wr_mas->node_end)
+			if (wr_mas->offset_end == mas->end)
 				mas->last = mas->max;
 			else
 				mas->last = wr_mas->pivots[wr_mas->offset_end];
@@ -4105,11 +4105,11 @@ static inline void mas_wr_extend_null(st
 
 static inline void mas_wr_end_piv(struct ma_wr_state *wr_mas)
 {
-	while ((wr_mas->offset_end < wr_mas->node_end) &&
+	while ((wr_mas->offset_end < wr_mas->mas->end) &&
 	       (wr_mas->mas->last > wr_mas->pivots[wr_mas->offset_end]))
 		wr_mas->offset_end++;
 
-	if (wr_mas->offset_end < wr_mas->node_end)
+	if (wr_mas->offset_end < wr_mas->mas->end)
 		wr_mas->end_piv = wr_mas->pivots[wr_mas->offset_end];
 	else
 		wr_mas->end_piv = wr_mas->mas->max;
@@ -4121,7 +4121,7 @@ static inline void mas_wr_end_piv(struct
 static inline unsigned char mas_wr_new_end(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
-	unsigned char new_end = wr_mas->node_end + 2;
+	unsigned char new_end = mas->end + 2;
 
 	new_end -= wr_mas->offset_end - mas->offset;
 	if (wr_mas->r_min == mas->index)
@@ -4155,10 +4155,10 @@ static inline bool mas_wr_append(struct
 	if (mt_in_rcu(mas->tree))
 		return false;
 
-	if (mas->offset != wr_mas->node_end)
+	if (mas->offset != mas->end)
 		return false;
 
-	end = wr_mas->node_end;
+	end = mas->end;
 	if (mas->offset != end)
 		return false;
 
@@ -4210,7 +4210,7 @@ static void mas_wr_bnode(struct ma_wr_st
 	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	mas_commit_b_node(wr_mas, &b_node, wr_mas->node_end);
+	mas_commit_b_node(wr_mas, &b_node, wr_mas->mas->end);
 }
 
 static inline void mas_wr_modify(struct ma_wr_state *wr_mas)
@@ -4238,7 +4238,7 @@ static inline void mas_wr_modify(struct
 	if (mas_wr_append(wr_mas, new_end))
 		return;
 
-	if (new_end == wr_mas->node_end && mas_wr_slot_store(wr_mas))
+	if (new_end == mas->end && mas_wr_slot_store(wr_mas))
 		return;
 
 	if (mas_wr_node_store(wr_mas, new_end))
@@ -5044,6 +5044,7 @@ int mas_empty_area(struct ma_state *mas,
 	unsigned char offset;
 	unsigned long *pivots;
 	enum maple_type mt;
+	struct maple_node *node;
 
 	if (min > max)
 		return -EINVAL;
@@ -5074,13 +5075,14 @@ int mas_empty_area(struct ma_state *mas,
 	if (unlikely(offset == MAPLE_NODE_SLOTS))
 		return -EBUSY;
 
+	node = mas_mn(mas);
 	mt = mte_node_type(mas->node);
-	pivots = ma_pivots(mas_mn(mas), mt);
+	pivots = ma_pivots(node, mt);
 	min = mas_safe_min(mas, pivots, offset);
 	if (mas->index < min)
 		mas->index = min;
 	mas->last = mas->index + size - 1;
-	mas->end = mas_data_end(mas);
+	mas->end = ma_data_end(node, mt, pivots, mas->max);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mas_empty_area);
@@ -7588,7 +7590,7 @@ void mas_wr_dump(const struct ma_wr_stat
 	pr_err("WR_MAS: node=%p r_min=%lx r_max=%lx\n",
 	       wr_mas->node, wr_mas->r_min, wr_mas->r_max);
 	pr_err("        type=%u off_end=%u, node_end=%u, end_piv=%lx\n",
-	       wr_mas->type, wr_mas->offset_end, wr_mas->node_end,
+	       wr_mas->type, wr_mas->offset_end, wr_mas->mas->end,
 	       wr_mas->end_piv);
 }
 EXPORT_SYMBOL_GPL(mas_wr_dump);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch
maple_tree-make-mas_erase-more-robust.patch
maple_tree-move-debug-check-to-__mas_set_range.patch
maple_tree-add-end-of-node-tracking-to-the-maple-state.patch
maple_tree-use-cached-node-end-in-mas_next.patch
maple_tree-use-cached-node-end-in-mas_destroy.patch
maple_tree-clean-up-inlines-for-some-functions.patch
maple_tree-separate-ma_state-node-from-status.patch
maple_tree-separate-ma_state-node-from-status-fix-1.patch
maple_tree-separate-ma_state-node-from-status-fix-2.patch
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

