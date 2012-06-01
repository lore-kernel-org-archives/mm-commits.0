From: akpm@linux-foundation.org
Subject: [merged] c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:35:32 -0700
Message-ID: <20120601193532.8DB30A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:34132 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395Ab2FATfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:35:33 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so93380qab.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:35:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, keescook@chromium.org, kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, oleg@redhat.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: prctl: add ability to set new mm_struct::exe_file
has been removed from the -mm tree.  Its filename was
     c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: prctl: add ability to set new mm_struct::exe_file

When we do restore we would like to have a way to setup a former
mm_struct::exe_file so that /proc/pid/exe would point to the original
executable file a process had at checkpoint time.

For this the PR_SET_MM_EXE_FILE code is introduced.  This option takes a
file descriptor which will be set as a source for new /proc/$pid/exe
symlink.

Note it allows to change /proc/$pid/exe if there are no VM_EXECUTABLE
vmas present for current process, simply because this feature is a special
to C/R and mm::num_exe_file_vmas become meaningless after that.

To minimize the amount of transition the /proc/pid/exe symlink might have,
this feature is implemented in one-shot manner.  Thus once changed the
symlink can't be changed again.  This should help sysadmins to monitor the
symlinks over all process running in a system.

In particular one could make a snapshot of processes and ring alarm if
there unexpected changes of /proc/pid/exe's in a system.

Note -- this feature is available iif CONFIG_CHECKPOINT_RESTORE is set and
the caller must have CAP_SYS_RESOURCE capability granted, otherwise the
request to change symlink will be rejected.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prctl.h |    1 
 kernel/sys.c          |   56 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff -puN include/linux/prctl.h~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file include/linux/prctl.h
--- a/include/linux/prctl.h~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file
+++ a/include/linux/prctl.h
@@ -118,6 +118,7 @@
 # define PR_SET_MM_ENV_START		10
 # define PR_SET_MM_ENV_END		11
 # define PR_SET_MM_AUXV			12
+# define PR_SET_MM_EXE_FILE		13
 
 /*
  * Set specific pid that is allowed to ptrace the current task.
diff -puN kernel/sys.c~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file
+++ a/kernel/sys.c
@@ -36,6 +36,8 @@
 #include <linux/personality.h>
 #include <linux/ptrace.h>
 #include <linux/fs_struct.h>
+#include <linux/file.h>
+#include <linux/mount.h>
 #include <linux/gfp.h>
 #include <linux/syscore_ops.h>
 #include <linux/version.h>
@@ -1792,6 +1794,57 @@ static bool vma_flags_mismatch(struct vm
 		(vma->vm_flags & banned);
 }
 
+static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
+{
+	struct file *exe_file;
+	struct dentry *dentry;
+	int err;
+
+	/*
+	 * Setting new mm::exe_file is only allowed when no VM_EXECUTABLE vma's
+	 * remain. So perform a quick test first.
+	 */
+	if (mm->num_exe_file_vmas)
+		return -EBUSY;
+
+	exe_file = fget(fd);
+	if (!exe_file)
+		return -EBADF;
+
+	dentry = exe_file->f_path.dentry;
+
+	/*
+	 * Because the original mm->exe_file points to executable file, make
+	 * sure that this one is executable as well, to avoid breaking an
+	 * overall picture.
+	 */
+	err = -EACCES;
+	if (!S_ISREG(dentry->d_inode->i_mode)	||
+	    exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
+		goto exit;
+
+	err = inode_permission(dentry->d_inode, MAY_EXEC);
+	if (err)
+		goto exit;
+
+	/*
+	 * The symlink can be changed only once, just to disallow arbitrary
+	 * transitions malicious software might bring in. This means one
+	 * could make a snapshot over all processes running and monitor
+	 * /proc/pid/exe changes to notice unusual activity if needed.
+	 */
+	down_write(&mm->mmap_sem);
+	if (likely(!mm->exe_file))
+		set_mm_exe_file(mm, exe_file);
+	else
+		err = -EBUSY;
+	up_write(&mm->mmap_sem);
+
+exit:
+	fput(exe_file);
+	return err;
+}
+
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
@@ -1806,6 +1859,9 @@ static int prctl_set_mm(int opt, unsigne
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
+	if (opt == PR_SET_MM_EXE_FILE)
+		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
+
 	if (addr >= TASK_SIZE)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

