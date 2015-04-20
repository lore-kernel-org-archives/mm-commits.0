From: akpm@linux-foundation.org
Subject: [merged]
 prctl-avoid-using-mmap_sem-for-exe_file-serialization.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:19:53 -0700
Message-ID: <55355159.XK6wZ0HhArjlrTXo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbDTTNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, khlebnikov@yandex-team.ru, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: avoid using mmap_sem for exe_file serialization
has been removed from the -mm tree.  Its filename was
     prctl-avoid-using-mmap_sem-for-exe_file-serialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: prctl: avoid using mmap_sem for exe_file serialization

Oleg cleverly suggested using xchg() to set the new mm->exe_file instead
of calling set_mm_exe_file() which requires some form of serialization --
mmap_sem in this case.  For archs that do not have atomic rmw instructions
we still fallback to a spinlock alternative, so this should always be
safe.  As such, we only need the mmap_sem for looking up the backing
vm_file, which can be done sharing the lock.  Naturally, this means we
need to manually deal with both the new and old file reference counting,
and we need not worry about the MMF_EXE_FILE_CHANGED bits, which can
probably be deleted in the future anyway.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    6 ++++++
 kernel/fork.c |   19 +++++++++++++------
 kernel/sys.c  |   47 ++++++++++++++++++++++++++++-------------------
 3 files changed, 47 insertions(+), 25 deletions(-)

diff -puN fs/exec.c~prctl-avoid-using-mmap_sem-for-exe_file-serialization fs/exec.c
--- a/fs/exec.c~prctl-avoid-using-mmap_sem-for-exe_file-serialization
+++ a/fs/exec.c
@@ -1078,7 +1078,13 @@ int flush_old_exec(struct linux_binprm *
 	if (retval)
 		goto out;
 
+	/*
+	 * Must be called _before_ exec_mmap() as bprm->mm is
+	 * not visibile until then. This also enables the update
+	 * to be lockless.
+	 */
 	set_mm_exe_file(bprm->mm, bprm->file);
+
 	/*
 	 * Release all of the old mmap stuff
 	 */
diff -puN kernel/fork.c~prctl-avoid-using-mmap_sem-for-exe_file-serialization kernel/fork.c
--- a/kernel/fork.c~prctl-avoid-using-mmap_sem-for-exe_file-serialization
+++ a/kernel/fork.c
@@ -711,15 +711,22 @@ EXPORT_SYMBOL_GPL(mmput);
  *
  * This changes mm's executable file (shown as symlink /proc/[pid]/exe).
  *
- * Main users are mmput(), sys_execve() and sys_prctl(PR_SET_MM_MAP/EXE_FILE).
- * Callers prevent concurrent invocations: in mmput() nobody alive left,
- * in execve task is single-threaded, prctl holds mmap_sem exclusively.
+ * Main users are mmput() and sys_execve(). Callers prevent concurrent
+ * invocations: in mmput() nobody alive left, in execve task is single
+ * threaded. sys_prctl(PR_SET_MM_MAP/EXE_FILE) also needs to set the
+ * mm->exe_file, but does so without using set_mm_exe_file() in order
+ * to do avoid the need for any locks.
  */
 void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file)
 {
-	struct file *old_exe_file = rcu_dereference_protected(mm->exe_file,
-			!atomic_read(&mm->mm_users) || current->in_execve ||
-			lockdep_is_held(&mm->mmap_sem));
+	struct file *old_exe_file;
+
+	/*
+	 * It is safe to dereference the exe_file without RCU as
+	 * this function is only called if nobody else can access
+	 * this mm -- see comment above for justification.
+	 */
+	old_exe_file = rcu_dereference_raw(mm->exe_file);
 
 	if (new_exe_file)
 		get_file(new_exe_file);
diff -puN kernel/sys.c~prctl-avoid-using-mmap_sem-for-exe_file-serialization kernel/sys.c
--- a/kernel/sys.c~prctl-avoid-using-mmap_sem-for-exe_file-serialization
+++ a/kernel/sys.c
@@ -1649,14 +1649,13 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
-static int prctl_set_mm_exe_file_locked(struct mm_struct *mm, unsigned int fd)
+static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
 	struct fd exe;
+	struct file *old_exe, *exe_file;
 	struct inode *inode;
 	int err;
 
-	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
-
 	exe = fdget(fd);
 	if (!exe.file)
 		return -EBADF;
@@ -1680,15 +1679,22 @@ static int prctl_set_mm_exe_file_locked(
 	/*
 	 * Forbid mm->exe_file change if old file still mapped.
 	 */
+	exe_file = get_mm_exe_file(mm);
 	err = -EBUSY;
-	if (mm->exe_file) {
+	if (exe_file) {
 		struct vm_area_struct *vma;
 
-		for (vma = mm->mmap; vma; vma = vma->vm_next)
-			if (vma->vm_file &&
-			    path_equal(&vma->vm_file->f_path,
-				       &mm->exe_file->f_path))
-				goto exit;
+		down_read(&mm->mmap_sem);
+		for (vma = mm->mmap; vma; vma = vma->vm_next) {
+			if (!vma->vm_file)
+				continue;
+			if (path_equal(&vma->vm_file->f_path,
+				       &exe_file->f_path))
+				goto exit_err;
+		}
+
+		up_read(&mm->mmap_sem);
+		fput(exe_file);
 	}
 
 	/*
@@ -1702,10 +1708,18 @@ static int prctl_set_mm_exe_file_locked(
 		goto exit;
 
 	err = 0;
-	set_mm_exe_file(mm, exe.file);	/* this grabs a reference to exe.file */
+	/* set the new file, lockless */
+	get_file(exe.file);
+	old_exe = xchg(&mm->exe_file, exe.file);
+	if (old_exe)
+		fput(old_exe);
 exit:
 	fdput(exe);
 	return err;
+exit_err:
+	up_read(&mm->mmap_sem);
+	fput(exe_file);
+	goto exit;
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
@@ -1840,10 +1854,9 @@ static int prctl_set_mm_map(int opt, con
 		user_auxv[AT_VECTOR_SIZE - 1] = AT_NULL;
 	}
 
-	down_write(&mm->mmap_sem);
 	if (prctl_map.exe_fd != (u32)-1)
-		error = prctl_set_mm_exe_file_locked(mm, prctl_map.exe_fd);
-	downgrade_write(&mm->mmap_sem);
+		error = prctl_set_mm_exe_file(mm, prctl_map.exe_fd);
+	down_read(&mm->mmap_sem);
 	if (error)
 		goto out;
 
@@ -1909,12 +1922,8 @@ static int prctl_set_mm(int opt, unsigne
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
-	if (opt == PR_SET_MM_EXE_FILE) {
-		down_write(&mm->mmap_sem);
-		error = prctl_set_mm_exe_file_locked(mm, (unsigned int)addr);
-		up_write(&mm->mmap_sem);
-		return error;
-	}
+	if (opt == PR_SET_MM_EXE_FILE)
+		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
 
 	if (addr >= TASK_SIZE || addr < mmap_min_addr)
 		return -EINVAL;
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch
linux-next.patch

