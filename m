From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-support-vector-address-ranges-for-process_madvise-fix.patch removed from
 -mm tree
Date: Wed, 10 Jun 2020 18:23:55 -0700
Message-ID: <20200611012355.CVPqG_qzJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgFKBX6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:23:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjunroy@google.com, bgeffon@google.com, christian.brauner@ubuntu.com, dancol@google.com, hannes@cmpxchg.org, joaodias@google.com, joel@joelfernandes.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, oleksandr@redhat.com, rientjes@google.com, shakeelb@google.com, sj38.park@gmail.com, sonnyrao@google.com, sspatil@google.com, surenb@google.com, timmurray@google.com, vbabka@suse.cz


The patch titled
     Subject: mm: support compat_sys_process_madvise
has been removed from the -mm tree.  Its filename was
     mm-support-vector-address-ranges-for-process_madvise-fix.patch

This patch was dropped because it was folded into mm-support-vector-address-ranges-for-process_madvise.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: support compat_sys_process_madvise

This patch supports compat syscall for process_madvise

Link: http://lkml.kernel.org/r/20200423195835.GA46847@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Daniel Colascione <dancol@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Dias <joaodias@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/unistd32.h         |    2 
 arch/mips/kernel/syscalls/syscall_n32.tbl |    2 
 arch/parisc/kernel/syscalls/syscall.tbl   |    2 
 arch/powerpc/kernel/syscalls/syscall.tbl  |    2 
 arch/s390/kernel/syscalls/syscall.tbl     |    2 
 arch/sparc/kernel/syscalls/syscall.tbl    |    2 
 arch/x86/entry/syscalls/syscall_32.tbl    |    2 
 arch/x86/entry/syscalls/syscall_64.tbl    |    4 -
 include/linux/compat.h                    |    3 +
 include/uapi/asm-generic/unistd.h         |    3 -
 kernel/sys_ni.c                           |    1 
 mm/madvise.c                              |   60 +++++++++++++++-----
 12 files changed, 60 insertions(+), 25 deletions(-)

