From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-generalize-the-dirty-balance-reserve.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:33:54 -0800
Message-ID: <569973d2.DBQ25gpdoQMnsMgQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWdz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: generalize the dirty balance reserve
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-generalize-the-dirty-balance-reserve.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: generalize the dirty balance reserve

The dirty balance reserve that dirty throttling has to consider is merely
memory not available to userspace allocations.  There is nothing
writeback-specific about it.  Generalize the name so that it's reusable
outside of that context.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++---
 include/linux/swap.h   |    1 -
 mm/page-writeback.c    |   14 ++++++++++++--
 mm/page_alloc.c        |   21 +++------------------
 4 files changed, 18 insertions(+), 24 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-generalize-the-dirty-balance-reserve include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-generalize-the-dirty-balance-reserve
+++ a/include/linux/mmzone.h
@@ -356,10 +356,10 @@ struct zone {
 	struct per_cpu_pageset __percpu *pageset;
 
 	/*
-	 * This is a per-zone reserve of pages that should not be
-	 * considered dirtyable memory.
+	 * This is a per-zone reserve of pages that are not available
+	 * to userspace allocations.
 	 */
-	unsigned long		dirty_balance_reserve;
+	unsigned long		totalreserve_pages;
 
 #ifndef CONFIG_SPARSEMEM
 	/*
diff -puN include/linux/swap.h~mm-page_alloc-generalize-the-dirty-balance-reserve include/linux/swap.h
--- a/include/linux/swap.h~mm-page_alloc-generalize-the-dirty-balance-reserve
+++ a/include/linux/swap.h
@@ -287,7 +287,6 @@ static inline void workingset_node_shado
 /* linux/mm/page_alloc.c */
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
-extern unsigned long dirty_balance_reserve;
 extern unsigned long nr_free_buffer_pages(void);
 extern unsigned long nr_free_pagecache_pages(void);
 
diff -puN mm/page-writeback.c~mm-page_alloc-generalize-the-dirty-balance-reserve mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page_alloc-generalize-the-dirty-balance-reserve
+++ a/mm/page-writeback.c
@@ -278,7 +278,12 @@ static unsigned long zone_dirtyable_memo
 	unsigned long nr_pages;
 
 	nr_pages = zone_page_state(zone, NR_FREE_PAGES);
-	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
+	/*
+	 * Pages reserved for the kernel should not be considered
+	 * dirtyable, to prevent a situation where reclaim has to
+	 * clean pages in order to balance the zones.
+	 */
+	nr_pages -= min(nr_pages, zone->totalreserve_pages);
 
 	nr_pages += zone_page_state(zone, NR_INACTIVE_FILE);
 	nr_pages += zone_page_state(zone, NR_ACTIVE_FILE);
@@ -332,7 +337,12 @@ static unsigned long global_dirtyable_me
 	unsigned long x;
 
 	x = global_page_state(NR_FREE_PAGES);
-	x -= min(x, dirty_balance_reserve);
+	/*
+	 * Pages reserved for the kernel should not be considered
+	 * dirtyable, to prevent a situation where reclaim has to
+	 * clean pages in order to balance the zones.
+	 */
+	x -= min(x, totalreserve_pages);
 
 	x += global_page_state(NR_INACTIVE_FILE);
 	x += global_page_state(NR_ACTIVE_FILE);
diff -puN mm/page_alloc.c~mm-page_alloc-generalize-the-dirty-balance-reserve mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-generalize-the-dirty-balance-reserve
+++ a/mm/page_alloc.c
@@ -114,13 +114,6 @@ static DEFINE_SPINLOCK(managed_page_coun
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
 unsigned long totalcma_pages __read_mostly;
-/*
- * When calculating the number of globally allowed dirty pages, there
- * is a certain number of per-zone reserves that should not be
- * considered dirtyable memory.  This is the sum of those reserves
- * over all existing zones that contribute dirtyable memory.
- */
-unsigned long dirty_balance_reserve __read_mostly;
 
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
@@ -5942,20 +5935,12 @@ static void calculate_totalreserve_pages
 
 			if (max > zone->managed_pages)
 				max = zone->managed_pages;
+
+			zone->totalreserve_pages = max;
+
 			reserve_pages += max;
-			/*
-			 * Lowmem reserves are not available to
-			 * GFP_HIGHUSER page cache allocations and
-			 * kswapd tries to balance zones to their high
-			 * watermark.  As a result, neither should be
-			 * regarded as dirtyable memory, to prevent a
-			 * situation where reclaim has to clean pages
-			 * in order to balance the zones.
-			 */
-			zone->dirty_balance_reserve = max;
 		}
 	}
-	dirty_balance_reserve = reserve_pages;
 	totalreserve_pages = reserve_pages;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

