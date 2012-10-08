From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:00:55 -0700
Message-ID: <20121008230056.D48125C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:44755 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab2JHXBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:01:00 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so293583eek.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:00:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch

This patch was dropped because it was folded into mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix

fix build

Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix
+++ a/mm/vmscan.c
@@ -1729,6 +1729,28 @@ static bool in_reclaim_compaction(struct
 	return false;
 }
 
+#ifdef CONFIG_COMPACTION
+/*
+ * If compaction is deferred for sc->order then scale the number of pages
+ * reclaimed based on the number of consecutive allocation failures
+ */
+static unsigned long scale_for_compaction(unsigned long pages_for_compaction,
+			struct lruvec *lruvec, struct scan_control *sc)
+{
+	struct zone *zone = lruvec_zone(lruvec);
+
+	if (zone->compact_order_failed <= sc->order)
+		pages_for_compaction <<= zone->compact_defer_shift;
+	return pages_for_compaction;
+}
+#else
+static unsigned long scale_for_compaction(unsigned long pages_for_compaction,
+			struct lruvec *lruvec, struct scan_control *sc)
+{
+	return pages_for_compaction;
+}
+#endif
+
 /*
  * Reclaim/compaction is used for high-order allocation requests. It reclaims
  * order-0 pages before compacting the zone. should_continue_reclaim() returns
@@ -1743,7 +1765,6 @@ static inline bool should_continue_recla
 {
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
-	struct zone *zone;
 
 	/* If not in reclaim/compaction mode, stop */
 	if (!in_reclaim_compaction(sc))
@@ -1778,14 +1799,8 @@ static inline bool should_continue_recla
 	 */
 	pages_for_compaction = (2UL << sc->order);
 
-	/*
-	 * If compaction is deferred for sc->order then scale the number of
-	 * pages reclaimed based on the number of consecutive allocation
-	 * failures
-	 */
-	zone = lruvec_zone(lruvec);
-	if (zone->compact_order_failed <= sc->order)
-		pages_for_compaction <<= zone->compact_defer_shift;
+	pages_for_compaction = scale_for_compaction(pages_for_compaction,
+						    lruvec, sc);
 	inactive_lru_pages = get_lru_size(lruvec, LRU_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
 		inactive_lru_pages += get_lru_size(lruvec, LRU_INACTIVE_ANON);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

