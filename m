From: akpm@linux-foundation.org
Subject: [merged] mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:26:38 -0800
Message-ID: <20120111212638.CC80610004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48989 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab2AKV0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:26:40 -0500
Received: by ggnk3 with SMTP id k3so134376ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:26:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, ccross@android.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, penberg@cs.helsinki.fi, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid livelock on !__GFP_FS allocations
has been removed from the -mm tree.  Its filename was
     mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: avoid livelock on !__GFP_FS allocations

Colin Cross reported;

  Under the following conditions, __alloc_pages_slowpath can loop forever:
  gfp_mask & __GFP_WAIT is true
  gfp_mask & __GFP_FS is false
  reclaim and compaction make no progress
  order <= PAGE_ALLOC_COSTLY_ORDER

  These conditions happen very often during suspend and resume,
  when pm_restrict_gfp_mask() effectively converts all GFP_KERNEL
  allocations into __GFP_WAIT.

  The oom killer is not run because gfp_mask & __GFP_FS is false,
  but should_alloc_retry will always return true when order is less
  than PAGE_ALLOC_COSTLY_ORDER.

In his fix, he avoided retrying the allocation if reclaim made no progress
and __GFP_FS was not set.  The problem is that this would result in
GFP_NOIO allocations failing that previously succeeded which would be very
unfortunate.

The big difference between GFP_NOIO and suspend converting GFP_KERNEL to
behave like GFP_NOIO is that normally flushers will be cleaning pages and
kswapd reclaims pages allowing GFP_NOIO to succeed after a short delay. 
The same does not necessarily apply during suspend as the storage device
may be suspended.

This patch special cases the suspend case to fail the page allocation if
reclaim cannot make progress and adds some documentation on how
gfp_allowed_mask is currently used.  Failing allocations like this may
cause suspend to abort but that is better than a livelock.

[mgorman@suse.de: Rework fix to be suspend specific]
[rientjes@google.com: Move suspended device check to should_alloc_retry]
Reported-by: Colin Cross <ccross@android.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   16 ++++++++++++++++
 mm/page_alloc.c     |   30 ++++++++++++++++++++++--------
 mm/swapfile.c       |    6 +++---
 3 files changed, 41 insertions(+), 11 deletions(-)

diff -puN include/linux/gfp.h~mm-avoid-livelock-on-__gfp_fs-allocations-v2 include/linux/gfp.h
--- a/include/linux/gfp.h~mm-avoid-livelock-on-__gfp_fs-allocations-v2
+++ a/include/linux/gfp.h
@@ -368,9 +368,25 @@ void drain_zone_pages(struct zone *zone,
 void drain_all_pages(void);
 void drain_local_pages(void *dummy);
 
+/*
+ * gfp_allowed_mask is set to GFP_BOOT_MASK during early boot to restrict what
+ * GFP flags are used before interrupts are enabled. Once interrupts are
+ * enabled, it is set to __GFP_BITS_MASK while the system is running. During
+ * hibernation, it is used by PM to avoid I/O during memory allocation while
+ * devices are suspended.
+ */
 extern gfp_t gfp_allowed_mask;
 
 extern void pm_restrict_gfp_mask(void);
 extern void pm_restore_gfp_mask(void);
 
+#ifdef CONFIG_PM_SLEEP
+extern bool pm_suspended_storage(void);
+#else
+static inline bool pm_suspended_storage(void)
+{
+	return false;
+}
+#endif /* CONFIG_PM_SLEEP */
+
 #endif /* __LINUX_GFP_H */
diff -puN mm/page_alloc.c~mm-avoid-livelock-on-__gfp_fs-allocations-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-avoid-livelock-on-__gfp_fs-allocations-v2
+++ a/mm/page_alloc.c
@@ -127,6 +127,13 @@ void pm_restrict_gfp_mask(void)
 	saved_gfp_mask = gfp_allowed_mask;
 	gfp_allowed_mask &= ~GFP_IOFS;
 }
+
+bool pm_suspended_storage(void)
+{
+	if ((gfp_allowed_mask & GFP_IOFS) == GFP_IOFS)
+		return false;
+	return true;
+}
 #endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
@@ -1786,12 +1793,25 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 
 static inline int
 should_alloc_retry(gfp_t gfp_mask, unsigned int order,
+				unsigned long did_some_progress,
 				unsigned long pages_reclaimed)
 {
 	/* Do not loop if specifically requested */
 	if (gfp_mask & __GFP_NORETRY)
 		return 0;
 
+	/* Always retry if specifically requested */
+	if (gfp_mask & __GFP_NOFAIL)
+		return 1;
+
+	/*
+	 * Suspend converts GFP_KERNEL to __GFP_WAIT which can prevent reclaim
+	 * making forward progress without invoking OOM. Suspend also disables
+	 * storage devices so kswapd will not help. Bail if we are suspending.
+	 */
+	if (!did_some_progress && pm_suspended_storage())
+		return 0;
+
 	/*
 	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
 	 * means __GFP_NOFAIL, but that may not be true in other
@@ -1810,13 +1830,6 @@ should_alloc_retry(gfp_t gfp_mask, unsig
 	if (gfp_mask & __GFP_REPEAT && pages_reclaimed < (1 << order))
 		return 1;
 
-	/*
-	 * Don't let big-order allocations loop unless the caller
-	 * explicitly requests that.
-	 */
-	if (gfp_mask & __GFP_NOFAIL)
-		return 1;
-
 	return 0;
 }
 
@@ -2209,7 +2222,8 @@ rebalance:
 
 	/* Check if we should retry the allocation */
 	pages_reclaimed += did_some_progress;
-	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
+	if (should_alloc_retry(gfp_mask, order, did_some_progress,
+						pages_reclaimed)) {
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
 		goto rebalance;
diff -puN mm/swapfile.c~mm-avoid-livelock-on-__gfp_fs-allocations-v2 mm/swapfile.c
--- a/mm/swapfile.c~mm-avoid-livelock-on-__gfp_fs-allocations-v2
+++ a/mm/swapfile.c
@@ -667,10 +667,10 @@ int try_to_free_swap(struct page *page)
 	 * original page might be freed under memory pressure, then
 	 * later read back in from swap, now with the wrong data.
 	 *
-	 * Hibernation clears bits from gfp_allowed_mask to prevent
-	 * memory reclaim from writing to disk, so check that here.
+	 * Hibration suspends storage while it is writing the image
+	 * to disk so check that here.
 	 */
-	if (!(gfp_allowed_mask & __GFP_IO))
+	if (pm_suspended_storage())
 		return 0;
 
 	delete_from_swap_cache(page);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
mm-compaction-allow-compaction-to-isolate-dirty-pages.patch
mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory.patch
mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch
mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction.patch
mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch
mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch
radix_tree-take-radix_tree_path-off-stack.patch
radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch

