Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F90E1DAC5A
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668043; cv=none; b=UPPufN6EuRHNPkRBnkHa0OR7l3iZXSPXiprg23Z4zLfBlN6kMP3y0521EnpnY8epKlitlZWznOsE02KSuTA89yanb9d4LFWk8vG5ejkiZ4oOcY5nnQi8Q8xN3VWHjYpPVLJoV5Cg00s6Y5Punw5cVdebnPswlNuLNaWAp612Im0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668043; c=relaxed/simple;
	bh=Lb5T6cufDb2b4jgyI3I/7ugY/XuL4aBTl/MIzAMv+ys=;
	h=Date:To:From:Subject:Message-Id; b=uOW00YokLN9TII4+fX5l+zt4nxTjyFrRoTPHqoW6u78x6TcjThbAikIbvuhL6RYNWvK0zYoWed3i/ZXGboNeBeuwD6fMHOWYiphHdT9vT+kQznv4P6C94AtCpTgLmBKMOFqgLKW81nROtxCtI82zu1Gk5BJONzTa1rvBugH8iLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hwl8dA1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hwl8dA1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351CEC116B1;
	Wed, 14 Aug 2024 20:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723668043;
	bh=Lb5T6cufDb2b4jgyI3I/7ugY/XuL4aBTl/MIzAMv+ys=;
	h=Date:To:From:Subject:From;
	b=Hwl8dA1Qamdp65LgsTrnx6a/OnqpgQV7L4oU5i+5u7Ecm4+TVn+2c5LU60Mam+722
	 BC8EY858JwVtV36TLcI9RjBsNGPspwTWmx1K9tEUIWwJyin/3dt9h0tt0bOLMBIX0J
	 /MKthihn7970aA7RhDQavvW2rCTaA9v0jxdOuF1s=
Date: Wed, 14 Aug 2024 13:40:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-make-write-helper-functions-void.patch added to mm-unstable branch
Message-Id: <20240814204043.351CEC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: make write helper functions void
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-make-write-helper-functions-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-make-write-helper-functions-void.patch

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
Subject: maple_tree: make write helper functions void
Date: Wed, 14 Aug 2024 12:19:44 -0400

The return value of various write helper functions are not checked. We
can safely change the return type of these functions to be void.

Link: https://lkml.kernel.org/r/20240814161944.55347-18-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   47 +++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 31 deletions(-)

--- a/lib/maple_tree.c~maple_tree-make-write-helper-functions-void
+++ a/lib/maple_tree.c
@@ -2823,10 +2823,8 @@ dead_node:
  * orig_l_mas->last is used in mas_consume to find the slots that will need to
  * be either freed or destroyed.  orig_l_mas->depth keeps track of the height of
  * the new sub-tree in case the sub-tree becomes the full tree.
- *
- * Return: the number of elements in b_node during the last loop.
  */
