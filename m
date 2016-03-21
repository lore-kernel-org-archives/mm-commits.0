From: akpm@linux-foundation.org
Subject: [merged] radix_tree-add-radix_tree_dump.patch removed from -mm
 tree
Date: Mon, 21 Mar 2016 11:41:46 -0700
Message-ID: <56f0406a.MxaZos/Hk5jIQ8Kq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952AbcCUTVY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix_tree: add radix_tree_dump
has been removed from the -mm tree.  Its filename was
     radix_tree-add-radix_tree_dump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix_tree: add radix_tree_dump

This is debug code which is #if 0 out.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN lib/radix-tree.c~radix_tree-add-radix_tree_dump lib/radix-tree.c
--- a/lib/radix-tree.c~radix_tree-add-radix_tree_dump
+++ a/lib/radix-tree.c
@@ -173,6 +173,41 @@ radix_tree_find_next_bit(const unsigned
 	return size;
 }
 
+#if 0
+static void dump_node(void *slot, int height, int offset)
+{
+	struct radix_tree_node *node;
+	int i;
+
+	if (!slot)
+		return;
+
+	if (height == 0) {
+		pr_debug("radix entry %p offset %d\n", slot, offset);
+		return;
+	}
+
+	node = indirect_to_ptr(slot);
+	pr_debug("radix node: %p offset %d tags %lx %lx %lx path %x count %d parent %p\n",
+		slot, offset, node->tags[0][0], node->tags[1][0],
+		node->tags[2][0], node->path, node->count, node->parent);
+
+	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++)
+		dump_node(node->slots[i], height - 1, i);
+}
+
+/* For debug */
+static void radix_tree_dump(struct radix_tree_root *root)
+{
+	pr_debug("radix root: %p height %d rnode %p tags %x\n",
+			root, root->height, root->rnode,
+			root->gfp_mask >> __GFP_BITS_SHIFT);
+	if (!radix_tree_is_indirect_ptr(root->rnode))
+		return;
+	dump_node(root->rnode, root->height, 0);
+}
+#endif
+
 /*
  * This assumes that the caller has performed appropriate preallocation, and
  * that the caller has pinned this thread of control to the current CPU.
_

Patches currently in -mm which might be from willy@linux.intel.com are


