From: akpm@linux-foundation.org
Subject: + exec-kill-task_struct-did_exec.patch added to -mm tree
Date: Fri, 22 Nov 2013 14:49:31 -0800
Message-ID: <528fdf7b.NC0WcYMacGOvUUR7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab3KVWtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:49:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, kosaki.motohiro@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com

Subject: + exec-kill-task_struct-did_exec.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,kosaki.motohiro@jp.fujitsu.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:49:31 -0800


The patch titled
     Subject: exec: kill task_struct->did_exec
has been added to the -mm tree.  Its filename is
     exec-kill-task_struct-did_exec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-kill-task_struct-did_exec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-kill-task_struct-did_exec.patch

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
Subject: exec: kill task_struct->did_exec

We can kill either task->did_exec or PF_FORKNOEXEC, they are mutually
exclusive.  The patch kills ->did_exec because it has a single user.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |    1 -
 include/linux/sched.h |    1 -
 kernel/fork.c         |    1 -
 kernel/sys.c          |    5 ++---
 4 files changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/exec.c~exec-kill-task_struct-did_exec fs/exec.c
--- a/fs/exec.c~exec-kill-task_struct-did_exec
+++ a/fs/exec.c
@@ -1424,7 +1424,6 @@ static int exec_binprm(struct linux_binp
 		audit_bprm(bprm);
 		trace_sched_process_exec(current, old_pid, bprm);
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
-		current->did_exec = 1;
 		proc_exec_connector(current);
 	}
 
diff -puN include/linux/sched.h~exec-kill-task_struct-did_exec include/linux/sched.h
--- a/include/linux/sched.h~exec-kill-task_struct-did_exec
+++ a/include/linux/sched.h
@@ -1129,7 +1129,6 @@ struct task_struct {
 	/* Used for emulating ABI behavior of previous Linux versions */
 	unsigned int personality;
 
-	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
 	unsigned in_iowait:1;
diff -puN kernel/fork.c~exec-kill-task_struct-did_exec kernel/fork.c
--- a/kernel/fork.c~exec-kill-task_struct-did_exec
+++ a/kernel/fork.c
@@ -1221,7 +1221,6 @@ static struct task_struct *copy_process(
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
 		goto bad_fork_cleanup_count;
 
-	p->did_exec = 0;
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
 	copy_flags(clone_flags, p);
 	INIT_LIST_HEAD(&p->children);
diff -puN kernel/sys.c~exec-kill-task_struct-did_exec kernel/sys.c
--- a/kernel/sys.c~exec-kill-task_struct-did_exec
+++ a/kernel/sys.c
@@ -895,8 +895,7 @@ SYSCALL_DEFINE1(times, struct tms __user
  * only important on a multi-user system anyway, to make sure one user
  * can't send a signal to a process owned by another.  -TYT, 12/12/91
  *
- * Auch. Had to add the 'did_exec' flag to conform completely to POSIX.
- * LBT 04.03.94
+ * !PF_FORKNOEXEC check to conform completely to POSIX.
  */
 SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 {
@@ -932,7 +931,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid
 		if (task_session(p) != task_session(group_leader))
 			goto out;
 		err = -EACCES;
-		if (p->did_exec)
+		if (!(p->flags & PF_FORKNOEXEC))
 			goto out;
 	} else {
 		err = -ESRCH;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exit_state-kill-task_is_dead.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
fork-no-need-to-initialize-child-exit_state.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
linux-next.patch

