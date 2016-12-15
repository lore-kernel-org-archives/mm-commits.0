From: akpm@linux-foundation.org
Subject: [merged] radix-tree-add-radix_tree_join.patch removed from -mm
 tree
Date: Thu, 15 Dec 2016 10:48:58 -0800
Message-ID: <5852e59a.U6tYRRCsuYdQ6PY1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49568 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753928AbcLOSs7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:48:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: add radix_tree_join
has been removed from the -mm tree.  Its filename was
     radix-tree-add-radix_tree_join.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: add radix_tree_join

This new function allows for the replacement of many smaller entries in
the radix tree with one larger multiorder entry.  From the point of view
of an RCU walker, they may see a mixture of the smaller entries and the
large entry during the same walk, but they will never see NULL for an
index which was populated before the join.

Link: http://lkml.kernel.org/r/1480369871-5271-58-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h            |    3 
 lib/radix-tree.c                      |  183 +++++++++++++++++++-----
 tools/testing/radix-tree/multiorder.c |   58 +++++++
 3 files changed, 213 insertions(+), 31 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-add-radix_tree_join include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-add-radix_tree_join
+++ a/include/linux/radix-tree.h
@@ -335,6 +335,9 @@ static inline void radix_tree_preload_en
 	preempt_enable();
 }
 
+int radix_tree_join(struct radix_tree_root *, unsigned long index,
+			unsigned new_order, void *);
+
 #define RADIX_TREE_ITER_TAG_MASK	0x00FF	/* tag index in lower byte */
 #define RADIX_TREE_ITER_TAGGED		0x0100	/* lookup tagged slots */
 #define RADIX_TREE_ITER_CONTIG		0x0200	/* stop at first hole */
diff -puN lib/radix-tree.c~radix-tree-add-radix_tree_join lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-add-radix_tree_join
+++ a/lib/radix-tree.c
@@ -339,17 +339,14 @@ static void radix_tree_node_rcu_free(str
 {
 	struct radix_tree_node *node =
 			container_of(head, struct radix_tree_node, rcu_head);
-	int i;
 
 	/*
-	 * must only free zeroed nodes into the slab. radix_tree_shrink
-	 * can leave us with a non-NULL entry in the first slot, so clear
-	 * that here to make sure.
+	 * Must only free zeroed nodes into the slab.  We can be left with
+	 * non-NULL entries by radix_tree_free_nodes, so clear the entries
+	 * and tags here.
 	 */
-	for (i = 0; i < RADIX_TREE_MAX_TAGS; i++)
-		tag_clear(node, i, 0);
-
-	node->slots[0] = NULL;
+	memset(node->slots, 0, sizeof(node->slots));
+	memset(node->tags, 0, sizeof(node->tags));
 	INIT_LIST_HEAD(&node->private_list);
 
 	kmem_cache_free(radix_tree_node_cachep, node);
@@ -678,14 +675,14 @@ int __radix_tree_create(struct radix_tre
 	shift = radix_tree_load_root(root, &child, &maxindex);
 
 	/* Make sure the tree is high enough.  */
+	if (order > 0 && max == ((1UL << order) - 1))
+		max++;
 	if (max > maxindex) {
 		int error = radix_tree_extend(root, max, shift);
 		if (error < 0)
 			return error;
 		shift = error;
 		child = root->rnode;
-		if (order == shift)
-			shift += RADIX_TREE_MAP_SHIFT;
 	}
 
 	while (shift > order) {
@@ -697,6 +694,8 @@ int __radix_tree_create(struct radix_tre
 				return -ENOMEM;
 			child->shift = shift;
 			child->offset = offset;
+			child->count = 0;
+			child->exceptional = 0;
 			child->parent = node;
 			rcu_assign_pointer(*slot, node_to_entry(child));
 			if (node)
@@ -710,31 +709,121 @@ int __radix_tree_create(struct radix_tre
 		slot = &node->slots[offset];
 	}
 
+	if (nodep)
+		*nodep = node;
+	if (slotp)
+		*slotp = slot;
+	return 0;
+}
+
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
-	/* Insert pointers to the canonical entry */
-	if (order > shift) {
-		unsigned i, n = 1 << (order - shift);
+/*
+ * Free any nodes below this node.  The tree is presumed to not need
+ * shrinking, and any user data in the tree is presumed to not need a
+ * destructor called on it.  If we need to add a destructor, we can
+ * add that functionality later.  Note that we may not clear tags or
+ * slots from the tree as an RCU walker may still have a pointer into
+ * this subtree.  We could replace the entries with RADIX_TREE_RETRY,
+ * but we'll still have to clear those in rcu_free.
+ */
+static void radix_tree_free_nodes(struct radix_tree_node *node)
+{
+	unsigned offset = 0;
+	struct radix_tree_node *child = entry_to_node(node);
+
+	for (;;) {
+		void *entry = child->slots[offset];
+		if (radix_tree_is_internal_node(entry) &&
+					!is_sibling_entry(child, entry)) {
+			child = entry_to_node(entry);
+			offset = 0;
+			continue;
+		}
+		offset++;
+		while (offset == RADIX_TREE_MAP_SIZE) {
+			struct radix_tree_node *old = child;
+			offset = child->offset + 1;
+			child = child->parent;
+			radix_tree_node_free(old);
+			if (old == entry_to_node(node))
+				return;
+		}
+	}
+}
+
+static inline int insert_entries(struct radix_tree_node *node, void **slot,
+				void *item, unsigned order, bool replace)
+{
+	struct radix_tree_node *child;
+	unsigned i, n, tag, offset, tags = 0;
+
+	if (node) {
+		n = 1 << (order - node->shift);
+		offset = get_slot_offset(node, slot);
+	} else {
+		n = 1;
+		offset = 0;
+	}
+
+	if (n > 1) {
 		offset = offset & ~(n - 1);
 		slot = &node->slots[offset];
-		child = node_to_entry(slot);
-		for (i = 0; i < n; i++) {
-			if (slot[i])
+	}
+	child = node_to_entry(slot);
+
+	for (i = 0; i < n; i++) {
+		if (slot[i]) {
+			if (replace) {
+				node->count--;
+				for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
+					if (tag_get(node, tag, offset + i))
+						tags |= 1 << tag;
+			} else
 				return -EEXIST;
 		}
+	}
 
-		for (i = 1; i < n; i++) {
+	for (i = 0; i < n; i++) {
+		struct radix_tree_node *old = slot[i];
+		if (i) {
 			rcu_assign_pointer(slot[i], child);
-			node->count++;
+			for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
+				if (tags & (1 << tag))
+					tag_clear(node, tag, offset + i);
+		} else {
+			rcu_assign_pointer(slot[i], item);
+			for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
+				if (tags & (1 << tag))
+					tag_set(node, tag, offset);
 		}
+		if (radix_tree_is_internal_node(old) &&
+					!is_sibling_entry(node, old))
+			radix_tree_free_nodes(old);
+		if (radix_tree_exceptional_entry(old))
+			node->exceptional--;
 	}
-#endif
-
-	if (nodep)
-		*nodep = node;
-	if (slotp)
-		*slotp = slot;
-	return 0;
+	if (node) {
+		node->count += n;
+		if (radix_tree_exceptional_entry(item))
+			node->exceptional += n;
+	}
+	return n;
+}
+#else
+static inline int insert_entries(struct radix_tree_node *node, void **slot,
+				void *item, unsigned order, bool replace)
+{
+	if (*slot)
+		return -EEXIST;
+	rcu_assign_pointer(*slot, item);
+	if (node) {
+		node->count++;
+		if (radix_tree_exceptional_entry(item))
+			node->exceptional++;
+	}
+	return 1;
 }
+#endif
 
 /**
  *	__radix_tree_insert    -    insert into a radix tree
@@ -757,15 +846,13 @@ int __radix_tree_insert(struct radix_tre
 	error = __radix_tree_create(root, index, order, &node, &slot);
 	if (error)
 		return error;
-	if (*slot != NULL)
-		return -EEXIST;
-	rcu_assign_pointer(*slot, item);
+
+	error = insert_entries(node, slot, item, order, false);
+	if (error < 0)
+		return error;
 
 	if (node) {
 		unsigned offset = get_slot_offset(node, slot);
-		node->count++;
-		if (radix_tree_exceptional_entry(item))
-			node->exceptional++;
 		BUG_ON(tag_get(node, 0, offset));
 		BUG_ON(tag_get(node, 1, offset));
 		BUG_ON(tag_get(node, 2, offset));
@@ -942,6 +1029,40 @@ void radix_tree_replace_slot(struct radi
 	replace_slot(root, NULL, slot, item, true);
 }
 
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+/**
+ * radix_tree_join - replace multiple entries with one multiorder entry
+ * @root: radix tree root
+ * @index: an index inside the new entry
+ * @order: order of the new entry
+ * @item: new entry
+ *
+ * Call this function to replace several entries with one larger entry.
+ * The existing entries are presumed to not need freeing as a result of
+ * this call.
+ *
+ * The replacement entry will have all the tags set on it that were set
+ * on any of the entries it is replacing.
+ */
+int radix_tree_join(struct radix_tree_root *root, unsigned long index,
+			unsigned order, void *item)
+{
+	struct radix_tree_node *node;
+	void **slot;
+	int error;
+
+	BUG_ON(radix_tree_is_internal_node(item));
+
+	error = __radix_tree_create(root, index, order, &node, &slot);
+	if (!error)
+		error = insert_entries(node, slot, item, order, true);
+	if (error > 0)
+		error = 0;
+
+	return error;
+}
+#endif
+
 /**
  *	radix_tree_tag_set - set a tag on a radix tree node
  *	@root:		radix tree root
diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-add-radix_tree_join tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-add-radix_tree_join
+++ a/tools/testing/radix-tree/multiorder.c
@@ -332,6 +332,63 @@ void multiorder_tagged_iteration(void)
 	item_kill_tree(&tree);
 }
 
+static void __multiorder_join(unsigned long index,
+				unsigned order1, unsigned order2)
+{
+	unsigned long loc;
+	void *item, *item2 = item_create(index + 1, order1);
+	RADIX_TREE(tree, GFP_KERNEL);
+
+	item_insert_order(&tree, index, order2);
+	item = radix_tree_lookup(&tree, index);
+	radix_tree_join(&tree, index + 1, order1, item2);
+	loc = find_item(&tree, item);
+	if (loc == -1)
+		free(item);
+	item = radix_tree_lookup(&tree, index + 1);
+	assert(item == item2);
+	item_kill_tree(&tree);
+}
+
+static void __multiorder_join2(unsigned order1, unsigned order2)
+{
+	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_node *node;
+	void *item1 = item_create(0, order1);
+	void *item2;
+
+	item_insert_order(&tree, 0, order2);
+	radix_tree_insert(&tree, 1 << order2, (void *)0x12UL);
+	item2 = __radix_tree_lookup(&tree, 1 << order2, &node, NULL);
+	assert(item2 == (void *)0x12UL);
+	assert(node->exceptional == 1);
+
+	radix_tree_join(&tree, 0, order1, item1);
+	item2 = __radix_tree_lookup(&tree, 1 << order2, &node, NULL);
+	assert(item2 == item1);
+	assert(node->exceptional == 0);
+	item_kill_tree(&tree);
+}
+
+static void multiorder_join(void)
+{
+	int i, j, idx;
+
+	for (idx = 0; idx < 1024; idx = idx * 2 + 3) {
+		for (i = 1; i < 15; i++) {
+			for (j = 0; j < i; j++) {
+				__multiorder_join(idx, i, j);
+			}
+		}
+	}
+
+	for (i = 1; i < 15; i++) {
+		for (j = 0; j < i; j++) {
+			__multiorder_join2(i, j);
+		}
+	}
+}
+
 void multiorder_checks(void)
 {
 	int i;
@@ -349,4 +406,5 @@ void multiorder_checks(void)
 	multiorder_tag_tests();
 	multiorder_iteration();
 	multiorder_tagged_iteration();
+	multiorder_join();
 }
_

Patches currently in -mm which might be from willy@linux.intel.com are

reimplement-idr-and-ida-using-the-radix-tree.patch

