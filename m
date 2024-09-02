Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0442D057
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247827; cv=none; b=G5ZUkHnhJGNpMCFSP2PuKk17Bh75h9BqF9x8MKma5JhPJwwda0TbYzBy48WYk6Mzi6LZYcEPPeWMK55KqXf4AKB2yyRjwX6CtuWWTc+nhByr9iOOxJJP4Y5uCO0Gh3l7VdGqNfJHp0YEgQGj4sSd2rKw072r6mLT0IeBseWMWjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247827; c=relaxed/simple;
	bh=YmjokzaaeiaN12YYUjFfOl2327EbdOK7Gy3QgNlw77Y=;
	h=Date:To:From:Subject:Message-Id; b=KyAM/oMAGN1W0Jld664p2FpA8lhOW/A5RYOVRloCQIK6a7ZsYTQFuO7Lenc3de0kcguEKz7CiclM9aPyteCnnmmDjWeNvZgt9JTDK0MiPWc5I2+NAre/e7kCOQVOaJc/Wq1ea1vHTSGfZNqZ5IwrCyPyCLumZYIz7rP50CsBQ9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y5cJ45FN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y5cJ45FN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20B0C4CEC2;
	Mon,  2 Sep 2024 03:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247827;
	bh=YmjokzaaeiaN12YYUjFfOl2327EbdOK7Gy3QgNlw77Y=;
	h=Date:To:From:Subject:From;
	b=Y5cJ45FNXv02F54cTIP/5sNh1qSWmKsC761jItBAa33rvtlzVeQ2+XYTfRcYEW5lD
	 qSoVH1ASQ3osFbtVWQHlqJuiqaWZMJGF1zdrMi1w9JSfcj4hIT472hIUdu/xm29vrS
	 YUkeggr/cs8UdRD4YKn5X7rj7HDN0ls5UPweAARo=
Date: Sun, 01 Sep 2024 20:30:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-introduce-mas_wr_store_type.patch removed from -mm tree
Message-Id: <20240902033027.B20B0C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: introduce mas_wr_store_type()
has been removed from the -mm tree.  Its filename was
     maple_tree-introduce-mas_wr_store_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: introduce mas_wr_store_type()
Date: Wed, 14 Aug 2024 12:19:31 -0400

Introduce mas_wr_store_type() which will set the correct store type based
on a walk of the tree.  In mas_wr_node_store() the <= min_slots condition
is changed to < as if new_end is = to mt_min_slots then there is not
enough room.

mas_prealloc_calc() is also introduced to abstract the calculation used to
determine the number of nodes needed for a store operation.

In this change a call to mas_reset() is removed in the error case of
mas_prealloc().  This is only needed in the MA_STATE_REBALANCE case of
mas_destroy().  We can move the call to mas_reset() directly to
mas_destroy().

Also, add a test case to validate the order that we check the store type
in is correct.  This test models a vma expanding and then shrinking which
is part of the boot process.

Link: https://lkml.kernel.org/r/20240814161944.55347-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |  217 ++++++++++++++++++++---------
 tools/testing/radix-tree/maple.c |   36 ++++
 2 files changed, 193 insertions(+), 60 deletions(-)

--- a/lib/maple_tree.c~maple_tree-introduce-mas_wr_store_type
+++ a/lib/maple_tree.c
@@ -1372,9 +1372,9 @@ retry:
 			return NULL;
 		}
 
