From: akpm@linux-foundation.org
Subject: [merged] c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:37:28 -0800
Message-ID: <20120113203729.49FE25C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:37:32 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:37:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, avagin@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, mtk.manpages@gmail.com, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: prctl: add PR_SET_MM codes to set up mm_struct entries
has been removed from the -mm tree.  Its filename was
     c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: prctl: add PR_SET_MM codes to set up mm_struct entries

When we restore a task we need to set up text, data and data heap sizes
from userspace to the values a task had at checkpoint time.  This patch
adds auxilary prctl codes for that.

While most of them have a statistical nature (their values are involved
into calculation of /proc/<pid>/statm output) the start_brk and brk values
are used to compute an allowed size of program data segment expansion. 
Which means an arbitrary changes of this values might be dangerous
operation.  So to restrict access the following requirements applied to
prctl calls:

 - The process has to have CAP_SYS_ADMIN capability granted.
 - For all opcodes except start_brk/brk members an appropriate
   VMA area must exist and should fit certain VMA flags,
   such as:
   - code segment must be executable but not writable;
   - data segment must not be executable.

start_brk/brk values must not intersect with data segment and must not
exceed RLIMIT_DATA resource limit.

Still the main guard is CAP_SYS_ADMIN capability check.

Note the kernel should be compiled with CONFIG_CHECKPOINT_RESTORE support
otherwise these prctl calls will return -EINVAL.

[akpm@linux-foundation.org: cache current->mm in a local, saving 200 bytes text]
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prctl.h |   12 +++
 kernel/sys.c          |  121 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)

diff -puN include/linux/prctl.h~c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries include/linux/prctl.h
--- a/include/linux/prctl.h~c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries
+++ a/include/linux/prctl.h
@@ -102,4 +102,16 @@
 
 #define PR_MCE_KILL_GET 34
 
+/*
+ * Tune up process memory map specifics.
+ */
+#define PR_SET_MM		35
+# define PR_SET_MM_START_CODE		1
+# define PR_SET_MM_END_CODE		2
+# define PR_SET_MM_START_DATA		3
+# define PR_SET_MM_END_DATA		4
+# define PR_SET_MM_START_STACK		5
+# define PR_SET_MM_START_BRK		6
+# define PR_SET_MM_BRK			7
+
 #endif /* _LINUX_PRCTL_H */
diff -puN kernel/sys.c~c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries
+++ a/kernel/sys.c
@@ -1692,6 +1692,124 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static int prctl_set_mm(int opt, unsigned long addr,
+			unsigned long arg4, unsigned long arg5)
+{
+	unsigned long rlim = rlimit(RLIMIT_DATA);
+	unsigned long vm_req_flags;
+	unsigned long vm_bad_flags;
+	struct vm_area_struct *vma;
+	int error = 0;
+	struct mm_struct *mm = current->mm;
+
+	if (arg4 | arg5)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (addr >= TASK_SIZE)
+		return -EINVAL;
+
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, addr);
+
+	if (opt != PR_SET_MM_START_BRK && opt != PR_SET_MM_BRK) {
+		/* It must be existing VMA */
+		if (!vma || vma->vm_start > addr)
+			goto out;
+	}
+
+	error = -EINVAL;
+	switch (opt) {
+	case PR_SET_MM_START_CODE:
+	case PR_SET_MM_END_CODE:
+		vm_req_flags = VM_READ | VM_EXEC;
+		vm_bad_flags = VM_WRITE | VM_MAYSHARE;
+
+		if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
+		    (vma->vm_flags & vm_bad_flags))
+			goto out;
+
+		if (opt == PR_SET_MM_START_CODE)
+			mm->start_code = addr;
+		else
+			mm->end_code = addr;
+		break;
+
+	case PR_SET_MM_START_DATA:
+	case PR_SET_MM_END_DATA:
+		vm_req_flags = VM_READ | VM_WRITE;
+		vm_bad_flags = VM_EXEC | VM_MAYSHARE;
+
+		if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
+		    (vma->vm_flags & vm_bad_flags))
+			goto out;
+
+		if (opt == PR_SET_MM_START_DATA)
+			mm->start_data = addr;
+		else
+			mm->end_data = addr;
+		break;
+
+	case PR_SET_MM_START_STACK:
+
+#ifdef CONFIG_STACK_GROWSUP
+		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSUP;
+#else
+		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSDOWN;
+#endif
+		if ((vma->vm_flags & vm_req_flags) != vm_req_flags)
+			goto out;
+
+		mm->start_stack = addr;
+		break;
+
+	case PR_SET_MM_START_BRK:
+		if (addr <= mm->end_data)
+			goto out;
+
+		if (rlim < RLIM_INFINITY &&
+		    (mm->brk - addr) +
+		    (mm->end_data - mm->start_data) > rlim)
+			goto out;
+
+		mm->start_brk = addr;
+		break;
+
+	case PR_SET_MM_BRK:
+		if (addr <= mm->end_data)
+			goto out;
+
+		if (rlim < RLIM_INFINITY &&
+		    (addr - mm->start_brk) +
+		    (mm->end_data - mm->start_data) > rlim)
+			goto out;
+
+		mm->brk = addr;
+		break;
+
+	default:
+		error = -EINVAL;
+		goto out;
+	}
+
+	error = 0;
+
+out:
+	up_read(&mm->mmap_sem);
+
+	return error;
+}
+#else /* CONFIG_CHECKPOINT_RESTORE */
+static int prctl_set_mm(int opt, unsigned long addr,
+			unsigned long arg4, unsigned long arg5)
+{
+	return -EINVAL;
+}
+#endif
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -1841,6 +1959,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SET_MM:
+			error = prctl_set_mm(arg2, arg3, arg4, arg5);
+			break;
 		default:
 			error = -EINVAL;
 			break;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch

