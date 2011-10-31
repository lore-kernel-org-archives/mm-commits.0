From: akpm@linux-foundation.org
Subject: [folded] cross-memory-attach-update.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:39:46 -0700
Message-ID: <201110312339.p9VNdkOU032282@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:41728 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1JaXkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyeoh@au1.ibm.com, hpa@zytor.com, mingo@elte.hu, rdunlap@xenotime.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: cross-memory-attach-update
has been removed from the -mm tree.  Its filename was
     cross-memory-attach-update.patch

This patch was dropped because it was folded into cross-memory-attach-v3.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Christopher Yeoh <cyeoh@au1.ibm.com>
Subject: cross-memory-attach-update

- Add x86_64 specific wire up

- Change behaviour so process_vm_readv and process_vm_writev return
  the number of bytes successfully read or written even if an error
  occurs

- Add more kernel doc interface comments

- rename some internal functions (process_vm_rw_check_iovecs,
  process_vm_rw) so they make more sense.

- Add licence message

- Fix kernel-doc comment format

Still need to do benchmarking to see if the optimisation for small copies
using a local on-stack array in process_vm_rw_core is worth it.

Signed-off-by: Chris Yeoh <cyeoh@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S        |    2 
 arch/x86/include/asm/unistd_64.h |    4 
 kernel/sys_ni.c                  |    4 
 mm/process_vm_access.c           |  203 +++++++++++++++++------------
 4 files changed, 132 insertions(+), 81 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~cross-memory-attach-update arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~cross-memory-attach-update
+++ a/arch/x86/ia32/ia32entry.S
@@ -850,4 +850,6 @@ ia32_sys_call_table:
 	.quad sys_syncfs
 	.quad compat_sys_sendmmsg	/* 345 */
 	.quad sys_setns
+	.quad compat_sys_process_vm_readv
+	.quad compat_sys_process_vm_writev
 ia32_syscall_end:
diff -puN arch/x86/include/asm/unistd_64.h~cross-memory-attach-update arch/x86/include/asm/unistd_64.h
--- a/arch/x86/include/asm/unistd_64.h~cross-memory-attach-update
+++ a/arch/x86/include/asm/unistd_64.h
@@ -682,6 +682,10 @@ __SYSCALL(__NR_sendmmsg, sys_sendmmsg)
 __SYSCALL(__NR_setns, sys_setns)
 #define __NR_getcpu				309
 __SYSCALL(__NR_getcpu, sys_getcpu)
+#define __NR_process_vm_readv			310
+__SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
+#define __NR_process_vm_writev			311
+__SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff -puN kernel/sys_ni.c~cross-memory-attach-update kernel/sys_ni.c
--- a/kernel/sys_ni.c~cross-memory-attach-update
+++ a/kernel/sys_ni.c
@@ -145,6 +145,10 @@ cond_syscall(sys_io_submit);
 cond_syscall(sys_io_cancel);
 cond_syscall(sys_io_getevents);
 cond_syscall(sys_syslog);
+cond_syscall(sys_process_vm_readv);
+cond_syscall(sys_process_vm_writev);
+cond_syscall(compat_sys_process_vm_readv);
+cond_syscall(compat_sys_process_vm_writev);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
diff -puN mm/process_vm_access.c~cross-memory-attach-update mm/process_vm_access.c
--- a/mm/process_vm_access.c~cross-memory-attach-update
+++ a/mm/process_vm_access.c
@@ -1,7 +1,12 @@
 /*
- *  linux/mm/process_vm_access.c
+ * linux/mm/process_vm_access.c
  *
- *  Copyright (C) 2010-2011 Christopher Yeoh <cyeoh@au1.ibm.com>, IBM Corp.
+ * Copyright (C) 2010-2011 Christopher Yeoh <cyeoh@au1.ibm.com>, IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
  */
 
 #include <linux/mm.h>
@@ -16,7 +21,7 @@
 #include <linux/compat.h>
 #endif
 
-/*
+/**
  * process_vm_rw_pages - read/write pages from task specified
  * @task: task to read/write from
  * @mm: mm for task
@@ -31,19 +36,22 @@
  * @lvec_offset: offset in bytes from current iovec iov_base we are up to
  * @vm_write: 0 means copy from, 1 means copy to
  * @nr_pages_to_copy: number of pages to copy
+ * @bytes_copied: returns number of bytes successfully copied
+ * Returns 0 on success, error code otherwise
  */
