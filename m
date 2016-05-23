From: akpm@linux-foundation.org
Subject: [merged] radix-tree-introduce-radix_tree_replace_clear_tags.patch removed from -mm tree
Date: Mon, 23 May 2016 12:51:16 -0700
Message-ID: <57435f34.2oZxLgqZOtHZOQuP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbcEWTvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: introduce radix_tree_replace_clear_tags()
has been removed from the -mm tree.  Its filename was
     radix-tree-introduce-radix_tree_replace_clear_tags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: introduce radix_tree_replace_clear_tags()

In addition to replacing the entry, we also clear all associated tags. 
This is really a one-off special for page_cache_tree_delete() which had
far too much detailed knowledge about how the radix tree works.

For efficiency, factor node_tag_clear() out of radix_tree_tag_clear() It
can be used by radix_tree_delete_item() as well as
radix_tree_replace_clear_tags().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    9 ++--
 lib/radix-tree.c           |   76 +++++++++++++++++++++--------------
 mm/filemap.c               |   23 +---------
 3 files changed, 56 insertions(+), 52 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-introduce-radix_tree_replace_clear_tags include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-introduce-radix_tree_replace_clear_tags
+++ a/include/linux/radix-tree.h
@@ -281,9 +281,12 @@ bool __radix_tree_delete_node(struct rad
 			      struct radix_tree_node *node);
 void *radix_tree_delete_item(struct radix_tree_root *, unsigned long, void *);
 void *radix_tree_delete(struct radix_tree_root *, unsigned long);
-unsigned int
-radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
-			unsigned long first_index, unsigned int max_items);
+struct radix_tree_node *radix_tree_replace_clear_tags(
+				struct radix_tree_root *root,
+				unsigned long index, void *entry);
+unsigned int radix_tree_gang_lookup(struct radix_tree_root *root,
+			void **results, unsigned long first_index,
+			unsigned int max_items);
 unsigned int radix_tree_gang_lookup_slot(struct radix_tree_root *root,
 			void ***results, unsigned long *indices,
 			unsigned long first_index, unsigned int max_items);
diff -puN lib/radix-tree.c~radix-tree-introduce-radix_tree_replace_clear_tags lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-introduce-radix_tree_replace_clear_tags
+++ a/lib/radix-tree.c
@@ -740,6 +740,26 @@ void *radix_tree_tag_set(struct radix_tr
 }
 EXPORT_SYMBOL(radix_tree_tag_set);
 
+static void node_tag_clear(struct radix_tree_root *root,
+				struct radix_tree_node *node,
+				unsigned int tag, unsigned int offset)
+{
+	while (node) {
+		if (!tag_get(node, tag, offset))
+			return;
+		tag_clear(node, tag, offset);
+		if (any_tag_set(node, tag))
+			return;
+
+		offset = node->offset;
+		node = node->parent;
+	}
+
+	/* clear the root's tag bit */
+	if (root_tag_get(root, tag))
+		root_tag_clear(root, tag);
+}
+
 /**
  *	radix_tree_tag_clear - clear a tag on a radix tree node
  *	@root:		radix tree root
@@ -776,28 +796,9 @@ void *radix_tree_tag_clear(struct radix_
 		offset = radix_tree_descend(parent, &node, offset);
 	}
 
-	if (node == NULL)
-		goto out;
-
-	index >>= shift;
-
-	while (parent) {
-		if (!tag_get(parent, tag, offset))
-			goto out;
-		tag_clear(parent, tag, offset);
-		if (any_tag_set(parent, tag))
-			goto out;
-
-		index >>= RADIX_TREE_MAP_SHIFT;
-		offset = index & RADIX_TREE_MAP_MASK;
-		parent = parent->parent;
-	}
+	if (node)
+		node_tag_clear(root, parent, tag, offset);
 
-	/* clear the root's tag bit */
-	if (root_tag_get(root, tag))
-		root_tag_clear(root, tag);
-
-out:
 	return node;
 }
 EXPORT_SYMBOL(radix_tree_tag_clear);
@@ -1525,14 +1526,9 @@ void *radix_tree_delete_item(struct radi
 
 	offset = get_slot_offset(node, slot);
 
-	/*
-	 * Clear all tags associated with the item to be deleted.
-	 * This way of doing it would be inefficient, but seldom is any set.
-	 */
-	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
-		if (tag_get(node, tag, offset))
-			radix_tree_tag_clear(root, index, tag);
-	}
+	/* Clear all tags associated with the item to be deleted.  */
+	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
+		node_tag_clear(root, node, tag, offset);
 
 	delete_sibling_entries(node, node_to_entry(slot), offset);
 	node->slots[offset] = NULL;
@@ -1559,6 +1555,28 @@ void *radix_tree_delete(struct radix_tre
 }
 EXPORT_SYMBOL(radix_tree_delete);
 
+struct radix_tree_node *radix_tree_replace_clear_tags(
+			struct radix_tree_root *root,
+			unsigned long index, void *entry)
+{
+	struct radix_tree_node *node;
+	void **slot;
+
+	__radix_tree_lookup(root, index, &node, &slot);
+
+	if (node) {
+		unsigned int tag, offset = get_slot_offset(node, slot);
+		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
+			node_tag_clear(root, node, tag, offset);
+	} else {
+		/* Clear root node tags */
+		root->gfp_mask &= __GFP_BITS_MASK;
+	}
+
+	radix_tree_replace_slot(slot, entry);
+	return node;
+}
+
 /**
  *	radix_tree_tagged - test whether any items in the tree are tagged
  *	@root:		radix tree root
diff -puN mm/filemap.c~radix-tree-introduce-radix_tree_replace_clear_tags mm/filemap.c
--- a/mm/filemap.c~radix-tree-introduce-radix_tree_replace_clear_tags
+++ a/mm/filemap.c
@@ -114,14 +114,11 @@ static void page_cache_tree_delete(struc
 				   struct page *page, void *shadow)
 {
 	struct radix_tree_node *node;
-	unsigned long index;
-	unsigned int offset;
-	unsigned int tag;
-	void **slot;
 
 	VM_BUG_ON(!PageLocked(page));
 
-	__radix_tree_lookup(&mapping->page_tree, page->index, &node, &slot);
+	node = radix_tree_replace_clear_tags(&mapping->page_tree, page->index,
+								shadow);
 
 	if (shadow) {
 		mapping->nrexceptional++;
@@ -135,23 +132,9 @@ static void page_cache_tree_delete(struc
 	}
 	mapping->nrpages--;
 
-	if (!node) {
-		/* Clear direct pointer tags in root node */
-		mapping->page_tree.gfp_mask &= __GFP_BITS_MASK;
-		radix_tree_replace_slot(slot, shadow);
+	if (!node)
 		return;
-	}
