From: akpm@linux-foundation.org
Subject: [withdrawn] vmstat-add-anon_scan_ratio-field-to-zoneinfo.patch removed from -mm tree
Date: Sun, 24 Jan 2010 21:34:31 -0800
Message-ID: <201001250534.o0P5YVxo001093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776Ab0AYFfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 00:35:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmstat: add anon_scan_ratio field to zoneinfo
has been removed from the -mm tree.  Its filename was
     vmstat-add-anon_scan_ratio-field-to-zoneinfo.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmstat: add anon_scan_ratio field to zoneinfo
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Vmscan folks were asked "why does my system makes so much swap-out?" in
lkml at several times.

At that time, I made the debug patch to show recent_anon_{scanned/rorated}
parameter at least three times.

Thus, its parameter should be showed on /proc/zoneinfo.  It help vmscan
folks debugging.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +
 mm/vmscan.c          |   50 +++++++++++++++++++++++++++++------------
 mm/vmstat.c          |    7 ++++-
 3 files changed, 43 insertions(+), 16 deletions(-)

diff -puN include/linux/swap.h~vmstat-add-anon_scan_ratio-field-to-zoneinfo include/linux/swap.h
--- a/include/linux/swap.h~vmstat-add-anon_scan_ratio-field-to-zoneinfo
+++ a/include/linux/swap.h
@@ -280,6 +280,8 @@ extern void scan_unevictable_unregister_
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
 
+unsigned long get_anon_scan_ratio(struct zone *zone, struct mem_cgroup *memcg, int swappiness);
+
 #ifdef CONFIG_MMU
 /* linux/mm/shmem.c */
 extern int shmem_unuse(swp_entry_t entry, struct page *page);
diff -puN mm/vmscan.c~vmstat-add-anon_scan_ratio-field-to-zoneinfo mm/vmscan.c
--- a/mm/vmscan.c~vmstat-add-anon_scan_ratio-field-to-zoneinfo
+++ a/mm/vmscan.c
@@ -1493,8 +1493,8 @@ static unsigned long shrink_list(enum lr
  * percent[0] specifies how much pressure to put on ram/swap backed
  * memory, while percent[1] determines pressure on the file LRUs.
  */
-static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
-					unsigned long *percent)
+static void __get_scan_ratio(struct zone *zone, struct scan_control *sc,
+			     int need_update, unsigned long *percent)
 {
 	unsigned long anon, file, free;
 	unsigned long anon_prio, file_prio;
@@ -1535,18 +1535,19 @@ static void get_scan_ratio(struct zone *
 	 *
 	 * anon in [0], file in [1]
 	 */
-	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
-		spin_lock_irq(&zone->lru_lock);
-		reclaim_stat->recent_scanned[0] /= 2;
-		reclaim_stat->recent_rotated[0] /= 2;
-		spin_unlock_irq(&zone->lru_lock);
-	}
-
-	if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
-		spin_lock_irq(&zone->lru_lock);
-		reclaim_stat->recent_scanned[1] /= 2;
-		reclaim_stat->recent_rotated[1] /= 2;
-		spin_unlock_irq(&zone->lru_lock);
+	if (need_update) {
+		if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
+			spin_lock_irq(&zone->lru_lock);
+			reclaim_stat->recent_scanned[0] /= 2;
+			reclaim_stat->recent_rotated[0] /= 2;
+			spin_unlock_irq(&zone->lru_lock);
+		}
+		if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
+			spin_lock_irq(&zone->lru_lock);
+			reclaim_stat->recent_scanned[1] /= 2;
+			reclaim_stat->recent_rotated[1] /= 2;
+			spin_unlock_irq(&zone->lru_lock);
+		}
 	}
 
 	/*
@@ -1572,6 +1573,27 @@ static void get_scan_ratio(struct zone *
 	percent[1] = 100 - percent[0];
 }
 
+static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
+			   unsigned long *percent)
+{
+	__get_scan_ratio(zone, sc, 1, percent);
+}
+
+unsigned long get_anon_scan_ratio(struct zone *zone, struct mem_cgroup *memcg, int swappiness)
+{
+	unsigned long percent[2];
+	struct scan_control sc = {
+		.may_swap = 1,
+		.swappiness = swappiness,
+		.mem_cgroup = memcg,
+	};
+
+	__get_scan_ratio(zone, &sc, 0, percent);
+
+	return percent[0];
+}
+
+
 /*
  * Smallish @nr_to_scan's are deposited in @nr_saved_scan,
  * until we collected @swap_cluster_max pages to scan.
diff -puN mm/vmstat.c~vmstat-add-anon_scan_ratio-field-to-zoneinfo mm/vmstat.c
--- a/mm/vmstat.c~vmstat-add-anon_scan_ratio-field-to-zoneinfo
+++ a/mm/vmstat.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/vmstat.h>
 #include <linux/sched.h>
+#include <linux/swap.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
@@ -762,11 +763,13 @@ static void zoneinfo_show_print(struct s
 		   "\n  all_unreclaimable: %u"
 		   "\n  prev_priority:     %i"
 		   "\n  start_pfn:         %lu"
-		   "\n  inactive_ratio:    %u",
+		   "\n  inactive_ratio:    %u"
+		   "\n  anon_scan_ratio:   %lu",
 			   zone_is_all_unreclaimable(zone),
 		   zone->prev_priority,
 		   zone->zone_start_pfn,
-		   zone->inactive_ratio);
+		   zone->inactive_ratio,
+		   get_anon_scan_ratio(zone, NULL, vm_swappiness));
 	seq_putc(m, '\n');
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
vmstat-add-anon_scan_ratio-field-to-zoneinfo.patch
memcg-add-anon_scan_ratio-to-memorystat-file.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-fix-mbind-vma-merge-problem.patch
mm-fix-mbind-vma-merge-problem-fix.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

