From: akpm@linux-foundation.org
Subject: + radix-tree-fix-replacement-for-multiorder-entries.patch added
 to -mm tree
Date: Tue, 06 Dec 2016 12:51:05 -0800
Message-ID: <584724b9.SFbP19rPounmfUKU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37028 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752117AbcLFUuf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:50:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix replacement for multiorder entries
has been added to the -mm tree.  Its filename is
     radix-tree-fix-replacement-for-multiorder-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-fix-replacement-for-multiorder-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-fix-replacement-for-multiorder-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: radix-tree: fix replacement for multiorder entries

When replacing an entry with NULL, we need to delete any sibling entries. 
Also account deleting exceptional entries properly.  Also fix a bug with
radix_tree_iter_replace() where we would fail to remove entirely freed
nodes.  Also fix accounting bug when switching between normal and
exceptional entries with replace_slot.  Also add testcases for all these
bugs.

Link: http://lkml.kernel.org/r/1480369871-5271-61-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                      |   60 ++++++++++++----
 tools/testing/radix-tree/multiorder.c |   87 ++++++++++++++++++++----
 2 files changed, 119 insertions(+), 28 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-replacement-for-multiorder-entries lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-replacement-for-multiorder-entries
+++ a/lib/radix-tree.c
@@ -976,6 +976,24 @@ void *radix_tree_lookup(struct radix_tre
 }
 EXPORT_SYMBOL(radix_tree_lookup);
 
+static inline int slot_count(struct radix_tree_node *node,
+						void **slot)
+{
+	int n = 1;
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+	void *ptr = node_to_entry(slot);
+	unsigned offset = get_slot_offset(node, slot);
+	int i;
+
+	for (i = 1; offset + i < RADIX_TREE_MAP_SIZE; i++) {
+		if (node->slots[offset + i] != ptr)
+			break;
+		n++;
+	}
+#endif
+	return n;
+}
+
 static void replace_slot(struct radix_tree_root *root,
 			 struct radix_tree_node *node,
 			 void **slot, void *item,
@@ -994,12 +1012,35 @@ static void replace_slot(struct radix_tr
 
 	if (node) {
 		node->count += count;
-		node->exceptional += exceptional;
+		if (exceptional) {
+			exceptional *= slot_count(node, slot);
+			node->exceptional += exceptional;
+		}
 	}
 
 	rcu_assign_pointer(*slot, item);
 }
 
+static inline void delete_sibling_entries(struct radix_tree_node *node,
+						void **slot)
+{
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+	bool exceptional = radix_tree_exceptional_entry(*slot);
+	void *ptr = node_to_entry(slot);
+	unsigned offset = get_slot_offset(node, slot);
+	int i;
+
+	for (i = 1; offset + i < RADIX_TREE_MAP_SIZE; i++) {
+		if (node->slots[offset + i] != ptr)
+			break;
+		node->slots[offset + i] = NULL;
+		node->count--;
+		if (exceptional)
+			node->exceptional--;
+	}
+#endif
+}
+
 /**
  * __radix_tree_replace		- replace item in a slot
  * @root:		radix tree root
@@ -1017,6 +1058,8 @@ void __radix_tree_replace(struct radix_t
 			  void **slot, void *item,
 			  radix_tree_update_node_t update_node, void *private)
 {
+	if (!item)
+		delete_sibling_entries(node, slot);
 	/*
 	 * This function supports replacing exceptional entries and
 	 * deleting entries, but that needs accounting against the
@@ -1793,20 +1836,6 @@ void __radix_tree_delete_node(struct rad
 	delete_node(root, node, NULL, NULL);
 }
 
-static inline void delete_sibling_entries(struct radix_tree_node *node,
-					void *ptr, unsigned offset)
-{
-#ifdef CONFIG_RADIX_TREE_MULTIORDER
-	int i;
-	for (i = 1; offset + i < RADIX_TREE_MAP_SIZE; i++) {
-		if (node->slots[offset + i] != ptr)
-			break;
-		node->slots[offset + i] = NULL;
-		node->count--;
-	}
-#endif
-}
-
 /**
  *	radix_tree_delete_item    -    delete an item from a radix tree
  *	@root:		radix tree root
@@ -1846,7 +1875,6 @@ void *radix_tree_delete_item(struct radi
 	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
 		node_tag_clear(root, node, tag, offset);
 
-	delete_sibling_entries(node, node_to_entry(slot), offset);
 	__radix_tree_replace(root, node, slot, NULL, NULL, NULL);
 
 	return entry;
diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-fix-replacement-for-multiorder-entries tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-fix-replacement-for-multiorder-entries
+++ a/tools/testing/radix-tree/multiorder.c
@@ -410,8 +410,6 @@ static void __multiorder_split(int old_o
 	RADIX_TREE(tree, GFP_ATOMIC);
 	void **slot;
 	struct radix_tree_iter iter;
-	struct radix_tree_node *node;
-	void *item;
 	unsigned alloc;
 
 	radix_tree_preload(GFP_KERNEL);
@@ -434,58 +432,122 @@ static void __multiorder_split(int old_o
 	radix_tree_preload_end();
 
 	item_kill_tree(&tree);
+}
+
+static void __multiorder_split2(int old_order, int new_order)
+{
+	RADIX_TREE(tree, GFP_KERNEL);
+	void **slot;
+	struct radix_tree_iter iter;
+	struct radix_tree_node *node;
+	void *item;
 
-	radix_tree_preload(GFP_KERNEL);
 	__radix_tree_insert(&tree, 0, old_order, (void *)0x12);
-	radix_tree_preload_end();
 
 	item = __radix_tree_lookup(&tree, 0, &node, NULL);
 	assert(item == (void *)0x12);
 	assert(node->exceptional > 0);
 
-	radix_tree_split_preload(old_order, new_order, GFP_KERNEL);
 	radix_tree_split(&tree, 0, new_order);
 	radix_tree_for_each_slot(slot, &tree, &iter, 0) {
 		radix_tree_iter_replace(&tree, &iter, slot,
 					item_create(iter.index, new_order));
 	}
-	radix_tree_preload_end();
 
 	item = __radix_tree_lookup(&tree, 0, &node, NULL);
 	assert(item != (void *)0x12);
 	assert(node->exceptional == 0);
 
 	item_kill_tree(&tree);
+}
+
+static void __multiorder_split3(int old_order, int new_order)
+{
+	RADIX_TREE(tree, GFP_KERNEL);
+	void **slot;
+	struct radix_tree_iter iter;
+	struct radix_tree_node *node;
+	void *item;
 
-	radix_tree_preload(GFP_KERNEL);
 	__radix_tree_insert(&tree, 0, old_order, (void *)0x12);
-	radix_tree_preload_end();
 
 	item = __radix_tree_lookup(&tree, 0, &node, NULL);
 	assert(item == (void *)0x12);
 	assert(node->exceptional > 0);
 
-	radix_tree_split_preload(old_order, new_order, GFP_KERNEL);
 	radix_tree_split(&tree, 0, new_order);
 	radix_tree_for_each_slot(slot, &tree, &iter, 0) {
 		radix_tree_iter_replace(&tree, &iter, slot, (void *)0x16);
 	}
-	radix_tree_preload_end();
 
 	item = __radix_tree_lookup(&tree, 0, &node, NULL);
 	assert(item == (void *)0x16);
 	assert(node->exceptional > 0);
 
 	item_kill_tree(&tree);
+
+	__radix_tree_insert(&tree, 0, old_order, (void *)0x12);
+
+	item = __radix_tree_lookup(&tree, 0, &node, NULL);
+	assert(item == (void *)0x12);
+	assert(node->exceptional > 0);
+
+	radix_tree_split(&tree, 0, new_order);
+	radix_tree_for_each_slot(slot, &tree, &iter, 0) {
+		if (iter.index == (1 << new_order))
+			radix_tree_iter_replace(&tree, &iter, slot,
+						(void *)0x16);
+		else
+			radix_tree_iter_replace(&tree, &iter, slot, NULL);
+	}
+
+	item = __radix_tree_lookup(&tree, 1 << new_order, &node, NULL);
+	assert(item == (void *)0x16);
+	assert(node->count == node->exceptional);
+	do {
+		node = node->parent;
+		if (!node)
+			break;
+		assert(node->count == 1);
+		assert(node->exceptional == 0);
+	} while (1);
+
+	item_kill_tree(&tree);
 }
 
 static void multiorder_split(void)
 {
 	int i, j;
 
-	for (i = 9; i < 19; i++)
-		for (j = 0; j < i; j++)
+	for (i = 3; i < 11; i++)
+		for (j = 0; j < i; j++) {
 			__multiorder_split(i, j);
+			__multiorder_split2(i, j);
+			__multiorder_split3(i, j);
+		}
+}
+
+static void multiorder_account(void)
+{
+	RADIX_TREE(tree, GFP_KERNEL);
+	struct radix_tree_node *node;
+	void **slot;
+
+	item_insert_order(&tree, 0, 5);
+
+	__radix_tree_insert(&tree, 1 << 5, 5, (void *)0x12);
+	__radix_tree_lookup(&tree, 0, &node, NULL);
+	assert(node->count == node->exceptional * 2);
+	radix_tree_delete(&tree, 1 << 5);
+	assert(node->exceptional == 0);
+
+	__radix_tree_insert(&tree, 1 << 5, 5, (void *)0x12);
+	__radix_tree_lookup(&tree, 1 << 5, &node, &slot);
+	assert(node->count == node->exceptional * 2);
+	__radix_tree_replace(&tree, node, slot, NULL, NULL, NULL);
+	assert(node->exceptional == 0);
+
+	item_kill_tree(&tree);
 }
 
 void multiorder_checks(void)
@@ -507,6 +569,7 @@ void multiorder_checks(void)
 	multiorder_tagged_iteration();
 	multiorder_join();
 	multiorder_split();
+	multiorder_account();
 
 	radix_tree_cpu_dead(0);
 }
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

radix-tree-test-suite-fix-compilation.patch
radix-tree-test-suite-iteration-test-misuses-rcu.patch
radix-tree-test-suite-use-rcu_barrier.patch
radix-tree-test-suite-handle-exceptional-entries.patch
radix-tree-test-suite-record-order-in-each-item.patch
btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch
radix-tree-improve-multiorder-iterators.patch
radix-tree-delete-radix_tree_locate_item.patch
radix-tree-delete-radix_tree_range_tag_if_tagged.patch
radix-tree-fix-replacement-for-multiorder-entries.patch
radix-tree-test-suite-check-multiorder-iteration.patch
tpm-use-idr_find-not-idr_find_slowpath.patch
rxrpc-abstract-away-knowledge-of-idr-internals.patch

