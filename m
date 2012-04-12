From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-vmscan-remove-reclaim_mode_t.patch removed from -mm tree
Date: Thu, 12 Apr 2012 16:48:52 -0700
Message-ID: <20120412234852.519D7A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:40124 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2DLXsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Apr 2012 19:48:53 -0400
Received: by ghbz15 with SMTP id z15so313167ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Apr 2012 16:48:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, apw@shadowen.org, hughd@google.com, khlebnikov@openvz.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: remove reclaim_mode_t
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-reclaim_mode_t.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: remove reclaim_mode_t

There is little motiviation for reclaim_mode_t once RECLAIM_MODE_[A]SYNC
and lumpy reclaim have been removed.  This patch gets rid of
reclaim_mode_t as well and improves the documentation about what
reclaim/compaction is and when it is triggered.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |    4 -
 mm/vmscan.c                   |   72 +++++++++-----------------------
 2 files changed, 24 insertions(+), 52 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-vmscan-remove-reclaim_mode_t include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-vmscan-remove-reclaim_mode_t
+++ a/include/trace/events/vmscan.h
@@ -25,12 +25,12 @@
 		{RECLAIM_WB_ASYNC,	"RECLAIM_WB_ASYNC"}	\
 		) : "RECLAIM_WB_NONE"
 
-#define trace_reclaim_flags(page, sync) ( \
+#define trace_reclaim_flags(page) ( \
 	(page_is_file_cache(page) ? RECLAIM_WB_FILE : RECLAIM_WB_ANON) | \
 	(RECLAIM_WB_ASYNC)   \
 	)
 
-#define trace_shrink_flags(file, sync) ( \
+#define trace_shrink_flags(file) \
 	( \
 		(file ? RECLAIM_WB_FILE : RECLAIM_WB_ANON) |  \
 		(RECLAIM_WB_ASYNC) \
diff -puN mm/vmscan.c~mm-vmscan-remove-reclaim_mode_t mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-reclaim_mode_t
+++ a/mm/vmscan.c
@@ -53,16 +53,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
 
-/*
- * reclaim_mode determines how the inactive list is shrunk
- * RECLAIM_MODE_SINGLE: Reclaim only order-0 pages
- * RECLAIM_MODE_COMPACTION: For high-order allocations, reclaim a number of
- *			order-0 pages and then compact the zone
- */
-typedef unsigned __bitwise__ reclaim_mode_t;
-#define RECLAIM_MODE_SINGLE		((__force reclaim_mode_t)0x01u)
-#define RECLAIM_MODE_COMPACTION		((__force reclaim_mode_t)0x10u)
-
 struct scan_control {
 	/* Incremented by the number of inactive pages that were scanned */
 	unsigned long nr_scanned;
@@ -89,12 +79,6 @@ struct scan_control {
 	int order;
 
 	/*
-	 * Intend to reclaim enough continuous memory rather than reclaim
-	 * enough amount of memory. i.e, mode for high order allocation.
-	 */
-	reclaim_mode_t reclaim_mode;
-
-	/*
 	 * The memory cgroup that hit its limit and as a result is the
 	 * primary target of this reclaim invocation.
 	 */
@@ -356,25 +340,6 @@ out:
 	return ret;
 }
 
-static void set_reclaim_mode(int priority, struct scan_control *sc)
-{
-	/*
-	 * Restrict reclaim/compaction to costly allocations or when
-	 * under memory pressure
-	 */
-	if (COMPACTION_BUILD && sc->order &&
-			(sc->order > PAGE_ALLOC_COSTLY_ORDER ||
-			 priority < DEF_PRIORITY - 2))
-		sc->reclaim_mode = RECLAIM_MODE_COMPACTION;
-	else
-		sc->reclaim_mode = RECLAIM_MODE_SINGLE;
-}
-
-static void reset_reclaim_mode(struct scan_control *sc)
-{
-	sc->reclaim_mode = RECLAIM_MODE_SINGLE;
-}
-
 static inline int is_page_cache_freeable(struct page *page)
 {
 	/*
@@ -497,8 +462,7 @@ static pageout_t pageout(struct page *pa
 			/* synchronous write or broken a_ops? */
 			ClearPageReclaim(page);
 		}
-		trace_mm_vmscan_writepage(page,
-			trace_reclaim_flags(page, sc->reclaim_mode));
+		trace_mm_vmscan_writepage(page, trace_reclaim_flags(page));
 		inc_zone_page_state(page, NR_VMSCAN_WRITE);
 		return PAGE_SUCCESS;
 	}
@@ -953,7 +917,6 @@ cull_mlocked:
 			try_to_free_swap(page);
 		unlock_page(page);
 		putback_lru_page(page);
-		reset_reclaim_mode(sc);
 		continue;
 
 activate_locked:
@@ -1348,8 +1311,6 @@ shrink_inactive_list(unsigned long nr_to
 			return SWAP_CLUSTER_MAX;
 	}
 
-	set_reclaim_mode(priority, sc);
-
 	lru_add_drain();
 
 	if (!sc->may_unmap)
@@ -1428,7 +1389,7 @@ shrink_inactive_list(unsigned long nr_to
 		zone_idx(zone),
 		nr_scanned, nr_reclaimed,
 		priority,
-		trace_shrink_flags(file, sc->reclaim_mode));
+		trace_shrink_flags(file));
 	return nr_reclaimed;
 }
 
@@ -1507,8 +1468,6 @@ static void shrink_active_list(unsigned 
 
 	lru_add_drain();
 
-	reset_reclaim_mode(sc);
-
 	if (!sc->may_unmap)
 		isolate_mode |= ISOLATE_UNMAPPED;
 	if (!sc->may_writepage)
@@ -1821,23 +1780,35 @@ out:
 	}
 }
 
+/* Use reclaim/compaction for costly allocs or under memory pressure */
+static bool in_reclaim_compaction(int priority, struct scan_control *sc)
+{
+	if (COMPACTION_BUILD && sc->order &&
+			(sc->order > PAGE_ALLOC_COSTLY_ORDER ||
+			 priority < DEF_PRIORITY - 2))
+		return true;
+
+	return false;
+}
+
 /*
- * Reclaim/compaction depends on a number of pages being freed. To avoid
- * disruption to the system, a small number of order-0 pages continue to be
- * rotated and reclaimed in the normal fashion. However, by the time we get
- * back to the allocator and call try_to_compact_zone(), we ensure that
- * there are enough free pages for it to be likely successful
+ * Reclaim/compaction is used for high-order allocation requests. It reclaims
+ * order-0 pages before compacting the zone. should_continue_reclaim() returns
+ * true if more pages should be reclaimed such that when the page allocator
+ * calls try_to_compact_zone() that it will have enough free pages to succeed.
+ * It will give up earlier than that if there is difficulty reclaiming pages.
  */
 static inline bool should_continue_reclaim(struct mem_cgroup_zone *mz,
 					unsigned long nr_reclaimed,
 					unsigned long nr_scanned,
+					int priority,
 					struct scan_control *sc)
 {
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
 
 	/* If not in reclaim/compaction mode, stop */
-	if (!(sc->reclaim_mode & RECLAIM_MODE_COMPACTION))
+	if (!in_reclaim_compaction(priority, sc))
 		return false;
 
 	/* Consider stopping depending on scan and reclaim activity */
@@ -1944,7 +1915,8 @@ restart:
 
 	/* reclaim/compaction might need reclaim to continue */
 	if (should_continue_reclaim(mz, nr_reclaimed,
-					sc->nr_scanned - nr_scanned, sc))
+					sc->nr_scanned - nr_scanned,
+					priority, sc))
 		goto restart;
 
 	throttle_vm_writeout(sc->gfp_mask);
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch

