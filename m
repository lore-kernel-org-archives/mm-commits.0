From: akpm@linux-foundation.org
Subject: [merged] slow_work_thread-should-do-the-exclusive-wait.patch removed from -mm tree
Date: Thu, 11 Jun 2009 14:25:16 -0700
Message-ID: <200906112125.n5BLPGQE018208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbZFKVZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 17:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, Daire.Byrne@framestore.com, Trond.Myklebust@netapp.com, dhowells@redhat.com, serue@us.ibm.com, steved@redhat.com, mm-commits@vger.kernel.org


The patch titled
     slow_work_thread() should do the exclusive wait
has been removed from the -mm tree.  Its filename was
     slow_work_thread-should-do-the-exclusive-wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slow_work_thread() should do the exclusive wait
From: Oleg Nesterov <oleg@redhat.com>

slow_work_thread() sleeps on slow_work_thread_wq without WQ_FLAG_EXCLUSIVE,
this means that slow_work_enqueue()->__wake_up(nr_exclusive => 1) wakes up
all kslowd threads. Afaics this is not what we want, change slow_work_thread()
to use prepare_to_wait_exclusive().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Steve Dickson <steved@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Daire Byrne <Daire.Byrne@framestore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/slow-work.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/slow-work.c~slow_work_thread-should-do-the-exclusive-wait kernel/slow-work.c
--- a/kernel/slow-work.c~slow_work_thread-should-do-the-exclusive-wait
+++ a/kernel/slow-work.c
@@ -372,8 +372,8 @@ static int slow_work_thread(void *_data)
 		vsmax *= atomic_read(&slow_work_thread_count);
 		vsmax /= 100;
 
-		prepare_to_wait(&slow_work_thread_wq, &wait,
-				TASK_INTERRUPTIBLE);
+		prepare_to_wait_exclusive(&slow_work_thread_wq, &wait,
+						TASK_INTERRUPTIBLE);
 		if (!freezing(current) &&
 		    !slow_work_threads_should_exit &&
 		    !slow_work_available(vsmax) &&
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
ptrace-do-not-use-task_lock-for-attach.patch
ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch
ptrace-wait_task_zombie-s-parent-real_parent.patch
ptrace-do_notify_parent_cldstop-fix-the-wrong-nsproxy-usage.patch
ptrace-dont-take-tasklist-to-get-set-last_siginfo.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped.patch
introduce-struct-wait_opts-to-simplify-do_wait-pathes.patch
do_wait-simplify-retval-tsk_result-notask_error-mess.patch
do_wait-kill-the-old-bug_on-use-while_each_thread.patch
do_wait-fix-the-theoretical-race-with-stop-trace-cont.patch
mm-exitc-reorder-wait_opts-to-remove-padding-on-64-bit-builds.patch
wait_task_-cleanups-split-wait_noreap_copyout.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-clean-up-find_task_by_pid-variants.patch

