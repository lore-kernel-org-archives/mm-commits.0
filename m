From: akpm@linux-foundation.org
Subject: + radix-tree-remove-a-use-of-root-height-from-delete_node.patch
 added to -mm tree
Date: Fri, 15 Apr 2016 23:04:41 -0700
Message-ID: <5711d5f9.sI/bb0EFRr0YNtKJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbcDPGEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 02:04:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: remove a use of root->height from delete_node
has been added to the -mm tree.  Its filename is
     radix-tree-remove-a-use-of-root-height-from-delete_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-remove-a-use-of-root-height-from-delete_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-remove-a-use-of-root-height-from-delete_node.patch

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
Subject: radix-tree: remove a use of root->height from delete_node

If radix_tree_shrink returns whether it managed to shrink, then
__radix_tree_delete_node doesn't ned to query the tree to find out whether
it did any work or not.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-remove-a-use-of-root-height-from-delete_node lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-remove-a-use-of-root-height-from-delete_node
+++ a/lib/radix-tree.c
@@ -1416,8 +1416,10 @@ unsigned long radix_tree_locate_item(str
  *	radix_tree_shrink    -    shrink height of a radix tree to minimal
  *	@root		radix tree root
  */
-static inline void radix_tree_shrink(struct radix_tree_root *root)
+static inline bool radix_tree_shrink(struct radix_tree_root *root)
 {
+	bool shrunk = false;
+
 	/* try to shrink tree height */
 	while (root->height > 0) {
 		struct radix_tree_node *to_free = root->rnode;
@@ -1477,7 +1479,10 @@ static inline void radix_tree_shrink(str
 			to_free->slots[0] = RADIX_TREE_RETRY;
 
 		radix_tree_node_free(to_free);
+		shrunk = true;
 	}
+
+	return shrunk;
 }
 
 /**
@@ -1500,11 +1505,8 @@ bool __radix_tree_delete_node(struct rad
 		struct radix_tree_node *parent;
 
 		if (node->count) {
-			if (node == indirect_to_ptr(root->rnode)) {
-				radix_tree_shrink(root);
-				if (root->height == 0)
-					deleted = true;
-			}
+			if (node == indirect_to_ptr(root->rnode))
+				deleted |= radix_tree_shrink(root);
 			return deleted;
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

