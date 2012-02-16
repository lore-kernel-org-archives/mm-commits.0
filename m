From: akpm@linux-foundation.org
Subject: [folded] syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix-fix.patch removed from -mm tree
Date: Thu, 16 Feb 2012 11:48:43 -0800
Message-ID: <20120216194843.70F06A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37081 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab2BPTso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2012 14:48:44 -0500
Received: by mail-yw0-f74.google.com with SMTP id m50so338011yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2012 11:48:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls, x86: Make __NR_kcmp to work with equivalent pids
has been removed from the -mm tree.  Its filename was
     syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into syscalls-x86-add-__nr_kcmp-syscall-v8.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: syscalls, x86: Make __NR_kcmp to work with equivalent pids

In case if pid1 is equal to pid2 the kcmp will return -EBUSY, which makes
no sence.  Make it able to work with equivalent pids.  Selftest is
extended as well.

Repored-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcmp.c                            |   37 +++++++++++++--------
 tools/testing/selftests/kcmp/kcmp_test.c |    9 +++++
 2 files changed, 32 insertions(+), 14 deletions(-)

diff -puN kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix-fix kernel/kcmp.c
--- a/kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix-fix
+++ a/kernel/kcmp.c
@@ -58,22 +58,28 @@ get_file_raw_ptr(struct task_struct *tas
 	return file;
 }
 
-static void access_unlock(struct task_struct *task)
+static void kcmp_unlock(struct mutex *m1, struct mutex *m2)
 {
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	if (likely(m2 != m1))
+		mutex_unlock(m2);
+	mutex_unlock(m1);
 }
 
-static int access_trylock(struct task_struct *task)
+static int kcmp_lock(struct mutex *m1, struct mutex *m2)
 {
-	if (!mutex_trylock(&task->signal->cred_guard_mutex))
-		return -EBUSY;
+	int err;
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
-		mutex_unlock(&task->signal->cred_guard_mutex);
-		return -EPERM;
+	if (m2 > m1)
+		swap(m1, m2);
+
+	err = mutex_lock_killable(m1);
+	if (!err && likely(m1 != m2)) {
+		err = mutex_lock_killable_nested(m2, SINGLE_DEPTH_NESTING);
+		if (err)
+			mutex_unlock(m1);
 	}
 
-	return 0;
+	return err;
 }
 
 SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
@@ -100,12 +106,15 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t
 	/*
 	 * One should have enough rights to inspect task details.
 	 */
-	ret = access_trylock(task1);
+	ret = kcmp_lock(&task1->signal->cred_guard_mutex,
+			&task2->signal->cred_guard_mutex);
 	if (ret)
 		goto err;
-	ret = access_trylock(task2);
-	if (ret)
+	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
+	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
+		ret = -EPERM;
 		goto err_unlock;
+	}
 
 	switch (type) {
 	case KCMP_FILE: {
@@ -149,9 +158,9 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t
 		break;
 	}
 
-	access_unlock(task2);
 err_unlock:
-	access_unlock(task1);
+	kcmp_unlock(&task1->signal->cred_guard_mutex,
+		    &task2->signal->cred_guard_mutex);
 err:
 	put_task_struct(task1);
 	put_task_struct(task2);
diff -puN tools/testing/selftests/kcmp/kcmp_test.c~syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix-fix tools/testing/selftests/kcmp/kcmp_test.c
--- a/tools/testing/selftests/kcmp/kcmp_test.c~syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix-fix
+++ a/tools/testing/selftests/kcmp/kcmp_test.c
@@ -76,6 +76,15 @@ int main(int argc, char **argv)
 			ret = -1;
 		} else
 			printf("PASS: 0 returned as expected\n");
+
+		/* Compare with self */
+		ret = sys_kcmp(pid1, pid1, KCMP_VM, 0, 0);
+		if (ret) {
+			printf("FAIL: 0 expected but %li returned\n", ret);
+			ret = -1;
+		} else
+			printf("PASS: 0 returned as expected\n");
+
 		exit(ret);
 	}
 
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