--- a/arch/arm64/include/asm/unistd32.h~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/arch/arm64/include/asm/unistd32.h
@@ -886,7 +886,7 @@ __SYSCALL(__NR_pidfd_getfd, sys_pidfd_ge
 #define __NR_faccessat2 439
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
 #define __NR_process_madvise 440
-__SYSCALL(__NR_process_madvise, sys_process_madvise)
+__SYSCALL(__NR_process_madvise, compat_sys_process_madvise)
 
 /*
  * Please add new compat syscalls above this comment and update
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -377,4 +377,4 @@
 437	n32	openat2				sys_openat2
 438	n32	pidfd_getfd			sys_pidfd_getfd
 439	n32	faccessat2			sys_faccessat2
-440	n32	process_madvise			sys_process_madvise
+440	n32	process_madvise			compat_sys_process_madvise
--- a/arch/parisc/kernel/syscalls/syscall.tbl~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -436,4 +436,4 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-440	common	process_madvise			sys_process_madvise
+440	common	process_madvise			sys_process_madvise		compat_sys_process_madvise
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -528,4 +528,4 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-440	common	process_madvise			sys_process_madvise
+440	common	process_madvise			sys_process_madvise		compat_sys_process_madvise
--- a/arch/s390/kernel/syscalls/syscall.tbl~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -441,4 +441,4 @@
 437  common	openat2			sys_openat2			sys_openat2
 438  common	pidfd_getfd		sys_pidfd_getfd			sys_pidfd_getfd
 439  common	faccessat2		sys_faccessat2			sys_faccessat2
-440  common	process_madvise		sys_process_madvise		sys_process_madvise
+440  common	process_madvise		sys_process_madvise		compat_sys_process_madvise
--- a/arch/sparc/kernel/syscalls/syscall.tbl~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -484,4 +484,4 @@
 437	common	openat2			sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-440	common	process_madvise			sys_process_madvise
+440	common	process_madvise			sys_process_madvise		compat_sys_process_madvise
--- a/arch/x86/entry/syscalls/syscall_32.tbl~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -443,4 +443,4 @@
 437	i386	openat2			sys_openat2
 438	i386	pidfd_getfd		sys_pidfd_getfd
 439	i386	faccessat2		sys_faccessat2
-440	i386	process_madvise		sys_process_madvise
+440	i386	process_madvise		sys_process_madvise		compat_sys_process_madvise
--- a/arch/x86/entry/syscalls/syscall_64.tbl~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -360,8 +360,7 @@
 437	common	openat2			sys_openat2
 438	common	pidfd_getfd		sys_pidfd_getfd
 439	common	faccessat2		sys_faccessat2
-440	common	process_madvise		sys_process_madvise
-
+440	64	process_madvise		sys_process_madvise
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
 # for native 64-bit operation. The __x32_compat_sys stubs are created
@@ -404,3 +403,4 @@
 545	x32	execveat		compat_sys_execveat
 546	x32	preadv2			compat_sys_preadv64v2
 547	x32	pwritev2		compat_sys_pwritev64v2
+548	x32	process_madvise		compat_sys_process_madvise
--- a/include/linux/compat.h~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/include/linux/compat.h
@@ -827,6 +827,9 @@ asmlinkage long compat_sys_pwritev64v2(u
 		unsigned long vlen, loff_t pos, rwf_t flags);
 #endif
 
+asmlinkage ssize_t compat_sys_process_madvise(int which,
+		compat_pid_t upid, const struct compat_iovec __user *vec,
+		unsigned long vlen, int behavior, unsigned long flags);
 
 /*
  * Deprecated system calls which are still defined in
--- a/include/uapi/asm-generic/unistd.h~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/include/uapi/asm-generic/unistd.h
@@ -858,7 +858,8 @@ __SYSCALL(__NR_pidfd_getfd, sys_pidfd_ge
 #define __NR_faccessat2 439
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
 #define __NR_process_madvise 440
-__SYSCALL(__NR_process_madvise, sys_process_madvise)
+__SC_COMP(__NR_process_madvise, sys_process_madvise, \
+		compat_sys_process_madvise)
 
 #undef __NR_syscalls
 #define __NR_syscalls 441
--- a/kernel/sys_ni.c~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/kernel/sys_ni.c
@@ -281,6 +281,7 @@ COND_SYSCALL(munlockall);
 COND_SYSCALL(mincore);
 COND_SYSCALL(madvise);
 COND_SYSCALL(process_madvise);
+COND_SYSCALL_COMPAT(process_madvise);
 COND_SYSCALL(remap_file_pages);
 COND_SYSCALL(mbind);
 COND_SYSCALL_COMPAT(mbind);
--- a/mm/madvise.c~mm-support-vector-address-ranges-for-process_madvise-fix
+++ a/mm/madvise.c
@@ -1212,7 +1212,7 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	return do_madvise(current, current->mm, start, len_in, behavior);
 }
 
-static int do_process_madvise(struct task_struct *target_task,
+static int process_madvise_vec(struct task_struct *target_task,
 		struct mm_struct *mm, struct iov_iter *iter, int behavior)
 {
 	struct iovec iovec;
@@ -1230,17 +1230,14 @@ static int do_process_madvise(struct tas
 	return ret;
 }
 
-SYSCALL_DEFINE6(process_madvise, int, which, pid_t, upid,
-		const struct iovec __user *, vec, unsigned long, vlen,
-		int, behavior, unsigned long, flags)
+ssize_t do_process_madvise(int which, pid_t upid, struct iov_iter *iter,
+				int behavior, unsigned long flags)
 {
 	ssize_t ret;
 	struct pid *pid;
 	struct task_struct *task;
 	struct mm_struct *mm;
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
-	struct iov_iter iter;
+	size_t total_len = iov_iter_count(iter);
 
 	if (flags != 0)
 		return -EINVAL;
@@ -1284,15 +1281,10 @@ SYSCALL_DEFINE6(process_madvise, int, wh
 		goto release_task;
 	}
 
-	ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
-	if (ret >= 0) {
-		size_t total_len = iov_iter_count(&iter);
+	ret = process_madvise_vec(task, mm, iter, behavior);
+	if (ret >= 0)
+		ret = total_len - iov_iter_count(iter);
 
-		ret = do_process_madvise(task, mm, &iter, behavior);
-		if (ret >= 0)
-			ret = total_len - iov_iter_count(&iter);
-		kfree(iov);
-	}
 	mmput(mm);
 release_task:
 	put_task_struct(task);
@@ -1300,3 +1292,41 @@ put_pid:
 	put_pid(pid);
 	return ret;
 }
+
+SYSCALL_DEFINE6(process_madvise, int, which, pid_t, upid,
+		const struct iovec __user *, vec, unsigned long, vlen,
+		int, behavior, unsigned long, flags)
+{
+	ssize_t ret;
+	struct iovec iovstack[UIO_FASTIOV];
+	struct iovec *iov = iovstack;
+	struct iov_iter iter;
+
+	ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
+	if (ret >= 0) {
+		ret = do_process_madvise(which, upid, &iter, behavior, flags);
+		kfree(iov);
+	}
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+COMPAT_SYSCALL_DEFINE6(process_madvise, int, which, compat_pid_t, upid,
+		const struct compat_iovec __user *, vec, unsigned long, vlen,
+		int, behavior, unsigned long, flags)
+
+{
+	ssize_t ret;
+	struct iovec iovstack[UIO_FASTIOV];
+	struct iovec *iov = iovstack;
+	struct iov_iter iter;
+
+	ret = compat_import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack),
+				&iov, &iter);
+	if (ret >= 0) {
+		ret = do_process_madvise(which, upid, &iter, behavior, flags);
+		kfree(iov);
+	}
+	return ret;
+}
+#endif
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api.patch
mm-check-fatal-signal-pending-of-target-process.patch
pid-move-pidfd_get_pid-function-to-pidc.patch
mm-support-both-pid-and-pidfd-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix.patch
mm-use-only-pidfd-for-process_madvise-syscall.patch
mm-use-only-pidfd-for-process_madvise-syscall-fix.patch
