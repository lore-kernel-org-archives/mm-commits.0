Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ADC1D6DC7
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668040; cv=none; b=T311PFktz9Tv9oJVSYSM7gQB6CngKHkuOInQnZ7pZNzPkCn+yW211Kz9cs8DnATRaLF7/D/Zwc5oKkif25qDHt9omJlN5L8FNAqSkoQ+Lr4ogG2e28J/Q44Lf5AnGAZjnsKj9NtYjMz5j85hoWCoKq+HuQWo1KU4k1PPkUXtKAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668040; c=relaxed/simple;
	bh=YubmIlcT1Z5BD3+DiRRdsr34I7uBZ2ECwoYRYge2L1E=;
	h=Date:To:From:Subject:Message-Id; b=DFTxVNi5aMqqEVkNT/vI+dPxWsXrkwuXUTSGJWjULJBxwTdOzKlO16KHcV7i/8bXdaQEbA+8c/dXbcZkp2SffpWKl3/LEKwRzstjBs/8gZnywhAoyZFAFNUlRK8E5/KE39R8MhrjKCMxVekXyXTTn6DkH7+XovdYckmKLjukKNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=coehfYrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="coehfYrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B449C4AF14;
	Wed, 14 Aug 2024 20:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723668039;
	bh=YubmIlcT1Z5BD3+DiRRdsr34I7uBZ2ECwoYRYge2L1E=;
	h=Date:To:From:Subject:From;
	b=coehfYrb3qxGXvi/EUDN5CBJ89aaEl8TtphZoqNl4knI8DFSIx5G/EjKcxbfiRkyW
	 w+9nLtSreqicJhB0yxUAvyC34zlsafse0bPOLyVYjABQdLJ5FrI31015p8hy21iJAK
	 FH8k5NCfu1S3RIUrYpzPHeBTSynZaZEotsyK2SZg=
Date: Wed, 14 Aug 2024 13:40:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-node-allocations-from-various-write-helper-functions.patch added to mm-unstable branch
Message-Id: <20240814204039.8B449C4AF14@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove node allocations from various write helper functions
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-node-allocations-from-various-write-helper-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-node-allocations-from-various-write-helper-functions.patch

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
Subject: maple_tree: remove node allocations from various write helper functions
Date: Wed, 14 Aug 2024 12:19:41 -0400

These write helper functions are all called from store paths which
preallocate enough nodes that will be needed for the write. There is no
more need to allocate within the functions themselves.

Link: https://lkml.kernel.org/r/20240814161944.55347-15-sidhartha.kumar@oracle.com
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-node-allocations-from-various-write-helper-functions
+++ a/lib/maple_tree.c
@@ -2976,9 +2976,6 @@ static inline int mas_rebalance(struct m
 	 * tries to combine the data in the same way.  If one node contains the
 	 * entire range of the tree, then that node is used as a new root node.
 	 */
-	mas_node_count(mas, empty_count * 2 - 1);
-	if (mas_is_err(mas))
-		return 0;
 
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
@@ -3029,11 +3026,6 @@ static inline void mas_destroy_rebalance
 
 	/* set up node. */
 	if (in_rcu) {
-		/* Allocate for both left and right as well as parent. */
-		mas_node_count(mas, 3);
-		if (mas_is_err(mas))
-			return;
-
 		newnode = mas_pop_node(mas);
 	} else {
 		newnode = &reuse;
@@ -3341,10 +3333,6 @@ static int mas_split(struct ma_state *ma
 
 	trace_ma_op(__func__, mas);
 	mas->depth = mas_mt_height(mas);
-	/* Allocation failures will happen early. */
-	mas_node_count(mas, 1 + mas->depth * 2);
-	if (mas_is_err(mas))
-		return 0;
 
 	mast.l = &l_mas;
 	mast.r = &r_mas;
@@ -3427,10 +3415,6 @@ static inline int mas_root_expand(struct
 	unsigned long *pivots;
 	int slot = 0;
 
-	mas_node_count(mas, 1);
-	if (unlikely(mas_is_err(mas)))
-		return 0;
-
 	node = mas_pop_node(mas);
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
@@ -3699,10 +3683,6 @@ static inline int mas_new_root(struct ma
 		goto done;
 	}
 
-	mas_node_count(mas, 1);
-	if (mas_is_err(mas))
-		return 0;
-
 	node = mas_pop_node(mas);
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
@@ -3765,9 +3745,6 @@ static noinline int mas_wr_spanning_stor
 	 * entries per level plus a new root.
 	 */
 	height = mas_mt_height(mas);
-	mas_node_count(mas, 1 + height * 3);
-	if (mas_is_err(mas))
-		return 0;
 
 	/*
 	 * Set up right side.  Need to get to the next offset after the spanning
@@ -3851,10 +3828,6 @@ static inline bool mas_wr_node_store(str
 
 	/* set up node. */
 	if (in_rcu) {
-		mas_node_count(mas, 1);
-		if (mas_is_err(mas))
-			return false;
-
 		newnode = mas_pop_node(mas);
 	} else {
 		memset(&reuse, 0, sizeof(struct maple_node));
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-reset-mas-index-and-mas-last-on-write-retries.patch
maple_tree-add-test-to-replicate-low-memory-race-conditions.patch
maple_tree-introduce-store_type-enum.patch
maple_tree-introduce-mas_wr_prealloc_setup.patch
maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch
maple_tree-introduce-mas_wr_store_type.patch
maple_tree-remove-mas_destroy-from-mas_nomem.patch
maple_tree-preallocate-nodes-in-mas_erase.patch
maple_tree-use-mas_store_gfp-in-mtree_store_range.patch
maple_tree-print-store-type-in-mas_dump.patch
maple_tree-use-store-type-in-mas_wr_store_entry.patch
maple_tree-convert-mas_insert-to-preallocate-nodes.patch
maple_tree-simplify-mas_commit_b_node.patch
maple_tree-remove-mas_wr_modify.patch
maple_tree-have-mas_store-allocate-nodes-if-needed.patch
maple_tree-remove-node-allocations-from-various-write-helper-functions.patch
maple_tree-remove-repeated-sanity-checks-from-write-helper-functions.patch
maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch
maple_tree-make-write-helper-functions-void.patch

