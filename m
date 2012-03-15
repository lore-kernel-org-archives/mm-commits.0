From: akpm@linux-foundation.org
Subject: + radix-tree-rewrite-gang-lookup-with-using-iterator.patch added to -mm tree
Date: Wed, 14 Mar 2012 17:44:34 -0700
Message-ID: <20120315004435.0DA88A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37472 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031375Ab2COAog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Mar 2012 20:44:36 -0400
Received: by yhgm50 with SMTP id m50so405832yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 17:44:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hch@lst.de, hughd@google.com, torvalds@linux-foundation.org


The patch titled
     Subject: radix-tree: rewrite gang lookup using iterator
has been added to the -mm tree.  Its filename is
     radix-tree-rewrite-gang-lookup-with-using-iterator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: radix-tree: rewrite gang lookup using iterator

Rewrite radix_tree_gang_lookup_* functions using the new radix-tree
iterator.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |  291 +++++----------------------------------------
 1 file changed, 33 insertions(+), 258 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-rewrite-gang-lookup-with-using-iterator lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rewrite-gang-lookup-with-using-iterator
+++ a/lib/radix-tree.c
@@ -964,57 +964,6 @@ unsigned long radix_tree_prev_hole(struc
 }
 EXPORT_SYMBOL(radix_tree_prev_hole);
 
-static unsigned int
-__lookup(struct radix_tree_node *slot, void ***results, unsigned long *indices,
-	unsigned long index, unsigned int max_items, unsigned long *next_index)
-{
-	unsigned int nr_found = 0;
-	unsigned int shift, height;
-	unsigned long i;
-
-	height = slot->height;
-	if (height == 0)
-		goto out;
-	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
-
-	for ( ; height > 1; height--) {
-		i = (index >> shift) & RADIX_TREE_MAP_MASK;
-		for (;;) {
-			if (slot->slots[i] != NULL)
-				break;
-			index &= ~((1UL << shift) - 1);
-			index += 1UL << shift;
-			if (index == 0)
-				goto out;	/* 32-bit wraparound */
-			i++;
-			if (i == RADIX_TREE_MAP_SIZE)
-				goto out;
-		}
-
-		shift -= RADIX_TREE_MAP_SHIFT;
-		slot = rcu_dereference_raw(slot->slots[i]);
-		if (slot == NULL)
-			goto out;
-	}
-
-	/* Bottom level: grab some items */
-	for (i = index & RADIX_TREE_MAP_MASK; i < RADIX_TREE_MAP_SIZE; i++) {
-		if (slot->slots[i]) {
-			results[nr_found] = &(slot->slots[i]);
-			if (indices)
-				indices[nr_found] = index;
-			if (++nr_found == max_items) {
-				index++;
-				goto out;
-			}
-		}
-		index++;
-	}
-out:
-	*next_index = index;
-	return nr_found;
-}
-
 /**
  *	radix_tree_gang_lookup - perform multiple lookup on a radix tree
  *	@root:		radix tree root
@@ -1038,48 +987,19 @@ unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			unsigned long first_index, unsigned int max_items)
 {
-	unsigned long max_index;
-	struct radix_tree_node *node;
-	unsigned long cur_index = first_index;
-	unsigned int ret;
+	struct radix_tree_iter iter;
+	void **slot;
+	unsigned int ret = 0;
 
-	node = rcu_dereference_raw(root->rnode);
-	if (!node)
+	if (unlikely(!max_items))
 		return 0;
 
-	if (!radix_tree_is_indirect_ptr(node)) {
-		if (first_index > 0)
-			return 0;
-		results[0] = node;
-		return 1;
-	}
-	node = indirect_to_ptr(node);
-
-	max_index = radix_tree_maxindex(node->height);
-
-	ret = 0;
-	while (ret < max_items) {
-		unsigned int nr_found, slots_found, i;
-		unsigned long next_index;	/* Index of next search */
-
-		if (cur_index > max_index)
-			break;
-		slots_found = __lookup(node, (void ***)results + ret, NULL,
-				cur_index, max_items - ret, &next_index);
-		nr_found = 0;
-		for (i = 0; i < slots_found; i++) {
-			struct radix_tree_node *slot;
-			slot = *(((void ***)results)[ret + i]);
-			if (!slot)
-				continue;
-			results[ret + nr_found] =
-				indirect_to_ptr(rcu_dereference_raw(slot));
-			nr_found++;
-		}
-		ret += nr_found;
-		if (next_index == 0)
+	radix_tree_for_each_slot(slot, root, &iter, first_index) {
+		results[ret] = indirect_to_ptr(rcu_dereference_raw(*slot));
+		if (!results[ret])
+			continue;
+		if (++ret == max_items)
 			break;
-		cur_index = next_index;
 	}
 
 	return ret;
