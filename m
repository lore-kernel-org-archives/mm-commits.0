From: akpm@linux-foundation.org
Subject: +
 oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch added to
 -mm tree
Date: Wed, 03 Dec 2014 13:58:19 -0800
Message-ID: <547f877b.fQOo7k9rg4nbNnze%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaLCV6U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2014 16:58:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mhocko@suse.cz, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2
has been added to the -mm tree.  Its filename is
     oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch

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
Subject: oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2

The patch is basically the same, but as Michal pointed out
mem_cgroup_out_of_memory() can use the new helper too, it can face the
same problems.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    6 ++++++
 mm/memcontrol.c     |    2 +-
 mm/oom_kill.c       |    6 ------
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/oom.h~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2 include/linux/oom.h
--- a/include/linux/oom.h~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2
+++ a/include/linux/oom.h
@@ -87,6 +87,12 @@ static inline void oom_killer_enable(voi
 
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
+static inline bool task_will_free_mem(struct task_struct *task)
+{
+	return (task->flags & PF_EXITING) &&
+		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
+}
+
 /* sysctls */
 extern int sysctl_oom_dump_tasks;
 extern int sysctl_oom_kill_allocating_task;
diff -puN mm/memcontrol.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2
+++ a/mm/memcontrol.c
@@ -1559,7 +1559,7 @@ static void mem_cgroup_out_of_memory(str
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
+	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
diff -puN mm/oom_kill.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2 mm/oom_kill.c
--- a/mm/oom_kill.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2
+++ a/mm/oom_kill.c
@@ -254,12 +254,6 @@ static enum oom_constraint constrained_a
 }
 #endif
 
-static inline bool task_will_free_mem(struct task_struct *task)
-{
-	return (task->flags & PF_EXITING) &&
-		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
-}
-
 enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill)
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
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
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

