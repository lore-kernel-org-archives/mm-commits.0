From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-inline-zone_statistics.patch removed from
 -mm tree
Date: Fri, 20 May 2016 14:06:16 -0700
Message-ID: <573f7c48.hJJpgjFn9pEn2Cpx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbcETVGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: inline zone_statistics
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-inline-zone_statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: inline zone_statistics

zone_statistics has one call-site but it's a public function.  Make it
static and inline.

The performance difference on a page allocator microbenchmark is;

                                           4.6.0-rc2                  4.6.0-rc2
                                    statbranch-v1r20           statinline-v1r20
Min      alloc-odr0-1               419.00 (  0.00%)           412.00 (  1.67%)
Min      alloc-odr0-2               305.00 (  0.00%)           301.00 (  1.31%)
Min      alloc-odr0-4               250.00 (  0.00%)           247.00 (  1.20%)
Min      alloc-odr0-8               219.00 (  0.00%)           215.00 (  1.83%)
Min      alloc-odr0-16              203.00 (  0.00%)           199.00 (  1.97%)
Min      alloc-odr0-32              195.00 (  0.00%)           191.00 (  2.05%)
Min      alloc-odr0-64              191.00 (  0.00%)           187.00 (  2.09%)
Min      alloc-odr0-128             189.00 (  0.00%)           185.00 (  2.12%)
Min      alloc-odr0-256             198.00 (  0.00%)           193.00 (  2.53%)
Min      alloc-odr0-512             210.00 (  0.00%)           207.00 (  1.43%)
Min      alloc-odr0-1024            216.00 (  0.00%)           213.00 (  1.39%)
Min      alloc-odr0-2048            221.00 (  0.00%)           220.00 (  0.45%)
Min      alloc-odr0-4096            227.00 (  0.00%)           226.00 (  0.44%)
Min      alloc-odr0-8192            232.00 (  0.00%)           229.00 (  1.29%)
Min      alloc-odr0-16384           232.00 (  0.00%)           229.00 (  1.29%)

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 --
 mm/page_alloc.c        |   31 +++++++++++++++++++++++++++++++
 mm/vmstat.c            |   29 -----------------------------
 3 files changed, 31 insertions(+), 31 deletions(-)

diff -puN include/linux/vmstat.h~mm-page_alloc-inline-zone_statistics include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-page_alloc-inline-zone_statistics
+++ a/include/linux/vmstat.h
@@ -163,12 +163,10 @@ static inline unsigned long zone_page_st
 #ifdef CONFIG_NUMA
 
 extern unsigned long node_page_state(int node, enum zone_stat_item item);
-extern void zone_statistics(struct zone *, struct zone *, gfp_t gfp);
 
 #else
 
 #define node_page_state(node, item) global_page_state(item)
-#define zone_statistics(_zl, _z, gfp) do { } while (0)
 
 #endif /* CONFIG_NUMA */
 
diff -puN mm/page_alloc.c~mm-page_alloc-inline-zone_statistics mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-inline-zone_statistics
+++ a/mm/page_alloc.c
@@ -2355,6 +2355,37 @@ int split_free_page(struct page *page)
 }
 
 /*
+ * Update NUMA hit/miss statistics
+ *
+ * Must be called with interrupts disabled.
+ *
+ * When __GFP_OTHER_NODE is set assume the node of the preferred
+ * zone is the local node. This is useful for daemons who allocate
+ * memory on behalf of other processes.
+ */
+static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
+								gfp_t flags)
+{
+#ifdef CONFIG_NUMA
+	int local_nid = numa_node_id();
+	enum zone_stat_item local_stat = NUMA_LOCAL;
+
+	if (unlikely(flags & __GFP_OTHER_NODE)) {
+		local_stat = NUMA_OTHER;
+		local_nid = preferred_zone->node;
+	}
+
+	if (z->node == local_nid) {
+		__inc_zone_state(z, NUMA_HIT);
+		__inc_zone_state(z, local_stat);
+	} else {
+		__inc_zone_state(z, NUMA_MISS);
+		__inc_zone_state(preferred_zone, NUMA_FOREIGN);
+	}
+#endif
+}
+
+/*
  * Allocate a page from the given zone. Use pcplists for order-0 allocations.
  */
 static inline
diff -puN mm/vmstat.c~mm-page_alloc-inline-zone_statistics mm/vmstat.c
--- a/mm/vmstat.c~mm-page_alloc-inline-zone_statistics
+++ a/mm/vmstat.c
@@ -570,35 +570,6 @@ void drain_zonestat(struct zone *zone, s
 
 #ifdef CONFIG_NUMA
 /*
- * zonelist = the list of zones passed to the allocator
- * z 	    = the zone from which the allocation occurred.
- *
- * Must be called with interrupts disabled.
- *
- * When __GFP_OTHER_NODE is set assume the node of the preferred
- * zone is the local node. This is useful for daemons who allocate
- * memory on behalf of other processes.
- */
-void zone_statistics(struct zone *preferred_zone, struct zone *z, gfp_t flags)
-{
-	int local_nid = numa_node_id();
-	enum zone_stat_item local_stat = NUMA_LOCAL;
-
-	if (unlikely(flags & __GFP_OTHER_NODE)) {
-		local_stat = NUMA_OTHER;
-		local_nid = preferred_zone->node;
-	}
-
-	if (z->node == local_nid) {
-		__inc_zone_state(z, NUMA_HIT);
-		__inc_zone_state(z, local_stat);
-	} else {
-		__inc_zone_state(z, NUMA_MISS);
-		__inc_zone_state(preferred_zone, NUMA_FOREIGN);
-	}
-}
