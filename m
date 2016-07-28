From: akpm@linux-foundation.org
Subject: [patch 026/101] mm, vmscan: simplify the logic deciding whether
 kswapd sleeps
Date: Thu, 28 Jul 2016 15:45:49 -0700
Message-ID: <579a8b1d.dvODSloEQyGYBcbi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbcG1Wpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: simplify the logic deciding whether kswapd sleeps

kswapd goes through some complex steps trying to figure out if it should
stay awake based on the classzone_idx and the requested order.  It is
unnecessarily complex and passes in an invalid classzone_idx to
balance_pgdat().  What matters most of all is whether a larger order has
been requsted and whether kswapd successfully reclaimed at the previous
order.  This patch irons out the logic to check just that and the end
result is less headache inducing.

Link: http://lkml.kernel.org/r/1467970510-21195-10-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +
 mm/memory_hotplug.c    |    5 +
 mm/page_alloc.c        |    2 
 mm/vmscan.c            |  103 +++++++++++++++++++--------------------
 4 files changed, 58 insertions(+), 57 deletions(-)

diff -puN include/linux/mmzone.h~mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps
+++ a/include/linux/mmzone.h
@@ -668,8 +668,9 @@ typedef struct pglist_data {
 	wait_queue_head_t pfmemalloc_wait;
 	struct task_struct *kswapd;	/* Protected by
 					   mem_hotplug_begin/end() */
-	int kswapd_max_order;
-	enum zone_type classzone_idx;
+	int kswapd_order;
+	enum zone_type kswapd_classzone_idx;
+
 #ifdef CONFIG_COMPACTION
 	int kcompactd_max_order;
 	enum zone_type kcompactd_classzone_idx;
diff -puN mm/memory_hotplug.c~mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps
+++ a/mm/memory_hotplug.c
@@ -1209,9 +1209,10 @@ static pg_data_t __ref *hotadd_new_pgdat
 
 		arch_refresh_nodedata(nid, pgdat);
 	} else {
-		/* Reset the nr_zones and classzone_idx to 0 before reuse */
+		/* Reset the nr_zones, order and classzone_idx before reuse */
 		pgdat->nr_zones = 0;
-		pgdat->classzone_idx = 0;
+		pgdat->kswapd_order = 0;
+		pgdat->kswapd_classzone_idx = 0;
 	}
 
 	/* we can use NODE_DATA(nid) from here */
diff -puN mm/page_alloc.c~mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps
+++ a/mm/page_alloc.c
@@ -6039,7 +6039,7 @@ void __paginginit free_area_init_node(in
 	unsigned long end_pfn = 0;
 
 	/* pg_data_t should be reset to zero when it's allocated */
-	WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
+	WARN_ON(pgdat->nr_zones || pgdat->kswapd_classzone_idx);
 
 	reset_deferred_meminit(pgdat);
 	pgdat->node_id = nid;
diff -puN mm/vmscan.c~mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps
+++ a/mm/vmscan.c
@@ -2762,7 +2762,7 @@ static bool pfmemalloc_watermark_ok(pg_d
 
 	/* kswapd must be awake if processes are being throttled */
 	if (!wmark_ok && waitqueue_active(&pgdat->kswapd_wait)) {
-		pgdat->classzone_idx = min(pgdat->classzone_idx,
+		pgdat->kswapd_classzone_idx = min(pgdat->kswapd_classzone_idx,
 						(enum zone_type)ZONE_NORMAL);
 		wake_up_interruptible(&pgdat->kswapd_wait);
 	}
@@ -3042,11 +3042,11 @@ static bool prepare_kswapd_sleep(pg_data
 		if (!populated_zone(zone))
 			continue;
 
-		if (zone_balanced(zone, order, classzone_idx))
-			return true;
+		if (!zone_balanced(zone, order, classzone_idx))
+			return false;
 	}
 
-	return false;
+	return true;
 }
 
 /*
@@ -3238,8 +3238,8 @@ out:
 	return sc.order;
 }
 
-static void kswapd_try_to_sleep(pg_data_t *pgdat, int order,
-				int classzone_idx, int balanced_classzone_idx)
+static void kswapd_try_to_sleep(pg_data_t *pgdat, int alloc_order, int reclaim_order,
+				unsigned int classzone_idx)
 {
 	long remaining = 0;
 	DEFINE_WAIT(wait);
@@ -3250,8 +3250,7 @@ static void kswapd_try_to_sleep(pg_data_
 	prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 
 	/* Try to sleep for a short interval */
-	if (prepare_kswapd_sleep(pgdat, order, remaining,
-						balanced_classzone_idx)) {
+	if (prepare_kswapd_sleep(pgdat, reclaim_order, remaining, classzone_idx)) {
 		/*
 		 * Compaction records what page blocks it recently failed to
 		 * isolate pages from and skips them in the future scanning.
@@ -3264,9 +3263,20 @@ static void kswapd_try_to_sleep(pg_data_
 		 * We have freed the memory, now we should compact it to make
 		 * allocation of the requested order possible.
 		 */
-		wakeup_kcompactd(pgdat, order, classzone_idx);
+		wakeup_kcompactd(pgdat, alloc_order, classzone_idx);
 
 		remaining = schedule_timeout(HZ/10);
+
+		/*
+		 * If woken prematurely then reset kswapd_classzone_idx and
+		 * order. The values will either be from a wakeup request or
+		 * the previous request that slept prematurely.
+		 */
+		if (remaining) {
+			pgdat->kswapd_classzone_idx = max(pgdat->kswapd_classzone_idx, classzone_idx);
+			pgdat->kswapd_order = max(pgdat->kswapd_order, reclaim_order);
+		}
+
 		finish_wait(&pgdat->kswapd_wait, &wait);
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 	}
@@ -3275,8 +3285,7 @@ static void kswapd_try_to_sleep(pg_data_
 	 * After a short sleep, check if it was a premature sleep. If not, then
 	 * go fully to sleep until explicitly woken up.
 	 */
-	if (prepare_kswapd_sleep(pgdat, order, remaining,
-						balanced_classzone_idx)) {
+	if (prepare_kswapd_sleep(pgdat, reclaim_order, remaining, classzone_idx)) {
 		trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
 
 		/*
@@ -3317,9 +3326,7 @@ static void kswapd_try_to_sleep(pg_data_
  */
 static int kswapd(void *p)
 {
-	unsigned long order, new_order;
-	int classzone_idx, new_classzone_idx;
-	int balanced_classzone_idx;
+	unsigned int alloc_order, reclaim_order, classzone_idx;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
 
@@ -3349,38 +3356,20 @@ static int kswapd(void *p)
 	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 	set_freezable();
 
-	order = new_order = 0;
-	classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
-	balanced_classzone_idx = classzone_idx;
+	pgdat->kswapd_order = alloc_order = reclaim_order = 0;
+	pgdat->kswapd_classzone_idx = classzone_idx = 0;
 	for ( ; ; ) {
 		bool ret;
 
-		/*
-		 * While we were reclaiming, there might have been another
-		 * wakeup, so check the values.
-		 */
-		new_order = pgdat->kswapd_max_order;
-		new_classzone_idx = pgdat->classzone_idx;
-		pgdat->kswapd_max_order =  0;
-		pgdat->classzone_idx = pgdat->nr_zones - 1;
-
-		if (order < new_order || classzone_idx > new_classzone_idx) {
-			/*
-			 * Don't sleep if someone wants a larger 'order'
-			 * allocation or has tigher zone constraints
-			 */
-			order = new_order;
-			classzone_idx = new_classzone_idx;
-		} else {
-			kswapd_try_to_sleep(pgdat, order, classzone_idx,
-						balanced_classzone_idx);
-			order = pgdat->kswapd_max_order;
-			classzone_idx = pgdat->classzone_idx;
-			new_order = order;
-			new_classzone_idx = classzone_idx;
-			pgdat->kswapd_max_order = 0;
-			pgdat->classzone_idx = pgdat->nr_zones - 1;
-		}
+kswapd_try_sleep:
+		kswapd_try_to_sleep(pgdat, alloc_order, reclaim_order,
+					classzone_idx);
+
+		/* Read the new order and classzone_idx */
+		alloc_order = reclaim_order = pgdat->kswapd_order;
+		classzone_idx = pgdat->kswapd_classzone_idx;
+		pgdat->kswapd_order = 0;
+		pgdat->kswapd_classzone_idx = 0;
 
 		ret = try_to_freeze();
 		if (kthread_should_stop())
@@ -3390,12 +3379,24 @@ static int kswapd(void *p)
 		 * We can speed up thawing tasks if we don't call balance_pgdat
 		 * after returning from the refrigerator
 		 */
-		if (!ret) {
-			trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
+		if (ret)
+			continue;
 
-			/* return value ignored until next patch */
-			balance_pgdat(pgdat, order, classzone_idx);
-		}
+		/*
+		 * Reclaim begins at the requested order but if a high-order
+		 * reclaim fails then kswapd falls back to reclaiming for
+		 * order-0. If that happens, kswapd will consider sleeping
+		 * for the order it finished reclaiming at (reclaim_order)
+		 * but kcompactd is woken to compact for the original
+		 * request (alloc_order).
+		 */
+		trace_mm_vmscan_kswapd_wake(pgdat->node_id, alloc_order);
+		reclaim_order = balance_pgdat(pgdat, alloc_order, classzone_idx);
+		if (reclaim_order < alloc_order)
+			goto kswapd_try_sleep;
+
+		alloc_order = reclaim_order = pgdat->kswapd_order;
+		classzone_idx = pgdat->kswapd_classzone_idx;
 	}
 
 	tsk->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD);
@@ -3418,10 +3419,8 @@ void wakeup_kswapd(struct zone *zone, in
 	if (!cpuset_zone_allowed(zone, GFP_KERNEL | __GFP_HARDWALL))
 		return;
 	pgdat = zone->zone_pgdat;
-	if (pgdat->kswapd_max_order < order) {
-		pgdat->kswapd_max_order = order;
-		pgdat->classzone_idx = min(pgdat->classzone_idx, classzone_idx);
-	}
+	pgdat->kswapd_classzone_idx = max(pgdat->kswapd_classzone_idx, classzone_idx);
+	pgdat->kswapd_order = max(pgdat->kswapd_order, order);
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
 	if (zone_balanced(zone, order, 0))
_
