From: akpm@linux-foundation.org
Subject: - get_user_pages-fix-possible-page-leak-on-oom.patch removed from -mm tree
Date: Sun, 06 Jul 2008 19:58:08 -0700
Message-ID: <200807070258.m672w8jE004423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbYGGC6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 22:58:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     get_user_pages(): fix possible page leak on oom
has been removed from the -mm tree.  Its filename was
     get_user_pages-fix-possible-page-leak-on-oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_user_pages(): fix possible page leak on oom
From: Oleg Nesterov <oleg@tv-sign.ru>

get_user_pages() must not return the error when i != 0.  When pages !=
NULL we have i get_page()'ed pages.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~get_user_pages-fix-possible-page-leak-on-oom mm/memory.c
--- a/mm/memory.c~get_user_pages-fix-possible-page-leak-on-oom
+++ a/mm/memory.c
@@ -1151,7 +1151,7 @@ int get_user_pages(struct task_struct *t
 			 * be processed until returning to user space.
 			 */
 			if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
-				return -ENOMEM;
+				return i ? i : -ENOMEM;
 
 			if (write)
 				foll_flags |= FOLL_WRITE;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

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
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
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
workqueues-lockdep-annotations-for-flush_work.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