@@ -1109,112 +1029,25 @@ radix_tree_gang_lookup_slot(struct radix
 			void ***results, unsigned long *indices,
 			unsigned long first_index, unsigned int max_items)
 {
-	unsigned long max_index;
-	struct radix_tree_node *node;
-	unsigned long cur_index = first_index;
-	unsigned int ret;
+	struct radix_tree_iter iter;
+	void **slot;
+	unsigned int ret = 0;
 
-	node = rcu_dereference_raw(root->rnode);
-	if (!node)
+	if (unlikely(!max_items))
 		return 0;
 
-	if (!radix_tree_is_indirect_ptr(node)) {
-		if (first_index > 0)
-			return 0;
-		results[0] = (void **)&root->rnode;
+	radix_tree_for_each_slot(slot, root, &iter, first_index) {
+		results[ret] = slot;
 		if (indices)
-			indices[0] = 0;
-		return 1;
-	}
-	node = indirect_to_ptr(node);
-
-	max_index = radix_tree_maxindex(node->height);
-
-	ret = 0;
-	while (ret < max_items) {
-		unsigned int slots_found;
-		unsigned long next_index;	/* Index of next search */
-
-		if (cur_index > max_index)
-			break;
-		slots_found = __lookup(node, results + ret,
-				indices ? indices + ret : NULL,
-				cur_index, max_items - ret, &next_index);
-		ret += slots_found;
-		if (next_index == 0)
+			indices[ret] = iter.index;
+		if (++ret == max_items)
 			break;
-		cur_index = next_index;
 	}
 
 	return ret;
 }
 EXPORT_SYMBOL(radix_tree_gang_lookup_slot);
 
-/*
- * FIXME: the two tag_get()s here should use find_next_bit() instead of
- * open-coding the search.
- */
-static unsigned int
-__lookup_tag(struct radix_tree_node *slot, void ***results, unsigned long index,
-	unsigned int max_items, unsigned long *next_index, unsigned int tag)
-{
-	unsigned int nr_found = 0;
-	unsigned int shift, height;
-
-	height = slot->height;
-	if (height == 0)
-		goto out;
-	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
-
-	while (height > 0) {
-		unsigned long i = (index >> shift) & RADIX_TREE_MAP_MASK ;
-
-		for (;;) {
-			if (tag_get(slot, tag, i))
-				break;
-			index &= ~((1UL << shift) - 1);
-			index += 1UL << shift;
-			if (index == 0)
-				goto out;	/* 32-bit wraparound */
-			i++;
-			if (i == RADIX_TREE_MAP_SIZE)
-				goto out;
-		}
-		height--;
-		if (height == 0) {	/* Bottom level: grab some items */
-			unsigned long j = index & RADIX_TREE_MAP_MASK;
-
-			for ( ; j < RADIX_TREE_MAP_SIZE; j++) {
-				index++;
-				if (!tag_get(slot, tag, j))
-					continue;
-				/*
-				 * Even though the tag was found set, we need to
-				 * recheck that we have a non-NULL node, because
-				 * if this lookup is lockless, it may have been
-				 * subsequently deleted.
-				 *
-				 * Similar care must be taken in any place that
-				 * lookup ->slots[x] without a lock (ie. can't
-				 * rely on its value remaining the same).
-				 */
-				if (slot->slots[j]) {
-					results[nr_found++] = &(slot->slots[j]);
-					if (nr_found == max_items)
-						goto out;
-				}
-			}
-		}
-		shift -= RADIX_TREE_MAP_SHIFT;
-		slot = rcu_dereference_raw(slot->slots[i]);
-		if (slot == NULL)
-			break;
-	}
-out:
-	*next_index = index;
-	return nr_found;
-}
-
 /**
  *	radix_tree_gang_lookup_tag - perform multiple lookup on a radix tree
  *	                             based on a tag
@@ -1233,52 +1066,19 @@ radix_tree_gang_lookup_tag(struct radix_
 		unsigned long first_index, unsigned int max_items,
 		unsigned int tag)
 {
-	struct radix_tree_node *node;
-	unsigned long max_index;
-	unsigned long cur_index = first_index;
-	unsigned int ret;
+	struct radix_tree_iter iter;
+	void **slot;
+	unsigned int ret = 0;
 
-	/* check the root's tag bit */
-	if (!root_tag_get(root, tag))
+	if (unlikely(!max_items))
 		return 0;
 
-	node = rcu_dereference_raw(root->rnode);
-	if (!node)
-		return 0;
-
-	if (!radix_tree_is_indirect_ptr(node)) {
-		if (first_index > 0)
-			return 0;
-		results[0] = node;
-		return 1;
-	}
-	node = indirect_to_ptr(node);
-
-	max_index = radix_tree_maxindex(node->height);
-
-	ret = 0;
-	while (ret < max_items) {
-		unsigned int nr_found, slots_found, i;
-		unsigned long next_index;	/* Index of next search */
-
-		if (cur_index > max_index)
+	radix_tree_for_each_tagged(slot, root, &iter, first_index, tag) {
+		results[ret] = indirect_to_ptr(rcu_dereference_raw(*slot));
+		if (!results[ret])
+			continue;
+		if (++ret == max_items)
 			break;
-		slots_found = __lookup_tag(node, (void ***)results + ret,
-				cur_index, max_items - ret, &next_index, tag);
-		nr_found = 0;
-		for (i = 0; i < slots_found; i++) {
-			struct radix_tree_node *slot;
-			slot = *(((void ***)results)[ret + i]);
-			if (!slot)
-				continue;
-			results[ret + nr_found] =
-				indirect_to_ptr(rcu_dereference_raw(slot));
-			nr_found++;
-		}
-		ret += nr_found;
-		if (next_index == 0)
-			break;
-		cur_index = next_index;
 	}
 
 	return ret;
@@ -1303,42 +1103,17 @@ radix_tree_gang_lookup_tag_slot(struct r
 		unsigned long first_index, unsigned int max_items,
 		unsigned int tag)
 {
-	struct radix_tree_node *node;
-	unsigned long max_index;
-	unsigned long cur_index = first_index;
-	unsigned int ret;
-
-	/* check the root's tag bit */
-	if (!root_tag_get(root, tag))
-		return 0;
+	struct radix_tree_iter iter;
+	void **slot;
+	unsigned int ret = 0;
 
-	node = rcu_dereference_raw(root->rnode);
-	if (!node)
+	if (unlikely(!max_items))
 		return 0;
 
-	if (!radix_tree_is_indirect_ptr(node)) {
-		if (first_index > 0)
-			return 0;
-		results[0] = (void **)&root->rnode;
-		return 1;
-	}
-	node = indirect_to_ptr(node);
-
-	max_index = radix_tree_maxindex(node->height);
-
-	ret = 0;
-	while (ret < max_items) {
-		unsigned int slots_found;
-		unsigned long next_index;	/* Index of next search */
-
-		if (cur_index > max_index)
-			break;
-		slots_found = __lookup_tag(node, results + ret,
-				cur_index, max_items - ret, &next_index, tag);
-		ret += slots_found;
-		if (next_index == 0)
+	radix_tree_for_each_tagged(slot, root, &iter, first_index, tag) {
+		results[ret] = slot;
+		if (++ret == max_items)
 			break;
-		cur_index = next_index;
 	}
 
 	return ret;
_
Subject: Subject: radix-tree: rewrite gang lookup using iterator

Patches currently in -mm which might be from khlebnikov@openvz.org are

memcg-free-mem_cgroup-by-rcu-to-fix-oops.patch
linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-make-get_mm_counter-static-inline.patch
mm-replace-page_migration-with-is_enabledconfig_migration.patch
mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
memcg-remove-pcg_cache-page_cgroup-flag-fix.patch
memcg-kill-dead-prev_priority-stubs.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch

