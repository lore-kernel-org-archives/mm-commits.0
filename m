Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E525A23E345
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 22:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695007; cv=none; b=PJk8dGibNgHP6LbubhZMC1JkrIHlNr+v6Kwp9byJmCYYsEdqNFVWdtitnEt/A+CnI87meYzWF9q1WXAssIsDJbKO+jUVoDGeip9OrDtvBFdvE5QAa5zWSIokYszzwO2DP43FhAkMigSmZb2O57ypg6aQBJEuAdgbppIc1qGLN3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695007; c=relaxed/simple;
	bh=1o2Y1JrKwvd9q/SVXsHz+Ui/YUaoGzlFz+3sLry7RcE=;
	h=Date:To:From:Subject:Message-Id; b=VNcBHcCQ2OM3Y6yc+teqkTmQ5vnG6jEsembVzLe9Wh8tcKAK8eRARtGbYgr4bmV+oaUUDJs5UJLeUdZWJDrUqzHasYL7fQGVVFHXcTV01o3V3rZUEVAYeJ9hO/aQtaPBsMaDRD2AUNUuHvcLgDGTVjxUIcBPBAwJyIomiuwSHHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ov5owP1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ov5owP1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CFAC4CEF4;
	Thu, 27 Feb 2025 22:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740695006;
	bh=1o2Y1JrKwvd9q/SVXsHz+Ui/YUaoGzlFz+3sLry7RcE=;
	h=Date:To:From:Subject:From;
	b=ov5owP1RHCId0zESqQRRHXUSBKMc3DtdrBrOI6OIb5ErieeMegdOubJwEuqrRjAh3
	 WcAZj6j7NusIsW37F2MMZ2q6yhoVhec/L+C8zQv7vDt8zx8imjZ/q5UuoX30kAQ/Vk
	 A1BPkrNoUTHlo5RDcMSZO+yF3EhOcA2xEB+A9p20=
Date: Thu, 27 Feb 2025 14:23:25 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-height-and-depth-consistently.patch added to mm-unstable branch
Message-Id: <20250227222326.A6CFAC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: use height and depth consistently
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-height-and-depth-consistently.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-height-and-depth-consistently.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: use height and depth consistently
Date: Thu, 27 Feb 2025 20:48:19 +0000

For the maple tree, the root node is defined to have a depth of 0 with a
height of 1.  Each level down from the node, these values are incremented
by 1.  Various code paths define a root with depth 1 which is inconsisent
with the definition.  Modify the code to be consistent with this
definition.

Link: https://lkml.kernel.org/r/20250227204823.758784-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   85 ++++++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 39 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-height-and-depth-consistently
+++ a/lib/maple_tree.c
@@ -211,14 +211,14 @@ static void ma_free_rcu(struct maple_nod
 	call_rcu(&node->rcu, mt_free_rcu);
 }
 
-static void mas_set_height(struct ma_state *mas)
+static void mt_set_height(struct maple_tree *mt, unsigned char height)
 {
-	unsigned int new_flags = mas->tree->ma_flags;
+	unsigned int new_flags = mt->ma_flags;
 
 	new_flags &= ~MT_FLAGS_HEIGHT_MASK;
-	MAS_BUG_ON(mas, mas->depth > MAPLE_HEIGHT_MAX);
-	new_flags |= mas->depth << MT_FLAGS_HEIGHT_OFFSET;
-	mas->tree->ma_flags = new_flags;
+	MT_BUG_ON(mt, height > MAPLE_HEIGHT_MAX);
+	new_flags |= height << MT_FLAGS_HEIGHT_OFFSET;
+	mt->ma_flags = new_flags;
 }
 
 static unsigned int mas_mt_height(struct ma_state *mas)
@@ -1371,7 +1371,7 @@ retry:
 		root = mas_root(mas);
 		/* Tree with nodes */
 		if (likely(xa_is_node(root))) {
-			mas->depth = 1;
+			mas->depth = 0;
 			mas->status = ma_active;
 			mas->node = mte_safe_root(root);
 			mas->offset = 0;
@@ -1712,9 +1712,10 @@ static inline void mas_adopt_children(st
  * node as dead.
  * @mas: the maple state with the new node
  * @old_enode: The old maple encoded node to replace.
+ * @new_height: if we are inserting a root node, update the height of the tree
  */
 static inline void mas_put_in_tree(struct ma_state *mas,
-		struct maple_enode *old_enode)
+		struct maple_enode *old_enode, char new_height)
 	__must_hold(mas->tree->ma_lock)
 {
 	unsigned char offset;
@@ -1723,7 +1724,7 @@ static inline void mas_put_in_tree(struc
 	if (mte_is_root(mas->node)) {
 		mas_mn(mas)->parent = ma_parent_ptr(mas_tree_parent(mas));
 		rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
-		mas_set_height(mas);
+		mt_set_height(mas->tree, new_height);
 	} else {
 
 		offset = mte_parent_slot(mas->node);
@@ -1741,12 +1742,13 @@ static inline void mas_put_in_tree(struc
  * the parent encoding to locate the maple node in the tree.
  * @mas: the ma_state with @mas->node pointing to the new node.
  * @old_enode: The old maple encoded node.
+ * @new_height: The new height of the tree as a result of the operation
  */
 static inline void mas_replace_node(struct ma_state *mas,
-		struct maple_enode *old_enode)
+		struct maple_enode *old_enode, unsigned char new_height)
 	__must_hold(mas->tree->ma_lock)
 {
-	mas_put_in_tree(mas, old_enode);
+	mas_put_in_tree(mas, old_enode, new_height);
 	mas_free(mas, old_enode);
 }
 
@@ -2536,10 +2538,11 @@ static inline void mas_topiary_node(stru
  *
  * @mas: The maple state pointing at the new data
  * @old_enode: The maple encoded node being replaced
+ * @new_height: The new height of the tree as a result of the operation
  *
  */
 static inline void mas_topiary_replace(struct ma_state *mas,
-		struct maple_enode *old_enode)
+		struct maple_enode *old_enode, unsigned char new_height)
 {
 	struct ma_state tmp[3], tmp_next[3];
 	MA_TOPIARY(subtrees, mas->tree);
@@ -2547,7 +2550,7 @@ static inline void mas_topiary_replace(s
 	int i, n;
 
 	/* Place data in tree & then mark node as old */
-	mas_put_in_tree(mas, old_enode);
+	mas_put_in_tree(mas, old_enode, new_height);
 
 	/* Update the parent pointers in the tree */
 	tmp[0] = *mas;
@@ -2631,14 +2634,15 @@ static inline void mas_topiary_replace(s
  * mas_wmb_replace() - Write memory barrier and replace
  * @mas: The maple state
  * @old_enode: The old maple encoded node that is being replaced.
+ * @new_height: The new height of the tree as a result of the operation
  *
  * Updates gap as necessary.
  */
 static inline void mas_wmb_replace(struct ma_state *mas,
-		struct maple_enode *old_enode)
+		struct maple_enode *old_enode, unsigned char new_height)
 {
 	/* Insert the new data in the tree */
-	mas_topiary_replace(mas, old_enode);
+	mas_topiary_replace(mas, old_enode, new_height);
 
 	if (mte_is_leaf(mas->node))
 		return;
@@ -2824,6 +2828,7 @@ static void mas_spanning_rebalance(struc
 {
 	unsigned char split, mid_split;
 	unsigned char slot = 0;
+	unsigned char new_height = 0; /* used if node is a new root */
 	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
 	struct maple_enode *old_enode;
 
@@ -2873,7 +2878,7 @@ static void mas_spanning_rebalance(struc
 		 */
 		memset(mast->bn, 0, sizeof(struct maple_big_node));
 		mast->bn->type = mte_node_type(left);
-		l_mas.depth++;
+		new_height++;
 
 		/* Root already stored in l->node. */
 		if (mas_is_root_limits(mast->l))
@@ -2897,8 +2902,10 @@ static void mas_spanning_rebalance(struc
 			continue;
 
 		/* May be a new root stored in mast->bn */
-		if (mas_is_root_limits(mast->orig_l))
+		if (mas_is_root_limits(mast->orig_l)) {
+			new_height++;
 			break;
+		}
 
 		mast_spanning_rebalance(mast);
 
@@ -2909,7 +2916,7 @@ static void mas_spanning_rebalance(struc
 
 	l_mas.node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
 				mte_node_type(mast->orig_l->node));
-	l_mas.depth++;
+
 	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, &l_mas, true);
 	mas_set_parent(mas, left, l_mas.node, slot);
 	if (middle)
@@ -2933,7 +2940,7 @@ new_root:
 	mas->min = l_mas.min;
 	mas->max = l_mas.max;
 	mas->offset = l_mas.offset;
-	mas_wmb_replace(mas, old_enode);
+	mas_wmb_replace(mas, old_enode, new_height);
 	mtree_range_walk(mas);
 	return;
 }
@@ -3009,6 +3016,7 @@ static inline void mas_destroy_rebalance
 	void __rcu **l_slots, **slots;
 	unsigned long *l_pivs, *pivs, gap;
 	bool in_rcu = mt_in_rcu(mas->tree);
+	unsigned char new_height = mas_mt_height(mas);
 
 	MA_STATE(l_mas, mas->tree, mas->index, mas->last);
 
@@ -3103,7 +3111,7 @@ done:
 	mas_ascend(mas);
 
 	if (in_rcu) {
-		mas_replace_node(mas, old_eparent);
+		mas_replace_node(mas, old_eparent, new_height);
 		mas_adopt_children(mas, mas->node);
 	}
 
@@ -3114,10 +3122,9 @@ done:
  * mas_split_final_node() - Split the final node in a subtree operation.
  * @mast: the maple subtree state
  * @mas: The maple state
- * @height: The height of the tree in case it's a new root.
  */
 static inline void mas_split_final_node(struct maple_subtree_state *mast,
-					struct ma_state *mas, int height)
+					struct ma_state *mas)
 {
 	struct maple_enode *ancestor;
 
@@ -3126,7 +3133,6 @@ static inline void mas_split_final_node(
 			mast->bn->type = maple_arange_64;
 		else
 			mast->bn->type = maple_range_64;
-		mas->depth = height;
 	}
 	/*
 	 * Only a single node is used here, could be root.
@@ -3214,7 +3220,6 @@ static inline void mast_split_data(struc
  * mas_push_data() - Instead of splitting a node, it is beneficial to push the
  * data to the right or left node if there is room.
  * @mas: The maple state
- * @height: The current height of the maple state
  * @mast: The maple subtree state
  * @left: Push left or not.
  *
@@ -3222,8 +3227,8 @@ static inline void mast_split_data(struc
  *
  * Return: True if pushed, false otherwise.
  */
-static inline bool mas_push_data(struct ma_state *mas, int height,
-				 struct maple_subtree_state *mast, bool left)
+static inline bool mas_push_data(struct ma_state *mas,
+				struct maple_subtree_state *mast, bool left)
 {
 	unsigned char slot_total = mast->bn->b_end;
 	unsigned char end, space, split;
@@ -3280,7 +3285,7 @@ static inline bool mas_push_data(struct
 
 	mast_split_data(mast, mas, split);
 	mast_fill_bnode(mast, mas, 2);
-	mas_split_final_node(mast, mas, height + 1);
+	mas_split_final_node(mast, mas);
 	return true;
 }
 
@@ -3293,6 +3298,7 @@ static void mas_split(struct ma_state *m
 {
 	struct maple_subtree_state mast;
 	int height = 0;
+	unsigned int orig_height = mas_mt_height(mas);
 	unsigned char mid_split, split = 0;
 	struct maple_enode *old;
 
@@ -3319,7 +3325,6 @@ static void mas_split(struct ma_state *m
 	MA_STATE(prev_r_mas, mas->tree, mas->index, mas->last);
 
 	trace_ma_op(__func__, mas);
-	mas->depth = mas_mt_height(mas);
 
 	mast.l = &l_mas;
 	mast.r = &r_mas;
@@ -3327,9 +3332,9 @@ static void mas_split(struct ma_state *m
 	mast.orig_r = &prev_r_mas;
 	mast.bn = b_node;
 
-	while (height++ <= mas->depth) {
+	while (height++ <= orig_height) {
 		if (mt_slots[b_node->type] > b_node->b_end) {
-			mas_split_final_node(&mast, mas, height);
+			mas_split_final_node(&mast, mas);
 			break;
 		}
 
@@ -3344,11 +3349,15 @@ static void mas_split(struct ma_state *m
 		 * is a significant savings.
 		 */
 		/* Try to push left. */
-		if (mas_push_data(mas, height, &mast, true))
+		if (mas_push_data(mas, &mast, true)) {
+			height++;
 			break;
+		}
 		/* Try to push right. */
-		if (mas_push_data(mas, height, &mast, false))
+		if (mas_push_data(mas, &mast, false)) {
+			height++;
 			break;
+		}
 
 		split = mab_calc_split(mas, b_node, &mid_split);
 		mast_split_data(&mast, mas, split);
@@ -3365,7 +3374,7 @@ static void mas_split(struct ma_state *m
 	/* Set the original node as dead */
 	old = mas->node;
 	mas->node = l_mas.node;
-	mas_wmb_replace(mas, old);
+	mas_wmb_replace(mas, old, height);
 	mtree_range_walk(mas);
 	return;
 }
@@ -3424,8 +3433,7 @@ static inline void mas_root_expand(struc
 	if (mas->last != ULONG_MAX)
 		pivots[++slot] = ULONG_MAX;
 
-	mas->depth = 1;
-	mas_set_height(mas);
+	mt_set_height(mas->tree, 1);
 	ma_set_meta(node, maple_leaf_64, 0, slot);
 	/* swap the new root into the tree */
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
@@ -3669,8 +3677,7 @@ static inline void mas_new_root(struct m
 	WARN_ON_ONCE(mas->index || mas->last != ULONG_MAX);
 
 	if (!entry) {
-		mas->depth = 0;
-		mas_set_height(mas);
+		mt_set_height(mas->tree, 0);
 		rcu_assign_pointer(mas->tree->ma_root, entry);
 		mas->status = ma_start;
 		goto done;
@@ -3684,8 +3691,7 @@ static inline void mas_new_root(struct m
 	mas->status = ma_active;
 	rcu_assign_pointer(slots[0], entry);
 	pivots[0] = mas->last;
-	mas->depth = 1;
-	mas_set_height(mas);
+	mt_set_height(mas->tree, 1);
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
 
 done:
@@ -3804,6 +3810,7 @@ static inline void mas_wr_node_store(str
 	struct maple_node reuse, *newnode;
 	unsigned char copy_size, node_pivots = mt_pivots[wr_mas->type];
 	bool in_rcu = mt_in_rcu(mas->tree);
+	unsigned char height = mas_mt_height(mas);
 
 	if (mas->last == wr_mas->end_piv)
 		offset_end++; /* don't copy this offset */
@@ -3860,7 +3867,7 @@ done:
 		struct maple_enode *old_enode = mas->node;
 
 		mas->node = mt_mk_node(newnode, wr_mas->type);
-		mas_replace_node(mas, old_enode);
+		mas_replace_node(mas, old_enode, height);
 	} else {
 		memcpy(wr_mas->node, newnode, sizeof(struct maple_node));
 	}
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-convert-mas_prealloc_calc-to-take-in-a-maple-write-state.patch
maple_tree-use-height-and-depth-consistently.patch
maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch
maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch
maple_tree-add-sufficient-height.patch
maple_tree-reorder-mas-store_type-case-statements.patch

