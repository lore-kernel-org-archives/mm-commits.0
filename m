From: akpm@linux-foundation.org
Subject: + mm-oom-change-type-of-oom_score_adj-to-short.patch added to -mm tree
Date: Thu, 08 Nov 2012 12:19:38 -0800
Message-ID: <20121108201938.80B69100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40819 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab2KHUTk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 15:19:40 -0500
Received: by mail-vc0-f202.google.com with SMTP id fy27so374078vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 12:19:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, anton.vorontsov@linaro.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com


The patch titled
     Subject: mm, oom: change type of oom_score_adj to short
has been added to the -mm tree.  Its filename is
     mm-oom-change-type-of-oom_score_adj-to-short.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: change type of oom_score_adj to short

The maximum oom_score_adj is 1000 and the minimum oom_score_adj is -1000,
so this range can be represented by the signed short type with no
functional change.  The extra space this frees up in struct signal_struct
will be used for per-thread oom kill flags in the next patch.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/lowmemorykiller.c |   16 ++++++++--------
 fs/proc/base.c                            |   10 +++++-----
 include/linux/oom.h                       |    4 ++--
 include/linux/sched.h                     |    6 +++---
 include/trace/events/oom.h                |    4 ++--
 include/trace/events/task.h               |    8 ++++----
 mm/ksm.c                                  |    2 +-
 mm/oom_kill.c                             |   10 +++++-----
 mm/swapfile.c                             |    2 +-
 9 files changed, 31 insertions(+), 31 deletions(-)

diff -puN drivers/staging/android/lowmemorykiller.c~mm-oom-change-type-of-oom_score_adj-to-short drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~mm-oom-change-type-of-oom_score_adj-to-short
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -40,7 +40,7 @@
 #include <linux/notifier.h>
 
 static uint32_t lowmem_debug_level = 2;
-static int lowmem_adj[6] = {
+static short lowmem_adj[6] = {
 	0,
 	1,
 	6,
@@ -70,9 +70,9 @@ static int lowmem_shrink(struct shrinker
 	int rem = 0;
 	int tasksize;
 	int i;
-	int min_score_adj = OOM_SCORE_ADJ_MAX + 1;
+	short min_score_adj = OOM_SCORE_ADJ_MAX + 1;
 	int selected_tasksize = 0;
-	int selected_oom_score_adj;
+	short selected_oom_score_adj;
 	int array_size = ARRAY_SIZE(lowmem_adj);
 	int other_free = global_page_state(NR_FREE_PAGES);
 	int other_file = global_page_state(NR_FILE_PAGES) -
@@ -90,7 +90,7 @@ static int lowmem_shrink(struct shrinker
 		}
 	}
 	if (sc->nr_to_scan > 0)
-		lowmem_print(3, "lowmem_shrink %lu, %x, ofree %d %d, ma %d\n",
+		lowmem_print(3, "lowmem_shrink %lu, %x, ofree %d %d, ma %hd\n",
 				sc->nr_to_scan, sc->gfp_mask, other_free,
 				other_file, min_score_adj);
 	rem = global_page_state(NR_ACTIVE_ANON) +
@@ -107,7 +107,7 @@ static int lowmem_shrink(struct shrinker
 	rcu_read_lock();
 	for_each_process(tsk) {
 		struct task_struct *p;
-		int oom_score_adj;
+		short oom_score_adj;
 
 		if (tsk->flags & PF_KTHREAD)
 			continue;
@@ -141,11 +141,11 @@ static int lowmem_shrink(struct shrinker
 		selected = p;
 		selected_tasksize = tasksize;
 		selected_oom_score_adj = oom_score_adj;
-		lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
+		lowmem_print(2, "select %d (%s), adj %hd, size %d, to kill\n",
 			     p->pid, p->comm, oom_score_adj, tasksize);
 	}
 	if (selected) {
-		lowmem_print(1, "send sigkill to %d (%s), adj %d, size %d\n",
+		lowmem_print(1, "send sigkill to %d (%s), adj %hd, size %d\n",
 			     selected->pid, selected->comm,
 			     selected_oom_score_adj, selected_tasksize);
 		lowmem_deathpending_timeout = jiffies + HZ;
@@ -176,7 +176,7 @@ static void __exit lowmem_exit(void)
 }
 
 module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
-module_param_array_named(adj, lowmem_adj, int, &lowmem_adj_size,
+module_param_array_named(adj, lowmem_adj, short, &lowmem_adj_size,
 			 S_IRUGO | S_IWUSR);
 module_param_array_named(minfree, lowmem_minfree, uint, &lowmem_minfree_size,
 			 S_IRUGO | S_IWUSR);
diff -puN fs/proc/base.c~mm-oom-change-type-of-oom_score_adj-to-short fs/proc/base.c
--- a/fs/proc/base.c~mm-oom-change-type-of-oom_score_adj-to-short
+++ a/fs/proc/base.c
@@ -878,7 +878,7 @@ static ssize_t oom_score_adj_read(struct
 {
 	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 	char buffer[PROC_NUMBUF];
-	int oom_score_adj = OOM_SCORE_ADJ_MIN;
+	short oom_score_adj = OOM_SCORE_ADJ_MIN;
 	unsigned long flags;
 	size_t len;
 
@@ -889,7 +889,7 @@ static ssize_t oom_score_adj_read(struct
 		unlock_task_sighand(task, &flags);
 	}
 	put_task_struct(task);
-	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_score_adj);
+	len = snprintf(buffer, sizeof(buffer), "%hd\n", oom_score_adj);
 	return simple_read_from_buffer(buf, count, ppos, buffer, len);
 }
 
@@ -936,15 +936,15 @@ static ssize_t oom_score_adj_write(struc
 		goto err_task_lock;
 	}
 
-	if (oom_score_adj < task->signal->oom_score_adj_min &&
+	if ((short)oom_score_adj < task->signal->oom_score_adj_min &&
 			!capable(CAP_SYS_RESOURCE)) {
 		err = -EACCES;
 		goto err_sighand;
 	}
 
-	task->signal->oom_score_adj = oom_score_adj;
+	task->signal->oom_score_adj = (short)oom_score_adj;
 	if (has_capability_noaudit(current, CAP_SYS_RESOURCE))
-		task->signal->oom_score_adj_min = oom_score_adj;
+		task->signal->oom_score_adj_min = (short)oom_score_adj;
 	trace_oom_score_adj_update(task);
 
 err_sighand:
diff -puN include/linux/oom.h~mm-oom-change-type-of-oom_score_adj-to-short include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-change-type-of-oom_score_adj-to-short
+++ a/include/linux/oom.h
@@ -29,8 +29,8 @@ enum oom_scan_t {
 	OOM_SCAN_SELECT,	/* always select this thread first */
 };
 
-extern void compare_swap_oom_score_adj(int old_val, int new_val);
-extern int test_set_oom_score_adj(int new_val);
+extern void compare_swap_oom_score_adj(short old_val, short new_val);
+extern short test_set_oom_score_adj(short new_val);
 
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
diff -puN include/linux/sched.h~mm-oom-change-type-of-oom_score_adj-to-short include/linux/sched.h
--- a/include/linux/sched.h~mm-oom-change-type-of-oom_score_adj-to-short
+++ a/include/linux/sched.h
@@ -633,9 +633,9 @@ struct signal_struct {
 	struct rw_semaphore group_rwsem;
 #endif
 
-	int oom_score_adj;	/* OOM kill score adjustment */
-	int oom_score_adj_min;	/* OOM kill score adjustment minimum value.
-				 * Only settable by CAP_SYS_RESOURCE. */
+	short oom_score_adj;		/* OOM kill score adjustment */
+	short oom_score_adj_min;	/* OOM kill score adjustment min value.
+					 * Only settable by CAP_SYS_RESOURCE. */
 
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
diff -puN include/trace/events/oom.h~mm-oom-change-type-of-oom_score_adj-to-short include/trace/events/oom.h
--- a/include/trace/events/oom.h~mm-oom-change-type-of-oom_score_adj-to-short
+++ a/include/trace/events/oom.h
@@ -14,7 +14,7 @@ TRACE_EVENT(oom_score_adj_update,
 	TP_STRUCT__entry(
 		__field(	pid_t,	pid)
 		__array(	char,	comm,	TASK_COMM_LEN )
-		__field(	 int,	oom_score_adj)
+		__field(	short,	oom_score_adj)
 	),
 
 	TP_fast_assign(
@@ -23,7 +23,7 @@ TRACE_EVENT(oom_score_adj_update,
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
-	TP_printk("pid=%d comm=%s oom_score_adj=%d",
+	TP_printk("pid=%d comm=%s oom_score_adj=%hd",
 		__entry->pid, __entry->comm, __entry->oom_score_adj)
 );
 
diff -puN include/trace/events/task.h~mm-oom-change-type-of-oom_score_adj-to-short include/trace/events/task.h
--- a/include/trace/events/task.h~mm-oom-change-type-of-oom_score_adj-to-short
+++ a/include/trace/events/task.h
@@ -15,7 +15,7 @@ TRACE_EVENT(task_newtask,
 		__field(	pid_t,	pid)
 		__array(	char,	comm, TASK_COMM_LEN)
 		__field( unsigned long, clone_flags)
-		__field(	int,    oom_score_adj)
+		__field(	short,	oom_score_adj)
 	),
 
 	TP_fast_assign(
@@ -25,7 +25,7 @@ TRACE_EVENT(task_newtask,
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
-	TP_printk("pid=%d comm=%s clone_flags=%lx oom_score_adj=%d",
+	TP_printk("pid=%d comm=%s clone_flags=%lx oom_score_adj=%hd",
 		__entry->pid, __entry->comm,
 		__entry->clone_flags, __entry->oom_score_adj)
 );
@@ -40,7 +40,7 @@ TRACE_EVENT(task_rename,
 		__field(	pid_t,	pid)
 		__array(	char, oldcomm,  TASK_COMM_LEN)
 		__array(	char, newcomm,  TASK_COMM_LEN)
-		__field(	int, oom_score_adj)
+		__field(	short,	oom_score_adj)
 	),
 
 	TP_fast_assign(
@@ -50,7 +50,7 @@ TRACE_EVENT(task_rename,
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
-	TP_printk("pid=%d oldcomm=%s newcomm=%s oom_score_adj=%d",
+	TP_printk("pid=%d oldcomm=%s newcomm=%s oom_score_adj=%hd",
 		__entry->pid, __entry->oldcomm,
 		__entry->newcomm, __entry->oom_score_adj)
 );
diff -puN mm/ksm.c~mm-oom-change-type-of-oom_score_adj-to-short mm/ksm.c
--- a/mm/ksm.c~mm-oom-change-type-of-oom_score_adj-to-short
+++ a/mm/ksm.c
@@ -1919,7 +1919,7 @@ static ssize_t run_store(struct kobject 
 	if (ksm_run != flags) {
 		ksm_run = flags;
 		if (flags & KSM_RUN_UNMERGE) {
-			int oom_score_adj;
+			short oom_score_adj;
 
 			oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
 			err = unmerge_and_remove_all_rmap_items();
diff -puN mm/oom_kill.c~mm-oom-change-type-of-oom_score_adj-to-short mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-change-type-of-oom_score_adj-to-short
+++ a/mm/oom_kill.c
@@ -53,7 +53,7 @@ static DEFINE_SPINLOCK(zone_scan_lock);
  * @old_val.  Usually used to reinstate a previous value to prevent racing with
  * userspacing tuning the value in the interim.
  */
-void compare_swap_oom_score_adj(int old_val, int new_val)
+void compare_swap_oom_score_adj(short old_val, short new_val)
 {
 	struct sighand_struct *sighand = current->sighand;
 
@@ -72,7 +72,7 @@ void compare_swap_oom_score_adj(int old_
  * synchronization and returns the old value.  Usually used to temporarily
  * set a value, save the old value in the caller, and then reinstate it later.
  */
-int test_set_oom_score_adj(int new_val)
+short test_set_oom_score_adj(short new_val)
 {
 	struct sighand_struct *sighand = current->sighand;
 	int old_val;
@@ -193,7 +193,7 @@ unsigned long oom_badness(struct task_st
 	if (!p)
 		return 0;
 
-	adj = p->signal->oom_score_adj;
+	adj = (long)p->signal->oom_score_adj;
 	if (adj == OOM_SCORE_ADJ_MIN) {
 		task_unlock(p);
 		return 0;
@@ -399,7 +399,7 @@ static void dump_tasks(const struct mem_
 			continue;
 		}
 
-		pr_info("[%5d] %5d %5d %8lu %8lu %7lu %8lu         %5d %s\n",
+		pr_info("[%5d] %5d %5d %8lu %8lu %7lu %8lu         %5hd %s\n",
 			task->pid, from_kuid(&init_user_ns, task_uid(task)),
 			task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
 			task->mm->nr_ptes,
@@ -415,7 +415,7 @@ static void dump_header(struct task_stru
 {
 	task_lock(current);
 	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
-		"oom_score_adj=%d\n",
+		"oom_score_adj=%hd\n",
 		current->comm, gfp_mask, order,
 		current->signal->oom_score_adj);
 	cpuset_print_task_mems_allowed(current);
diff -puN mm/swapfile.c~mm-oom-change-type-of-oom_score_adj-to-short mm/swapfile.c
--- a/mm/swapfile.c~mm-oom-change-type-of-oom_score_adj-to-short
+++ a/mm/swapfile.c
@@ -1498,7 +1498,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	struct address_space *mapping;
 	struct inode *inode;
 	struct filename *pathname;
-	int oom_score_adj;
+	short oom_score_adj;
 	int i, type, prev;
 	int err;
 
_

Patches currently in -mm which might be from rientjes@google.com are

mm-bugfix-set-current-reclaim_state-to-null-while-returning-from-kswapd.patch
linux-next.patch
mm-fix-build-warning-for-uninitialized-value.patch
irq-tsk-comm-is-an-array.patch
irq-tsk-comm-is-an-array-fix.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-clean-up-__collapse_huge_page_isolate.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
mm-mempolicy-remove-duplicate-code.patch
memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0.patch
memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix.patch
mm-cleanup-register_node.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch

