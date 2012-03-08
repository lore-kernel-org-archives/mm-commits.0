From: akpm@linux-foundation.org
Subject: + mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat.patch added to -mm tree
Date: Wed, 07 Mar 2012 17:12:52 -0800
Message-ID: <20120308011253.B3B9BA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:53128 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2CHBMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Mar 2012 20:12:55 -0500
Received: by ghbz15 with SMTP id z15so885886ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Mar 2012 17:12:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: mm, counters: remove task argument to sync_mm_rss() and __sync_task_rss_stat()
has been added to the -mm tree.  Its filename is
     mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat.patch

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
Subject: mm, counters: remove task argument to sync_mm_rss() and __sync_task_rss_stat()

sync_mm_rss() can only be used for current to avoid race conditions in
iterating and clearing its per-task counters.  Remove the task argument
for it and its helper function, __sync_task_rss_stat(), to avoid thinking
it can be used safely for anything other than current.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    2 +-
 include/linux/mm.h |    4 ++--
 kernel/exit.c      |    2 +-
 mm/memory.c        |   18 +++++++++---------
 mm/mmu_context.c   |    2 +-
 5 files changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/exec.c~mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat fs/exec.c
--- a/fs/exec.c~mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat
+++ a/fs/exec.c
@@ -824,7 +824,7 @@ static int exec_mmap(struct mm_struct *m
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
-	sync_mm_rss(tsk, old_mm);
+	sync_mm_rss(old_mm);
 	mm_release(tsk, old_mm);
 
 	if (old_mm) {
diff -puN include/linux/mm.h~mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat include/linux/mm.h
--- a/include/linux/mm.h~mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat
+++ a/include/linux/mm.h
@@ -1132,9 +1132,9 @@ static inline void setmax_mm_hiwater_rss
 }
 
 #if defined(SPLIT_RSS_COUNTING)
-void sync_mm_rss(struct task_struct *task, struct mm_struct *mm);
+void sync_mm_rss(struct mm_struct *mm);
 #else
-static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
+static inline void sync_mm_rss(struct mm_struct *mm)
 {
 }
 #endif
diff -puN kernel/exit.c~mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat kernel/exit.c
--- a/kernel/exit.c~mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat
+++ a/kernel/exit.c
@@ -954,7 +954,7 @@ void do_exit(long code)
 	acct_update_integrals(tsk);
 	/* sync mm's RSS info before statistics gathering */
 	if (tsk->mm)
-		sync_mm_rss(tsk, tsk->mm);
+		sync_mm_rss(tsk->mm);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
diff -puN mm/memory.c~mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat mm/memory.c
--- a/mm/memory.c~mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat
+++ a/mm/memory.c
@@ -133,17 +133,17 @@ core_initcall(init_zero_pfn);
 
 #if defined(SPLIT_RSS_COUNTING)
 
-static void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
+static void __sync_task_rss_stat(struct mm_struct *mm)
 {
 	int i;
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
-		if (task->rss_stat.count[i]) {
-			add_mm_counter(mm, i, task->rss_stat.count[i]);
-			task->rss_stat.count[i] = 0;
+		if (current->rss_stat.count[i]) {
+			add_mm_counter(mm, i, current->rss_stat.count[i]);
+			current->rss_stat.count[i] = 0;
 		}
 	}
-	task->rss_stat.events = 0;
+	current->rss_stat.events = 0;
 }
 
 static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
@@ -165,12 +165,12 @@ static void check_sync_rss_stat(struct t
 	if (unlikely(task != current))
 		return;
 	if (unlikely(task->rss_stat.events++ > TASK_RSS_EVENTS_THRESH))
-		__sync_task_rss_stat(task, task->mm);
+		__sync_task_rss_stat(task->mm);
 }
 
-void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
+void sync_mm_rss(struct mm_struct *mm)
 {
-	__sync_task_rss_stat(task, mm);
+	__sync_task_rss_stat(mm);
 }
 #else /* SPLIT_RSS_COUNTING */
 
@@ -651,7 +651,7 @@ static inline void add_mm_rss_vec(struct
 	int i;
 
 	if (current->mm == mm)
-		sync_mm_rss(current, mm);
+		sync_mm_rss(mm);
 	for (i = 0; i < NR_MM_COUNTERS; i++)
 		if (rss[i])
 			add_mm_counter(mm, i, rss[i]);
diff -puN mm/mmu_context.c~mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat mm/mmu_context.c
--- a/mm/mmu_context.c~mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat
+++ a/mm/mmu_context.c
@@ -53,7 +53,7 @@ void unuse_mm(struct mm_struct *mm)
 	struct task_struct *tsk = current;
 
 	task_lock(tsk);
-	sync_mm_rss(tsk, mm);
+	sync_mm_rss(mm);
 	tsk->mm = NULL;
 	/* active_mm is still 'mm' */
 	enter_lazy_tlb(mm, tsk);
_
Subject: Subject: mm, counters: remove task argument to sync_mm_rss() and __sync_task_rss_stat()

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
slab-introduce-kmalloc_array.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-oom-introduce-independent-oom-killer-ratelimit-state.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
rmap-remove-__anon_vma_link.patch
mm-oom-force-oom-kill-on-sysrqf.patch
mm-memcg-pass-charge-order-to-oom-killer.patch
cpuset-mm-reduce-large-amounts-of-memory-barrier-related-damage-v3.patch
mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat.patch
mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch

