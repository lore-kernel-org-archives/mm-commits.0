From: akpm@linux-foundation.org
Subject: + radix-tree-change-naming-conventions-in-radix_tree_shrink.patch added to -mm tree
Date: Fri, 15 Apr 2016 23:04:55 -0700
Message-ID: <5711d607.HRhu8Go7MhxnCShX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbcDPGE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 02:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: change naming conventions in radix_tree_shrink
has been added to the -mm tree.  Its filename is
     radix-tree-change-naming-conventions-in-radix_tree_shrink.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-change-naming-conventions-in-radix_tree_shrink.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-change-naming-conventions-in-radix_tree_shrink.patch

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
Subject: radix-tree: change naming conventions in radix_tree_shrink

Use the more standard 'node' and 'child' instead of 'to_free' and 'slot'.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-change-naming-conventions-in-radix_tree_shrink lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-change-naming-conventions-in-radix_tree_shrink
+++ a/lib/radix-tree.c
@@ -1396,37 +1396,37 @@ static inline bool radix_tree_shrink(str
 	bool shrunk = false;
 
 	for (;;) {
-		struct radix_tree_node *to_free = root->rnode;
-		struct radix_tree_node *slot;
+		struct radix_tree_node *node = root->rnode;
+		struct radix_tree_node *child;
 
-		if (!radix_tree_is_internal_node(to_free))
+		if (!radix_tree_is_internal_node(node))
 			break;
-		to_free = entry_to_node(to_free);
+		node = entry_to_node(node);
 
 		/*
 		 * The candidate node has more than one child, or its child
 		 * is not at the leftmost slot, or the child is a multiorder
 		 * entry, we cannot shrink.
 		 */
-		if (to_free->count != 1)
+		if (node->count != 1)
 			break;
-		slot = to_free->slots[0];
-		if (!slot)
+		child = node->slots[0];
+		if (!child)
 			break;
-		if (!radix_tree_is_internal_node(slot) && to_free->shift)
+		if (!radix_tree_is_internal_node(child) && node->shift)
 			break;
 
-		if (radix_tree_is_internal_node(slot))
-			entry_to_node(slot)->parent = NULL;
+		if (radix_tree_is_internal_node(child))
+			entry_to_node(child)->parent = NULL;
 
 		/*
 		 * We don't need rcu_assign_pointer(), since we are simply
 		 * moving the node from one part of the tree to another: if it
 		 * was safe to dereference the old pointer to it
-		 * (to_free->slots[0]), it will be safe to dereference the new
+		 * (node->slots[0]), it will be safe to dereference the new
 		 * one (root->rnode) as far as dependent read barriers go.
 		 */
-		root->rnode = slot;
+		root->rnode = child;
 
 		/*
 		 * We have a dilemma here. The node's slot[0] must not be
@@ -1446,10 +1446,10 @@ static inline bool radix_tree_shrink(str
 		 * also results in a stale slot). So tag the slot as indirect
 		 * to force callers to retry.
 		 */
-		if (!radix_tree_is_internal_node(slot))
-			to_free->slots[0] = RADIX_TREE_RETRY;
+		if (!radix_tree_is_internal_node(child))
+			node->slots[0] = RADIX_TREE_RETRY;
 
-		radix_tree_node_free(to_free);
+		radix_tree_node_free(node);
 		shrunk = true;
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

