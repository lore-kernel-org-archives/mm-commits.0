From: akpm@linux-foundation.org
Subject: [folded] syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix.patch removed from -mm tree
Date: Thu, 16 Feb 2012 11:48:40 -0800
Message-ID: <20120216194840.A0A35A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:45139 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab2BPTsl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2012 14:48:41 -0500
Received: by qadb12 with SMTP id b12so366230qad.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2012 11:48:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls, x86: Fix __NR_kcmp execve race and potential NULL dereference
has been removed from the -mm tree.  Its filename was
     syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix.patch

This patch was dropped because it was folded into syscalls-x86-add-__nr_kcmp-syscall-v8.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: syscalls, x86: Fix __NR_kcmp execve race and potential NULL dereference

Plain ptrace_may_access() check used in kcmp is not safe against race with
execve(setuid_app), so we need to grab cred_guard_mutex and keep it until
kcmp is finished.

Also task->files may be nil, better to use task_lock and fcheck_files
helpers instead of direct file_lock usage.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcmp.c |   48 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff -puN kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix kernel/kcmp.c
--- a/kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix
+++ a/kernel/kcmp.c
@@ -44,20 +44,38 @@ static int kcmp_ptr(void *v1, void *v2, 
 static struct file *
 get_file_raw_ptr(struct task_struct *task, unsigned int idx)
 {
-	struct fdtable *fdt;
-	struct file *file;
+	struct file *file = NULL;
 
-	spin_lock(&task->files->file_lock);
-	fdt = files_fdtable(task->files);
-	if (idx < fdt->max_fds)
-		file = fdt->fd[idx];
-	else
-		file = NULL;
-	spin_unlock(&task->files->file_lock);
+	task_lock(task);
+	rcu_read_lock();
+
+	if (task->files)
+		file = fcheck_files(task->files, idx);
+
+	rcu_read_unlock();
+	task_unlock(task);
 
 	return file;
 }
 
+static void access_unlock(struct task_struct *task)
+{
+	mutex_unlock(&task->signal->cred_guard_mutex);
+}
+
+static int access_trylock(struct task_struct *task)
+{
+	if (!mutex_trylock(&task->signal->cred_guard_mutex))
+		return -EBUSY;
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		mutex_unlock(&task->signal->cred_guard_mutex);
+		return -EPERM;
+	}
+
+	return 0;
+}
+
 SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
 		unsigned long, idx1, unsigned long, idx2)
 {
@@ -82,11 +100,12 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t
 	/*
 	 * One should have enough rights to inspect task details.
 	 */
-	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
-	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
-		ret = -EACCES;
+	ret = access_trylock(task1);
+	if (ret)
 		goto err;
-	}
+	ret = access_trylock(task2);
+	if (ret)
+		goto err_unlock;
 
 	switch (type) {
 	case KCMP_FILE: {
@@ -130,6 +149,9 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t
 		break;
 	}
 
+	access_unlock(task2);
+err_unlock:
+	access_unlock(task1);
 err:
 	put_task_struct(task1);
 	put_task_struct(task2);
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

