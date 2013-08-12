From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fair-zone-allocator-policy-v2-fix.patch added to
 -mm tree
Date: Mon, 12 Aug 2013 14:25:55 -0700
Message-ID: <520952e3.t5OQt7h8eaGI7694%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3HLVZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Aug 2013 17:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, paul.bollee@gmail.com, mgorman@suse.de, aarcange@redhat.com, hannes@cmpxchg.org

Subject: + mm-page_alloc-fair-zone-allocator-policy-v2-fix.patch added to -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,mgorman@suse.de,paul.bollee@gmail.com,riel@redhat.com,zcalusic@bitsync.net
From: akpm@linux-foundation.org
Date: Mon, 12 Aug 2013 14:25:55 -0700


The patch titled
     Subject: mm: page_alloc: use vmstats for fair zone allocation batching
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fair-zone-allocator-policy-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fair-zone-allocator-policy-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fair-zone-allocator-policy-v2-fix.patch

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
Subject: mm: page_alloc: use vmstats for fair zone allocation batching

Avoid dirtying the same cache line with every single page allocation by
making the fair per-zone allocation batch a vmstat item, which will turn
it into batched percpu counters on SMP.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zlatko Calusic <zcalusic@bitsync.net>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paul Bolle <paul.bollee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/page_alloc.c        |   21 ++++++++++++---------
 mm/vmstat.c            |    1 +
 3 files changed, 14 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-fair-zone-allocator-policy-v2-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-fair-zone-allocator-policy-v2-fix
+++ a/include/linux/mmzone.h
@@ -105,6 +105,7 @@ struct zone_padding {
 enum zone_stat_item {
 	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
+	NR_ALLOC_BATCH,
 	NR_LRU_BASE,
 	NR_INACTIVE_ANON = NR_LRU_BASE, /* must match order of LRU_[IN]ACTIVE */
 	NR_ACTIVE_ANON,		/*  "     "     "   "       "         */
@@ -352,7 +353,6 @@ struct zone {
 	 * free areas of different sizes
 	 */
 	spinlock_t		lock;
-	int			alloc_batch;
 	int                     all_unreclaimable; /* All pages pinned */
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 	/* Set to true when the PG_migrate_skip bits should be cleared */
diff -puN mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy-v2-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy-v2-fix
+++ a/mm/page_alloc.c
@@ -1551,6 +1551,7 @@ again:
 					  get_pageblock_migratetype(page));
 	}
 
+	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
 	local_irq_restore(flags);
@@ -1924,7 +1925,7 @@ zonelist_scan:
 		 * fairness round-robin cycle of this zonelist.
 		 */
 		if (alloc_flags & ALLOC_WMARK_LOW) {
-			if (zone->alloc_batch <= 0)
+			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
 			if (zone_reclaim_mode &&
 			    !zone_local(preferred_zone, zone))
@@ -2036,8 +2037,7 @@ this_zone_full:
 		goto zonelist_scan;
 	}
 
-	if (page) {
-		zone->alloc_batch -= 1U << order;
+	if (page)
 		/*
 		 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
 		 * necessary to allocate the page. The expectation is
@@ -2046,7 +2046,6 @@ this_zone_full:
 		 * for !PFMEMALLOC purposes.
 		 */
 		page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
-	}
 
 	return page;
 }
@@ -2397,8 +2396,10 @@ static void prepare_slowpath(gfp_t gfp_m
 		 */
 		if (zone_reclaim_mode && !zone_local(preferred_zone, zone))
 			continue;
-		zone->alloc_batch = high_wmark_pages(zone) -
-			low_wmark_pages(zone);
+		mod_zone_page_state(zone, NR_ALLOC_BATCH,
+				    high_wmark_pages(zone) -
+				    low_wmark_pages(zone) -
+				    zone_page_state(zone, NR_ALLOC_BATCH));
 	}
 }
 
@@ -4798,7 +4799,7 @@ static void __paginginit free_area_init_
 		zone->zone_pgdat = pgdat;
 
 		/* For bootup, initialized properly in watermark setup */
-		zone->alloc_batch = zone->managed_pages;
+		mod_zone_page_state(zone, NR_ALLOC_BATCH, zone->managed_pages);
 
 		zone_pcp_init(zone);
 		lruvec_init(&zone->lruvec);
@@ -5571,8 +5572,10 @@ static void __setup_per_zone_wmarks(void
 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
 
-		zone->alloc_batch = high_wmark_pages(zone) -
-			low_wmark_pages(zone);
+		__mod_zone_page_state(zone, NR_ALLOC_BATCH,
+				      high_wmark_pages(zone) -
+				      low_wmark_pages(zone) -
+				      zone_page_state(zone, NR_ALLOC_BATCH));
 
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
diff -puN mm/vmstat.c~mm-page_alloc-fair-zone-allocator-policy-v2-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-page_alloc-fair-zone-allocator-policy-v2-fix
+++ a/mm/vmstat.c
@@ -703,6 +703,7 @@ static void walk_zones_in_node(struct se
 const char * const vmstat_text[] = {
 	/* Zoned VM counters */
 	"nr_free_pages",
+	"nr_alloc_batch",
 	"nr_inactive_anon",
 	"nr_active_anon",
 	"nr_inactive_file",
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
mm-kill-one-if-loop-in-__free_pages_bootmem.patch
mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd.patch
mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch
mm-page_alloc-fair-zone-allocator-policy.patch
mm-page_alloc-fair-zone-allocator-policy-v2.patch
mm-page_alloc-fair-zone-allocator-policy-v2-fix.patch
mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
arch-mm-remove-obsolete-init-oom-protection.patch
arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
arch-mm-pass-userspace-fault-flag-to-generic-fault-handler.patch
x86-finish-user-fault-error-path-with-fatal-signal.patch
mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch
mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch
mm-memcg-do-not-trap-chargers-with-full-callstack-on-oom.patch
mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
mm-move-pgtable-related-functions-to-right-place.patch
swap-clean-up-ifdef-in-page_mapping.patch
mm-vmalloc-remove-useless-variable-in-vmap_block.patch
mm-vmalloc-use-well-defined-find_last_bit-func.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

