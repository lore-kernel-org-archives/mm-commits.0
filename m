From: akpm@linux-foundation.org
Subject: [patch 050/119] mm: remove unused
 pgdat_reclaimable_pages()
Date: Wed, 31 Jan 2018 16:17:06 -0800
Message-ID: <20180201001706.CcTsiZIH7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbeBAARI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:17:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Jan Kara <jack@suse.cz>
Subject: mm: remove unused pgdat_reclaimable_pages()

Remove unused function pgdat_reclaimable_pages() and
node_page_state_snapshot() which becomes unused as well.

Link: http://lkml.kernel.org/r/20171122094416.26019-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h   |    1 -
 include/linux/vmstat.h |   17 -----------------
 mm/vmscan.c            |   16 ----------------
 3 files changed, 34 deletions(-)

diff -puN include/linux/swap.h~mm-remove-unused-pgdat_reclaimable_pages include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-unused-pgdat_reclaimable_pages
+++ a/include/linux/swap.h
@@ -344,7 +344,6 @@ extern void lru_cache_add_active_or_unev
 
 /* linux/mm/vmscan.c */
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
-extern unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
 extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
diff -puN include/linux/vmstat.h~mm-remove-unused-pgdat_reclaimable_pages include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-remove-unused-pgdat_reclaimable_pages
+++ a/include/linux/vmstat.h
@@ -216,23 +216,6 @@ static inline unsigned long zone_page_st
 	return x;
 }
 
-static inline unsigned long node_page_state_snapshot(pg_data_t *pgdat,
-					enum node_stat_item item)
-{
-	long x = atomic_long_read(&pgdat->vm_stat[item]);
-
-#ifdef CONFIG_SMP
-	int cpu;
-	for_each_online_cpu(cpu)
-		x += per_cpu_ptr(pgdat->per_cpu_nodestats, cpu)->vm_node_stat_diff[item];
-
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
-}
-
-
 #ifdef CONFIG_NUMA
 extern void __inc_numa_state(struct zone *zone, enum numa_stat_item item);
 extern unsigned long sum_zone_node_page_state(int node,
diff -puN mm/vmscan.c~mm-remove-unused-pgdat_reclaimable_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-unused-pgdat_reclaimable_pages
+++ a/mm/vmscan.c
@@ -220,22 +220,6 @@ unsigned long zone_reclaimable_pages(str
 	return nr;
 }
 
-unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat)
-{
-	unsigned long nr;
-
-	nr = node_page_state_snapshot(pgdat, NR_ACTIVE_FILE) +
-	     node_page_state_snapshot(pgdat, NR_INACTIVE_FILE) +
-	     node_page_state_snapshot(pgdat, NR_ISOLATED_FILE);
-
-	if (get_nr_swap_pages() > 0)
-		nr += node_page_state_snapshot(pgdat, NR_ACTIVE_ANON) +
-		      node_page_state_snapshot(pgdat, NR_INACTIVE_ANON) +
-		      node_page_state_snapshot(pgdat, NR_ISOLATED_ANON);
-
-	return nr;
-}
