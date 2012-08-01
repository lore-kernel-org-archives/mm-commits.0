From: akpm@linux-foundation.org
Subject: [merged] mm-remove-redundant-initialization.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:19:05 -0700
Message-ID: <20120801201906.0E7CF5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:64068 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab2HAUTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:19:08 -0400
Received: by bkcjc3 with SMTP id jc3so345317bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:19:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ralf@linux-mips.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove redundant initialization
has been removed from the -mm tree.  Its filename was
     mm-remove-redundant-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove redundant initialization

pg_data_t is zeroed before reaching free_area_init_core(), so remove the
now unnecessary initializations.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    5 -----
 mm/page_alloc.c        |    9 ++-------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff -puN include/linux/vmstat.h~mm-remove-redundant-initialization include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-remove-redundant-initialization
+++ a/include/linux/vmstat.h
@@ -179,11 +179,6 @@ extern void zone_statistics(struct zone 
 #define add_zone_page_state(__z, __i, __d) mod_zone_page_state(__z, __i, __d)
 #define sub_zone_page_state(__z, __i, __d) mod_zone_page_state(__z, __i, -(__d))
 
-static inline void zap_zone_vm_stats(struct zone *zone)
-{
-	memset(zone->vm_stat, 0, sizeof(zone->vm_stat));
-}
-
 extern void inc_zone_state(struct zone *, enum zone_stat_item);
 
 #ifdef CONFIG_SMP
diff -puN mm/page_alloc.c~mm-remove-redundant-initialization mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-redundant-initialization
+++ a/mm/page_alloc.c
@@ -4377,6 +4377,8 @@ void __init set_pageblock_order(void)
  *   - mark all pages reserved
  *   - mark all memory queues empty
  *   - clear the memory bitmaps
+ *
+ * NOTE: pgdat should get zeroed by caller.
  */
 static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long *zholes_size)
@@ -4387,10 +4389,8 @@ static void __paginginit free_area_init_
 	int ret;
 
 	pgdat_resize_init(pgdat);
-	pgdat->nr_zones = 0;
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
-	pgdat->kswapd_max_order = 0;
 	pgdat_page_cgroup_init(pgdat);
 
 	for (j = 0; j < MAX_NR_ZONES; j++) {
@@ -4451,11 +4451,6 @@ static void __paginginit free_area_init_
 
 		zone_pcp_init(zone);
 		lruvec_init(&zone->lruvec, zone);
-		zap_zone_vm_stats(zone);
-		zone->flags = 0;
-#ifdef CONFIG_MEMORY_ISOLATION
-		zone->nr_pageblock_isolate = 0;
-#endif
 		if (!size)
 			continue;
 
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-__gfp_no_kswapd.patch
remove-__gfp_no_kswapd-fixes-fix.patch

