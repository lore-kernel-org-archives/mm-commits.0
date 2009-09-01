From: akpm@linux-foundation.org
Subject: + do_wait-wakeup-optimization-simplify-task_pid_type.patch added to -mm tree
Date: Tue, 01 Sep 2009 15:20:58 -0700
Message-ID: <200909012220.n81MKw3X004570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236AbZIAWVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 18:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, roland@redhat.com


The patch titled
     do_wait-wakeup-optimization: simplify task_pid_type()
has been added to the -mm tree.  Its filename is
     do_wait-wakeup-optimization-simplify-task_pid_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait-wakeup-optimization: simplify task_pid_type()
From: Oleg Nesterov <oleg@redhat.com>

task_pid_type() is only used by eligible_pid() which has to check wo_type
!= PIDTYPE_MAX anyway.  Remove this check from task_pid_type() and factor
out ->pids[type] access, this shrinks .text a bit and simplifies the code.

The matches the behaviour of other similar helpers, say get_task_pid(). 
The caller must ensure that pid_type is valid, not the callee.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~do_wait-wakeup-optimization-simplify-task_pid_type kernel/exit.c
--- a/kernel/exit.c~do_wait-wakeup-optimization-simplify-task_pid_type
+++ a/kernel/exit.c
@@ -1096,17 +1096,15 @@ struct wait_opts {
 	int			notask_error;
 };
 
-static struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
+static inline
+struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
 {
-	struct pid *pid = NULL;
-	if (type == PIDTYPE_PID)
-		pid = task->pids[type].pid;
-	else if (type < PIDTYPE_MAX)
-		pid = task->group_leader->pids[type].pid;
-	return pid;
+	if (type != PIDTYPE_PID)
+		task = task->group_leader;
+	return task->pids[type].pid;
 }
 
-static inline int eligible_pid(struct wait_opts *wo, struct task_struct *p)
+static int eligible_pid(struct wait_opts *wo, struct task_struct *p)
 {
 	return	wo->wo_type == PIDTYPE_MAX ||
 		task_pid_type(p, wo->wo_type) == wo->wo_pid;
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
cgroups-revert-cgroups-fix-pid-namespace-bug.patch
cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
fcntl-add-f_etown_ex.patch
signals-inline-__fatal_signal_pending.patch
signals-tracehook_notify_jctl-change.patch
signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
signals-introduce-tracehook_finish_jctl-helper.patch
utrace-core.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

