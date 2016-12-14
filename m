From: akpm@linux-foundation.org
Subject: [patch 096/114] radix-tree: improve dump output
Date: Wed, 14 Dec 2016 15:08:43 -0800
Message-ID: <5851d0fb.hMTdKKKQG7UxHQpp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35396 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933077AbcLNXIp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:08:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@infradead.org, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@infradead.org>
Subject: radix-tree: improve dump output

Print the indices of the entries as unsigned (instead of signed) integers
and print the parent node of each entry to help navigate around larger
trees where the layout is not quite so obvious.  Print the indices covered
by a node.  Rearrange the order of fields printed so the indices and
parents line up for each type of entry.

Link: http://lkml.kernel.org/r/1480369871-5271-53-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   49 +++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-improve-dump-output lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-improve-dump-output
+++ a/lib/radix-tree.c
@@ -214,15 +214,29 @@ radix_tree_find_next_bit(struct radix_tr
 	return RADIX_TREE_MAP_SIZE;
 }
 
+/*
+ * The maximum index which can be stored in a radix tree
+ */
+static inline unsigned long shift_maxindex(unsigned int shift)
+{
+	return (RADIX_TREE_MAP_SIZE << shift) - 1;
+}
+
+static inline unsigned long node_maxindex(struct radix_tree_node *node)
+{
+	return shift_maxindex(node->shift);
+}
+
 #ifndef __KERNEL__
 static void dump_node(struct radix_tree_node *node, unsigned long index)
 {
 	unsigned long i;
 
-	pr_debug("radix node: %p offset %d tags %lx %lx %lx shift %d count %d exceptional %d parent %p\n",
-		node, node->offset,
+	pr_debug("radix node: %p offset %d indices %lu-%lu parent %p tags %lx %lx %lx shift %d count %d exceptional %d\n",
+		node, node->offset, index, index | node_maxindex(node),
+		node->parent,
 		node->tags[0][0], node->tags[1][0], node->tags[2][0],
-		node->shift, node->count, node->exceptional, node->parent);
+		node->shift, node->count, node->exceptional);
 
 	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
 		unsigned long first = index | (i << node->shift);
@@ -230,14 +244,16 @@ static void dump_node(struct radix_tree_
 		void *entry = node->slots[i];
 		if (!entry)
 			continue;
-		if (is_sibling_entry(node, entry)) {
-			pr_debug("radix sblng %p offset %ld val %p indices %ld-%ld\n",
-					entry, i,
-					*(void **)entry_to_node(entry),
-					first, last);
+		if (entry == RADIX_TREE_RETRY) {
+			pr_debug("radix retry offset %ld indices %lu-%lu parent %p\n",
+					i, first, last, node);
 		} else if (!radix_tree_is_internal_node(entry)) {
-			pr_debug("radix entry %p offset %ld indices %ld-%ld\n",
-					entry, i, first, last);
+			pr_debug("radix entry %p offset %ld indices %lu-%lu parent %p\n",
+					entry, i, first, last, node);
+		} else if (is_sibling_entry(node, entry)) {
+			pr_debug("radix sblng %p offset %ld indices %lu-%lu parent %p val %p\n",
+					entry, i, first, last, node,
+					*(void **)entry_to_node(entry));
 		} else {
 			dump_node(entry_to_node(entry), first);
 		}
@@ -455,19 +471,6 @@ int radix_tree_maybe_preload_order(gfp_t
 	return __radix_tree_preload(gfp_mask, nr_nodes);
 }
 
-/*
- * The maximum index which can be stored in a radix tree
- */
-static inline unsigned long shift_maxindex(unsigned int shift)
-{
-	return (RADIX_TREE_MAP_SIZE << shift) - 1;
-}
-
-static inline unsigned long node_maxindex(struct radix_tree_node *node)
-{
-	return shift_maxindex(node->shift);
-}
