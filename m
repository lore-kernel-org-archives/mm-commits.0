From: akpm@linux-foundation.org
Subject: [nacked]
 mm-stop-kswapd-early-when-nothings-waiting-for-it-to-free-pages.patch removed
 from -mm tree
Date: Wed, 19 Feb 2020 13:18:59 -0800
Message-ID: <20200219211859.GnZGj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSVTB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 16:19:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com, vbabka@suse.cz, mhocko@suse.com, mgorman@techsingularity.net, hannes@cmpxchg.org, sultan@kerneltoast.com


The patch titled
     Subject: mm/vmscan: stop kswapd early when nothing's waiting for it to free pages
has been removed from the -mm tree.  Its filename was
     mm-stop-kswapd-early-when-nothings-waiting-for-it-to-free-pages.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Sultan Alsawaf <sultan@kerneltoast.com>
Subject: mm/vmscan: stop kswapd early when nothing's waiting for it to free pages

Keeping kswapd running when all the failed allocations that invoked it are
satisfied incurs a high overhead due to unnecessary page eviction and
writeback, as well as spurious VM pressure events to various registered
shrinkers.  When kswapd doesn't need to work to make an allocation succeed
anymore, stop it prematurely to save resources.

Link: http://lkml.kernel.org/r/20200219182522.1960-1-sultan@kerneltoast.com
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/page_alloc.c        |   17 ++++++++++++++---
 mm/vmscan.c            |    3 ++-
 3 files changed, 18 insertions(+), 4 deletions(-)

--- a/include/linux/mmzone.h~mm-stop-kswapd-early-when-nothings-waiting-for-it-to-free-pages
+++ a/include/linux/mmzone.h
@@ -20,6 +20,7 @@
 #include <linux/atomic.h>
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
+#include <linux/refcount.h>
 #include <asm/page.h>
 
 /* Free memory management - zoned buddy allocator.  */
@@ -737,6 +738,7 @@ typedef struct pglist_data {
 	unsigned long node_spanned_pages; /* total size of physical page
 					     range, including holes */
 	int node_id;
+	refcount_t kswapd_waiters;
 	wait_queue_head_t kswapd_wait;
 	wait_queue_head_t pfmemalloc_wait;
 	struct task_struct *kswapd;	/* Protected by
--- a/mm/page_alloc.c~mm-stop-kswapd-early-when-nothings-waiting-for-it-to-free-pages
+++ a/mm/page_alloc.c
@@ -4403,6 +4403,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	int no_progress_loops;
 	unsigned int cpuset_mems_cookie;
 	int reserve_flags;
+	pg_data_t *pgdat = ac->preferred_zoneref->zone->zone_pgdat;
+	bool woke_kswapd = false;
 
 	/*
 	 * We also sanity check to catch abuse of atomic reserves being used by
@@ -4436,8 +4438,13 @@ retry_cpuset:
 	if (!ac->preferred_zoneref->zone)
 		goto nopage;
 
-	if (alloc_flags & ALLOC_KSWAPD)
+	if (alloc_flags & ALLOC_KSWAPD) {
+		if (!woke_kswapd) {
+			refcount_inc(&pgdat->kswapd_waiters);
+			woke_kswapd = true;
+		}
 		wake_all_kswapds(order, gfp_mask, ac);
+	}
 
 	/*
 	 * The adjusted alloc_flags might result in immediate success, so try
@@ -4642,9 +4649,12 @@ nopage:
 		goto retry;
 	}
 fail:
-	warn_alloc(gfp_mask, ac->nodemask,
-			"page allocation failure: order:%u", order);
 got_pg:
+	if (woke_kswapd)
+		refcount_dec(&pgdat->kswapd_waiters);
+	if (!page)
+		warn_alloc(gfp_mask, ac->nodemask,
+				"page allocation failure: order:%u", order);
 	return page;
 }
 
@@ -6713,6 +6723,7 @@ static void __meminit pgdat_init_interna
 	pgdat_page_ext_init(pgdat);
 	spin_lock_init(&pgdat->lru_lock);
 	lruvec_init(&pgdat->__lruvec);
+	pgdat->kswapd_waiters = (refcount_t)REFCOUNT_INIT(0);
 }
 
 static void __meminit zone_init_internals(struct zone *zone, enum zone_type idx, int nid,
--- a/mm/vmscan.c~mm-stop-kswapd-early-when-nothings-waiting-for-it-to-free-pages
+++ a/mm/vmscan.c
@@ -3697,7 +3697,8 @@ restart:
 		__fs_reclaim_release();
 		ret = try_to_freeze();
 		__fs_reclaim_acquire();
-		if (ret || kthread_should_stop())
+		if (ret || kthread_should_stop() ||
+		    !refcount_read(&pgdat->kswapd_waiters))
 			break;
 
 		/*
_

Patches currently in -mm which might be from sultan@kerneltoast.com are
