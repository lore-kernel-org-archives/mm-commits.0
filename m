From: akpm@linux-foundation.org
Subject: + radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch added to -mm tree
Date: Thu, 05 Jun 2008 13:35:02 -0700
Message-ID: <200806052035.m55KZ22E028500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbYFEUf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 16:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, benh@kernel.crashing.org, hugh@veritas.com, paulmck@us.ibm.com, paulus@samba.org


The patch titled
     radix-tree: add gang_lookup_slot, gang_lookup_slot_tag
has been added to the -mm tree.  Its filename is
     radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radix-tree: add gang_lookup_slot, gang_lookup_slot_tag
From: Nick Piggin <npiggin@suse.de>

Introduce gang_lookup_slot() and gang_lookup_slot_tag() functions, which
are used by lockless pagecache.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   12 ++
 lib/radix-tree.c           |  178 ++++++++++++++++++++++++++++++-----
 2 files changed, 166 insertions(+), 24 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag
+++ a/include/linux/radix-tree.h
@@ -99,12 +99,15 @@ do {									\
  *
  * The notable exceptions to this rule are the following functions:
  * radix_tree_lookup
+ * radix_tree_lookup_slot
  * radix_tree_tag_get
  * radix_tree_gang_lookup
+ * radix_tree_gang_lookup_slot
  * radix_tree_gang_lookup_tag
+ * radix_tree_gang_lookup_tag_slot
  * radix_tree_tagged
  *
- * The first 4 functions are able to be called locklessly, using RCU. The
+ * The first 7 functions are able to be called locklessly, using RCU. The
  * caller must ensure calls to these functions are made within rcu_read_lock()
  * regions. Other readers (lock-free or otherwise) and modifications may be
  * running concurrently.
@@ -159,6 +162,9 @@ void *radix_tree_delete(struct radix_tre
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			unsigned long first_index, unsigned int max_items);
+unsigned int
+radix_tree_gang_lookup_slot(struct radix_tree_root *root, void ***results,
+			unsigned long first_index, unsigned int max_items);
 unsigned long radix_tree_next_hole(struct radix_tree_root *root,
 				unsigned long index, unsigned long max_scan);
 int radix_tree_preload(gfp_t gfp_mask);
@@ -173,6 +179,10 @@ unsigned int
 radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
 		unsigned long first_index, unsigned int max_items,
 		unsigned int tag);
+unsigned int
+radix_tree_gang_lookup_tag_slot(struct radix_tree_root *root, void ***results,
+		unsigned long first_index, unsigned int max_items,
+		unsigned int tag);
 int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
 
 static inline void radix_tree_preload_end(void)
diff -puN lib/radix-tree.c~radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag
+++ a/lib/radix-tree.c
@@ -350,18 +350,17 @@ EXPORT_SYMBOL(radix_tree_insert);
  *	Returns:  the slot corresponding to the position @index in the
  *	radix tree @root. This is useful for update-if-exists operations.
  *
- *	This function cannot be called under rcu_read_lock, it must be
- *	excluded from writers, as must the returned slot for subsequent
- *	use by radix_tree_deref_slot() and radix_tree_replace slot.
- *	Caller must hold tree write locked across slot lookup and
- *	replace.
+ *	This function can be called under rcu_read_lock iff the slot is not
+ *	modified by radix_tree_replace_slot, otherwise it must be called
+ *	exclusive from other writers. Any dereference of the slot must be done
+ *	using radix_tree_deref_slot.
  */
 void **radix_tree_lookup_slot(struct radix_tree_root *root, unsigned long index)
 {
 	unsigned int height, shift;
 	struct radix_tree_node *node, **slot;
 
-	node = root->rnode;
+	node = rcu_dereference(root->rnode);
 	if (node == NULL)
 		return NULL;
 
@@ -381,7 +380,7 @@ void **radix_tree_lookup_slot(struct rad
 	do {
 		slot = (struct radix_tree_node **)
 			(node->slots + ((index>>shift) & RADIX_TREE_MAP_MASK));
-		node = *slot;
+		node = rcu_dereference(*slot);
 		if (node == NULL)
 			return NULL;
 
@@ -658,7 +657,7 @@ unsigned long radix_tree_next_hole(struc
 EXPORT_SYMBOL(radix_tree_next_hole);
 
 static unsigned int
-__lookup(struct radix_tree_node *slot, void **results, unsigned long index,
+__lookup(struct radix_tree_node *slot, void ***results, unsigned long index,
 	unsigned int max_items, unsigned long *next_index)
 {
 	unsigned int nr_found = 0;
@@ -692,11 +691,9 @@ __lookup(struct radix_tree_node *slot, v
 
 	/* Bottom level: grab some items */
 	for (i = index & RADIX_TREE_MAP_MASK; i < RADIX_TREE_MAP_SIZE; i++) {
-		struct radix_tree_node *node;
 		index++;
-		node = slot->slots[i];
-		if (node) {
-			results[nr_found++] = rcu_dereference(node);
+		if (slot->slots[i]) {
+			results[nr_found++] = &(slot->slots[i]);
 			if (nr_found == max_items)
 				goto out;
 		}
@@ -750,13 +747,22 @@ radix_tree_gang_lookup(struct radix_tree
 
 	ret = 0;
 	while (ret < max_items) {
-		unsigned int nr_found;
+		unsigned int nr_found, slots_found, i;
 		unsigned long next_index;	/* Index of next search */
 
 		if (cur_index > max_index)
 			break;
-		nr_found = __lookup(node, results + ret, cur_index,
+		slots_found = __lookup(node, (void ***)results + ret, cur_index,
 					max_items - ret, &next_index);
+		nr_found = 0;
+		for (i = 0; i < slots_found; i++) {
+			struct radix_tree_node *slot;
+			slot = *(((void ***)results)[ret + i]);
+			if (!slot)
+				continue;
+			results[ret + nr_found] = rcu_dereference(slot);
+			nr_found++;
+		}
 		ret += nr_found;
 		if (next_index == 0)
 			break;
@@ -767,12 +773,71 @@ radix_tree_gang_lookup(struct radix_tree
 }
 EXPORT_SYMBOL(radix_tree_gang_lookup);
 
+/**
+ *	radix_tree_gang_lookup_slot - perform multiple slot lookup on radix tree
+ *	@root:		radix tree root
+ *	@results:	where the results of the lookup are placed
+ *	@first_index:	start the lookup from this key
+ *	@max_items:	place up to this many items at *results
+ *
+ *	Performs an index-ascending scan of the tree for present items.  Places
+ *	their slots at *@results and returns the number of items which were
+ *	placed at *@results.
+ *
+ *	The implementation is naive.
+ *
+ *	Like radix_tree_gang_lookup as far as RCU and locking goes. Slots must
+ *	be dereferenced with radix_tree_deref_slot, and if using only RCU
+ *	protection, radix_tree_deref_slot may fail requiring a retry.
+ */
+unsigned int
+radix_tree_gang_lookup_slot(struct radix_tree_root *root, void ***results,
+			unsigned long first_index, unsigned int max_items)
+{
+	unsigned long max_index;
+	struct radix_tree_node *node;
+	unsigned long cur_index = first_index;
+	unsigned int ret;
+
+	node = rcu_dereference(root->rnode);
+	if (!node)
+		return 0;
+
+	if (!radix_tree_is_indirect_ptr(node)) {
+		if (first_index > 0)
+			return 0;
+		results[0] = (void **)&root->rnode;
+		return 1;
+	}
+	node = radix_tree_indirect_to_ptr(node);
+
+	max_index = radix_tree_maxindex(node->height);
+
+	ret = 0;
+	while (ret < max_items) {
+		unsigned int slots_found;
+		unsigned long next_index;	/* Index of next search */
+
+		if (cur_index > max_index)
+			break;
+		slots_found = __lookup(node, results + ret, cur_index,
+					max_items - ret, &next_index);
+		ret += slots_found;
+		if (next_index == 0)
+			break;
+		cur_index = next_index;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(radix_tree_gang_lookup_slot);
+
 /*
  * FIXME: the two tag_get()s here should use find_next_bit() instead of
  * open-coding the search.
  */
 static unsigned int
-__lookup_tag(struct radix_tree_node *slot, void **results, unsigned long index,
+__lookup_tag(struct radix_tree_node *slot, void ***results, unsigned long index,
 	unsigned int max_items, unsigned long *next_index, unsigned int tag)
 {
 	unsigned int nr_found = 0;
@@ -802,11 +867,9 @@ __lookup_tag(struct radix_tree_node *slo
 			unsigned long j = index & RADIX_TREE_MAP_MASK;
 
 			for ( ; j < RADIX_TREE_MAP_SIZE; j++) {
-				struct radix_tree_node *node;
 				index++;
 				if (!tag_get(slot, tag, j))
 					continue;
-				node = slot->slots[j];
 				/*
 				 * Even though the tag was found set, we need to
 				 * recheck that we have a non-NULL node, because
@@ -817,9 +880,8 @@ __lookup_tag(struct radix_tree_node *slo
 				 * lookup ->slots[x] without a lock (ie. can't
 				 * rely on its value remaining the same).
 				 */
-				if (node) {
-					node = rcu_dereference(node);
-					results[nr_found++] = node;
+				if (slot->slots[j]) {
+					results[nr_found++] = &(slot->slots[j]);
 					if (nr_found == max_items)
 						goto out;
 				}
@@ -878,13 +940,22 @@ radix_tree_gang_lookup_tag(struct radix_
 
 	ret = 0;
 	while (ret < max_items) {
-		unsigned int nr_found;
+		unsigned int nr_found, slots_found, i;
 		unsigned long next_index;	/* Index of next search */
 
 		if (cur_index > max_index)
 			break;
-		nr_found = __lookup_tag(node, results + ret, cur_index,
-					max_items - ret, &next_index, tag);
+		slots_found = __lookup_tag(node, (void ***)results + ret,
+				cur_index, max_items - ret, &next_index, tag);
+		nr_found = 0;
+		for (i = 0; i < slots_found; i++) {
+			struct radix_tree_node *slot;
+			slot = *(((void ***)results)[ret + i]);
+			if (!slot)
+				continue;
+			results[ret + nr_found] = rcu_dereference(slot);
+			nr_found++;
+		}
 		ret += nr_found;
 		if (next_index == 0)
 			break;
@@ -896,6 +967,67 @@ radix_tree_gang_lookup_tag(struct radix_
 EXPORT_SYMBOL(radix_tree_gang_lookup_tag);
 
 /**
+ *	radix_tree_gang_lookup_tag_slot - perform multiple slot lookup on a
+ *					  radix tree based on a tag
+ *	@root:		radix tree root
+ *	@results:	where the results of the lookup are placed
+ *	@first_index:	start the lookup from this key
+ *	@max_items:	place up to this many items at *results
+ *	@tag:		the tag index (< RADIX_TREE_MAX_TAGS)
+ *
+ *	Performs an index-ascending scan of the tree for present items which
+ *	have the tag indexed by @tag set.  Places the slots at *@results and
+ *	returns the number of slots which were placed at *@results.
+ */
+unsigned int
+radix_tree_gang_lookup_tag_slot(struct radix_tree_root *root, void ***results,
+		unsigned long first_index, unsigned int max_items,
+		unsigned int tag)
+{
+	struct radix_tree_node *node;
+	unsigned long max_index;
+	unsigned long cur_index = first_index;
+	unsigned int ret;
+
+	/* check the root's tag bit */
+	if (!root_tag_get(root, tag))
+		return 0;
+
+	node = rcu_dereference(root->rnode);
+	if (!node)
+		return 0;
+
+	if (!radix_tree_is_indirect_ptr(node)) {
+		if (first_index > 0)
+			return 0;
+		results[0] = (void **)&root->rnode;
+		return 1;
+	}
+	node = radix_tree_indirect_to_ptr(node);
+
+	max_index = radix_tree_maxindex(node->height);
+
+	ret = 0;
+	while (ret < max_items) {
+		unsigned int slots_found;
+		unsigned long next_index;	/* Index of next search */
+
+		if (cur_index > max_index)
+			break;
+		slots_found = __lookup_tag(node, results + ret,
+				cur_index, max_items - ret, &next_index, tag);
+		ret += slots_found;
+		if (next_index == 0)
+			break;
+		cur_index = next_index;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(radix_tree_gang_lookup_tag_slot);
+
+
+/**
  *	radix_tree_shrink    -    shrink height of a radix tree to minimal
  *	@root		radix tree root
  */
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
vt-fix-vc_resize-locking.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

