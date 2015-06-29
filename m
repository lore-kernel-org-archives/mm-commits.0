From: akpm@linux-foundation.org
Subject: [merged] prctl-more-prctlpr_set_mm_-checks.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:46:49 -0700
Message-ID: <5591aeb9.yWpwBOAA4XOCiZIM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbbF2Uqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, gorcunov@openvz.org, jarod@redhat.com, jstancek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: more prctl(PR_SET_MM_*) checks
has been removed from the -mm tree.  Its filename was
     prctl-more-prctlpr_set_mm_-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: prctl: more prctl(PR_SET_MM_*) checks

Individual prctl(PR_SET_MM_*) calls do some checking to maintain a
consistent view of mm->arg_start et al fields, but not enough.  In
particular
PR_SET_MM_ARG_START/PR_SET_MM_ARG_END/PR_SET_MM_ENV_START/PR_SET_MM_ENV_END
only check that the address lies in an existing VMA, but don't check that
the start address is lower than the end address _at all_.

Consolidate all consistency checks, so there will be no difference in the
future between PR_SET_MM_MAP and individual PR_SET_MM_* calls.

The program below makes both ARGV and ENVP areas be reversed.  It makes
/proc/$PID/cmdline show garbage (it doesn't oops by luck).

#include <sys/mman.h>
#include <sys/prctl.h>
#include <unistd.h>

enum {PAGE_SIZE=4096};

int main(void)
{
	void *p;

	p = mmap(NULL, PAGE_SIZE, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);

#define PR_SET_MM               35
#define PR_SET_MM_ARG_START     8
#define PR_SET_MM_ARG_END       9
#define PR_SET_MM_ENV_START     10
#define PR_SET_MM_ENV_END       11
	prctl(PR_SET_MM, PR_SET_MM_ARG_START, (unsigned long)p + PAGE_SIZE - 1, 0, 0);
	prctl(PR_SET_MM, PR_SET_MM_ARG_END,   (unsigned long)p, 0, 0);
	prctl(PR_SET_MM, PR_SET_MM_ENV_START, (unsigned long)p + PAGE_SIZE - 1, 0, 0);
	prctl(PR_SET_MM, PR_SET_MM_ENV_END,   (unsigned long)p, 0, 0);

	pause();
	return 0;
}

[akpm@linux-foundation.org: tidy code, tweak comment]
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |  158 ++++++++++++++++++++++++++++---------------------
 1 file changed, 91 insertions(+), 67 deletions(-)

diff -puN kernel/sys.c~prctl-more-prctlpr_set_mm_-checks kernel/sys.c
--- a/kernel/sys.c~prctl-more-prctlpr_set_mm_-checks
+++ a/kernel/sys.c
@@ -1722,7 +1722,6 @@ exit_err:
 	goto exit;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
 /*
  * WARNING: we don't require any capability here so be very careful
  * in what is allowed for modification from userspace.
@@ -1818,6 +1817,7 @@ out:
 	return error;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static int prctl_set_mm_map(int opt, const void __user *addr, unsigned long data_size)
 {
 	struct prctl_mm_map prctl_map = { .exe_fd = (u32)-1, };
@@ -1902,10 +1902,41 @@ out:
 }
 #endif /* CONFIG_CHECKPOINT_RESTORE */
 
+static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
+			  unsigned long len)
+{
+	/*
+	 * This doesn't move the auxiliary vector itself since it's pinned to
+	 * mm_struct, but it permits filling the vector with new values.  It's
+	 * up to the caller to provide sane values here, otherwise userspace
+	 * tools which use this vector might be unhappy.
+	 */
+	unsigned long user_auxv[AT_VECTOR_SIZE];
+
+	if (len > sizeof(user_auxv))
+		return -EINVAL;
+
+	if (copy_from_user(user_auxv, (const void __user *)addr, len))
+		return -EFAULT;
+
+	/* Make sure the last entry is always AT_NULL */
+	user_auxv[AT_VECTOR_SIZE - 2] = 0;
+	user_auxv[AT_VECTOR_SIZE - 1] = 0;
+
+	BUILD_BUG_ON(sizeof(user_auxv) != sizeof(mm->saved_auxv));
+
+	task_lock(current);
+	memcpy(mm->saved_auxv, user_auxv, len);
+	task_unlock(current);
+
+	return 0;
+}
+
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
 	struct mm_struct *mm = current->mm;
+	struct prctl_mm_map prctl_map;
 	struct vm_area_struct *vma;
 	int error;
 
