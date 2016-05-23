From: akpm@linux-foundation.org
Subject: [merged] radix-tree-rewrite-__radix_tree_lookup.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:49:54 -0700
Message-ID: <57435ee2.FPY1dHqhlHTxZNN3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbcEWTtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:49:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: rewrite __radix_tree_lookup
has been removed from the -mm tree.  Its filename was
     radix-tree-rewrite-__radix_tree_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: rewrite __radix_tree_lookup

Use the new multi-order support functions to rewrite __radix_tree_lookup()

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   48 +++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 32 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-rewrite-__radix_tree_lookup lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rewrite-__radix_tree_lookup
+++ a/lib/radix-tree.c
@@ -634,44 +634,28 @@ void *__radix_tree_lookup(struct radix_t
 			  struct radix_tree_node **nodep, void ***slotp)
 {
 	struct radix_tree_node *node, *parent;
-	unsigned int height, shift;
+	unsigned long maxindex;
+	unsigned int shift;
 	void **slot;
 
-	node = rcu_dereference_raw(root->rnode);
-	if (node == NULL)
+ restart:
+	parent = NULL;
+	slot = (void **)&root->rnode;
+	shift = radix_tree_load_root(root, &node, &maxindex);
+	if (index > maxindex)
 		return NULL;
 
-	if (!radix_tree_is_indirect_ptr(node)) {
-		if (index > 0)
-			return NULL;
-
-		if (nodep)
-			*nodep = NULL;
-		if (slotp)
-			*slotp = (void **)&root->rnode;
-		return node;
-	}
-	node = indirect_to_ptr(node);
-
-	height = node->path & RADIX_TREE_HEIGHT_MASK;
-	if (index > radix_tree_maxindex(height))
-		return NULL;
-
-	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
-
-	do {
-		parent = node;
-		slot = node->slots + ((index >> shift) & RADIX_TREE_MAP_MASK);
-		node = rcu_dereference_raw(*slot);
-		if (node == NULL)
-			return NULL;
-		if (!radix_tree_is_indirect_ptr(node))
-			break;
-		node = indirect_to_ptr(node);
+	while (radix_tree_is_indirect_ptr(node)) {
+		unsigned offset;
 
+		if (node == RADIX_TREE_RETRY)
+			goto restart;
+		parent = indirect_to_ptr(node);
 		shift -= RADIX_TREE_MAP_SHIFT;
-		height--;
-	} while (height > 0);
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		offset = radix_tree_descend(parent, &node, offset);
+		slot = parent->slots + offset;
+	}
 
 	if (nodep)
 		*nodep = parent;
_

Patches currently in -mm which might be from willy@linux.intel.com are

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

