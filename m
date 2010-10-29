From: akpm@linux-foundation.org
Subject: + memcg-check-memcg-dirty-limits-in-page-writeback.patch added to -mm tree
Date: Fri, 29 Oct 2010 13:19:59 -0700
Message-ID: <201010292019.o9TKJxiK014992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761919Ab0J2UUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 16:20:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: check memcg dirty limits in page writeback
has been added to the -mm tree.  Its filename is
     memcg-check-memcg-dirty-limits-in-page-writeback.patch

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
Subject: memcg: check memcg dirty limits in page writeback
From: Greg Thelen <gthelen@google.com>

If the current process is in a non-root memcg, then balance_dirty_pages()
will consider the memcg dirty limits as well as the system-wide limits. 
This allows different cgroups to have distinct dirty limits which trigger
direct and background writeback at different levels.

Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |  109 ++++++++++++++++++++++++++++++------------
 1 file changed, 78 insertions(+), 31 deletions(-)

diff -puN mm/page-writeback.c~memcg-check-memcg-dirty-limits-in-page-writeback mm/page-writeback.c
--- a/mm/page-writeback.c~memcg-check-memcg-dirty-limits-in-page-writeback
+++ a/mm/page-writeback.c
@@ -131,6 +131,18 @@ EXPORT_SYMBOL(laptop_mode);
 static struct prop_descriptor vm_completions;
 static struct prop_descriptor vm_dirties;
 
+static unsigned long dirty_writeback_pages(void)
+{
+	s64 ret;
+
+	ret = mem_cgroup_page_stat(MEMCG_NR_DIRTY_WRITEBACK_PAGES);
+	if (ret < 0)
+		ret = global_page_state(NR_UNSTABLE_NFS) +
+			global_page_state(NR_WRITEBACK);
+
+	return ret;
+}
+
 /*
  * couple the period to the dirty_ratio:
  *
@@ -398,45 +410,67 @@ unsigned long determine_dirtyable_memory
 }
 
 /*
+ * The dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
+ * runtime tasks.
+ */
+static inline void adjust_dirty_info(struct dirty_info *info)
+{
+	struct task_struct *tsk;
+
+	if (info->background_thresh >= info->dirty_thresh)
+		info->background_thresh = info->dirty_thresh / 2;
+	tsk = current;
+	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
+		info->background_thresh += info->background_thresh / 4;
+		info->dirty_thresh += info->dirty_thresh / 4;
+	}
+}
+
+/*
  * global_dirty_info - return background-writeback and dirty-throttling
  * thresholds as well as dirty usage metrics.
  *
  * Calculate the dirty thresholds based on sysctl parameters
  * - vm.dirty_background_ratio  or  vm.dirty_background_bytes
  * - vm.dirty_ratio             or  vm.dirty_bytes
- * The dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
- * runtime tasks.
  */
 void global_dirty_info(struct dirty_info *info)
 {
-	unsigned long background;
-	unsigned long dirty;
 	unsigned long available_memory = determine_dirtyable_memory();
-	struct task_struct *tsk;
 
 	if (vm_dirty_bytes)
-		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
+		info->dirty_thresh = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
 	else
-		dirty = (vm_dirty_ratio * available_memory) / 100;
+		info->dirty_thresh = (vm_dirty_ratio * available_memory) / 100;
 
 	if (dirty_background_bytes)
-		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
+		info->background_thresh =
+			DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
 	else
-		background = (dirty_background_ratio * available_memory) / 100;
+		info->background_thresh =
+			(dirty_background_ratio * available_memory) / 100;
 
 	info->nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 				global_page_state(NR_UNSTABLE_NFS);
 	info->nr_writeback = global_page_state(NR_WRITEBACK);
 
-	if (background >= dirty)
-		background = dirty / 2;
-	tsk = current;
-	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
-		background += background / 4;
-		dirty += dirty / 4;
-	}
-	info->background_thresh = background;
-	info->dirty_thresh = dirty;
+	adjust_dirty_info(info);
+}
+
+/*
+ * Calculate the background-writeback and dirty-throttling thresholds and dirty
+ * usage metrics from the current task's memcg dirty limit parameters.  Returns
+ * false if no memcg limits exist.
+ */
+static bool memcg_dirty_info(struct dirty_info *info)
+{
+	unsigned long available_memory = determine_dirtyable_memory();
+
+	if (!mem_cgroup_dirty_info(available_memory, info))
+		return false;
+
+	adjust_dirty_info(info);
+	return true;
 }
 
 /*
@@ -480,7 +514,8 @@ unsigned long bdi_dirty_limit(struct bac
 static void balance_dirty_pages(struct address_space *mapping,
 				unsigned long write_chunk)
 {
-	struct dirty_info dirty_info;
+	struct dirty_info sys_info;
+	struct dirty_info memcg_info;
 	long bdi_nr_reclaimable;
 	long bdi_nr_writeback;
 	unsigned long bdi_thresh;
@@ -497,19 +532,27 @@ static void balance_dirty_pages(struct a
 			.range_cyclic	= 1,
 		};
 
-		global_dirty_info(&dirty_info);
+		global_dirty_info(&sys_info);
+
+		if (!memcg_dirty_info(&memcg_info))
+			memcg_info = sys_info;
 
 		/*
 		 * Throttle it only when the background writeback cannot
 		 * catch-up. This avoids (excessively) small writeouts
 		 * when the bdi limits are ramping up.
 		 */
-		if (dirty_info.nr_reclaimable + dirty_info.nr_writeback <=
-				(dirty_info.background_thresh +
-				 dirty_info.dirty_thresh) / 2)
+		if ((sys_info.nr_reclaimable + sys_info.nr_writeback <=
+				(sys_info.background_thresh +
+				 sys_info.dirty_thresh) / 2) &&
+		    (memcg_info.nr_reclaimable + memcg_info.nr_writeback <=
+				(memcg_info.background_thresh +
+				 memcg_info.dirty_thresh) / 2))
 			break;
 
-		bdi_thresh = bdi_dirty_limit(bdi, dirty_info.dirty_thresh);
+		bdi_thresh = bdi_dirty_limit(bdi,
+				min(sys_info.dirty_thresh,
+				    memcg_info.dirty_thresh));
 		bdi_thresh = task_dirty_limit(current, bdi_thresh);
 
 		/*
@@ -538,9 +581,12 @@ static void balance_dirty_pages(struct a
 		 */
 		dirty_exceeded =
 			(bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh)
-			|| (dirty_info.nr_reclaimable +
-			    dirty_info.nr_writeback >
-			    dirty_info.dirty_thresh);
+			|| (sys_info.nr_reclaimable +
+			    sys_info.nr_writeback >
+			    sys_info.dirty_thresh)
+			|| (memcg_info.nr_reclaimable +
+			    memcg_info.nr_writeback >
+			    memcg_info.dirty_thresh);
 
 		if (!dirty_exceeded)
 			break;
@@ -593,8 +639,10 @@ static void balance_dirty_pages(struct a
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
 	if ((laptop_mode && pages_written) ||
-	    (!laptop_mode && (dirty_info.nr_reclaimable >
-			      dirty_info.background_thresh)))
+	    (!laptop_mode && ((sys_info.nr_reclaimable >
+			       sys_info.background_thresh) ||
+			      (memcg_info.nr_reclaimable >
+			       memcg_info.background_thresh))))
 		bdi_start_background_writeback(bdi);
 }
 
@@ -666,8 +714,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 		dirty_info.dirty_thresh +=
 			dirty_info.dirty_thresh / 10;      /* wheeee... */
 
-                if (global_page_state(NR_UNSTABLE_NFS) +
-		    global_page_state(NR_WRITEBACK) <= dirty_info.dirty_thresh)
+		if (dirty_writeback_pages() <= dirty_info.dirty_thresh)
 			break;
                 congestion_wait(BLK_RW_ASYNC, HZ/10);
 
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch

