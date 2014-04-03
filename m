From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch removed from -mm
 tree
Date: Thu, 03 Apr 2014 14:06:17 -0700
Message-ID: <533dcd49.FCHr98JgIN2zhZyc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaDCVGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:06:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, minchan@kernel.org, hughd@google.com, hannes@cmpxchg.org

Subject: [folded-merged] mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch removed from -mm tree
To: hannes@cmpxchg.org,hughd@google.com,minchan@kernel.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:06:17 -0700


The patch titled
     Subject: mm-keep-page-cache-radix-tree-nodes-in-check-fix
has been removed from the -mm tree.  Its filename was
     mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch

This patch was dropped because it was folded into mm-keep-page-cache-radix-tree-nodes-in-check.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-keep-page-cache-radix-tree-nodes-in-check-fix

Hugh Dickin reports the following lockdep splat:

======================================================
[ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
3.14.0-rc1-mm1 #1 Not tainted
------------------------------------------------------
kswapd0/48 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&(&lru->node[i].lock)->rlock){+.+.-.}, at: [<ffffffff81117064>] list_lru_add+0x80/0xf4

s already holding:
 (&(&mapping->tree_lock)->rlock){..-.-.}, at: [<ffffffff81108c63>] __remove_mapping+0x3b/0x12d
which would create a new lock dependency:
 (&(&mapping->tree_lock)->rlock){..-.-.} -> (&(&lru->node[i].lock)->rlock){+.+.-.}

lru->node[i].lock nests inside the mapping->tree_lock when page cache
insertions and deletions add or remove radix tree nodes to the shadow
LRU list.

However, paths that only hold the IRQ-unsafe lru->node[i].lock, like
the shadow shrinker, can be interrupted at any time by the IO
completion handler, which in turn acquires the mapping->tree_lock.
This is a simple locking order inversion and can deadlock like so:

CPU#0: shadow shrinker          CPU#1: page cache modification
lru->node[i].lock
                                mapping->tree_lock
                                lru->node[i].lock
<interrupt>
mapping->tree_lock

Make the shadow lru->node[i].lock IRQ-safe to remove the order
dictated by interruption.  This slightly increases the IRQ-disabled
section in the shadow shrinker, but it still drops all locks and
enables IRQ after every reclaimed shadow radix tree node.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    6 +++++-
 mm/list_lru.c            |    4 +++-
 mm/workingset.c          |   24 ++++++++++++++++++++----
 3 files changed, 28 insertions(+), 6 deletions(-)

diff -puN include/linux/list_lru.h~mm-keep-page-cache-radix-tree-nodes-in-check-fix include/linux/list_lru.h
--- a/include/linux/list_lru.h~mm-keep-page-cache-radix-tree-nodes-in-check-fix
+++ a/include/linux/list_lru.h
@@ -34,7 +34,11 @@ struct list_lru {
 };
 
 void list_lru_destroy(struct list_lru *lru);
-int list_lru_init(struct list_lru *lru);
+int list_lru_init_key(struct list_lru *lru, struct lock_class_key *key);
+static inline int list_lru_init(struct list_lru *lru)
+{
+	return list_lru_init_key(lru, NULL);
+}
 
 /**
  * list_lru_add: add an element to the lru list's tail
diff -puN mm/list_lru.c~mm-keep-page-cache-radix-tree-nodes-in-check-fix mm/list_lru.c
--- a/mm/list_lru.c~mm-keep-page-cache-radix-tree-nodes-in-check-fix
+++ a/mm/list_lru.c
@@ -124,7 +124,7 @@ restart:
 }
 EXPORT_SYMBOL_GPL(list_lru_walk_node);
 
-int list_lru_init(struct list_lru *lru)
+int list_lru_init_key(struct list_lru *lru, struct lock_class_key *key)
 {
 	int i;
 	size_t size = sizeof(*lru->node) * nr_node_ids;
@@ -136,6 +136,8 @@ int list_lru_init(struct list_lru *lru)
 	nodes_clear(lru->active_nodes);
 	for (i = 0; i < nr_node_ids; i++) {
 		spin_lock_init(&lru->node[i].lock);
+		if (key)
+			lockdep_set_class(&lru->node[i].lock, key);
 		INIT_LIST_HEAD(&lru->node[i].list);
 		lru->node[i].nr_items = 0;
 	}
diff -puN mm/workingset.c~mm-keep-page-cache-radix-tree-nodes-in-check-fix mm/workingset.c
--- a/mm/workingset.c~mm-keep-page-cache-radix-tree-nodes-in-check-fix
+++ a/mm/workingset.c
@@ -273,7 +273,10 @@ static unsigned long count_shadow_nodes(
 	unsigned long max_nodes;
 	unsigned long pages;
 
+	local_irq_disable();
 	shadow_nodes = list_lru_count_node(&workingset_shadow_nodes, sc->nid);
+	local_irq_enable();
+
 	pages = node_present_pages(sc->nid);
 	/*
 	 * Active cache pages are limited to 50% of memory, and shadow
@@ -322,7 +325,7 @@ static enum lru_status shadow_lru_isolat
 	mapping = node->private_data;
 
 	/* Coming from the list, invert the lock order */
-	if (!spin_trylock_irq(&mapping->tree_lock)) {
+	if (!spin_trylock(&mapping->tree_lock)) {
 		spin_unlock(lru_lock);
 		ret = LRU_RETRY;
 		goto out;
@@ -355,10 +358,12 @@ static enum lru_status shadow_lru_isolat
 	if (!__radix_tree_delete_node(&mapping->page_tree, node))
 		BUG();
 
-	spin_unlock_irq(&mapping->tree_lock);
+	spin_unlock(&mapping->tree_lock);
 	ret = LRU_REMOVED_RETRY;
 out:
+	local_irq_enable();
 	cond_resched();
+	local_irq_disable();
 	spin_lock(lru_lock);
 	return ret;
 }
@@ -366,8 +371,13 @@ out:
 static unsigned long scan_shadow_nodes(struct shrinker *shrinker,
 				       struct shrink_control *sc)
 {
-	return list_lru_walk_node(&workingset_shadow_nodes, sc->nid,
+	unsigned long ret;
+
+	local_irq_disable();
+	ret =  list_lru_walk_node(&workingset_shadow_nodes, sc->nid,
 				  shadow_lru_isolate, NULL, &sc->nr_to_scan);
+	local_irq_enable();
+	return ret;
 }
 
 static struct shrinker workingset_shadow_shrinker = {
@@ -377,11 +387,17 @@ static struct shrinker workingset_shadow
 	.flags = SHRINKER_NUMA_AWARE,
 };
 
+/*
+ * Our list_lru->lock is IRQ-safe as it nests inside the IRQ-safe
+ * mapping->tree_lock.
+ */
+static struct lock_class_key shadow_nodes_key;
+
 static int __init workingset_init(void)
 {
 	int ret;
 
-	ret = list_lru_init(&workingset_shadow_nodes);
+	ret = list_lru_init_key(&workingset_shadow_nodes, &shadow_nodes_key);
 	if (ret)
 		goto err;
 	ret = register_shrinker(&workingset_shadow_shrinker);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch

