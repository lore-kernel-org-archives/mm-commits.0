From: akpm@linux-foundation.org
Subject: [merged] lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:28 -0700
Message-ID: <200906171837.n5HIbSJ1003472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbZFQSpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, cl@linux-foundation.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     lib: do code optimization for radix_tree_lookup() and radix_tree_lookup_slot()
has been removed from the -mm tree.  Its filename was
     lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: do code optimization for radix_tree_lookup() and radix_tree_lookup_slot()
From: Huang Shijie <shijie8@gmail.com>

radix_tree_lookup() and radix_tree_lookup_slot() have much the
same code except for the return value.

Introduce radix_tree_lookup_element() to do the real work.

/*
 * is_slot == 1 : search for the slot.
 * is_slot == 0 : search for the node.
 */
static void * radix_tree_lookup_element(struct radix_tree_root *root,
					unsigned long index, int is_slot);

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   73 ++++++++++++++++-----------------------------
 1 file changed, 26 insertions(+), 47 deletions(-)

diff -puN lib/radix-tree.c~lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot lib/radix-tree.c
--- a/lib/radix-tree.c~lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot
+++ a/lib/radix-tree.c
@@ -351,20 +351,12 @@ int radix_tree_insert(struct radix_tree_
 }
 EXPORT_SYMBOL(radix_tree_insert);
 
-/**
- *	radix_tree_lookup_slot    -    lookup a slot in a radix tree
- *	@root:		radix tree root
- *	@index:		index key
- *
- *	Returns:  the slot corresponding to the position @index in the
- *	radix tree @root. This is useful for update-if-exists operations.
- *
- *	This function can be called under rcu_read_lock iff the slot is not
- *	modified by radix_tree_replace_slot, otherwise it must be called
- *	exclusive from other writers. Any dereference of the slot must be done
- *	using radix_tree_deref_slot.
+/*
+ * is_slot == 1 : search for the slot.
+ * is_slot == 0 : search for the node.
  */
-void **radix_tree_lookup_slot(struct radix_tree_root *root, unsigned long index)
+static void *radix_tree_lookup_element(struct radix_tree_root *root,
+				unsigned long index, int is_slot)
 {
 	unsigned int height, shift;
 	struct radix_tree_node *node, **slot;
@@ -376,7 +368,7 @@ void **radix_tree_lookup_slot(struct rad
 	if (!radix_tree_is_indirect_ptr(node)) {
 		if (index > 0)
 			return NULL;
-		return (void **)&root->rnode;
+		return is_slot ? (void *)&root->rnode : node;
 	}
 	node = radix_tree_indirect_to_ptr(node);
 
@@ -397,7 +389,25 @@ void **radix_tree_lookup_slot(struct rad
 		height--;
 	} while (height > 0);
 
-	return (void **)slot;
+	return is_slot ? (void *)slot:node;
+}
+
+/**
+ *	radix_tree_lookup_slot    -    lookup a slot in a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *
+ *	Returns:  the slot corresponding to the position @index in the
+ *	radix tree @root. This is useful for update-if-exists operations.
+ *
+ *	This function can be called under rcu_read_lock iff the slot is not
+ *	modified by radix_tree_replace_slot, otherwise it must be called
+ *	exclusive from other writers. Any dereference of the slot must be done
+ *	using radix_tree_deref_slot.
+ */
+void **radix_tree_lookup_slot(struct radix_tree_root *root, unsigned long index)
+{
+	return (void **)radix_tree_lookup_element(root, index, 1);
 }
 EXPORT_SYMBOL(radix_tree_lookup_slot);
 
@@ -415,38 +425,7 @@ EXPORT_SYMBOL(radix_tree_lookup_slot);
  */
 void *radix_tree_lookup(struct radix_tree_root *root, unsigned long index)
 {
-	unsigned int height, shift;
-	struct radix_tree_node *node, **slot;
-
-	node = rcu_dereference(root->rnode);
-	if (node == NULL)
-		return NULL;
-
-	if (!radix_tree_is_indirect_ptr(node)) {
-		if (index > 0)
-			return NULL;
-		return node;
-	}
-	node = radix_tree_indirect_to_ptr(node);
-
-	height = node->height;
-	if (index > radix_tree_maxindex(height))
-		return NULL;
-
-	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
-
-	do {
-		slot = (struct radix_tree_node **)
-			(node->slots + ((index>>shift) & RADIX_TREE_MAP_MASK));
-		node = rcu_dereference(*slot);
-		if (node == NULL)
-			return NULL;
-
-		shift -= RADIX_TREE_MAP_SHIFT;
-		height--;
-	} while (height > 0);
