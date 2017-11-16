From: akpm@linux-foundation.org
Subject: [merged]
 mm-truncate-do-not-check-mapping-for-every-page-being-truncated.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:04:09 -0800
Message-ID: <20171116200409.46bIVY8PT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47284 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933284AbdKPUEK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:04:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@techsingularity.net, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm, truncate: do not check mapping for every page being truncated
has been removed from the -mm tree.  Its filename was
     mm-truncate-do-not-check-mapping-for-every-page-being-truncated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, truncate: do not check mapping for every page being truncated

During truncation, the mapping has already been checked for shmem and dax
so it's known that workingset_update_node is required.  This patch avoids
the checks on mapping for each page being truncated.  In all other cases,
a lookup helper is used to determine if workingset_update_node() needs to
be called.  The one danger is that the API is slightly harder to use as
calling workingset_update_node directly without checking for dax or shmem
mappings could lead to surprises.  However, the API rarely needs to be
used and hopefully the comment is enough to give people the hint.

sparsetruncate (tiny)
                              4.14.0-rc4             4.14.0-rc4
                             oneirq-v1r1        pickhelper-v1r1
Min          Time      141.00 (   0.00%)      140.00 (   0.71%)
1st-qrtle    Time      142.00 (   0.00%)      141.00 (   0.70%)
2nd-qrtle    Time      142.00 (   0.00%)      142.00 (   0.00%)
3rd-qrtle    Time      143.00 (   0.00%)      143.00 (   0.00%)
Max-90%      Time      144.00 (   0.00%)      144.00 (   0.00%)
Max-95%      Time      147.00 (   0.00%)      145.00 (   1.36%)
Max-99%      Time      195.00 (   0.00%)      191.00 (   2.05%)
Max          Time      230.00 (   0.00%)      205.00 (  10.87%)
Amean        Time      144.37 (   0.00%)      143.82 (   0.38%)
Stddev       Time       10.44 (   0.00%)        9.00 (  13.74%)
Coeff        Time        7.23 (   0.00%)        6.26 (  13.41%)
Best99%Amean Time      143.72 (   0.00%)      143.34 (   0.26%)
Best95%Amean Time      142.37 (   0.00%)      142.00 (   0.26%)
Best90%Amean Time      142.19 (   0.00%)      141.85 (   0.24%)
Best75%Amean Time      141.92 (   0.00%)      141.58 (   0.24%)
Best50%Amean Time      141.69 (   0.00%)      141.31 (   0.27%)
Best25%Amean Time      141.38 (   0.00%)      140.97 (   0.29%)

As you'd expect, the gain is marginal but it can be detected.  The
differences in bonnie are all within the noise which is not surprising
given the impact on the microbenchmark.

radix_tree_update_node_t is a callback for some radix operations that
optionally passes in a private field.  The only user of the callback is
workingset_update_node and as it no longer requires a mapping, the private
field is removed.

Link: http://lkml.kernel.org/r/20171018075952.10627-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                              |    2 -
 include/linux/radix-tree.h            |    7 ++---
 include/linux/swap.h                  |   13 +++++++++-
 lib/idr.c                             |    2 -
 lib/radix-tree.c                      |   30 ++++++++++--------------
 mm/filemap.c                          |    7 +++--
 mm/shmem.c                            |    2 -
 mm/truncate.c                         |    2 -
 mm/workingset.c                       |   10 +-------
 tools/testing/radix-tree/multiorder.c |    2 -
 10 files changed, 39 insertions(+), 38 deletions(-)

diff -puN fs/dax.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated fs/dax.c
--- a/fs/dax.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated
+++ a/fs/dax.c
@@ -565,7 +565,7 @@ static void *dax_insert_mapping_entry(st
 		ret = __radix_tree_lookup(page_tree, index, &node, &slot);
 		WARN_ON_ONCE(ret != entry);
 		__radix_tree_replace(page_tree, node, slot,
-				     new_entry, NULL, NULL);
+				     new_entry, NULL);
 		entry = new_entry;
 	}
 
