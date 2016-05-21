From: akpm@linux-foundation.org
Subject: [patch 119/162] radix-tree: rewrite radix_tree_tag_set
Date: Fri, 20 May 2016 17:02:32 -0700
Message-ID: <573fa598.+CwmuVx0dUdOmpwM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcEUACd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree: rewrite radix_tree_tag_set

Use the new multi-order support functions to rewrite radix_tree_tag_set()

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-rewrite-radix_tree_tag_set lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rewrite-radix_tree_tag_set
+++ a/lib/radix-tree.c
@@ -722,35 +722,32 @@ EXPORT_SYMBOL(radix_tree_lookup);
 void *radix_tree_tag_set(struct radix_tree_root *root,
 			unsigned long index, unsigned int tag)
 {
-	unsigned int height, shift;
-	struct radix_tree_node *slot;
+	struct radix_tree_node *node, *parent;
+	unsigned long maxindex;
+	unsigned int shift;
 
-	height = root->height;
-	BUG_ON(index > radix_tree_maxindex(height));
+	shift = radix_tree_load_root(root, &node, &maxindex);
+	BUG_ON(index > maxindex);
 
-	slot = indirect_to_ptr(root->rnode);
-	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	while (radix_tree_is_indirect_ptr(node)) {
+		unsigned offset;
 
-	while (height > 0) {
-		int offset;
-
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		if (!tag_get(slot, tag, offset))
-			tag_set(slot, tag, offset);
-		slot = slot->slots[offset];
-		BUG_ON(slot == NULL);
-		if (!radix_tree_is_indirect_ptr(slot))
-			break;
-		slot = indirect_to_ptr(slot);
 		shift -= RADIX_TREE_MAP_SHIFT;
-		height--;
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+
+		parent = indirect_to_ptr(node);
+		offset = radix_tree_descend(parent, &node, offset);
+		BUG_ON(!node);
+
+		if (!tag_get(parent, tag, offset))
+			tag_set(parent, tag, offset);
 	}
 
 	/* set the root's tag bit */
-	if (slot && !root_tag_get(root, tag))
+	if (!root_tag_get(root, tag))
 		root_tag_set(root, tag);
 
-	return slot;
+	return node;
 }
 EXPORT_SYMBOL(radix_tree_tag_set);
 
_
