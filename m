From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-support-vector-address-ranges-for-process_madvise.patch removed from -mm
 tree
Date: Wed, 10 Jun 2020 22:26:20 -0700
Message-ID: <20200611052620.0CR_cPoJA%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgFKF0X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 01:26:23 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjunroy@google.com, bgeffon@google.com, christian.brauner@ubuntu.com, dancol@google.com, hannes@cmpxchg.org, joaodias@google.com, joel@joelfernandes.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, natechancellor@gmail.com, oleksandr@redhat.com, rientjes@google.com, shakeelb@google.com, sj38.park@gmail.com, sonnyrao@google.com, sspatil@google.com, surenb@google.com, timmurray@google.com, vbabka@suse.cz, zhengbin13@huawei.com


The patch titled
     Subject: mm: support vector address ranges for process_madvise
has been removed from the -mm tree.  Its filename was
     mm-support-vector-address-ranges-for-process_madvise.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: support vector address ranges for process_madvise

This patch changes process_madvise interface:

  a) support vector address ranges in a system call
  b) support the vector address ranges to local process as well as
     external process
  c) remove pid but keep only pidfd in argument - [1][2]
  d) change type of flags with unsgined int

Android app has thousands of vmas due to zygote so it's totally waste of
CPU and power if we should call the syscall one by one for each vma. 
(With testing 2000-vma syscall vs 1-vector syscall, it showed 15%
performance improvement.  I think it would be bigger in real practice
because the testing ran very cache friendly environment).

Another potential use case for the vector range is to amortize the cost of
TLB shootdowns for multiple ranges when using MADV_DONTNEED; this could
benefit users like TCP receive zerocopy and malloc implementations.  In
future, we could find more usecases for other advises so let's make it
happens as API since we introduce a new syscall at this moment.  With
that, existing madvise(2) user could replace it with process_madvise(2)
with their own pid if they want to have batch address ranges support
feature.

So finally, the API is as follows,

      ssize_t process_madvise(int pidfd, const struct iovec *iovec,
      		unsigned long vlen, int advice, unsigned int flags);

    DESCRIPTION
      The process_madvise() system call is used to give advice or directions
      to the kernel about the address ranges from external process as well as
      local process. It provides the advice to address ranges of process
      described by iovec and vlen. The goal of such advice is to improve system
      or application performance.

      The pidfd selects the process referred to by the PID file descriptor
      specified in pidfd. (See pidofd_open(2) for further information)

      The pointer iovec points to an array of iovec structures, defined in
      <sys/uio.h> as:

        struct iovec {
            void *iov_base;         /* starting address */
            size_t iov_len;         /* number of bytes to be advised */
        };

      The iovec describes address ranges beginning at address(iov_base)
      and with size length of bytes(iov_len).

      The vlen represents the number of elements in iovec.

      The advice is indicated in the advice argument, which is one of the
      following at this moment if the target process specified by pidfd is
      external.

        MADV_COLD
        MADV_PAGEOUT
        MADV_MERGEABLE
        MADV_UNMERGEABLE

      Permission to provide a hint to external process is governed by a
      ptrace access mode PTRACE_MODE_ATTACH_FSCREDS check; see ptrace(2).

      The process_madvise supports every advice madvise(2) has if target
      process is in same thread group with calling process so user could
      use process_madvise(2) to extend existing madvise(2) to support
      vector address ranges.

    RETURN VALUE
      On success, process_madvise() returns the number of bytes advised.
      This return value may be less than the total number of requested
      bytes, if an error occurred. The caller should check return value
      to determine whether a partial advice occurred.

[1] https://lore.kernel.org/linux-mm/20200509124817.xmrvsrq3mla6b76k@wittgenstein/
[2] https://lore.kernel.org/linux-mm/9d849087-3359-c4ab-fbec-859e8186c509@virtuozzo.com/

[minchan@kernel.org: support compat_sys_process_madvise]
  Link: http://lkml.kernel.org/r/20200423195835.GA46847@google.com
[rdunlap@infradead.org: fix process_madvise prototype]
[zhengbin13@huawei.com: make do_process_madvise() static]
  Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
[minchan@kernel.org: fix s390 compat build error]
  Link: http://lkml.kernel.org/r/20200429012421.GA132200@google.com
[akpm@linux-foundation.org: add compat_sys_process_madvise to mips syscall table]
Link: http://lkml.kernel.org/r/20200518211350.GA50295@google.com
Link: http://lkml.kernel.org/r/20200423145215.72666-2-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>	[build]
Cc: David Rientjes <rientjes@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Daniel Colascione <dancol@google.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: John Dias <joaodias@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/unistd32.h         |    2 
 arch/mips/kernel/syscalls/syscall_n32.tbl |    2 
 arch/mips/kernel/syscalls/syscall_o32.tbl |    2 
 arch/parisc/kernel/syscalls/syscall.tbl   |    2 
 arch/powerpc/kernel/syscalls/syscall.tbl  |    2 
 arch/s390/kernel/syscalls/syscall.tbl     |    2 
 arch/sparc/kernel/syscalls/syscall.tbl    |    2 
 arch/x86/entry/syscalls/syscall_32.tbl    |    2 
 arch/x86/entry/syscalls/syscall_64.tbl    |    4 -
 include/linux/compat.h                    |    4 +
 include/linux/syscalls.h                  |    6 -
 include/uapi/asm-generic/unistd.h         |    3 
 kernel/sys_ni.c                           |    1 
 mm/madvise.c                              |   80 ++++++++++++++++++--
 14 files changed, 93 insertions(+), 21 deletions(-)

--- a/arch/arm64/include/asm/unistd32.h~mm-support-vector-address-ranges-for-process_madvise
+++ a/arch/arm64/include/asm/unistd32.h
@@ -886,7 +886,7 @@ __SYSCALL(__NR_pidfd_getfd, sys_pidfd_ge
 #define __NR_faccessat2 439
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
 #define __NR_process_madvise 440
-__SYSCALL(__NR_process_madvise, sys_process_madvise)
+__SYSCALL(__NR_process_madvise, compat_sys_process_madvise)
 
 /*
  * Please add new compat syscalls above this comment and update
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~mm-support-vector-address-ranges-for-process_madvise
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -377,4 +377,4 @@
 437	n32	openat2				sys_openat2
 438	n32	pidfd_getfd			sys_pidfd_getfd
 439	n32	faccessat2			sys_faccessat2
-440	n32	process_madvise			sys_process_madvise
+440	n32	process_madvise			compat_sys_process_madvise
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~mm-support-vector-address-ranges-for-process_madvise
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -426,4 +426,4 @@
 437	o32	openat2				sys_openat2
 438	o32	pidfd_getfd			sys_pidfd_getfd
 439	o32	faccessat2			sys_faccessat2
-440	o32	process_madvise			sys_process_madvise
+440	o32	process_madvise			sys_process_madvise		compat_sys_process_madvise
--- a/arch/parisc/kernel/syscalls/syscall.tbl~mm-support-vector-address-ranges-for-process_madvise
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -436,4 +436,4 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-440	common	process_madvise			sys_process_madvise
+440	common	process_madvise			sys_process_madvise		compat_sys_process_madvise
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~mm-support-vector-address-ranges-for-process_madvise
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -528,4 +528,4 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-440	common	process_madvise			sys_process_madvise
+440	common	process_madvise			sys_process_madvise		compat_sys_process_madvise
--- a/arch/s390/kernel/syscalls/syscall.tbl~mm-support-vector-address-ranges-for-process_madvise
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -441,4 +441,4 @@
 437  common	openat2			sys_openat2			sys_openat2
 438  common	pidfd_getfd		sys_pidfd_getfd			sys_pidfd_getfd
 439  common	faccessat2		sys_faccessat2			sys_faccessat2
-440  common	process_madvise		sys_process_madvise		sys_process_madvise
+440  common	process_madvise		sys_process_madvise		compat_sys_process_madvise
--- a/arch/sparc/kernel/syscalls/syscall.tbl~mm-support-vector-address-ranges-for-process_madvise
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -484,4 +484,4 @@
 437	common	openat2			sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-440	common	process_madvise			sys_process_madvise
+440	common	process_madvise			sys_process_madvise		compat_sys_process_madvise
--- a/arch/x86/entry/syscalls/syscall_32.tbl~mm-support-vector-address-ranges-for-process_madvise
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -443,4 +443,4 @@
 437	i386	openat2			sys_openat2
 438	i386	pidfd_getfd		sys_pidfd_getfd
 439	i386	faccessat2		sys_faccessat2
-440	i386	process_madvise		sys_process_madvise
+440	i386	process_madvise		sys_process_madvise		compat_sys_process_madvise
--- a/arch/x86/entry/syscalls/syscall_64.tbl~mm-support-vector-address-ranges-for-process_madvise
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
--- a/include/linux/compat.h~mm-support-vector-address-ranges-for-process_madvise
+++ a/include/linux/compat.h
@@ -827,6 +827,10 @@ asmlinkage long compat_sys_pwritev64v2(u
 		unsigned long vlen, loff_t pos, rwf_t flags);
 #endif
 
+asmlinkage ssize_t compat_sys_process_madvise(compat_int_t which,
+		compat_pid_t upid, const struct compat_iovec __user *vec,
+		compat_ulong_t vlen, compat_int_t behavior,
+		compat_ulong_t flags);
 
 /*
  * Deprecated system calls which are still defined in
--- a/include/linux/syscalls.h~mm-support-vector-address-ranges-for-process_madvise
+++ a/include/linux/syscalls.h
@@ -878,9 +878,9 @@ asmlinkage long sys_munlockall(void);
 asmlinkage long sys_mincore(unsigned long start, size_t len,
 				unsigned char __user * vec);
 asmlinkage long sys_madvise(unsigned long start, size_t len, int behavior);
-
-asmlinkage long sys_process_madvise(int which, pid_t pid, unsigned long start,
-			size_t len, int behavior, unsigned long flags);
+asmlinkage long sys_process_madvise(int which, pid_t upid,
+		const struct iovec __user *vec, unsigned long vlen,
+		int behavior, unsigned long flags);
 asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
 			unsigned long prot, unsigned long pgoff,
 			unsigned long flags);
--- a/include/uapi/asm-generic/unistd.h~mm-support-vector-address-ranges-for-process_madvise
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
--- a/kernel/sys_ni.c~mm-support-vector-address-ranges-for-process_madvise
+++ a/kernel/sys_ni.c
@@ -281,6 +281,7 @@ COND_SYSCALL(munlockall);
 COND_SYSCALL(mincore);
 COND_SYSCALL(madvise);
 COND_SYSCALL(process_madvise);
+COND_SYSCALL_COMPAT(process_madvise);
 COND_SYSCALL(remap_file_pages);
 COND_SYSCALL(mbind);
 COND_SYSCALL_COMPAT(mbind);
--- a/mm/madvise.c~mm-support-vector-address-ranges-for-process_madvise
+++ a/mm/madvise.c
@@ -1212,20 +1212,36 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	return do_madvise(current, current->mm, start, len_in, behavior);
 }
 
-SYSCALL_DEFINE6(process_madvise, int, which, pid_t, upid, unsigned long, start,
-		size_t, len_in, int, behavior, unsigned long, flags)
+static int process_madvise_vec(struct task_struct *target_task,
+		struct mm_struct *mm, struct iov_iter *iter, int behavior)
 {
-	int ret;
+	struct iovec iovec;
+	int ret = 0;
+
+	while (iov_iter_count(iter)) {
+		iovec = iov_iter_iovec(iter);
+		ret = do_madvise(target_task, mm, (unsigned long)iovec.iov_base,
+					iovec.iov_len, behavior);
+		if (ret < 0)
+			break;
+		iov_iter_advance(iter, iovec.iov_len);
+	}
+
+	return ret;
+}
+
+static ssize_t do_process_madvise(int which, pid_t upid, struct iov_iter *iter,
+				       int behavior, unsigned long flags)
+{
+	ssize_t ret;
 	struct pid *pid;
 	struct task_struct *task;
 	struct mm_struct *mm;
+	size_t total_len = iov_iter_count(iter);
 
 	if (flags != 0)
 		return -EINVAL;
 
-	if (!process_madvise_behavior_valid(behavior))
-		return -EINVAL;
-
 	switch (which) {
 	case P_PID:
 		if (upid <= 0)
@@ -1253,13 +1269,22 @@ SYSCALL_DEFINE6(process_madvise, int, wh
 		goto put_pid;
 	}
 
+	if (task->mm != current->mm &&
+			!process_madvise_behavior_valid(behavior)) {
+		ret = -EINVAL;
+		goto release_task;
+	}
+
 	mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
 	if (IS_ERR_OR_NULL(mm)) {
 		ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
 		goto release_task;
 	}
 
-	ret = do_madvise(task, mm, start, len_in, behavior);
+	ret = process_madvise_vec(task, mm, iter, behavior);
+	if (ret >= 0)
+		ret = total_len - iov_iter_count(iter);
+
 	mmput(mm);
 release_task:
 	put_task_struct(task);
@@ -1267,3 +1292,44 @@ put_pid:
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
+COMPAT_SYSCALL_DEFINE6(process_madvise, compat_int_t, which,
+			compat_pid_t, upid,
+			const struct compat_iovec __user *, vec,
+			compat_ulong_t, vlen,
+			compat_int_t, behavior,
+			compat_ulong_t, flags)
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

mm-use-only-pidfd-for-process_madvise-syscall.patch
