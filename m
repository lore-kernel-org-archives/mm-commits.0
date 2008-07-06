From: akpm@linux-foundation.org
Subject: + coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch added to -mm tree
Date: Sun, 06 Jul 2008 12:24:18 -0700
Message-ID: <200807061924.m66JOIgl021274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756814AbYGFTYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 15:24:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     coredump: turn mm->core_startup_done into the pointer to struct core_state
has been added to the -mm tree.  Its filename is
     coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch

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
Subject: coredump: turn mm->core_startup_done into the pointer to struct core_state
From: Oleg Nesterov <oleg@tv-sign.ru>

mm->core_startup_done points to "struct completion startup_done" allocated
on the coredump_wait()'s stack.  Introduce the new structure, core_state,
which holds this "struct completion".  This way we can add more info
visible to the threads participating in coredump without enlarging
mm_struct.

No changes in affected .o files.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    8 ++++----
 include/linux/mm_types.h |    7 ++++++-
 kernel/exit.c            |    2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff -puN fs/exec.c~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state fs/exec.c
--- a/fs/exec.c~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state
+++ a/fs/exec.c
@@ -1597,13 +1597,13 @@ static int coredump_wait(int exit_code)
 {
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
-	struct completion startup_done;
+	struct core_state core_state;
 	struct completion *vfork_done;
 	int core_waiters;
 
 	init_completion(&mm->core_done);
-	init_completion(&startup_done);
-	mm->core_startup_done = &startup_done;
+	init_completion(&core_state.startup);
+	mm->core_state = &core_state;
 
 	core_waiters = zap_threads(tsk, mm, exit_code);
 	up_write(&mm->mmap_sem);
@@ -1622,7 +1622,7 @@ static int coredump_wait(int exit_code)
 	}
 
 	if (core_waiters)
-		wait_for_completion(&startup_done);
+		wait_for_completion(&core_state.startup);
 fail:
 	BUG_ON(mm->core_waiters);
 	return core_waiters;
diff -puN include/linux/mm_types.h~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state include/linux/mm_types.h
--- a/include/linux/mm_types.h~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state
+++ a/include/linux/mm_types.h
@@ -164,6 +164,10 @@ struct vm_area_struct {
 #endif
 };
 
+struct core_state {
+	struct completion startup;
+};
+
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
@@ -225,7 +229,8 @@ struct mm_struct {
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	/* coredumping support */
-	struct completion *core_startup_done, core_done;
+	struct core_state *core_state;
+	struct completion core_done;
 
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;	/* aio lock */
diff -puN kernel/exit.c~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state kernel/exit.c
--- a/kernel/exit.c~coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state
+++ a/kernel/exit.c
@@ -667,7 +667,7 @@ static void exit_mm(struct task_struct *
 		up_read(&mm->mmap_sem);
 		down_write(&mm->mmap_sem);
 		if (!--mm->core_waiters)
-			complete(mm->core_startup_done);
+			complete(&mm->core_state->startup);
 		up_write(&mm->mmap_sem);
 
 		wait_for_completion(&mm->core_done);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
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
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

