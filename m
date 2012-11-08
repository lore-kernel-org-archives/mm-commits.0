From: akpm@linux-foundation.org
Subject: + mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch added to -mm tree
Date: Thu, 08 Nov 2012 12:19:42 -0800
Message-ID: <20121108201942.F2C29200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48098 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2KHUTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 15:19:46 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so206190fae.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 12:19:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, anton.vorontsov@linaro.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com


The patch titled
     Subject: mm, oom: fix race when specifying a thread as the oom origin
has been added to the -mm tree.  Its filename is
     mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch

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
@@ -633,6 +633,7 @@ struct signal_struct {
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
 
@@ -1558,9 +1557,9 @@ SYSCALL_DEFINE1(swapoff, const char __us
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

