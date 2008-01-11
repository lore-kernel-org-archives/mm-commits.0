From: akpm@linux-foundation.org
Subject: + remove-task_ppid_nr_ns.patch added to -mm tree
Date: Thu, 10 Jan 2008 16:12:10 -0800
Message-ID: <200801110012.m0B0CAWd017042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731AbYAKAN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 19:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ebiederm@xmission.com, oleg@tv-sign.ru


The patch titled
     remove task_ppid_nr_ns
has been added to the -mm tree.  Its filename is
     remove-task_ppid_nr_ns.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove task_ppid_nr_ns
From: Roland McGrath <roland@redhat.com>

task_ppid_nr_ns is called in three places.  One of these should never have
called it.  In the other two, using it broke the existing semantics.  This
was presumably accidental.  If the function had not been there, it would
have been much more obvious to the eye that those patches were changing the
behavior.  We don't need this function.

In task_state, the pid of the ptracer is not the ppid of the ptracer.

In do_task_stat, ppid is the tgid of the real_parent, not its pid.  I also
moved the call outside of lock_task_sighand, since it doesn't need it.

In sys_getppid, ppid is the tgid of the real_parent, not its pid.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c       |    4 ++--
 include/linux/sched.h |   13 -------------
 kernel/timer.c        |    2 +-
 3 files changed, 3 insertions(+), 16 deletions(-)

diff -puN fs/proc/array.c~remove-task_ppid_nr_ns fs/proc/array.c
--- a/fs/proc/array.c~remove-task_ppid_nr_ns
+++ a/fs/proc/array.c
@@ -168,7 +168,7 @@ static inline void task_state(struct seq
 	ppid = pid_alive(p) ?
 		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
 	tpid = pid_alive(p) && p->ptrace ?
-		task_ppid_nr_ns(rcu_dereference(p->parent), ns) : 0;
+		task_pid_nr_ns(rcu_dereference(p->parent), ns) : 0;
 	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
@@ -426,6 +426,7 @@ static int do_task_stat(struct seq_file 
 	cgtime = gtime = cputime_zero;
 
 	rcu_read_lock();
+	ppid = task_tgid_nr_ns(task->real_parent, ns);
 	if (lock_task_sighand(task, &flags)) {
 		struct signal_struct *sig = task->signal;
 
@@ -465,7 +466,6 @@ static int do_task_stat(struct seq_file 
 
 		sid = task_session_nr_ns(task, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
-		ppid = task_ppid_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);
 	}
diff -puN include/linux/sched.h~remove-task_ppid_nr_ns include/linux/sched.h
--- a/include/linux/sched.h~remove-task_ppid_nr_ns
+++ a/include/linux/sched.h
@@ -1325,13 +1325,6 @@ struct pid_namespace;
  *
  * set_task_vxid()   : assigns a virtual id to a task;
  *
- * task_ppid_nr_ns() : the parent's id as seen from the namespace specified.
- *                     the result depends on the namespace and whether the
- *                     task in question is the namespace's init. e.g. for the
- *                     namespace's init this will return 0 when called from
- *                     the namespace of this init, or appropriate id otherwise.
- *
- *
  * see also pid_nr() etc in include/linux/pid.h
  */
 
@@ -1387,12 +1380,6 @@ static inline pid_t task_session_vnr(str
 }
 
 
-static inline pid_t task_ppid_nr_ns(struct task_struct *tsk,
-		struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_pid(rcu_dereference(tsk->real_parent)), ns);
-}
-
 /**
  * pid_alive - check that a task structure is not stale
  * @p: Task structure to be checked.
diff -puN kernel/timer.c~remove-task_ppid_nr_ns kernel/timer.c
--- a/kernel/timer.c~remove-task_ppid_nr_ns
+++ a/kernel/timer.c
@@ -978,7 +978,7 @@ asmlinkage long sys_getppid(void)
 	int pid;
 
 	rcu_read_lock();
-	pid = task_ppid_nr_ns(current, current->nsproxy->pid_ns);
+	pid = task_tgid_nr_ns(current->real_parent, current->nsproxy->pid_ns);
 	rcu_read_unlock();
 
 	return pid;
_

Patches currently in -mm which might be from roland@redhat.com are

get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
git-s390.patch
git-x86.patch
use-__set_task_state-for-traced-stopped-tasks.patch
do_wait-remove-one-else-if-branch.patch
add-arch_ptrace_stop.patch
proc-fix-the-threaded-proc-self.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
do_wait-factor-out-retval-=-0-checks.patch
ptrace_stop-fix-racy-nonstop_code-setting.patch
wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
do_wait-cleanup-delay_group_leader-usage.patch
do_wait-fix-security-checks.patch
do_wait-fix-security-checks-fix.patch
wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
fix-group-stop-with-exit-race.patch
sys_setsid-remove-now-unneeded-session-=-1-check.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
linux-kernel-markers-create-modpost-file.patch
core-dump-real_parent-ppid.patch
acct-real_parent-ppid.patch
asm-posix_typesh-scrub-__glibc__.patch
remove-task_ppid_nr_ns.patch
