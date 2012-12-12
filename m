From: akpm@linux-foundation.org
Subject: [merged] mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch removed from -mm tree
Date: Wed, 12 Dec 2012 12:01:00 -0800
Message-ID: <20121212200100.CC3C1820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:54755 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab2LLUBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:01:02 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so119969vcd.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:01:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, anton.vorontsov@linaro.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: fix race when specifying a thread as the oom origin
has been removed from the -mm tree.  Its filename was
     mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: fix race when specifying a thread as the oom origin

test_set_oom_score_adj() and compare_swap_oom_score_adj() are used to
specify that current should be killed first if an oom condition occurs in
between the two calls.

The usage is

	short oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
	...
	compare_swap_oom_score_adj(OOM_SCORE_ADJ_MAX, oom_score_adj);

to store the thread's oom_score_adj, temporarily change it to the maximum
score possible, and then restore the old value if it is still the same.

This happens to still be racy, however, if the user writes
OOM_SCORE_ADJ_MAX to /proc/pid/oom_score_adj in between the two calls. 
The compare_swap_oom_score_adj() will then incorrectly reset the old value
prior to the write of OOM_SCORE_ADJ_MAX.

To fix this, introduce a new oom_flags_t member in struct signal_struct
that will be used for per-thread oom killer flags.  KSM and swapoff can
now use a bit in this member to specify that threads should be killed
first in oom conditions without playing around with oom_score_adj.

This also allows the correct oom_score_adj to always be shown when reading
/proc/pid/oom_score.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h   |   19 +++++++++++++--
 include/linux/sched.h |    1 
 include/linux/types.h |    1 
 mm/ksm.c              |    7 +----
 mm/oom_kill.c         |   49 +++++-----------------------------------
 mm/swapfile.c         |    5 +---
 6 files changed, 30 insertions(+), 52 deletions(-)

diff -puN include/linux/oom.h~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin
+++ a/include/linux/oom.h
@@ -29,8 +29,23 @@ enum oom_scan_t {
 	OOM_SCAN_SELECT,	/* always select this thread first */
 };
 
-extern void compare_swap_oom_score_adj(short old_val, short new_val);
-extern short test_set_oom_score_adj(short new_val);
+/* Thread is the potential origin of an oom condition; kill first on oom */
+#define OOM_FLAG_ORIGIN		((__force oom_flags_t)0x1)
+
+static inline void set_current_oom_origin(void)
+{
+	current->signal->oom_flags |= OOM_FLAG_ORIGIN;
+}
+
+static inline void clear_current_oom_origin(void)
+{
+	current->signal->oom_flags &= ~OOM_FLAG_ORIGIN;
+}
+
+static inline bool oom_task_origin(const struct task_struct *p)
+{
+	return !!(p->signal->oom_flags & OOM_FLAG_ORIGIN);
+}
 
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
diff -puN include/linux/sched.h~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin include/linux/sched.h
--- a/include/linux/sched.h~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin
+++ a/include/linux/sched.h
@@ -631,6 +631,7 @@ struct signal_struct {
 	struct rw_semaphore group_rwsem;
 #endif
 
+	oom_flags_t oom_flags;
 	short oom_score_adj;		/* OOM kill score adjustment */
 	short oom_score_adj_min;	/* OOM kill score adjustment min value.
 					 * Only settable by CAP_SYS_RESOURCE. */
diff -puN include/linux/types.h~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin include/linux/types.h
--- a/include/linux/types.h~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin
+++ a/include/linux/types.h
@@ -156,6 +156,7 @@ typedef u32 dma_addr_t;
 #endif
 typedef unsigned __bitwise__ gfp_t;
 typedef unsigned __bitwise__ fmode_t;
+typedef unsigned __bitwise__ oom_flags_t;
 
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
 typedef u64 phys_addr_t;
diff -puN mm/ksm.c~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin mm/ksm.c
--- a/mm/ksm.c~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin
+++ a/mm/ksm.c
@@ -1919,12 +1919,9 @@ static ssize_t run_store(struct kobject 
 	if (ksm_run != flags) {
 		ksm_run = flags;
 		if (flags & KSM_RUN_UNMERGE) {
-			short oom_score_adj;
-
-			oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
+			set_current_oom_origin();
 			err = unmerge_and_remove_all_rmap_items();
-			compare_swap_oom_score_adj(OOM_SCORE_ADJ_MAX,
-								oom_score_adj);
+			clear_current_oom_origin();
 			if (err) {
 				ksm_run = KSM_RUN_STOP;
 				count = err;
diff -puN mm/oom_kill.c~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin
+++ a/mm/oom_kill.c
@@ -44,48 +44,6 @@ int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks = 1;
 static DEFINE_SPINLOCK(zone_scan_lock);
 
-/*
- * compare_swap_oom_score_adj() - compare and swap current's oom_score_adj
- * @old_val: old oom_score_adj for compare
- * @new_val: new oom_score_adj for swap
- *
- * Sets the oom_score_adj value for current to @new_val iff its present value is
- * @old_val.  Usually used to reinstate a previous value to prevent racing with
- * userspacing tuning the value in the interim.
- */
-void compare_swap_oom_score_adj(short old_val, short new_val)
-{
-	struct sighand_struct *sighand = current->sighand;
-
-	spin_lock_irq(&sighand->siglock);
-	if (current->signal->oom_score_adj == old_val)
-		current->signal->oom_score_adj = new_val;
-	trace_oom_score_adj_update(current);
-	spin_unlock_irq(&sighand->siglock);
-}
-
-/**
- * test_set_oom_score_adj() - set current's oom_score_adj and return old value
- * @new_val: new oom_score_adj value
- *
- * Sets the oom_score_adj value for current to @new_val with proper
- * synchronization and returns the old value.  Usually used to temporarily
- * set a value, save the old value in the caller, and then reinstate it later.
- */
-short test_set_oom_score_adj(short new_val)
-{
-	struct sighand_struct *sighand = current->sighand;
-	int old_val;
-
-	spin_lock_irq(&sighand->siglock);
-	old_val = current->signal->oom_score_adj;
-	current->signal->oom_score_adj = new_val;
-	trace_oom_score_adj_update(current);
-	spin_unlock_irq(&sighand->siglock);
-
-	return old_val;
-}
-
 #ifdef CONFIG_NUMA
 /**
  * has_intersects_mems_allowed() - check task eligiblity for kill
@@ -310,6 +268,13 @@ enum oom_scan_t oom_scan_process_thread(
 	if (!task->mm)
 		return OOM_SCAN_CONTINUE;
 
+	/*
+	 * If task is allocating a lot of memory and has been marked to be
+	 * killed first if it triggers an oom, then select it.
+	 */
+	if (oom_task_origin(task))
+		return OOM_SCAN_SELECT;
+
 	if (task->flags & PF_EXITING && !force_kill) {
 		/*
 		 * If this task is not being ptraced on exit, then wait for it
diff -puN mm/swapfile.c~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin mm/swapfile.c
--- a/mm/swapfile.c~mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin
+++ a/mm/swapfile.c
@@ -1498,7 +1498,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	struct address_space *mapping;
 	struct inode *inode;
 	struct filename *pathname;
-	short oom_score_adj;
 	int i, type, prev;
 	int err;
 
@@ -1557,9 +1556,9 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->flags &= ~SWP_WRITEOK;
 	spin_unlock(&swap_lock);
 
-	oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
+	set_current_oom_origin();
 	err = try_to_unuse(type, false, 0); /* force all pages to be unused */
-	compare_swap_oom_score_adj(OOM_SCORE_ADJ_MAX, oom_score_adj);
+	clear_current_oom_origin();
 
 	if (err) {
 		/* re-insert swap space back into swap_list */
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
hotplug-update-nodemasks-management-fix.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-fix.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-oom-cleanup-pagefault-oom-handler.patch
mm-oom-remove-redundant-sleep-in-pagefault-oom-handler.patch
mm-oom-remove-statically-defined-arch-functions-of-same-name.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
memcg-do-not-check-for-mm-in-mem_cgroup_count_vm_event-disabled.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
irq-tsk-comm-is-an-array.patch
mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

