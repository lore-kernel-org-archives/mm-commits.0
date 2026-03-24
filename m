Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1042E06EA
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388485; cv=none; b=UQOIW+rrW2Bsgx3r6wvZkQk5l5/4DCBQPouYljJpiU0iNElndT/w7mn2rCBqORi8bL0kgxtUaXCDi4ssQBfgBkfn2C+zepfION74dgQd4HvAmJdT+msBpAVZnz3QcnwE7LamkUnIZx+8sIaMzaQmAR/djXF5wfDmWs4IkFTb450=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388485; c=relaxed/simple;
	bh=i7Remb7KgEMBXFxMxZ2u6Xf87cn8V15XydLvsLemapk=;
	h=Date:To:From:Subject:Message-Id; b=H8Xwr0L1EJblK5ju+V2yATdZjEuDCbaFee2gj4hBadhmaZyG6SEuuZiiWwb74JVw0TbtCFIL7oUQLCZm8SsJb1kZGeeuK0OyxxfyhYzSLJuLPJuSh7O6sK3yDPgefjS/rDqoTGV/kuoPNKV4PTTZQqOTKOTDf0jHITQ2vt3CZKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FcGwoffn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FcGwoffn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDDDC19424;
	Tue, 24 Mar 2026 21:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388485;
	bh=i7Remb7KgEMBXFxMxZ2u6Xf87cn8V15XydLvsLemapk=;
	h=Date:To:From:Subject:From;
	b=FcGwoffnm1WrgJEohVJbaQUTC8mxaqhIK0/X7vsQW7okwGSLFgOqXsVAk2/vZ93Mf
	 IL2ELWGx2W59C7jDY5uq8HBMz3bLgSbTMyYmutWc5ak+OBFAMv0LN+uzuGNtodrTCx
	 xwc7LXYgGxELZjhp5DE+cRD/K1LdHMvHfhTwmE0Y=
Date: Tue, 24 Mar 2026 14:41:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-move-mas_spanning_rebalance-loop-to-function.patch removed from -mm tree
Message-Id: <20260324214125.8EDDDC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: move mas_spanning_rebalance loop to function
has been removed from the -mm tree.  Its filename was
     maple_tree-move-mas_spanning_rebalance-loop-to-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: move mas_spanning_rebalance loop to function
Date: Fri, 30 Jan 2026 15:59:07 -0500

Move the loop over the tree levels to its own function.

No intended functional changes.

Link: https://lkml.kernel.org/r/20260130205935.2559335-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |  108 ++++++++++++++++++++++++---------------------
 1 file changed, 58 insertions(+), 50 deletions(-)

--- a/lib/maple_tree.c~maple_tree-move-mas_spanning_rebalance-loop-to-function
+++ a/lib/maple_tree.c
@@ -2595,49 +2595,16 @@ dead_node:
 	return NULL;
 }
 
-/*
- * mas_spanning_rebalance() - Rebalance across two nodes which may not be peers.
- * @mas: The starting maple state
- * @mast: The maple_subtree_state, keeps track of 4 maple states.
- * @count: The estimated count of iterations needed.
- *
- * Follow the tree upwards from @l_mas and @r_mas for @count, or until the root
- * is hit.  First @b_node is split into two entries which are inserted into the
- * next iteration of the loop.  @b_node is returned populated with the final
- * iteration. @mas is used to obtain allocations.  orig_l_mas keeps track of the
- * nodes that will remain active by using orig_l_mas->index and orig_l_mas->last
- * to account of what has been copied into the new sub-tree.  The update of
- * orig_l_mas->last is used in mas_consume to find the slots that will need to
- * be either freed or destroyed.  orig_l_mas->depth keeps track of the height of
- * the new sub-tree in case the sub-tree becomes the full tree.
- */
-static void mas_spanning_rebalance(struct ma_state *mas,
+static void mas_spanning_rebalance_loop(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char count)
 {
+
 	unsigned char split, mid_split;
 	unsigned char slot = 0;
 	unsigned char new_height = 0; /* used if node is a new root */
 	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
 	struct maple_enode *old_enode;
 
-	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
-	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
-
-	/*
-	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
-	 * Rebalancing is done by use of the ``struct maple_topiary``.
-	 */
-	mast->l = &l_mas;
-	mast->m = &m_mas;
-	mast->r = &r_mas;
-	l_mas.status = r_mas.status = m_mas.status = ma_none;
-
-	/* Check if this is not root and has sufficient data.  */
-	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
-		mast_spanning_rebalance(mast);
-
 	/*
 	 * Each level of the tree is examined and balanced, pushing data to the left or
 	 * right, or rebalancing against left or right nodes is employed to avoid
@@ -2672,10 +2639,10 @@ static void mas_spanning_rebalance(struc
 
 		mast_ascend(mast);
 		mast_combine_cp_left(mast);
-		l_mas.offset = mast->bn->b_end;
-		mab_set_b_end(mast->bn, &l_mas, left);
-		mab_set_b_end(mast->bn, &m_mas, middle);
-		mab_set_b_end(mast->bn, &r_mas, right);
+		mast->l->offset = mast->bn->b_end;
+		mab_set_b_end(mast->bn, mast->l, left);
+		mab_set_b_end(mast->bn, mast->m, middle);
+		mab_set_b_end(mast->bn, mast->r, right);
 
 		/* Copy anything necessary out of the right node. */
 		mast_combine_cp_right(mast);
@@ -2708,17 +2675,17 @@ static void mas_spanning_rebalance(struc
 			count++;
 	}
 
-	l_mas.node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
+	mast->l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
 				mte_node_type(mast->orig_l->node));
 
-	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, &l_mas, true);
+	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, mast->l, true);
 	new_height++;
-	mas_set_parent(mas, left, l_mas.node, slot);
+	mas_set_parent(mas, left, mast->l->node, slot);
 	if (middle)
-		mas_set_parent(mas, middle, l_mas.node, ++slot);
+		mas_set_parent(mas, middle, mast->l->node, ++slot);
 
 	if (right)
-		mas_set_parent(mas, right, l_mas.node, ++slot);
+		mas_set_parent(mas, right, mast->l->node, ++slot);
 
 	if (mas_is_root_limits(mast->l)) {
 new_root:
@@ -2726,21 +2693,62 @@ new_root:
 		while (!mte_is_root(mast->orig_l->node))
 			mast_ascend(mast);
 	} else {
-		mas_mn(&l_mas)->parent = mas_mn(mast->orig_l)->parent;
+		mas_mn(mast->l)->parent = mas_mn(mast->orig_l)->parent;
 	}
 
 	old_enode = mast->orig_l->node;
-	mas->depth = l_mas.depth;
-	mas->node = l_mas.node;
-	mas->min = l_mas.min;
-	mas->max = l_mas.max;
-	mas->offset = l_mas.offset;
+	mas->depth = mast->l->depth;
+	mas->node = mast->l->node;
+	mas->min = mast->l->min;
+	mas->max = mast->l->max;
+	mas->offset = mast->l->offset;
 	mas_wmb_replace(mas, old_enode, new_height);
 	mtree_range_walk(mas);
 	return;
 }
 
 /*
+ * mas_spanning_rebalance() - Rebalance across two nodes which may not be peers.
+ * @mas: The starting maple state
+ * @mast: The maple_subtree_state, keeps track of 4 maple states.
+ * @count: The estimated count of iterations needed.
+ *
+ * Follow the tree upwards from @l_mas and @r_mas for @count, or until the root
+ * is hit.  First @b_node is split into two entries which are inserted into the
+ * next iteration of the loop.  @b_node is returned populated with the final
+ * iteration. @mas is used to obtain allocations.  orig_l_mas keeps track of the
+ * nodes that will remain active by using orig_l_mas->index and orig_l_mas->last
+ * to account of what has been copied into the new sub-tree.  The update of
+ * orig_l_mas->last is used in mas_consume to find the slots that will need to
+ * be either freed or destroyed.  orig_l_mas->depth keeps track of the height of
+ * the new sub-tree in case the sub-tree becomes the full tree.
+ */
+static void mas_spanning_rebalance(struct ma_state *mas,
+		struct maple_subtree_state *mast, unsigned char count)
+{
+
+	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
+	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
+
+	/*
+	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
+	 * Rebalancing is done by use of the ``struct maple_topiary``.
+	 */
+	mast->l = &l_mas;
+	mast->m = &m_mas;
+	mast->r = &r_mas;
+	l_mas.status = r_mas.status = m_mas.status = ma_none;
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
+		mast_spanning_rebalance(mast);
+
+	mas_spanning_rebalance_loop(mas, mast, count);
+}
+
+/*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
  * @b_node: The big maple node.
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


