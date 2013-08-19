From: akpm@linux-foundation.org
Subject: + task_work-minor-cleanups.patch added to -mm tree
Date: Mon, 19 Aug 2013 14:34:55 -0700
Message-ID: <52128f7f.IhQSOt17enCgqK3/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3HSVfB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 17:35:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com

Subject: + task_work-minor-cleanups.patch added to -mm tree
To: oleg@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 14:34:55 -0700


The patch titled
     Subject: task_work: minor cleanups
has been added to the -mm tree.  Its filename is
     task_work-minor-cleanups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/task_work-minor-cleanups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/task_work-minor-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: task_work: minor cleanups

Trivial.  Remove the unnecessary "work = NULL" initialization and turn
read_barrier_depends() into smp_read_barrier_depends() in
task_work_cancel().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/task_work.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/task_work.c~task_work-minor-cleanups kernel/task_work.c
--- a/kernel/task_work.c~task_work-minor-cleanups
+++ a/kernel/task_work.c
@@ -25,7 +25,7 @@ struct callback_head *
 task_work_cancel(struct task_struct *task, task_work_func_t func)
 {
 	struct callback_head **pprev = &task->task_works;
-	struct callback_head *work = NULL;
+	struct callback_head *work;
 	unsigned long flags;
 	/*
 	 * If cmpxchg() fails we continue without updating pprev.
@@ -35,7 +35,7 @@ task_work_cancel(struct task_struct *tas
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	while ((work = ACCESS_ONCE(*pprev))) {
-		read_barrier_depends();
+		smp_read_barrier_depends();
 		if (work->func != func)
 			pprev = &work->next;
 		else if (cmpxchg(pprev, work, work->next) == work)
_

Patches currently in -mm which might be from oleg@redhat.com are

include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
task_work-minor-cleanups.patch
task_work-documentation.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
__ptrace_may_access-should-not-deny-sub-threads.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
exec-introduce-exec_binprm-for-depth-==-0-code.patch
exec-kill-int-depth-in-search_binary_handler.patch
exec-proc_exec_connector-should-be-called-only-once.patch
exec-move-allow_write_access-fput-to-exec_binprm.patch
exec-kill-load_binary-=-null-check-in-search_binary_handler.patch
exec-cleanup-the-config_modules-logic.patch
exec-dont-retry-if-request_module-fails.patch
exec-cleanup-the-error-handling-in-search_binary_handler.patch
linux-next.patch

