From: akpm@linux-foundation.org
Subject: + mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice.patch added to -mm tree
Date: Fri, 16 Apr 2010 11:50:05 -0700
Message-ID: <201004161850.o3GIo5Aq021397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757722Ab0DPSuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 14:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com


The patch titled
     mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice.patch

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
Subject: mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice
From: Mel Gorman <mel@csn.ul.ie>

mm,compaction: Do not compact twice

Patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
created a __alloc_pages_direct_compact() function but the old call to
try_to_compact_pages() was not removed.  This patch removes it.

This is a fix to the mmotm patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice
+++ a/mm/page_alloc.c
@@ -1822,38 +1822,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 
 	cond_resched();
 
-#ifdef CONFIG_COMPACTION
-	/* Try memory compaction for high-order allocations before reclaim */
-	if (order) {
-		*did_some_progress = try_to_compact_pages(zonelist,
-						order, gfp_mask, nodemask);
-		if (*did_some_progress != COMPACT_SKIPPED) {
-
-			/* Page migration frees to the PCP lists but we want merging */
-			drain_pages(get_cpu());
-			put_cpu();
-
-			page = get_page_from_freelist(gfp_mask, nodemask,
-					order, zonelist, high_zoneidx,
-					alloc_flags, preferred_zone,
-					migratetype);
-			if (page) {
-				__count_vm_event(COMPACTSUCCESS);
-				return page;
-			}
-
-			/*
-			 * It's bad if compaction run occurs and fails.
-			 * The most likely reason is that pages exist,
-			 * but not enough to satisfy watermarks.
-			 */
-			count_vm_event(COMPACTFAIL);
-
-			cond_resched();
-		}
-	}
-#endif
-
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
 	p->flags |= PF_MEMALLOC;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-unusable-free-space-index-via-proc-unusable_index-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index-fix-fix-2.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index-fix.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-memory-compaction-core-fix-page-buddy-can-go-away-before-reading-page_order-while-isolating-pages-for-migration.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice.patch
mm-remove-nodes-validity-check-in-alloc_pages.patch
mm-change-alloc-function-in-vmemmap_alloc_block.patch
mm-change-alloc-function-in-__vmalloc_area_node.patch
mm-add-comment-in-alloc_pages_exact_node.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

