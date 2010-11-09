From: akpm@linux-foundation.org
Subject: + memcg-make-throttle_vm_writeout-memcg-aware.patch added to -mm tree
Date: Tue, 09 Nov 2010 11:21:53 -0800
Message-ID: <201011091921.oA9JLseI002250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab0KITWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2010 14:22:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: make throttle_vm_writeout() memcg aware
has been added to the -mm tree.  Its filename is
     memcg-make-throttle_vm_writeout-memcg-aware.patch

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
Subject: memcg: make throttle_vm_writeout() memcg aware
From: Greg Thelen <gthelen@google.com>

If called with a mem_cgroup, then throttle_vm_writeout() should query the
given cgroup for its dirty memory usage limits.

dirty_writeback_pages() is no longer used, so delete it.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    2 +-
 mm/page-writeback.c       |   31 ++++++++++++++++---------------
 mm/vmscan.c               |    2 +-
 3 files changed, 18 insertions(+), 17 deletions(-)

diff -puN include/linux/writeback.h~memcg-make-throttle_vm_writeout-memcg-aware include/linux/writeback.h
--- a/include/linux/writeback.h~memcg-make-throttle_vm_writeout-memcg-aware
+++ a/include/linux/writeback.h
@@ -99,7 +99,7 @@ void laptop_mode_timer_fn(unsigned long 
 #else
 static inline void laptop_sync_completion(void) { }
 #endif
-void throttle_vm_writeout(gfp_t gfp_mask);
+void throttle_vm_writeout(gfp_t gfp_mask, struct mem_cgroup *mem_cgroup);
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
diff -puN mm/page-writeback.c~memcg-make-throttle_vm_writeout-memcg-aware mm/page-writeback.c
--- a/mm/page-writeback.c~memcg-make-throttle_vm_writeout-memcg-aware
+++ a/mm/page-writeback.c
@@ -131,18 +131,6 @@ EXPORT_SYMBOL(laptop_mode);
 static struct prop_descriptor vm_completions;
 static struct prop_descriptor vm_dirties;
 
-static unsigned long dirty_writeback_pages(void)
-{
-	unsigned long ret;
-
-	ret = mem_cgroup_page_stat(NULL, MEMCG_NR_DIRTY_WRITEBACK_PAGES);
-	if ((long)ret < 0)
-		ret = global_page_state(NR_UNSTABLE_NFS) +
-			global_page_state(NR_WRITEBACK);
-
-	return ret;
-}
-
 /*
  * couple the period to the dirty_ratio:
  *
@@ -703,12 +691,25 @@ void balance_dirty_pages_ratelimited_nr(
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 
-void throttle_vm_writeout(gfp_t gfp_mask)
+/*
+ * Throttle the current task if it is near dirty memory usage limits.
+ * If @mem_cgroup is NULL or the root_cgroup, then use global dirty memory
+ * information; otherwise use the per-memcg dirty limits.
+ */
+void throttle_vm_writeout(gfp_t gfp_mask, struct mem_cgroup *mem_cgroup)
 {
 	struct dirty_info dirty_info;
+	unsigned long nr_writeback;
 
         for ( ; ; ) {
-		global_dirty_info(&dirty_info);
+		if (!mem_cgroup || !memcg_dirty_info(mem_cgroup, &dirty_info)) {
+			global_dirty_info(&dirty_info);
+			nr_writeback = global_page_state(NR_UNSTABLE_NFS) +
+				global_page_state(NR_WRITEBACK);
+		} else {
+			nr_writeback = mem_cgroup_page_stat(
+				mem_cgroup, MEMCG_NR_DIRTY_WRITEBACK_PAGES);
+		}
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
@@ -717,7 +718,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 		dirty_info.dirty_thresh +=
 			dirty_info.dirty_thresh / 10;      /* wheeee... */
 
-		if (dirty_writeback_pages() <= dirty_info.dirty_thresh)
+		if (nr_writeback <= dirty_info.dirty_thresh)
 			break;
                 congestion_wait(BLK_RW_ASYNC, HZ/10);
 
diff -puN mm/vmscan.c~memcg-make-throttle_vm_writeout-memcg-aware mm/vmscan.c
--- a/mm/vmscan.c~memcg-make-throttle_vm_writeout-memcg-aware
+++ a/mm/vmscan.c
@@ -1844,7 +1844,7 @@ static void shrink_zone(int priority, st
 	if (inactive_anon_is_low(zone, sc))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
-	throttle_vm_writeout(sc->gfp_mask);
+	throttle_vm_writeout(sc->gfp_mask, sc->mem_cgroup);
 }
 
 /*
_

Patches currently in -mm which might be from gthelen@google.com are

memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch
memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix.patch
memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat.patch
memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info.patch
memcg-make-throttle_vm_writeout-memcg-aware.patch
memcg-simplify-mem_cgroup_page_stat.patch
memcg-simplify-mem_cgroup_dirty_info.patch
memcg-make-mem_cgroup_page_stat-return-value-unsigned.patch

