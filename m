From: akpm@linux-foundation.org
Subject: + mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:28:17 -0700
Message-ID: <20120712212817.D4C4020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:46345 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161575Ab2GLV2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:28:21 -0400
Received: by lbbgp10 with SMTP id gp10so165960lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:28:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc


The patch titled
     Subject: mm: throttle direct reclaimers if PF_MEMALLOC reserves are low and swap is backed by network storage
has been added to the -mm tree.  Its filename is
     mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch

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
Subject: mm: throttle direct reclaimers if PF_MEMALLOC reserves are low and swap is backed by network storage

If swap is backed by network storage such as NBD, there is a risk that a
large number of reclaimers can hang the system by consuming all
PF_MEMALLOC reserves.  To avoid these hangs, the administrator must tune
min_free_kbytes in advance which is a bit fragile.

This patch throttles direct reclaimers if half the PF_MEMALLOC reserves
are in use.  If the system is routinely getting throttled the system
administrator can increase min_free_kbytes so degradation is smoother but
the system will keep running.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 
 mm/page_alloc.c        |    1 
 mm/vmscan.c            |  128 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 122 insertions(+), 8 deletions(-)

diff -puN include/linux/mmzone.h~mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage
+++ a/include/linux/mmzone.h
@@ -704,6 +704,7 @@ typedef struct pglist_data {
 					     range, including holes */
 	int node_id;
 	wait_queue_head_t kswapd_wait;
+	wait_queue_head_t pfmemalloc_wait;
 	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
 	int kswapd_max_order;
 	enum zone_type classzone_idx;
diff -puN mm/page_alloc.c~mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage mm/page_alloc.c
--- a/mm/page_alloc.c~mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage
+++ a/mm/page_alloc.c
@@ -4388,6 +4388,7 @@ static void __paginginit free_area_init_
 	pgdat_resize_init(pgdat);
 	pgdat->nr_zones = 0;
 	init_waitqueue_head(&pgdat->kswapd_wait);
+	init_waitqueue_head(&pgdat->pfmemalloc_wait);
 	pgdat->kswapd_max_order = 0;
 	pgdat_page_cgroup_init(pgdat);
 
diff -puN mm/vmscan.c~mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage mm/vmscan.c
--- a/mm/vmscan.c~mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage
+++ a/mm/vmscan.c
@@ -2129,6 +2129,80 @@ out:
 	return 0;
 }
 
+static bool pfmemalloc_watermark_ok(pg_data_t *pgdat)
+{
+	struct zone *zone;
+	unsigned long pfmemalloc_reserve = 0;
+	unsigned long free_pages = 0;
+	int i;
+	bool wmark_ok;
+
+	for (i = 0; i <= ZONE_NORMAL; i++) {
+		zone = &pgdat->node_zones[i];
+		pfmemalloc_reserve += min_wmark_pages(zone);
+		free_pages += zone_page_state(zone, NR_FREE_PAGES);
+	}
+
+	wmark_ok = free_pages > pfmemalloc_reserve / 2;
+
+	/* kswapd must be awake if processes are being throttled */
+	if (!wmark_ok && waitqueue_active(&pgdat->kswapd_wait)) {
+		pgdat->classzone_idx = min(pgdat->classzone_idx,
+						(enum zone_type)ZONE_NORMAL);
+		wake_up_interruptible(&pgdat->kswapd_wait);
+	}
+
+	return wmark_ok;
+}
+
+/*
+ * Throttle direct reclaimers if backing storage is backed by the network
+ * and the PFMEMALLOC reserve for the preferred node is getting dangerously
+ * depleted. kswapd will continue to make progress and wake the processes
+ * when the low watermark is reached
+ */
+static void throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
+					nodemask_t *nodemask)
+{
+	struct zone *zone;
+	int high_zoneidx = gfp_zone(gfp_mask);
+	pg_data_t *pgdat;
+
+	/*
+	 * Kernel threads should not be throttled as they may be indirectly
+	 * responsible for cleaning pages necessary for reclaim to make forward
+	 * progress. kjournald for example may enter direct reclaim while
+	 * committing a transaction where throttling it could forcing other
+	 * processes to block on log_wait_commit().
+	 */
+	if (current->flags & PF_KTHREAD)
+		return;
+
+	/* Check if the pfmemalloc reserves are ok */
+	first_zones_zonelist(zonelist, high_zoneidx, NULL, &zone);
+	pgdat = zone->zone_pgdat;
+	if (pfmemalloc_watermark_ok(pgdat))
+		return;
+
+	/*
+	 * If the caller cannot enter the filesystem, it's possible that it
+	 * is due to the caller holding an FS lock or performing a journal
+	 * transaction in the case of a filesystem like ext[3|4]. In this case,
+	 * it is not safe to block on pfmemalloc_wait as kswapd could be
+	 * blocked waiting on the same lock. Instead, throttle for up to a
+	 * second before continuing.
+	 */
+	if (!(gfp_mask & __GFP_FS)) {
+		wait_event_interruptible_timeout(pgdat->pfmemalloc_wait,
+			pfmemalloc_watermark_ok(pgdat), HZ);
+		return;
+	}
+
+	/* Throttle until kswapd wakes the process */
+	wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
+		pfmemalloc_watermark_ok(pgdat));
+}
+
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 				gfp_t gfp_mask, nodemask_t *nodemask)
 {
@@ -2148,6 +2222,15 @@ unsigned long try_to_free_pages(struct z
 		.gfp_mask = sc.gfp_mask,
 	};
 
+	throttle_direct_reclaim(gfp_mask, zonelist, nodemask);
+
+	/*
+	 * Do not enter reclaim if fatal signal is pending. 1 is returned so
+	 * that the page allocator does not consider triggering OOM
+	 */
+	if (fatal_signal_pending(current))
+		return 1;
+
 	trace_mm_vmscan_direct_reclaim_begin(order,
 				sc.may_writepage,
 				gfp_mask);
@@ -2292,8 +2375,13 @@ static bool pgdat_balanced(pg_data_t *pg
 	return balanced_pages >= (present_pages >> 2);
 }
 
-/* is kswapd sleeping prematurely? */
-static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
+/*
+ * Prepare kswapd for sleeping. This verifies that there are no processes
+ * waiting in throttle_direct_reclaim() and that watermarks have been met.
+ *
+ * Returns true if kswapd is ready to sleep
+ */
+static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
 					int classzone_idx)
 {
 	int i;
@@ -2302,7 +2390,21 @@ static bool sleeping_prematurely(pg_data
 
 	/* If a direct reclaimer woke kswapd within HZ/10, it's premature */
 	if (remaining)
-		return true;
+		return false;
+
+	/*
+	 * There is a potential race between when kswapd checks its watermarks
+	 * and a process gets throttled. There is also a potential race if
+	 * processes get throttled, kswapd wakes, a large process exits therby
+	 * balancing the zones that causes kswapd to miss a wakeup. If kswapd
+	 * is going to sleep, no process should be sleeping on pfmemalloc_wait
+	 * so wake them now if necessary. If necessary, processes will wake
+	 * kswapd and get throttled again
+	 */
+	if (waitqueue_active(&pgdat->pfmemalloc_wait)) {
+		wake_up(&pgdat->pfmemalloc_wait);
+		return false;
+	}
 
 	/* Check the watermark levels */
 	for (i = 0; i <= classzone_idx; i++) {
@@ -2335,9 +2437,9 @@ static bool sleeping_prematurely(pg_data
 	 * must be balanced
 	 */
 	if (order)
-		return !pgdat_balanced(pgdat, balanced, classzone_idx);
+		return pgdat_balanced(pgdat, balanced, classzone_idx);
 	else
-		return !all_zones_ok;
+		return all_zones_ok;
 }
 
 /*
@@ -2563,6 +2665,16 @@ loop_again:
 			}
 
 		}
+
+		/*
+		 * If the low watermark is met there is no need for processes
+		 * to be throttled on pfmemalloc_wait as they should not be
+		 * able to safely make forward progress. Wake them
+		 */
+		if (waitqueue_active(&pgdat->pfmemalloc_wait) &&
+				pfmemalloc_watermark_ok(pgdat))
+			wake_up(&pgdat->pfmemalloc_wait);
+
 		if (all_zones_ok || (order && pgdat_balanced(pgdat, balanced, *classzone_idx)))
 			break;		/* kswapd: all done */
 		/*
@@ -2664,7 +2776,7 @@ out:
 	}
 
 	/*
-	 * Return the order we were reclaiming at so sleeping_prematurely()
+	 * Return the order we were reclaiming at so prepare_kswapd_sleep()
 	 * makes a decision on the order we were last reclaiming at. However,
 	 * if another caller entered the allocator slow path while kswapd
 	 * was awake, order will remain at the higher level
@@ -2684,7 +2796,7 @@ static void kswapd_try_to_sleep(pg_data_
 	prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 
 	/* Try to sleep for a short interval */
-	if (!sleeping_prematurely(pgdat, order, remaining, classzone_idx)) {
+	if (prepare_kswapd_sleep(pgdat, order, remaining, classzone_idx)) {
 		remaining = schedule_timeout(HZ/10);
 		finish_wait(&pgdat->kswapd_wait, &wait);
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
@@ -2694,7 +2806,7 @@ static void kswapd_try_to_sleep(pg_data_
 	 * After a short sleep, check if it was a premature sleep. If not, then
 	 * go fully to sleep until explicitly woken up.
 	 */
-	if (!sleeping_prematurely(pgdat, order, remaining, classzone_idx)) {
+	if (prepare_kswapd_sleep(pgdat, order, remaining, classzone_idx)) {
 		trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
 
 		/*
_
Subject: Subject: mm: throttle direct reclaimers if PF_MEMALLOC reserves are low and swap is backed by network storage

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-prevent-oom-with-too-many-dirty-pages-fix.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch
mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch
mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch
mm-allow-pf_memalloc-from-softirq-context.patch
mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch
mm-ignore-mempolicies-when-using-alloc_no_watermark.patch
net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch
netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch
netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch
netvm-propagate-page-pfmemalloc-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch
netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch
mm-micro-optimise-slab-to-avoid-a-function-call.patch
nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch
mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch
mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch

