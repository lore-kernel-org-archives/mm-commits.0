From: akpm@linux-foundation.org
Subject: [patch 101/108] mm: vmstat: move slab statistics from zone
 to node counters
Date: Thu, 06 Jul 2017 15:40:43 -0700
Message-ID: <20170706224043.n9D65NbfN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37092 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753027AbdGFWkp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:40:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, josef@toxicpanda.com, mhocko@suse.com, mm-commits@vger.kernel.org, riel@redhat.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmstat: move slab statistics from zone to node counters

Patch series "mm: per-lruvec slab stats"

Josef is working on a new approach to balancing slab caches and the page
cache.  For this to work, he needs slab cache statistics on the lruvec
level.  These patches implement that by adding infrastructure that allows
updating and reading generic VM stat items per lruvec, then switches some
existing VM accounting sites, including the slab accounting ones, to this
new cgroup-aware API.

I'll follow up with more patches on this, because there is actually
substantial simplification that can be done to the memory controller when
we replace private memcg accounting with making the existing VM accounting
sites cgroup-aware.  But this is enough for Josef to base his slab reclaim
work on, so here goes.


This patch (of 5):

To re-implement slab cache vs.  page cache balancing, we'll need the slab
counters at the lruvec level, which, ever since lru reclaim was moved from
the zone to the node, is the intersection of the node, not the zone, and
the memcg.

We could retain the per-zone counters for when the page allocator dumps
its memory information on failures, and have counters on both levels -
which on all but NUMA node 0 is usually redundant.  But let's keep it
simple for now and just move them.  If anybody complains we can restore
the per-zone counters.

[hannes@cmpxchg.org: fix oops]
  Link: http://lkml.kernel.org/r/20170605183511.GA8915@cmpxchg.org
Link: http://lkml.kernel.org/r/20170530181724.27197-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |   10 +++++-----
 include/linux/mmzone.h |    4 ++--
 mm/page_alloc.c        |    7 +++----
 mm/slab.c              |    8 ++++----
 mm/slub.c              |    4 ++--
 mm/vmscan.c            |    2 +-
 mm/vmstat.c            |    4 ++--
 7 files changed, 19 insertions(+), 20 deletions(-)

diff -puN drivers/base/node.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters drivers/base/node.c
--- a/drivers/base/node.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters
+++ a/drivers/base/node.c
@@ -129,11 +129,11 @@ static ssize_t node_read_meminfo(struct
 		       nid, K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
 		       nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
 		       nid, K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
-		       nid, K(sum_zone_node_page_state(nid, NR_SLAB_RECLAIMABLE) +
-				sum_zone_node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
-		       nid, K(sum_zone_node_page_state(nid, NR_SLAB_RECLAIMABLE)),
+		       nid, K(node_page_state(pgdat, NR_SLAB_RECLAIMABLE) +
+			      node_page_state(pgdat, NR_SLAB_UNRECLAIMABLE)),
+		       nid, K(node_page_state(pgdat, NR_SLAB_RECLAIMABLE)),
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		       nid, K(sum_zone_node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
+		       nid, K(node_page_state(pgdat, NR_SLAB_UNRECLAIMABLE)),
 		       nid, K(node_page_state(pgdat, NR_ANON_THPS) *
 				       HPAGE_PMD_NR),
 		       nid, K(node_page_state(pgdat, NR_SHMEM_THPS) *
@@ -141,7 +141,7 @@ static ssize_t node_read_meminfo(struct
 		       nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED) *
 				       HPAGE_PMD_NR));
 #else
-		       nid, K(sum_zone_node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
+		       nid, K(node_page_state(pgdat, NR_SLAB_UNRECLAIMABLE)));
 #endif
 	n += hugetlb_report_node_meminfo(nid, buf + n);
 	return n;
diff -puN include/linux/mmzone.h~mm-vmstat-move-slab-statistics-from-zone-to-node-counters include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmstat-move-slab-statistics-from-zone-to-node-counters
+++ a/include/linux/mmzone.h
@@ -125,8 +125,6 @@ enum zone_stat_item {
 	NR_ZONE_UNEVICTABLE,
 	NR_ZONE_WRITE_PENDING,	/* Count of dirty, writeback and unstable pages */
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
-	NR_SLAB_RECLAIMABLE,
-	NR_SLAB_UNRECLAIMABLE,
 	NR_PAGETABLE,		/* used for pagetables */
 	NR_KERNEL_STACK_KB,	/* measured in KiB */
 	/* Second 128 byte cacheline */
@@ -152,6 +150,8 @@ enum node_stat_item {
 	NR_INACTIVE_FILE,	/*  "     "     "   "       "         */
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
 	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
+	NR_SLAB_RECLAIMABLE,
+	NR_SLAB_UNRECLAIMABLE,
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	WORKINGSET_REFAULT,
diff -puN mm/page_alloc.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters
+++ a/mm/page_alloc.c
@@ -4643,8 +4643,6 @@ void show_free_areas(unsigned int filter
 			" present:%lukB"
 			" managed:%lukB"
 			" mlocked:%lukB"
-			" slab_reclaimable:%lukB"
-			" slab_unreclaimable:%lukB"
 			" kernel_stack:%lukB"
 			" pagetables:%lukB"
 			" bounce:%lukB"
@@ -4666,8 +4664,6 @@ void show_free_areas(unsigned int filter
 			K(zone->present_pages),
 			K(zone->managed_pages),
 			K(zone_page_state(zone, NR_MLOCK)),
-			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
-			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
 			zone_page_state(zone, NR_KERNEL_STACK_KB),
 			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_BOUNCE)),
@@ -5153,6 +5149,7 @@ static void build_zonelists(pg_data_t *p
  */
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch);
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
+static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 static void setup_zone_pageset(struct zone *zone);
 
 /*
@@ -6053,6 +6050,8 @@ static void __paginginit free_area_init_
 	spin_lock_init(&pgdat->lru_lock);
 	lruvec_init(node_lruvec(pgdat));
 
+	pgdat->per_cpu_nodestats = &boot_nodestats;
+
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, freesize, memmap_pages;
diff -puN mm/slab.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters mm/slab.c
--- a/mm/slab.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters
+++ a/mm/slab.c
@@ -1425,10 +1425,10 @@ static struct page *kmem_getpages(struct
 
 	nr_pages = (1 << cachep->gfporder);
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
-		add_zone_page_state(page_zone(page),
+		add_node_page_state(page_pgdat(page),
 			NR_SLAB_RECLAIMABLE, nr_pages);
 	else
-		add_zone_page_state(page_zone(page),
+		add_node_page_state(page_pgdat(page),
 			NR_SLAB_UNRECLAIMABLE, nr_pages);
 
 	__SetPageSlab(page);
@@ -1459,10 +1459,10 @@ static void kmem_freepages(struct kmem_c
 	kmemcheck_free_shadow(page, order);
 
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
-		sub_zone_page_state(page_zone(page),
+		sub_node_page_state(page_pgdat(page),
 				NR_SLAB_RECLAIMABLE, nr_freed);
 	else
-		sub_zone_page_state(page_zone(page),
+		sub_node_page_state(page_pgdat(page),
 				NR_SLAB_UNRECLAIMABLE, nr_freed);
 
 	BUG_ON(!PageSlab(page));
diff -puN mm/slub.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters mm/slub.c
--- a/mm/slub.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters
+++ a/mm/slub.c
@@ -1615,7 +1615,7 @@ out:
 	if (!page)
 		return NULL;
 
-	mod_zone_page_state(page_zone(page),
+	mod_node_page_state(page_pgdat(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		1 << oo_order(oo));
@@ -1655,7 +1655,7 @@ static void __free_slab(struct kmem_cach
 
 	kmemcheck_free_shadow(page, compound_order(page));
 
-	mod_zone_page_state(page_zone(page),
+	mod_node_page_state(page_pgdat(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
diff -puN mm/vmscan.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters mm/vmscan.c
--- a/mm/vmscan.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters
+++ a/mm/vmscan.c
@@ -3874,7 +3874,7 @@ int node_reclaim(struct pglist_data *pgd
 	 * unmapped file backed pages.
 	 */
 	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
-	    sum_zone_node_page_state(pgdat->node_id, NR_SLAB_RECLAIMABLE) <= pgdat->min_slab_pages)
+	    node_page_state(pgdat, NR_SLAB_RECLAIMABLE) <= pgdat->min_slab_pages)
 		return NODE_RECLAIM_FULL;
 
 	/*
diff -puN mm/vmstat.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-move-slab-statistics-from-zone-to-node-counters
+++ a/mm/vmstat.c
@@ -928,8 +928,6 @@ const char * const vmstat_text[] = {
 	"nr_zone_unevictable",
 	"nr_zone_write_pending",
 	"nr_mlock",
-	"nr_slab_reclaimable",
-	"nr_slab_unreclaimable",
 	"nr_page_table_pages",
 	"nr_kernel_stack",
 	"nr_bounce",
@@ -952,6 +950,8 @@ const char * const vmstat_text[] = {
 	"nr_inactive_file",
 	"nr_active_file",
 	"nr_unevictable",
+	"nr_slab_reclaimable",
+	"nr_slab_unreclaimable",
 	"nr_isolated_anon",
 	"nr_isolated_file",
 	"workingset_refault",
_
