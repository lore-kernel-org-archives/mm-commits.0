From: akpm@linux-foundation.org
Subject: + c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch added to -mm tree
Date: Mon, 19 Mar 2012 15:19:37 -0700
Message-ID: <20120319221937.90BB1A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:43821 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab2CSWTi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Mar 2012 18:19:38 -0400
Received: by yhgm50 with SMTP id m50so1093340yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Mar 2012 15:19:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, keescook@chromium.org, kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, oleg@redhat.com, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: c/r: prctl: add ability to set new mm_struct::exe_file
has been added to the -mm tree.  Its filename is
     c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: prctl: add ability to set new mm_struct::exe_file

When we do restore we would like to have a way to setup a former
mm_struct::exe_file so that /proc/pid/exe would point to the original
executable file a process had at checkpoint time.

For this the PR_SET_MM_EXE_FILE code is introduced.  This option takes a
file descriptor which will be set as a source for new /proc/$pid/exe
symlink.

Note it allows to change /proc/$pid/exe iif there are no VM_EXECUTABLE
vmas present for current process, simply because this feature is a special
to C/R and mm::num_exe_file_vmas become meaningless after that.

Also this action is one-shot only.  For security reason we don't allow to
change the symlink several times.

This feature is available iif CONFIG_CHECKPOINT_RESTORE is set.

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
@@ -1710,6 +1712,57 @@ static bool vma_flags_mismatch(struct vm
 		(vma->vm_flags & banned);
 }
 
+static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
+{
+	struct file *exe_file;
+	struct dentry *dentry;
+	int err;
+
+	/*
+	 * Setting new mm::exe_file is only allowed
+	 * when no VM_EXECUTABLE vma's left. So make
+	 * a fast test first.
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
+	 * Because the original mm->exe_file
+	 * points to executable file, make sure
+	 * this one is executable as well to not
+	 * break an overall picture.
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
+	 * For security reason changing mm->exe_file
+	 * is one-shot action.
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
@@ -1724,6 +1777,9 @@ static int prctl_set_mm(int opt, unsigne
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
+	if (opt == PR_SET_MM_EXE_FILE)
+		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
+
 	if (addr >= TASK_SIZE)
 		return -EINVAL;
 
_
Subject: Subject: c/r: prctl: add ability to set new mm_struct::exe_file

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch

