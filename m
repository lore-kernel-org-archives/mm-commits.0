From: akpm@linux-foundation.org
Subject: [merged]
 lib-radix-tree-update-callback-for-changing-leaf-nodes.patch removed from
 -mm tree
Date: Wed, 14 Dec 2016 11:25:35 -0800
Message-ID: <58519caf.82DQX/mfovfBLcHk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44516 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756564AbcLNTZg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@linuxonhyperv.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: radix-tree: update callback for changing leaf nodes
has been removed from the -mm tree.  Its filename was
     lib-radix-tree-update-callback-for-changing-leaf-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: lib: radix-tree: update callback for changing leaf nodes

Support handing __radix_tree_replace() a callback that gets invoked for
all leaf nodes that change or get freed as a result of the slot
replacement, to assist users tracking nodes with node->private_list.

This prepares for putting page cache shadow entries into the radix tree
root again and drastically simplifying the shadow tracking.

Link: http://lkml.kernel.org/r/20161117193134.GD23430@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <mawilcox@linuxonhyperv.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                   |    3 +-
 include/linux/radix-tree.h |    4 ++-
 lib/radix-tree.c           |   42 ++++++++++++++++++++++++-----------
 mm/shmem.c                 |    3 +-
 4 files changed, 36 insertions(+), 16 deletions(-)

diff -puN fs/dax.c~lib-radix-tree-update-callback-for-changing-leaf-nodes fs/dax.c
--- a/fs/dax.c~lib-radix-tree-update-callback-for-changing-leaf-nodes
+++ a/fs/dax.c
@@ -649,7 +649,8 @@ static void *dax_insert_mapping_entry(st
 
 		ret = __radix_tree_lookup(page_tree, index, &node, &slot);
 		WARN_ON_ONCE(ret != entry);
-		__radix_tree_replace(page_tree, node, slot, new_entry);
+		__radix_tree_replace(page_tree, node, slot,
+				     new_entry, NULL, NULL);
 	}
 	if (vmf->flags & FAULT_FLAG_WRITE)
 		radix_tree_tag_set(page_tree, index, PAGECACHE_TAG_DIRTY);
diff -puN include/linux/radix-tree.h~lib-radix-tree-update-callback-for-changing-leaf-nodes include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~lib-radix-tree-update-callback-for-changing-leaf-nodes
+++ a/include/linux/radix-tree.h
@@ -263,9 +263,11 @@ void *__radix_tree_lookup(struct radix_t
 			  struct radix_tree_node **nodep, void ***slotp);
 void *radix_tree_lookup(struct radix_tree_root *, unsigned long);
 void **radix_tree_lookup_slot(struct radix_tree_root *, unsigned long);
+typedef void (*radix_tree_update_node_t)(struct radix_tree_node *, void *);
 void __radix_tree_replace(struct radix_tree_root *root,
 			  struct radix_tree_node *node,
-			  void **slot, void *item);
+			  void **slot, void *item,
+			  radix_tree_update_node_t update_node, void *private);
 void radix_tree_replace_slot(struct radix_tree_root *root,
 			     void **slot, void *item);
 bool __radix_tree_delete_node(struct radix_tree_root *root,
diff -puN lib/radix-tree.c~lib-radix-tree-update-callback-for-changing-leaf-nodes lib/radix-tree.c
--- a/lib/radix-tree.c~lib-radix-tree-update-callback-for-changing-leaf-nodes
+++ a/lib/radix-tree.c
@@ -325,7 +325,6 @@ static void radix_tree_node_rcu_free(str
 		tag_clear(node, i, 0);
 
 	node->slots[0] = NULL;
-	node->count = 0;
 
 	kmem_cache_free(radix_tree_node_cachep, node);
 }
@@ -542,7 +541,9 @@ out:
  *	radix_tree_shrink    -    shrink radix tree to minimum height
  *	@root		radix tree root
  */
-static inline bool radix_tree_shrink(struct radix_tree_root *root)
+static inline bool radix_tree_shrink(struct radix_tree_root *root,
+				     radix_tree_update_node_t update_node,
+				     void *private)
 {
 	bool shrunk = false;
 
@@ -597,8 +598,12 @@ static inline bool radix_tree_shrink(str
 		 * also results in a stale slot). So tag the slot as indirect
 		 * to force callers to retry.
 		 */
-		if (!radix_tree_is_internal_node(child))
+		node->count = 0;
+		if (!radix_tree_is_internal_node(child)) {
 			node->slots[0] = RADIX_TREE_RETRY;
+			if (update_node)
+				update_node(node, private);
+		}
 
 		radix_tree_node_free(node);
 		shrunk = true;
@@ -608,7 +613,8 @@ static inline bool radix_tree_shrink(str
 }
 
 static bool delete_node(struct radix_tree_root *root,
-			struct radix_tree_node *node)
+			struct radix_tree_node *node,
+			radix_tree_update_node_t update_node, void *private)
 {
 	bool deleted = false;
 
@@ -617,7 +623,8 @@ static bool delete_node(struct radix_tre
 
 		if (node->count) {
 			if (node == entry_to_node(root->rnode))
-				deleted |= radix_tree_shrink(root);
+				deleted |= radix_tree_shrink(root, update_node,
+							     private);
 			return deleted;
 		}
 
@@ -880,17 +887,20 @@ static void replace_slot(struct radix_tr
 
 /**
  * __radix_tree_replace		- replace item in a slot
- * @root:	radix tree root
- * @node:	pointer to tree node
- * @slot:	pointer to slot in @node
- * @item:	new item to store in the slot.
+ * @root:		radix tree root
+ * @node:		pointer to tree node
+ * @slot:		pointer to slot in @node
+ * @item:		new item to store in the slot.
+ * @update_node:	callback for changing leaf nodes
+ * @private:		private data to pass to @update_node
  *
  * For use with __radix_tree_lookup().  Caller must hold tree write locked
  * across slot lookup and replacement.
  */
 void __radix_tree_replace(struct radix_tree_root *root,
 			  struct radix_tree_node *node,
-			  void **slot, void *item)
+			  void **slot, void *item,
+			  radix_tree_update_node_t update_node, void *private)
 {
 	/*
 	 * This function supports replacing exceptional entries and
@@ -900,7 +910,13 @@ void __radix_tree_replace(struct radix_t
 	replace_slot(root, node, slot, item,
 		     !node && slot != (void **)&root->rnode);
 
-	delete_node(root, node);
+	if (!node)
+		return;
+
+	if (update_node)
+		update_node(node, private);
+
+	delete_node(root, node, update_node, private);
 }
 
 /**
@@ -1585,7 +1601,7 @@ unsigned long radix_tree_locate_item(str
 bool __radix_tree_delete_node(struct radix_tree_root *root,
 			      struct radix_tree_node *node)
 {
-	return delete_node(root, node);
+	return delete_node(root, node, NULL, NULL);
 }
 
 static inline void delete_sibling_entries(struct radix_tree_node *node,
@@ -1642,7 +1658,7 @@ void *radix_tree_delete_item(struct radi
 		node_tag_clear(root, node, tag, offset);
 
 	delete_sibling_entries(node, node_to_entry(slot), offset);
-	__radix_tree_replace(root, node, slot, NULL);
+	__radix_tree_replace(root, node, slot, NULL, NULL, NULL);
 
 	return entry;
 }
diff -puN mm/shmem.c~lib-radix-tree-update-callback-for-changing-leaf-nodes mm/shmem.c
--- a/mm/shmem.c~lib-radix-tree-update-callback-for-changing-leaf-nodes
+++ a/mm/shmem.c
@@ -311,7 +311,8 @@ static int shmem_radix_tree_replace(stru
 		return -ENOENT;
 	if (item != expected)
 		return -ENOENT;
-	__radix_tree_replace(&mapping->page_tree, node, pslot, replacement);
+	__radix_tree_replace(&mapping->page_tree, node, pslot,
+			     replacement, NULL, NULL);
 	return 0;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


