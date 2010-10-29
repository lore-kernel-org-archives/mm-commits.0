From: akpm@linux-foundation.org
Subject: + writeback-create-dirty_info-structure.patch added to -mm tree
Date: Fri, 29 Oct 2010 13:19:47 -0700
Message-ID: <201010292019.o9TKJlbh014962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761919Ab0J2UUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 16:20:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     writeback: create dirty_info structure
has been added to the -mm tree.  Its filename is
     writeback-create-dirty_info-structure.patch

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
Subject: writeback: create dirty_info structure
From: Greg Thelen <gthelen@google.com>

Bundle dirty limits and dirty memory usage metrics into a dirty_info
structure to simplify interfaces of routines that need all.

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Righi <arighi@develer.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |    7 ++--
 include/linux/writeback.h |    9 +++++-
 mm/backing-dev.c          |   12 ++++----
 mm/page-writeback.c       |   52 +++++++++++++++++++-----------------
 mm/vmstat.c               |    6 ++--
 5 files changed, 49 insertions(+), 37 deletions(-)

diff -puN fs/fs-writeback.c~writeback-create-dirty_info-structure fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-create-dirty_info-structure
+++ a/fs/fs-writeback.c
@@ -581,12 +581,11 @@ static void __writeback_inodes_sb(struct
 
 static inline bool over_bground_thresh(void)
 {
-	unsigned long background_thresh, dirty_thresh;
+	struct dirty_info info;
 
-	global_dirty_limits(&background_thresh, &dirty_thresh);
+	global_dirty_info(&info);
 
-	return (global_page_state(NR_FILE_DIRTY) +
-		global_page_state(NR_UNSTABLE_NFS) > background_thresh);
+	return info.nr_reclaimable > info.background_thresh;
 }
 
 /*
diff -puN include/linux/writeback.h~writeback-create-dirty_info-structure include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-create-dirty_info-structure
+++ a/include/linux/writeback.h
@@ -82,6 +82,13 @@ static inline void inode_sync_wait(struc
 /*
  * mm/page-writeback.c
  */
+struct dirty_info {
+	unsigned long dirty_thresh;
+	unsigned long background_thresh;
+	unsigned long nr_reclaimable;
+	unsigned long nr_writeback;
+};
+
 #ifdef CONFIG_BLOCK
 void laptop_io_completion(struct backing_dev_info *info);
 void laptop_sync_completion(void);
@@ -122,7 +129,7 @@ struct ctl_table;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int,
 				      void __user *, size_t *, loff_t *);
 
-void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
+void global_dirty_info(struct dirty_info *info);
 unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
 			       unsigned long dirty);
 
diff -puN mm/backing-dev.c~writeback-create-dirty_info-structure mm/backing-dev.c
--- a/mm/backing-dev.c~writeback-create-dirty_info-structure
+++ a/mm/backing-dev.c
@@ -66,8 +66,7 @@ static int bdi_debug_stats_show(struct s
 {
 	struct backing_dev_info *bdi = m->private;
 	struct bdi_writeback *wb = &bdi->wb;
-	unsigned long background_thresh;
-	unsigned long dirty_thresh;
+	struct dirty_info dirty_info;
 	unsigned long bdi_thresh;
 	unsigned long nr_dirty, nr_io, nr_more_io, nr_wb;
 	struct inode *inode;
@@ -82,8 +81,8 @@ static int bdi_debug_stats_show(struct s
 		nr_more_io++;
 	spin_unlock(&inode_lock);
 
-	global_dirty_limits(&background_thresh, &dirty_thresh);
-	bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
+	global_dirty_info(&dirty_info);
+	bdi_thresh = bdi_dirty_limit(bdi, dirty_info.dirty_thresh);
 
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	seq_printf(m,
@@ -99,8 +98,9 @@ static int bdi_debug_stats_show(struct s
 		   "state:            %8lx\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-		   K(bdi_thresh), K(dirty_thresh),
-		   K(background_thresh), nr_dirty, nr_io, nr_more_io,
+		   K(bdi_thresh), K(dirty_info.dirty_thresh),
+		   K(dirty_info.background_thresh),
+		   nr_dirty, nr_io, nr_more_io,
 		   !list_empty(&bdi->bdi_list), bdi->state);
 #undef K
 
diff -puN mm/page-writeback.c~writeback-create-dirty_info-structure mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-create-dirty_info-structure
+++ a/mm/page-writeback.c
@@ -398,7 +398,8 @@ unsigned long determine_dirtyable_memory
 }
 
 /*
- * global_dirty_limits - background-writeback and dirty-throttling thresholds
+ * global_dirty_info - return background-writeback and dirty-throttling
+ * thresholds as well as dirty usage metrics.
  *
  * Calculate the dirty thresholds based on sysctl parameters
  * - vm.dirty_background_ratio  or  vm.dirty_background_bytes
@@ -406,7 +407,7 @@ unsigned long determine_dirtyable_memory
  * The dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
  * runtime tasks.
  */
-void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
+void global_dirty_info(struct dirty_info *info)
 {
 	unsigned long background;
 	unsigned long dirty;
@@ -423,6 +424,10 @@ void global_dirty_limits(unsigned long *
 	else
 		background = (dirty_background_ratio * available_memory) / 100;
 
+	info->nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
+				global_page_state(NR_UNSTABLE_NFS);
+	info->nr_writeback = global_page_state(NR_WRITEBACK);
+
 	if (background >= dirty)
 		background = dirty / 2;
 	tsk = current;
@@ -430,8 +435,8 @@ void global_dirty_limits(unsigned long *
 		background += background / 4;
 		dirty += dirty / 4;
 	}
-	*pbackground = background;
-	*pdirty = dirty;
+	info->background_thresh = background;
+	info->dirty_thresh = dirty;
 }
 
 /*
@@ -475,10 +480,9 @@ unsigned long bdi_dirty_limit(struct bac
 static void balance_dirty_pages(struct address_space *mapping,
 				unsigned long write_chunk)
 {
-	long nr_reclaimable, bdi_nr_reclaimable;
-	long nr_writeback, bdi_nr_writeback;
-	unsigned long background_thresh;
-	unsigned long dirty_thresh;
+	struct dirty_info dirty_info;
+	long bdi_nr_reclaimable;
+	long bdi_nr_writeback;
 	unsigned long bdi_thresh;
 	unsigned long pages_written = 0;
 	unsigned long pause = 1;
@@ -493,22 +497,19 @@ static void balance_dirty_pages(struct a
 			.range_cyclic	= 1,
 		};
 
-		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
-
-		global_dirty_limits(&background_thresh, &dirty_thresh);
+		global_dirty_info(&dirty_info);
 
 		/*
 		 * Throttle it only when the background writeback cannot
 		 * catch-up. This avoids (excessively) small writeouts
 		 * when the bdi limits are ramping up.
 		 */
-		if (nr_reclaimable + nr_writeback <=
-				(background_thresh + dirty_thresh) / 2)
+		if (dirty_info.nr_reclaimable + dirty_info.nr_writeback <=
+				(dirty_info.background_thresh +
+				 dirty_info.dirty_thresh) / 2)
 			break;
 
-		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
+		bdi_thresh = bdi_dirty_limit(bdi, dirty_info.dirty_thresh);
 		bdi_thresh = task_dirty_limit(current, bdi_thresh);
 
 		/*
@@ -537,7 +538,9 @@ static void balance_dirty_pages(struct a
 		 */
 		dirty_exceeded =
 			(bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh)
-			|| (nr_reclaimable + nr_writeback > dirty_thresh);
+			|| (dirty_info.nr_reclaimable +
+			    dirty_info.nr_writeback >
+			    dirty_info.dirty_thresh);
 
 		if (!dirty_exceeded)
 			break;
@@ -590,7 +593,8 @@ static void balance_dirty_pages(struct a
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
 	if ((laptop_mode && pages_written) ||
-	    (!laptop_mode && (nr_reclaimable > background_thresh)))
+	    (!laptop_mode && (dirty_info.nr_reclaimable >
+			      dirty_info.background_thresh)))
 		bdi_start_background_writeback(bdi);
 }
 
@@ -650,21 +654,21 @@ EXPORT_SYMBOL(balance_dirty_pages_rateli
 
 void throttle_vm_writeout(gfp_t gfp_mask)
 {
-	unsigned long background_thresh;
-	unsigned long dirty_thresh;
+	struct dirty_info dirty_info;
 
         for ( ; ; ) {
-		global_dirty_limits(&background_thresh, &dirty_thresh);
+		global_dirty_info(&dirty_info);
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
                  * allocators so they don't get DoS'ed by heavy writers
                  */
-                dirty_thresh += dirty_thresh / 10;      /* wheeee... */
+		dirty_info.dirty_thresh +=
+			dirty_info.dirty_thresh / 10;      /* wheeee... */
 
                 if (global_page_state(NR_UNSTABLE_NFS) +
-			global_page_state(NR_WRITEBACK) <= dirty_thresh)
-                        	break;
+		    global_page_state(NR_WRITEBACK) <= dirty_info.dirty_thresh)
+			break;
                 congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/*
diff -puN mm/vmstat.c~writeback-create-dirty_info-structure mm/vmstat.c
--- a/mm/vmstat.c~writeback-create-dirty_info-structure
+++ a/mm/vmstat.c
@@ -968,6 +968,7 @@ static void *vmstat_start(struct seq_fil
 {
 	unsigned long *v;
 	int i, stat_items_size;
+	struct dirty_info dirty_info;
 
 	if (*pos >= ARRAY_SIZE(vmstat_text))
 		return NULL;
@@ -986,8 +987,9 @@ static void *vmstat_start(struct seq_fil
 		v[i] = global_page_state(i);
 	v += NR_VM_ZONE_STAT_ITEMS;
 
-	global_dirty_limits(v + NR_DIRTY_BG_THRESHOLD,
-			    v + NR_DIRTY_THRESHOLD);
+	global_dirty_info(&dirty_info);
+	v[NR_DIRTY_BG_THRESHOLD] = dirty_info.background_thresh;
+	v[NR_DIRTY_THRESHOLD] = dirty_info.dirty_thresh;
 	v += NR_VM_WRITEBACK_STAT_ITEMS;
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
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

