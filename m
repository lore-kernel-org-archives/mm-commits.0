From: akpm@linux-foundation.org
Subject: [merged] mm-avoid-false-sharing-of-mm_counter.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:05 -0800
Message-ID: <201003091903.o29J35No030923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab0CITDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, lee.schermerhorn@hp.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: avoid false sharing of mm_counter
has been removed from the -mm tree.  Its filename was
     mm-avoid-false-sharing-of-mm_counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: avoid false sharing of mm_counter
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Considering the nature of per mm stats, it's the shared object among
threads and can be a cache-miss point in the page fault path.

This patch adds per-thread cache for mm_counter.  RSS value will be
counted into a struct in task_struct and synchronized with mm's one at
events.

Now, in this patch, the event is the number of calls to handle_mm_fault. 
Per-thread value is added to mm at each 64 calls.

 rough estimation with small benchmark on parallel thread (2threads) shows
 [before]
     4.5 cache-miss/faults
 [after]
     4.0 cache-miss/faults
 Anyway, the most contended object is mmap_sem if the number of threads grows.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    6 +
 fs/exec.c                          |    1 
 include/linux/mm.h                 |    8 --
 include/linux/mm_types.h           |    6 +
 include/linux/sched.h              |    4 -
 kernel/exit.c                      |    3 
 mm/memory.c                        |   94 ++++++++++++++++++++++++---
 7 files changed, 107 insertions(+), 15 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-avoid-false-sharing-of-mm_counter Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-avoid-false-sharing-of-mm_counter
+++ a/Documentation/filesystems/proc.txt
@@ -188,6 +188,12 @@ memory usage. Its seven fields are expla
 contains details information about the process itself.  Its fields are
 explained in Table 1-4.
 
+(for SMP CONFIG users)
+For making accounting scalable, RSS related information are handled in
+asynchronous manner and the vaule may not be very precise. To see a precise
+snapshot of a moment, you can see /proc/<pid>/smaps file and scan page table.
+It's slow but very precise.
+
 Table 1-2: Contents of the statm files (as of 2.6.30-rc7)
 ..............................................................................
  Field                       Content
diff -puN fs/exec.c~mm-avoid-false-sharing-of-mm_counter fs/exec.c
--- a/fs/exec.c~mm-avoid-false-sharing-of-mm_counter
+++ a/fs/exec.c
@@ -718,6 +718,7 @@ static int exec_mmap(struct mm_struct *m
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
+	sync_mm_rss(tsk, old_mm);
 	mm_release(tsk, old_mm);
 
 	if (old_mm) {
diff -puN include/linux/mm.h~mm-avoid-false-sharing-of-mm_counter include/linux/mm.h
--- a/include/linux/mm.h~mm-avoid-false-sharing-of-mm_counter
+++ a/include/linux/mm.h
@@ -873,7 +873,7 @@ int __get_user_pages_fast(unsigned long 
 /*
  * per-process(per-mm_struct) statistics.
  */
-#if USE_SPLIT_PTLOCKS
+#if defined(SPLIT_RSS_COUNTING)
 /*
  * The mm counters are not protected by its page_table_lock,
  * so must be incremented atomically.
@@ -883,10 +883,7 @@ static inline void set_mm_counter(struct
 	atomic_long_set(&mm->rss_stat.count[member], value);
 }
 
-static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
-{
-	return (unsigned long)atomic_long_read(&mm->rss_stat.count[member]);
-}
+unsigned long get_mm_counter(struct mm_struct *mm, int member);
 
 static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
 {
@@ -974,6 +971,7 @@ static inline void setmax_mm_hiwater_rss
 		*maxrss = hiwater_rss;
 }
 
+void sync_mm_rss(struct task_struct *task, struct mm_struct *mm);
 
 /*
  * A callback you can register to apply pressure to ageable caches.
diff -puN include/linux/mm_types.h~mm-avoid-false-sharing-of-mm_counter include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-avoid-false-sharing-of-mm_counter
+++ a/include/linux/mm_types.h
@@ -202,9 +202,15 @@ enum {
 };
 
 #if USE_SPLIT_PTLOCKS
+#define SPLIT_RSS_COUNTING
 struct mm_rss_stat {
 	atomic_long_t count[NR_MM_COUNTERS];
 };
+/* per-thread cached information, */
+struct task_rss_stat {
+	int events;	/* for synchronization threshold */
+	int count[NR_MM_COUNTERS];
+};
 #else  /* !USE_SPLIT_PTLOCKS */
 struct mm_rss_stat {
 	unsigned long count[NR_MM_COUNTERS];
diff -puN include/linux/sched.h~mm-avoid-false-sharing-of-mm_counter include/linux/sched.h
--- a/include/linux/sched.h~mm-avoid-false-sharing-of-mm_counter
+++ a/include/linux/sched.h
@@ -1220,7 +1220,9 @@ struct task_struct {
 	struct plist_node pushable_tasks;
 
 	struct mm_struct *mm, *active_mm;
-
+#if defined(SPLIT_RSS_COUNTING)
+	struct task_rss_stat	rss_stat;
+#endif
 /* task state */
 	int exit_state;
 	int exit_code, exit_signal;
diff -puN kernel/exit.c~mm-avoid-false-sharing-of-mm_counter kernel/exit.c
--- a/kernel/exit.c~mm-avoid-false-sharing-of-mm_counter
+++ a/kernel/exit.c
@@ -952,7 +952,8 @@ NORET_TYPE void do_exit(long code)
 				preempt_count());
 
 	acct_update_integrals(tsk);
-
+	/* sync mm's RSS info before statistics gathering */
+	sync_mm_rss(tsk, tsk->mm);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
diff -puN mm/memory.c~mm-avoid-false-sharing-of-mm_counter mm/memory.c
--- a/mm/memory.c~mm-avoid-false-sharing-of-mm_counter
+++ a/mm/memory.c
@@ -122,6 +122,79 @@ static int __init init_zero_pfn(void)
 core_initcall(init_zero_pfn);
 
 
+#if defined(SPLIT_RSS_COUNTING)
+
+void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
+{
+	int i;
+
+	for (i = 0; i < NR_MM_COUNTERS; i++) {
+		if (task->rss_stat.count[i]) {
+			add_mm_counter(mm, i, task->rss_stat.count[i]);
+			task->rss_stat.count[i] = 0;
+		}
+	}
+	task->rss_stat.events = 0;
+}
+
+static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
+{
+	struct task_struct *task = current;
+
+	if (likely(task->mm == mm))
+		task->rss_stat.count[member] += val;
+	else
+		add_mm_counter(mm, member, val);
+}
+#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, 1)
+#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, -1)
+
+/* sync counter once per 64 page faults */
+#define TASK_RSS_EVENTS_THRESH	(64)
+static void check_sync_rss_stat(struct task_struct *task)
+{
+	if (unlikely(task != current))
+		return;
+	if (unlikely(task->rss_stat.events++ > TASK_RSS_EVENTS_THRESH))
+		__sync_task_rss_stat(task, task->mm);
+}
+
+unsigned long get_mm_counter(struct mm_struct *mm, int member)
+{
+	long val = 0;
+
+	/*
+	 * Don't use task->mm here...for avoiding to use task_get_mm()..
+	 * The caller must guarantee task->mm is not invalid.
+	 */
+	val = atomic_long_read(&mm->rss_stat.count[member]);
+	/*
+	 * counter is updated in asynchronous manner and may go to minus.
+	 * But it's never be expected number for users.
+	 */
+	if (val < 0)
+		return 0;
+	return (unsigned long)val;
+}
+
+void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
+{
+	__sync_task_rss_stat(task, mm);
+}
+#else
+
+#define inc_mm_counter_fast(mm, member) inc_mm_counter(mm, member)
+#define dec_mm_counter_fast(mm, member) dec_mm_counter(mm, member)
+
+static void check_sync_rss_stat(struct task_struct *task)
+{
+}
+
+void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
+{
+}
+#endif
+
 /*
  * If a p?d_bad entry is found while walking page tables, report
  * the error, before resetting entry to p?d_none.  Usually (but
@@ -386,6 +459,8 @@ static inline void add_mm_rss_vec(struct
 {
 	int i;
 
+	if (current->mm == mm)
+		sync_mm_rss(current, mm);
 	for (i = 0; i < NR_MM_COUNTERS; i++)
 		if (rss[i])
 			add_mm_counter(mm, i, rss[i]);
@@ -1539,7 +1614,7 @@ static int insert_page(struct vm_area_st
 
 	/* Ok, finally just insert the thing.. */
 	get_page(page);
-	inc_mm_counter(mm, MM_FILEPAGES);
+	inc_mm_counter_fast(mm, MM_FILEPAGES);
 	page_add_file_rmap(page);
 	set_pte_at(mm, addr, pte, mk_pte(page, prot));
 
@@ -2175,11 +2250,11 @@ gotten:
 	if (likely(pte_same(*page_table, orig_pte))) {
 		if (old_page) {
 			if (!PageAnon(old_page)) {
-				dec_mm_counter(mm, MM_FILEPAGES);
-				inc_mm_counter(mm, MM_ANONPAGES);
+				dec_mm_counter_fast(mm, MM_FILEPAGES);
+				inc_mm_counter_fast(mm, MM_ANONPAGES);
 			}
 		} else
-			inc_mm_counter(mm, MM_ANONPAGES);
+			inc_mm_counter_fast(mm, MM_ANONPAGES);
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
@@ -2616,7 +2691,7 @@ static int do_swap_page(struct mm_struct
 	 * discarded at swap_free().
 	 */
 
-	inc_mm_counter(mm, MM_ANONPAGES);
+	inc_mm_counter_fast(mm, MM_ANONPAGES);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
@@ -2700,7 +2775,7 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 
-	inc_mm_counter(mm, MM_ANONPAGES);
+	inc_mm_counter_fast(mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, address);
 setpte:
 	set_pte_at(mm, address, page_table, entry);
@@ -2854,10 +2929,10 @@ static int __do_fault(struct mm_struct *
 		if (flags & FAULT_FLAG_WRITE)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		if (anon) {
-			inc_mm_counter(mm, MM_ANONPAGES);
+			inc_mm_counter_fast(mm, MM_ANONPAGES);
 			page_add_new_anon_rmap(page, vma, address);
 		} else {
-			inc_mm_counter(mm, MM_FILEPAGES);
+			inc_mm_counter_fast(mm, MM_FILEPAGES);
 			page_add_file_rmap(page);
 			if (flags & FAULT_FLAG_WRITE) {
 				dirty_page = page;
@@ -3035,6 +3110,9 @@ int handle_mm_fault(struct mm_struct *mm
 
 	count_vm_event(PGFAULT);
 
+	/* do counter updates before entering really critical section. */
+	check_sync_rss_stat(current);
+
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, flags);
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
memcg-handle-panic_on_oom=always-case-v2.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch
memcg-fix-oom-kill-behavior-v3.patch
memcg-fix-oom-kill-behavior-v4.patch
memcg-update-maintainer-list.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch

