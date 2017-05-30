From: akpm@linux-foundation.org
Subject: + mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch added to -mm tree
Date: Tue, 30 May 2017 13:53:44 -0700
Message-ID: <592ddbd8.g951IAkW6BMESkcs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57136 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdE3Uxu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 16:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, josef@toxicpanda.com, mhocko@suse.com, riel@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat: move slab statistics from zone to node counters
has been added to the -mm tree.  Its filename is
     mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmstat: move slab statistics from zone to node counters

To re-implement slab cache vs.  page cache balancing, we'll need the slab
counters at the lruvec level, which, ever since lru reclaim was moved from
the zone to the node, is the intersection of the node, not the zone, and
the memcg.

We could retain the per-zone counters for when the page allocator dumps
its memory information on failures, and have counters on both levels -
which on all but NUMA node 0 is usually redundant.  But let's keep it
simple for now and just move them.  If anybody complains we can restore
the per-zone counters.

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
 mm/page_alloc.c        |    4 ----
 mm/slab.c              |    8 ++++----
 mm/slub.c              |    4 ++--
 mm/vmscan.c            |    2 +-
 mm/vmstat.c            |    4 ++--
 7 files changed, 16 insertions(+), 20 deletions(-)

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
@@ -4632,8 +4632,6 @@ void show_free_areas(unsigned int filter
 			" present:%lukB"
 			" managed:%lukB"
 			" mlocked:%lukB"
-			" slab_reclaimable:%lukB"
-			" slab_unreclaimable:%lukB"
 			" kernel_stack:%lukB"
 			" pagetables:%lukB"
 			" bounce:%lukB"
@@ -4655,8 +4653,6 @@ void show_free_areas(unsigned int filter
 			K(zone->present_pages),
 			K(zone->managed_pages),
 			K(zone_page_state(zone, NR_MLOCK)),
-			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
-			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
 			zone_page_state(zone, NR_KERNEL_STACK_KB),
 			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_BOUNCE)),
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
@@ -4006,7 +4006,7 @@ int node_reclaim(struct pglist_data *pgd
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-delete-unused-pgdat_reclaimable_pages.patch
mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
mm-memcontrol-use-the-node-native-slab-memory-counters.patch
mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
mm-memcontrol-per-lruvec-stats-infrastructure.patch
mm-memcontrol-account-slab-stats-per-lruvec.patch

