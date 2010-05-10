From: akpm@linux-foundation.org
Subject: + pids-fix-fork_idle-to-setup-pids-correctly.patch added to -mm tree
Date: Mon, 10 May 2010 14:08:03 -0700
Message-ID: <201005102108.o4AL84rE022765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845Ab0EJVIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 17:08:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, Mathias.Krause@secunet.com, clg@fr.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, roland@redhat.com, serue@us.ibm.com, sukadev@us.ibm.com


The patch titled
     pids: fix fork_idle() to setup ->pids correctly
has been added to the -mm tree.  Its filename is
     pids-fix-fork_idle-to-setup-pids-correctly.patch

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
Subject: pids: fix fork_idle() to setup ->pids correctly
From: Oleg Nesterov <oleg@redhat.com>

copy_process(pid => &init_struct_pid) doesn't do attach_pid/etc.

It shouldn't, but this means that the idle threads run with the wrong
pids copied from the caller's task_struct. In x86 case the caller is
either kernel_init() thread or keventd.

In particular, this means that after the series of cpu_up/cpu_down an
idle thread (which never exits) can run with .pid pointing to nowhere.

Change fork_idle() to initialize idle->pids[] correctly. We only set
.pid = &init_struct_pid but do not add .node to list, INIT_TASK() does
the same for the boot-cpu idle thread (swapper).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Mathias Krause <Mathias.Krause@secunet.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN kernel/fork.c~pids-fix-fork_idle-to-setup-pids-correctly kernel/fork.c
--- a/kernel/fork.c~pids-fix-fork_idle-to-setup-pids-correctly
+++ a/kernel/fork.c
@@ -1340,6 +1340,16 @@ noinline struct pt_regs * __cpuinit __at
 	return regs;
 }
 
+static inline void init_idle_pids(struct pid_link *links)
+{
+	enum pid_type type;
+
+	for (type = PIDTYPE_PID; type < PIDTYPE_MAX; ++type) {
+		INIT_HLIST_NODE(&links[type].node); /* not really needed */
+		links[type].pid = &init_struct_pid;
+	}
+}
+
 struct task_struct * __cpuinit fork_idle(int cpu)
 {
 	struct task_struct *task;
@@ -1347,8 +1357,10 @@ struct task_struct * __cpuinit fork_idle
 
 	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL,
 			    &init_struct_pid, 0);
-	if (!IS_ERR(task))
+	if (!IS_ERR(task)) {
+		init_idle_pids(task->pids);
 		init_idle(task, cpu);
+	}
 
 	return task;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-select_bad_process-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
oom-select_bad_process-never-choose-tasks-with-badness-==-0.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
call_usermodehelper-no-need-to-unblock-signals.patch
wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free.patch
call_usermodehelper-simplify-fix-umh_no_wait-case.patch
call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
exit-exit_notify-can-trust-signal-notify_count-0.patch
exit-change-zap_other_threads-to-count-sub-threads.patch
exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization.patch
exit-avoid-sig-count-in-__exit_signal-to-detect-the-group-dead-case.patch
posix-cpu-timers-avoid-task-signal-=-null-checks.patch
ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks.patch
fork-exit-move-tty_kref_put-outside-of-__cleanup_signal.patch
signals-make-task_struct-signal-immutable-refcountable.patch
signals-clear-signal-tty-when-the-last-thread-exits.patch
signals-clear-signal-tty-when-the-last-thread-exits-fix.patch
signals-kill-the-awful-task_rq_unlock_wait-hack.patch
exit-__exit_signal-use-thread_group_leader-consistently.patch
kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers.patch
exit-move-taskstats_tgid_free-from-__exit_signal-to-free_signal_struct.patch
check_unshare_flags-kill-the-bogus-clone_sighand-sig-count-check.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
proc-turn-signal_struct-count-into-int-nr_threads.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
proc-cleanup-remove-unused-assignments.patch
init_task-should-initialize-thread_group-list.patch
pids-init_struct_pidtasks-should-never-see-the-swapper-process.patch
pids-fix-fork_idle-to-setup-pids-correctly.patch
init_sighand-use-sig_dfl-instead-of-null.patch

