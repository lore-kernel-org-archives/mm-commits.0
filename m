From: akpm@linux-foundation.org
Subject: + coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch added to -mm tree
Date: Tue, 15 Jul 2008 19:08:25 -0700
Message-ID: <200807160208.m6G28PXe000811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755394AbYGPCIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jul 2008 22:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, dhowells@redhat.com, roland@redhat.com


The patch titled
     coredump: elf_fdpic_core_dump: use core_state->dumper list
has been added to the -mm tree.  Its filename is
     coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch

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
Subject: coredump: elf_fdpic_core_dump: use core_state->dumper list
From: Oleg Nesterov <oleg@tv-sign.ru>

Kill the nasty rcu_read_lock() + do_each_thread() loop, use the list
encoded in mm->core_state instead, s/GFP_ATOMIC/GFP_KERNEL/.

This patch allows futher cleanups in binfmt_elf_fdpic.c.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~coredump-elf_fdpic_core_dump-use-core_state-dumper-list fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~coredump-elf_fdpic_core_dump-use-core_state-dumper-list
+++ a/fs/binfmt_elf_fdpic.c
@@ -1578,7 +1578,6 @@ static int elf_fdpic_core_dump(long sign
 	struct memelfnote *notes = NULL;
 	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
 	struct elf_prpsinfo *psinfo = NULL;	/* NT_PRPSINFO */
- 	struct task_struct *g, *p;
  	LIST_HEAD(thread_list);
  	struct list_head *t;
 	elf_fpregset_t *fpu = NULL;
@@ -1627,23 +1626,19 @@ static int elf_fdpic_core_dump(long sign
 #endif
 
 	if (signr) {
+		struct core_thread *ct;
 		struct elf_thread_status *tmp;
-		rcu_read_lock();
-		do_each_thread(g,p)
-			if (current->mm == p->mm && current != p) {
-				if (p->flags & PF_KTHREAD)
-					continue;
-
-				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
-				if (!tmp) {
-					rcu_read_unlock();
-					goto cleanup;
-				}
-				tmp->thread = p;
-				list_add(&tmp->list, &thread_list);
-			}
-		while_each_thread(g,p);
-		rcu_read_unlock();
+
+		for (ct = current->mm->core_state->dumper.next;
+						ct; ct = ct->next) {
+			tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+			if (!tmp)
+				goto cleanup;
+
+			tmp->thread = ct->task;
+			list_add(&tmp->list, &thread_list);
+		}
+
 		list_for_each(t, &thread_list) {
 			struct elf_thread_status *tmp;
 			int sz;
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

