From: akpm@linux-foundation.org
Subject: + mm-oom_kill-simplify-oom-killer-locking.patch added to -mm tree
Date: Wed, 20 May 2015 13:25:24 -0700
Message-ID: <555cedb4.brxsurhdRrge38HX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbbETUZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 May 2015 16:25:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, aarcange@redhat.com, david@fromorbit.com, mhocko@suse.cz, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom_kill: simplify OOM killer locking
has been added to the -mm tree.  Its filename is
     mm-oom_kill-simplify-oom-killer-locking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-simplify-oom-killer-locking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-simplify-oom-killer-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: oom_kill: simplify OOM killer locking

The zonelist locking and the oom_sem are two overlapping locks that are
used to serialize global OOM killing against different things.

The historical zonelist locking serializes OOM kills from allocations with
overlapping zonelists against each other to prevent killing more tasks
than necessary in the same memory domain.  Only when neither tasklists nor
zonelists from two concurrent OOM kills overlap (tasks in separate memcgs
bound to separate nodes) are OOM kills allowed to execute in parallel.

The younger oom_sem is a read-write lock to serialize OOM killing against
the PM code trying to disable the OOM killer altogether.

However, the OOM killer is a fairly cold error path, there is really no
reason to optimize for highly performant and concurrent OOM kills.  And
the oom_sem is just flat-out redundant.

Replace both locking schemes with a single global mutex serializing OOM
kills regardless of context.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    2 
 include/linux/oom.h |    5 -
 mm/memcontrol.c     |   18 +++--
 mm/oom_kill.c       |  127 ++++++++----------------------------------
 mm/page_alloc.c     |    8 +-
 5 files changed, 46 insertions(+), 114 deletions(-)

diff -puN drivers/tty/sysrq.c~mm-oom_kill-simplify-oom-killer-locking drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~mm-oom_kill-simplify-oom-killer-locking
+++ a/drivers/tty/sysrq.c
@@ -356,9 +356,11 @@ static struct sysrq_key_op sysrq_term_op
 
 static void moom_callback(struct work_struct *ignored)
 {
+	mutex_lock(&oom_lock);
 	if (!out_of_memory(node_zonelist(first_memory_node, GFP_KERNEL),
 			   GFP_KERNEL, 0, NULL, true))
 		pr_info("OOM request ignored because killer is disabled\n");
+	mutex_unlock(&oom_lock);
 }
 
 static DECLARE_WORK(moom_work, moom_callback);
diff -puN include/linux/oom.h~mm-oom_kill-simplify-oom-killer-locking include/linux/oom.h
--- a/include/linux/oom.h~mm-oom_kill-simplify-oom-killer-locking
+++ a/include/linux/oom.h
@@ -32,6 +32,8 @@ enum oom_scan_t {
 /* Thread is the potential origin of an oom condition; kill first on oom */
 #define OOM_FLAG_ORIGIN		((__force oom_flags_t)0x1)
 
+extern struct mutex oom_lock;
+
 static inline void set_current_oom_origin(void)
 {
 	current->signal->oom_flags |= OOM_FLAG_ORIGIN;
@@ -60,9 +62,6 @@ extern void oom_kill_process(struct task
 			     struct mem_cgroup *memcg, nodemask_t *nodemask,
 			     const char *message);
 
-extern bool oom_zonelist_trylock(struct zonelist *zonelist, gfp_t gfp_flags);
-extern void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_flags);
-
 extern void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
 			       int order, const nodemask_t *nodemask,
 			       struct mem_cgroup *memcg);
diff -puN mm/memcontrol.c~mm-oom_kill-simplify-oom-killer-locking mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom_kill-simplify-oom-killer-locking
+++ a/mm/memcontrol.c
@@ -1530,6 +1530,8 @@ static void mem_cgroup_out_of_memory(str
 	unsigned int points = 0;
 	struct task_struct *chosen = NULL;
 
+	mutex_lock(&oom_lock);
+
 	/*
 	 * If current has a pending SIGKILL or is exiting, then automatically
 	 * select it.  The goal is to allow it to allocate so that it may
@@ -1537,7 +1539,7 @@ static void mem_cgroup_out_of_memory(str
 	 */
 	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
 		mark_oom_victim(current);
-		return;
+		goto unlock;
 	}
 
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL, memcg);
@@ -1564,7 +1566,7 @@ static void mem_cgroup_out_of_memory(str
 				mem_cgroup_iter_break(memcg, iter);
 				if (chosen)
 					put_task_struct(chosen);
-				return;
+				goto unlock;
 			case OOM_SCAN_OK:
 				break;
 			};
