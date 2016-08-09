From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-recalculate-some-of-node-threshold-when-on-offline-memory.patch added to -mm tree
Date: Tue, 09 Aug 2016 13:59:06 -0700
Message-ID: <57aa441a.mwkbw5vpKbIIW9Wh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbcHIU7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 16:59:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, mgorman@techsingularity.net, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: recalculate some of node threshold when on/offline memory
has been added to the -mm tree.  Its filename is
     mm-page_alloc-recalculate-some-of-node-threshold-when-on-offline-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-recalculate-some-of-node-threshold-when-on-offline-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-recalculate-some-of-node-threshold-when-on-offline-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc.c: recalculate some of node threshold when on/offline memory

Some of node threshold depends on number of managed pages in the node. 
When memory is going on/offline, it can be changed and we need to adjust
them.

Add recalculation to appropriate places and clean-up related functions for
better maintenance.

Link: http://lkml.kernel.org/r/1470724248-26780-2-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
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
@@ -6805,6 +6804,12 @@ int __meminit init_per_zone_wmark_min(vo
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
@@ -6846,16 +6851,10 @@ int watermark_scale_factor_sysctl_handle
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
@@ -6863,26 +6862,47 @@ int sysctl_min_unmapped_ratio_sysctl_han
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

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-page_alloc-fix-wrong-initialization-when-sysctl_min_unmapped_ratio-changes.patch
mm-page_alloc-recalculate-some-of-node-threshold-when-on-offline-memory.patch

