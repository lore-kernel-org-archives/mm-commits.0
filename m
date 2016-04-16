From: akpm@linux-foundation.org
Subject: + radix-tree-tidy-up-__radix_tree_create.patch added to -mm tree
Date: Fri, 15 Apr 2016 23:05:01 -0700
Message-ID: <5711d60d.U2BYOt1qdnYicdNt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbcDPGFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 02:05:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: tidy up __radix_tree_create()
has been added to the -mm tree.  Its filename is
     radix-tree-tidy-up-__radix_tree_create.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-tidy-up-__radix_tree_create.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-tidy-up-__radix_tree_create.patch

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

