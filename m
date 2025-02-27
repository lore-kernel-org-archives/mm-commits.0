Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A663423E34A
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 22:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695008; cv=none; b=DulczloOer8DSWLA070p8LzUAPEnXYltvV3S+451jMAOphwjE9W+mRtUM7pZCGuAXzu3/1nRimvIimJKK1NC8D3j7/lCpocKRgKe3t7KErvtw+SfjeknIsx/kzrn1QjZ72tNztvS5jdd8Jc5gsdMULsGQM1e5JL6HrOmO6e9Glw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695008; c=relaxed/simple;
	bh=F0JIp5kldbdnDVbcQxcG3XX/D9yeSB9zzHGqizLilXw=;
	h=Date:To:From:Subject:Message-Id; b=tOuvJ7y+0r/93Dk6HLRlRZ6jGNU6DPTnCrxNVCjrazLxvfyrWX/DiH6kX+gUOaXcP1/1CcBkWCW3KV9NbvqxRYUP7unwN87SUy9GrJGRQqY6FQUwUDBOC/2w7XwfoCIeWFSFfsJjfwygdWOY4GQUG3E5inuvkyhXK6KhMBa/LKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n8JbJ8Qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n8JbJ8Qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108A0C4CEDD;
	Thu, 27 Feb 2025 22:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740695008;
	bh=F0JIp5kldbdnDVbcQxcG3XX/D9yeSB9zzHGqizLilXw=;
	h=Date:To:From:Subject:From;
	b=n8JbJ8Qun5WK/6ozkdv+f5CxcKCVHxzkb5q4Vk4vnBL7TQ+RKRqGo8uU9mm9Wthxx
	 fSVYTI/YtcLmZ0fvuM3atI5WJw+VGObSbF6xhjalbESMC/C5UXk4c19obrSc3XX/QI
	 LCW7J3Ynk4b4FHWH8IWeo6hRWWzhle6nfNYgqj34=
Date: Thu, 27 Feb 2025 14:23:27 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch added to mm-unstable branch
Message-Id: <20250227222328.108A0C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: use vacant nodes to reduce worst case allocations
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch

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
Subject: maple_tree: use vacant nodes to reduce worst case allocations
Date: Thu, 27 Feb 2025 20:48:20 +0000

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

Link: https://lkml.kernel.org/r/20250227204823.758784-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha <sidhartha.kumar@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
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
+	unsigned char vacant_height;	/* Depth of lowest node with free space */
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
@@ -3540,6 +3540,9 @@ static bool mas_wr_walk(struct ma_wr_sta
 		if (ma_is_leaf(wr_mas->type))
 			return true;
 
+		if (mas->end < mt_slots[wr_mas->type] - 1)
+			wr_mas->vacant_height = mas->depth + 1;
+
 		mas_wr_walk_traverse(wr_mas);
 	}
 
@@ -4155,7 +4158,9 @@ set_content:
 static inline int mas_prealloc_calc(struct ma_wr_state *wr_mas, void *entry)
 {
 	struct ma_state *mas = wr_mas->mas;
-	int ret = mas_mt_height(mas) * 3 + 1;
+	unsigned char height = mas_mt_height(mas);
+	int ret = height * 3 + 1;
+	unsigned char delta = height - wr_mas->vacant_height;
 
 	switch (mas->store_type) {
 	case wr_invalid:
@@ -4173,13 +4178,13 @@ static inline int mas_prealloc_calc(stru
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

maple_tree-convert-mas_prealloc_calc-to-take-in-a-maple-write-state.patch
maple_tree-use-height-and-depth-consistently.patch
maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch
maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch
maple_tree-add-sufficient-height.patch
maple_tree-reorder-mas-store_type-case-statements.patch

