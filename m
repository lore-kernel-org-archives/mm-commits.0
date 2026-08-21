Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B003D9DA6
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350913; cv=none; b=lubmgpbvYTwmYjUj06fnicgE0KGu2OcqgmPIINVQsjRihEg0y1WxyO55HR3c5qR6PvqFksCmFq5qrIP/OkdNS9EYYtytmJ/m1mZWUlWdBDWeRVnWdtsy/jV1rYiU2tyk53mXO6W6qdKOV2paaRiKJis+DzGnoAFscrmYE+wNSyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350913; c=relaxed/simple;
	bh=T9z6j4Wzx7Y9Gnb3KceJjQFkmELhU8aK1gWOI3wDsPI=;
	h=Date:To:From:Subject:Message-Id; b=OZrCfYrGAhWsjIAj9CwVovDMT4mSS7iIKhTZCi3jOEUyvyJRV3LyJSlZvlmoMLvmFv7AF3u9s6Qy7pVnOC10Ng7/1PWnUharzZqbYizvOBvYoA1rSi43w5UsrWy5/kDEei1J6VIPEeOJtFyCKuzBc+YSEHVWxpo0hnGDwQ+Jihk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x9fai0Kf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x9fai0Kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5A61F000E9;
	Fri, 21 Aug 2026 22:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350911;
	bh=GYBUHLZRrDar76cbWicKuWnvZ1Lq3k1H9VHrjU2o3QY=;
	h=Date:To:From:Subject;
	b=x9fai0KfkfR1iJlMLyUV1d0jcbyYvftMGH1CVGvMjP/MPQJCEQ304D0xn0yPFWo2Z
	 0KwLnTzIF4usohKm4shqEAdY4DbY5XCtYcNvAGVedexezmOuAdKYCdaCO3Nf4cQT90
	 WOQrMfdtlO4VtumgjJ1LR67fsN87WdOBCNgCtQ/I=
Date: Fri, 21 Aug 2026 15:21:51 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-add-bulk-parent-set-helper.patch removed from -mm tree
Message-Id: <20260821222151.CD5A61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add bulk parent set helper
has been removed from the -mm tree.  Its filename was
     maple_tree-add-bulk-parent-set-helper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: add bulk parent set helper
Date: Tue, 30 Jun 2026 15:08:35 -0400

Instead of calculating the parent pointer each time for a child, cache the
majority of the parent pointer and only change the slot per child.

Drop the mas_set_parent() function since the last user has been removed.

Testing on a tree containing 2048 entries of height 4 had an increased
gain of 3.51% on nodes tracking gaps.

Link: https://lore.kernel.org/20260630190843.3563858-12-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   97 +++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 55 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-bulk-parent-set-helper
+++ a/lib/maple_tree.c
@@ -451,46 +451,6 @@ enum maple_type mas_parent_type(struct m
 }
 
 /*
- * mas_set_parent() - Set the parent node and encode the slot
- * @mas: The maple state
- * @enode: The encoded maple node.
- * @parent: The encoded maple node that is the parent of @enode.
- * @slot: The slot that @enode resides in @parent.
- *
- * Slot number is encoded in the enode->parent bit 3-6 or 2-6, depending on the
- * parent type.
- */
-static inline
-void mas_set_parent(struct ma_state *mas, struct maple_enode *enode,
-		    const struct maple_enode *parent, unsigned char slot)
-{
-	unsigned long val = (unsigned long)parent;
-	unsigned long shift;
-	unsigned long type;
-	enum maple_type p_type = mte_node_type(parent);
-
-	MAS_BUG_ON(mas, p_type == maple_dense);
-	MAS_BUG_ON(mas, p_type == maple_leaf_64);
-
-	switch (p_type) {
-	case maple_range_64:
-	case maple_arange_64:
-		shift = MAPLE_PARENT_SLOT_SHIFT;
-		type = MAPLE_PARENT_RANGE64;
-		break;
-	default:
-	case maple_dense:
-	case maple_leaf_64:
-		shift = type = 0;
-		break;
-	}
-
-	val &= ~MAPLE_NODE_MASK; /* Clear all node metadata in parent */
-	val |= (slot << shift) | type;
-	mte_to_node(enode)->parent = ma_parent_ptr(val);
-}
-
-/*
  * mte_parent_slot() - get the parent slot of @enode.
  * @enode: The encoded maple node.
  *
@@ -872,6 +832,42 @@ static inline void ma_set_meta_gap(struc
 }
 
 /*
+ * mas_set_parent_slots() - Bulk operation to set many slot parent pointers
+ * @mas: The maple state
+ * @parent: The encoded maple node that is the parent of @enode.
+ * @slot: The slot that of the @enode.
+ * @start_slot: The offset into @slot
+ * @count: The number of slots to set (eg: exclusive)
+ */
+static inline
+void mas_set_parent_slots(struct ma_state *mas, struct maple_enode *parent,
+	void __rcu **slots, unsigned char start_slot, unsigned char count)
+{
+	unsigned long val;
+	unsigned long shift;
+	unsigned long type;
+	enum maple_type p_type = mte_node_type(parent);
+	unsigned char i;
+
+	MAS_BUG_ON(mas, p_type != maple_range_64 &&
+			p_type != maple_arange_64);
+
+	shift = MAPLE_PARENT_SLOT_SHIFT;
+	type = MAPLE_PARENT_RANGE64;
+
+	val = (unsigned long)parent;
+	val &= ~MAPLE_NODE_MASK;
+
+	for (i = 0; i < count; i++) {
+		unsigned long pval = val | ((start_slot + i) << shift) | type;
+		struct maple_enode *child;
+
+		child = mt_slot_locked(mas->tree, slots, i);
+		mte_to_node(child)->parent = ma_parent_ptr(pval);
+	}
+}
+
+/*
  * mat_add() - Add a @dead_enode to the ma_topiary of a list of dead nodes.
  * @mat: the ma_topiary, a linked list of dead nodes.
  * @dead_enode: the node to be marked as dead and added to the tail of the list
@@ -1609,14 +1605,10 @@ static inline void mas_adopt_children(st
 	struct maple_node *node = mte_to_node(parent);
 	void __rcu **slots = ma_slots(node, type);
 	unsigned long *pivots = ma_pivots(node, type);
-	struct maple_enode *child;
-	unsigned char offset;
+	unsigned char end;
 
-	offset = ma_data_end(node, type, pivots, mas->max);
-	do {
-		child = mas_slot_locked(mas, slots, offset);
-		mas_set_parent(mas, child, parent, offset);
-	} while (offset--);
+	end = ma_data_end(node, type, pivots, mas->max);
+	mas_set_parent_slots(mas, parent, slots, 0, end + 1);
 }
 
 /*
@@ -1998,15 +1990,10 @@ unsigned long node_copy(struct ma_state
 	s_slots = ma_slots(src, s_mt) + start;
 	s_pivots = ma_pivots(src, s_mt) + start;
 	memcpy(d_slots, s_slots, size * sizeof(void __rcu *));
-	if (!ma_is_leaf(d_mt) && s_mt == maple_copy) {
-		struct maple_enode *edst = mt_mk_node(dst, d_mt);
 
-
-		for (int i = 0; i < size; i++)
-			mas_set_parent(mas,
-				       mt_slot_locked(mas->tree, d_slots, i),
-				       edst, d_start + i);
-	}
+	if (!ma_is_leaf(d_mt) && s_mt == maple_copy)
+		mas_set_parent_slots(mas, mt_mk_node(dst, d_mt),
+				     d_slots, d_start, size);
 
 	d_gaps = ma_gaps(dst, d_mt);
 	if (d_gaps) {
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