+		mas->node = NULL;
 		/* empty tree */
 		if (unlikely(!root)) {
-			mas->node = NULL;
 			mas->status = ma_none;
 			mas->offset = MAPLE_NODE_SLOTS;
 			return NULL;
@@ -3890,7 +3890,7 @@ static inline bool mas_wr_node_store(str
 	bool in_rcu = mt_in_rcu(mas->tree);
 
 	/* Check if there is enough data. The room is enough. */
-	if (!mte_is_root(mas->node) && (new_end <= mt_min_slots[wr_mas->type]) &&
+	if (!mte_is_root(mas->node) && (new_end < mt_min_slots[wr_mas->type]) &&
 	    !(mas->mas_flags & MA_STATE_BULK))
 		return false;
 
@@ -4276,6 +4276,146 @@ static inline void mas_wr_prealloc_setup
 }
 
 /**
+ * mas_prealloc_calc() - Calculate number of nodes needed for a
+ * given store oepration
+ * @mas: The maple state
+ * @entry: The entry to store into the tree
+ *
+ * Return: Number of nodes required for preallocation.
+ */
+static inline int mas_prealloc_calc(struct ma_state *mas, void *entry)
+{
+	int ret = mas_mt_height(mas) * 3 + 1;
+
+	switch (mas->store_type) {
+	case wr_invalid:
+		WARN_ON_ONCE(1);
+		break;
+	case wr_new_root:
+		ret = 1;
+		break;
+	case wr_store_root:
+		if (likely((mas->last != 0) || (mas->index != 0)))
+			ret = 1;
+		else if (((unsigned long) (entry) & 3) == 2)
+			ret = 1;
+		else
+			ret = 0;
+		break;
+	case wr_spanning_store:
+		ret =  mas_mt_height(mas) * 3 + 1;
+		break;
+	case wr_split_store:
+		ret =  mas_mt_height(mas) * 2 + 1;
+		break;
+	case wr_rebalance:
+		ret =  mas_mt_height(mas) * 2 - 1;
+		break;
+	case wr_node_store:
+		ret = mt_in_rcu(mas->tree) ? 1 : 0;
+		break;
+	case wr_append:
+	case wr_exact_fit:
+	case wr_slot_store:
+		ret = 0;
+	}
+
+	return ret;
+}
+
+/*
+ * mas_wr_store_type() - Set the store type for a given
+ * store operation.
+ * @wr_mas: The maple write state
+ */
+static inline void mas_wr_store_type(struct ma_wr_state *wr_mas)
+{
+	struct ma_state *mas = wr_mas->mas;
+	unsigned char new_end;
+
+	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas))) {
+		mas->store_type = wr_store_root;
+		return;
+	}
+
+	if (unlikely(!mas_wr_walk(wr_mas))) {
+		mas->store_type = wr_spanning_store;
+		return;
+	}
+
+	/* At this point, we are at the leaf node that needs to be altered. */
+	mas_wr_end_piv(wr_mas);
+	if (!wr_mas->entry)
+		mas_wr_extend_null(wr_mas);
+
+	new_end = mas_wr_new_end(wr_mas);
+	if ((wr_mas->r_min == mas->index) && (wr_mas->r_max == mas->last)) {
+		mas->store_type = wr_exact_fit;
+		return;
+	}
+
+	if (unlikely(!mas->index && mas->last == ULONG_MAX)) {
+		mas->store_type = wr_new_root;
+		return;
+	}
+
+	/* Potential spanning rebalance collapsing a node */
+	if (new_end < mt_min_slots[wr_mas->type]) {
+		if (!mte_is_root(mas->node)) {
+			mas->store_type = wr_rebalance;
+			return;
+		}
+		mas->store_type = wr_node_store;
+		return;
+	}
+
+	if (new_end >= mt_slots[wr_mas->type]) {
+		mas->store_type = wr_split_store;
+		return;
+	}
+
+	if (!mt_in_rcu(mas->tree) && (mas->offset == mas->end)) {
+		mas->store_type = wr_append;
+		return;
+	}
+
+	if ((new_end == mas->end) && (!mt_in_rcu(mas->tree) ||
+		(wr_mas->offset_end - mas->offset == 1))) {
+		mas->store_type = wr_slot_store;
+		return;
+	}
+
+	if (mte_is_root(mas->node) || (new_end >= mt_min_slots[wr_mas->type]) ||
+		(mas->mas_flags & MA_STATE_BULK)) {
+		mas->store_type = wr_node_store;
+		return;
+	}
+
+	mas->store_type = wr_invalid;
+	MAS_WARN_ON(mas, 1);
+}
+
+/**
+ * mas_wr_preallocate() - Preallocate enough nodes for a store operation
+ * @wr_mas: The maple write state
+ * @entry: The entry that will be stored
+ *
+ */
+static inline void mas_wr_preallocate(struct ma_wr_state *wr_mas, void *entry)
+{
+	struct ma_state *mas = wr_mas->mas;
+	int request;
+
+	mas_wr_prealloc_setup(wr_mas);
+	mas_wr_store_type(wr_mas);
+	request = mas_prealloc_calc(mas, entry);
+	if (!request)
+		return;
+
+	mas_node_count(mas, request);
+}
+
+/**
  * mas_insert() - Internal call to insert a value
  * @mas: The maple state
  * @entry: The entry to store
@@ -5508,69 +5648,25 @@ EXPORT_SYMBOL_GPL(mas_store_prealloc);
 int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
-	unsigned char node_size;
-	int request = 1;
-	int ret;
-
-
-	if (unlikely(!mas->index && mas->last == ULONG_MAX))
-		goto ask_now;
+	int ret = 0;
+	int request;
 
 	mas_wr_prealloc_setup(&wr_mas);
-	/* Root expand */
-	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
-		goto ask_now;
+	mas_wr_store_type(&wr_mas);
+	request = mas_prealloc_calc(mas, entry);
+	if (!request)
+		return ret;
 
-	if (unlikely(!mas_wr_walk(&wr_mas))) {
-		/* Spanning store, use worst case for now */
-		request = 1 + mas_mt_height(mas) * 3;
-		goto ask_now;
+	mas_node_count_gfp(mas, request, gfp);
+	if (mas_is_err(mas)) {
+		mas_set_alloc_req(mas, 0);
+		ret = xa_err(mas->node);
+		mas_destroy(mas);
+		mas_reset(mas);
+		return ret;
 	}
 
-	/* At this point, we are at the leaf node that needs to be altered. */
-	/* Exact fit, no nodes needed. */
-	if (wr_mas.r_min == mas->index && wr_mas.r_max == mas->last)
-		return 0;
-
-	mas_wr_end_piv(&wr_mas);
-	node_size = mas_wr_new_end(&wr_mas);
-
-	/* Slot store, does not require additional nodes */
-	if (node_size == mas->end) {
-		/* reuse node */
-		if (!mt_in_rcu(mas->tree))
-			return 0;
-		/* shifting boundary */
-		if (wr_mas.offset_end - mas->offset == 1)
-			return 0;
-	}
-
-	if (node_size >= mt_slots[wr_mas.type]) {
-		/* Split, worst case for now. */
-		request = 1 + mas_mt_height(mas) * 2;
-		goto ask_now;
-	}
-
-	/* New root needs a single node */
-	if (unlikely(mte_is_root(mas->node)))
-		goto ask_now;
-
-	/* Potential spanning rebalance collapsing a node, use worst-case */
-	if (node_size  - 1 <= mt_min_slots[wr_mas.type])
-		request = mas_mt_height(mas) * 2 - 1;
-
-	/* node store, slot store needs one node */
-ask_now:
-	mas_node_count_gfp(mas, request, gfp);
 	mas->mas_flags |= MA_STATE_PREALLOC;
-	if (likely(!mas_is_err(mas)))
-		return 0;
-
-	mas_set_alloc_req(mas, 0);
-	ret = xa_err(mas->node);
-	mas_reset(mas);
-	mas_destroy(mas);
-	mas_reset(mas);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mas_preallocate);
@@ -5596,7 +5692,8 @@ void mas_destroy(struct ma_state *mas)
 	 */
 	if (mas->mas_flags & MA_STATE_REBALANCE) {
 		unsigned char end;
-
+		if (mas_is_err(mas))
+			mas_reset(mas);
 		mas_start(mas);
 		mtree_range_walk(mas);
 		end = mas->end + 1;
--- a/tools/testing/radix-tree/maple.c~maple_tree-introduce-mas_wr_store_type
+++ a/tools/testing/radix-tree/maple.c
@@ -36283,6 +36283,38 @@ static void check_nomem_writer_race(stru
 	mtree_unlock(mt);
 }
 
+ /* test to simulate expanding a vma from [0x7fffffffe000, 0x7ffffffff000)
+  * to [0x7ffde4ca1000, 0x7ffffffff000) and then shrinking the vma to
+  * [0x7ffde4ca1000, 0x7ffde4ca2000)
+  */
+static inline int check_vma_modification(struct maple_tree *mt)
+{
+	MA_STATE(mas, mt, 0, 0);
+
+	mtree_lock(mt);
+	/* vma with old start and old end */
+	__mas_set_range(&mas, 0x7fffffffe000, 0x7ffffffff000 - 1);
+	mas_preallocate(&mas, xa_mk_value(1), GFP_KERNEL);
+	mas_store_prealloc(&mas, xa_mk_value(1));
+
+	/* next write occurs partly in previous range [0, 0x7fffffffe000)*/
+	mas_prev_range(&mas, 0);
+	/* expand vma to {0x7ffde4ca1000, 0x7ffffffff000) */
+	__mas_set_range(&mas, 0x7ffde4ca1000, 0x7ffffffff000 - 1);
+	mas_preallocate(&mas, xa_mk_value(1), GFP_KERNEL);
+	mas_store_prealloc(&mas, xa_mk_value(1));
+
+	/* shrink vma to [0x7ffde4ca1000, 7ffde4ca2000) */
+	__mas_set_range(&mas, 0x7ffde4ca2000, 0x7ffffffff000 - 1);
+	mas_preallocate(&mas, NULL, GFP_KERNEL);
+	mas_store_prealloc(&mas, NULL);
+	mt_dump(mt, mt_dump_hex);
+
+	mas_destroy(&mas);
+	mtree_unlock(mt);
+	return 0;
+}
+
 void farmer_tests(void)
 {
 	struct maple_node *node;
@@ -36290,6 +36322,10 @@ void farmer_tests(void)
 
 	mt_dump(&tree, mt_dump_dec);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | MT_FLAGS_USE_RCU);
+	check_vma_modification(&tree);
+	mtree_destroy(&tree);
+
 	tree.ma_root = xa_mk_value(0);
 	mt_dump(&tree, mt_dump_dec);
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


