From: akpm@linux-foundation.org
Subject: [patch 121/162] radix-tree: rewrite radix_tree_tag_get
Date: Fri, 20 May 2016 17:02:38 -0700
Message-ID: <573fa59e.my38KgCGODB+EjU7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcEUACj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree: rewrite radix_tree_tag_get

Use the new multi-order support functions to rewrite radix_tree_tag_get()

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-rewrite-radix_tree_tag_get lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rewrite-radix_tree_tag_get
+++ a/lib/radix-tree.c
@@ -831,45 +831,37 @@ EXPORT_SYMBOL(radix_tree_tag_clear);
 int radix_tree_tag_get(struct radix_tree_root *root,
 			unsigned long index, unsigned int tag)
 {
-	unsigned int height, shift;
-	struct radix_tree_node *node;
+	struct radix_tree_node *node, *parent;
+	unsigned long maxindex;
+	unsigned int shift;
 
-	/* check the root's tag bit */
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	node = rcu_dereference_raw(root->rnode);
+	shift = radix_tree_load_root(root, &node, &maxindex);
+	if (index > maxindex)
+		return 0;
 	if (node == NULL)
 		return 0;
 
-	if (!radix_tree_is_indirect_ptr(node))
-		return (index == 0);
-	node = indirect_to_ptr(node);
+	while (radix_tree_is_indirect_ptr(node)) {
+		int offset;
 
-	height = node->path & RADIX_TREE_HEIGHT_MASK;
-	if (index > radix_tree_maxindex(height))
-		return 0;
+		shift -= RADIX_TREE_MAP_SHIFT;
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 
-	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+		parent = indirect_to_ptr(node);
+		offset = radix_tree_descend(parent, &node, offset);
 
-	for ( ; ; ) {
-		int offset;
-
-		if (node == NULL)
+		if (!node)
 			return 0;
-		node = indirect_to_ptr(node);
