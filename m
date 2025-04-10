Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E659D1FAC4A
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 20:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744317601; cv=none; b=pniiiM9ATUoYXfCyZF925BYMyGTq9xzfDvzL0s6ne12NzYctmqrL6928yFJlYavfmjz0O9YszE0tYrrK66H/JebDyewSKMYtrlKzUDyA2ELIeUbluHFKQlwQdlAAqBveXB6j7ML7NOnB4QgwHb+SR/h5TiZXrkgLilII5Q0jvzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744317601; c=relaxed/simple;
	bh=JqQtVrNbiIEwdHJbdR+Uxy1uX3P/WzqQCzO0nzqVbo8=;
	h=Date:To:From:Subject:Message-Id; b=F2LnjsGhDfwsdici3qNcotFS9Q6IWvX50VTaNHAhK8FXfmxl2JMf8DMn8H9T4nI495+r2RCMjjwnmoKThERGkZ4tq8DVRj7Mt7Rem8039g7DkU5MK2uvfSILpZ/0R4wt22RaxYE7EdxjBBNthfszuRxVgBPbdbOXqkhB3DZsOm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RGNNPqJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RGNNPqJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EA9C4CEE7;
	Thu, 10 Apr 2025 20:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744317600;
	bh=JqQtVrNbiIEwdHJbdR+Uxy1uX3P/WzqQCzO0nzqVbo8=;
	h=Date:To:From:Subject:From;
	b=RGNNPqJkyc/AUYT2FrYM0MFy7AyEwj5Igj4uJXn2mlZ4VHOtyONMoToz2CO72IYo0
	 BrI1wM9jc7MbDWOfY0BLcrfu3tNaugG5KoOz1Y3IDYURT244RxIoYqt9Lrgo8ZUR3E
	 k7NIScroMVPsUGMBc557JJVGaklJbnsQyczH2KxA=
Date: Thu, 10 Apr 2025 13:39:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-sufficient-height.patch added to mm-new branch
Message-Id: <20250410204000.43EA9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add sufficient height
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-add-sufficient-height.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-sufficient-height.patch

This patch will later appear in the mm-new branch at
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
Subject: maple_tree: add sufficient height
Date: Thu, 10 Apr 2025 19:14:45 +0000

In order to support rebalancing and spanning stores using less than the
worst case number of nodes, we need to track more than just the vacant
height.  Using only vacant height to reduce the worst case maple node
allocation count can lead to a shortcoming of nodes in the following
scenarios.

For rebalancing writes, when a leaf node becomes insufficient, it may be
combined with a sibling into a single node.  This means that the parent
node which has entries for this children will lose one entry.  If this
parent node was just meeting the minimum entries, losing one entry will
now cause this parent node to be insufficient.  This leads to a cascading
operation of rebalancing at different levels and can lead to more node
allocations than simply using vacant height can return.

For spanning writes, a similar situation occurs.  At the location at which
a spanning write is detected, the number of ancestor nodes may similarly
need to rebalanced into a smaller number of nodes and the same cascading
situation could occur.

To use less than the full height of the tree for the number of
allocations, we also need to track the height at which a non-leaf node
cannot become insufficient.  This means even if a rebalance occurs to a
child of this node, it currently has enough entries that it can lose one
without any further action.  This field is stored in the maple write state
as sufficient height.  In mas_prealloc_calc() when figuring out how many
nodes to allocate, we check if the vacant node is lower in the tree than a
sufficient node (has a larger value).  If it is, we cannot use the vacant
height and must use the difference in the height and sufficient height as
the basis for the number of nodes needed.

An off by one bug was also discovered in mast_overflow() where it is using
>= rather than >.  This caused extra iterations of the
mas_spanning_rebalance() loop and lead to unneeded allocations.  A test is
also added to check the number of allocations is correct.

Link: https://lkml.kernel.org/r/20250410191446.2474640-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h       |    4 +++-
 lib/maple_tree.c                 |   19 ++++++++++++++++---
 tools/testing/radix-tree/maple.c |   28 ++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 4 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-add-sufficient-height
+++ a/include/linux/maple_tree.h
@@ -464,6 +464,7 @@ struct ma_wr_state {
 	void *entry;			/* The entry to write */
 	void *content;			/* The existing entry that is being overwritten */
 	unsigned char vacant_height;	/* Height of lowest node with free space */
+	unsigned char sufficient_height;/* Height of lowest node with min sufficiency + 1 nodes */
 };
 
 #define mas_lock(mas)           spin_lock(&((mas)->tree->ma_lock))
@@ -499,7 +500,8 @@ struct ma_wr_state {
 		.mas = ma_state,					\
 		.content = NULL,					\
 		.entry = wr_entry,					\
-		.vacant_height = 0					\
+		.vacant_height = 0,					\
+		.sufficient_height = 0					\
 	}
 
 #define MA_TOPIARY(name, tree)						\
--- a/lib/maple_tree.c~maple_tree-add-sufficient-height
+++ a/lib/maple_tree.c
@@ -2741,7 +2741,7 @@ static inline bool mast_sufficient(struc
  */
 static inline bool mast_overflow(struct maple_subtree_state *mast)
 {
-	if (mast->bn->b_end >= mt_slot_count(mast->orig_l->node))
+	if (mast->bn->b_end > mt_slot_count(mast->orig_l->node))
 		return true;
 
 	return false;
@@ -3550,6 +3550,13 @@ static bool mas_wr_walk(struct ma_wr_sta
 		if (mas->end < mt_slots[wr_mas->type] - 1)
 			wr_mas->vacant_height = mas->depth + 1;
 
+		if (ma_is_root(mas_mn(mas))) {
+			/* root needs more than 2 entries to be sufficient + 1 */
+			if (mas->end > 2)
+				wr_mas->sufficient_height = 1;
+		} else if (mas->end > mt_min_slots[wr_mas->type] + 1)
+			wr_mas->sufficient_height = mas->depth + 1;
+
 		mas_wr_walk_traverse(wr_mas);
 	}
 
@@ -4185,13 +4192,19 @@ static inline int mas_prealloc_calc(stru
 			ret = 0;
 		break;
 	case wr_spanning_store:
-		WARN_ON_ONCE(ret != height * 3 + 1);
+		if (wr_mas->sufficient_height < wr_mas->vacant_height)
+			ret = (height - wr_mas->sufficient_height) * 3 + 1;
+		else
+			ret = delta * 3 + 1;
 		break;
 	case wr_split_store:
 		ret = delta * 2 + 1;
 		break;
 	case wr_rebalance:
-		ret = height * 2 + 1;
+		if (wr_mas->sufficient_height < wr_mas->vacant_height)
+			ret = (height - wr_mas->sufficient_height) * 2 + 1;
+		else
+			ret = delta * 2 + 1;
 		break;
 	case wr_node_store:
 		ret = mt_in_rcu(mas->tree) ? 1 : 0;
--- a/tools/testing/radix-tree/maple.c~maple_tree-add-sufficient-height
+++ a/tools/testing/radix-tree/maple.c
@@ -36326,6 +36326,30 @@ static inline void check_spanning_store_
 	mas_unlock(&mas);
 }
 
+/*
+ * Test to check the path of a spanning rebalance which results in
+ * a collapse where the rebalancing of the child node leads to
+ * insufficieny in the parent node.
+ */
+static void check_collapsing_rebalance(struct maple_tree *mt)
+{
+	int i = 0;
+	MA_STATE(mas, mt, ULONG_MAX, ULONG_MAX);
+
+	/* create a height 6 tree */
+	while (mt_height(mt) < 6) {
+		mtree_store_range(mt, i, i + 10, xa_mk_value(i), GFP_KERNEL);
+		i += 9;
+	}
+
+	/* delete all entries one at a time, starting from the right */
+	do {
+		mas_erase(&mas);
+	} while (mas_prev(&mas, 0) != NULL);
+
+	mtree_unlock(mt);
+}
+
 /* callback function used for check_nomem_writer_race() */
 static void writer2(void *maple_tree)
 {
@@ -36497,6 +36521,10 @@ void farmer_tests(void)
 	mtree_destroy(&tree);
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_collapsing_rebalance(&tree);
+	mtree_destroy(&tree);
+
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_null_expand(&tree);
 	mtree_destroy(&tree);
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-convert-mas_prealloc_calc-to-take-in-a-maple-write-state.patch
maple_tree-use-height-and-depth-consistently.patch
maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch
maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch
maple_tree-add-sufficient-height.patch
maple_tree-reorder-mas-store_type-case-statements.patch

