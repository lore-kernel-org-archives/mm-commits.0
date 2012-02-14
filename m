From: akpm@linux-foundation.org
Subject: + c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch added to -mm tree
Date: Tue, 14 Feb 2012 15:15:47 -0800
Message-ID: <20120214231548.0B309A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:54208 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab2BNXPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 18:15:49 -0500
Received: by ggnp1 with SMTP id p1so67578ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 15:15:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, avagin@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, mtk.manpages@gmail.com, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: c/r: prctl: extend PR_SET_MM to set up more mm_struct entries
has been added to the -mm tree.  Its filename is
     c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

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
Subject: c/r: prctl: extend PR_SET_MM to set up more mm_struct entries

During checkpoint we dump whole process memory to a file and the dump
includes process stack memory.  But among stack data itself, the stack
carries additional parameters such as command line arguments, environment
data and auxiliary vector.

So when we do restore procedure and once we've restored stack data itself
we need to setup mm_struct::arg_start/end, env_start/end, so restored
process would be able to find command line arguments and environment data
it had at checkpoint time.  The same applies to auxiliary vector.

For this reason additional PR_SET_MM_(ARG_START | ARG_END | ENV_START |
ENV_END | AUXV) codes are introduced.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prctl.h |    5 +
 kernel/sys.c          |  113 ++++++++++++++++++++++++++++------------
 2 files changed, 85 insertions(+), 33 deletions(-)

diff -puN include/linux/prctl.h~c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2 include/linux/prctl.h
--- a/include/linux/prctl.h~c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2
+++ a/include/linux/prctl.h
@@ -113,6 +113,11 @@
 # define PR_SET_MM_START_STACK		5
 # define PR_SET_MM_START_BRK		6
 # define PR_SET_MM_BRK			7
+# define PR_SET_MM_ARG_START		8
+# define PR_SET_MM_ARG_END		9
+# define PR_SET_MM_ENV_START		10
+# define PR_SET_MM_ENV_END		11
+# define PR_SET_MM_AUXV			12
 
 /*
  * Set specific pid that is allowed to ptrace the current task.
diff -puN kernel/sys.c~c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2 kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2
+++ a/kernel/sys.c
@@ -1702,17 +1702,23 @@ SYSCALL_DEFINE1(umask, int, mask)
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
+static bool vma_flags_mismatch(struct vm_area_struct *vma,
+			       unsigned long required,
+			       unsigned long banned)
+{
+	return (vma->vm_flags & required) != required ||
+		(vma->vm_flags & banned);
+}
+
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
 	unsigned long rlim = rlimit(RLIMIT_DATA);
-	unsigned long vm_req_flags;
-	unsigned long vm_bad_flags;
-	struct vm_area_struct *vma;
-	int error = 0;
 	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	int error;
 
-	if (arg4 | arg5)
+	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
 		return -EINVAL;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -1721,24 +1727,24 @@ static int prctl_set_mm(int opt, unsigne
 	if (addr >= TASK_SIZE)
 		return -EINVAL;
 
+	error = -EINVAL;
+
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, addr);
 
-	if (opt != PR_SET_MM_START_BRK && opt != PR_SET_MM_BRK) {
+	if (opt != PR_SET_MM_START_BRK &&
+	    opt != PR_SET_MM_BRK &&
+	    opt != PR_SET_MM_AUXV) {
 		/* It must be existing VMA */
 		if (!vma || vma->vm_start > addr)
 			goto out;
 	}
 
-	error = -EINVAL;
 	switch (opt) {
 	case PR_SET_MM_START_CODE:
 	case PR_SET_MM_END_CODE:
-		vm_req_flags = VM_READ | VM_EXEC;
-		vm_bad_flags = VM_WRITE | VM_MAYSHARE;
-
-		if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
-		    (vma->vm_flags & vm_bad_flags))
+		if (vma_flags_mismatch(vma, VM_READ | VM_EXEC,
+				       VM_WRITE | VM_MAYSHARE))
 			goto out;
 
 		if (opt == PR_SET_MM_START_CODE)
@@ -1749,11 +1755,8 @@ static int prctl_set_mm(int opt, unsigne
 
 	case PR_SET_MM_START_DATA:
 	case PR_SET_MM_END_DATA:
-		vm_req_flags = VM_READ | VM_WRITE;
-		vm_bad_flags = VM_EXEC | VM_MAYSHARE;
-
-		if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
-		    (vma->vm_flags & vm_bad_flags))
+		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE,
+				       VM_EXEC | VM_MAYSHARE))
 			goto out;
 
 		if (opt == PR_SET_MM_START_DATA)
@@ -1762,19 +1765,6 @@ static int prctl_set_mm(int opt, unsigne
 			mm->end_data = addr;
 		break;
 
-	case PR_SET_MM_START_STACK:
-
-#ifdef CONFIG_STACK_GROWSUP
-		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSUP;
-#else
-		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSDOWN;
-#endif
-		if ((vma->vm_flags & vm_req_flags) != vm_req_flags)
-			goto out;
-
-		mm->start_stack = addr;
-		break;
-
 	case PR_SET_MM_START_BRK:
 		if (addr <= mm->end_data)
 			goto out;
@@ -1799,16 +1789,73 @@ static int prctl_set_mm(int opt, unsigne
 		mm->brk = addr;
 		break;
 
+	/*
+	 * If command line arguments and environment
+	 * are placed somewhere else on stack, we can
+	 * set them up here, ARG_START/END to setup
+	 * command line argumets and ENV_START/END
+	 * for environment.
+	 */
+	case PR_SET_MM_START_STACK:
+	case PR_SET_MM_ARG_START:
+	case PR_SET_MM_ARG_END:
+	case PR_SET_MM_ENV_START:
+	case PR_SET_MM_ENV_END:
+#ifdef CONFIG_STACK_GROWSUP
+		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSUP, 0))
+#else
+		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSDOWN, 0))
+#endif
+			goto out;
+		if (opt == PR_SET_MM_START_STACK)
+			mm->start_stack = addr;
+		else if (opt == PR_SET_MM_ARG_START)
+			mm->arg_start = addr;
+		else if (opt == PR_SET_MM_ARG_END)
+			mm->arg_end = addr;
+		else if (opt == PR_SET_MM_ENV_START)
+			mm->env_start = addr;
+		else if (opt == PR_SET_MM_ENV_END)
+			mm->env_end = addr;
+		break;
+
+	/*
+	 * This doesn't move auxiliary vector itself
+	 * since it's pinned to mm_struct, but allow
+	 * to fill vector with new values. It's up
+	 * to a caller to provide sane values here
+	 * otherwise user space tools which use this
+	 * vector might be unhappy.
+	 */
+	case PR_SET_MM_AUXV: {
+		unsigned long user_auxv[AT_VECTOR_SIZE];
+
+		if (arg4 > sizeof(user_auxv))
+			goto out;
+		up_read(&mm->mmap_sem);
+
+		if (copy_from_user(user_auxv, (const void __user *)addr, arg4))
+			return -EFAULT;
+
+		/* Make sure the last entry is always AT_NULL */
+		user_auxv[AT_VECTOR_SIZE - 2] = 0;
+		user_auxv[AT_VECTOR_SIZE - 1] = 0;
+
+		BUILD_BUG_ON(sizeof(user_auxv) != sizeof(mm->saved_auxv));
+
+		task_lock(current);
+		memcpy(mm->saved_auxv, user_auxv, arg4);
+		task_unlock(current);
+
+		return 0;
+	}
 	default:
-		error = -EINVAL;
 		goto out;
 	}
 
 	error = 0;
-
 out:
 	up_read(&mm->mmap_sem);
