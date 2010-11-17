From: akpm@linux-foundation.org
Subject: + writeback-per-task-rate-limit-on-balance_dirty_pages.patch added to -mm tree
Date: Wed, 17 Nov 2010 15:03:08 -0800
Message-ID: <201011172303.oAHN38lZ010586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935678Ab0KQXEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Nov 2010 18:04:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mrubin@google.com, richard@rsk.demon.co.uk, riel@redhat.com, shaohua.li@intel.com, tytso@mit.edu


The patch titled
     writeback: per-task rate limit on balance_dirty_pages()
has been added to the -mm tree.  Its filename is
     writeback-per-task-rate-limit-on-balance_dirty_pages.patch

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
Subject: writeback: per-task rate limit on balance_dirty_pages()
From: Wu Fengguang <fengguang.wu@intel.com>

Try to limit the dirty throttle pause time in range [1 jiffy, 100 ms], by
controlling how many pages can be dirtied before inserting a pause.

The dirty count will be directly billed to the task struct.  Slow start
and quick back off is employed, so that the stable range will be biased
towards less than 50ms.  Another intention is for fine timing control of
slow devices, which may need to do full 100ms pauses for every 1 page.

The switch from per-cpu to per-task rate limit makes it easier to exceed
the global dirty limit with a fork bomb, where each new task dirties 1
page, sleep 10m and continue to dirty 1000 more pages.  The caveat is,
when it dirties the first page, it may be honoured a high nr_dirtied_pause
because nr_dirty is still low at that time.  In this way lots of tasks get
the free tickets to dirty more pages than allowed.  The solution is to
disable rate limiting (ie.  to ignore nr_dirtied_pause) totally once the
bdi becomes dirty exceeded.

Note that some filesystems will dirty a batch of pages before calling
balance_dirty_pages_ratelimited_nr().  They saves a little CPU overheads
at the cost of possibly overrunning the dirty limits a bit and/or in the
case of very slow devices, pause the application for much more than 100ms
at a time.  This is a tradeoff, and seems reasonable optimization as long
as the batch size is controlled within a dozen pages.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    7 ++
 mm/memory_hotplug.c   |    3 
 mm/page-writeback.c   |  126 ++++++++++++++++++----------------------
 3 files changed, 65 insertions(+), 71 deletions(-)

diff -puN include/linux/sched.h~writeback-per-task-rate-limit-on-balance_dirty_pages include/linux/sched.h
--- a/include/linux/sched.h~writeback-per-task-rate-limit-on-balance_dirty_pages
+++ a/include/linux/sched.h
@@ -1474,6 +1474,13 @@ struct task_struct {
 	int make_it_fail;
 #endif
 	struct prop_local_single dirties;
+	/*
+	 * when (nr_dirtied >= nr_dirtied_pause), it's time to call
+	 * balance_dirty_pages() for some dirty throttling pause
+	 */
+	int nr_dirtied;
+	int nr_dirtied_pause;
+
 #ifdef CONFIG_LATENCYTOP
 	int latency_record_count;
 	struct latency_record latency_record[LT_SAVECOUNT];
diff -puN mm/memory_hotplug.c~writeback-per-task-rate-limit-on-balance_dirty_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~writeback-per-task-rate-limit-on-balance_dirty_pages
+++ a/mm/memory_hotplug.c
@@ -446,8 +446,6 @@ int online_pages(unsigned long pfn, unsi
 
 	vm_total_pages = nr_free_pagecache_pages();
 
-	writeback_set_ratelimit();
-
 	if (onlined_pages)
 		memory_notify(MEM_ONLINE, &arg);
 
@@ -877,7 +875,6 @@ repeat:
 	}
 
 	vm_total_pages = nr_free_pagecache_pages();
-	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
 	unlock_system_sleep();
diff -puN mm/page-writeback.c~writeback-per-task-rate-limit-on-balance_dirty_pages mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-per-task-rate-limit-on-balance_dirty_pages
+++ a/mm/page-writeback.c
@@ -36,12 +36,6 @@
 #include <linux/pagevec.h>
 #include <trace/events/writeback.h>
 
-/*
- * After a CPU has dirtied this many pages, balance_dirty_pages_ratelimited
- * will look to see if it needs to force writeback or throttling.
- */
-static long ratelimit_pages = 32;
-
 /* The following parameters are exported via /proc/sys/vm */
 
 /*
@@ -452,6 +446,40 @@ unsigned long bdi_dirty_limit(struct bac
 }
 
 /*
+ * After a task dirtied this many pages, balance_dirty_pages_ratelimited_nr()
+ * will look to see if it needs to start dirty throttling.
+ *
+ * If ratelimit_pages is too low then big NUMA machines will call the expensive
+ * global_page_state() too often. So scale it adaptively to the safety margin
+ * (the number of pages we may dirty without exceeding the dirty limits).
+ */
+static unsigned long ratelimit_pages(struct backing_dev_info *bdi)
+{
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
+	unsigned long dirty_pages;
+
+	global_dirty_limits(&background_thresh, &dirty_thresh);
+	dirty_pages = global_page_state(NR_FILE_DIRTY) +
+		      global_page_state(NR_WRITEBACK) +
+		      global_page_state(NR_UNSTABLE_NFS);
+
+	if (dirty_pages <= (dirty_thresh + background_thresh) / 2)
+		goto out;
+
+	dirty_thresh = bdi_dirty_limit(bdi, dirty_thresh);
+	dirty_pages  = bdi_stat(bdi, BDI_RECLAIMABLE) +
+		       bdi_stat(bdi, BDI_WRITEBACK);
+
+	if (dirty_pages < dirty_thresh)
+		goto out;
+
+	return 1;
+out:
+	return 1 + int_sqrt(dirty_thresh - dirty_pages);
+}
+
+/*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
  * the caller to perform writeback if the system is over `vm_dirty_ratio'.
@@ -467,7 +495,7 @@ static void balance_dirty_pages(struct a
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
 	unsigned long bw;
-	unsigned long pause;
+	unsigned long pause = 0;
 	bool dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
@@ -549,6 +577,17 @@ pause:
 	if (!dirty_exceeded && bdi->dirty_exceeded)
 		bdi->dirty_exceeded = 0;
 
+	if (pause == 0 && nr_dirty < background_thresh)
+		current->nr_dirtied_pause = ratelimit_pages(bdi);
+	else if (pause == 1)
+		current->nr_dirtied_pause += current->nr_dirtied_pause >> 5;
+	else if (pause >= HZ/10)
+		/*
+		 * when repeated, writing 1 page per 100ms on slow devices,
+		 * i-(i+2)/4 will be able to reach 1 but never reduce to 0.
+		 */
+		current->nr_dirtied_pause -= (current->nr_dirtied_pause+2) >> 2;
+
 	if (writeback_in_progress(bdi))
 		return;
 
@@ -575,8 +614,6 @@ void set_page_dirty_balance(struct page 
 	}
 }
 
-static DEFINE_PER_CPU(unsigned long, bdp_ratelimits) = 0;
-
 /**
  * balance_dirty_pages_ratelimited_nr - balance dirty memory state
  * @mapping: address_space which was dirtied
@@ -586,36 +623,30 @@ static DEFINE_PER_CPU(unsigned long, bdp
  * which was newly dirtied.  The function will periodically check the system's
  * dirty state and will initiate writeback if needed.
  *
- * On really big machines, get_writeback_state is expensive, so try to avoid
+ * On really big machines, global_page_state() is expensive, so try to avoid
  * calling it too often (ratelimiting).  But once we're over the dirty memory
- * limit we decrease the ratelimiting by a lot, to prevent individual processes
- * from overshooting the limit by (ratelimit_pages) each.
+ * limit we disable the ratelimiting, to prevent individual processes from
+ * overshooting the limit by (ratelimit_pages) each.
  */
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 					unsigned long nr_pages_dirtied)
 {
-	unsigned long ratelimit;
-	unsigned long *p;
+	struct backing_dev_info *bdi = mapping->backing_dev_info;
+
+	current->nr_dirtied += nr_pages_dirtied;
 
-	ratelimit = ratelimit_pages;
-	if (mapping->backing_dev_info->dirty_exceeded)
-		ratelimit = 8;
+	if (unlikely(!current->nr_dirtied_pause))
+		current->nr_dirtied_pause = ratelimit_pages(bdi);
 
 	/*
 	 * Check the rate limiting. Also, we do not want to throttle real-time
 	 * tasks in balance_dirty_pages(). Period.
 	 */
-	preempt_disable();
-	p =  &__get_cpu_var(bdp_ratelimits);
-	*p += nr_pages_dirtied;
-	if (unlikely(*p >= ratelimit)) {
-		ratelimit = *p;
-		*p = 0;
-		preempt_enable();
-		balance_dirty_pages(mapping, ratelimit);
-		return;
+	if (unlikely(current->nr_dirtied >= current->nr_dirtied_pause ||
+		     bdi->dirty_exceeded)) {
+		balance_dirty_pages(mapping, current->nr_dirtied);
+		current->nr_dirtied = 0;
 	}
-	preempt_enable();
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 
@@ -703,44 +734,6 @@ void laptop_sync_completion(void)
 #endif
 
 /*
- * If ratelimit_pages is too high then we can get into dirty-data overload
- * if a large number of processes all perform writes at the same time.
- * If it is too low then SMP machines will call the (expensive)
- * get_writeback_state too often.
- *
- * Here we set ratelimit_pages to a level which ensures that when all CPUs are
- * dirtying in parallel, we cannot go more than 3% (1/32) over the dirty memory
- * thresholds before writeback cuts in.
- *
- * But the limit should not be set too high.  Because it also controls the
- * amount of memory which the balance_dirty_pages() caller has to write back.
- * If this is too large then the caller will block on the IO queue all the
- * time.  So limit it to four megabytes - the balance_dirty_pages() caller
- * will write six megabyte chunks, max.
- */
-
-void writeback_set_ratelimit(void)
-{
-	ratelimit_pages = vm_total_pages / (num_online_cpus() * 32);
-	if (ratelimit_pages < 16)
-		ratelimit_pages = 16;
-	if (ratelimit_pages * PAGE_CACHE_SIZE > 4096 * 1024)
-		ratelimit_pages = (4096 * 1024) / PAGE_CACHE_SIZE;
-}
-
-static int __cpuinit
-ratelimit_handler(struct notifier_block *self, unsigned long u, void *v)
-{
-	writeback_set_ratelimit();
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block __cpuinitdata ratelimit_nb = {
-	.notifier_call	= ratelimit_handler,
-	.next		= NULL,
-};
-
-/*
  * Called early on to tune the page writeback dirty limits.
  *
  * We used to scale dirty pages according to how total memory
@@ -762,9 +755,6 @@ void __init page_writeback_init(void)
 {
 	int shift;
 
-	writeback_set_ratelimit();
-	register_cpu_notifier(&ratelimit_nb);
-
 	shift = calc_period_shift();
 	prop_descriptor_init(&vm_completions, shift);
 	prop_descriptor_init(&vm_dirties, shift);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
writeback-integrated-background-writeback-work.patch
writeback-trace-wakeup-event-for-background-writeback.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works-update.patch
writeback-avoid-livelocking-wb_sync_all-writeback.patch
writeback-avoid-livelocking-wb_sync_all-writeback-update.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch
mm-find_get_pages_contig-fixlet.patch
mm-smaps-export-mlock-information.patch
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
memcg-make-throttle_vm_writeout-memcg-aware-fix.patch
memcg-simplify-mem_cgroup_page_stat.patch
memcg-simplify-mem_cgroup_dirty_info.patch
memcg-make-mem_cgroup_page_stat-return-value-unsigned.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

