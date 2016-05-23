From: akpm@linux-foundation.org
Subject: [merged] radix-tree-rename-ptr_to_indirect-to-node_to_entry.patch removed from -mm tree
Date: Mon, 23 May 2016 12:50:55 -0700
Message-ID: <57435f1f.s775pLAEylov8U+A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbcEWTu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:50:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: rename ptr_to_indirect() to node_to_entry()
has been removed from the -mm tree.  Its filename was
     radix-tree-rename-ptr_to_indirect-to-node_to_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: rename ptr_to_indirect() to node_to_entry()

ptr_to_indirect() was a bad name.  What it really means is "Convert this
pointer to a node into an entry suitable for storing in the radix tree". 
So node_to_entry() seemed like a better name.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-rename-ptr_to_indirect-to-node_to_entry lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rename-ptr_to_indirect-to-node_to_entry
+++ a/lib/radix-tree.c
@@ -66,12 +66,12 @@ struct radix_tree_preload {
 };
 static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
 
-static inline void *ptr_to_indirect(void *ptr)
+static inline void *node_to_entry(void *ptr)
 {
 	return (void *)((unsigned long)ptr | RADIX_TREE_INTERNAL_NODE);
 }
 
-#define RADIX_TREE_RETRY	ptr_to_indirect(NULL)
+#define RADIX_TREE_RETRY	node_to_entry(NULL)
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
 /* Sibling slots point directly to another slot in the same node */
@@ -470,13 +470,12 @@ static int radix_tree_extend(struct radi
 		if (radix_tree_is_indirect_ptr(slot)) {
 			slot = indirect_to_ptr(slot);
 			slot->parent = node;
-			slot = ptr_to_indirect(slot);
+			slot = node_to_entry(slot);
 		}
 		node->slots[0] = slot;
-		node = ptr_to_indirect(node);
-		rcu_assign_pointer(root->rnode, node);
+		slot = node_to_entry(node);
+		rcu_assign_pointer(root->rnode, slot);
 		shift += RADIX_TREE_MAP_SHIFT;
-		slot = node;
 	} while (shift <= maxshift);
 out:
 	return maxshift + RADIX_TREE_MAP_SHIFT;
@@ -534,11 +533,11 @@ int __radix_tree_create(struct radix_tre
 			slot->parent = node;
 			if (node) {
 				rcu_assign_pointer(node->slots[offset],
-							ptr_to_indirect(slot));
+							node_to_entry(slot));
 				node->count++;
 			} else
 				rcu_assign_pointer(root->rnode,
-							ptr_to_indirect(slot));
+							node_to_entry(slot));
 		} else if (!radix_tree_is_indirect_ptr(slot))
 			break;
 
@@ -553,7 +552,7 @@ int __radix_tree_create(struct radix_tre
 	if (order > shift) {
 		int i, n = 1 << (order - shift);
 		offset = offset & ~(n - 1);
-		slot = ptr_to_indirect(&node->slots[offset]);
+		slot = node_to_entry(&node->slots[offset]);
 		for (i = 0; i < n; i++) {
 			if (node->slots[offset + i])
 				return -EEXIST;
@@ -1422,7 +1421,7 @@ static inline bool radix_tree_shrink(str
 		if (radix_tree_is_indirect_ptr(slot)) {
 			slot = indirect_to_ptr(slot);
 			slot->parent = NULL;
-			slot = ptr_to_indirect(slot);
+			slot = node_to_entry(slot);
 		}
 
 		/*
@@ -1563,7 +1562,7 @@ void *radix_tree_delete_item(struct radi
 			radix_tree_tag_clear(root, index, tag);
 	}
 
-	delete_sibling_entries(node, ptr_to_indirect(slot), offset);
+	delete_sibling_entries(node, node_to_entry(slot), offset);
 	node->slots[offset] = NULL;
 	node->count--;
 
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-rename-indirect_to_ptr-to-entry_to_node.patch
radix-tree-rename-radix_tree_is_indirect_ptr.patch
radix-tree-change-naming-conventions-in-radix_tree_shrink.patch
radix-tree-tidy-up-next_chunk.patch
radix-tree-tidy-up-range_tag_if_tagged.patch
radix-tree-tidy-up-__radix_tree_create.patch
radix-tree-introduce-radix_tree_replace_clear_tags.patch
radix-tree-make-radix_tree_descend-more-useful.patch
radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse.patch

