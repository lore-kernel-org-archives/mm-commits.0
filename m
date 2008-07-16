From: akpm@linux-foundation.org
Subject: + coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch added to -mm tree
Date: Tue, 15 Jul 2008 19:08:21 -0700
Message-ID: <200807160208.m6G28LG7000805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755419AbYGPCIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jul 2008 22:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     coredump: construct the list of coredumping threads at startup time
has been added to the -mm tree.  Its filename is
     coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: construct the list of coredumping threads at startup time
From: Oleg Nesterov <oleg@tv-sign.ru>

binfmt->core_dump() has to iterate over the all threads in system in order
to find the coredumping threads and construct the list using the
GFP_ATOMIC allocations.

With this patch each thread allocates the list node on exit_mm()'s stack and
adds itself to the list.

This allows us to do further changes:

	- simplify ->core_dump()

	- change exit_mm() to clear ->mm first, then wait for ->core_done.
	  this makes the coredumping process visible to oom_kill

	- kill mm->core_done

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    2 ++
 include/linux/mm_types.h |    6 ++++++
 kernel/exit.c            |   15 ++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~coredump-construct-the-list-of-coredumping-threads-at-startup-time fs/exec.c
--- a/fs/exec.c~coredump-construct-the-list-of-coredumping-threads-at-startup-time
+++ a/fs/exec.c
@@ -1604,6 +1604,8 @@ static int coredump_wait(int exit_code, 
 
 	init_completion(&mm->core_done);
 	init_completion(&core_state->startup);
+	core_state->dumper.task = tsk;
+	core_state->dumper.next = NULL;
 	core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
diff -puN include/linux/mm_types.h~coredump-construct-the-list-of-coredumping-threads-at-startup-time include/linux/mm_types.h
--- a/include/linux/mm_types.h~coredump-construct-the-list-of-coredumping-threads-at-startup-time
+++ a/include/linux/mm_types.h
@@ -164,8 +164,14 @@ struct vm_area_struct {
 #endif
 };
 
+struct core_thread {
+	struct task_struct *task;
+	struct core_thread *next;
+};
+
 struct core_state {
 	atomic_t nr_threads;
+	struct core_thread dumper;
 	struct completion startup;
 };
 
diff -puN kernel/exit.c~coredump-construct-the-list-of-coredumping-threads-at-startup-time kernel/exit.c
--- a/kernel/exit.c~coredump-construct-the-list-of-coredumping-threads-at-startup-time
+++ a/kernel/exit.c
@@ -651,6 +651,7 @@ assign_new_owner:
 static void exit_mm(struct task_struct * tsk)
 {
 	struct mm_struct *mm = tsk->mm;
+	struct core_state *core_state;
 
 	mm_release(tsk, mm);
 	if (!mm)
@@ -663,11 +664,19 @@ static void exit_mm(struct task_struct *
 	 * group with ->mm != NULL.
 	 */
 	down_read(&mm->mmap_sem);
-	if (mm->core_state) {
+	core_state = mm->core_state;
+	if (core_state) {
+		struct core_thread self;
 		up_read(&mm->mmap_sem);
 
-		if (atomic_dec_and_test(&mm->core_state->nr_threads))
-			complete(&mm->core_state->startup);
+		self.task = tsk;
+		self.next = xchg(&core_state->dumper.next, &self);
+		/*
+		 * Implies mb(), the result of xchg() must be visible
+		 * to core_state->dumper.
+		 */
+		if (atomic_dec_and_test(&core_state->nr_threads))
+			complete(&core_state->startup);
 
 		wait_for_completion(&mm->core_done);
 		down_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
coredump-make-mm-core_state-visible-to-core_dump.patch
coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
coredump-elf_core_dump-use-core_state-dumper-list.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-kill-mm-core_done.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
workqueues-lockdep-annotations-for-flush_work.patch
workqueues-queue_work-can-use-queue_work_on.patch
workqueues-schedule_on_each_cpu-can-use-schedule_work_on.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

