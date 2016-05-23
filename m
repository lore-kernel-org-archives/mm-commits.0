From: akpm@linux-foundation.org
Subject: [merged] radix-tree-tidy-up-range_tag_if_tagged.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:51:10 -0700
Message-ID: <57435f2e.lQKZhDbGhPdpaz0Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbcEWTvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: tidy up range_tag_if_tagged
has been removed from the -mm tree.  Its filename was
     radix-tree-tidy-up-range_tag_if_tagged.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
