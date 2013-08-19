From: akpm@linux-foundation.org
Subject: + task_work-documentation.patch added to -mm tree
Date: Mon, 19 Aug 2013 14:34:56 -0700
Message-ID: <52128f80.ANi7G8nRfmJjyG7y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3HSVfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 17:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com

Subject: + task_work-documentation.patch added to -mm tree
To: oleg@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 14:34:56 -0700


The patch titled
     Subject: task_work: documentation
has been added to the -mm tree.  Its filename is
     task_work-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/task_work-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/task_work-documentation.patch

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
Subject: task_work: documentation

No functional changes, just comments.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/task_work.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN kernel/task_work.c~task_work-documentation kernel/task_work.c
--- a/kernel/task_work.c~task_work-documentation
+++ a/kernel/task_work.c
@@ -4,6 +4,23 @@
 
 static struct callback_head work_exited; /* all we need is ->next == NULL */
 
+/**
+ * task_work_add - ask the @task to execute @work->func()
+ * @task: the task which should run the callback
+ * @work: the callback to run
+ * @notify: send the notification if true
+ *
+ * Queue @work for task_work_run() below and notify the @task if @notify.
+ * Fails if the @task is exiting/exited and thus it can't process this @work.
+ * Otherwise @work->func() will be called when the @task returns from kernel
+ * mode or exits.
+ *
+ * This is like the signal handler which runs in kernel mode, but it doesn't
+ * try to wake up the @task.
+ *
+ * RETURNS:
+ * 0 if succeeds or -ESRCH.
+ */
 int
 task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
@@ -21,6 +38,17 @@ task_work_add(struct task_struct *task,
 	return 0;
 }
 
+/**
+ * task_work_cancel - cancel a pending work added by task_work_add()
+ * @task: the task which should execute the work
+ * @func: identifies the work to remove
+ *
+ * Find the last queued pending work with ->func == @func and remove
+ * it from queue.
+ *
+ * RETURNS:
+ * The found work or NULL if not found.
+ */
 struct callback_head *
 task_work_cancel(struct task_struct *task, task_work_func_t func)
 {
@@ -46,6 +74,14 @@ task_work_cancel(struct task_struct *tas
 	return work;
 }
 
+/**
+ * task_work_run - execute the works added by task_work_add()
+ *
+ * Flush the pending works. Should be used by the core kernel code.
+ * Called before the task returns to the user-mode or stops, or when
+ * it exits. In the latter case task_work_add() can no longer add the
+ * new work after task_work_run() returns.
+ */
 void task_work_run(void)
 {
 	struct task_struct *task = current;
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

