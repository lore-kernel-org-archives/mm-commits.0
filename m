From: akpm@linux-foundation.org
Subject: [patch 133/162] radix-tree: remove a use of root->height from
 delete_node
Date: Fri, 20 May 2016 17:03:13 -0700
Message-ID: <573fa5c1.gZKsZ7tVq1kNMqrS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbcEUADO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:03:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

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
@@ -1415,8 +1415,10 @@ unsigned long radix_tree_locate_item(str
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
@@ -1476,7 +1478,10 @@ static inline void radix_tree_shrink(str
 			to_free->slots[0] = RADIX_TREE_RETRY;
 
 		radix_tree_node_free(to_free);
+		shrunk = true;
 	}
+
+	return shrunk;
 }
 
 /**
@@ -1499,11 +1504,8 @@ bool __radix_tree_delete_node(struct rad
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
