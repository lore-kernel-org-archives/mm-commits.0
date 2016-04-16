From: akpm@linux-foundation.org
Subject: + radix-tree-rename-radix_tree_is_indirect_ptr.patch added to -mm tree
Date: Fri, 15 Apr 2016 23:04:53 -0700
Message-ID: <5711d605.VfbMp8Y4Dmfn7qqh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbcDPGEy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 02:04:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: rename radix_tree_is_indirect_ptr()
has been added to the -mm tree.  Its filename is
     radix-tree-rename-radix_tree_is_indirect_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-rename-radix_tree_is_indirect_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-rename-radix_tree_is_indirect_ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: rename radix_tree_is_indirect_ptr()

As with indirect_to_ptr(), ptr_to_indirect() and RADIX_TREE_INDIRECT_PTR,
change radix_tree_is_indirect_ptr() to radix_tree_is_internal_node().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h      |   10 +++---
 lib/radix-tree.c                |   48 +++++++++++++++---------------
 tools/testing/radix-tree/test.c |    4 +-
 3 files changed, 31 insertions(+), 31 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-rename-radix_tree_is_indirect_ptr include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-rename-radix_tree_is_indirect_ptr
+++ a/include/linux/radix-tree.h
@@ -57,7 +57,7 @@
 #define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
 		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
 
-static inline int radix_tree_is_indirect_ptr(void *ptr)
+static inline int radix_tree_is_internal_node(void *ptr)
 {
 	return (int)((unsigned long)ptr & RADIX_TREE_INTERNAL_NODE);
 }
@@ -224,7 +224,7 @@ static inline void *radix_tree_deref_slo
  */
 static inline int radix_tree_deref_retry(void *arg)
 {
-	return unlikely(radix_tree_is_indirect_ptr(arg));
+	return unlikely(radix_tree_is_internal_node(arg));
 }
 
 /**
@@ -259,7 +259,7 @@ static inline int radix_tree_exception(v
  */
 static inline void radix_tree_replace_slot(void **pslot, void *item)
 {
-	BUG_ON(radix_tree_is_indirect_ptr(item));
+	BUG_ON(radix_tree_is_internal_node(item));
 	rcu_assign_pointer(*pslot, item);
 }
 
@@ -468,7 +468,7 @@ radix_tree_next_slot(void **slot, struct
 		if (unlikely(!iter->tags))
 			return NULL;
 		while (IS_ENABLED(CONFIG_RADIX_TREE_MULTIORDER) &&
-					radix_tree_is_indirect_ptr(slot[1])) {
+					radix_tree_is_internal_node(slot[1])) {
 			if (entry_to_node(slot[1]) == canon) {
 				iter->tags >>= 1;
 				iter->index = __radix_tree_iter_add(iter, 1);
@@ -498,7 +498,7 @@ radix_tree_next_slot(void **slot, struct
 			iter->index = __radix_tree_iter_add(iter, 1);
 
 			if (IS_ENABLED(CONFIG_RADIX_TREE_MULTIORDER) &&
-			    radix_tree_is_indirect_ptr(*slot)) {
+			    radix_tree_is_internal_node(*slot)) {
 				if (entry_to_node(*slot) == canon)
 					continue;
 				iter->next_index = iter->index;
diff -puN lib/radix-tree.c~radix-tree-rename-radix_tree_is_indirect_ptr lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rename-radix_tree_is_indirect_ptr
+++ a/lib/radix-tree.c
@@ -100,7 +100,7 @@ static unsigned radix_tree_descend(struc
 	void **entry = rcu_dereference_raw(parent->slots[offset]);
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
-	if (radix_tree_is_indirect_ptr(entry)) {
+	if (radix_tree_is_internal_node(entry)) {
 		unsigned long siboff = get_slot_offset(parent, entry);
 		if (siboff < RADIX_TREE_MAP_SIZE) {
 			offset = siboff;
@@ -232,7 +232,7 @@ static void dump_node(struct radix_tree_
 					entry, i,
 					*(void **)entry_to_node(entry),
 					first, last);
-		} else if (!radix_tree_is_indirect_ptr(entry)) {
+		} else if (!radix_tree_is_internal_node(entry)) {
 			pr_debug("radix entry %p offset %ld indices %ld-%ld\n",
 					entry, i, first, last);
 		} else {
@@ -247,7 +247,7 @@ static void radix_tree_dump(struct radix
 	pr_debug("radix root: %p rnode %p tags %x\n",
 			root, root->rnode,
 			root->gfp_mask >> __GFP_BITS_SHIFT);
-	if (!radix_tree_is_indirect_ptr(root->rnode))
+	if (!radix_tree_is_internal_node(root->rnode))
 		return;
 	dump_node(entry_to_node(root->rnode), 0);
 }
@@ -302,7 +302,7 @@ radix_tree_node_alloc(struct radix_tree_
 	ret = kmem_cache_alloc(radix_tree_node_cachep,
 			       gfp_mask | __GFP_ACCOUNT);
 out:
-	BUG_ON(radix_tree_is_indirect_ptr(ret));
+	BUG_ON(radix_tree_is_internal_node(ret));
 	return ret;
 }
 
@@ -421,7 +421,7 @@ static unsigned radix_tree_load_root(str
 
 	*nodep = node;
 
-	if (likely(radix_tree_is_indirect_ptr(node))) {
+	if (likely(radix_tree_is_internal_node(node))) {
 		node = entry_to_node(node);
 		*maxindex = node_maxindex(node);
 		return node->shift + RADIX_TREE_MAP_SHIFT;
@@ -467,7 +467,7 @@ static int radix_tree_extend(struct radi
 		node->offset = 0;
 		node->count = 1;
 		node->parent = NULL;
-		if (radix_tree_is_indirect_ptr(slot))
+		if (radix_tree_is_internal_node(slot))
 			entry_to_node(slot)->parent = node;
 		node->slots[0] = slot;
 		slot = node_to_entry(node);
@@ -535,7 +535,7 @@ int __radix_tree_create(struct radix_tre
 			} else
 				rcu_assign_pointer(root->rnode,
 							node_to_entry(slot));
-		} else if (!radix_tree_is_indirect_ptr(slot))
+		} else if (!radix_tree_is_internal_node(slot))
 			break;
 
 		/* Go a level down */
@@ -585,7 +585,7 @@ int __radix_tree_insert(struct radix_tre
 	void **slot;
 	int error;
 
-	BUG_ON(radix_tree_is_indirect_ptr(item));
+	BUG_ON(radix_tree_is_internal_node(item));
 
 	error = __radix_tree_create(root, index, order, &node, &slot);
 	if (error)
@@ -637,7 +637,7 @@ void *__radix_tree_lookup(struct radix_t
 	if (index > maxindex)
 		return NULL;
 
-	while (radix_tree_is_indirect_ptr(node)) {
+	while (radix_tree_is_internal_node(node)) {
 		unsigned offset;
 
 		if (node == RADIX_TREE_RETRY)
@@ -720,7 +720,7 @@ void *radix_tree_tag_set(struct radix_tr
 	shift = radix_tree_load_root(root, &node, &maxindex);
 	BUG_ON(index > maxindex);
 
-	while (radix_tree_is_indirect_ptr(node)) {
+	while (radix_tree_is_internal_node(node)) {
 		unsigned offset;
 
 		shift -= RADIX_TREE_MAP_SHIFT;
@@ -770,7 +770,7 @@ void *radix_tree_tag_clear(struct radix_
 
 	parent = NULL;
 
-	while (radix_tree_is_indirect_ptr(node)) {
+	while (radix_tree_is_internal_node(node)) {
 		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 
@@ -835,7 +835,7 @@ int radix_tree_tag_get(struct radix_tree
 	if (node == NULL)
 		return 0;
 
-	while (radix_tree_is_indirect_ptr(node)) {
+	while (radix_tree_is_internal_node(node)) {
 		int offset;
 
 		shift -= RADIX_TREE_MAP_SHIFT;
@@ -900,7 +900,7 @@ void **radix_tree_next_chunk(struct radi
 	if (index > maxindex)
 		return NULL;
 
-	if (radix_tree_is_indirect_ptr(rnode)) {
+	if (radix_tree_is_internal_node(rnode)) {
 		rnode = entry_to_node(rnode);
 	} else if (rnode) {
 		/* Single-slot tree */
@@ -957,7 +957,7 @@ void **radix_tree_next_chunk(struct radi
 
 		if ((slot == NULL) || (slot == RADIX_TREE_RETRY))
 			goto restart;
-		if (!radix_tree_is_indirect_ptr(slot))
+		if (!radix_tree_is_internal_node(slot))
 			break;
 
 		node = entry_to_node(slot);
@@ -1039,7 +1039,7 @@ unsigned long radix_tree_range_tag_if_ta
 		*first_indexp = last_index + 1;
 		return 0;
 	}
-	if (!radix_tree_is_indirect_ptr(slot)) {
+	if (!radix_tree_is_internal_node(slot)) {
 		*first_indexp = last_index + 1;
 		root_tag_set(root, settag);
 		return 1;
@@ -1059,7 +1059,7 @@ unsigned long radix_tree_range_tag_if_ta
 		if (!tag_get(node, iftag, offset))
 			goto next;
 		/* Sibling slots never have tags set on them */
-		if (radix_tree_is_indirect_ptr(slot)) {
+		if (radix_tree_is_internal_node(slot)) {
 			node = entry_to_node(slot);
 			shift -= RADIX_TREE_MAP_SHIFT;
 			continue;
@@ -1152,7 +1152,7 @@ radix_tree_gang_lookup(struct radix_tree
 		results[ret] = rcu_dereference_raw(*slot);
 		if (!results[ret])
 			continue;
-		if (radix_tree_is_indirect_ptr(results[ret])) {
+		if (radix_tree_is_internal_node(results[ret])) {
 			slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
@@ -1235,7 +1235,7 @@ radix_tree_gang_lookup_tag(struct radix_
 		results[ret] = rcu_dereference_raw(*slot);
 		if (!results[ret])
 			continue;
-		if (radix_tree_is_indirect_ptr(results[ret])) {
+		if (radix_tree_is_internal_node(results[ret])) {
 			slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
@@ -1312,7 +1312,7 @@ static unsigned long __locate(struct rad
 					rcu_dereference_raw(slot->slots[i]);
 			if (node == RADIX_TREE_RETRY)
 				goto out;
-			if (!radix_tree_is_indirect_ptr(node)) {
+			if (!radix_tree_is_internal_node(node)) {
 				if (node == item) {
 					info->found_index = index;
 					info->stop = true;
@@ -1358,7 +1358,7 @@ unsigned long radix_tree_locate_item(str
 	do {
 		rcu_read_lock();
 		node = rcu_dereference_raw(root->rnode);
-		if (!radix_tree_is_indirect_ptr(node)) {
+		if (!radix_tree_is_internal_node(node)) {
 			rcu_read_unlock();
 			if (node == item)
 				info.found_index = 0;
@@ -1399,7 +1399,7 @@ static inline bool radix_tree_shrink(str
 		struct radix_tree_node *to_free = root->rnode;
 		struct radix_tree_node *slot;
 
-		if (!radix_tree_is_indirect_ptr(to_free))
+		if (!radix_tree_is_internal_node(to_free))
 			break;
 		to_free = entry_to_node(to_free);
 
@@ -1413,10 +1413,10 @@ static inline bool radix_tree_shrink(str
 		slot = to_free->slots[0];
 		if (!slot)
 			break;
-		if (!radix_tree_is_indirect_ptr(slot) && to_free->shift)
+		if (!radix_tree_is_internal_node(slot) && to_free->shift)
 			break;
 
-		if (radix_tree_is_indirect_ptr(slot))
+		if (radix_tree_is_internal_node(slot))
 			entry_to_node(slot)->parent = NULL;
 
 		/*
@@ -1446,7 +1446,7 @@ static inline bool radix_tree_shrink(str
 		 * also results in a stale slot). So tag the slot as indirect
 		 * to force callers to retry.
 		 */
-		if (!radix_tree_is_indirect_ptr(slot))
+		if (!radix_tree_is_internal_node(slot))
 			to_free->slots[0] = RADIX_TREE_RETRY;
 
 		radix_tree_node_free(to_free);
diff -puN tools/testing/radix-tree/test.c~radix-tree-rename-radix_tree_is_indirect_ptr tools/testing/radix-tree/test.c
--- a/tools/testing/radix-tree/test.c~radix-tree-rename-radix_tree_is_indirect_ptr
+++ a/tools/testing/radix-tree/test.c
@@ -193,7 +193,7 @@ static int verify_node(struct radix_tree
 void verify_tag_consistency(struct radix_tree_root *root, unsigned int tag)
 {
 	struct radix_tree_node *node = root->rnode;
-	if (!radix_tree_is_indirect_ptr(node))
+	if (!radix_tree_is_internal_node(node))
 		return;
 	verify_node(node, tag, !!root_tag_get(root, tag));
 }
@@ -222,7 +222,7 @@ void tree_verify_min_height(struct radix
 {
 	unsigned shift;
 	struct radix_tree_node *node = root->rnode;
-	if (!radix_tree_is_indirect_ptr(node)) {
+	if (!radix_tree_is_internal_node(node)) {
 		assert(maxindex == 0);
 		return;
 	}
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-introduce-radix_tree_empty.patch
radix-tree-test-suite-fix-build.patch
radix-tree-test-suite-add-tests-for-radix_tree_locate_item.patch
introduce-config_radix_tree_multiorder.patch
radix-tree-add-missing-sibling-entry-functionality.patch
radix-tree-fix-sibling-entry-insertion.patch
radix-tree-fix-deleting-a-multi-order-entry-through-an-alias.patch
radix-tree-remove-restriction-on-multi-order-entries.patch
radix-tree-introduce-radix_tree_load_root.patch
radix-tree-fix-extending-the-tree-for-multi-order-entries-at-offset-0.patch
radix-tree-test-suite-start-adding-multiorder-tests.patch
radix-tree-fix-several-shrinking-bugs-with-multiorder-entries.patch
radix-tree-rewrite-__radix_tree_lookup.patch
radix-tree-fix-multiorder-bug_on-in-radix_tree_insert.patch
radix-tree-fix-radix_tree_create-for-sibling-entries.patch
radix-tree-rewrite-radix_tree_locate_item.patch
radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries.patch
radix-tree-add-copyright-statements.patch
drivers-hwspinlock-use-correct-radix-tree-api.patch
radix-tree-miscellaneous-fixes.patch
radix-tree-split-node-path-into-offset-and-height.patch
radix-tree-replace-node-height-with-node-shift.patch
radix-tree-remove-a-use-of-root-height-from-delete_node.patch
radix-tree-test-suite-remove-dependencies-on-height.patch
radix-tree-remove-root-height.patch
radix-tree-rename-indirect_ptr-to-internal_node.patch
radix-tree-rename-ptr_to_indirect-to-node_to_entry.patch
radix-tree-rename-indirect_to_ptr-to-entry_to_node.patch
radix-tree-rename-radix_tree_is_indirect_ptr.patch
radix-tree-change-naming-conventions-in-radix_tree_shrink.patch
radix-tree-tidy-up-next_chunk.patch
radix-tree-tidy-up-range_tag_if_tagged.patch
radix-tree-tidy-up-__radix_tree_create.patch
radix-tree-introduce-radix_tree_replace_clear_tags.patch
radix-tree-make-radix_tree_descend-more-useful.patch
radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse.patch

