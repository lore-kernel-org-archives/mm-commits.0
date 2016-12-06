From: akpm@linux-foundation.org
Subject: + radix-tree-delete-radix_tree_locate_item.patch added to -mm
 tree
Date: Tue, 06 Dec 2016 12:50:52 -0800
Message-ID: <584724ac.1jVdOEdziQwiI7rh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36994 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbcLFUuX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:50:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: delete radix_tree_locate_item()
has been added to the -mm tree.  Its filename is
     radix-tree-delete-radix_tree_locate_item.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-delete-radix_tree_locate_item.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-delete-radix_tree_locate_item.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: radix-tree: delete radix_tree_locate_item()

This rather complicated function can be better implemented as an iterator.
It has only one caller, so move the functionality to the only place that
needs it.  Update the test suite to follow the same pattern.

Link: http://lkml.kernel.org/r/1480369871-5271-56-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h      |    1 
 lib/radix-tree.c                |   99 ------------------------------
 mm/shmem.c                      |   26 +++++++
 tools/testing/radix-tree/main.c |    8 +-
 tools/testing/radix-tree/test.c |   22 ++++++
 tools/testing/radix-tree/test.h |    2 
 6 files changed, 53 insertions(+), 105 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-delete-radix_tree_locate_item include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-delete-radix_tree_locate_item
+++ a/include/linux/radix-tree.h
@@ -296,7 +296,6 @@ unsigned long radix_tree_range_tag_if_ta
 		unsigned long nr_to_tag,
 		unsigned int fromtag, unsigned int totag);
 int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
-unsigned long radix_tree_locate_item(struct radix_tree_root *root, void *item);
 
 static inline void radix_tree_preload_end(void)
 {
diff -puN lib/radix-tree.c~radix-tree-delete-radix_tree_locate_item lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-delete-radix_tree_locate_item
+++ a/lib/radix-tree.c
@@ -1578,105 +1578,6 @@ radix_tree_gang_lookup_tag_slot(struct r
 }
 EXPORT_SYMBOL(radix_tree_gang_lookup_tag_slot);
 
-#if defined(CONFIG_SHMEM) && defined(CONFIG_SWAP)
-#include <linux/sched.h> /* for cond_resched() */
-
-struct locate_info {
-	unsigned long found_index;
-	bool stop;
-};
-
-/*
- * This linear search is at present only useful to shmem_unuse_inode().
- */
-static unsigned long __locate(struct radix_tree_node *slot, void *item,
-			      unsigned long index, struct locate_info *info)
-{
-	unsigned long i;
-
-	do {
-		unsigned int shift = slot->shift;
-
-		for (i = (index >> shift) & RADIX_TREE_MAP_MASK;
-		     i < RADIX_TREE_MAP_SIZE;
-		     i++, index += (1UL << shift)) {
-			struct radix_tree_node *node =
-					rcu_dereference_raw(slot->slots[i]);
-			if (node == RADIX_TREE_RETRY)
-				goto out;
-			if (!radix_tree_is_internal_node(node)) {
-				if (node == item) {
-					info->found_index = index;
-					info->stop = true;
-					goto out;
-				}
-				continue;
-			}
-			node = entry_to_node(node);
-			if (is_sibling_entry(slot, node))
-				continue;
-			slot = node;
-			break;
-		}
-	} while (i < RADIX_TREE_MAP_SIZE);
-
-out:
-	if ((index == 0) && (i == RADIX_TREE_MAP_SIZE))
-		info->stop = true;
-	return index;
-}
-
-/**
- *	radix_tree_locate_item - search through radix tree for item
- *	@root:		radix tree root
- *	@item:		item to be found
- *
- *	Returns index where item was found, or -1 if not found.
- *	Caller must hold no lock (since this time-consuming function needs
- *	to be preemptible), and must check afterwards if item is still there.
- */
-unsigned long radix_tree_locate_item(struct radix_tree_root *root, void *item)
-{
-	struct radix_tree_node *node;
-	unsigned long max_index;
-	unsigned long cur_index = 0;
-	struct locate_info info = {
-		.found_index = -1,
-		.stop = false,
-	};
-
-	do {
-		rcu_read_lock();
-		node = rcu_dereference_raw(root->rnode);
-		if (!radix_tree_is_internal_node(node)) {
-			rcu_read_unlock();
-			if (node == item)
-				info.found_index = 0;
-			break;
-		}
-
-		node = entry_to_node(node);
-
-		max_index = node_maxindex(node);
-		if (cur_index > max_index) {
-			rcu_read_unlock();
-			break;
-		}
-
-		cur_index = __locate(node, item, cur_index, &info);
-		rcu_read_unlock();
-		cond_resched();
-	} while (!info.stop && cur_index <= max_index);
-
-	return info.found_index;
-}
-#else
-unsigned long radix_tree_locate_item(struct radix_tree_root *root, void *item)
-{
-	return -1;
-}
-#endif /* CONFIG_SHMEM && CONFIG_SWAP */
-
 /**
  *	__radix_tree_delete_node    -    try to free node after clearing a slot
  *	@root:		radix tree root
diff -puN mm/shmem.c~radix-tree-delete-radix_tree_locate_item mm/shmem.c
--- a/mm/shmem.c~radix-tree-delete-radix_tree_locate_item
+++ a/mm/shmem.c
@@ -1049,6 +1049,30 @@ static void shmem_evict_inode(struct ino
 	clear_inode(inode);
 }
 
+static unsigned long find_swap_entry(struct radix_tree_root *root, void *item)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+	unsigned long found = -1;
+	unsigned int checked = 0;
+
+	rcu_read_lock();
+	radix_tree_for_each_slot(slot, root, &iter, 0) {
+		if (*slot == item) {
+			found = iter.index;
+			break;
+		}
+		checked++;
+		if ((checked % 4096) != 0)
+			continue;
+		slot = radix_tree_iter_resume(slot, &iter);
+		cond_resched_rcu();
+	}
+
+	rcu_read_unlock();
+	return found;
+}
+
 /*
  * If swap found in inode, free it and move page from swapcache to filecache.
  */
@@ -1062,7 +1086,7 @@ static int shmem_unuse_inode(struct shme
 	int error = 0;
 
 	radswap = swp_to_radix_entry(swap);
-	index = radix_tree_locate_item(&mapping->page_tree, radswap);
+	index = find_swap_entry(&mapping->page_tree, radswap);
 	if (index == -1)
 		return -EAGAIN;	/* tell shmem_unuse we found nothing */
 
diff -puN tools/testing/radix-tree/main.c~radix-tree-delete-radix_tree_locate_item tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-delete-radix_tree_locate_item
+++ a/tools/testing/radix-tree/main.c
@@ -239,7 +239,7 @@ static void __locate_check(struct radix_
 
 	item_insert_order(tree, index, order);
 	item = item_lookup(tree, index);
-	index2 = radix_tree_locate_item(tree, item);
+	index2 = find_item(tree, item);
 	if (index != index2) {
 		printf("index %ld order %d inserted; found %ld\n",
 			index, order, index2);
@@ -273,17 +273,17 @@ static void locate_check(void)
 			     index += (1UL << order)) {
 				__locate_check(&tree, index + offset, order);
 			}
-			if (radix_tree_locate_item(&tree, &tree) != -1)
+			if (find_item(&tree, &tree) != -1)
 				abort();
 
 			item_kill_tree(&tree);
 		}
 	}
 
-	if (radix_tree_locate_item(&tree, &tree) != -1)
+	if (find_item(&tree, &tree) != -1)
 		abort();
 	__locate_check(&tree, -1, 0);
-	if (radix_tree_locate_item(&tree, &tree) != -1)
+	if (find_item(&tree, &tree) != -1)
 		abort();
 	item_kill_tree(&tree);
 }
diff -puN tools/testing/radix-tree/test.c~radix-tree-delete-radix_tree_locate_item tools/testing/radix-tree/test.c
--- a/tools/testing/radix-tree/test.c~radix-tree-delete-radix_tree_locate_item
+++ a/tools/testing/radix-tree/test.c
@@ -151,6 +151,28 @@ void item_full_scan(struct radix_tree_ro
 	assert(nfound == 0);
 }
 
+/* Use the same pattern as find_swap_entry() in mm/shmem.c */
+unsigned long find_item(struct radix_tree_root *root, void *item)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+	unsigned long found = -1;
+	unsigned long checked = 0;
+
+	radix_tree_for_each_slot(slot, root, &iter, 0) {
+		if (*slot == item) {
+			found = iter.index;
+			break;
+		}
+		checked++;
+		if ((checked % 4) != 0)
+			continue;
+		slot = radix_tree_iter_resume(slot, &iter);
+	}
+
+	return found;
+}
+
 static int verify_node(struct radix_tree_node *slot, unsigned int tag,
 			int tagged)
 {
diff -puN tools/testing/radix-tree/test.h~radix-tree-delete-radix_tree_locate_item tools/testing/radix-tree/test.h
--- a/tools/testing/radix-tree/test.h~radix-tree-delete-radix_tree_locate_item
+++ a/tools/testing/radix-tree/test.h
@@ -25,6 +25,8 @@ void item_full_scan(struct radix_tree_ro
 			unsigned long nr, int chunk);
 void item_kill_tree(struct radix_tree_root *root);
 
+unsigned long find_item(struct radix_tree_root *, void *item);
+
 void tag_check(void);
 void multiorder_checks(void);
 void iteration_test(void);
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

radix-tree-test-suite-fix-compilation.patch
radix-tree-test-suite-iteration-test-misuses-rcu.patch
radix-tree-test-suite-use-rcu_barrier.patch
radix-tree-test-suite-handle-exceptional-entries.patch
radix-tree-test-suite-record-order-in-each-item.patch
btrfs-fix-race-in-btrfs_free_dummy_fs_info.patch
radix-tree-improve-multiorder-iterators.patch
radix-tree-delete-radix_tree_locate_item.patch
radix-tree-delete-radix_tree_range_tag_if_tagged.patch
radix-tree-fix-replacement-for-multiorder-entries.patch
radix-tree-test-suite-check-multiorder-iteration.patch
tpm-use-idr_find-not-idr_find_slowpath.patch
rxrpc-abstract-away-knowledge-of-idr-internals.patch

