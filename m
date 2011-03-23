From: akpm@linux-foundation.org
Subject: [folded] memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:20:28 -0700
Message-ID: <201103232320.p2NNKSFx004390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933114Ab1CWXVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: fix event counter breakage with THP
has been removed from the -mm tree.  Its filename was
     memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp.patch

This patch was dropped because it was folded into memcg-use-native-word-page-statistics-counters.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix event counter breakage with THP
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

With THP, event counter is updated by the size of large page because event
counter is for catching the change in usage.  This is now used for
threshold notifier and soft limit.

Current event counter cathces the event by mask, as

   !(counter & mask)

Before THP, counter is always updated by 1, this never misses target.
But now, this can miss.

This patch makes the trigger for event as

  counter > target.

target is updated when the event happens.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   59 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp
+++ a/mm/memcontrol.c
@@ -73,15 +73,6 @@ static int really_do_swap_account __init
 #define do_swap_account		(0)
 #endif
 
-/*
- * Per memcg event counter is incremented at every pagein/pageout. This counter
- * is used for trigger some periodic events. This is straightforward and better
- * than using jiffies etc. to handle periodic memcg event.
- *
- * These values will be used as !((event) & ((1 <<(thresh)) - 1))
- */
-#define THRESHOLDS_EVENTS_THRESH (7) /* once in 128 */
-#define SOFTLIMIT_EVENTS_THRESH (10) /* once in 1024 */
 
 /*
  * Statistics for memory cgroup.
@@ -105,10 +96,24 @@ enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_COUNT,	/* # of pages paged in/out */
 	MEM_CGROUP_EVENTS_NSTATS,
 };
+/*
+ * Per memcg event counter is incremented at every pagein/pageout. With THP,
+ * it will be incremated by the number of pages. This counter is used for
+ * for trigger some periodic events. This is straightforward and better
+ * than using jiffies etc. to handle periodic memcg event.
+ */
+enum mem_cgroup_events_target {
+        MEM_CGROUP_TARGET_THRESH,
+        MEM_CGROUP_TARGET_SOFTLIMIT,
+        MEM_CGROUP_NTARGETS,
+};
+#define THRESHOLDS_EVENTS_TARGET (128)
+#define SOFTLIMIT_EVENTS_TARGET (1024)
 
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
 	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
+        unsigned long targets[MEM_CGROUP_NTARGETS];
 };
 
 /*
@@ -634,13 +639,34 @@ static unsigned long mem_cgroup_get_loca
 	return total;
 }
 
-static bool __memcg_event_check(struct mem_cgroup *mem, int event_mask_shift)
+static bool __memcg_event_check(struct mem_cgroup *mem, int target)
 {
-	unsigned long val;
+	unsigned long val, next;
 
 	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	next = this_cpu_read(mem->stat->targets[target]);
+        /* from time_after() in jiffies.h */
+	return ((long)next - (long)val < 0);
+}
 
-	return !(val & ((1 << event_mask_shift) - 1));
+static void __mem_cgroup_target_update(struct mem_cgroup *mem, int target)
+{
+        unsigned long val, next;
+
+	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+
+        switch (target) {
+        case MEM_CGROUP_TARGET_THRESH:
+		next = val + THRESHOLDS_EVENTS_TARGET;
+            	break;
+        case MEM_CGROUP_TARGET_SOFTLIMIT:
+		next = val + SOFTLIMIT_EVENTS_TARGET;
+            	break;
+	default:
+		return;
+        }
+
+        this_cpu_write(mem->stat->targets[target], next);
 }
 
 /*
@@ -650,10 +676,15 @@ static bool __memcg_event_check(struct m
 static void memcg_check_events(struct mem_cgroup *mem, struct page *page)
 {
 	/* threshold event is triggered in finer grain than soft limit */
-	if (unlikely(__memcg_event_check(mem, THRESHOLDS_EVENTS_THRESH))) {
+	if (unlikely(__memcg_event_check(mem, MEM_CGROUP_TARGET_THRESH))) {
 		mem_cgroup_threshold(mem);
-		if (unlikely(__memcg_event_check(mem, SOFTLIMIT_EVENTS_THRESH)))
+                __mem_cgroup_target_update(mem, MEM_CGROUP_TARGET_THRESH);
+		if (unlikely(__memcg_event_check(mem,
+			MEM_CGROUP_TARGET_SOFTLIMIT))){
 			mem_cgroup_update_tree(mem, page);
+			__mem_cgroup_target_update(mem,
+				MEM_CGROUP_TARGET_SOFTLIMIT);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix.patch
memcg-page_cgroup-array-is-never-stored-on-reserved-pages.patch
memcg-fix-leak-on-wrong-lru-with-fuse.patch
memcg-give-current-access-to-memory-reserves-if-its-trying-to-die.patch