-static ssize_t process_vm_rw_pages(struct task_struct *task,
-				   struct mm_struct *mm,
-				   struct page **process_pages,
-				   unsigned long pa,
-				   unsigned long start_offset,
-				   unsigned long len,
-				   const struct iovec *lvec,
-				   unsigned long lvec_cnt,
-				   unsigned long *lvec_current,
-				   size_t *lvec_offset,
-				   int vm_write,
-				   unsigned int nr_pages_to_copy)
+static int process_vm_rw_pages(struct task_struct *task,
+			       struct mm_struct *mm,
+			       struct page **process_pages,
+			       unsigned long pa,
+			       unsigned long start_offset,
+			       unsigned long len,
+			       const struct iovec *lvec,
+			       unsigned long lvec_cnt,
+			       unsigned long *lvec_current,
+			       size_t *lvec_offset,
+			       int vm_write,
+			       unsigned int nr_pages_to_copy,
+			       ssize_t *bytes_copied)
 {
 	int pages_pinned;
 	void *target_kaddr;
@@ -51,8 +59,9 @@ static ssize_t process_vm_rw_pages(struc
 	int j;
 	int ret;
 	ssize_t bytes_to_copy;
-	ssize_t bytes_copied = 0;
-	ssize_t rc = -EFAULT;
+	ssize_t rc = 0;
+
+	*bytes_copied = 0;
 
 	/* Get the pages we're interested in */
 	down_read(&mm->mmap_sem);
@@ -61,8 +70,10 @@ static ssize_t process_vm_rw_pages(struc
 				      vm_write, 0, process_pages, NULL);
 	up_read(&mm->mmap_sem);
 
-	if (pages_pinned != nr_pages_to_copy)
+	if (pages_pinned != nr_pages_to_copy) {
+		rc = -EFAULT;
 		goto end;
+	}
 
 	/* Do the copy for each page */
 	for (pgs_copied = 0;
@@ -81,7 +92,7 @@ static ssize_t process_vm_rw_pages(struc
 		 * - bytes remaining in destination iovec
 		 */
 		bytes_to_copy = min_t(ssize_t, PAGE_SIZE - start_offset,
-				      len - bytes_copied);
+				      len - *bytes_copied);
 		bytes_to_copy = min_t(ssize_t, bytes_to_copy,
 				      lvec[*lvec_current].iov_len
 				      - *lvec_offset);
@@ -99,10 +110,12 @@ static ssize_t process_vm_rw_pages(struc
 					   target_kaddr, bytes_to_copy);
 		kunmap(process_pages[pgs_copied]);
 		if (ret) {
+			*bytes_copied += bytes_to_copy - ret;
 			pgs_copied++;
+			rc = -EFAULT;
 			goto end;
 		}
-		bytes_copied += bytes_to_copy;
+		*bytes_copied += bytes_to_copy;
 		*lvec_offset += bytes_to_copy;
 		if (*lvec_offset == lvec[*lvec_current].iov_len) {
 			/*
@@ -120,8 +133,6 @@ static ssize_t process_vm_rw_pages(struc
 		}
 	}
 
-	rc = bytes_copied;
-
 end:
 	if (vm_write) {
 		for (j = 0; j < pages_pinned; j++) {
@@ -140,7 +151,7 @@ end:
 /* Maximum number of pages kmalloc'd to hold struct page's during copy */
 #define PVM_MAX_KMALLOC_PAGES (PAGE_SIZE * 2)
 
-/*
+/**
  * process_vm_rw_single_vec - read/write pages from task specified
  * @addr: start memory address of target process
  * @len: size of area to copy to/from
@@ -153,35 +164,38 @@ end:
  * @mm: mm for task
  * @task: task to read/write from
  * @vm_write: 0 means copy from, 1 means copy to
+ * @bytes_copied: returns number of bytes successfully copied
+ * Returns 0 on success or on failure error code
  */
-static ssize_t process_vm_rw_single_vec(unsigned long addr,
-					unsigned long len,
-					const struct iovec *lvec,
-					unsigned long lvec_cnt,
-					unsigned long *lvec_current,
-					size_t *lvec_offset,
-					struct page **process_pages,
-					struct mm_struct *mm,
-					struct task_struct *task,
-					int vm_write)
+static int process_vm_rw_single_vec(unsigned long addr,
+				    unsigned long len,
+				    const struct iovec *lvec,
+				    unsigned long lvec_cnt,
+				    unsigned long *lvec_current,
+				    size_t *lvec_offset,
+				    struct page **process_pages,
+				    struct mm_struct *mm,
+				    struct task_struct *task,
+				    int vm_write,
+				    ssize_t *bytes_copied)
 {
 	unsigned long pa = addr & PAGE_MASK;
 	unsigned long start_offset = addr - pa;
 	unsigned long nr_pages;
-	ssize_t bytes_copied = 0;
-	ssize_t rc;
+	ssize_t bytes_copied_loop;
+	ssize_t rc = 0;
 	unsigned long nr_pages_copied = 0;
 	unsigned long nr_pages_to_copy;
 	unsigned long max_pages_per_loop = PVM_MAX_KMALLOC_PAGES
 		/ sizeof(struct pages *);
 
+	*bytes_copied = 0;
 
 	/* Work out address and page range required */
 	if (len == 0)
 		return 0;
 	nr_pages = (addr + len - 1) / PAGE_SIZE - addr / PAGE_SIZE + 1;
 
-
 	while ((nr_pages_copied < nr_pages) && (*lvec_current < lvec_cnt)) {
 		nr_pages_to_copy = min(nr_pages - nr_pages_copied,
 				       max_pages_per_loop);
@@ -190,35 +204,49 @@ static ssize_t process_vm_rw_single_vec(
 					 start_offset, len,
 					 lvec, lvec_cnt,
 					 lvec_current, lvec_offset,
-					 vm_write, nr_pages_to_copy);
+					 vm_write, nr_pages_to_copy,
+					 &bytes_copied_loop);
 		start_offset = 0;
+		*bytes_copied += bytes_copied_loop;
 
-		if (rc < 0)
+		if (rc < 0) {
 			return rc;
-		else {
-			bytes_copied += rc;
-			len -= rc;
+		} else {
+			len -= bytes_copied_loop;
 			nr_pages_copied += nr_pages_to_copy;
 			pa += nr_pages_to_copy * PAGE_SIZE;
 		}
 	}
 
-	rc = bytes_copied;
 	return rc;
 }
 
-static ssize_t process_vm_rw(pid_t pid, const struct iovec *lvec,
-			     unsigned long liovcnt,
-			     const struct iovec *rvec,
-			     unsigned long riovcnt,
-			     unsigned long flags, int vm_write)
+/**
+ * process_vm_rw_core - core of reading/writing pages from task specified
+ * @pid: PID of process to read/write from/to
+ * @lvec: iovec array specifying where to copy to/from locally
+ * @liovcnt: size of lvec array
+ * @rvec: iovec array specifying where to copy to/from in the other process
+ * @riovcnt: size of rvec array
+ * @flags: currently unused
+ * @vm_write: 0 if reading from other process, 1 if writing to other process
+ * Returns the number of bytes read/written or error code. May
+ *  return less bytes than expected if an error occurs during the copying
+ *  process.
+ */
+static ssize_t process_vm_rw_core(pid_t pid, const struct iovec *lvec,
+				  unsigned long liovcnt,
+				  const struct iovec *rvec,
+				  unsigned long riovcnt,
+				  unsigned long flags, int vm_write)
 {
 	struct task_struct *task;
 	struct page **process_pages = NULL;
 	struct mm_struct *mm;
 	unsigned long i;
-	ssize_t rc;
-	ssize_t bytes_copied;
+	ssize_t rc = 0;
+	ssize_t bytes_copied_loop;
+	ssize_t bytes_copied = 0;
 	unsigned long nr_pages = 0;
 	unsigned long nr_pages_iov;
 	unsigned long iov_l_curr_idx = 0;
@@ -279,38 +307,53 @@ static ssize_t process_vm_rw(pid_t pid, 
 	atomic_inc(&mm->mm_users);
 	task_unlock(task);
 
-	rc = 0;
 	for (i = 0; i < riovcnt && iov_l_curr_idx < liovcnt; i++) {
-		bytes_copied = process_vm_rw_single_vec(
+		rc = process_vm_rw_single_vec(
 			(unsigned long)rvec[i].iov_base, rvec[i].iov_len,
 			lvec, liovcnt, &iov_l_curr_idx, &iov_l_curr_offset,
-			process_pages, mm, task, vm_write);
-		if (bytes_copied < 0) {
-			rc = bytes_copied;
+			process_pages, mm, task, vm_write, &bytes_copied_loop);
+		bytes_copied += bytes_copied_loop;
+		if (rc != 0) {
+			/* If we have managed to copy any data at all then
+			   we return the number of bytes copied. Otherwise
+			   we return the error code */
+			if (bytes_copied)
+				rc = bytes_copied;
 			goto put_mm;
-		} else {
-			rc += bytes_copied;
 		}
 	}
 
+	rc = bytes_copied;
 put_mm:
 	mmput(mm);
 
 put_task_struct:
 	put_task_struct(task);
 
-
 free_proc_pages:
 	kfree(process_pages);
 	return rc;
 }
 
-static ssize_t process_vm_rw_check_iovecs(pid_t pid,
-					  const struct iovec __user *lvec,
-					  unsigned long liovcnt,
-					  const struct iovec __user *rvec,
-					  unsigned long riovcnt,
-					  unsigned long flags, int vm_write)
+/**
+ * process_vm_rw - check iovecs before calling core routine
+ * @pid: PID of process to read/write from/to
+ * @lvec: iovec array specifying where to copy to/from locally
+ * @liovcnt: size of lvec array
+ * @rvec: iovec array specifying where to copy to/from in the other process
+ * @riovcnt: size of rvec array
+ * @flags: currently unused
+ * @vm_write: 0 if reading from other process, 1 if writing to other process
+ * Returns the number of bytes read/written or error code. May
+ *  return less bytes than expected if an error occurs during the copying
+ *  process.
+ */
+static ssize_t process_vm_rw(pid_t pid,
+			     const struct iovec __user *lvec,
+			     unsigned long liovcnt,
+			     const struct iovec __user *rvec,
+			     unsigned long riovcnt,
+			     unsigned long flags, int vm_write)
 {
 	struct iovec iovstack_l[UIO_FASTIOV];
 	struct iovec iovstack_r[UIO_FASTIOV];
@@ -336,8 +379,8 @@ static ssize_t process_vm_rw_check_iovec
 	if (rc <= 0)
 		goto free_iovecs;
 
-	rc = process_vm_rw(pid, iov_l, liovcnt, iov_r, riovcnt, flags,
-			    vm_write);
+	rc = process_vm_rw_core(pid, iov_l, liovcnt, iov_r, riovcnt, flags,
+				vm_write);
 
 free_iovecs:
 	if (iov_r != iovstack_r)
@@ -352,8 +395,7 @@ SYSCALL_DEFINE6(process_vm_readv, pid_t,
 		unsigned long, liovcnt, const struct iovec __user *, rvec,
 		unsigned long, riovcnt,	unsigned long, flags)
 {
-	return process_vm_rw_check_iovecs(pid, lvec, liovcnt, rvec, riovcnt,
-					  flags, 0);
+	return process_vm_rw(pid, lvec, liovcnt, rvec, riovcnt, flags, 0);
 }
 
 SYSCALL_DEFINE6(process_vm_writev, pid_t, pid,
@@ -361,19 +403,18 @@ SYSCALL_DEFINE6(process_vm_writev, pid_t
 		unsigned long, liovcnt, const struct iovec __user *, rvec,
 		unsigned long, riovcnt,	unsigned long, flags)
 {
-	return process_vm_rw_check_iovecs(pid, lvec, liovcnt, rvec, riovcnt,
-					  flags, 1);
+	return process_vm_rw(pid, lvec, liovcnt, rvec, riovcnt, flags, 1);
 }
 
 #ifdef CONFIG_COMPAT
 
 asmlinkage ssize_t
-compat_process_vm_rw_check_iovecs(compat_pid_t pid,
-				  const struct compat_iovec __user *lvec,
-				  unsigned long liovcnt,
-				  const struct compat_iovec __user *rvec,
-				  unsigned long riovcnt,
-				  unsigned long flags, int vm_write)
+compat_process_vm_rw(compat_pid_t pid,
+		     const struct compat_iovec __user *lvec,
+		     unsigned long liovcnt,
+		     const struct compat_iovec __user *rvec,
+		     unsigned long riovcnt,
+		     unsigned long flags, int vm_write)
 {
 	struct iovec iovstack_l[UIO_FASTIOV];
 	struct iovec iovstack_r[UIO_FASTIOV];
@@ -406,8 +447,8 @@ compat_process_vm_rw_check_iovecs(compat
 	if (rc <= 0)
 		goto free_iovecs;
 
-	rc = process_vm_rw(pid, iov_l, liovcnt, iov_r, riovcnt, flags,
-			    vm_write);
+	rc = process_vm_rw_core(pid, iov_l, liovcnt, iov_r, riovcnt, flags,
+			   vm_write);
 
 free_iovecs:
 	if (iov_r != iovstack_r)
@@ -427,8 +468,8 @@ compat_sys_process_vm_readv(compat_pid_t
 			    unsigned long riovcnt,
 			    unsigned long flags)
 {
-	return compat_process_vm_rw_check_iovecs(pid, lvec, liovcnt, rvec,
-						 riovcnt, flags, 0);
+	return compat_process_vm_rw(pid, lvec, liovcnt, rvec,
+				    riovcnt, flags, 0);
 }
 
 asmlinkage ssize_t
@@ -439,8 +480,8 @@ compat_sys_process_vm_writev(compat_pid_
 			     unsigned long riovcnt,
 			     unsigned long flags)
 {
-	return compat_process_vm_rw_check_iovecs(pid, lvec, liovcnt, rvec,
-						 riovcnt, flags, 1);
+	return compat_process_vm_rw(pid, lvec, liovcnt, rvec,
+				    riovcnt, flags, 1);
 }
 
 #endif
_

Patches currently in -mm which might be from cyeoh@au1.ibm.com are

cross-memory-attach-v3.patch
cross-memory-attach-v4.patch

