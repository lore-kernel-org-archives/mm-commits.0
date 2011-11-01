From: akpm@linux-foundation.org
Subject: [merged] cross-memory-attach-v3.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:07:26 -0700
Message-ID: <201111012107.pA1L7Q3j011543@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15267 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1KAVIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyeoh@au1.ibm.com, arnd@arndb.de, benh@kernel.crashing.org, dhowells@redhat.com, hpa@zytor.com, jmorris@namei.org, linux-arch@vger.kernel.org, linux-man@vger.kernel.org, mingo@elte.hu


The patch titled
     Subject: Cross Memory Attach
has been removed from the -mm tree.  Its filename was
     cross-memory-attach-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Christopher Yeoh <cyeoh@au1.ibm.com>
Subject: Cross Memory Attach

The basic idea behind cross memory attach is to allow MPI programs doing
intra-node communication to do a single copy of the message rather than a
double copy of the message via shared memory.

The following patch attempts to achieve this by allowing a destination
process, given an address and size from a source process, to copy memory
directly from the source process into its own address space via a system
call.  There is also a symmetrical ability to copy from the current
process's address space into a destination process's address space.

- Use of /proc/pid/mem has been considered, but there are issues with
  using it:
  - Does not allow for specifying iovecs for both src and dest, assuming
    preadv or pwritev was implemented either the area read from or
  written to would need to be contiguous.
  - Currently mem_read allows only processes who are currently
  ptrace'ing the target and are still able to ptrace the target to read
  from the target. This check could possibly be moved to the open call,
  but its not clear exactly what race this restriction is stopping
  (reason  appears to have been lost)
  - Having to send the fd of /proc/self/mem via SCM_RIGHTS on unix
  domain socket is a bit ugly from a userspace point of view,
  especially when you may have hundreds if not (eventually) thousands
  of processes  that all need to do this with each other
  - Doesn't allow for some future use of the interface we would like to
  consider adding in the future (see below)
  - Interestingly reading from /proc/pid/mem currently actually
  involves two copies! (But this could be fixed pretty easily)

As mentioned previously use of vmsplice instead was considered, but has
problems.  Since you need the reader and writer working co-operatively if
the pipe is not drained then you block.  Which requires some wrapping to
do non blocking on the send side or polling on the receive.  In all to all
communication it requires ordering otherwise you can deadlock.  And in the
example of many MPI tasks writing to one MPI task vmsplice serialises the
copying.

There are some cases of MPI collectives where even a single copy interface
does not get us the performance gain we could.  For example in an
MPI_Reduce rather than copy the data from the source we would like to
instead use it directly in a mathops (say the reduce is doing a sum) as
this would save us doing a copy.  We don't need to keep a copy of the data
from the source.  I haven't implemented this, but I think this interface
could in the future do all this through the use of the flags - eg could
specify the math operation and type and the kernel rather than just
copying the data would apply the specified operation between the source
and destination and store it in the destination.

Although we don't have a "second user" of the interface (though I've had
some nibbles from people who may be interested in using it for intra
process messaging which is not MPI).  This interface is something which
hardware vendors are already doing for their custom drivers to implement
fast local communication.  And so in addition to this being useful for
OpenMPI it would mean the driver maintainers don't have to fix things up
when the mm changes.

There was some discussion about how much faster a true zero copy would
go. Here's a link back to the email with some testing I did on that:

http://marc.info/?l=linux-mm&m=130105930902915&w=2

There is a basic man page for the proposed interface here:

http://ozlabs.org/~cyeoh/cma/process_vm_readv.txt

This has been implemented for x86 and powerpc, other architecture should
mainly (I think) just need to add syscall numbers for the process_vm_readv
and process_vm_writev. There are 32 bit compatibility versions for
64-bit kernels.

For arch maintainers there are some simple tests to be able to quickly
verify that the syscalls are working correctly here:

http://ozlabs.org/~cyeoh/cma/cma-test-20110718.tgz

Signed-off-by: Chris Yeoh <yeohc@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <linux-man@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/systbl.h  |    2 
 arch/powerpc/include/asm/unistd.h  |    4 
 arch/x86/ia32/ia32entry.S          |    2 
 arch/x86/include/asm/unistd_32.h   |    4 
 arch/x86/include/asm/unistd_64.h   |    4 
 arch/x86/kernel/syscall_table_32.S |    2 
 fs/aio.c                           |    4 
 fs/compat.c                        |    7 
 fs/read_write.c                    |    8 
 include/linux/compat.h             |    3 
 include/linux/fs.h                 |    7 
 include/linux/syscalls.h           |   13 
 kernel/sys_ni.c                    |    4 
 mm/Makefile                        |    3 
 mm/process_vm_access.c             |  496 +++++++++++++++++++++++++++
 security/keys/compat.c             |    2 
 security/keys/keyctl.c             |    2 
 17 files changed, 550 insertions(+), 17 deletions(-)

diff -puN arch/powerpc/include/asm/systbl.h~cross-memory-attach-v3 arch/powerpc/include/asm/systbl.h
--- a/arch/powerpc/include/asm/systbl.h~cross-memory-attach-v3
+++ a/arch/powerpc/include/asm/systbl.h
@@ -354,3 +354,5 @@ COMPAT_SYS_SPU(clock_adjtime)
 SYSCALL_SPU(syncfs)
 COMPAT_SYS_SPU(sendmmsg)
 SYSCALL_SPU(setns)
+COMPAT_SYS(process_vm_readv)
+COMPAT_SYS(process_vm_writev)
diff -puN arch/powerpc/include/asm/unistd.h~cross-memory-attach-v3 arch/powerpc/include/asm/unistd.h
--- a/arch/powerpc/include/asm/unistd.h~cross-memory-attach-v3
+++ a/arch/powerpc/include/asm/unistd.h
@@ -373,10 +373,12 @@
 #define __NR_syncfs		348
 #define __NR_sendmmsg		349
 #define __NR_setns		350
+#define __NR_process_vm_readv	351
+#define __NR_process_vm_writev	352
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		351
+#define __NR_syscalls		353
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff -puN arch/x86/ia32/ia32entry.S~cross-memory-attach-v3 arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~cross-memory-attach-v3
+++ a/arch/x86/ia32/ia32entry.S
@@ -850,4 +850,6 @@ ia32_sys_call_table:
 	.quad sys_syncfs
 	.quad compat_sys_sendmmsg	/* 345 */
 	.quad sys_setns
+	.quad compat_sys_process_vm_readv
+	.quad compat_sys_process_vm_writev
 ia32_syscall_end:
diff -puN arch/x86/include/asm/unistd_32.h~cross-memory-attach-v3 arch/x86/include/asm/unistd_32.h
--- a/arch/x86/include/asm/unistd_32.h~cross-memory-attach-v3
+++ a/arch/x86/include/asm/unistd_32.h
@@ -352,10 +352,12 @@
 #define __NR_syncfs             344
 #define __NR_sendmmsg		345
 #define __NR_setns		346
+#define __NR_process_vm_readv	347
+#define __NR_process_vm_writev	348
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 347
+#define NR_syscalls 349
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN arch/x86/include/asm/unistd_64.h~cross-memory-attach-v3 arch/x86/include/asm/unistd_64.h
--- a/arch/x86/include/asm/unistd_64.h~cross-memory-attach-v3
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
diff -puN arch/x86/kernel/syscall_table_32.S~cross-memory-attach-v3 arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~cross-memory-attach-v3
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -346,3 +346,5 @@ ENTRY(sys_call_table)
 	.long sys_syncfs
 	.long sys_sendmmsg		/* 345 */
 	.long sys_setns
+	.long sys_process_vm_readv
+	.long sys_process_vm_writev
diff -puN fs/aio.c~cross-memory-attach-v3 fs/aio.c
--- a/fs/aio.c~cross-memory-attach-v3
+++ a/fs/aio.c
@@ -1387,13 +1387,13 @@ static ssize_t aio_setup_vectored_rw(int
 		ret = compat_rw_copy_check_uvector(type,
 				(struct compat_iovec __user *)kiocb->ki_buf,
 				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
-				&kiocb->ki_iovec);
+				&kiocb->ki_iovec, 1);
 	else
 #endif
 		ret = rw_copy_check_uvector(type,
 				(struct iovec __user *)kiocb->ki_buf,
 				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
-				&kiocb->ki_iovec);
+				&kiocb->ki_iovec, 1);
 	if (ret < 0)
 		goto out;
 
diff -puN fs/compat.c~cross-memory-attach-v3 fs/compat.c
--- a/fs/compat.c~cross-memory-attach-v3
+++ a/fs/compat.c
@@ -546,7 +546,7 @@ out:
 ssize_t compat_rw_copy_check_uvector(int type,
 		const struct compat_iovec __user *uvector, unsigned long nr_segs,
 		unsigned long fast_segs, struct iovec *fast_pointer,
-		struct iovec **ret_pointer)
+		struct iovec **ret_pointer, int check_access)
 {
 	compat_ssize_t tot_len;
 	struct iovec *iov = *ret_pointer = fast_pointer;
@@ -593,7 +593,8 @@ ssize_t compat_rw_copy_check_uvector(int
 		}
 		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
 			goto out;
-		if (!access_ok(vrfy_dir(type), compat_ptr(buf), len)) {
+		if (check_access &&
+		    !access_ok(vrfy_dir(type), compat_ptr(buf), len)) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1107,7 +1108,7 @@ static ssize_t compat_do_readv_writev(in
 		goto out;
 
 	tot_len = compat_rw_copy_check_uvector(type, uvector, nr_segs,
-					       UIO_FASTIOV, iovstack, &iov);
+					       UIO_FASTIOV, iovstack, &iov, 1);
 	if (tot_len == 0) {
 		ret = 0;
 		goto out;
diff -puN fs/read_write.c~cross-memory-attach-v3 fs/read_write.c
--- a/fs/read_write.c~cross-memory-attach-v3
+++ a/fs/read_write.c
@@ -633,7 +633,8 @@ ssize_t do_loop_readv_writev(struct file
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,
-			      struct iovec **ret_pointer)
+			      struct iovec **ret_pointer,
+			      int check_access)
 {
 	unsigned long seg;
 	ssize_t ret;
@@ -689,7 +690,8 @@ ssize_t rw_copy_check_uvector(int type, 
 			ret = -EINVAL;
 			goto out;
 		}
-		if (unlikely(!access_ok(vrfy_dir(type), buf, len))) {
+		if (check_access
+		    && unlikely(!access_ok(vrfy_dir(type), buf, len))) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -721,7 +723,7 @@ static ssize_t do_readv_writev(int type,
 	}
 
 	ret = rw_copy_check_uvector(type, uvector, nr_segs,
-			ARRAY_SIZE(iovstack), iovstack, &iov);
+				    ARRAY_SIZE(iovstack), iovstack, &iov, 1);
 	if (ret <= 0)
 		goto out;
 
diff -puN include/linux/compat.h~cross-memory-attach-v3 include/linux/compat.h
--- a/include/linux/compat.h~cross-memory-attach-v3
+++ a/include/linux/compat.h
@@ -547,7 +547,8 @@ extern ssize_t compat_rw_copy_check_uvec
 		const struct compat_iovec __user *uvector,
 		unsigned long nr_segs,
 		unsigned long fast_segs, struct iovec *fast_pointer,
-		struct iovec **ret_pointer);
+		struct iovec **ret_pointer,
+		int check_access);
 
 extern void __user *compat_alloc_user_space(unsigned long len);
 
diff -puN include/linux/fs.h~cross-memory-attach-v3 include/linux/fs.h
--- a/include/linux/fs.h~cross-memory-attach-v3
+++ a/include/linux/fs.h
@@ -1633,9 +1633,10 @@ struct inode_operations {
 struct seq_file;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
-				unsigned long nr_segs, unsigned long fast_segs,
-				struct iovec *fast_pointer,
-				struct iovec **ret_pointer);
+			      unsigned long nr_segs, unsigned long fast_segs,
+			      struct iovec *fast_pointer,
+			      struct iovec **ret_pointer,
+			      int check_access);
 
 extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
diff -puN include/linux/syscalls.h~cross-memory-attach-v3 include/linux/syscalls.h
--- a/include/linux/syscalls.h~cross-memory-attach-v3
+++ a/include/linux/syscalls.h
@@ -844,4 +844,17 @@ asmlinkage long sys_open_by_handle_at(in
 				      struct file_handle __user *handle,
 				      int flags);
 asmlinkage long sys_setns(int fd, int nstype);
+asmlinkage long sys_process_vm_readv(pid_t pid,
+				     const struct iovec __user *lvec,
+				     unsigned long liovcnt,
+				     const struct iovec __user *rvec,
+				     unsigned long riovcnt,
+				     unsigned long flags);
+asmlinkage long sys_process_vm_writev(pid_t pid,
+				      const struct iovec __user *lvec,
+				      unsigned long liovcnt,
+				      const struct iovec __user *rvec,
+				      unsigned long riovcnt,
+				      unsigned long flags);
+
 #endif
diff -puN kernel/sys_ni.c~cross-memory-attach-v3 kernel/sys_ni.c
--- a/kernel/sys_ni.c~cross-memory-attach-v3
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
diff -puN mm/Makefile~cross-memory-attach-v3 mm/Makefile
--- a/mm/Makefile~cross-memory-attach-v3
+++ a/mm/Makefile
@@ -5,7 +5,8 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o pagewalk.o pgtable-generic.o
+			   vmalloc.o pagewalk.o pgtable-generic.o \
+			   process_vm_access.o
 
 obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
diff -puN /dev/null mm/process_vm_access.c
--- /dev/null
+++ a/mm/process_vm_access.c
@@ -0,0 +1,496 @@
+/*
+ * linux/mm/process_vm_access.c
+ *
+ * Copyright (C) 2010-2011 Christopher Yeoh <cyeoh@au1.ibm.com>, IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/mm.h>
+#include <linux/uio.h>
+#include <linux/sched.h>
+#include <linux/highmem.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+#endif
+
+/**
+ * process_vm_rw_pages - read/write pages from task specified
+ * @task: task to read/write from
+ * @mm: mm for task
+ * @process_pages: struct pages area that can store at least
+ *  nr_pages_to_copy struct page pointers
+ * @pa: address of page in task to start copying from/to
+ * @start_offset: offset in page to start copying from/to
+ * @len: number of bytes to copy
+ * @lvec: iovec array specifying where to copy to/from
+ * @lvec_cnt: number of elements in iovec array
+ * @lvec_current: index in iovec array we are up to
+ * @lvec_offset: offset in bytes from current iovec iov_base we are up to
+ * @vm_write: 0 means copy from, 1 means copy to
+ * @nr_pages_to_copy: number of pages to copy
+ * @bytes_copied: returns number of bytes successfully copied
+ * Returns 0 on success, error code otherwise
+ */
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
+{
+	int pages_pinned;
+	void *target_kaddr;
+	int pgs_copied = 0;
+	int j;
+	int ret;
+	ssize_t bytes_to_copy;
+	ssize_t rc = 0;
+
+	*bytes_copied = 0;
+
+	/* Get the pages we're interested in */
+	down_read(&mm->mmap_sem);
+	pages_pinned = get_user_pages(task, mm, pa,
+				      nr_pages_to_copy,
+				      vm_write, 0, process_pages, NULL);
+	up_read(&mm->mmap_sem);
+
+	if (pages_pinned != nr_pages_to_copy) {
+		rc = -EFAULT;
+		goto end;
+	}
+
+	/* Do the copy for each page */
+	for (pgs_copied = 0;
+	     (pgs_copied < nr_pages_to_copy) && (*lvec_current < lvec_cnt);
+	     pgs_copied++) {
+		/* Make sure we have a non zero length iovec */
+		while (*lvec_current < lvec_cnt
+		       && lvec[*lvec_current].iov_len == 0)
+			(*lvec_current)++;
+		if (*lvec_current == lvec_cnt)
+			break;
+
+		/*
+		 * Will copy smallest of:
+		 * - bytes remaining in page
+		 * - bytes remaining in destination iovec
+		 */
+		bytes_to_copy = min_t(ssize_t, PAGE_SIZE - start_offset,
+				      len - *bytes_copied);
+		bytes_to_copy = min_t(ssize_t, bytes_to_copy,
+				      lvec[*lvec_current].iov_len
+				      - *lvec_offset);
+
+		target_kaddr = kmap(process_pages[pgs_copied]) + start_offset;
+
+		if (vm_write)
+			ret = copy_from_user(target_kaddr,
+					     lvec[*lvec_current].iov_base
+					     + *lvec_offset,
+					     bytes_to_copy);
+		else
+			ret = copy_to_user(lvec[*lvec_current].iov_base
+					   + *lvec_offset,
+					   target_kaddr, bytes_to_copy);
+		kunmap(process_pages[pgs_copied]);
+		if (ret) {
+			*bytes_copied += bytes_to_copy - ret;
+			pgs_copied++;
+			rc = -EFAULT;
+			goto end;
+		}
+		*bytes_copied += bytes_to_copy;
+		*lvec_offset += bytes_to_copy;
+		if (*lvec_offset == lvec[*lvec_current].iov_len) {
+			/*
+			 * Need to copy remaining part of page into the
+			 * next iovec if there are any bytes left in page
+			 */
+			(*lvec_current)++;
+			*lvec_offset = 0;
+			start_offset = (start_offset + bytes_to_copy)
+				% PAGE_SIZE;
+			if (start_offset)
+				pgs_copied--;
+		} else {
+			start_offset = 0;
+		}
+	}
+
+end:
+	if (vm_write) {
+		for (j = 0; j < pages_pinned; j++) {
+			if (j < pgs_copied)
+				set_page_dirty_lock(process_pages[j]);
+			put_page(process_pages[j]);
+		}
+	} else {
+		for (j = 0; j < pages_pinned; j++)
+			put_page(process_pages[j]);
+	}
+
+	return rc;
+}
+
+/* Maximum number of pages kmalloc'd to hold struct page's during copy */
+#define PVM_MAX_KMALLOC_PAGES (PAGE_SIZE * 2)
+
+/**
+ * process_vm_rw_single_vec - read/write pages from task specified
+ * @addr: start memory address of target process
+ * @len: size of area to copy to/from
+ * @lvec: iovec array specifying where to copy to/from locally
+ * @lvec_cnt: number of elements in iovec array
+ * @lvec_current: index in iovec array we are up to
+ * @lvec_offset: offset in bytes from current iovec iov_base we are up to
+ * @process_pages: struct pages area that can store at least
+ *  nr_pages_to_copy struct page pointers
+ * @mm: mm for task
+ * @task: task to read/write from
+ * @vm_write: 0 means copy from, 1 means copy to
+ * @bytes_copied: returns number of bytes successfully copied
+ * Returns 0 on success or on failure error code
+ */
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
+{
+	unsigned long pa = addr & PAGE_MASK;
+	unsigned long start_offset = addr - pa;
+	unsigned long nr_pages;
+	ssize_t bytes_copied_loop;
+	ssize_t rc = 0;
+	unsigned long nr_pages_copied = 0;
+	unsigned long nr_pages_to_copy;
+	unsigned long max_pages_per_loop = PVM_MAX_KMALLOC_PAGES
+		/ sizeof(struct pages *);
+
+	*bytes_copied = 0;
+
+	/* Work out address and page range required */
+	if (len == 0)
+		return 0;
+	nr_pages = (addr + len - 1) / PAGE_SIZE - addr / PAGE_SIZE + 1;
+
+	while ((nr_pages_copied < nr_pages) && (*lvec_current < lvec_cnt)) {
+		nr_pages_to_copy = min(nr_pages - nr_pages_copied,
+				       max_pages_per_loop);
+
+		rc = process_vm_rw_pages(task, mm, process_pages, pa,
+					 start_offset, len,
+					 lvec, lvec_cnt,
+					 lvec_current, lvec_offset,
+					 vm_write, nr_pages_to_copy,
+					 &bytes_copied_loop);
+		start_offset = 0;
+		*bytes_copied += bytes_copied_loop;
+
+		if (rc < 0) {
+			return rc;
+		} else {
+			len -= bytes_copied_loop;
+			nr_pages_copied += nr_pages_to_copy;
+			pa += nr_pages_to_copy * PAGE_SIZE;
+		}
+	}
+
+	return rc;
+}
+
+/* Maximum number of entries for process pages array
+   which lives on stack */
+#define PVM_MAX_PP_ARRAY_COUNT 16
+
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
+{
+	struct task_struct *task;
+	struct page *pp_stack[PVM_MAX_PP_ARRAY_COUNT];
+	struct page **process_pages = pp_stack;
+	struct mm_struct *mm;
+	unsigned long i;
+	ssize_t rc = 0;
+	ssize_t bytes_copied_loop;
+	ssize_t bytes_copied = 0;
+	unsigned long nr_pages = 0;
+	unsigned long nr_pages_iov;
+	unsigned long iov_l_curr_idx = 0;
+	size_t iov_l_curr_offset = 0;
+	ssize_t iov_len;
+
+	/*
+	 * Work out how many pages of struct pages we're going to need
+	 * when eventually calling get_user_pages
+	 */
+	for (i = 0; i < riovcnt; i++) {
+		iov_len = rvec[i].iov_len;
+		if (iov_len > 0) {
+			nr_pages_iov = ((unsigned long)rvec[i].iov_base
+					+ iov_len)
+				/ PAGE_SIZE - (unsigned long)rvec[i].iov_base
+				/ PAGE_SIZE + 1;
+			nr_pages = max(nr_pages, nr_pages_iov);
+		}
+	}
+
+	if (nr_pages == 0)
+		return 0;
+
+	if (nr_pages > PVM_MAX_PP_ARRAY_COUNT) {
+		/* For reliability don't try to kmalloc more than
+		   2 pages worth */
+		process_pages = kmalloc(min_t(size_t, PVM_MAX_KMALLOC_PAGES,
+					      sizeof(struct pages *)*nr_pages),
+					GFP_KERNEL);
+
+		if (!process_pages)
+			return -ENOMEM;
+	}
+
+	/* Get process information */
+	rcu_read_lock();
+	task = find_task_by_vpid(pid);
+	if (task)
+		get_task_struct(task);
+	rcu_read_unlock();
+	if (!task) {
+		rc = -ESRCH;
+		goto free_proc_pages;
+	}
+
+	task_lock(task);
+	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
+		task_unlock(task);
+		rc = -EPERM;
+		goto put_task_struct;
+	}
+	mm = task->mm;
+
+	if (!mm || (task->flags & PF_KTHREAD)) {
+		task_unlock(task);
+		rc = -EINVAL;
+		goto put_task_struct;
+	}
+
+	atomic_inc(&mm->mm_users);
+	task_unlock(task);
+
+	for (i = 0; i < riovcnt && iov_l_curr_idx < liovcnt; i++) {
+		rc = process_vm_rw_single_vec(
+			(unsigned long)rvec[i].iov_base, rvec[i].iov_len,
+			lvec, liovcnt, &iov_l_curr_idx, &iov_l_curr_offset,
+			process_pages, mm, task, vm_write, &bytes_copied_loop);
+		bytes_copied += bytes_copied_loop;
+		if (rc != 0) {
+			/* If we have managed to copy any data at all then
+			   we return the number of bytes copied. Otherwise
+			   we return the error code */
+			if (bytes_copied)
+				rc = bytes_copied;
+			goto put_mm;
+		}
+	}
+
+	rc = bytes_copied;
+put_mm:
+	mmput(mm);
+
+put_task_struct:
+	put_task_struct(task);
+
+free_proc_pages:
+	if (process_pages != pp_stack)
+		kfree(process_pages);
+	return rc;
+}
+
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
+{
+	struct iovec iovstack_l[UIO_FASTIOV];
+	struct iovec iovstack_r[UIO_FASTIOV];
+	struct iovec *iov_l = iovstack_l;
+	struct iovec *iov_r = iovstack_r;
+	ssize_t rc;
+
+	if (flags != 0)
+		return -EINVAL;
+
+	/* Check iovecs */
+	if (vm_write)
+		rc = rw_copy_check_uvector(WRITE, lvec, liovcnt, UIO_FASTIOV,
+					   iovstack_l, &iov_l, 1);
+	else
+		rc = rw_copy_check_uvector(READ, lvec, liovcnt, UIO_FASTIOV,
+					   iovstack_l, &iov_l, 1);
+	if (rc <= 0)
+		goto free_iovecs;
+
+	rc = rw_copy_check_uvector(READ, rvec, riovcnt, UIO_FASTIOV,
+				   iovstack_r, &iov_r, 0);
+	if (rc <= 0)
+		goto free_iovecs;
+
+	rc = process_vm_rw_core(pid, iov_l, liovcnt, iov_r, riovcnt, flags,
+				vm_write);
+
+free_iovecs:
+	if (iov_r != iovstack_r)
+		kfree(iov_r);
+	if (iov_l != iovstack_l)
+		kfree(iov_l);
+
+	return rc;
+}
+
+SYSCALL_DEFINE6(process_vm_readv, pid_t, pid, const struct iovec __user *, lvec,
+		unsigned long, liovcnt, const struct iovec __user *, rvec,
+		unsigned long, riovcnt,	unsigned long, flags)
+{
+	return process_vm_rw(pid, lvec, liovcnt, rvec, riovcnt, flags, 0);
+}
+
+SYSCALL_DEFINE6(process_vm_writev, pid_t, pid,
+		const struct iovec __user *, lvec,
+		unsigned long, liovcnt, const struct iovec __user *, rvec,
+		unsigned long, riovcnt,	unsigned long, flags)
+{
+	return process_vm_rw(pid, lvec, liovcnt, rvec, riovcnt, flags, 1);
+}
+
+#ifdef CONFIG_COMPAT
+
+asmlinkage ssize_t
+compat_process_vm_rw(compat_pid_t pid,
+		     const struct compat_iovec __user *lvec,
+		     unsigned long liovcnt,
+		     const struct compat_iovec __user *rvec,
+		     unsigned long riovcnt,
+		     unsigned long flags, int vm_write)
+{
+	struct iovec iovstack_l[UIO_FASTIOV];
+	struct iovec iovstack_r[UIO_FASTIOV];
+	struct iovec *iov_l = iovstack_l;
+	struct iovec *iov_r = iovstack_r;
+	ssize_t rc = -EFAULT;
+
+	if (flags != 0)
+		return -EINVAL;
+
+	if (!access_ok(VERIFY_READ, lvec, liovcnt * sizeof(*lvec)))
+		goto out;
+
+	if (!access_ok(VERIFY_READ, rvec, riovcnt * sizeof(*rvec)))
+		goto out;
+
+	if (vm_write)
+		rc = compat_rw_copy_check_uvector(WRITE, lvec, liovcnt,
+						  UIO_FASTIOV, iovstack_l,
+						  &iov_l, 1);
+	else
+		rc = compat_rw_copy_check_uvector(READ, lvec, liovcnt,
+						  UIO_FASTIOV, iovstack_l,
+						  &iov_l, 1);
+	if (rc <= 0)
+		goto free_iovecs;
+	rc = compat_rw_copy_check_uvector(READ, rvec, riovcnt,
+					  UIO_FASTIOV, iovstack_r,
+					  &iov_r, 0);
+	if (rc <= 0)
+		goto free_iovecs;
+
+	rc = process_vm_rw_core(pid, iov_l, liovcnt, iov_r, riovcnt, flags,
+			   vm_write);
+
+free_iovecs:
+	if (iov_r != iovstack_r)
+		kfree(iov_r);
+	if (iov_l != iovstack_l)
+		kfree(iov_l);
+
+out:
+	return rc;
+}
+
+asmlinkage ssize_t
+compat_sys_process_vm_readv(compat_pid_t pid,
+			    const struct compat_iovec __user *lvec,
+			    unsigned long liovcnt,
+			    const struct compat_iovec __user *rvec,
+			    unsigned long riovcnt,
+			    unsigned long flags)
+{
+	return compat_process_vm_rw(pid, lvec, liovcnt, rvec,
+				    riovcnt, flags, 0);
+}
+
+asmlinkage ssize_t
+compat_sys_process_vm_writev(compat_pid_t pid,
+			     const struct compat_iovec __user *lvec,
+			     unsigned long liovcnt,
+			     const struct compat_iovec __user *rvec,
+			     unsigned long riovcnt,
+			     unsigned long flags)
+{
+	return compat_process_vm_rw(pid, lvec, liovcnt, rvec,
+				    riovcnt, flags, 1);
+}
+
+#endif
diff -puN security/keys/compat.c~cross-memory-attach-v3 security/keys/compat.c
--- a/security/keys/compat.c~cross-memory-attach-v3
+++ a/security/keys/compat.c
@@ -38,7 +38,7 @@ long compat_keyctl_instantiate_key_iov(
 
 	ret = compat_rw_copy_check_uvector(WRITE, _payload_iov, ioc,
 					   ARRAY_SIZE(iovstack),
-					   iovstack, &iov);
+					   iovstack, &iov, 1);
 	if (ret < 0)
 		return ret;
 	if (ret == 0)
diff -puN security/keys/keyctl.c~cross-memory-attach-v3 security/keys/keyctl.c
--- a/security/keys/keyctl.c~cross-memory-attach-v3
+++ a/security/keys/keyctl.c
@@ -1065,7 +1065,7 @@ long keyctl_instantiate_key_iov(key_seri
 		goto no_payload;
 
 	ret = rw_copy_check_uvector(WRITE, _payload_iov, ioc,
-				    ARRAY_SIZE(iovstack), iovstack, &iov);
+				    ARRAY_SIZE(iovstack), iovstack, &iov, 1);
 	if (ret < 0)
 		return ret;
 	if (ret == 0)
_

Patches currently in -mm which might be from cyeoh@au1.ibm.com are

origin.patch

