From: akpm@linux-foundation.org
Subject: [merged] mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:57:02 -0800
Message-ID: <20121212195702.B54FA82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:44858 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:57:04 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so115413yhl.3
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:57:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, minchan@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use IS_ENABLED(CONFIG_COMPACTION) instead of COMPACTION_BUILD
has been removed from the -mm tree.  Its filename was
     mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: use IS_ENABLED(CONFIG_COMPACTION) instead of COMPACTION_BUILD

We don't need custom COMPACTION_BUILD anymore, since we have handy
IS_ENABLED().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    7 -------
 mm/vmscan.c            |    9 +++++----
 2 files changed, 5 insertions(+), 11 deletions(-)

diff -puN include/linux/kernel.h~mm-use-is_enabledconfig_compaction-instead-of-compaction_build include/linux/kernel.h
--- a/include/linux/kernel.h~mm-use-is_enabledconfig_compaction-instead-of-compaction_build
+++ a/include/linux/kernel.h
@@ -687,13 +687,6 @@ static inline void ftrace_dump(enum ftra
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
-/* This helps us avoid #ifdef CONFIG_COMPACTION */
-#ifdef CONFIG_COMPACTION
-#define COMPACTION_BUILD 1
-#else
-#define COMPACTION_BUILD 0
-#endif
-
 /* This helps us to avoid #ifdef CONFIG_SYMBOL_PREFIX */
 #ifdef CONFIG_SYMBOL_PREFIX
 #define SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
diff -puN mm/vmscan.c~mm-use-is_enabledconfig_compaction-instead-of-compaction_build mm/vmscan.c
--- a/mm/vmscan.c~mm-use-is_enabledconfig_compaction-instead-of-compaction_build
+++ a/mm/vmscan.c
@@ -1752,7 +1752,7 @@ out:
 /* Use reclaim/compaction for costly allocs or under memory pressure */
 static bool in_reclaim_compaction(struct scan_control *sc)
 {
-	if (COMPACTION_BUILD && sc->order &&
+	if (IS_ENABLED(CONFIG_COMPACTION) && sc->order &&
 			(sc->order > PAGE_ALLOC_COSTLY_ORDER ||
 			 sc->priority < DEF_PRIORITY - 2))
 		return true;
@@ -2005,7 +2005,7 @@ static bool shrink_zones(struct zonelist
 			if (zone->all_unreclaimable &&
 					sc->priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
-			if (COMPACTION_BUILD) {
+			if (IS_ENABLED(CONFIG_COMPACTION)) {
 				/*
 				 * If we already have plenty of memory free for
 				 * compaction in this zone, don't free any more.
@@ -2421,7 +2421,8 @@ static bool zone_balanced(struct zone *z
 				    balance_gap, classzone_idx, 0))
 		return false;
 
-	if (COMPACTION_BUILD && order && !compaction_suitable(zone, order))
+	if (IS_ENABLED(CONFIG_COMPACTION) && order &&
+	    !compaction_suitable(zone, order))
 		return false;
 
 	return true;
@@ -2684,7 +2685,7 @@ loop_again:
 			 * Do not reclaim more than needed for compaction.
 			 */
 			testorder = order;
-			if (COMPACTION_BUILD && order &&
+			if (IS_ENABLED(CONFIG_COMPACTION) && order &&
 					compaction_suitable(zone, order) !=
 						COMPACT_SKIPPED)
 				testorder = 0;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-thp-fix-anononymous-page-accounting-in-fallback-path-for-cow-of-hzp.patch
thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-fix.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-implement-refcounting-for-huge-zero-page-fix.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
asm-generic-mm-pgtable-consolidate-zero-page-helpers.patch
linux-next.patch
thp-fix-update_mmu_cache_pmd-calls.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch

