From: akpm@linux-foundation.org
Subject: [merged] mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:04 -0700
Message-ID: <20120322201904.7596EA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:46452 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454Ab2CVUTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:06 -0400
Received: by mail-wi0-f202.google.com with SMTP id hj13so59596wib.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, counters: remove task argument to sync_mm_rss() and __sync_task_rss_stat()
has been removed from the -mm tree.  Its filename was
     mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, counters: remove task argument to sync_mm_rss() and __sync_task_rss_stat()

sync_mm_rss() can only be used for current to avoid race conditions in
iterating and clearing its per-task counters.  Remove the task argument
for it and its helper function, __sync_task_rss_stat(), to avoid thinking
it can be used safely for anything other than current.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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
@@ -1131,9 +1131,9 @@ static inline void setmax_mm_hiwater_rss
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
@@ -934,7 +934,7 @@ void do_exit(long code)
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
@@ -125,17 +125,17 @@ core_initcall(init_zero_pfn);
 
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
@@ -157,12 +157,12 @@ static void check_sync_rss_stat(struct t
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
 
@@ -643,7 +643,7 @@ static inline void add_mm_rss_vec(struct
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

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
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

