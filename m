From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-check-memcg-dirty-limits-in-page-writeback.patch removed from -mm tree
Date: Tue, 29 Mar 2011 16:12:00 -0700
Message-ID: <201103292312.p2TNC0Vo011263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989Ab1C2XMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Mar 2011 19:12:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, ctalbott@google.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.co


The patch titled
     memcg: check memcg dirty limits in page writeback
has been removed from the -mm tree.  Its filename was
     memcg-check-memcg-dirty-limits-in-page-writeback.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: check memcg dirty limits in page writeback
From: Greg Thelen <gthelen@google.com>

If the current process is in a non-root memcg, then balance_dirty_pages()
will consider the memcg dirty limits as well as the system-wide limits. 
This allows different cgroups to have distinct dirty limits which trigger
direct and background writeback at different levels.

If called with a mem_cgroup, then throttle_vm_writeout() queries the given
cgroup for its dirty memory usage limits.

Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Chad Talbott <ctalbott@google.com>
Cc: Justin TerAvest <teravest@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    3 ++-
 mm/page-writeback.c       |   32 +++++++++++++++++++++++++++-----
 mm/vmscan.c               |    2 +-
 3 files changed, 30 insertions(+), 7 deletions(-)

diff -puN include/linux/writeback.h~memcg-check-memcg-dirty-limits-in-page-writeback include/linux/writeback.h
--- a/include/linux/writeback.h~memcg-check-memcg-dirty-limits-in-page-writeback
+++ a/include/linux/writeback.h
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 
 struct backing_dev_info;
+struct mem_cgroup;
 
 extern spinlock_t inode_wb_list_lock;
 
@@ -92,7 +93,7 @@ void laptop_mode_timer_fn(unsigned long 
 #else
 static inline void laptop_sync_completion(void) { }
 #endif
-void throttle_vm_writeout(gfp_t gfp_mask);
+void throttle_vm_writeout(gfp_t gfp_mask, struct mem_cgroup *mem_cgroup);
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
diff -puN mm/page-writeback.c~memcg-check-memcg-dirty-limits-in-page-writeback mm/page-writeback.c
--- a/mm/page-writeback.c~memcg-check-memcg-dirty-limits-in-page-writeback
+++ a/mm/page-writeback.c
@@ -473,7 +473,8 @@ unsigned long bdi_dirty_limit(struct bac
  * data.  It looks at the number of dirty pages in the machine and will force
  * the caller to perform writeback if the system is over `vm_dirty_ratio'.
  * If we're over `background_thresh' then the writeback threads are woken to
- * perform some writeout.
+ * perform some writeout.  The current task may have per-memcg dirty
+ * limits, which are also checked.
  */
 static void balance_dirty_pages(struct address_space *mapping,
 				unsigned long write_chunk)
@@ -488,6 +489,8 @@ static void balance_dirty_pages(struct a
 	bool dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
+	mem_cgroup_balance_dirty_pages(mapping, write_chunk);
+
 	for (;;) {
 		struct writeback_control wbc = {
 			.sync_mode	= WB_SYNC_NONE,
@@ -651,23 +654,42 @@ void balance_dirty_pages_ratelimited_nr(
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 
-void throttle_vm_writeout(gfp_t gfp_mask)
+/*
+ * Throttle the current task if it is near dirty memory usage limits.  Both
+ * global dirty memory limits and (if @mem_cgroup is given) per-cgroup dirty
+ * memory limits are checked.
+ *
+ * If near limits, then wait for usage to drop.  Dirty usage should drop because
+ * dirty producers should have used balance_dirty_pages(), which would have
+ * scheduled writeback.
+ */
+void throttle_vm_writeout(gfp_t gfp_mask, struct mem_cgroup *mem_cgroup)
 {
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
+	struct dirty_info memcg_info;
+	bool do_memcg;
 
         for ( ; ; ) {
 		global_dirty_limits(&background_thresh, &dirty_thresh);
+		do_memcg = mem_cgroup && mem_cgroup_hierarchical_dirty_info(
+			determine_dirtyable_memory(), true, mem_cgroup,
+			&memcg_info);
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
                  * allocators so they don't get DoS'ed by heavy writers
                  */
                 dirty_thresh += dirty_thresh / 10;      /* wheeee... */
+		if (do_memcg)
+			memcg_info.dirty_thresh += memcg_info.dirty_thresh / 10;
 
-                if (global_page_state(NR_UNSTABLE_NFS) +
-			global_page_state(NR_WRITEBACK) <= dirty_thresh)
-                        	break;
+		if ((global_page_state(NR_UNSTABLE_NFS) +
+		     global_page_state(NR_WRITEBACK) <= dirty_thresh) &&
+		    (!do_memcg ||
+		     (memcg_info.nr_unstable_nfs +
+		      memcg_info.nr_writeback <= memcg_info.dirty_thresh)))
+			break;
                 congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/*
diff -puN mm/vmscan.c~memcg-check-memcg-dirty-limits-in-page-writeback mm/vmscan.c
--- a/mm/vmscan.c~memcg-check-memcg-dirty-limits-in-page-writeback
+++ a/mm/vmscan.c
@@ -1939,7 +1939,7 @@ restart:
 					sc->nr_scanned - nr_scanned, sc))
 		goto restart;
 
-	throttle_vm_writeout(sc->gfp_mask);
+	throttle_vm_writeout(sc->gfp_mask, sc->mem_cgroup);
 }
 
 /*
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
memcg-make-background-writeback-memcg-aware.patch

