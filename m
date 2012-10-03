From: akpm@linux-foundation.org
Subject: + mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-3.patch added to -mm tree
Date: Wed, 03 Oct 2012 13:16:41 -0700
Message-ID: <20121003201642.3A98B200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:53932 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab2JCUQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2012 16:16:46 -0400
Received: by lahj13 with SMTP id j13so196704lah.1
        for <mm-commits@vger.kernel.org>; Wed, 03 Oct 2012 13:16:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, b.zolnierkie@samsung.com, broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mina86@mina86.com, peter.ujfalusi@ti.com, thierry.reding@avionic-design.de


The patch titled
     Subject: mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-3
has been added to the -mm tree.  Its filename is
     mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-3

mm: compaction: Iron out isolate_freepages_block() and isolate_freepages_range() -fix1

CMA is reported to be broken in next-20120926. Minchan Kim pointed out
that this was due to nr_scanned != total_isolated in the case of CMA
because PageBuddy pages are one scan but many isolations in CMA. This
patch should address the problem.

This patch is a fix for
mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-3 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-3
+++ a/mm/compaction.c
@@ -182,6 +182,7 @@ static unsigned long isolate_freepages_b
 {
 	int nr_scanned = 0, total_isolated = 0;
 	struct page *cursor;
+	unsigned long nr_strict_required = end_pfn - blockpfn;
 	unsigned long flags;
 	bool locked = false;
 
@@ -240,10 +241,10 @@ static unsigned long isolate_freepages_b
 
 	/*
 	 * If strict isolation is requested by CMA then check that all the
-	 * pages scanned were isolated. If there were any failures, 0 is
+	 * pages requested were isolated. If there were any failures, 0 is
 	 * returned and CMA will fail.
 	 */
-	if (strict && nr_scanned != total_isolated)
+	if (strict && nr_strict_required != total_isolated)
 		total_isolated = 0;
 
 	if (locked)
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch
cma-fix-watermark-checking-fix.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-update-try_to_compact_pageskerneldoc-comment.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-3.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix2.patch
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

