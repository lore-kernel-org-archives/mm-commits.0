From: akpm@linux-foundation.org
Subject: [patch 5/8] mm/page_alloc.c: recalculate some of node threshold
 when on/offline memory
Date: Wed, 10 Aug 2016 16:27:49 -0700
Message-ID: <57abb875.4eBQT8S/qg6Dis40%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbcHJX1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 19:27:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, mgorman@techsingularity.net, minchan@kernel.org, vbabka@suse.cz

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc.c: recalculate some of node threshold when on/offline memory

Some of node threshold depends on number of managed pages in the node. 
When memory is going on/offline, it can be changed and we need to adjust
them.

Add recalculation to appropriate places and clean-up related functions for
better maintenance.

Link: http://lkml.kernel.org/r/1470724248-26780-2-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   50 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-recalculate-some-of-node-threshold-when-on-offline-memory mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-recalculate-some-of-node-threshold-when-on-offline-memory
+++ a/mm/page_alloc.c
@@ -4757,6 +4757,8 @@ int local_memory_node(int node)
 }
 #endif
 
+static void setup_min_unmapped_ratio(void);
+static void setup_min_slab_ratio(void);
 #else	/* CONFIG_NUMA */
 
 static void set_zonelist_order(void)
@@ -5878,9 +5880,6 @@ static void __paginginit free_area_init_
 		zone->managed_pages = is_highmem_idx(j) ? realsize : freesize;
 #ifdef CONFIG_NUMA
 		zone->node = nid;
-		pgdat->min_unmapped_pages += (freesize*sysctl_min_unmapped_ratio)
-						/ 100;
-		pgdat->min_slab_pages += (freesize * sysctl_min_slab_ratio) / 100;
 #endif
 		zone->name = zone_names[j];
 		zone->zone_pgdat = pgdat;
@@ -6801,6 +6800,12 @@ int __meminit init_per_zone_wmark_min(vo
 	setup_per_zone_wmarks();
 	refresh_zone_stat_thresholds();
 	setup_per_zone_lowmem_reserve();
+
+#ifdef CONFIG_NUMA
+	setup_min_unmapped_ratio();
+	setup_min_slab_ratio();
+#endif
+
 	return 0;
 }
 core_initcall(init_per_zone_wmark_min)
@@ -6842,16 +6847,10 @@ int watermark_scale_factor_sysctl_handle
 }
 
 #ifdef CONFIG_NUMA
-int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *table, int write,
-	void __user *buffer, size_t *length, loff_t *ppos)
+static void setup_min_unmapped_ratio(void)
 {
-	struct pglist_data *pgdat;
+	pg_data_t *pgdat;
 	struct zone *zone;
-	int rc;
-
-	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (rc)
-		return rc;
 
 	for_each_online_pgdat(pgdat)
 		pgdat->min_unmapped_pages = 0;
@@ -6859,26 +6858,47 @@ int sysctl_min_unmapped_ratio_sysctl_han
 	for_each_zone(zone)
 		zone->zone_pgdat->min_unmapped_pages += (zone->managed_pages *
 				sysctl_min_unmapped_ratio) / 100;
-	return 0;
 }
 
-int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *table, int write,
+
+int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
-	struct pglist_data *pgdat;
-	struct zone *zone;
 	int rc;
 
 	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
 	if (rc)
 		return rc;
 
+	setup_min_unmapped_ratio();
+
+	return 0;
+}
+
+static void setup_min_slab_ratio(void)
+{
+	pg_data_t *pgdat;
+	struct zone *zone;
+
 	for_each_online_pgdat(pgdat)
 		pgdat->min_slab_pages = 0;
 
 	for_each_zone(zone)
 		zone->zone_pgdat->min_slab_pages += (zone->managed_pages *
 				sysctl_min_slab_ratio) / 100;
+}
+
+int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *table, int write,
+	void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int rc;
+
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
+
+	setup_min_slab_ratio();
+
 	return 0;
 }
 #endif
_
