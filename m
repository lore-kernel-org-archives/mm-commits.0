From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix2.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:13:03 -0700
Message-ID: <20121008231304.064C8100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:52583 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2JHXNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:13:05 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so539484vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:13:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: cache if a pageblock was scanned and no pages were isolated -fix2
has been removed from the -mm tree.  Its filename was
     mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix2.patch

This patch was dropped because it was folded into mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: cache if a pageblock was scanned and no pages were isolated -fix2

The clearing of PG_migrate_skip potentially takes a long time if the
zone is massive. Be safe and check if it needs to reschedule.

This is a fix for
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/compaction.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix2
+++ a/mm/compaction.c
@@ -85,6 +85,9 @@ static void reset_isolation_suitable(str
 	/* Walk the zone and mark every pageblock as suitable for isolation */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		struct page *page;
+
+		cond_resched();
+
 		if (!pfn_valid(pfn))
 			continue;
 
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-fix-watermark-checking.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-update-try_to_compact_pageskerneldoc-comment.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3.patch
mm-compaction-restart-compaction-from-near-where-it-left-off.patch
mm-compaction-restart-compaction-from-near-where-it-left-off-fix.patch
mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix.patch
mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
cma-migrate-mlocked-pages.patch
cma-migrate-mlocked-pages-fix.patch
cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch
make-gfp_notrack-definition-unconditional.patch

