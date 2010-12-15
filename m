From: akpm@linux-foundation.org
Subject: + thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:58:05 -0800
Message-ID: <201012152358.oBFNw5UR013676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922Ab0LOX6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:58:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp: use compaction in kswapd for GFP_ATOMIC order > 0
has been added to the -mm tree.  Its filename is
     thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: use compaction in kswapd for GFP_ATOMIC order > 0
From: Andrea Arcangeli <aarcange@redhat.com>

This takes advantage of memory compaction to properly generate pages of
order > 0 if regular page reclaim fails and priority level becomes more
severe and we don't reach the proper watermarks.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   11 ++++++++---
 mm/compaction.c            |   31 ++++++++++++++++++++++++++-----
 mm/vmscan.c                |   30 ++++++++++++++++++++----------
 3 files changed, 54 insertions(+), 18 deletions(-)

diff -puN include/linux/compaction.h~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0 include/linux/compaction.h
--- a/include/linux/compaction.h~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0
+++ a/include/linux/compaction.h
@@ -11,6 +11,9 @@
 /* The full zone was compacted */
 #define COMPACT_COMPLETE	3
 
+#define COMPACT_MODE_DIRECT_RECLAIM	0
+#define COMPACT_MODE_KSWAPD		1
+
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
@@ -25,7 +28,8 @@ extern unsigned long try_to_compact_page
 			bool sync);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
 extern unsigned long compact_zone_order(struct zone *zone, int order,
-						gfp_t gfp_mask, bool sync);
+					gfp_t gfp_mask, bool sync,
+					int compact_mode);
 
 /* Do not skip compaction more than 64 times */
 #define COMPACT_MAX_DEFER_SHIFT 6
@@ -70,9 +74,10 @@ static inline unsigned long compaction_s
 }
 
 static inline unsigned long compact_zone_order(struct zone *zone, int order,
-						gfp_t gfp_mask, bool sync)
+					       gfp_t gfp_mask, bool sync,
+					       int compact_mode)
 {
-	return 0;
+	return COMPACT_CONTINUE;
 }
 
 static inline void defer_compaction(struct zone *zone)
diff -puN mm/compaction.c~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0 mm/compaction.c
--- a/mm/compaction.c~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0
+++ a/mm/compaction.c
@@ -42,6 +42,8 @@ struct compact_control {
 	unsigned int order;		/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
+
+	int compact_mode;
 };
 
 static unsigned long release_freepages(struct list_head *freelist)
@@ -382,10 +384,10 @@ static void update_nr_listpages(struct c
 }
 
 static int compact_finished(struct zone *zone,
-						struct compact_control *cc)
+			    struct compact_control *cc)
 {
 	unsigned int order;
-	unsigned long watermark = low_wmark_pages(zone) + (1 << cc->order);
+	unsigned long watermark;
 
 	if (fatal_signal_pending(current))
 		return COMPACT_PARTIAL;
@@ -395,12 +397,27 @@ static int compact_finished(struct zone 
 		return COMPACT_COMPLETE;
 
 	/* Compaction run is not finished if the watermark is not met */
+	if (cc->compact_mode != COMPACT_MODE_KSWAPD)
+		watermark = low_wmark_pages(zone);
+	else
+		watermark = high_wmark_pages(zone);
+	watermark += (1 << cc->order);
+
 	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
 		return COMPACT_CONTINUE;
 
 	if (cc->order == -1)
 		return COMPACT_CONTINUE;
 
+	/*
+	 * Generating only one page of the right order is not enough
+	 * for kswapd, we must continue until we're above the high
+	 * watermark as a pool for high order GFP_ATOMIC allocations
+	 * too.
+	 */
+	if (cc->compact_mode == COMPACT_MODE_KSWAPD)
+		return COMPACT_CONTINUE;
+
 	/* Direct compactor: Is a suitable page free? */
 	for (order = cc->order; order < MAX_ORDER; order++) {
 		/* Job done if page is free of the right migratetype */
@@ -514,8 +531,9 @@ static int compact_zone(struct zone *zon
 }
 
 unsigned long compact_zone_order(struct zone *zone,
-						int order, gfp_t gfp_mask,
-						bool sync)
+				 int order, gfp_t gfp_mask,
+				 bool sync,
+				 int compact_mode)
 {
 	struct compact_control cc = {
 		.nr_freepages = 0,
@@ -524,6 +542,7 @@ unsigned long compact_zone_order(struct 
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
 		.sync = sync,
+		.compact_mode = compact_mode,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -569,7 +588,8 @@ unsigned long try_to_compact_pages(struc
 								nodemask) {
 		int status;
 
-		status = compact_zone_order(zone, order, gfp_mask, sync);
+		status = compact_zone_order(zone, order, gfp_mask, sync,
+					    COMPACT_MODE_DIRECT_RECLAIM);
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
@@ -600,6 +620,7 @@ static int compact_node(int nid)
 			.nr_freepages = 0,
 			.nr_migratepages = 0,
 			.order = -1,
+			.compact_mode = COMPACT_MODE_DIRECT_RECLAIM,
 		};
 
 		zone = &pgdat->node_zones[zoneid];
diff -puN mm/vmscan.c~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0 mm/vmscan.c
--- a/mm/vmscan.c~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0
+++ a/mm/vmscan.c
@@ -41,6 +41,7 @@
 #include <linux/memcontrol.h>
 #include <linux/delayacct.h>
 #include <linux/sysctl.h>
+#include <linux/compaction.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -2382,6 +2383,7 @@ loop_again:
 		 * cause too much scanning of the lower zones.
 		 */
 		for (i = 0; i <= end_zone; i++) {
+			int compaction;
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
 
@@ -2411,9 +2413,26 @@ loop_again:
 						lru_pages);
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
+
+			compaction = 0;
+			if (order &&
+			    zone_watermark_ok(zone, 0,
+					       high_wmark_pages(zone),
+					      end_zone, 0) &&
+			    !zone_watermark_ok(zone, order,
+					       high_wmark_pages(zone),
+					       end_zone, 0)) {
+				compact_zone_order(zone,
+						   order,
+						   sc.gfp_mask, false,
+						   COMPACT_MODE_KSWAPD);
+				compaction = 1;
+			}
+
 			if (zone->all_unreclaimable)
 				continue;
-			if (nr_slab == 0 && !zone_reclaimable(zone))
+			if (!compaction && nr_slab == 0 &&
+			    !zone_reclaimable(zone))
 				zone->all_unreclaimable = 1;
 			/*
 			 * If we've done a decent amount of scanning and
@@ -2424,15 +2443,6 @@ loop_again:
 			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage = 1;
 
-			/*
-			 * Compact the zone for higher orders to reduce
-			 * latencies for higher-order allocations that
-			 * would ordinarily call try_to_compact_pages()
-			 */
-			if (sc.order > PAGE_ALLOC_COSTLY_ORDER)
-				compact_zone_order(zone, sc.order, sc.gfp_mask,
-							false);
-
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), end_zone, 0)) {
 				all_zones_ok = 0;
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-transparent-hugepage-support-documentation.patch
thp-mm-define-madv_hugepage.patch
thp-compound_lock.patch
thp-alter-compound-get_page-put_page.patch
thp-put_page-recheck-pagehead-after-releasing-the-compound_lock.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-transparent-hugepage-core.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-madvisemadv_hugepage.patch
thp-add-pagetranscompound.patch
thp-pmd_trans_huge-migrate-bugcheck.patch
thp-memcg-compound.patch
thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-memcg-huge-memory.patch
thp-transparent-hugepage-vmstat.patch
thp-khugepaged.patch
thp-khugepaged-vma-merge.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-remove-pg_buddy.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
thp-set-recommended-min-free-kbytes.patch
thp-enable-direct-defrag.patch
thp-add-numa-awareness-to-hugepage-allocations.patch
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch
thp-transparent-hugepage-config-choice.patch
thp-select-config_compaction-if-transparent_hugepage-enabled.patch
thp-transhuge-isolate_migratepages.patch
thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch
thp-dont-allow-transparent-hugepage-support-without-pse.patch
thp-mmu_notifier_test_young.patch
thp-freeze-khugepaged-and-ksmd.patch
thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch
thp-use-compaction-for-all-allocation-orders.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
thp-fix-anon-memory-statistics-with-transparent-hugepages.patch
thp-scale-nr_rotated-to-balance-memory-pressure.patch
thp-transparent-hugepage-sysfs-meminfo.patch
thp-add-debug-checks-for-mapcount-related-invariants.patch
thp-fix-memory-failure-hugetlbfs-vs-thp-collision.patch
thp-compound_trans_order.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch

