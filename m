From: akpm@linux-foundation.org
Subject: + radix-tree-tidy-up-range_tag_if_tagged.patch added to -mm tree
Date: Fri, 15 Apr 2016 23:04:59 -0700
Message-ID: <5711d60b.YuGYwT0C5rnTy4t8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbcDPGFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 02:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: tidy up range_tag_if_tagged
has been added to the -mm tree.  Its filename is
     radix-tree-tidy-up-range_tag_if_tagged.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-tidy-up-range_tag_if_tagged.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-tidy-up-range_tag_if_tagged.patch

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
Subject: radix-tree: tidy up range_tag_if_tagged

Convert radix_tree_range_tag_if_tagged to name the nodes parent, node and
child instead of node & slot.

Use parent->offset instead of playing games with 'upindex'.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-tidy-up-range_tag_if_tagged lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-tidy-up-range_tag_if_tagged
+++ a/lib/radix-tree.c
@@ -1009,9 +1009,9 @@ unsigned long radix_tree_range_tag_if_ta
 		unsigned long nr_to_tag,
 		unsigned int iftag, unsigned int settag)
 {
-	struct radix_tree_node *slot, *node = NULL;
+	struct radix_tree_node *parent, *node, *child;
 	unsigned long maxindex;
-	unsigned int shift = radix_tree_load_root(root, &slot, &maxindex);
+	unsigned int shift = radix_tree_load_root(root, &child, &maxindex);
 	unsigned long tagged = 0;
 	unsigned long index = *first_indexp;
 
@@ -1024,28 +1024,25 @@ unsigned long radix_tree_range_tag_if_ta
 		*first_indexp = last_index + 1;
 		return 0;
 	}
-	if (!radix_tree_is_internal_node(slot)) {
+	if (!radix_tree_is_internal_node(child)) {
 		*first_indexp = last_index + 1;
 		root_tag_set(root, settag);
 		return 1;
 	}
 
-	node = entry_to_node(slot);
+	node = entry_to_node(child);
 	shift -= RADIX_TREE_MAP_SHIFT;
 
 	for (;;) {
-		unsigned long upindex;
-		unsigned offset;
-
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		offset = radix_tree_descend(node, &slot, offset);
-		if (!slot)
+		unsigned offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		offset = radix_tree_descend(node, &child, offset);
+		if (!child)
 			goto next;
 		if (!tag_get(node, iftag, offset))
 			goto next;
 		/* Sibling slots never have tags set on them */
-		if (radix_tree_is_internal_node(slot)) {
-			node = entry_to_node(slot);
+		if (radix_tree_is_internal_node(child)) {
+			node = entry_to_node(child);
 			shift -= RADIX_TREE_MAP_SHIFT;
 			continue;
 		}
@@ -1054,20 +1051,18 @@ unsigned long radix_tree_range_tag_if_ta
 		tagged++;
 		tag_set(node, settag, offset);
 
-		slot = node->parent;
 		/* walk back up the path tagging interior nodes */
-		upindex = index >> shift;
-		while (slot) {
-			upindex >>= RADIX_TREE_MAP_SHIFT;
-			offset = upindex & RADIX_TREE_MAP_MASK;
-
+		parent = node;
+		for (;;) {
+			offset = parent->offset;
+			parent = parent->parent;
+			if (!parent)
+				break;
 			/* stop if we find a node with the tag already set */
-			if (tag_get(slot, settag, offset))
+			if (tag_get(parent, settag, offset))
 				break;
-			tag_set(slot, settag, offset);
-			slot = slot->parent;
+			tag_set(parent, settag, offset);
 		}
-
  next:
 		/* Go to next item at level determined by 'shift' */
 		index = ((index >> shift) + 1) << shift;
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

