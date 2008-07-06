From: akpm@linux-foundation.org
Subject: + coredump-turn-core_state-nr_threads-into-atomic_t.patch added to -mm tree
Date: Sun, 06 Jul 2008 12:24:24 -0700
Message-ID: <200807061924.m66JOOh5021283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756346AbYGFTYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 15:24:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     coredump: turn core_state->nr_threads into atomic_t
has been added to the -mm tree.  Its filename is
     coredump-turn-core_state-nr_threads-into-atomic_t.patch

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
Subject: coredump: turn core_state->nr_threads into atomic_t
From: Oleg Nesterov <oleg@tv-sign.ru>

Turn core_state->nr_threads into atomic_t and kill now unneeded
down_write(&mm->mmap_sem) in exit_mm().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    2 +-
 include/linux/mm_types.h |    2 +-
 kernel/exit.c            |    5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/exec.c~coredump-turn-core_state-nr_threads-into-atomic_t fs/exec.c
--- a/fs/exec.c~coredump-turn-core_state-nr_threads-into-atomic_t
+++ a/fs/exec.c
@@ -1591,7 +1591,7 @@ static inline int zap_threads(struct tas
 	}
 	rcu_read_unlock();
 done:
-	core_state->nr_threads = nr;
+	atomic_set(&core_state->nr_threads, nr);
 	return nr;
 }
 
diff -puN include/linux/mm_types.h~coredump-turn-core_state-nr_threads-into-atomic_t include/linux/mm_types.h
--- a/include/linux/mm_types.h~coredump-turn-core_state-nr_threads-into-atomic_t
+++ a/include/linux/mm_types.h
@@ -165,7 +165,7 @@ struct vm_area_struct {
 };
 
 struct core_state {
-	int nr_threads;
+	atomic_t nr_threads;
 	struct completion startup;
 };
 
diff -puN kernel/exit.c~coredump-turn-core_state-nr_threads-into-atomic_t kernel/exit.c
--- a/kernel/exit.c~coredump-turn-core_state-nr_threads-into-atomic_t
+++ a/kernel/exit.c
@@ -665,10 +665,9 @@ static void exit_mm(struct task_struct *
 	down_read(&mm->mmap_sem);
 	if (mm->core_state) {
 		up_read(&mm->mmap_sem);
-		down_write(&mm->mmap_sem);
-		if (!--mm->core_state->nr_threads)
+
+		if (atomic_dec_and_test(&mm->core_state->nr_threads))
 			complete(&mm->core_state->startup);
-		up_write(&mm->mmap_sem);
 
 		wait_for_completion(&mm->core_done);
 		down_read(&mm->mmap_sem);
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

