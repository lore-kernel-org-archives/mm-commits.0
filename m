Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F353CC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011122; cv=none; b=MmggvH9SW0MxXBSWYqBBpi4UDn1Qy2pD0gW99pODG7uxi4NPysPGi7pMmA1TFajhn7JgMk28v4Kp12OzJBLR/lGoA9jKA0NtokpULqwoh9NlJqnNwSmCzB0JZEy8cTLUK1fhqzZnhmaZ39eWD5dGMDyRHj3OO55GfrNipywubug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011122; c=relaxed/simple;
	bh=q/izZKwkFCbe1YgwWAuQwHgj92WumqMBwqlR19IB84Q=;
	h=Date:To:From:Subject:Message-Id; b=GqUYuGAWkHqiiO3VzfsJw/XGQIUTrU3cyVdmh98QmODtEDPX1hqD5SSIdqgYGcp8F9AP6jFsQlSGtbVOYv+qqmmEM+BiZFxEtc786UGTPHpSnEzs9t4WXfChEgg6NirSyQkQttb8w4/Rif51TpC/z9rjd1p8/GK6hD5pMcMqNUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ORcmTlfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ORcmTlfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A7CC4CEE4;
	Mon, 12 May 2025 00:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011121;
	bh=q/izZKwkFCbe1YgwWAuQwHgj92WumqMBwqlR19IB84Q=;
	h=Date:To:From:Subject:From;
	b=ORcmTlfIFhfcuaR20jTlaT71gfBi5UwMdCrNndxULPUklvufAFr8s5vWlqKPjrDFk
	 2nR9Dm9vyU5TylkW1ebfHRn+KOcvbiZjFjXigzj1ugysN3yut3jwWrHmtYOHiW8czU
	 QIUQOexdlA+/eG6T/HQ60+zkALbnebVF0TeLZoVQ=
Date: Sun, 11 May 2025 17:52:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-sufficient-height.patch removed from -mm tree
Message-Id: <20250512005201.C9A7CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add sufficient height
has been removed from the -mm tree.  Its filename was
     maple_tree-add-sufficient-height.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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


