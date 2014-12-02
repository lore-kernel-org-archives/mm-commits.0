From: akpm@linux-foundation.org
Subject: + oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
 added to -mm tree
Date: Mon, 01 Dec 2014 16:34:43 -0800
Message-ID: <547d0923.Hum+3MtnI/VaJdLj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaLBAeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2014 19:34:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mhocko@suse.cz, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: don't assume that a coredumping thread will exit soon
has been added to the -mm tree.  Its filename is
     oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch

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
Subject: oom: don't assume that a coredumping thread will exit soon

oom_kill.c assumes that PF_EXITING task should exit and free the memory
soon.  This is wrong in many ways and one important case is the coredump. 
A task can sleep in exit_mm() "forever" while the coredumping sub-thread
can need more memory.

Change the PF_EXITING checks to take SIGNAL_GROUP_COREDUMP into account,
we add the new trivial helper for that.

Note: this is only the first step, this patch doesn't try to solve other
problems.  For example it doesn't try to clear the wrongly set TIF_MEMDIE
(SIGNAL_GROUP_COREDUMP check is obviously racy), fatal_signal_pending()
can be false positive, etc.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon mm/oom_kill.c
--- a/mm/oom_kill.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon
+++ a/mm/oom_kill.c
@@ -254,6 +254,12 @@ static enum oom_constraint constrained_a
 }
 #endif
 
+static inline bool task_will_free_mem(struct task_struct *task)
+{
+	return (task->flags & PF_EXITING) &&
+		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
+}
+
 enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill)
@@ -281,7 +287,7 @@ enum oom_scan_t oom_scan_process_thread(
 	if (oom_task_origin(task))
 		return OOM_SCAN_SELECT;
 
-	if (task->flags & PF_EXITING && !force_kill) {
+	if (task_will_free_mem(task) && !force_kill) {
 		/*
 		 * If this task is not being ptraced on exit, then wait for it
 		 * to finish before killing some other task unnecessarily.
@@ -443,7 +449,7 @@ void oom_kill_process(struct task_struct
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
-	if (p->flags & PF_EXITING) {
+	if (task_will_free_mem(p)) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
 		put_task_struct(p);
 		return;
@@ -649,7 +655,7 @@ void out_of_memory(struct zonelist *zone
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
+	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
proc-task_state-read-cred-group_info-outside-of-task_lock.patch
proc-task_state-deuglify-the-max_fds-calculation.patch
proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch
proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch
sched_show_task-fix-unsafe-usage-of-real_parent.patch
exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch
exit-reparent-cleanup-the-changing-of-parent.patch
exit-reparent-cleanup-the-changing-of-parent-fix.patch
exit-reparent-cleanup-the-usage-of-reparent_leader.patch
exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
exit-wait-cleanup-the-ptrace_reparented-checks.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch
exit-wait-dont-use-zombie-real_parent.patch
exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch
exit-release_task-fix-the-comment-about-group-leader-accounting.patch
exit-proc-dont-try-to-flush-proc-tgid-task-tgid.patch
exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting.patch
exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting.patch
exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch
exit-reparent-document-the-has_child_subreaper-checks.patch
exit-reparent-introduce-find_child_reaper.patch
exit-reparent-introduce-find_alive_thread.patch
exit-reparent-avoid-find_new_reaper-if-no-children.patch
exit-reparent-call-forget_original_parent-under-tasklist_lock.patch
exit-exit_notify-re-use-dead-list-to-autoreap-current.patch
exit-pidns-alloc_pid-leaks-pid_namespace-if-child_reaper-is-exiting.patch
exit-pidns-fix-update-the-comments-in-zap_pid_ns_processes.patch
linux-next.patch