@@ -1925,6 +1956,9 @@ static int prctl_set_mm(int opt, unsigne
 	if (opt == PR_SET_MM_EXE_FILE)
 		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
 
+	if (opt == PR_SET_MM_AUXV)
+		return prctl_set_auxv(mm, addr, arg4);
+
 	if (addr >= TASK_SIZE || addr < mmap_min_addr)
 		return -EINVAL;
 
@@ -1933,42 +1967,64 @@ static int prctl_set_mm(int opt, unsigne
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, addr);
 
+	prctl_map.start_code	= mm->start_code;
+	prctl_map.end_code	= mm->end_code;
+	prctl_map.start_data	= mm->start_data;
+	prctl_map.end_data	= mm->end_data;
+	prctl_map.start_brk	= mm->start_brk;
+	prctl_map.brk		= mm->brk;
+	prctl_map.start_stack	= mm->start_stack;
+	prctl_map.arg_start	= mm->arg_start;
+	prctl_map.arg_end	= mm->arg_end;
+	prctl_map.env_start	= mm->env_start;
+	prctl_map.env_end	= mm->env_end;
+	prctl_map.auxv		= NULL;
+	prctl_map.auxv_size	= 0;
+	prctl_map.exe_fd	= -1;
+
 	switch (opt) {
 	case PR_SET_MM_START_CODE:
-		mm->start_code = addr;
+		prctl_map.start_code = addr;
 		break;
 	case PR_SET_MM_END_CODE:
-		mm->end_code = addr;
+		prctl_map.end_code = addr;
 		break;
 	case PR_SET_MM_START_DATA:
-		mm->start_data = addr;
+		prctl_map.start_data = addr;
 		break;
 	case PR_SET_MM_END_DATA:
-		mm->end_data = addr;
+		prctl_map.end_data = addr;
+		break;
+	case PR_SET_MM_START_STACK:
+		prctl_map.start_stack = addr;
 		break;
-
 	case PR_SET_MM_START_BRK:
-		if (addr <= mm->end_data)
-			goto out;
-
-		if (check_data_rlimit(rlimit(RLIMIT_DATA), mm->brk, addr,
-				      mm->end_data, mm->start_data))
-			goto out;
-
-		mm->start_brk = addr;
+		prctl_map.start_brk = addr;
 		break;
-
 	case PR_SET_MM_BRK:
-		if (addr <= mm->end_data)
-			goto out;
-
-		if (check_data_rlimit(rlimit(RLIMIT_DATA), addr, mm->start_brk,
-				      mm->end_data, mm->start_data))
-			goto out;
-
-		mm->brk = addr;
+		prctl_map.brk = addr;
+		break;
+	case PR_SET_MM_ARG_START:
+		prctl_map.arg_start = addr;
+		break;
+	case PR_SET_MM_ARG_END:
+		prctl_map.arg_end = addr;
+		break;
+	case PR_SET_MM_ENV_START:
+		prctl_map.env_start = addr;
 		break;
+	case PR_SET_MM_ENV_END:
+		prctl_map.env_end = addr;
+		break;
+	default:
+		goto out;
+	}
 
+	error = validate_prctl_map(&prctl_map);
+	if (error)
+		goto out;
+
+	switch (opt) {
 	/*
 	 * If command line arguments and environment
 	 * are placed somewhere else on stack, we can
@@ -1985,52 +2041,20 @@ static int prctl_set_mm(int opt, unsigne
 			error = -EFAULT;
 			goto out;
 		}
-		if (opt == PR_SET_MM_START_STACK)
-			mm->start_stack = addr;
-		else if (opt == PR_SET_MM_ARG_START)
-			mm->arg_start = addr;
-		else if (opt == PR_SET_MM_ARG_END)
-			mm->arg_end = addr;
-		else if (opt == PR_SET_MM_ENV_START)
-			mm->env_start = addr;
-		else if (opt == PR_SET_MM_ENV_END)
-			mm->env_end = addr;
-		break;
-
-	/*
-	 * This doesn't move auxiliary vector itself
-	 * since it's pinned to mm_struct, but allow
-	 * to fill vector with new values. It's up
-	 * to a caller to provide sane values here
-	 * otherwise user space tools which use this
-	 * vector might be unhappy.
-	 */
-	case PR_SET_MM_AUXV: {
-		unsigned long user_auxv[AT_VECTOR_SIZE];
-
-		if (arg4 > sizeof(user_auxv))
-			goto out;
-		up_read(&mm->mmap_sem);
-
-		if (copy_from_user(user_auxv, (const void __user *)addr, arg4))
-			return -EFAULT;
-
-		/* Make sure the last entry is always AT_NULL */
-		user_auxv[AT_VECTOR_SIZE - 2] = 0;
-		user_auxv[AT_VECTOR_SIZE - 1] = 0;
-
-		BUILD_BUG_ON(sizeof(user_auxv) != sizeof(mm->saved_auxv));
-
-		task_lock(current);
-		memcpy(mm->saved_auxv, user_auxv, arg4);
-		task_unlock(current);
-
-		return 0;
-	}
-	default:
-		goto out;
 	}
 
+	mm->start_code	= prctl_map.start_code;
+	mm->end_code	= prctl_map.end_code;
+	mm->start_data	= prctl_map.start_data;
+	mm->end_data	= prctl_map.end_data;
+	mm->start_brk	= prctl_map.start_brk;
+	mm->brk		= prctl_map.brk;
+	mm->start_stack	= prctl_map.start_stack;
+	mm->arg_start	= prctl_map.arg_start;
+	mm->arg_end	= prctl_map.arg_end;
+	mm->env_start	= prctl_map.env_start;
+	mm->env_end	= prctl_map.env_end;
+
 	error = 0;
 out:
 	up_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch

