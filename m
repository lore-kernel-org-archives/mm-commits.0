Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CFF2F7EEE
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 23:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860831; cv=none; b=hF411INrvOGAWWIIgqFoqy6TGdlp2PKEI1nEYqUB14DLqupp5SfSgxLuqezPOZXjWvwxQ7Q5T1IvjfqmXZup+ydIZ2XMKLNVfSHaVNih8cnftX/yfy3ryQHGVihLqJ+Z/8lXzcRb1JIDOAr6WkN4Y4lMC2x145Uc5IwClYlCDqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860831; c=relaxed/simple;
	bh=Xp/EJ3W8JYF4kKviy1LPtUZsc7ZkJhISYI7RDrMp6X8=;
	h=Date:To:From:Subject:Message-Id; b=CUX5AuGLfJyoWSzK8+2Wft+uqsJ106DW36VfUllk84YF22qNGf/Y8dxsei5u99+oblcH5O7wVg1GIDZ3cTlJd3jsI9N5fGiLkvQtfIijiZYQAH2F7dVkIVyh2OO3sdAWJujhA/UdSrrjqio49UiAnB9STvdoBUKp/l7pm569LmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RjlfE1fe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RjlfE1fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDA81F000E9;
	Tue, 30 Jun 2026 23:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860829;
	bh=BBbuO9Rp0RbsTyoX8FzEW89mc6YbiWbESwhZSWOdpko=;
	h=Date:To:From:Subject;
	b=RjlfE1feqGVLTxJURAwfNVn/7+mw3wcVIgfCY7a2iyf+9sKkrVj7+UIr4/yMK6KWI
	 vfgqTweGBIQWaEPiv3dI3Pq86sr+Vbkgm27Gxg4z8G+oMvNbLSr5HtSFJ8ujzOBNJj
	 TYNhXmVZ08SQ+/89BKvcENFTjdNlxpxQURB3dnGk=
Date: Tue, 30 Jun 2026 16:07:09 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-bulk-parent-set-helper.patch added to mm-new branch
Message-Id: <20260630230709.BDDA81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add bulk parent set helper
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-add-bulk-parent-set-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-bulk-parent-set-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -456,46 +456,6 @@ enum maple_type mas_parent_type(struct m
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
@@ -877,6 +837,42 @@ static inline void ma_set_meta_gap(struc
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
@@ -1608,14 +1604,10 @@ static inline void mas_adopt_children(st
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
@@ -1997,15 +1989,10 @@ unsigned long node_copy(struct ma_state
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

maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch
locking-lockdep-add-sequence-counter-to-held_lock.patch
maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch
maple_tree-documentation-fix.patch
maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch
maple_tree-drop-maple_alloc_slots.patch
maple_tree-clarify-comments-on-mas_nomem.patch
maple_tree-use-prefetched-value-in-mas_wr_store_type.patch
maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

