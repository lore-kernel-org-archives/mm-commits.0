From: akpm@linux-foundation.org
Subject: [patch 115/162] radix-tree: rewrite __radix_tree_lookup
Date: Fri, 20 May 2016 17:02:20 -0700
Message-ID: <573fa58c.o1deGOLf7bnGYbgP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbcEUACV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

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
