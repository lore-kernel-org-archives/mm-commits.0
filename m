From: akpm@linux-foundation.org
Subject: + proc-use-task_access_lock-instead-of-ptrace_may_access.patch added to -mm tree
Date: Wed, 11 Apr 2012 17:48:06 -0700
Message-ID: <20120412004806.CA333A03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:49888 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2DLAsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Apr 2012 20:48:08 -0400
Received: by mail-ey0-f202.google.com with SMTP id q10so63007eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Apr 2012 17:48:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, adobriyan@gmail.com, hughd@google.com, oleg@redhat.com


The patch titled
     Subject: proc: use task_access_lock() instead of ptrace_may_access()
has been added to the -mm tree.  Its filename is
     proc-use-task_access_lock-instead-of-ptrace_may_access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: proc: use task_access_lock() instead of ptrace_may_access()

There are several places in fs/proc/base.c still use ptrace_may_access()
directly to check the permission, actually this just gets a snapshot of
the permission, nothing prevents the target task from raising the
priviledges itself, it is better to use task_access_lock() for these
places, to hold the priviledges.

Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   74 ++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 41 deletions(-)

diff -puN fs/proc/base.c~proc-use-task_access_lock-instead-of-ptrace_may_access fs/proc/base.c
--- a/fs/proc/base.c~proc-use-task_access_lock-instead-of-ptrace_may_access
+++ a/fs/proc/base.c
@@ -253,6 +253,23 @@ static int proc_pid_auxv(struct task_str
 	return res;
 }
 
+static int task_access_lock(struct task_struct *task, unsigned int mode)
+
+{
+	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (err)
+		return err;
+	if (!ptrace_may_access(task, mode)) {
+		mutex_unlock(&task->signal->cred_guard_mutex);
+		return -EPERM;
+	}
+	return 0;
+}
+
+static void task_access_unlock(struct task_struct *task)
+{
+	mutex_unlock(&task->signal->cred_guard_mutex);
+}
 
 #ifdef CONFIG_KALLSYMS
 /*
@@ -264,35 +281,18 @@ static int proc_pid_wchan(struct task_st
 	unsigned long wchan;
 	char symname[KSYM_NAME_LEN];
 
+	if (task_access_lock(task, PTRACE_MODE_READ))
+		return 0;
 	wchan = get_wchan(task);
 
+	task_access_unlock(task);
 	if (lookup_symbol_name(wchan, symname) < 0)
-		if (!ptrace_may_access(task, PTRACE_MODE_READ))
-			return 0;
-		else
-			return sprintf(buffer, "%lu", wchan);
+		return sprintf(buffer, "%lu", wchan);
 	else
 		return sprintf(buffer, "%s", symname);
 }
 #endif /* CONFIG_KALLSYMS */
 
-static int task_access_lock(struct task_struct *task, unsigned int mode)
-{
-	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
-	if (err)
-		return err;
-	if (!ptrace_may_access(task, mode)) {
-		mutex_unlock(&task->signal->cred_guard_mutex);
-		return -EPERM;
-	}
-	return 0;
-}
-
-static void task_access_unlock(struct task_struct *task)
-{
-	mutex_unlock(&task->signal->cred_guard_mutex);
-}
-
 #ifdef CONFIG_STACKTRACE
 
 #define MAX_STACK_TRACE_DEPTH	64
@@ -512,23 +512,6 @@ static int proc_pid_syscall(struct task_
 /*                       Here the fs part begins                        */
 /************************************************************************/
 
-/* permission checks */
-static int proc_fd_access_allowed(struct inode *inode)
-{
-	struct task_struct *task;
-	int allowed = 0;
-	/* Allow access to a task's file descriptors if it is us or we
-	 * may use ptrace attach to the process and find out that
-	 * information.
-	 */
-	task = get_proc_task(inode);
-	if (task) {
-		allowed = ptrace_may_access(task, PTRACE_MODE_READ);
-		put_task_struct(task);
-	}
-	return allowed;
-}
-
 int proc_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	int error;
@@ -1425,17 +1408,21 @@ static int proc_exe_link(struct dentry *
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
+	struct task_struct *task = get_proc_task(inode);
 	int error = -EACCES;
 
 	/* We don't need a base pointer in the /proc filesystem */
 	path_put(&nd->path);
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
-	if (!proc_fd_access_allowed(inode))
+	error = task_access_lock(task, PTRACE_MODE_READ);
+	if (error)
 		goto out;
 
 	error = PROC_I(inode)->op.proc_get_link(dentry, &nd->path);
+	task_access_unlock(task);
 out:
+	put_task_struct(task);
 	return ERR_PTR(error);
 }
 
@@ -1467,19 +1454,24 @@ static int proc_pid_readlink(struct dent
 {
 	int error = -EACCES;
 	struct inode *inode = dentry->d_inode;
+	struct task_struct *task = get_proc_task(inode);
 	struct path path;
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
-	if (!proc_fd_access_allowed(inode))
+	error = task_access_lock(task, PTRACE_MODE_READ);
+	if (error)
 		goto out;
 
 	error = PROC_I(inode)->op.proc_get_link(dentry, &path);
 	if (error)
-		goto out;
+		goto out_unlock;
 
 	error = do_proc_readlink(&path, buffer, buflen);
 	path_put(&path);
+out_unlock:
+	task_access_unlock(task);
 out:
+	put_task_struct(task);
 	return error;
 }
 
_
Subject: Subject: proc: use task_access_lock() instead of ptrace_may_access()

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

linux-next.patch
cris-select-generic_atomic64.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-unify-ptrace_may_access-locking-code.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-task_access_lock-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch

