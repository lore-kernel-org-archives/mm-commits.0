Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35151C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011119; cv=none; b=JnAX6jc7CX9hjXMG85kYt6juTtJbSnAW4fISWPR9t+WOhHYAwThd/u5qJUAP/gSE5zU2M15t0/hVlS6UkhmJ3dBzkgtURfK8wAChzRd8wIwOIzIW+wgP5bs3AYOii3exfGOeR6GRh5iENngONoDfq6fAe+DnVxqy/YYfVJDeJOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011119; c=relaxed/simple;
	bh=df0zlOoLYPtZN1Hpsegx+iwPQTSjW/0sycg5sozxW/c=;
	h=Date:To:From:Subject:Message-Id; b=IYxVM5itE89oEt9Q3zxBIqM5jvLsN4Ceto+ELQ9Ny12+3z4OBPmioI+Q1bVtjCnxvGghOY7m4qmYUTYj+c7YS3lo2//HZIqom2V2Bhp2gi+mzlXPWfhpogPIwD7T0LjCPX8n+IEtEnH/X+QfW0nxOSaSbphJyDfAi3D51j4uw90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rMVfGsdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rMVfGsdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B748C4CEE4;
	Mon, 12 May 2025 00:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011119;
	bh=df0zlOoLYPtZN1Hpsegx+iwPQTSjW/0sycg5sozxW/c=;
	h=Date:To:From:Subject:From;
	b=rMVfGsdha8wZwmC4B3Y7iQ9lZCt9jhpXAQfQ8EVdn8bzBu52W39+O1qC/B4Kaxgtq
	 1EopjuYQbtrHP9FN7hnscOLXUdaNHo4oHxE+91A46ZPOXdR12JHRl7HsXuFa8XitjR
	 XwekfMwP/PsDq3yfnkmhbsbVB1AoFIrhWvi5mzrU=
Date: Sun, 11 May 2025 17:51:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch removed from -mm tree
Message-Id: <20250512005159.0B748C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use vacant nodes to reduce worst case allocations
has been removed from the -mm tree.  Its filename was
     maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: use vacant nodes to reduce worst case allocations
Date: Thu, 10 Apr 2025 19:14:43 +0000

In order to determine the store type for a maple tree operation, a walk of
the tree is done through mas_wr_walk().  This function descends the tree
until a spanning write is detected or we reach a leaf node.  While
descending, keep track of the height at which we encounter a node with
available space.  This is done by checking if mas->end is less than the
number of slots a given node type can fit.

Now that the height of the vacant node is tracked, we can use the
difference between the height of the tree and the height of the vacant
node to know how many levels we will have to propagate creating new nodes.
Update mas_prealloc_calc() to consider the vacant height and reduce the
number of worst-case allocations.

Rebalancing and spanning stores are not supported and fall back to using
the full height of the tree for allocations.

Update preallocation testing assertions to take into account vacant
height.

Link: https://lkml.kernel.org/r/20250410191446.2474640-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h       |    2 
 lib/maple_tree.c                 |   13 +++-
 tools/testing/radix-tree/maple.c |   79 ++++++++++++++++++++++++++---
 3 files changed, 82 insertions(+), 12 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations
+++ a/include/linux/maple_tree.h
@@ -463,6 +463,7 @@ struct ma_wr_state {
 	void __rcu **slots;		/* mas->node->slots pointer */
 	void *entry;			/* The entry to write */
 	void *content;			/* The existing entry that is being overwritten */
+	unsigned char vacant_height;	/* Height of lowest node with free space */
 };
 
 #define mas_lock(mas)           spin_lock(&((mas)->tree->ma_lock))
@@ -498,6 +499,7 @@ struct ma_wr_state {
 		.mas = ma_state,					\
 		.content = NULL,					\
 		.entry = wr_entry,					\
+		.vacant_height = 0					\
 	}
 
 #define MA_TOPIARY(name, tree)						\
--- a/lib/maple_tree.c~maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations
+++ a/lib/maple_tree.c
@@ -3537,6 +3537,9 @@ static bool mas_wr_walk(struct ma_wr_sta
 		if (ma_is_leaf(wr_mas->type))
 			return true;
 
+		if (mas->end < mt_slots[wr_mas->type] - 1)
+			wr_mas->vacant_height = mas->depth + 1;
+
 		mas_wr_walk_traverse(wr_mas);
 	}
 
@@ -4152,7 +4155,9 @@ set_content:
 static inline int mas_prealloc_calc(struct ma_wr_state *wr_mas, void *entry)
 {
 	struct ma_state *mas = wr_mas->mas;
-	int ret = mas_mt_height(mas) * 3 + 1;
+	unsigned char height = mas_mt_height(mas);
+	int ret = height * 3 + 1;
+	unsigned char delta = height - wr_mas->vacant_height;
 
 	switch (mas->store_type) {
 	case wr_invalid:
@@ -4170,13 +4175,13 @@ static inline int mas_prealloc_calc(stru
 			ret = 0;
 		break;
 	case wr_spanning_store:
-		ret =  mas_mt_height(mas) * 3 + 1;
+		WARN_ON_ONCE(ret != height * 3 + 1);
 		break;
 	case wr_split_store:
-		ret =  mas_mt_height(mas) * 2 + 1;
+		ret = delta * 2 + 1;
 		break;
 	case wr_rebalance:
-		ret =  mas_mt_height(mas) * 2 - 1;
+		ret = height * 2 + 1;
 		break;
 	case wr_node_store:
 		ret = mt_in_rcu(mas->tree) ? 1 : 0;
--- a/tools/testing/radix-tree/maple.c~maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations
+++ a/tools/testing/radix-tree/maple.c
@@ -35475,15 +35475,65 @@ static void check_dfs_preorder(struct ma
 }
 /* End of depth first search tests */
 
+/* get height of the lowest non-leaf node with free space */
+static unsigned char get_vacant_height(struct ma_wr_state *wr_mas, void *entry)
+{
+	struct ma_state *mas = wr_mas->mas;
+	char vacant_height = 0;
+	enum maple_type type;
+	unsigned long *pivots;
+	unsigned long min = 0;
+	unsigned long max = ULONG_MAX;
+	unsigned char offset;
+
+	/* start traversal */
+	mas_reset(mas);
+	mas_start(mas);
+	if (!xa_is_node(mas_root(mas)))
+		return 0;
+
+	type = mte_node_type(mas->node);
+	wr_mas->type = type;
+	while (!ma_is_leaf(type)) {
+		mas_node_walk(mas, mte_to_node(mas->node), type, &min, &max);
+		offset = mas->offset;
+		mas->end = mas_data_end(mas);
+		pivots = ma_pivots(mte_to_node(mas->node), type);
+
+		if (pivots) {
+			if (offset)
+				min = pivots[mas->offset - 1];
+			if (offset < mas->end)
+				max = pivots[mas->offset];
+		}
+		wr_mas->r_max = offset < mas->end ? pivots[offset] : mas->max;
+
+		/* detect spanning write */
+		if (mas_is_span_wr(wr_mas))
+			break;
+
+		if (mas->end < mt_slot_count(mas->node) - 1)
+			vacant_height = mas->depth + 1;
+
+		mas_descend(mas);
+		type = mte_node_type(mas->node);
+		mas->depth++;
+	}
+
+	return vacant_height;
+}
+
 /* Preallocation testing */
 static noinline void __init check_prealloc(struct maple_tree *mt)
 {
 	unsigned long i, max = 100;
 	unsigned long allocated;
 	unsigned char height;
+	unsigned char vacant_height;
 	struct maple_node *mn;
 	void *ptr = check_prealloc;
 	MA_STATE(mas, mt, 10, 20);
+	MA_WR_STATE(wr_mas, &mas, ptr);
 
 	mt_set_non_kernel(1000);
 	for (i = 0; i <= max; i++)
@@ -35494,8 +35544,9 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
+	vacant_height = get_vacant_height(&wr_mas, ptr);
 	MT_BUG_ON(mt, allocated == 0);
-	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	MT_BUG_ON(mt, allocated != 1 + (height - vacant_height) * 3);
 	mas_destroy(&mas);
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
@@ -35503,8 +35554,9 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
+	vacant_height = get_vacant_height(&wr_mas, ptr);
 	MT_BUG_ON(mt, allocated == 0);
-	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	MT_BUG_ON(mt, allocated != 1 + (height - vacant_height) * 3);
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	mas_destroy(&mas);
 	allocated = mas_allocated(&mas);
@@ -35514,7 +35566,8 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	vacant_height = get_vacant_height(&wr_mas, ptr);
+	MT_BUG_ON(mt, allocated != 1 + (height - vacant_height) * 3);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
 	mn->parent = ma_parent_ptr(mn);
@@ -35527,7 +35580,8 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	vacant_height = get_vacant_height(&wr_mas, ptr);
+	MT_BUG_ON(mt, allocated != 1 + (height - vacant_height) * 3);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
@@ -35540,7 +35594,8 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	vacant_height = get_vacant_height(&wr_mas, ptr);
+	MT_BUG_ON(mt, allocated != 1 + (height - vacant_height) * 3);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
 	mas_push_node(&mas, mn);
@@ -35553,7 +35608,8 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	vacant_height = get_vacant_height(&wr_mas, ptr);
+	MT_BUG_ON(mt, allocated != 1 + (height - vacant_height) * 3);
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 
@@ -35578,7 +35634,8 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated != 1 + height * 2);
+	vacant_height = get_vacant_height(&wr_mas, ptr);
+	MT_BUG_ON(mt, allocated != 1 + (height - vacant_height) * 2);
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mt_set_non_kernel(1);
@@ -35595,8 +35652,14 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
+	vacant_height = get_vacant_height(&wr_mas, ptr);
 	MT_BUG_ON(mt, allocated == 0);
-	MT_BUG_ON(mt, allocated != 1 + height * 3);
+	/*
+	 * vacant height cannot be used to compute the number of nodes needed
+	 * as the root contains two entries which means it is on the verge of
+	 * insufficiency. The worst case full height of the tree is needed.
+	 */
+	MT_BUG_ON(mt, allocated != height * 3 + 1);
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mas_set_range(&mas, 0, 200);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