-static int mas_spanning_rebalance(struct ma_state *mas,
+static void mas_spanning_rebalance(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char count)
 {
 	unsigned char split, mid_split;
@@ -2942,7 +2940,7 @@ new_root:
 	mas->offset = l_mas.offset;
 	mas_wmb_replace(mas, old_enode);
 	mtree_range_walk(mas);
-	return mast->bn->b_end;
+	return;
 }
 
 /*
@@ -2952,10 +2950,8 @@ new_root:
  *
  * Rebalance two nodes into a single node or two new nodes that are sufficient.
  * Continue upwards until tree is sufficient.
- *
- * Return: the number of elements in b_node during the last loop.
  */
-static inline int mas_rebalance(struct ma_state *mas,
+static inline void mas_rebalance(struct ma_state *mas,
 				struct maple_big_node *b_node)
 {
 	char empty_count = mas_mt_height(mas);
@@ -3300,9 +3296,8 @@ static inline bool mas_push_data(struct
  * mas_split() - Split data that is too big for one node into two.
  * @mas: The maple state
  * @b_node: The maple big node
- * Return: 1 on success, 0 on failure.
  */
-static int mas_split(struct ma_state *mas, struct maple_big_node *b_node)
+static void mas_split(struct ma_state *mas, struct maple_big_node *b_node)
 {
 	struct maple_subtree_state mast;
 	int height = 0;
@@ -3380,7 +3375,7 @@ static int mas_split(struct ma_state *ma
 	mas->node = l_mas.node;
 	mas_wmb_replace(mas, old);
 	mtree_range_walk(mas);
-	return 1;
+	return;
 }
 
 /*
@@ -3388,7 +3383,7 @@ static int mas_split(struct ma_state *ma
  * @wr_mas: The maple write state
  * @b_node: The maple big node
  */
-static noinline_for_kasan int mas_commit_b_node(struct ma_wr_state *wr_mas,
+static noinline_for_kasan void mas_commit_b_node(struct ma_wr_state *wr_mas,
 			    struct maple_big_node *b_node)
 {
 	enum store_type type = wr_mas->mas->store_type;
@@ -3664,10 +3659,8 @@ static void mte_destroy_walk(struct mapl
  * @entry: The entry to store.
  *
  * Only valid when the index == 0 and the last == ULONG_MAX
- *
- * Return 0 on error, 1 on success.
  */
-static inline int mas_new_root(struct ma_state *mas, void *entry)
+static inline void mas_new_root(struct ma_state *mas, void *entry)
 {
 	struct maple_enode *root = mas_root_locked(mas);
 	enum maple_type type = maple_leaf_64;
@@ -3699,7 +3692,7 @@ done:
 	if (xa_is_node(root))
 		mte_destroy_walk(root, mas->tree);
 
-	return 1;
+	return;
 }
 /*
  * mas_wr_spanning_store() - Create a subtree with the store operation completed
@@ -3707,10 +3700,8 @@ done:
  * Note that mas is expected to point to the node which caused the store to
  * span.
  * @wr_mas: The maple write state
- *
- * Return: 0 on error, positive on success.
  */
-static noinline int mas_wr_spanning_store(struct ma_wr_state *wr_mas)
+static noinline void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
 	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
@@ -3802,10 +3793,8 @@ static noinline int mas_wr_spanning_stor
  * @wr_mas: The maple write state
  *
  * Attempts to reuse the node, but may allocate.
- *
- * Return: True if stored, false otherwise
  */
-static inline bool mas_wr_node_store(struct ma_wr_state *wr_mas,
+static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 				     unsigned char new_end)
 {
 	struct ma_state *mas = wr_mas->mas;
@@ -3878,16 +3867,14 @@ done:
 	trace_ma_write(__func__, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
 	mas->end = new_end;
-	return true;
+	return;
 }
 
 /*
  * mas_wr_slot_store: Attempt to store a value in a slot.
  * @wr_mas: the maple write state
- *
- * Return: True if stored, false otherwise
  */
-static inline bool mas_wr_slot_store(struct ma_wr_state *wr_mas)
+static inline void mas_wr_slot_store(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char offset = mas->offset;
@@ -3919,7 +3906,7 @@ static inline bool mas_wr_slot_store(str
 		wr_mas->pivots[offset + 1] = mas->last;
 		mas->offset++; /* Keep mas accurate. */
 	} else {
-		return false;
+		return;
 	}
 
 	trace_ma_write(__func__, mas, 0, wr_mas->entry);
@@ -3930,7 +3917,7 @@ static inline bool mas_wr_slot_store(str
 	if (!wr_mas->entry || gap)
 		mas_update_gap(mas);
 
-	return true;
+	return;
 }
 
 static inline void mas_wr_extend_null(struct ma_wr_state *wr_mas)
@@ -4004,10 +3991,8 @@ static inline unsigned char mas_wr_new_e
  * This is currently unsafe in rcu mode since the end of the node may be cached
  * by readers while the node contents may be updated which could result in
  * inaccurate information.
- *
- * Return: True if appended, false otherwise
  */
-static inline bool mas_wr_append(struct ma_wr_state *wr_mas,
+static inline void mas_wr_append(struct ma_wr_state *wr_mas,
 		unsigned char new_end)
 {
 	struct ma_state *mas = wr_mas->mas;
@@ -4046,7 +4031,7 @@ static inline bool mas_wr_append(struct
 
 	mas->end = new_end;
 	trace_ma_write(__func__, mas, new_end, wr_mas->entry);
-	return  true;
+	return;
 }
 
 /*
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

