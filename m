From: akpm@linux-foundation.org
Subject: [patch 111/162] radix-tree: introduce radix_tree_load_root()
Date: Fri, 20 May 2016 17:02:08 -0700
Message-ID: <573fa580.638+PXDJwjnEUMof%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcEUACK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: introduce radix_tree_load_root()

All the tree walking functions start with some variant of this code;
centralise it in one place so we're not chasing subtly different bugs
everywhere.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN lib/radix-tree.c~radix-tree-introduce-radix_tree_load_root lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-introduce-radix_tree_load_root
+++ a/lib/radix-tree.c
@@ -405,6 +405,29 @@ static inline unsigned long radix_tree_m
 	return height_to_maxindex[height];
 }
 
+static inline unsigned long node_maxindex(struct radix_tree_node *node)
+{
+	return radix_tree_maxindex(node->path & RADIX_TREE_HEIGHT_MASK);
+}
+
+static unsigned radix_tree_load_root(struct radix_tree_root *root,
+		struct radix_tree_node **nodep, unsigned long *maxindex)
+{
+	struct radix_tree_node *node = rcu_dereference_raw(root->rnode);
+
+	*nodep = node;
+
+	if (likely(radix_tree_is_indirect_ptr(node))) {
+		node = indirect_to_ptr(node);
+		*maxindex = node_maxindex(node);
+		return (node->path & RADIX_TREE_HEIGHT_MASK) *
+			RADIX_TREE_MAP_SHIFT;
+	}
+
+	*maxindex = 0;
+	return 0;
+}
+
 /*
  *	Extend a radix tree so it can store key @index.
  */
_
