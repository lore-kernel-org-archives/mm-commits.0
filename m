From: akpm@linux-foundation.org
Subject: [patch 1/4] mm: workingset: fix crash in shadow node shrinker
 caused by replace_page_cache_page()
Date: Fri, 30 Sep 2016 15:11:29 -0700
Message-ID: <57eee311.w/s9dgzyaSAImDGA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43856 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbcI3WLa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2016 18:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, miklos@szeredi.hu, stable@vger.kernel.org, trapexit@spawn.link

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: fix crash in shadow node shrinker caused by replace_page_cache_page()

Antonio reports the following crash when using fuse under memory pressure:

[25192.515454] kernel BUG at /build/linux-a2WvEb/linux-4.4.0/mm/workingset.c:346!
[25192.517521] invalid opcode: 0000 [#1] SMP
[25192.519602] Modules linked in: all of them
[25192.540910] CPU: 2 PID: 63 Comm: kswapd0 Not tainted 4.4.0-36-generic #55-Ubuntu
[25192.543411] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[25192.545840] task: ffff88040cae6040 ti: ffff880407488000 task.ti: ffff880407488000
[25192.548277] RIP: 0010:[<ffffffff811ba501>]  [<ffffffff811ba501>] shadow_lru_isolate+0x181/0x190
[25192.550706] RSP: 0018:ffff88040748bbe0  EFLAGS: 00010002
[25192.553127] RAX: 0000000000001c81 RBX: ffff8802f91ee928 RCX: ffff8802f91eeb38
[25192.555544] RDX: ffff8802f91ee938 RSI: ffff8802f91ee928 RDI: ffff8804099ba2c0
[25192.557914] RBP: ffff88040748bc08 R08: 000000000001a7b6 R09: 000000000000003f
[25192.560237] R10: 000000000001a750 R11: 0000000000000000 R12: ffff8804099ba2c0
[25192.562512] R13: ffff8803157e9680 R14: ffff8803157e9668 R15: ffff8804099ba2c8
[25192.564724] FS:  0000000000000000(0000) GS:ffff88041f280000(0000) knlGS:0000000000000000
[25192.566990] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25192.569201] CR2: 00007ffabb690000 CR3: 0000000001e0a000 CR4: 00000000000406e0
[25192.571419] Stack:
[25192.573550]  ffff8804099ba2c0 ffff88039e4f86f0 ffff8802f91ee928 ffff8804099ba2c8
[25192.575695]  ffff88040748bd08 ffff88040748bc58 ffffffff811b99bf 0000000000000052
[25192.577814]  0000000000000000 ffffffff811ba380 000000000000008a 0000000000000080
[25192.579947] Call Trace:
[25192.582022]  [<ffffffff811b99bf>] __list_lru_walk_one.isra.3+0x8f/0x130
[25192.584137]  [<ffffffff811ba380>] ? memcg_drain_all_list_lrus+0x190/0x190
[25192.586165]  [<ffffffff811b9a83>] list_lru_walk_one+0x23/0x30
[25192.588145]  [<ffffffff811ba544>] scan_shadow_nodes+0x34/0x50
[25192.590074]  [<ffffffff811a0e9d>] shrink_slab.part.40+0x1ed/0x3d0
[25192.591985]  [<ffffffff811a53da>] shrink_zone+0x2ca/0x2e0
[25192.593863]  [<ffffffff811a64ce>] kswapd+0x51e/0x990
[25192.595737]  [<ffffffff811a5fb0>] ? mem_cgroup_shrink_node_zone+0x1c0/0x1c0
[25192.597613]  [<ffffffff810a0808>] kthread+0xd8/0xf0
[25192.599495]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[25192.601335]  [<ffffffff8182e34f>] ret_from_fork+0x3f/0x70
[25192.603193]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[25192.605083] Code: Red
[25192.609252] RIP  [<ffffffff811ba501>] shadow_lru_isolate+0x181/0x190
[25192.611304]  RSP <ffff88040748bbe0>

which corresponds to the following sanity check in the shadow node
tracking:

  BUG_ON(node->count & RADIX_TREE_COUNT_MASK);

The workingset code tracks radix tree nodes that exclusively contain
shadow entries of evicted pages in them, and this (somewhat obscure) line
checks whether there are real pages left that would interfere with reclaim
of the radix tree node under memory pressure.

While discussing ways how fuse might sneak pages into the radix tree past
the workingset code, Miklos pointed to replace_page_cache_page(), and
indeed there is a problem there: it properly accounts for the old page
being removed - __delete_from_page_cache() does that - but then does a raw
raw radix_tree_insert(), not accounting for the replacement page. 
Eventually the page count bits in node->count underflow while leaving the
node incorrectly linked to the shadow node LRU.

To address this, make sure replace_page_cache_page() uses the tracked page
insertion code, page_cache_tree_insert().  This fixes the page accounting
and makes sure page-containing nodes are properly unlinked from the shadow
node LRU again.

Also, make the sanity checks a bit less obscure by using the helpers for
checking the number of pages and shadows in a radix tree node.

Fixes: 449dd6984d0e ("mm: keep page cache radix tree nodes in check")
Link: http://lkml.kernel.org/r/20160919155822.29498-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Antonio SJ Musumeci <trapexit@spawn.link>
Debugged-by: Miklos Szeredi <miklos@szeredi.hu>
Cc: <stable@vger.kernel.org>	[3.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 
 mm/filemap.c         |  114 ++++++++++++++++++++---------------------
 mm/workingset.c      |   10 +--
 3 files changed, 63 insertions(+), 63 deletions(-)

diff -puN include/linux/swap.h~mm-workingset-fix-crash-in-shadow-node-shrinker-caused-by-replace_page_cache_page include/linux/swap.h
--- a/include/linux/swap.h~mm-workingset-fix-crash-in-shadow-node-shrinker-caused-by-replace_page_cache_page
+++ a/include/linux/swap.h
@@ -257,6 +257,7 @@ static inline void workingset_node_pages
 
 static inline void workingset_node_pages_dec(struct radix_tree_node *node)
 {
+	VM_BUG_ON(!workingset_node_pages(node));
 	node->count--;
 }
 
@@ -272,6 +273,7 @@ static inline void workingset_node_shado
 
 static inline void workingset_node_shadows_dec(struct radix_tree_node *node)
 {
+	VM_BUG_ON(!workingset_node_shadows(node));
 	node->count -= 1U << RADIX_TREE_COUNT_SHIFT;
 }
 
diff -puN mm/filemap.c~mm-workingset-fix-crash-in-shadow-node-shrinker-caused-by-replace_page_cache_page mm/filemap.c
--- a/mm/filemap.c~mm-workingset-fix-crash-in-shadow-node-shrinker-caused-by-replace_page_cache_page
+++ a/mm/filemap.c
@@ -110,6 +110,62 @@
  *   ->tasklist_lock            (memory_failure, collect_procs_ao)
  */
 
+static int page_cache_tree_insert(struct address_space *mapping,
+				  struct page *page, void **shadowp)
+{
+	struct radix_tree_node *node;
+	void **slot;
+	int error;
+
+	error = __radix_tree_create(&mapping->page_tree, page->index, 0,
+				    &node, &slot);
+	if (error)
+		return error;
+	if (*slot) {
+		void *p;
+
+		p = radix_tree_deref_slot_protected(slot, &mapping->tree_lock);
+		if (!radix_tree_exceptional_entry(p))
+			return -EEXIST;
+
+		mapping->nrexceptional--;
+		if (!dax_mapping(mapping)) {
+			if (shadowp)
+				*shadowp = p;
+			if (node)
+				workingset_node_shadows_dec(node);
+		} else {
+			/* DAX can replace empty locked entry with a hole */
+			WARN_ON_ONCE(p !=
+				(void *)(RADIX_TREE_EXCEPTIONAL_ENTRY |
+					 RADIX_DAX_ENTRY_LOCK));
+			/* DAX accounts exceptional entries as normal pages */
+			if (node)
+				workingset_node_pages_dec(node);
+			/* Wakeup waiters for exceptional entry lock */
+			dax_wake_mapping_entry_waiter(mapping, page->index,
+						      false);
+		}
+	}
+	radix_tree_replace_slot(slot, page);
+	mapping->nrpages++;
+	if (node) {
+		workingset_node_pages_inc(node);
+		/*
+		 * Don't track node that contains actual pages.
+		 *
+		 * Avoid acquiring the list_lru lock if already
+		 * untracked.  The list_empty() test is safe as
+		 * node->private_list is protected by
+		 * mapping->tree_lock.
+		 */
+		if (!list_empty(&node->private_list))
+			list_lru_del(&workingset_shadow_nodes,
+				     &node->private_list);
+	}
+	return 0;
+}
+
 static void page_cache_tree_delete(struct address_space *mapping,
 				   struct page *page, void *shadow)
 {
@@ -561,7 +617,7 @@ int replace_page_cache_page(struct page
 
 		spin_lock_irqsave(&mapping->tree_lock, flags);
 		__delete_from_page_cache(old, NULL);
-		error = radix_tree_insert(&mapping->page_tree, offset, new);
+		error = page_cache_tree_insert(mapping, new, NULL);
 		BUG_ON(error);
 		mapping->nrpages++;
 
@@ -584,62 +640,6 @@ int replace_page_cache_page(struct page
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
-static int page_cache_tree_insert(struct address_space *mapping,
-				  struct page *page, void **shadowp)
-{
-	struct radix_tree_node *node;
-	void **slot;
-	int error;
-
-	error = __radix_tree_create(&mapping->page_tree, page->index, 0,
-				    &node, &slot);
-	if (error)
-		return error;
-	if (*slot) {
-		void *p;
-
-		p = radix_tree_deref_slot_protected(slot, &mapping->tree_lock);
-		if (!radix_tree_exceptional_entry(p))
-			return -EEXIST;
-
-		mapping->nrexceptional--;
-		if (!dax_mapping(mapping)) {
-			if (shadowp)
-				*shadowp = p;
-			if (node)
-				workingset_node_shadows_dec(node);
-		} else {
-			/* DAX can replace empty locked entry with a hole */
-			WARN_ON_ONCE(p !=
-				(void *)(RADIX_TREE_EXCEPTIONAL_ENTRY |
-					 RADIX_DAX_ENTRY_LOCK));
-			/* DAX accounts exceptional entries as normal pages */
-			if (node)
-				workingset_node_pages_dec(node);
-			/* Wakeup waiters for exceptional entry lock */
-			dax_wake_mapping_entry_waiter(mapping, page->index,
-						      false);
-		}
-	}
-	radix_tree_replace_slot(slot, page);
-	mapping->nrpages++;
-	if (node) {
-		workingset_node_pages_inc(node);
-		/*
-		 * Don't track node that contains actual pages.
-		 *
-		 * Avoid acquiring the list_lru lock if already
-		 * untracked.  The list_empty() test is safe as
-		 * node->private_list is protected by
-		 * mapping->tree_lock.
-		 */
-		if (!list_empty(&node->private_list))
-			list_lru_del(&workingset_shadow_nodes,
-				     &node->private_list);
-	}
-	return 0;
-}
-
 static int __add_to_page_cache_locked(struct page *page,
 				      struct address_space *mapping,
 				      pgoff_t offset, gfp_t gfp_mask,
diff -puN mm/workingset.c~mm-workingset-fix-crash-in-shadow-node-shrinker-caused-by-replace_page_cache_page mm/workingset.c
--- a/mm/workingset.c~mm-workingset-fix-crash-in-shadow-node-shrinker-caused-by-replace_page_cache_page
+++ a/mm/workingset.c
@@ -418,21 +418,19 @@ static enum lru_status shadow_lru_isolat
 	 * no pages, so we expect to be able to remove them all and
 	 * delete and free the empty node afterwards.
 	 */