@@ -1585,11 +1587,13 @@ static void mem_cgroup_out_of_memory(str
 		css_task_iter_end(&it);
 	}
 
-	if (!chosen)
-		return;
-	points = chosen_points * 1000 / totalpages;
-	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
-			 NULL, "Memory cgroup out of memory");
+	if (chosen) {
+		points = chosen_points * 1000 / totalpages;
+		oom_kill_process(chosen, gfp_mask, order, points, totalpages,
+				 memcg, NULL, "Memory cgroup out of memory");
+	}
+unlock:
+	mutex_unlock(&oom_lock);
 }
 
 #if MAX_NUMNODES > 1
diff -puN mm/oom_kill.c~mm-oom_kill-simplify-oom-killer-locking mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-simplify-oom-killer-locking
+++ a/mm/oom_kill.c
@@ -42,7 +42,8 @@
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks = 1;
-static DEFINE_SPINLOCK(zone_scan_lock);
+
+DEFINE_MUTEX(oom_lock);
 
 #ifdef CONFIG_NUMA
 /**
@@ -405,13 +406,12 @@ static atomic_t oom_victims = ATOMIC_INI
 static DECLARE_WAIT_QUEUE_HEAD(oom_victims_wait);
 
 bool oom_killer_disabled __read_mostly;
-static DECLARE_RWSEM(oom_sem);
 
 /**
  * mark_oom_victim - mark the given task as OOM victim
  * @tsk: task to mark
  *
- * Has to be called with oom_sem taken for read and never after
+ * Has to be called with oom_lock held and never after
  * oom has been disabled already.
  */
 void mark_oom_victim(struct task_struct *tsk)
@@ -460,14 +460,14 @@ bool oom_killer_disable(void)
 	 * Make sure to not race with an ongoing OOM killer
 	 * and that the current is not the victim.
 	 */
-	down_write(&oom_sem);
+	mutex_lock(&oom_lock);
 	if (test_thread_flag(TIF_MEMDIE)) {
-		up_write(&oom_sem);
+		mutex_unlock(&oom_lock);
 		return false;
 	}
 
 	oom_killer_disabled = true;
-	up_write(&oom_sem);
+	mutex_unlock(&oom_lock);
 
 	wait_event(oom_victims_wait, !atomic_read(&oom_victims));
 
@@ -634,52 +634,6 @@ int unregister_oom_notifier(struct notif
 }
 EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 
-/*
- * Try to acquire the OOM killer lock for the zones in zonelist.  Returns zero
- * if a parallel OOM killing is already taking place that includes a zone in
- * the zonelist.  Otherwise, locks all zones in the zonelist and returns 1.
- */
-bool oom_zonelist_trylock(struct zonelist *zonelist, gfp_t gfp_mask)
-{
-	struct zoneref *z;
-	struct zone *zone;
-	bool ret = true;
-
-	spin_lock(&zone_scan_lock);
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
-		if (test_bit(ZONE_OOM_LOCKED, &zone->flags)) {
-			ret = false;
-			goto out;
-		}
-
-	/*
-	 * Lock each zone in the zonelist under zone_scan_lock so a parallel
-	 * call to oom_zonelist_trylock() doesn't succeed when it shouldn't.
-	 */
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
-		set_bit(ZONE_OOM_LOCKED, &zone->flags);
-
-out:
-	spin_unlock(&zone_scan_lock);
-	return ret;
-}
-
-/*
- * Clears the ZONE_OOM_LOCKED flag for all zones in the zonelist so that failed
- * allocation attempts with zonelists containing them may now recall the OOM
- * killer, if necessary.
- */
-void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_mask)
-{
-	struct zoneref *z;
-	struct zone *zone;
-
-	spin_lock(&zone_scan_lock);
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
-		clear_bit(ZONE_OOM_LOCKED, &zone->flags);
-	spin_unlock(&zone_scan_lock);
-}
-
 /**
  * __out_of_memory - kill the "best" process when we run out of memory
  * @zonelist: zonelist pointer
@@ -693,8 +647,8 @@ void oom_zonelist_unlock(struct zonelist
  * OR try to be smart about which process to kill. Note that we
  * don't have to be perfect here, we just have to be good.
  */
-static void __out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
-		int order, nodemask_t *nodemask, bool force_kill)
+bool out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+		   int order, nodemask_t *nodemask, bool force_kill)
 {
 	const nodemask_t *mpol_mask;
 	struct task_struct *p;
@@ -704,10 +658,13 @@ static void __out_of_memory(struct zonel
 	enum oom_constraint constraint = CONSTRAINT_NONE;
 	int killed = 0;
 
+	if (oom_killer_disabled)
+		return false;
+
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
 		/* Got some memory back in the last second. */
-		return;
+		goto out;
 
 	/*
 	 * If current has a pending SIGKILL or is exiting, then automatically
@@ -720,7 +677,7 @@ static void __out_of_memory(struct zonel
 	if (current->mm &&
 	    (fatal_signal_pending(current) || task_will_free_mem(current))) {
 		mark_oom_victim(current);
-		return;
+		goto out;
 	}
 
 	/*
@@ -760,32 +717,8 @@ out:
 	 */
 	if (killed)
 		schedule_timeout_killable(1);
-}
-
-/**
- * out_of_memory -  tries to invoke OOM killer.
- * @zonelist: zonelist pointer
- * @gfp_mask: memory allocation flags
- * @order: amount of memory being requested as a power of 2
- * @nodemask: nodemask passed to page allocator
- * @force_kill: true if a task must be killed, even if others are exiting
- *
- * invokes __out_of_memory if the OOM is not disabled by oom_killer_disable()
- * when it returns false. Otherwise returns true.
- */
-bool out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
-		int order, nodemask_t *nodemask, bool force_kill)
-{
-	bool ret = false;
-
-	down_read(&oom_sem);
-	if (!oom_killer_disabled) {
-		__out_of_memory(zonelist, gfp_mask, order, nodemask, force_kill);
-		ret = true;
-	}
-	up_read(&oom_sem);
 
-	return ret;
+	return true;
 }
 
 /*
@@ -795,27 +728,21 @@ bool out_of_memory(struct zonelist *zone
  */
 void pagefault_out_of_memory(void)
 {
-	struct zonelist *zonelist;
-
-	down_read(&oom_sem);
 	if (mem_cgroup_oom_synchronize(true))
-		goto unlock;
+		return;
 
-	zonelist = node_zonelist(first_memory_node, GFP_KERNEL);
-	if (oom_zonelist_trylock(zonelist, GFP_KERNEL)) {
-		if (!oom_killer_disabled)
-			__out_of_memory(NULL, 0, 0, NULL, false);
-		else
-			/*
-			 * There shouldn't be any user tasks runable while the
-			 * OOM killer is disabled so the current task has to
-			 * be a racing OOM victim for which oom_killer_disable()
-			 * is waiting for.
-			 */
-			WARN_ON(test_thread_flag(TIF_MEMDIE));
+	if (!mutex_trylock(&oom_lock))
+		return;
 
-		oom_zonelist_unlock(zonelist, GFP_KERNEL);
+	if (!out_of_memory(NULL, 0, 0, NULL, false)) {
+		/*
+		 * There shouldn't be any user tasks runnable while the
+		 * OOM killer is disabled, so the current task has to
+		 * be a racing OOM victim for which oom_killer_disable()
+		 * is waiting for.
+		 */
+		WARN_ON(test_thread_flag(TIF_MEMDIE));
 	}
-unlock:
-	up_read(&oom_sem);
+
+	mutex_unlock(&oom_lock);
 }
diff -puN mm/page_alloc.c~mm-oom_kill-simplify-oom-killer-locking mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom_kill-simplify-oom-killer-locking
+++ a/mm/page_alloc.c
@@ -2720,10 +2720,10 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	*did_some_progress = 0;
 
 	/*
-	 * Acquire the per-zone oom lock for each zone.  If that
-	 * fails, somebody else is making progress for us.
+	 * Acquire the oom lock.  If that fails, somebody else is
+	 * making progress for us.
 	 */
-	if (!oom_zonelist_trylock(ac->zonelist, gfp_mask)) {
+	if (!mutex_trylock(&oom_lock)) {
 		*did_some_progress = 1;
 		schedule_timeout_uninterruptible(1);
 		return NULL;
@@ -2768,7 +2768,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 			|| WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL))
 		*did_some_progress = 1;
 out:
-	oom_zonelist_unlock(ac->zonelist, gfp_mask);
+	mutex_unlock(&oom_lock);
 	return page;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
rename-reclaim_swap-to-reclaim_unmap.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch
mm-oom_kill-switch-test-and-clear-of-known-tif_memdie-to-clear.patch
mm-oom_kill-generalize-oom-progress-waitqueue.patch
mm-oom_kill-remove-unnecessary-locking-in-exit_oom_victim.patch
mm-oom_kill-simplify-oom-killer-locking.patch
mm-page_alloc-inline-should_alloc_retry.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list.patch

