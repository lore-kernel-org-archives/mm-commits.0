From: akpm@linux-foundation.org
Subject: [patch 127/162] radix-tree: fix radix_tree_dump() for multi-order entries
Date: Fri, 20 May 2016 17:02:55 -0700
Message-ID: <573fa5af.J70GKy+AUNm15mnu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbcEUAC4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree: fix radix_tree_dump() for multi-order entries

 - Print which indices are covered by every leaf entry
 - Print sibling entries
 - Print the node pointer instead of the slot entry
 - Build by default in userspace, and make it accessible to the test-suite

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                |   48 ++++++++++++++++++------------
 tools/testing/radix-tree/test.h |    1 
 2 files changed, 30 insertions(+), 19 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-radix_tree_dump-for-multi-order-entries lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-radix_tree_dump-for-multi-order-entries
+++ a/lib/radix-tree.c
@@ -215,27 +215,36 @@ radix_tree_find_next_bit(const unsigned
 	return size;
 }
 
-#if 0
-static void dump_node(void *slot, int height, int offset)
+#ifndef __KERNEL__
+static void dump_node(struct radix_tree_node *node, unsigned offset,
+				unsigned shift, unsigned long index)
 {
-	struct radix_tree_node *node;
-	int i;
+	unsigned long i;
 
-	if (!slot)
-		return;
-
-	if (height == 0) {
-		pr_debug("radix entry %p offset %d\n", slot, offset);
-		return;
-	}
-
-	node = indirect_to_ptr(slot);
 	pr_debug("radix node: %p offset %d tags %lx %lx %lx path %x count %d parent %p\n",
-		slot, offset, node->tags[0][0], node->tags[1][0],
-		node->tags[2][0], node->path, node->count, node->parent);
-
-	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++)
-		dump_node(node->slots[i], height - 1, i);
+		node, offset,
+		node->tags[0][0], node->tags[1][0], node->tags[2][0],
+		node->path, node->count, node->parent);
+
+	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
+		unsigned long first = index | (i << shift);
+		unsigned long last = first | ((1UL << shift) - 1);
+		void *entry = node->slots[i];
+		if (!entry)
+			continue;
+		if (is_sibling_entry(node, entry)) {
+			pr_debug("radix sblng %p offset %ld val %p indices %ld-%ld\n",
+					entry, i,
+					*(void **)indirect_to_ptr(entry),
+					first, last);
+		} else if (!radix_tree_is_indirect_ptr(entry)) {
+			pr_debug("radix entry %p offset %ld indices %ld-%ld\n",
+					entry, i, first, last);
+		} else {
+			dump_node(indirect_to_ptr(entry), i,
+					shift - RADIX_TREE_MAP_SHIFT, first);
+		}
+	}
 }
 
 /* For debug */
@@ -246,7 +255,8 @@ static void radix_tree_dump(struct radix
 			root->gfp_mask >> __GFP_BITS_SHIFT);
 	if (!radix_tree_is_indirect_ptr(root->rnode))
 		return;
-	dump_node(root->rnode, root->height, 0);
+	dump_node(indirect_to_ptr(root->rnode), 0,
+				(root->height - 1) * RADIX_TREE_MAP_SHIFT, 0);
 }
 #endif
 
diff -puN tools/testing/radix-tree/test.h~radix-tree-fix-radix_tree_dump-for-multi-order-entries tools/testing/radix-tree/test.h
--- a/tools/testing/radix-tree/test.h~radix-tree-fix-radix_tree_dump-for-multi-order-entries
+++ a/tools/testing/radix-tree/test.h
@@ -40,5 +40,6 @@ extern int nr_allocated;
 
 /* Normally private parts of lib/radix-tree.c */
 void *indirect_to_ptr(void *ptr);
+void radix_tree_dump(struct radix_tree_root *root);
 int root_tag_get(struct radix_tree_root *root, unsigned int tag);
 unsigned long radix_tree_maxindex(unsigned int height);
_
