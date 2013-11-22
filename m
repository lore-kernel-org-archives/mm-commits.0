From: akpm@linux-foundation.org
Subject: +
 exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
 added to -mm tree
Date: Fri, 22 Nov 2013 14:49:29 -0800
Message-ID: <528fdf79.Jy8eYKkmHaET20UT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3KVWta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:49:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, kosaki.motohiro@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com

Subject: + exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,kosaki.motohiro@jp.fujitsu.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:49:29 -0800


The patch titled
     Subject: exec:check_unsafe_exec: kill the dead -EAGAIN and clear_in_exec logic
has been added to the -mm tree.  Its filename is
     exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch

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
Subject: exec:check_unsafe_exec: kill the dead -EAGAIN and clear_in_exec logic

fs_struct->in_exec == T means that this ->fs is used by a single process
(thread group), and one of the treads does do_execve().

To avoid the mt-exec races this code has the following complications:

	1. check_unsafe_exec() returns -EBUSY if ->in_exec was
	   already set by another thread.

	2. do_execve_common() records "clear_in_exec" to ensure
	   that the error path can only clear ->in_exec if it was
	   set by current.

However, after 9b1bf12d5d51 "signals: move cred_guard_mutex from
task_struct to signal_struct" we do not need these complications:

	1. We can't race with our sub-thread, this is called under
	   per-process ->cred_guard_mutex. And we can't race with
	   another CLONE_FS task, we already checked that this fs
	   is not shared.

	   We can remove the  dead -EAGAIN logic.

	2. "out_unmark:" in do_execve_common() is either called
	   under ->cred_guard_mutex, or after de_thread() which
	   kills other threads, so we can't race with sub-thread
	   which could set ->in_exec. And if ->fs is shared with
	   another process ->in_exec should be false anyway.

	   We can clear in_exec unconditionally.

This also means that check_unsafe_exec() can be void.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff -puN fs/exec.c~exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic fs/exec.c
--- a/fs/exec.c~exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic
+++ a/fs/exec.c
@@ -1223,11 +1223,10 @@ EXPORT_SYMBOL(install_exec_creds);
  * - the caller must hold ->cred_guard_mutex to protect against
  *   PTRACE_ATTACH
  */
-static int check_unsafe_exec(struct linux_binprm *bprm)
+static void check_unsafe_exec(struct linux_binprm *bprm)
 {
 	struct task_struct *p = current, *t;
 	unsigned n_fs;
-	int res = 0;
 
 	if (p->ptrace) {
 		if (p->ptrace & PT_PTRACE_CAP)
@@ -1253,22 +1252,15 @@ static int check_unsafe_exec(struct linu
 	}
 	rcu_read_unlock();
 
-	if (p->fs->users > n_fs) {
+	if (p->fs->users > n_fs)
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
-	} else {
-		res = -EAGAIN;
-		if (!p->fs->in_exec) {
-			p->fs->in_exec = 1;
-			res = 1;
-		}
-	}
+	else
+		p->fs->in_exec = 1;
 	spin_unlock(&p->fs->lock);
-
-	return res;
 }
 
-/* 
- * Fill the binprm structure from the inode. 
+/*
+ * Fill the binprm structure from the inode.
  * Check permissions, then read the first 128 (BINPRM_BUF_SIZE) bytes
  *
  * This may be called multiple times for binary chains (scripts for example).
@@ -1453,7 +1445,6 @@ static int do_execve_common(const char *
 	struct linux_binprm *bprm;
 	struct file *file;
 	struct files_struct *displaced;
-	bool clear_in_exec;
 	int retval;
 
 	/*
@@ -1485,10 +1476,7 @@ static int do_execve_common(const char *
 	if (retval)
 		goto out_free;
 
-	retval = check_unsafe_exec(bprm);
-	if (retval < 0)
-		goto out_free;
-	clear_in_exec = retval;
+	check_unsafe_exec(bprm);
 	current->in_execve = 1;
 
 	file = open_exec(filename);
@@ -1558,8 +1546,7 @@ out_file:
 	}
 
 out_unmark:
-	if (clear_in_exec)
-		current->fs->in_exec = 0;
+	current->fs->in_exec = 0;
 	current->in_execve = 0;
 
 out_free:
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

