From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-handle-non-error-oom-situations-more-gracefully.patch removed from -mm tree
Date: Thu, 17 Oct 2013 11:13:17 -0700
Message-ID: <526028bd.k5qPj2+MDOK1o6ii%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356Ab3JQSNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, mhocko@suse.cz, azurit@pobox.sk, hannes@cmpxchg.org

Subject: [merged] mm-memcg-handle-non-error-oom-situations-more-gracefully.patch removed from -mm tree
To: hannes@cmpxchg.org,azurit@pobox.sk,mhocko@suse.cz,stable@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:17 -0700


The patch titled
     Subject: mm: memcg: handle non-error OOM situations more gracefully
has been removed from the -mm tree.  Its filename was
     mm-memcg-handle-non-error-oom-situations-more-gracefully.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: handle non-error OOM situations more gracefully

3812c8c ("mm: memcg: do not trap chargers with full callstack on OOM")
assumed that only a few places that can trigger a memcg OOM situation do
not return VM_FAULT_OOM, like optional page cache readahead.  But there
are many more and it's impractical to annotate them all.

First of all, we don't want to invoke the OOM killer when the failed
allocation is gracefully handled, so defer the actual kill to the end of
the fault handling as well.  This simplifies the code quite a bit for
added bonus.

Second, since a failed allocation might not be the abrupt end of the
fault, the memcg OOM handler needs to be re-entrant until the fault
finishes for subsequent allocation attempts.  If an allocation is
attempted after the task already OOMed, allow it to bypass the limit so
that it can quickly finish the fault and invoke the OOM killer.

Reported-by: azurIt <azurit@pobox.sk>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   50 ++----------
 include/linux/sched.h      |    7 -
 mm/filemap.c               |   11 --
 mm/memcontrol.c            |  139 ++++++++++++-----------------------
 mm/memory.c                |   18 +++-
 mm/oom_kill.c              |    2 
 6 files changed, 79 insertions(+), 148 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-handle-non-error-oom-situations-more-gracefully include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-handle-non-error-oom-situations-more-gracefully
+++ a/include/linux/memcontrol.h
@@ -137,47 +137,24 @@ extern void mem_cgroup_print_oom_info(st
 extern void mem_cgroup_replace_page_cache(struct page *oldpage,
 					struct page *newpage);
 
-/**
- * mem_cgroup_toggle_oom - toggle the memcg OOM killer for the current task
- * @new: true to enable, false to disable
- *
- * Toggle whether a failed memcg charge should invoke the OOM killer
- * or just return -ENOMEM.  Returns the previous toggle state.
- *
- * NOTE: Any path that enables the OOM killer before charging must
- *       call mem_cgroup_oom_synchronize() afterward to finalize the
- *       OOM handling and clean up.
- */
-static inline bool mem_cgroup_toggle_oom(bool new)
+static inline void mem_cgroup_oom_enable(void)
 {
-	bool old;
-
-	old = current->memcg_oom.may_oom;
-	current->memcg_oom.may_oom = new;
-
-	return old;
+	WARN_ON(current->memcg_oom.may_oom);
+	current->memcg_oom.may_oom = 1;
 }
 
-static inline void mem_cgroup_enable_oom(void)
+static inline void mem_cgroup_oom_disable(void)
 {
-	bool old = mem_cgroup_toggle_oom(true);
-
-	WARN_ON(old == true);
-}
-
-static inline void mem_cgroup_disable_oom(void)
-{
-	bool old = mem_cgroup_toggle_oom(false);
-
-	WARN_ON(old == false);
+	WARN_ON(!current->memcg_oom.may_oom);
+	current->memcg_oom.may_oom = 0;
 }
 
 static inline bool task_in_memcg_oom(struct task_struct *p)
 {
-	return p->memcg_oom.in_memcg_oom;
+	return p->memcg_oom.memcg;
 }
 
-bool mem_cgroup_oom_synchronize(void);
+bool mem_cgroup_oom_synchronize(bool wait);
 
 #ifdef CONFIG_MEMCG_SWAP
 extern int do_swap_account;
@@ -402,16 +379,11 @@ static inline void mem_cgroup_end_update
 {
 }
 
-static inline bool mem_cgroup_toggle_oom(bool new)
-{
-	return false;
-}
-
-static inline void mem_cgroup_enable_oom(void)
+static inline void mem_cgroup_oom_enable(void)
 {
 }
 
-static inline void mem_cgroup_disable_oom(void)
+static inline void mem_cgroup_oom_disable(void)
 {
 }
 
@@ -420,7 +392,7 @@ static inline bool task_in_memcg_oom(str
 	return false;
 }
 
-static inline bool mem_cgroup_oom_synchronize(void)
+static inline bool mem_cgroup_oom_synchronize(bool wait)
 {
 	return false;
 }
diff -puN include/linux/sched.h~mm-memcg-handle-non-error-oom-situations-more-gracefully include/linux/sched.h
--- a/include/linux/sched.h~mm-memcg-handle-non-error-oom-situations-more-gracefully
+++ a/include/linux/sched.h
@@ -1394,11 +1394,10 @@ struct task_struct {
 	} memcg_batch;
 	unsigned int memcg_kmem_skip_account;
 	struct memcg_oom_info {
+		struct mem_cgroup *memcg;
+		gfp_t gfp_mask;
+		int order;
 		unsigned int may_oom:1;
-		unsigned int in_memcg_oom:1;
-		unsigned int oom_locked:1;
-		int wakeups;
-		struct mem_cgroup *wait_on_memcg;
 	} memcg_oom;
 #endif
 #ifdef CONFIG_UPROBES
diff -puN mm/filemap.c~mm-memcg-handle-non-error-oom-situations-more-gracefully mm/filemap.c
--- a/mm/filemap.c~mm-memcg-handle-non-error-oom-situations-more-gracefully
+++ a/mm/filemap.c
@@ -1616,7 +1616,6 @@ int filemap_fault(struct vm_area_struct
 	struct inode *inode = mapping->host;
 	pgoff_t offset = vmf->pgoff;
 	struct page *page;
-	bool memcg_oom;
 	pgoff_t size;
 	int ret = 0;
 
@@ -1625,11 +1624,7 @@ int filemap_fault(struct vm_area_struct
 		return VM_FAULT_SIGBUS;
 
 	/*
-	 * Do we have something in the page cache already?  Either
-	 * way, try readahead, but disable the memcg OOM killer for it
-	 * as readahead is optional and no errors are propagated up
-	 * the fault stack.  The OOM killer is enabled while trying to
-	 * instantiate the faulting page individually below.
+	 * Do we have something in the page cache already?
 	 */
 	page = find_get_page(mapping, offset);
 	if (likely(page) && !(vmf->flags & FAULT_FLAG_TRIED)) {
@@ -1637,14 +1632,10 @@ int filemap_fault(struct vm_area_struct
 		 * We found the page, so try async readahead before
 		 * waiting for the lock.
 		 */
-		memcg_oom = mem_cgroup_toggle_oom(false);
 		do_async_mmap_readahead(vma, ra, file, page, offset);
-		mem_cgroup_toggle_oom(memcg_oom);
 	} else if (!page) {
 		/* No page in the page cache at all */
-		memcg_oom = mem_cgroup_toggle_oom(false);
 		do_sync_mmap_readahead(vma, ra, file, offset);
-		mem_cgroup_toggle_oom(memcg_oom);
 		count_vm_event(PGMAJFAULT);
 		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 		ret = VM_FAULT_MAJOR;
diff -puN mm/memcontrol.c~mm-memcg-handle-non-error-oom-situations-more-gracefully mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-handle-non-error-oom-situations-more-gracefully
+++ a/mm/memcontrol.c
@@ -2161,110 +2161,59 @@ static void memcg_oom_recover(struct mem
 		memcg_wakeup_oom(memcg);
 }
 
-/*
- * try to call OOM killer
- */
 static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	bool locked;
-	int wakeups;
-
 	if (!current->memcg_oom.may_oom)
 		return;
-
-	current->memcg_oom.in_memcg_oom = 1;
-
 	/*
-	 * As with any blocking lock, a contender needs to start
-	 * listening for wakeups before attempting the trylock,
-	 * otherwise it can miss the wakeup from the unlock and sleep
-	 * indefinitely.  This is just open-coded because our locking
-	 * is so particular to memcg hierarchies.
+	 * We are in the middle of the charge context here, so we
+	 * don't want to block when potentially sitting on a callstack
+	 * that holds all kinds of filesystem and mm locks.
+	 *
+	 * Also, the caller may handle a failed allocation gracefully
+	 * (like optional page cache readahead) and so an OOM killer
+	 * invocation might not even be necessary.
+	 *
+	 * That's why we don't do anything here except remember the
+	 * OOM context and then deal with it at the end of the page
+	 * fault when the stack is unwound, the locks are released,
+	 * and when we know whether the fault was overall successful.
 	 */
-	wakeups = atomic_read(&memcg->oom_wakeups);
-	mem_cgroup_mark_under_oom(memcg);
-
-	locked = mem_cgroup_oom_trylock(memcg);
-
-	if (locked)
-		mem_cgroup_oom_notify(memcg);
-
-	if (locked && !memcg->oom_kill_disable) {
-		mem_cgroup_unmark_under_oom(memcg);
-		mem_cgroup_out_of_memory(memcg, mask, order);
-		mem_cgroup_oom_unlock(memcg);
-		/*
-		 * There is no guarantee that an OOM-lock contender
-		 * sees the wakeups triggered by the OOM kill
-		 * uncharges.  Wake any sleepers explicitely.
-		 */
-		memcg_oom_recover(memcg);
-	} else {
-		/*
-		 * A system call can just return -ENOMEM, but if this
-		 * is a page fault and somebody else is handling the
-		 * OOM already, we need to sleep on the OOM waitqueue
-		 * for this memcg until the situation is resolved.
-		 * Which can take some time because it might be
-		 * handled by a userspace task.
-		 *
-		 * However, this is the charge context, which means
-		 * that we may sit on a large call stack and hold
-		 * various filesystem locks, the mmap_sem etc. and we
-		 * don't want the OOM handler to deadlock on them
-		 * while we sit here and wait.  Store the current OOM
-		 * context in the task_struct, then return -ENOMEM.
-		 * At the end of the page fault handler, with the
-		 * stack unwound, pagefault_out_of_memory() will check
-		 * back with us by calling
-		 * mem_cgroup_oom_synchronize(), possibly putting the
-		 * task to sleep.
-		 */
-		current->memcg_oom.oom_locked = locked;
-		current->memcg_oom.wakeups = wakeups;
-		css_get(&memcg->css);
-		current->memcg_oom.wait_on_memcg = memcg;
-	}
+	css_get(&memcg->css);
+	current->memcg_oom.memcg = memcg;
+	current->memcg_oom.gfp_mask = mask;
+	current->memcg_oom.order = order;
 }
 
 /**
  * mem_cgroup_oom_synchronize - complete memcg OOM handling
+ * @handle: actually kill/wait or just clean up the OOM state
  *
- * This has to be called at the end of a page fault if the the memcg
- * OOM handler was enabled and the fault is returning %VM_FAULT_OOM.
+ * This has to be called at the end of a page fault if the memcg OOM
+ * handler was enabled.
  *
- * Memcg supports userspace OOM handling, so failed allocations must
+ * Memcg supports userspace OOM handling where failed allocations must
  * sleep on a waitqueue until the userspace task resolves the
  * situation.  Sleeping directly in the charge context with all kinds
  * of locks held is not a good idea, instead we remember an OOM state
  * in the task and mem_cgroup_oom_synchronize() has to be called at
- * the end of the page fault to put the task to sleep and clean up the
- * OOM state.
+ * the end of the page fault to complete the OOM handling.
  *
  * Returns %true if an ongoing memcg OOM situation was detected and
- * finalized, %false otherwise.
+ * completed, %false otherwise.
  */
-bool mem_cgroup_oom_synchronize(void)
+bool mem_cgroup_oom_synchronize(bool handle)
 {
+	struct mem_cgroup *memcg = current->memcg_oom.memcg;
 	struct oom_wait_info owait;
-	struct mem_cgroup *memcg;
+	bool locked;
 
 	/* OOM is global, do not handle */
-	if (!current->memcg_oom.in_memcg_oom)
-		return false;
-
-	/*
-	 * We invoked the OOM killer but there is a chance that a kill
-	 * did not free up any charges.  Everybody else might already
-	 * be sleeping, so restart the fault and keep the rampage
-	 * going until some charges are released.
-	 */
-	memcg = current->memcg_oom.wait_on_memcg;
 	if (!memcg)
-		goto out;
+		return false;
 
-	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
-		goto out_memcg;
+	if (!handle)
+		goto cleanup;
 
 	owait.memcg = memcg;
 	owait.wait.flags = 0;
@@ -2273,13 +2222,25 @@ bool mem_cgroup_oom_synchronize(void)
 	INIT_LIST_HEAD(&owait.wait.task_list);
 
 	prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
-	/* Only sleep if we didn't miss any wakeups since OOM */
-	if (atomic_read(&memcg->oom_wakeups) == current->memcg_oom.wakeups)
+	mem_cgroup_mark_under_oom(memcg);
+
+	locked = mem_cgroup_oom_trylock(memcg);
+
+	if (locked)
+		mem_cgroup_oom_notify(memcg);
+
+	if (locked && !memcg->oom_kill_disable) {
+		mem_cgroup_unmark_under_oom(memcg);
+		finish_wait(&memcg_oom_waitq, &owait.wait);
+		mem_cgroup_out_of_memory(memcg, current->memcg_oom.gfp_mask,
+					 current->memcg_oom.order);
+	} else {
 		schedule();
-	finish_wait(&memcg_oom_waitq, &owait.wait);
-out_memcg:
-	mem_cgroup_unmark_under_oom(memcg);
-	if (current->memcg_oom.oom_locked) {
+		mem_cgroup_unmark_under_oom(memcg);
+		finish_wait(&memcg_oom_waitq, &owait.wait);
+	}
+
+	if (locked) {
 		mem_cgroup_oom_unlock(memcg);
 		/*
 		 * There is no guarantee that an OOM-lock contender
@@ -2288,10 +2249,9 @@ out_memcg:
 		 */
 		memcg_oom_recover(memcg);
 	}
+cleanup:
+	current->memcg_oom.memcg = NULL;
 	css_put(&memcg->css);
-	current->memcg_oom.wait_on_memcg = NULL;
-out:
-	current->memcg_oom.in_memcg_oom = 0;
 	return true;
 }
 
@@ -2705,6 +2665,9 @@ static int __mem_cgroup_try_charge(struc
 		     || fatal_signal_pending(current)))
 		goto bypass;
 
+	if (unlikely(task_in_memcg_oom(current)))
+		goto bypass;
+
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
diff -puN mm/memory.c~mm-memcg-handle-non-error-oom-situations-more-gracefully mm/memory.c
--- a/mm/memory.c~mm-memcg-handle-non-error-oom-situations-more-gracefully
+++ a/mm/memory.c
@@ -3865,15 +3865,21 @@ int handle_mm_fault(struct mm_struct *mm
 	 * space.  Kernel faults are handled more gracefully.
 	 */
 	if (flags & FAULT_FLAG_USER)
-		mem_cgroup_enable_oom();
+		mem_cgroup_oom_enable();
 
 	ret = __handle_mm_fault(mm, vma, address, flags);
 
-	if (flags & FAULT_FLAG_USER)
-		mem_cgroup_disable_oom();
-
-	if (WARN_ON(task_in_memcg_oom(current) && !(ret & VM_FAULT_OOM)))
-		mem_cgroup_oom_synchronize();
+	if (flags & FAULT_FLAG_USER) {
+		mem_cgroup_oom_disable();
+                /*
+                 * The task may have entered a memcg OOM situation but
+                 * if the allocation error was handled gracefully (no
+                 * VM_FAULT_OOM), there is no need to kill anything.
+                 * Just clean up the OOM state peacefully.
+                 */
+                if (task_in_memcg_oom(current) && !(ret & VM_FAULT_OOM))
+                        mem_cgroup_oom_synchronize(false);
+	}
 
 	return ret;
 }
diff -puN mm/oom_kill.c~mm-memcg-handle-non-error-oom-situations-more-gracefully mm/oom_kill.c
--- a/mm/oom_kill.c~mm-memcg-handle-non-error-oom-situations-more-gracefully
+++ a/mm/oom_kill.c
@@ -680,7 +680,7 @@ void pagefault_out_of_memory(void)
 {
 	struct zonelist *zonelist;
 
-	if (mem_cgroup_oom_synchronize())
+	if (mem_cgroup_oom_synchronize(true))
 		return;
 
 	zonelist = node_zonelist(first_online_node, GFP_KERNEL);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch
memcg-refactor-mem_control_numa_stat_show.patch
memcg-support-hierarchical-memorynuma_stats.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
mm-rearrange-madvise-code-to-allow-for-reuse.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

