From: akpm@linux-foundation.org
Subject: [patch 143/162] radix-tree: tidy up __radix_tree_create()
Date: Fri, 20 May 2016 17:03:42 -0700
Message-ID: <573fa5de.qj5eQ99HMCZbHCzv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbcEUADn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:03:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: tidy up __radix_tree_create()

1. Rename the existing variable 'slot' to 'child'.
2. Introduce a new variable called 'slot' which is the address of the
   slot we're dealing with.  This lets us simplify the tree insertion,
   and removes the recalculation of 'slot' at the end of the function.
3. Using 'slot' in the sibling pointer insertion part makes the code
   more readable.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   48 +++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-tidy-up-__radix_tree_create lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-tidy-up-__radix_tree_create
+++ a/lib/radix-tree.c
@@ -499,12 +499,13 @@ int __radix_tree_create(struct radix_tre
 			unsigned order, struct radix_tree_node **nodep,
 			void ***slotp)
 {
-	struct radix_tree_node *node = NULL, *slot;
+	struct radix_tree_node *node = NULL, *child;
+	void **slot = (void **)&root->rnode;
 	unsigned long maxindex;
-	unsigned int shift, offset;
+	unsigned int shift, offset = 0;
 	unsigned long max = index | ((1UL << order) - 1);
 
-	shift = radix_tree_load_root(root, &slot, &maxindex);
+	shift = radix_tree_load_root(root, &child, &maxindex);
 
 	/* Make sure the tree is high enough.  */
 	if (max > maxindex) {
@@ -512,51 +513,48 @@ int __radix_tree_create(struct radix_tre
 		if (error < 0)
 			return error;
 		shift = error;
-		slot = root->rnode;
+		child = root->rnode;
 		if (order == shift)
 			shift += RADIX_TREE_MAP_SHIFT;
 	}
 
-	offset = 0;			/* uninitialised var warning */
 	while (shift > order) {
 		shift -= RADIX_TREE_MAP_SHIFT;
-		if (slot == NULL) {
+		if (child == NULL) {
 			/* Have to add a child node.  */
-			slot = radix_tree_node_alloc(root);
-			if (!slot)
+			child = radix_tree_node_alloc(root);
+			if (!child)
 				return -ENOMEM;
-			slot->shift = shift;
-			slot->offset = offset;
-			slot->parent = node;
-			if (node) {
-				rcu_assign_pointer(node->slots[offset],
-							node_to_entry(slot));
+			child->shift = shift;
+			child->offset = offset;
+			child->parent = node;
+			rcu_assign_pointer(*slot, node_to_entry(child));
+			if (node)
 				node->count++;
-			} else
-				rcu_assign_pointer(root->rnode,
-							node_to_entry(slot));
-		} else if (!radix_tree_is_internal_node(slot))
+		} else if (!radix_tree_is_internal_node(child))
 			break;
 
 		/* Go a level down */
-		node = entry_to_node(slot);
+		node = entry_to_node(child);
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		offset = radix_tree_descend(node, &slot, offset);
+		offset = radix_tree_descend(node, &child, offset);
+		slot = &node->slots[offset];
 	}
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
 	/* Insert pointers to the canonical entry */
 	if (order > shift) {
-		int i, n = 1 << (order - shift);
+		unsigned i, n = 1 << (order - shift);
 		offset = offset & ~(n - 1);
-		slot = node_to_entry(&node->slots[offset]);
+		slot = &node->slots[offset];
+		child = node_to_entry(slot);
 		for (i = 0; i < n; i++) {
-			if (node->slots[offset + i])
+			if (slot[i])
 				return -EEXIST;
 		}
 
 		for (i = 1; i < n; i++) {
-			rcu_assign_pointer(node->slots[offset + i], slot);
+			rcu_assign_pointer(slot[i], child);
 			node->count++;
 		}
 	}
@@ -565,7 +563,7 @@ int __radix_tree_create(struct radix_tre
 	if (nodep)
 		*nodep = node;
 	if (slotp)
-		*slotp = node ? node->slots + offset : (void **)&root->rnode;
+		*slotp = slot;
 	return 0;
 }
 
_
