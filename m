Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50764272924
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 22:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695011; cv=none; b=JKDgA1nvFBa3r4IieW/iQnzlndJbYQ7gW2Ruzzh4wvXIGPXO4Srubwp5wFlI8Wc4rPvVd54RNkcTT0zMTX21Hgta34MMSND+6PGi5yTgJURW+CYcQAjhpDixBsfE516bRZ9RIv5GBvfWSmtCW7Nm6osK2doFSYEzdo0Rpvn9lR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695011; c=relaxed/simple;
	bh=A0iFWtrBCL8vWKScYxVkBYYOfyKeCVAE08vCLAWB4Rg=;
	h=Date:To:From:Subject:Message-Id; b=uUDZtLLmKDJ7L4fjWpL3QETtk4hAreqDp4FR64NERvX6v6C5PDebSiaVTApt8wx6RLIIuk5M6H3EpocMb3kIXhW33ThUjAJaf+nYme/Bp4tlMQDP7AFBFp6Rbjxvm1Gr7jEx136d6hZct7PvAKXCEziuUZ9ZPbIU/G4doU8+GZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jbjPl3RY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jbjPl3RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26D7C4CEDD;
	Thu, 27 Feb 2025 22:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740695010;
	bh=A0iFWtrBCL8vWKScYxVkBYYOfyKeCVAE08vCLAWB4Rg=;
	h=Date:To:From:Subject:From;
	b=jbjPl3RY501t2eA6PiAu/LgpGnC94yk4KXL1Ee8UjWDTKDF83OUu4Pue6+w1B7GoX
	 GopCK/i2f+PimCwIVi35WjjghvxgDafaWnzIWKgZSY++vGvjaTUcyVFW/FTvSRHcPk
	 d4TmHEH23M6Ui1nYSJwYy0Dr0wFUBUXvd8TExVfM=
Date: Thu, 27 Feb 2025 14:23:30 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-sufficient-height.patch added to mm-unstable branch
Message-Id: <20250227222330.C26D7C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add sufficient height
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-sufficient-height.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-sufficient-height.patch

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
Subject: maple_tree: add sufficient height
Date: Thu, 27 Feb 2025 20:48:22 +0000

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
nodes to allocate, we check if the the vacant node is lower in the tree
than a sufficient node (has a larger value).  If it is, we cannot use the
vacant height and must use the difference in the height and sufficient
height as the basis for the number of nodes needed.

Link: https://lkml.kernel.org/r/20250227204823.758784-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h       |    4 +++-
 lib/maple_tree.c                 |   17 +++++++++++++++--
 tools/testing/radix-tree/maple.c |   28 ++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 3 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-add-sufficient-height
+++ a/include/linux/maple_tree.h
@@ -464,6 +464,7 @@ struct ma_wr_state {
 	void *entry;			/* The entry to write */
 	void *content;			/* The existing entry that is being overwritten */
 	unsigned char vacant_height;	/* Depth of lowest node with free space */
+	unsigned char sufficient_height;/* Depth of lowest node with min sufficiency + 1 nodes */
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
@@ -3556,6 +3556,13 @@ static bool mas_wr_walk(struct ma_wr_sta
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
 
@@ -4191,13 +4198,19 @@ static inline int mas_prealloc_calc(stru
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
@@ -36311,6 +36311,30 @@ static noinline void __init check_mtree_
 
 extern void test_kmem_cache_bulk(void);
 
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
+	/* create a height 4 tree */
+	while (mt_height(mt) < 4) {
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
@@ -36478,6 +36502,10 @@ void farmer_tests(void)
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

