From: akpm@linux-foundation.org
Subject: + mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch added to -mm tree
Date: Wed, 07 Apr 2010 13:20:52 -0700
Message-ID: <201004072020.o37KKqBo005314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab0DGUVn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 16:21:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: compaction: do not display compaction-related stats when !CONFIG_COMPACTION
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch

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
Subject: mm: compaction: do not display compaction-related stats when !CONFIG_COMPACTION
From: Mel Gorman <mel@csn.ul.ie>

Although compaction can be disabled from .config, the vmstat entries still
exist.  This patch removes the vmstat entries.  As page_alloc.c refers
directly to the counters, the patch introduces
__alloc_pages_direct_compact() to isolate use of the counters.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +
 mm/page_alloc.c        |   62 +++++++++++++++++++++++++++++++++++++++
 mm/vmstat.c            |    2 +
 3 files changed, 66 insertions(+)

diff -puN include/linux/vmstat.h~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction
+++ a/include/linux/vmstat.h
@@ -43,8 +43,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
 		KSWAPD_SKIP_CONGESTION_WAIT,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+#ifdef CONFIG_COMPACTION
 		COMPACTBLOCKS, COMPACTPAGES, COMPACTPAGEFAILED,
 		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
diff -puN mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction
+++ a/mm/page_alloc.c
@@ -1756,6 +1756,59 @@ out:
 	return page;
 }
 
+#ifdef CONFIG_COMPACTION
+/* Try memory compaction for high-order allocations before reclaim */
+static struct page *
+__alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
+	struct zonelist *zonelist, enum zone_type high_zoneidx,
+	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
+	int migratetype, unsigned long *did_some_progress)
+{
+	struct page *page;
+
+	if (!order)
+		return NULL;
+
+	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
+								nodemask);
+	if (*did_some_progress != COMPACT_SKIPPED) {
+
+		/* Page migration frees to the PCP lists but we want merging */
+		drain_pages(get_cpu());
+		put_cpu();
+
+		page = get_page_from_freelist(gfp_mask, nodemask,
+				order, zonelist, high_zoneidx,
+				alloc_flags, preferred_zone,
+				migratetype);
+		if (page) {
+			__count_vm_event(COMPACTSUCCESS);
+			return page;
+		}
+
+		/*
+		 * It's bad if compaction run occurs and fails.
+		 * The most likely reason is that pages exist,
+		 * but not enough to satisfy watermarks.
+		 */
+		count_vm_event(COMPACTFAIL);
+
+		cond_resched();
+	}
+
+	return NULL;
+}
+#else
+static inline struct page *
+__alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
+	struct zonelist *zonelist, enum zone_type high_zoneidx,
+	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
+	int migratetype, unsigned long *did_some_progress)
+{
+	return NULL;
+}
+#endif /* CONFIG_COMPACTION */
+
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
@@ -1975,6 +2028,15 @@ rebalance:
 	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
 		goto nopage;
 
+	/* Try direct compaction */
+	page = __alloc_pages_direct_compact(gfp_mask, order,
+					zonelist, high_zoneidx,
+					nodemask,
+					alloc_flags, preferred_zone,
+					migratetype, &did_some_progress);
+	if (page)
+		goto got_pg;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
diff -puN mm/vmstat.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction mm/vmstat.c
--- a/mm/vmstat.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction
+++ a/mm/vmstat.c
@@ -902,12 +902,14 @@ static const char * const vmstat_text[] 
 
 	"pgrotated",
 
+#ifdef CONFIG_COMPACTION
 	"compact_blocks_moved",
 	"compact_pages_moved",
 	"compact_pagemigrate_failed",
 	"compact_stall",
 	"compact_fail",
 	"compact_success",
+#endif
 
 #ifdef CONFIG_HUGETLB_PAGE
 	"htlb_buddy_alloc_success",
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-reject-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