diff -puN include/linux/radix-tree.h~mm-truncate-do-not-check-mapping-for-every-page-being-truncated include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~mm-truncate-do-not-check-mapping-for-every-page-being-truncated
+++ a/include/linux/radix-tree.h
@@ -301,18 +301,17 @@ void *__radix_tree_lookup(const struct r
 void *radix_tree_lookup(const struct radix_tree_root *, unsigned long);
 void __rcu **radix_tree_lookup_slot(const struct radix_tree_root *,
 					unsigned long index);
-typedef void (*radix_tree_update_node_t)(struct radix_tree_node *, void *);
+typedef void (*radix_tree_update_node_t)(struct radix_tree_node *);
 void __radix_tree_replace(struct radix_tree_root *, struct radix_tree_node *,
 			  void __rcu **slot, void *entry,
-			  radix_tree_update_node_t update_node, void *private);
+			  radix_tree_update_node_t update_node);
 void radix_tree_iter_replace(struct radix_tree_root *,
 		const struct radix_tree_iter *, void __rcu **slot, void *entry);
 void radix_tree_replace_slot(struct radix_tree_root *,
 			     void __rcu **slot, void *entry);
 void __radix_tree_delete_node(struct radix_tree_root *,
 			      struct radix_tree_node *,
-			      radix_tree_update_node_t update_node,
-			      void *private);
+			      radix_tree_update_node_t update_node);
 void radix_tree_iter_delete(struct radix_tree_root *,
 			struct radix_tree_iter *iter, void __rcu **slot);
 void *radix_tree_delete_item(struct radix_tree_root *, unsigned long, void *);
