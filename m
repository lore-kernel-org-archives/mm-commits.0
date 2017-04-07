From: akpm@linux-foundation.org
Subject: [patch 10/10] mm: move pcp and lru-pcp draining into single wq
Date: Fri, 07 Apr 2017 16:05:05 -0700
Message-ID: <58e81b21.2z+qJJNHpeBeLnOP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755135AbdDGXFH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2017 19:05:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hughd@google.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, pku.leo@gmail.com, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm: move pcp and lru-pcp draining into single wq

We currently have 2 specific WQ_RECLAIM workqueues in the mm code. 
vmstat_wq for updating pcp stats and lru_add_drain_wq dedicated to drain
per cpu lru caches.  This seems more than necessary because both can run
on a single WQ.  Both do not block on locks requiring a memory allocation
nor perform any allocations themselves.  We will save one rescuer thread
this way.

On the other hand drain_all_pages() queues work on the system wq which
doesn't have rescuer and so this depend on memory allocation (when all
workers are stuck allocating and new ones cannot be created).  Initially
we thought this would be more of a theoretical problem but Hugh Dickins
has reported:

: 4.11-rc has been giving me hangs after hours of swapping load.  At
: first they looked like memory leaks ("fork: Cannot allocate memory");
: but for no good reason I happened to do "cat /proc/sys/vm/stat_refresh"
: before looking at /proc/meminfo one time, and the stat_refresh stuck
: in D state, waiting for completion of flush_work like many kworkers.
: kthreadd waiting for completion of flush_work in drain_all_pages().

This worker should be using WQ_RECLAIM as well in order to guarantee a
forward progress.  We can reuse the same one as for lru draining and
vmstat.

Link: http://lkml.kernel.org/r/20170307131751.24936-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Tested-by: Yang Li <pku.leo@gmail.com>
Tested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    7 +++++++
 mm/page_alloc.c |    9 ++++++++-
 mm/swap.c       |   27 ++++++++-------------------
 mm/vmstat.c     |   15 +++++++++------
 4 files changed, 32 insertions(+), 26 deletions(-)

diff -puN mm/internal.h~mm-move-pcp-and-lru-pcp-drainging-into-single-wq mm/internal.h
--- a/mm/internal.h~mm-move-pcp-and-lru-pcp-drainging-into-single-wq
+++ a/mm/internal.h
@@ -481,6 +481,13 @@ unsigned long reclaim_clean_pages_from_l
 enum ttu_flags;
 struct tlbflush_unmap_batch;
 
+
+/*
+ * only for MM internal work items which do not depend on
+ * any allocations or locks which might depend on allocations
+ */
+extern struct workqueue_struct *mm_percpu_wq;
+
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 void try_to_unmap_flush(void);
 void try_to_unmap_flush_dirty(void);
diff -puN mm/page_alloc.c~mm-move-pcp-and-lru-pcp-drainging-into-single-wq mm/page_alloc.c
--- a/mm/page_alloc.c~mm-move-pcp-and-lru-pcp-drainging-into-single-wq
+++ a/mm/page_alloc.c
@@ -2373,6 +2373,13 @@ void drain_all_pages(struct zone *zone)
 	 */
 	static cpumask_t cpus_with_pcps;
 
+	/*
+	 * Make sure nobody triggers this path before mm_percpu_wq is fully
+	 * initialized.
+	 */
+	if (WARN_ON_ONCE(!mm_percpu_wq))
+		return;
+
 	/* Workqueues cannot recurse */
 	if (current->flags & PF_WQ_WORKER)
 		return;
@@ -2422,7 +2429,7 @@ void drain_all_pages(struct zone *zone)
 	for_each_cpu(cpu, &cpus_with_pcps) {
 		struct work_struct *work = per_cpu_ptr(&pcpu_drain, cpu);
 		INIT_WORK(work, drain_local_pages_wq);
-		schedule_work_on(cpu, work);
+		queue_work_on(cpu, mm_percpu_wq, work);
 	}
 	for_each_cpu(cpu, &cpus_with_pcps)
 		flush_work(per_cpu_ptr(&pcpu_drain, cpu));
diff -puN mm/swap.c~mm-move-pcp-and-lru-pcp-drainging-into-single-wq mm/swap.c
--- a/mm/swap.c~mm-move-pcp-and-lru-pcp-drainging-into-single-wq
+++ a/mm/swap.c
@@ -670,30 +670,19 @@ static void lru_add_drain_per_cpu(struct
 
 static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
 
-/*
- * lru_add_drain_wq is used to do lru_add_drain_all() from a WQ_MEM_RECLAIM
- * workqueue, aiding in getting memory freed.
- */
-static struct workqueue_struct *lru_add_drain_wq;
-
-static int __init lru_init(void)
-{
-	lru_add_drain_wq = alloc_workqueue("lru-add-drain", WQ_MEM_RECLAIM, 0);
-
-	if (WARN(!lru_add_drain_wq,
-		"Failed to create workqueue lru_add_drain_wq"))
-		return -ENOMEM;
-
-	return 0;
-}
-early_initcall(lru_init);
-
 void lru_add_drain_all(void)
 {
 	static DEFINE_MUTEX(lock);
 	static struct cpumask has_work;
 	int cpu;
 
+	/*
+	 * Make sure nobody triggers this path before mm_percpu_wq is fully
+	 * initialized.
+	 */
+	if (WARN_ON(!mm_percpu_wq))
+		return;
+
 	mutex_lock(&lock);
 	get_online_cpus();
 	cpumask_clear(&has_work);
@@ -707,7 +696,7 @@ void lru_add_drain_all(void)
 		    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
 		    need_activate_page_drain(cpu)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
-			queue_work_on(cpu, lru_add_drain_wq, work);
+			queue_work_on(cpu, mm_percpu_wq, work);
 			cpumask_set_cpu(cpu, &has_work);
 		}
 	}
diff -puN mm/vmstat.c~mm-move-pcp-and-lru-pcp-drainging-into-single-wq mm/vmstat.c
--- a/mm/vmstat.c~mm-move-pcp-and-lru-pcp-drainging-into-single-wq
+++ a/mm/vmstat.c
@@ -1552,7 +1552,6 @@ static const struct file_operations proc
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SMP
-static struct workqueue_struct *vmstat_wq;
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
 
@@ -1623,7 +1622,7 @@ static void vmstat_update(struct work_st
 		 * to occur in the future. Keep on running the
 		 * update worker thread.
 		 */
-		queue_delayed_work_on(smp_processor_id(), vmstat_wq,
+		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
 				this_cpu_ptr(&vmstat_work),
 				round_jiffies_relative(sysctl_stat_interval));
 	}
@@ -1702,7 +1701,7 @@ static void vmstat_shepherd(struct work_
 		struct delayed_work *dw = &per_cpu(vmstat_work, cpu);
 
 		if (!delayed_work_pending(dw) && need_update(cpu))
-			queue_delayed_work_on(cpu, vmstat_wq, dw, 0);
+			queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
 	}
 	put_online_cpus();
 
@@ -1718,7 +1717,6 @@ static void __init start_shepherd_timer(
 		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
 			vmstat_update);
 
-	vmstat_wq = alloc_workqueue("vmstat", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
 	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
 }
@@ -1764,11 +1762,16 @@ static int vmstat_cpu_dead(unsigned int
 
 #endif
 
+struct workqueue_struct *mm_percpu_wq;
+
 void __init init_mm_internals(void)
 {
-#ifdef CONFIG_SMP
-	int ret;
+	int ret __maybe_unused;
 
+	mm_percpu_wq = alloc_workqueue("mm_percpu_wq",
+				       WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
+
+#ifdef CONFIG_SMP
 	ret = cpuhp_setup_state_nocalls(CPUHP_MM_VMSTAT_DEAD, "mm/vmstat:dead",
 					NULL, vmstat_cpu_dead);
 	if (ret < 0)
_
