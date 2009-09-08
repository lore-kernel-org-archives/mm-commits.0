From: akpm@linux-foundation.org
Subject: [merged] exec-do-not-sleep-in-task_traced-under-cred_guard_mutex.patch removed from -mm tree
Date: Tue, 08 Sep 2009 14:26:10 -0700
Message-ID: <200909082126.n88LQAti006467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbZIHV1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 17:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, jmorris@namei.org, roland@redhat.com, tom.horsley@att.net, mm-commits@vger.kernel.org


The patch titled
     exec: do not sleep in TASK_TRACED under ->cred_guard_mutex
has been removed from the -mm tree.  Its filename was
     exec-do-not-sleep-in-task_traced-under-cred_guard_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: do not sleep in TASK_TRACED under ->cred_guard_mutex
From: Oleg Nesterov <oleg@redhat.com>

Tom Horsley reports that his debugger hangs when it tries to read
/proc/pid_of_tracee/maps, this happens since

	"mm_for_maps: take ->cred_guard_mutex to fix the race with exec"
	04b836cbf19e885f8366bccb2e4b0474346c02d

commit in 2.6.31.

But the root of the problem lies in the fact that do_execve() path calls
tracehook_report_exec() which can stop if the tracer sets PT_TRACE_EXEC.

The tracee must not sleep in TASK_TRACED holding this mutex.  Even if we
remove ->cred_guard_mutex from mm_for_maps() and proc_pid_attr_write(),
another task doing PTRACE_ATTACH should not hang until it is killed or the
tracee resumes.

With this patch do_execve() does not use ->cred_guard_mutex directly and
we do not hold it throughout, instead:

	- introduce prepare_bprm_creds() helper, it locks the mutex
	  and calls prepare_exec_creds() to initialize bprm->cred.

	- install_exec_creds() drops the mutex after commit_creds(),
	  and thus before tracehook_report_exec()->ptrace_stop().

	  or, if exec fails,

	  free_bprm() drops this mutex when bprm->cred != NULL which
	  indicates install_exec_creds() was not called.

Reported-by: Tom Horsley <tom.horsley@att.net>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c             |   17 ++--------
 fs/exec.c               |   63 ++++++++++++++++++++++----------------
 include/linux/binfmts.h |    1 
 3 files changed, 43 insertions(+), 38 deletions(-)

diff -puN fs/compat.c~exec-do-not-sleep-in-task_traced-under-cred_guard_mutex fs/compat.c
--- a/fs/compat.c~exec-do-not-sleep-in-task_traced-under-cred_guard_mutex
+++ a/fs/compat.c
@@ -1485,20 +1485,15 @@ int compat_do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = -ERESTARTNOINTR;
-	if (mutex_lock_interruptible(&current->cred_guard_mutex))
+	retval = prepare_bprm_creds(bprm);
+	if (retval)
 		goto out_free;
-	current->in_execve = 1;
-
-	retval = -ENOMEM;
-	bprm->cred = prepare_exec_creds();
-	if (!bprm->cred)
-		goto out_unlock;
 
 	retval = check_unsafe_exec(bprm);
 	if (retval < 0)
-		goto out_unlock;
+		goto out_free;
 	clear_in_exec = retval;
+	current->in_execve = 1;
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
@@ -1547,7 +1542,6 @@ int compat_do_execve(char * filename,
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_guard_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
 	if (displaced)
@@ -1567,10 +1561,7 @@ out_file:
 out_unmark:
 	if (clear_in_exec)
 		current->fs->in_exec = 0;
-
-out_unlock:
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_guard_mutex);
 
 out_free:
 	free_bprm(bprm);
diff -puN fs/exec.c~exec-do-not-sleep-in-task_traced-under-cred_guard_mutex fs/exec.c
--- a/fs/exec.c~exec-do-not-sleep-in-task_traced-under-cred_guard_mutex
+++ a/fs/exec.c
@@ -1016,6 +1016,35 @@ out:
 EXPORT_SYMBOL(flush_old_exec);
 
 /*
+ * Prepare credentials and lock ->cred_guard_mutex.
+ * install_exec_creds() commits the new creds and drops the lock.
+ * Or, if exec fails before, free_bprm() should release ->cred and
+ * and unlock.
+ */
+int prepare_bprm_creds(struct linux_binprm *bprm)
+{
+	if (mutex_lock_interruptible(&current->cred_guard_mutex))
+		return -ERESTARTNOINTR;
+
+	bprm->cred = prepare_exec_creds();
+	if (likely(bprm->cred))
+		return 0;
+
+	mutex_unlock(&current->cred_guard_mutex);
+	return -ENOMEM;
+}
+
+void free_bprm(struct linux_binprm *bprm)
+{
+	free_arg_pages(bprm);
+	if (bprm->cred) {
+		mutex_unlock(&current->cred_guard_mutex);
+		abort_creds(bprm->cred);
+	}
+	kfree(bprm);
+}
+
+/*
  * install the new credentials for this executable
  */
 void install_exec_creds(struct linux_binprm *bprm)
@@ -1024,12 +1053,13 @@ void install_exec_creds(struct linux_bin
 
 	commit_creds(bprm->cred);
 	bprm->cred = NULL;
-
-	/* cred_guard_mutex must be held at least to this point to prevent
+	/*
+	 * cred_guard_mutex must be held at least to this point to prevent
 	 * ptrace_attach() from altering our determination of the task's
-	 * credentials; any time after this it may be unlocked */
-
+	 * credentials; any time after this it may be unlocked.
+	 */
 	security_bprm_committed_creds(bprm);
+	mutex_unlock(&current->cred_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
 
@@ -1246,14 +1276,6 @@ int search_binary_handler(struct linux_b
 
 EXPORT_SYMBOL(search_binary_handler);
 
-void free_bprm(struct linux_binprm *bprm)
-{
-	free_arg_pages(bprm);
-	if (bprm->cred)
-		abort_creds(bprm->cred);
-	kfree(bprm);
-}
-
 /*
  * sys_execve() executes a new program.
  */
@@ -1277,20 +1299,15 @@ int do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = -ERESTARTNOINTR;
-	if (mutex_lock_interruptible(&current->cred_guard_mutex))
+	retval = prepare_bprm_creds(bprm);
+	if (retval)
 		goto out_free;
-	current->in_execve = 1;
-
-	retval = -ENOMEM;
-	bprm->cred = prepare_exec_creds();
-	if (!bprm->cred)
-		goto out_unlock;
 
 	retval = check_unsafe_exec(bprm);
 	if (retval < 0)
-		goto out_unlock;
+		goto out_free;
 	clear_in_exec = retval;
+	current->in_execve = 1;
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
@@ -1340,7 +1357,6 @@ int do_execve(char * filename,
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_guard_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
 	if (displaced)
@@ -1360,10 +1376,7 @@ out_file:
 out_unmark:
 	if (clear_in_exec)
 		current->fs->in_exec = 0;
-
-out_unlock:
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_guard_mutex);
 
 out_free:
 	free_bprm(bprm);
diff -puN include/linux/binfmts.h~exec-do-not-sleep-in-task_traced-under-cred_guard_mutex include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-do-not-sleep-in-task_traced-under-cred_guard_mutex
+++ a/include/linux/binfmts.h
@@ -117,6 +117,7 @@ extern int setup_arg_pages(struct linux_
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
+extern int prepare_bprm_creds(struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
 extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
 extern int set_binfmt(struct linux_binfmt *new);
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