diff -puN include/linux/swap.h~mm-truncate-do-not-check-mapping-for-every-page-being-truncated include/linux/swap.h
--- a/include/linux/swap.h~mm-truncate-do-not-check-mapping-for-every-page-being-truncated
+++ a/include/linux/swap.h
@@ -298,7 +298,18 @@ struct vma_swap_readahead {
 void *workingset_eviction(struct address_space *mapping, struct page *page);
 bool workingset_refault(void *shadow);
 void workingset_activation(struct page *page);
-void workingset_update_node(struct radix_tree_node *node, void *private);
+
+/* Do not use directly, use workingset_lookup_update */
+void workingset_update_node(struct radix_tree_node *node);
+
+/* Returns workingset_update_node() if the mapping has shadow entries. */
+#define workingset_lookup_update(mapping)				\
+({									\
+	radix_tree_update_node_t __helper = workingset_update_node;	\
+	if (dax_mapping(mapping) || shmem_mapping(mapping))		\
+		__helper = NULL;					\
+	__helper;							\
+})
 
 /* linux/mm/page_alloc.c */
 extern unsigned long totalram_pages;
diff -puN lib/idr.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated lib/idr.c
--- a/lib/idr.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated
+++ a/lib/idr.c
@@ -171,7 +171,7 @@ void *idr_replace_ext(struct idr *idr, v
 	if (!slot || radix_tree_tag_get(&idr->idr_rt, id, IDR_FREE))
 		return ERR_PTR(-ENOENT);
 
-	__radix_tree_replace(&idr->idr_rt, node, slot, ptr, NULL, NULL);
+	__radix_tree_replace(&idr->idr_rt, node, slot, ptr, NULL);
 
 	return entry;
 }
diff -puN lib/radix-tree.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated lib/radix-tree.c
--- a/lib/radix-tree.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated
+++ a/lib/radix-tree.c
@@ -677,8 +677,7 @@ out:
  *	@root		radix tree root
  */
 static inline bool radix_tree_shrink(struct radix_tree_root *root,
-				     radix_tree_update_node_t update_node,
-				     void *private)
+				     radix_tree_update_node_t update_node)
 {
 	bool shrunk = false;
 
@@ -739,7 +738,7 @@ static inline bool radix_tree_shrink(str
 		if (!radix_tree_is_internal_node(child)) {
 			node->slots[0] = (void __rcu *)RADIX_TREE_RETRY;
 			if (update_node)
-				update_node(node, private);
+				update_node(node);
 		}
 
 		WARN_ON_ONCE(!list_empty(&node->private_list));
@@ -752,7 +751,7 @@ static inline bool radix_tree_shrink(str
 
 static bool delete_node(struct radix_tree_root *root,
 			struct radix_tree_node *node,
-			radix_tree_update_node_t update_node, void *private)
+			radix_tree_update_node_t update_node)
 {
 	bool deleted = false;
 
@@ -762,8 +761,8 @@ static bool delete_node(struct radix_tre
 		if (node->count) {
 			if (node_to_entry(node) ==
 					rcu_dereference_raw(root->rnode))
-				deleted |= radix_tree_shrink(root, update_node,
-								private);
+				deleted |= radix_tree_shrink(root,
+								update_node);
 			return deleted;
 		}
 
@@ -1173,7 +1172,6 @@ static int calculate_count(struct radix_
  * @slot:		pointer to slot in @node
  * @item:		new item to store in the slot.
  * @update_node:	callback for changing leaf nodes
- * @private:		private data to pass to @update_node
  *
  * For use with __radix_tree_lookup().  Caller must hold tree write locked
  * across slot lookup and replacement.
@@ -1181,7 +1179,7 @@ static int calculate_count(struct radix_
 void __radix_tree_replace(struct radix_tree_root *root,
 			  struct radix_tree_node *node,
 			  void __rcu **slot, void *item,
-			  radix_tree_update_node_t update_node, void *private)
+			  radix_tree_update_node_t update_node)
 {
 	void *old = rcu_dereference_raw(*slot);
 	int exceptional = !!radix_tree_exceptional_entry(item) -
@@ -1201,9 +1199,9 @@ void __radix_tree_replace(struct radix_t
 		return;
 
 	if (update_node)
-		update_node(node, private);
+		update_node(node);
 
-	delete_node(root, node, update_node, private);
+	delete_node(root, node, update_node);
 }
 
 /**
@@ -1225,7 +1223,7 @@ void __radix_tree_replace(struct radix_t
 void radix_tree_replace_slot(struct radix_tree_root *root,
 			     void __rcu **slot, void *item)
 {
-	__radix_tree_replace(root, NULL, slot, item, NULL, NULL);
+	__radix_tree_replace(root, NULL, slot, item, NULL);
 }
 EXPORT_SYMBOL(radix_tree_replace_slot);
 
@@ -1242,7 +1240,7 @@ void radix_tree_iter_replace(struct radi
 				const struct radix_tree_iter *iter,
 				void __rcu **slot, void *item)
 {
-	__radix_tree_replace(root, iter->node, slot, item, NULL, NULL);
+	__radix_tree_replace(root, iter->node, slot, item, NULL);
 }
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
@@ -1972,7 +1970,6 @@ EXPORT_SYMBOL(radix_tree_gang_lookup_tag
  *	@root:		radix tree root
  *	@node:		node containing @index
  *	@update_node:	callback for changing leaf nodes
- *	@private:	private data to pass to @update_node
  *
  *	After clearing the slot at @index in @node from radix tree
  *	rooted at @root, call this function to attempt freeing the
@@ -1980,10 +1977,9 @@ EXPORT_SYMBOL(radix_tree_gang_lookup_tag
  */
 void __radix_tree_delete_node(struct radix_tree_root *root,
 			      struct radix_tree_node *node,
-			      radix_tree_update_node_t update_node,
-			      void *private)
+			      radix_tree_update_node_t update_node)
 {
-	delete_node(root, node, update_node, private);
+	delete_node(root, node, update_node);
 }
 
 static bool __radix_tree_delete(struct radix_tree_root *root,
@@ -2001,7 +1997,7 @@ static bool __radix_tree_delete(struct r
 			node_tag_clear(root, node, tag, offset);
 
 	replace_slot(slot, NULL, node, -1, exceptional);
-	return node && delete_node(root, node, NULL, NULL);
+	return node && delete_node(root, node, NULL);
 }
 
 /**
diff -puN mm/filemap.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated mm/filemap.c
--- a/mm/filemap.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated
+++ a/mm/filemap.c
@@ -35,6 +35,7 @@
 #include <linux/hugetlb.h>
 #include <linux/memcontrol.h>
 #include <linux/cleancache.h>
+#include <linux/shmem_fs.h>
 #include <linux/rmap.h>
 #include "internal.h"
 
@@ -134,7 +135,7 @@ static int page_cache_tree_insert(struct
 			*shadowp = p;
 	}
 	__radix_tree_replace(&mapping->page_tree, node, slot, page,
-			     workingset_update_node, mapping);
+			     workingset_lookup_update(mapping));
 	mapping->nrpages++;
 	return 0;
 }
@@ -162,7 +163,7 @@ static void page_cache_tree_delete(struc
 
 		radix_tree_clear_tags(&mapping->page_tree, node, slot);
 		__radix_tree_replace(&mapping->page_tree, node, slot, shadow,
-				     workingset_update_node, mapping);
+				workingset_lookup_update(mapping));
 	}
 
 	page->mapping = NULL;
@@ -359,7 +360,7 @@ page_cache_tree_delete_batch(struct addr
 		}
 		radix_tree_clear_tags(&mapping->page_tree, iter.node, slot);
 		__radix_tree_replace(&mapping->page_tree, iter.node, slot, NULL,
-				     workingset_update_node, mapping);
+				workingset_lookup_update(mapping));
 		total_pages++;
 	}
 	mapping->nrpages -= total_pages;
diff -puN mm/shmem.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated mm/shmem.c
--- a/mm/shmem.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated
+++ a/mm/shmem.c
@@ -338,7 +338,7 @@ static int shmem_radix_tree_replace(stru
 	if (item != expected)
 		return -ENOENT;
 	__radix_tree_replace(&mapping->page_tree, node, pslot,
-			     replacement, NULL, NULL);
+			     replacement, NULL);
 	return 0;
 }
 
diff -puN mm/truncate.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated mm/truncate.c
--- a/mm/truncate.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated
+++ a/mm/truncate.c
@@ -42,7 +42,7 @@ static void clear_shadow_entry(struct ad
 	if (*slot != entry)
 		goto unlock;
 	__radix_tree_replace(&mapping->page_tree, node, slot, NULL,
-			     workingset_update_node, mapping);
+			     workingset_update_node);
 	mapping->nrexceptional--;
 unlock:
 	spin_unlock_irq(&mapping->tree_lock);
diff -puN mm/workingset.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated mm/workingset.c
--- a/mm/workingset.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated
+++ a/mm/workingset.c
@@ -340,14 +340,8 @@ out:
 
 static struct list_lru shadow_nodes;
 
-void workingset_update_node(struct radix_tree_node *node, void *private)
+void workingset_update_node(struct radix_tree_node *node)
 {
-	struct address_space *mapping = private;
-
-	/* Only regular page cache has shadow entries */
-	if (dax_mapping(mapping) || shmem_mapping(mapping))
-		return;
-
 	/*
 	 * Track non-empty nodes that contain only shadow entries;
 	 * unlink those that contain pages or are being freed.
@@ -475,7 +469,7 @@ static enum lru_status shadow_lru_isolat
 		goto out_invalid;
 	inc_lruvec_page_state(virt_to_page(node), WORKINGSET_NODERECLAIM);
 	__radix_tree_delete_node(&mapping->page_tree, node,
-				 workingset_update_node, mapping);
+				 workingset_lookup_update(mapping));
 
 out_invalid:
 	spin_unlock(&mapping->tree_lock);
diff -puN tools/testing/radix-tree/multiorder.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~mm-truncate-do-not-check-mapping-for-every-page-being-truncated
+++ a/tools/testing/radix-tree/multiorder.c
@@ -618,7 +618,7 @@ static void multiorder_account(void)
 	__radix_tree_insert(&tree, 1 << 5, 5, (void *)0x12);
 	__radix_tree_lookup(&tree, 1 << 5, &node, &slot);
 	assert(node->count == node->exceptional * 2);
-	__radix_tree_replace(&tree, node, slot, NULL, NULL, NULL);
+	__radix_tree_replace(&tree, node, slot, NULL, NULL);
 	assert(node->exceptional == 0);
 
 	item_kill_tree(&tree);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


