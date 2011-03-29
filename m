From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-make-background-writeback-memcg-aware.patch removed from -mm tree
Date: Tue, 29 Mar 2011 16:12:02 -0700
Message-ID: <201103292312.p2TNC2Vx011275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445Ab1C2XRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Mar 2011 19:17:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, ctalbott@google.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.co


The patch titled
     memcg: make background writeback memcg aware
has been removed from the -mm tree.  Its filename was
     memcg-make-background-writeback-memcg-aware.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: make background writeback memcg aware
From: Greg Thelen <gthelen@google.com>

Add an memcg parameter to bdi_start_background_writeback().  If a memcg is
specified then the resulting background writeback call to wb_writeback()
will run until the memcg dirty memory usage drops below the memcg
background limit.  This is used when balancing memcg dirty memory with
mem_cgroup_balance_dirty_pages().

If the memcg parameter is not specified, then background writeback runs
globally system dirty memory usage falls below the system background
limit.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chad Talbott <ctalbott@google.com>
Cc: Justin TerAvest <teravest@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c           |   63 ++++++++++++++++------------------
 include/linux/backing-dev.h |    3 +
 mm/memcontrol.c             |    2 -
 mm/page-writeback.c         |    2 -
 4 files changed, 34 insertions(+), 36 deletions(-)

diff -puN fs/fs-writeback.c~memcg-make-background-writeback-memcg-aware fs/fs-writeback.c
--- a/fs/fs-writeback.c~memcg-make-background-writeback-memcg-aware
+++ a/fs/fs-writeback.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/memcontrol.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/writeback.h>
@@ -35,6 +36,7 @@
 struct wb_writeback_work {
 	long nr_pages;
 	struct super_block *sb;
+	struct mem_cgroup *mem_cgroup;	/* NULL for global (root cgroup) */
 	enum writeback_sync_modes sync_mode;
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
@@ -113,7 +115,8 @@ static void bdi_queue_work(struct backin
 
 static void
 __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
-		      bool range_cyclic)
+		      bool range_cyclic, bool for_background,
+		      struct mem_cgroup *mem_cgroup)
 {
 	struct wb_writeback_work *work;
 
@@ -133,6 +136,8 @@ __bdi_start_writeback(struct backing_dev
 	work->sync_mode	= WB_SYNC_NONE;
 	work->nr_pages	= nr_pages;
 	work->range_cyclic = range_cyclic;
+	work->for_background = for_background;
+	work->mem_cgroup = mem_cgroup;
 
 	bdi_queue_work(bdi, work);
 }
@@ -150,7 +155,7 @@ __bdi_start_writeback(struct backing_dev
  */
 void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages)
 {
-	__bdi_start_writeback(bdi, nr_pages, true);
+	__bdi_start_writeback(bdi, nr_pages, true, false, NULL);
 }
 
 /**
@@ -163,16 +168,10 @@ void bdi_start_writeback(struct backing_
  *   some IO is happening if we are over background dirty threshold.
  *   Caller need not hold sb s_umount semaphore.
  */
-void bdi_start_background_writeback(struct backing_dev_info *bdi)
+void bdi_start_background_writeback(struct backing_dev_info *bdi,
+				    struct mem_cgroup *mem_cgroup)
 {
-	/*
-	 * We just wake up the flusher thread. It will perform background
-	 * writeback as soon as there is no other work to do.
-	 */
-	trace_writeback_wake_background(bdi);
-	spin_lock_bh(&bdi->wb_lock);
-	bdi_wakeup_flusher(bdi);
-	spin_unlock_bh(&bdi->wb_lock);
+	__bdi_start_writeback(bdi, LONG_MAX, true, true, mem_cgroup);
 }
 
 /*
@@ -593,10 +592,22 @@ static void __writeback_inodes_sb(struct
  */
 #define MAX_WRITEBACK_PAGES     1024
 
-static inline bool over_bground_thresh(void)
+static inline bool over_bground_thresh(struct mem_cgroup *mem_cgroup)
 {
 	unsigned long background_thresh, dirty_thresh;
 
+	if (mem_cgroup) {
+		struct dirty_info info;
+
+		if (!mem_cgroup_hierarchical_dirty_info(
+			    determine_dirtyable_memory(), false,
+			    mem_cgroup, &info))
+			return false;
+
+		return info.nr_file_dirty +
+			info.nr_unstable_nfs > info.background_thresh;
+	}
+
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 
 	return (global_page_state(NR_FILE_DIRTY) +
@@ -683,7 +694,8 @@ static long wb_writeback(struct bdi_writ
 		 * For background writeout, stop when we are below the
 		 * background dirty threshold
 		 */
-		if (work->for_background && !over_bground_thresh())
+		if (work->for_background &&
+		    !over_bground_thresh(work->mem_cgroup))
 			break;
 
 		wbc.more_io = 0;
@@ -761,23 +773,6 @@ static unsigned long get_nr_dirty_pages(
 		get_nr_dirty_inodes();
 }
 
-static long wb_check_background_flush(struct bdi_writeback *wb)
-{
-	if (over_bground_thresh()) {
-
-		struct wb_writeback_work work = {
-			.nr_pages	= LONG_MAX,
-			.sync_mode	= WB_SYNC_NONE,
-			.for_background	= 1,
-			.range_cyclic	= 1,
-		};
-
-		return wb_writeback(wb, &work);
-	}
-
-	return 0;
-}
-
 static long wb_check_old_data_flush(struct bdi_writeback *wb)
 {
 	unsigned long expired;
@@ -839,15 +834,17 @@ long wb_do_writeback(struct bdi_writebac
 		 */
 		if (work->done)
 			complete(work->done);
-		else
+		else {
+			if (work->mem_cgroup)
+				mem_cgroup_bg_writeback_done(work->mem_cgroup);
 			kfree(work);
+		}
 	}
 
 	/*
 	 * Check for periodic writeback, kupdated() style
 	 */
 	wrote += wb_check_old_data_flush(wb);
-	wrote += wb_check_background_flush(wb);
 	clear_bit(BDI_writeback_running, &wb->bdi->state);
 
 	return wrote;
@@ -934,7 +931,7 @@ void wakeup_flusher_threads(long nr_page
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		if (!bdi_has_dirty_io(bdi))
 			continue;
-		__bdi_start_writeback(bdi, nr_pages, false);
+		__bdi_start_writeback(bdi, nr_pages, false, false, NULL);
 	}
 	rcu_read_unlock();
 }
diff -puN include/linux/backing-dev.h~memcg-make-background-writeback-memcg-aware include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~memcg-make-background-writeback-memcg-aware
+++ a/include/linux/backing-dev.h
@@ -101,7 +101,8 @@ int bdi_register_dev(struct backing_dev_
 void bdi_unregister(struct backing_dev_info *bdi);
 int bdi_setup_and_register(struct backing_dev_info *, char *, unsigned int);
 void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages);
-void bdi_start_background_writeback(struct backing_dev_info *bdi);
+void bdi_start_background_writeback(struct backing_dev_info *bdi,
+				    struct mem_cgroup *mem_cgroup);
 int bdi_writeback_thread(void *data);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 void bdi_arm_supers_timer(void);
diff -puN mm/memcontrol.c~memcg-make-background-writeback-memcg-aware mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-background-writeback-memcg-aware
+++ a/mm/memcontrol.c
@@ -1489,7 +1489,7 @@ void mem_cgroup_balance_dirty_pages(stru
 			 * mem_cgroup_bg_writeback_done().
 			 */
 			css_get(&memcg->css);
-			bdi_start_background_writeback(bdi);
+			bdi_start_background_writeback(bdi, memcg);
 		}
 
 		/* continue walking up hierarchy enabled parents */
diff -puN mm/page-writeback.c~memcg-make-background-writeback-memcg-aware mm/page-writeback.c
--- a/mm/page-writeback.c~memcg-make-background-writeback-memcg-aware
+++ a/mm/page-writeback.c
@@ -597,7 +597,7 @@ static void balance_dirty_pages(struct a
 	 */
 	if ((laptop_mode && pages_written) ||
 	    (!laptop_mode && (nr_reclaimable > background_thresh)))
-		bdi_start_background_writeback(bdi);
+		bdi_start_background_writeback(bdi, NULL);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch

