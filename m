From: akpm@linux-foundation.org
Subject: [patch 032/101] mm, workingset: make working set detection
 node-aware
Date: Thu, 28 Jul 2016 15:46:08 -0700
Message-ID: <579a8b30.1dN3/5YX5qi6Smlr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbcG1WqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, workingset: make working set detection node-aware

Working set and refault detection is still zone-based, fix it.

Link: http://lkml.kernel.org/r/1467970510-21195-16-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++---
 include/linux/vmstat.h |    1 
 mm/vmstat.c            |   20 ++----------------
 mm/workingset.c        |   43 ++++++++++++++++++---------------------
 4 files changed, 26 insertions(+), 44 deletions(-)

diff -puN include/linux/mmzone.h~mm-workingset-make-working-set-detection-node-aware include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-workingset-make-working-set-detection-node-aware
+++ a/include/linux/mmzone.h
@@ -145,9 +145,6 @@ enum zone_stat_item {
 	NUMA_LOCAL,		/* allocation from local node */
 	NUMA_OTHER,		/* allocation from other node */
 #endif
-	WORKINGSET_REFAULT,
-	WORKINGSET_ACTIVATE,
-	WORKINGSET_NODERECLAIM,
 	NR_ANON_THPS,
 	NR_SHMEM_THPS,
 	NR_SHMEM_PMDMAPPED,
@@ -164,6 +161,9 @@ enum node_stat_item {
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	NR_PAGES_SCANNED,	/* pages scanned since last reclaim */
+	WORKINGSET_REFAULT,
+	WORKINGSET_ACTIVATE,
+	WORKINGSET_NODERECLAIM,
 	NR_VM_NODE_STAT_ITEMS
 };
 
diff -puN include/linux/vmstat.h~mm-workingset-make-working-set-detection-node-aware include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-workingset-make-working-set-detection-node-aware
+++ a/include/linux/vmstat.h
@@ -227,7 +227,6 @@ void mod_node_page_state(struct pglist_d
 void inc_node_page_state(struct page *, enum node_stat_item);
 void dec_node_page_state(struct page *, enum node_stat_item);
 
-extern void inc_zone_state(struct zone *, enum zone_stat_item);
 extern void inc_node_state(struct pglist_data *, enum node_stat_item);
 extern void __inc_zone_state(struct zone *, enum zone_stat_item);
 extern void __inc_node_state(struct pglist_data *, enum node_stat_item);
diff -puN mm/vmstat.c~mm-workingset-make-working-set-detection-node-aware mm/vmstat.c
--- a/mm/vmstat.c~mm-workingset-make-working-set-detection-node-aware
+++ a/mm/vmstat.c
@@ -446,11 +446,6 @@ void mod_zone_page_state(struct zone *zo
 }
 EXPORT_SYMBOL(mod_zone_page_state);
 
-void inc_zone_state(struct zone *zone, enum zone_stat_item item)
-{
-	mod_zone_state(zone, item, 1, 1);
-}
-
 void inc_zone_page_state(struct page *page, enum zone_stat_item item)
 {
 	mod_zone_state(page_zone(page), item, 1, 1);
@@ -539,15 +534,6 @@ void mod_zone_page_state(struct zone *zo
 }
 EXPORT_SYMBOL(mod_zone_page_state);
 
-void inc_zone_state(struct zone *zone, enum zone_stat_item item)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__inc_zone_state(zone, item);
-	local_irq_restore(flags);
-}
-
 void inc_zone_page_state(struct page *page, enum zone_stat_item item)
 {
 	unsigned long flags;
@@ -967,9 +953,6 @@ const char * const vmstat_text[] = {
 	"numa_local",
 	"numa_other",
 #endif
-	"workingset_refault",
-	"workingset_activate",
-	"workingset_nodereclaim",
 	"nr_anon_transparent_hugepages",
 	"nr_shmem_hugepages",
 	"nr_shmem_pmdmapped",
@@ -984,6 +967,9 @@ const char * const vmstat_text[] = {
 	"nr_isolated_anon",
 	"nr_isolated_file",
 	"nr_pages_scanned",
+	"workingset_refault",
+	"workingset_activate",
+	"workingset_nodereclaim",
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
diff -puN mm/workingset.c~mm-workingset-make-working-set-detection-node-aware mm/workingset.c
--- a/mm/workingset.c~mm-workingset-make-working-set-detection-node-aware
+++ a/mm/workingset.c
@@ -16,7 +16,7 @@
 /*
  *		Double CLOCK lists
  *
- * Per zone, two clock lists are maintained for file pages: the
+ * Per node, two clock lists are maintained for file pages: the
  * inactive and the active list.  Freshly faulted pages start out at
  * the head of the inactive list and page reclaim scans pages from the
  * tail.  Pages that are accessed multiple times on the inactive list
@@ -141,11 +141,11 @@
  *
  *		Implementation
  *
- * For each zone's file LRU lists, a counter for inactive evictions
- * and activations is maintained (zone->inactive_age).
+ * For each node's file LRU lists, a counter for inactive evictions
+ * and activations is maintained (node->inactive_age).
  *
  * On eviction, a snapshot of this counter (along with some bits to
- * identify the zone) is stored in the now empty page cache radix tree
+ * identify the node) is stored in the now empty page cache radix tree
  * slot of the evicted page.  This is called a shadow entry.
  *
  * On cache misses for which there are shadow entries, an eligible
@@ -153,7 +153,7 @@
  */
 
 #define EVICTION_SHIFT	(RADIX_TREE_EXCEPTIONAL_ENTRY + \
-			 ZONES_SHIFT + NODES_SHIFT +	\
+			 NODES_SHIFT +	\
 			 MEM_CGROUP_ID_SHIFT)
 #define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
 
@@ -167,33 +167,30 @@
  */
 static unsigned int bucket_order __read_mostly;
 
-static void *pack_shadow(int memcgid, struct zone *zone, unsigned long eviction)
+static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long eviction)
 {
 	eviction >>= bucket_order;
 	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
-	eviction = (eviction << NODES_SHIFT) | zone_to_nid(zone);
-	eviction = (eviction << ZONES_SHIFT) | zone_idx(zone);
+	eviction = (eviction << NODES_SHIFT) | pgdat->node_id;
 	eviction = (eviction << RADIX_TREE_EXCEPTIONAL_SHIFT);
 
 	return (void *)(eviction | RADIX_TREE_EXCEPTIONAL_ENTRY);
 }
 
-static void unpack_shadow(void *shadow, int *memcgidp, struct zone **zonep,
+static void unpack_shadow(void *shadow, int *memcgidp, pg_data_t **pgdat,
 			  unsigned long *evictionp)
 {
 	unsigned long entry = (unsigned long)shadow;
-	int memcgid, nid, zid;
+	int memcgid, nid;
 
 	entry >>= RADIX_TREE_EXCEPTIONAL_SHIFT;
-	zid = entry & ((1UL << ZONES_SHIFT) - 1);
-	entry >>= ZONES_SHIFT;
 	nid = entry & ((1UL << NODES_SHIFT) - 1);
 	entry >>= NODES_SHIFT;
 	memcgid = entry & ((1UL << MEM_CGROUP_ID_SHIFT) - 1);
 	entry >>= MEM_CGROUP_ID_SHIFT;
 
 	*memcgidp = memcgid;
-	*zonep = NODE_DATA(nid)->node_zones + zid;
+	*pgdat = NODE_DATA(nid);
 	*evictionp = entry << bucket_order;
 }
 
@@ -208,7 +205,7 @@ static void unpack_shadow(void *shadow,
 void *workingset_eviction(struct address_space *mapping, struct page *page)
 {
 	struct mem_cgroup *memcg = page_memcg(page);
-	struct zone *zone = page_zone(page);
+	struct pglist_data *pgdat = page_pgdat(page);
 	int memcgid = mem_cgroup_id(memcg);
 	unsigned long eviction;
 	struct lruvec *lruvec;
@@ -218,9 +215,9 @@ void *workingset_eviction(struct address
 	VM_BUG_ON_PAGE(page_count(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
-	lruvec = mem_cgroup_lruvec(zone->zone_pgdat, memcg);
+	lruvec = mem_cgroup_lruvec(pgdat, memcg);
 	eviction = atomic_long_inc_return(&lruvec->inactive_age);
-	return pack_shadow(memcgid, zone, eviction);
+	return pack_shadow(memcgid, pgdat, eviction);
 }
 
 /**
@@ -228,7 +225,7 @@ void *workingset_eviction(struct address
  * @shadow: shadow entry of the evicted page
  *
  * Calculates and evaluates the refault distance of the previously
- * evicted page in the context of the zone it was allocated in.
+ * evicted page in the context of the node it was allocated in.
  *
  * Returns %true if the page should be activated, %false otherwise.
  */
@@ -240,10 +237,10 @@ bool workingset_refault(void *shadow)
 	unsigned long eviction;
 	struct lruvec *lruvec;
 	unsigned long refault;
-	struct zone *zone;
+	struct pglist_data *pgdat;
 	int memcgid;
 
-	unpack_shadow(shadow, &memcgid, &zone, &eviction);
+	unpack_shadow(shadow, &memcgid, &pgdat, &eviction);
 
 	rcu_read_lock();
 	/*
@@ -267,7 +264,7 @@ bool workingset_refault(void *shadow)
 		rcu_read_unlock();
 		return false;
 	}
-	lruvec = mem_cgroup_lruvec(zone->zone_pgdat, memcg);
+	lruvec = mem_cgroup_lruvec(pgdat, memcg);
 	refault = atomic_long_read(&lruvec->inactive_age);
 	active_file = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE);
 	rcu_read_unlock();
@@ -290,10 +287,10 @@ bool workingset_refault(void *shadow)
 	 */
 	refault_distance = (refault - eviction) & EVICTION_MASK;
 
-	inc_zone_state(zone, WORKINGSET_REFAULT);
+	inc_node_state(pgdat, WORKINGSET_REFAULT);
 
 	if (refault_distance <= active_file) {
-		inc_zone_state(zone, WORKINGSET_ACTIVATE);
+		inc_node_state(pgdat, WORKINGSET_ACTIVATE);
 		return true;
 	}
 	return false;
@@ -436,7 +433,7 @@ static enum lru_status shadow_lru_isolat
 		}
 	}
 	BUG_ON(node->count);
-	inc_zone_state(page_zone(virt_to_page(node)), WORKINGSET_NODERECLAIM);
+	inc_node_state(page_pgdat(virt_to_page(node)), WORKINGSET_NODERECLAIM);
 	if (!__radix_tree_delete_node(&mapping->page_tree, node))
 		BUG();
 
_
