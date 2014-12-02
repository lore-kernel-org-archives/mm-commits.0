From: akpm@linux-foundation.org
Subject: +
 oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
 added to -mm tree
Date: Mon, 01 Dec 2014 16:34:45 -0800
Message-ID: <547d0925.U+IXeI4AAgb4+Ehp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbaLBAeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2014 19:34:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mhocko@suse.cz, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: kill the insufficient and no longer needed PT_TRACE_EXIT check
has been added to the -mm tree.  Its filename is
     oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch

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
Subject: oom: kill the insufficient and no longer needed PT_TRACE_EXIT check

After the previous patch we can remove the PT_TRACE_EXIT check in
oom_scan_process_thread(), it was added to handle the case when the
coredumping was "frozen" by ptrace, but it doesn't really work.  If
nothing else, we would need to check all threads which could share the
same ->mm to make it more or less correct.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN mm/oom_kill.c~oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check
+++ a/mm/oom_kill.c
@@ -287,14 +287,9 @@ enum oom_scan_t oom_scan_process_thread(
 	if (oom_task_origin(task))
 		return OOM_SCAN_SELECT;
 
-	if (task_will_free_mem(task) && !force_kill) {
-		/*
-		 * If this task is not being ptraced on exit, then wait for it
-		 * to finish before killing some other task unnecessarily.
-		 */
-		if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
-			return OOM_SCAN_ABORT;
-	}
+	if (task_will_free_mem(task) && !force_kill)
+		return OOM_SCAN_ABORT;
+
 	return OOM_SCAN_OK;
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

