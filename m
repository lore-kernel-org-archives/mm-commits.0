From: akpm@linux-foundation.org
Subject: + mm-remove-redundant-initialization.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:52:35 -0700
Message-ID: <20120724215236.21F5F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:58213 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2GXVwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:52:37 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so10002ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:52:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, ralf@linux-mips.org, tj@kernel.org


The patch titled
     Subject: mm: remove redundant initialization
has been added to the -mm tree.  Its filename is
     mm-remove-redundant-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4376,6 +4376,8 @@ void __init set_pageblock_order(void)
  *   - mark all pages reserved
  *   - mark all memory queues empty
  *   - clear the memory bitmaps
+ *
+ * NOTE: pgdat should get zeroed by caller.
  */
 static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long *zholes_size)
@@ -4386,10 +4388,8 @@ static void __paginginit free_area_init_
 	int ret;
 
 	pgdat_resize_init(pgdat);
-	pgdat->nr_zones = 0;
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
-	pgdat->kswapd_max_order = 0;
 	pgdat_page_cgroup_init(pgdat);
 
 	for (j = 0; j < MAX_NR_ZONES; j++) {
@@ -4450,11 +4450,6 @@ static void __paginginit free_area_init_
 
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
Subject: Subject: mm: remove redundant initialization

Patches currently in -mm which might be from minchan@kernel.org are

linux-next.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-have-order-0-compaction-start-off-where-it-left-v3.patch
vmscan-remove-obsolete-shrink_control-comment.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
mips-zero-out-pg_data_t-when-its-allocated.patch
mm-warn-if-pg_data_t-isnt-initialized-with-zero.patch
mm-remove-redundant-initialization.patch

