Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A342F7EEE
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 23:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860847; cv=none; b=L383V/gH6wnBe5EY2ZItX5qFXwzcMkVzOOeT1EM/ok1Lla7uJNuqfXmw1OApB4sX+a7N9S/jDgjNV2fuC9EW/YrnIGAi1aM/RWLf63PC4GaGofGLsaP1VC1GV9SD+jM3udBxVthkdDf3zfA3odRqu/TLXVmPg60UT+wrZJHjegE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860847; c=relaxed/simple;
	bh=9HyLMwNtYZs8VYMwO8ty5ym2GKQyMxWh9mly0kg1aUc=;
	h=Date:To:From:Subject:Message-Id; b=sYPARpEBOvYFU5cFHYuzGr9BrK5MVZUEXSPKDf41zP29UvI28ha2ie+BUAq3yy4R8KJgO/mdDcvMNMQHCodGJreB9JtId630YsjxgqxvGm5f+dj24L6IeWnS3M+7ZDrrG15eTYbkTMZcx0hcnZvpr3bbNXgNwOG3jzt5VFz8vTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ocEp5o06; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ocEp5o06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558F41F000E9;
	Tue, 30 Jun 2026 23:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860846;
	bh=eyVTy8zw5WQWkHUSbGEjahXd9u733gMRlpEt15VmJ0g=;
	h=Date:To:From:Subject;
	b=ocEp5o06XNp9L5XFuXak1rMXb5BPpzUuCALmhAk1/evdbhs67UZFjIIkvCb7OUZ+r
	 2VApbg8pFJxhLTd8PRdbwttvVeARbwCKOU4eUf4LRzSx/7vZvW+TuSyDehfWhPcg4a
	 0uZSizg7x2JJT+mBe07fcmaYnqlweYZIpCtU7ArI=
Date: Tue, 30 Jun 2026 16:07:25 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-avoid-extra-gap-calculation.patch added to mm-new branch
Message-Id: <20260630230726.558F41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: avoid extra gap calculation
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-avoid-extra-gap-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-avoid-extra-gap-calculation.patch

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
Subject: maple_tree: avoid extra gap calculation
Date: Tue, 30 Jun 2026 15:08:42 -0400

Prior to ending the ascension loop of larger operations like split,
rebalance, and spanning store the gap in the node had been calculated. 
Once the node is inserted into the tree, the gap is recalculated in
mas_update_gap().  This can be avoided by creating a helper for
mas_update_gap() that accepts the known gap value, which reduces the
operations required for gap updating path.

Link: https://lore.kernel.org/20260630190843.3563858-19-liam@infradead.org
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

 lib/maple_tree.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/lib/maple_tree.c~maple_tree-avoid-extra-gap-calculation
+++ a/lib/maple_tree.c
@@ -1565,14 +1565,26 @@ ascend:
 	goto ascend;
 }
 
+static __always_inline void mas_update_gap_known(struct ma_state *mas,
+		unsigned long gap)
+{
+	unsigned char pslot;
+	unsigned long p_gap;
+
+	pslot = mte_parent_slot(mas->node);
+	p_gap = ma_gaps(mte_parent(mas->node),
+			mas_parent_type(mas, mas->node))[pslot];
+
+	if (p_gap != gap)
+		mas_parent_gap(mas, pslot, gap);
+}
+
 /*
  * mas_update_gap() - Update a nodes gaps and propagate up if necessary.
  * @mas: the maple state.
  */
 static inline void mas_update_gap(struct ma_state *mas)
 {
-	unsigned char pslot;
-	unsigned long p_gap;
 	unsigned long max_gap;
 
 	if (!mt_is_alloc(mas->tree))
@@ -1582,13 +1594,7 @@ static inline void mas_update_gap(struct
 		return;
 
 	max_gap = mas_max_gap(mas);
-
-	pslot = mte_parent_slot(mas->node);
-	p_gap = ma_gaps(mte_parent(mas->node),
-			mas_parent_type(mas, mas->node))[pslot];
-
-	if (p_gap != max_gap)
-		mas_parent_gap(mas, pslot, max_gap);
+	mas_update_gap_known(mas, max_gap);
 }
 
 /*
@@ -2136,8 +2142,8 @@ static inline void mas_wmb_replace(struc
 	mas->node = mt_slot_locked(mas->tree, cp->slot, 0);
 	/* Insert the new data in the tree */
 	mas_topiary_replace(mas, old_enode, cp->height);
-	if (!mte_is_leaf(mas->node))
-		mas_update_gap(mas);
+	if (mt_is_alloc(mas->tree) && !mte_is_root(mas->node))
+		mas_update_gap_known(mas, cp->gap[0]);
 
 	mtree_range_walk(mas);
 }
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

