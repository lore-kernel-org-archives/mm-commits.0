From: akpm@linux-foundation.org
Subject: + oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
 added to -mm tree
Date: Mon, 12 Jan 2015 16:00:01 -0800
Message-ID: <54b46001.rLAFbEb/Q/pyfGql%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbAMAAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 19:00:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom, PM: make OOM detection in the freezer path raceless
has been added to the -mm tree.  Its filename is
     oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: oom, PM: make OOM detection in the freezer path raceless

5695be142e20 ("OOM, PM: OOM killed task shouldn't escape PM suspend") has
left a race window when OOM killer manages to note_oom_kill after
freeze_processes checks the counter.  The race window is quite small and
really unlikely and partial solution deemed sufficient at the time of
submission.

Tejun wasn't happy about this partial solution though and insisted on a
full solution.  That requires the full OOM and freezer's task freezing
exclusion, though.  This is done by this patch which introduces oom_sem RW
lock and turns oom_killer_disable() into a full OOM barrier.

oom_killer_disabled check is moved from the allocation path to the OOM
level and we take oom_sem for reading for both the check and the whole OOM
invocation.

oom_killer_disable() takes oom_sem for writing so it waits for all
currently running OOM killer invocations.  Then it disable all the further
OOMs by setting oom_killer_disabled and checks for any oom victims. 
Victims are counted via mark_tsk_oom_victim resp.  unmark_oom_victim.  The
last victim wakes up all waiters enqueued by oom_killer_disable(). 
Therefore this function acts as the full OOM barrier.

The page fault path is covered now as well although it was assumed to be
safe before.  As per Tejun, "We used to have freezing points deep in file
system code which may be reacheable from page fault." so it would be
better and more robust to not rely on freezing points here.  Same applies
to the memcg OOM killer.

out_of_memory tells the caller whether the OOM was allowed to trigger and
the callers are supposed to handle the situation.  The page allocation
path simply fails the allocation same as before.  The page fault path will
retry the fault (more on that later) and Sysrq OOM trigger will simply
complain to the log.

Normally there wouldn't be any unfrozen user tasks after
try_to_freeze_tasks so the function will not block. But if there was an
OOM killer racing with try_to_freeze_tasks and the OOM victim didn't
finish yet then we have to wait for it. This should complete in a finite
time, though, because

	- the victim cannot loop in the page fault handler (it would die
	  on the way out from the exception)
	- it cannot loop in the page allocator because all the further
	  allocation would fail and __GFP_NOFAIL allocations are not
	  acceptable at this stage
	- it shouldn't be blocked on any locks held by frozen tasks
	  (try_to_freeze expects lockless context) and kernel threads and
	  work queues are not frozen yet

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Suggested-by: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c    |    5 -
 include/linux/oom.h    |   14 ----
 kernel/exit.c          |    3 
 kernel/power/process.c |   50 ++------------
 mm/memcontrol.c        |    2 
 mm/oom_kill.c          |  132 +++++++++++++++++++++++++++++++++------
 mm/page_alloc.c        |   17 -----
 7 files changed, 132 insertions(+), 91 deletions(-)

diff -puN drivers/tty/sysrq.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless
+++ a/drivers/tty/sysrq.c
@@ -355,8 +355,9 @@ static struct sysrq_key_op sysrq_term_op
 
 static void moom_callback(struct work_struct *ignored)
 {
-	out_of_memory(node_zonelist(first_memory_node, GFP_KERNEL), GFP_KERNEL,
-		      0, NULL, true);
+	if (!out_of_memory(node_zonelist(first_memory_node, GFP_KERNEL),
+			   GFP_KERNEL, 0, NULL, true))
+		pr_info("OOM request ignored because killer is disabled\n");
 }
 
 static DECLARE_WORK(moom_work, moom_callback);
diff -puN include/linux/oom.h~oom-pm-make-oom-detection-in-the-freezer-path-raceless include/linux/oom.h
--- a/include/linux/oom.h~oom-pm-make-oom-detection-in-the-freezer-path-raceless
+++ a/include/linux/oom.h
@@ -72,22 +72,14 @@ extern enum oom_scan_t oom_scan_process_
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill);
 
-extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+extern bool out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *mask, bool force_kill);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
 extern bool oom_killer_disabled;
-
-static inline void oom_killer_disable(void)
-{
-	oom_killer_disabled = true;
-}
-
-static inline void oom_killer_enable(void)
-{
-	oom_killer_disabled = false;
-}
+extern bool oom_killer_disable(void);
+extern void oom_killer_enable(void);
 
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
diff -puN kernel/exit.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless kernel/exit.c
--- a/kernel/exit.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless
+++ a/kernel/exit.c
@@ -435,7 +435,8 @@ static void exit_mm(struct task_struct *
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
-	unmark_oom_victim();
+	if (test_thread_flag(TIF_MEMDIE))
+		unmark_oom_victim();
 }
 
 static struct task_struct *find_alive_thread(struct task_struct *p)
diff -puN kernel/power/process.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless kernel/power/process.c
--- a/kernel/power/process.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless
+++ a/kernel/power/process.c
@@ -108,30 +108,6 @@ static int try_to_freeze_tasks(bool user
 	return todo ? -EBUSY : 0;
 }
 
-static bool __check_frozen_processes(void)
-{
-	struct task_struct *g, *p;
-
-	for_each_process_thread(g, p)
-		if (p != current && !freezer_should_skip(p) && !frozen(p))
-			return false;
-
-	return true;
-}
-
-/*
- * Returns true if all freezable tasks (except for current) are frozen already
- */
-static bool check_frozen_processes(void)
-{
-	bool ret;
-
-	read_lock(&tasklist_lock);
-	ret = __check_frozen_processes();
-	read_unlock(&tasklist_lock);
-	return ret;
-}
-
 /**
  * freeze_processes - Signal user space processes to enter the refrigerator.
  * The current thread will not be frozen.  The same process that calls
@@ -142,7 +118,6 @@ static bool check_frozen_processes(void)
 int freeze_processes(void)
 {
 	int error;
-	int oom_kills_saved;
 
 	error = __usermodehelper_disable(UMH_FREEZING);
 	if (error)
@@ -157,29 +132,22 @@ int freeze_processes(void)
 	pm_wakeup_clear();
 	pr_info("Freezing user space processes ... ");
 	pm_freezing = true;
-	oom_kills_saved = oom_kills_count();
 	error = try_to_freeze_tasks(true);
 	if (!error) {
 		__usermodehelper_set_disable_depth(UMH_DISABLED);
-		oom_killer_disable();
-
-		/*
-		 * There might have been an OOM kill while we were
-		 * freezing tasks and the killed task might be still
-		 * on the way out so we have to double check for race.
-		 */
-		if (oom_kills_count() != oom_kills_saved &&
-		    !check_frozen_processes()) {
-			__usermodehelper_set_disable_depth(UMH_ENABLED);
-			pr_cont("OOM in progress.");
-			error = -EBUSY;
-		} else {
-			pr_cont("done.");
-		}
+		pr_cont("done.");
 	}
 	pr_cont("\n");
 	BUG_ON(in_atomic());
 
+	/*
+	 * Now that the whole userspace is frozen we need to disbale
+	 * the OOM killer to disallow any further interference with
+	 * killable tasks.
+	 */
+	if (!error && !oom_killer_disable())
+		error = -EBUSY;
+
 	if (error)
 		thaw_processes();
 	return error;
diff -puN mm/memcontrol.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless mm/memcontrol.c
--- a/mm/memcontrol.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless
+++ a/mm/memcontrol.c
@@ -1955,7 +1955,7 @@ bool mem_cgroup_oom_synchronize(bool han
 	if (!memcg)
 		return false;
 
-	if (!handle)
+	if (!handle || oom_killer_disabled)
 		goto cleanup;
 
 	owait.memcg = memcg;
diff -puN mm/oom_kill.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless mm/oom_kill.c
--- a/mm/oom_kill.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless
+++ a/mm/oom_kill.c
@@ -398,30 +398,27 @@ static void dump_header(struct task_stru
 }
 
 /*
- * Number of OOM killer invocations (including memcg OOM killer).
- * Primarily used by PM freezer to check for potential races with
- * OOM killed frozen task.
+ * Number of OOM victims in flight
  */
-static atomic_t oom_kills = ATOMIC_INIT(0);
+static atomic_t oom_victims = ATOMIC_INIT(0);
+static DECLARE_WAIT_QUEUE_HEAD(oom_victims_wait);
 
-int oom_kills_count(void)
-{
-	return atomic_read(&oom_kills);
-}
-
-void note_oom_kill(void)
-{
-	atomic_inc(&oom_kills);
-}
+bool oom_killer_disabled __read_mostly;
+static DECLARE_RWSEM(oom_sem);
 
 /**
  * mark_tsk_oom_victim - marks the given taks as OOM victim.
  * @tsk: task to mark
+ *
+ * Has to be called with oom_sem taken for read and never after
+ * oom has been disabled already.
  */
 void mark_tsk_oom_victim(struct task_struct *tsk)
 {
-	set_tsk_thread_flag(tsk, TIF_MEMDIE);
-
+	WARN_ON(oom_killer_disabled);
+	/* OOM killer might race with memcg OOM */
+	if (test_and_set_tsk_thread_flag(tsk, TIF_MEMDIE))
+		return;
 	/*
 	 * Make sure that the task is woken up from uninterruptible sleep
 	 * if it is frozen because OOM killer wouldn't be able to free
@@ -429,14 +426,70 @@ void mark_tsk_oom_victim(struct task_str
 	 * that TIF_MEMDIE tasks should be ignored.
 	 */
 	__thaw_task(tsk);
+	atomic_inc(&oom_victims);
 }
 
 /**
  * unmark_oom_victim - unmarks the current task as OOM victim.
+ *
+ * Wakes up all waiters in oom_killer_disable()
  */
 void unmark_oom_victim(void)
 {
-	clear_thread_flag(TIF_MEMDIE);
+	if (!test_and_clear_thread_flag(TIF_MEMDIE))
+		return;
+
+	down_read(&oom_sem);
+	/*
+	 * There is no need to signal the lasst oom_victim if there
+	 * is nobody who cares.
+	 */
+	if (!atomic_dec_return(&oom_victims) && oom_killer_disabled)
+		wake_up_all(&oom_victims_wait);
+	up_read(&oom_sem);
+}
+
+/**
+ * oom_killer_disable - disable OOM killer
+ *
+ * Forces all page allocations to fail rather than trigger OOM killer.
+ * Will block and wait until all OOM victims are killed.
+ *
+ * The function cannot be called when there are runnable user tasks because
+ * the userspace would see unexpected allocation failures as a result. Any
+ * new usage of this function should be consulted with MM people.
+ *
+ * Returns true if successful and false if the OOM killer cannot be
+ * disabled.
+ */
+bool oom_killer_disable(void)
+{
+	/*
+	 * Make sure to not race with an ongoing OOM killer
+	 * and that the current is not the victim.
+	 */
+	down_write(&oom_sem);
+	if (test_thread_flag(TIF_MEMDIE)) {
+		up_write(&oom_sem);
+		return false;
+	}
+
+	oom_killer_disabled = true;
+	up_write(&oom_sem);
+
+	wait_event(oom_victims_wait, !atomic_read(&oom_victims));
+
+	return true;
+}
+
+/**
+ * oom_killer_enable - enable OOM killer
+ */
+void oom_killer_enable(void)
+{
+	down_write(&oom_sem);
+	oom_killer_disabled = false;
+	up_write(&oom_sem);
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
@@ -637,7 +690,7 @@ void oom_zonelist_unlock(struct zonelist
 }
 
 /**
- * out_of_memory - kill the "best" process when we run out of memory
+ * __out_of_memory - kill the "best" process when we run out of memory
  * @zonelist: zonelist pointer
  * @gfp_mask: memory allocation flags
  * @order: amount of memory being requested as a power of 2
@@ -649,7 +702,7 @@ void oom_zonelist_unlock(struct zonelist
  * OR try to be smart about which process to kill. Note that we
  * don't have to be perfect here, we just have to be good.
  */
-void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+static void __out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *nodemask, bool force_kill)
 {
 	const nodemask_t *mpol_mask;
@@ -718,6 +771,32 @@ out:
 		schedule_timeout_killable(1);
 }
 
+/**
+ * out_of_memory -  tries to invoke OOM killer.
+ * @zonelist: zonelist pointer
+ * @gfp_mask: memory allocation flags
+ * @order: amount of memory being requested as a power of 2
+ * @nodemask: nodemask passed to page allocator
+ * @force_kill: true if a task must be killed, even if others are exiting
+ *
+ * invokes __out_of_memory if the OOM is not disabled by oom_killer_disable()
+ * when it returns false. Otherwise returns true.
+ */
+bool out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+		int order, nodemask_t *nodemask, bool force_kill)
+{
+	bool ret = false;
+
+	down_read(&oom_sem);
+	if (!oom_killer_disabled) {
+		__out_of_memory(zonelist, gfp_mask, order, nodemask, force_kill);
+		ret = true;
+	}
+	up_read(&oom_sem);
+
+	return ret;
+}
+
 /*
  * The pagefault handler calls here because it is out of memory, so kill a
  * memory-hogging task.  If any populated zone has ZONE_OOM_LOCKED set, a
@@ -727,12 +806,25 @@ void pagefault_out_of_memory(void)
 {
 	struct zonelist *zonelist;
 
+	down_read(&oom_sem);
 	if (mem_cgroup_oom_synchronize(true))
-		return;
+		goto unlock;
 
 	zonelist = node_zonelist(first_memory_node, GFP_KERNEL);
 	if (oom_zonelist_trylock(zonelist, GFP_KERNEL)) {
-		out_of_memory(NULL, 0, 0, NULL, false);
+		if (!oom_killer_disabled)
+			__out_of_memory(NULL, 0, 0, NULL, false);
+		else
+			/*
+			 * There shouldn't be any user tasks runable while the
+			 * OOM killer is disabled so the current task has to
+			 * be a racing OOM victim for which oom_killer_disable()
+			 * is waiting for.
+			 */
+			WARN_ON(test_thread_flag(TIF_MEMDIE));
+
 		oom_zonelist_unlock(zonelist, GFP_KERNEL);
 	}
+unlock:
+	up_read(&oom_sem);
 }
diff -puN mm/page_alloc.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless mm/page_alloc.c
--- a/mm/page_alloc.c~oom-pm-make-oom-detection-in-the-freezer-path-raceless
+++ a/mm/page_alloc.c
@@ -244,8 +244,6 @@ void set_pageblock_migratetype(struct pa
 					PB_migrate, PB_migrate_end);
 }
 
-bool oom_killer_disabled __read_mostly;
-
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
@@ -2317,9 +2315,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 
 	*did_some_progress = 0;
 
-	if (oom_killer_disabled)
-		return NULL;
-
 	/*
 	 * Acquire the per-zone oom lock for each zone.  If that
 	 * fails, somebody else is making progress for us.
@@ -2331,14 +2326,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	}
 
 	/*
-	 * PM-freezer should be notified that there might be an OOM killer on
-	 * its way to kill and wake somebody up. This is too early and we might
-	 * end up not killing anything but false positives are acceptable.
-	 * See freeze_processes.
-	 */
-	note_oom_kill();
-
-	/*
 	 * Go through the zonelist yet one more time, keep very high watermark
 	 * here, this is only to catch a parallel oom killing, we must fail if
 	 * we're still under heavy pressure.
@@ -2372,8 +2359,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 			goto out;
 	}
 	/* Exhausted what can be done so it's blamo time */
-	out_of_memory(ac->zonelist, gfp_mask, order, ac->nodemask, false);
-	*did_some_progress = 1;
+	if (out_of_memory(ac->zonelist, gfp_mask, order, nodemask, false))
+		*did_some_progress = 1;
 out:
 	oom_zonelist_unlock(ac->zonelist, gfp_mask);
 	return page;
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
vmscan-per-memory-cgroup-slab-shrinkers-fix.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

