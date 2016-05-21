From: akpm@linux-foundation.org
Subject: [patch 124/162] radix-tree: rewrite radix_tree_locate_item
Date: Fri, 20 May 2016 17:02:46 -0700
Message-ID: <573fa5a6.IPub8nlVRrJCRHcr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbcEUACs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: rewrite radix_tree_locate_item

Use the new multi-order support functions to rewrite
radix_tree_locate_item().  Modify the locate tests to test multiorder
entries too.

[hughd@google.com: radix_tree_locate_item() is often returning the wrong index]
  Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1605012108490.1166@eggly.anvils
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                |   87 ++++++++++++++----------------
 tools/testing/radix-tree/main.c |   30 ++++++----
 2 files changed, 61 insertions(+), 56 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-rewrite-radix_tree_locate_item lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rewrite-radix_tree_locate_item
+++ a/lib/radix-tree.c
@@ -1303,58 +1303,54 @@ EXPORT_SYMBOL(radix_tree_gang_lookup_tag
 #if defined(CONFIG_SHMEM) && defined(CONFIG_SWAP)
 #include <linux/sched.h> /* for cond_resched() */
 
+struct locate_info {
+	unsigned long found_index;
+	bool stop;
+};
+
 /*
  * This linear search is at present only useful to shmem_unuse_inode().
  */
 static unsigned long __locate(struct radix_tree_node *slot, void *item,
-			      unsigned long index, unsigned long *found_index)
+			      unsigned long index, struct locate_info *info)
 {
 	unsigned int shift, height;
 	unsigned long i;
 
 	height = slot->path & RADIX_TREE_HEIGHT_MASK;
-	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+	shift = height * RADIX_TREE_MAP_SHIFT;
 
-	for ( ; height > 1; height--) {
-		i = (index >> shift) & RADIX_TREE_MAP_MASK;
-		for (;;) {
-			if (slot->slots[i] != NULL)
-				break;
-			index &= ~((1UL << shift) - 1);
-			index += 1UL << shift;
-			if (index == 0)
-				goto out;	/* 32-bit wraparound */
-			i++;
-			if (i == RADIX_TREE_MAP_SIZE)
-				goto out;
-		}
+	do {
+		shift -= RADIX_TREE_MAP_SHIFT;
 
-		slot = rcu_dereference_raw(slot->slots[i]);
-		if (slot == NULL)
-			goto out;
-		if (!radix_tree_is_indirect_ptr(slot)) {
-			if (slot == item) {
-				*found_index = index + i;
-				index = 0;
-			} else {
-				index += shift;
+		for (i = (index >> shift) & RADIX_TREE_MAP_MASK;
+		     i < RADIX_TREE_MAP_SIZE;
+		     i++, index += (1UL << shift)) {
+			struct radix_tree_node *node =
+					rcu_dereference_raw(slot->slots[i]);
+			if (node == RADIX_TREE_RETRY)
+				goto out;
+			if (!radix_tree_is_indirect_ptr(node)) {
+				if (node == item) {
+					info->found_index = index;
+					info->stop = true;
+					goto out;
+				}
+				continue;
 			}
-			goto out;
+			node = indirect_to_ptr(node);
+			if (is_sibling_entry(slot, node))
+				continue;
+			slot = node;
+			break;
 		}
-		slot = indirect_to_ptr(slot);
-		shift -= RADIX_TREE_MAP_SHIFT;
-	}
+		if (i == RADIX_TREE_MAP_SIZE)
+			break;
+	} while (shift);
 
-	/* Bottom level: check items */
-	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
-		if (slot->slots[i] == item) {
-			*found_index = index + i;
-			index = 0;
-			goto out;
-		}
-	}
-	index += RADIX_TREE_MAP_SIZE;
 out:
+	if ((index == 0) && (i == RADIX_TREE_MAP_SIZE))
+		info->stop = true;
 	return index;
 }
 
@@ -1372,7 +1368,10 @@ unsigned long radix_tree_locate_item(str
 	struct radix_tree_node *node;
 	unsigned long max_index;
 	unsigned long cur_index = 0;
-	unsigned long found_index = -1;
+	struct locate_info info = {
+		.found_index = -1,
+		.stop = false,
+	};
 
 	do {
 		rcu_read_lock();
@@ -1380,24 +1379,24 @@ unsigned long radix_tree_locate_item(str
 		if (!radix_tree_is_indirect_ptr(node)) {
 			rcu_read_unlock();
 			if (node == item)
-				found_index = 0;
+				info.found_index = 0;
 			break;
 		}
 
 		node = indirect_to_ptr(node);
-		max_index = radix_tree_maxindex(node->path &
-						RADIX_TREE_HEIGHT_MASK);
+
+		max_index = node_maxindex(node);
 		if (cur_index > max_index) {
 			rcu_read_unlock();
 			break;
 		}
 
-		cur_index = __locate(node, item, cur_index, &found_index);
+		cur_index = __locate(node, item, cur_index, &info);
 		rcu_read_unlock();
 		cond_resched();
-	} while (cur_index != 0 && cur_index <= max_index);
+	} while (!info.stop && cur_index <= max_index);
 
-	return found_index;
+	return info.found_index;
 }
 #else
 unsigned long radix_tree_locate_item(struct radix_tree_root *root, void *item)
diff -puN tools/testing/radix-tree/main.c~radix-tree-rewrite-radix_tree_locate_item tools/testing/radix-tree/main.c
--- a/tools/testing/radix-tree/main.c~radix-tree-rewrite-radix_tree_locate_item
+++ a/tools/testing/radix-tree/main.c
@@ -232,17 +232,18 @@ void copy_tag_check(void)
 	item_kill_tree(&tree);
 }
 
-void __locate_check(struct radix_tree_root *tree, unsigned long index)
+void __locate_check(struct radix_tree_root *tree, unsigned long index,
+			unsigned order)
 {
 	struct item *item;
 	unsigned long index2;
 
-	item_insert(tree, index);
+	item_insert_order(tree, index, order);
 	item = item_lookup(tree, index);
 	index2 = radix_tree_locate_item(tree, item);
 	if (index != index2) {
-		printf("index %ld inserted; found %ld\n",
-			index, index2);
+		printf("index %ld order %d inserted; found %ld\n",
+			index, order, index2);
 		abort();
 	}
 }
@@ -250,21 +251,26 @@ void __locate_check(struct radix_tree_ro
 static void locate_check(void)
 {
 	RADIX_TREE(tree, GFP_KERNEL);
+	unsigned order;
 	unsigned long offset, index;
 
-	for (offset = 0; offset < (1 << 3); offset++) {
-		for (index = 0; index < (1UL << 5); index++) {
-			__locate_check(&tree, index + offset);
-		}
-		if (radix_tree_locate_item(&tree, &tree) != -1)
-			abort();
+	for (order = 0; order < 20; order++) {
+		for (offset = 0; offset < (1 << (order + 3));
+		     offset += (1UL << order)) {
+			for (index = 0; index < (1UL << (order + 5));
+			     index += (1UL << order)) {
+				__locate_check(&tree, index + offset, order);
+			}
+			if (radix_tree_locate_item(&tree, &tree) != -1)
+				abort();
 
-		item_kill_tree(&tree);
+			item_kill_tree(&tree);
+		}
 	}
 
 	if (radix_tree_locate_item(&tree, &tree) != -1)
 		abort();
-	__locate_check(&tree, -1);
+	__locate_check(&tree, -1, 0);
 	if (radix_tree_locate_item(&tree, &tree) != -1)
 		abort();
 	item_kill_tree(&tree);
_
