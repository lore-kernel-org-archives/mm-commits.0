From: akpm@linux-foundation.org
Subject: [patch 103/114] radix-tree: add radix_tree_split_preload()
Date: Wed, 14 Dec 2016 15:09:04 -0800
Message-ID: <5851d110.0Aw0XdgwZFApOAvE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbcLNXJF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:09:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: add radix_tree_split_preload()

Calculate how many nodes we need to allocate to split an old_order entry
into multiple entries, each of size new_order.  The test suite checks that
we allocated exactly the right number of nodes; neither too many (checked
by rtp->nr == 0), nor too few (checked by comparing nr_allocated before
and after the call to radix_tree_split()).

Link: http://lkml.kernel.org/r/1480369871-5271-60-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h            |    1 
 lib/radix-tree.c                      |   24 +++++++++++++
 tools/testing/radix-tree/multiorder.c |   42 ++++++++++++++++++++++--
 tools/testing/radix-tree/test.h       |    5 ++
 4 files changed, 69 insertions(+), 3 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-add-radix_tree_split_preload include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-add-radix_tree_split_preload
+++ a/include/linux/radix-tree.h
@@ -345,6 +345,7 @@ static inline void radix_tree_preload_en
 	preempt_enable();
 }
 
+int radix_tree_split_preload(unsigned old_order, unsigned new_order, gfp_t);
 int radix_tree_split(struct radix_tree_root *, unsigned long index,
 			unsigned new_order);
 int radix_tree_join(struct radix_tree_root *, unsigned long index,
diff -puN lib/radix-tree.c~radix-tree-add-radix_tree_split_preload lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-add-radix_tree_split_preload
+++ a/lib/radix-tree.c
@@ -368,7 +368,7 @@ radix_tree_node_free(struct radix_tree_n
  * To make use of this facility, the radix tree must be initialised without
  * __GFP_DIRECT_RECLAIM being passed to INIT_RADIX_TREE().
  */
-static int __radix_tree_preload(gfp_t gfp_mask, int nr)
+static int __radix_tree_preload(gfp_t gfp_mask, unsigned nr)
 {
 	struct radix_tree_preload *rtp;
 	struct radix_tree_node *node;
@@ -434,6 +434,28 @@ int radix_tree_maybe_preload(gfp_t gfp_m
 }
 EXPORT_SYMBOL(radix_tree_maybe_preload);
 
+#ifdef CONFIG_RADIX_TREE_MULTIORDER
+/*
+ * Preload with enough objects to ensure that we can split a single entry
+ * of order @old_order into many entries of size @new_order
+ */
+int radix_tree_split_preload(unsigned int old_order, unsigned int new_order,
+							gfp_t gfp_mask)
+{
+	unsigned top = 1 << (old_order % RADIX_TREE_MAP_SHIFT);
+	unsigned layers = (old_order / RADIX_TREE_MAP_SHIFT) -
+				(new_order / RADIX_TREE_MAP_SHIFT);
+	unsigned nr = 0;
+
+	WARN_ON_ONCE(!gfpflags_allow_blocking(gfp_mask));
+	BUG_ON(new_order >= old_order);
+
+	while (layers--)
+		nr = nr * RADIX_TREE_MAP_SIZE + 1;
+	return __radix_tree_preload(gfp_mask, top * nr);
+}
+#endif
+
 /*
  * The same as function above, but preload number of nodes required to insert
  * (1 << order) continuous naturally-aligned elements.
diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-add-radix_tree_split_preload tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-add-radix_tree_split_preload
+++ a/tools/testing/radix-tree/multiorder.c
@@ -389,35 +389,67 @@ static void multiorder_join(void)
 	}
 }
 
+static void check_mem(unsigned old_order, unsigned new_order, unsigned alloc)
+{
+	struct radix_tree_preload *rtp = &radix_tree_preloads;
+	if (rtp->nr != 0)
+		printf("split(%u %u) remaining %u\n", old_order, new_order,
+							rtp->nr);
+	/*
+	 * Can't check for equality here as some nodes may have been
+	 * RCU-freed while we ran.  But we should never finish with more
+	 * nodes allocated since they should have all been preloaded.
+	 */
+	if (nr_allocated > alloc)
+		printf("split(%u %u) allocated %u %u\n", old_order, new_order,
+							alloc, nr_allocated);
+}
+
 static void __multiorder_split(int old_order, int new_order)
 {
-	RADIX_TREE(tree, GFP_KERNEL);
+	RADIX_TREE(tree, GFP_ATOMIC);
 	void **slot;
 	struct radix_tree_iter iter;
 	struct radix_tree_node *node;
 	void *item;
+	unsigned alloc;
+
+	radix_tree_preload(GFP_KERNEL);
+	assert(item_insert_order(&tree, 0, old_order) == 0);
+	radix_tree_preload_end();
+
+	/* Wipe out the preloaded cache or it'll confuse check_mem() */
+	radix_tree_cpu_dead(0);
 
-	item_insert_order(&tree, 0, old_order);
 	radix_tree_tag_set(&tree, 0, 2);
+
+	radix_tree_split_preload(old_order, new_order, GFP_KERNEL);
+	alloc = nr_allocated;
 	radix_tree_split(&tree, 0, new_order);
+	check_mem(old_order, new_order, alloc);
 	radix_tree_for_each_slot(slot, &tree, &iter, 0) {
 		radix_tree_iter_replace(&tree, &iter, slot,
 					item_create(iter.index, new_order));
 	}
+	radix_tree_preload_end();
 
 	item_kill_tree(&tree);
 
+	radix_tree_preload(GFP_KERNEL);
 	__radix_tree_insert(&tree, 0, old_order, (void *)0x12);
+	radix_tree_preload_end();
 
 	item = __radix_tree_lookup(&tree, 0, &node, NULL);
 	assert(item == (void *)0x12);
 	assert(node->exceptional > 0);
 
+	radix_tree_split_preload(old_order, new_order, GFP_KERNEL);
 	radix_tree_split(&tree, 0, new_order);
 	radix_tree_for_each_slot(slot, &tree, &iter, 0) {
 		radix_tree_iter_replace(&tree, &iter, slot,
 					item_create(iter.index, new_order));
 	}
+	radix_tree_preload_end();
 
 	item = __radix_tree_lookup(&tree, 0, &node, NULL);
 	assert(item != (void *)0x12);
@@ -425,16 +457,20 @@ static void __multiorder_split(int old_o
 
 	item_kill_tree(&tree);
 
+	radix_tree_preload(GFP_KERNEL);
 	__radix_tree_insert(&tree, 0, old_order, (void *)0x12);
+	radix_tree_preload_end();
 
 	item = __radix_tree_lookup(&tree, 0, &node, NULL);
 	assert(item == (void *)0x12);
 	assert(node->exceptional > 0);
 
+	radix_tree_split_preload(old_order, new_order, GFP_KERNEL);
 	radix_tree_split(&tree, 0, new_order);
 	radix_tree_for_each_slot(slot, &tree, &iter, 0) {
 		radix_tree_iter_replace(&tree, &iter, slot, (void *)0x16);
 	}
+	radix_tree_preload_end();
 
 	item = __radix_tree_lookup(&tree, 0, &node, NULL);
 	assert(item == (void *)0x16);
@@ -471,4 +507,6 @@ void multiorder_checks(void)
 	multiorder_tagged_iteration();
 	multiorder_join();
 	multiorder_split();
+
+	radix_tree_cpu_dead(0);
 }
diff -puN tools/testing/radix-tree/test.h~radix-tree-add-radix_tree_split_preload tools/testing/radix-tree/test.h
--- a/tools/testing/radix-tree/test.h~radix-tree-add-radix_tree_split_preload
+++ a/tools/testing/radix-tree/test.h
@@ -52,3 +52,8 @@ int root_tag_get(struct radix_tree_root
 unsigned long node_maxindex(struct radix_tree_node *);
 unsigned long shift_maxindex(unsigned int shift);
 int radix_tree_cpu_dead(unsigned int cpu);
+struct radix_tree_preload {
+	unsigned nr;
+	struct radix_tree_node *nodes;
+};
+extern struct radix_tree_preload radix_tree_preloads;
_
