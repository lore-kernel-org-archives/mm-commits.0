From: akpm@linux-foundation.org
Subject: [patch 140/162] radix-tree: change naming conventions in
 radix_tree_shrink
Date: Fri, 20 May 2016 17:03:33 -0700
Message-ID: <573fa5d5.1Yexol957+uHuVp/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbcEUADf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:03:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

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
@@ -1395,37 +1395,37 @@ static inline bool radix_tree_shrink(str
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
@@ -1445,10 +1445,10 @@ static inline bool radix_tree_shrink(str
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
