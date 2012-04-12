From: akpm@linux-foundation.org
Subject: + proc-unify-ptrace_may_access-locking-code.patch added to -mm tree
Date: Wed, 11 Apr 2012 17:47:57 -0700
Message-ID: <20120412004757.E5D53A03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:38565 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2DLAr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Apr 2012 20:47:59 -0400
Received: by qcsp5 with SMTP id p5so195876qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Apr 2012 17:47:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, adobriyan@gmail.com, hughd@google.com, oleg@redhat.com


The patch titled
     Subject: proc: unify ptrace_may_access() locking code
has been added to the -mm tree.  Its filename is
     proc-unify-ptrace_may_access-locking-code.patch

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
Subject: proc: unify ptrace_may_access() locking code

Unify mutex_lock+ptrace_may_access code and rename lock_trace() to
task_access_lock(), which better describes what it does.

Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff -puN fs/proc/base.c~proc-unify-ptrace_may_access-locking-code fs/proc/base.c
--- a/fs/proc/base.c~proc-unify-ptrace_may_access-locking-code
+++ a/fs/proc/base.c
@@ -281,19 +281,19 @@ static int proc_pid_wchan(struct task_st
 }
 #endif /* CONFIG_KALLSYMS */
 
-static int lock_trace(struct task_struct *task)
+static int task_access_lock(struct task_struct *task, unsigned int mode)
 {
 	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
 	if (err)
 		return err;
-	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
+	if (!ptrace_may_access(task, mode)) {
 		mutex_unlock(&task->signal->cred_guard_mutex);
 		return -EPERM;
 	}
 	return 0;
 }
 
-static void unlock_trace(struct task_struct *task)
+static void task_access_unlock(struct task_struct *task)
 {
 	mutex_unlock(&task->signal->cred_guard_mutex);
 }
@@ -319,7 +319,7 @@ static int proc_pid_stack(struct seq_fil
 	trace.entries		= entries;
 	trace.skip		= 0;
 
-	err = lock_trace(task);
+	err = task_access_lock(task, PTRACE_MODE_ATTACH);
 	if (!err) {
 		save_stack_trace_tsk(task, &trace);
 
@@ -327,7 +327,7 @@ static int proc_pid_stack(struct seq_fil
 			seq_printf(m, "[<%pK>] %pS\n",
 				   (void *)entries[i], (void *)entries[i]);
 		}
-		unlock_trace(task);
+		task_access_unlock(task);
 	}
 	kfree(entries);
 
@@ -494,7 +494,7 @@ static int proc_pid_syscall(struct task_
 {
 	long nr;
 	unsigned long args[6], sp, pc;
-	int res = lock_trace(task);
+	int res = task_access_lock(task, PTRACE_MODE_ATTACH);
 	if (res)
 		return res;
 
@@ -508,7 +508,7 @@ static int proc_pid_syscall(struct task_
 		       nr,
 		       args[0], args[1], args[2], args[3], args[4], args[5],
 		       sp, pc);
-	unlock_trace(task);
+	task_access_unlock(task);
 	return res;
 }
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
@@ -2180,7 +2180,7 @@ static struct dentry *proc_map_files_loo
 		goto out;
 
 	result = ERR_PTR(-EACCES);
-	if (lock_trace(task))
+	if (task_access_lock(task, PTRACE_MODE_ATTACH))
 		goto out_put_task;
 
 	result = ERR_PTR(-ENOENT);
@@ -2202,7 +2202,7 @@ out_no_vma:
 	up_read(&mm->mmap_sem);
 	mmput(mm);
 out_unlock:
-	unlock_trace(task);
+	task_access_unlock(task);
 out_put_task:
 	put_task_struct(task);
 out:
@@ -2236,7 +2236,7 @@ proc_map_files_readdir(struct file *filp
 		goto out;
 
 	ret = -EACCES;
-	if (lock_trace(task))
+	if (task_access_lock(task, PTRACE_MODE_ATTACH))
 		goto out_put_task;
 
 	ret = 0;
@@ -2336,7 +2336,7 @@ proc_map_files_readdir(struct file *filp
 	}
 
 out_unlock:
-	unlock_trace(task);
+	task_access_unlock(task);
 out_put_task:
 	put_task_struct(task);
 out:
@@ -2897,15 +2897,10 @@ static int do_io_accounting(struct task_
 	unsigned long flags;
 	int result;
 
-	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	result = task_access_lock(task, PTRACE_MODE_READ);
 	if (result)
 		return result;
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
-		result = -EACCES;
-		goto out_unlock;
-	}
-
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
 
@@ -2930,8 +2925,7 @@ static int do_io_accounting(struct task_
 			(unsigned long long)acct.read_bytes,
 			(unsigned long long)acct.write_bytes,
 			(unsigned long long)acct.cancelled_write_bytes);
-out_unlock:
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	task_access_unlock(task);
 	return result;
 }
 
@@ -2949,10 +2943,10 @@ static int proc_tgid_io_accounting(struc
 static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task)
 {
-	int err = lock_trace(task);
+	int err = task_access_lock(task, PTRACE_MODE_ATTACH);
 	if (!err) {
 		seq_printf(m, "%08x\n", task->personality);
-		unlock_trace(task);
+		task_access_unlock(task);
 	}
 	return err;
 }
_
Subject: Subject: proc: unify ptrace_may_access() locking code

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

linux-next.patch
cris-select-generic_atomic64.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-unify-ptrace_may_access-locking-code.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-task_access_lock-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch

