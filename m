From: akpm@linux-foundation.org
Subject: + vmscan-make-kswapd-use-a-correct-order.patch added to -mm tree
Date: Thu, 09 Dec 2010 14:13:22 -0800
Message-ID: <201012092213.oB9MDMcH010088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757452Ab0LIWOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 17:14:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, shaohua.li@intel.com


The patch titled
     vmscan: make kswapd use a correct order
has been added to the -mm tree.  Its filename is
     vmscan-make-kswapd-use-a-correct-order.patch

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
Subject: vmscan: make kswapd use a correct order
From: Minchan Kim <minchan.kim@gmail.com>

If we wake up prematurely, it means we should keep going on reclaiming not
new order page but at old order page.  Sometime new order can be smaller
than old order by below race so it could make failure of old order page
reclaiming.

T0: Task 1 wakes up kswapd with order-3
T1: So, kswapd starts to reclaim pages using balance_pgdat
T2: Task 2 wakes up kswapd with order-2 because pages reclaimed
	by T1 are consumed quickly.
T3: kswapd exits balance_pgdat and will do following:
T4-1: In beginning of kswapd's loop, pgdat->kswapd_max_order will
	be reset with zero.
T4-2: 'order' will be set to pgdat->kswapd_max_order(0), since it
        enters the false branch of 'if (order (3) < new_order (2))'
T4-3: If previous balance_pgdat can't meet requirement of order-2
	free pages by high watermark, it will start reclaiming again.
        So balance_pgdat will use order-0 to do reclaim while it
	really should use order-2 at the moment.
T4-4: At last, Task 1 can't get the any page if it wanted with
	GFP_ATOMIC.

Reported-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~vmscan-make-kswapd-use-a-correct-order mm/vmscan.c
--- a/mm/vmscan.c~vmscan-make-kswapd-use-a-correct-order
+++ a/mm/vmscan.c
@@ -2454,13 +2454,18 @@ out:
 	return sc.nr_reclaimed;
 }
 
-static void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
+/*
+ * Return true if we slept enough. Otherwise, return false
+ */
+static bool kswapd_try_to_sleep(pg_data_t *pgdat, int order)
 {
 	long remaining = 0;
+	bool slept = false;
+
 	DEFINE_WAIT(wait);
 
 	if (freezing(current) || kthread_should_stop())
-		return;
+		return slept;
 
 	prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 
@@ -2489,6 +2494,7 @@ static void kswapd_try_to_sleep(pg_data_
 		set_pgdat_percpu_threshold(pgdat, calculate_normal_threshold);
 		schedule();
 		set_pgdat_percpu_threshold(pgdat, calculate_pressure_threshold);
+		slept = true;
 	} else {
 		if (remaining)
 			count_vm_event(KSWAPD_LOW_WMARK_HIT_QUICKLY);
@@ -2496,6 +2502,8 @@ static void kswapd_try_to_sleep(pg_data_
 			count_vm_event(KSWAPD_HIGH_WMARK_HIT_QUICKLY);
 	}
 	finish_wait(&pgdat->kswapd_wait, &wait);
+
+	return slept;
 }
 
 /*
@@ -2557,8 +2565,15 @@ static int kswapd(void *p)
 			 */
 			order = new_order;
 		} else {
-			kswapd_try_to_sleep(pgdat, order);
-			order = pgdat->kswapd_max_order;
+			/*
+			 * If we wake up after enough sleeping, it means
+			 * we reclaimed enough pages at that order. so
+			 * we starts reclaim new order in this time.
+			 * Otherwise, it was a premature sleep so we should
+			 * keep going on reclaiming at that order pages.
+			 */
+			if (kswapd_try_to_sleep(pgdat, order))
+				order = pgdat->kswapd_max_order;
 		}
 
 		ret = try_to_freeze();
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
mm-compactionc-avoid-double-mem_cgroup_del_lru.patch
mm-vmap-area-cache.patch
mm-find_get_pages_contig-fixlet.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
vmalloc-remove-redundant-unlikely.patch
vmscan-make-kswapd-use-a-correct-order.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

