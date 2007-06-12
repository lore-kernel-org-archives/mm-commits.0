From: akpm@linux-foundation.org
Subject: + uml-remove-page_size-from-libc-code.patch added to -mm tree
Date: Tue, 12 Jun 2007 14:06:11 -0700
Message-ID: <200706122106.l5CL6BRh021183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbXFLVGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 17:06:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: remove PAGE_SIZE from libc code
has been added to the -mm tree.  Its filename is
     uml-remove-page_size-from-libc-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove PAGE_SIZE from libc code
From: Jeff Dike <jdike@addtoit.com>

Distros seem to be removing PAGE_SIZE from asm/page.h.  So, the libc side of
UML should stop using it.

I replace it with UM_KERN_PAGE_SIZE, which is defined to be the same as
PAGE_SIZE on the kernel side of the house.  I could also use getpagesize(),
but it's more important that UML have the same value of PAGE_SIZE everywhere. 
It's conceivable that it could be built with a larger PAGE_SIZE, and use of
getpagesize() would break that badly.

PAGE_MASK got the same treatment, as it is closely tied to PAGE_SIZE.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/common-offsets.h |    1 +
 arch/um/os-Linux/main.c          |    4 +++-
 arch/um/os-Linux/skas/mem.c      |   13 +++++++------
 arch/um/os-Linux/skas/process.c  |   13 +++++++------
 arch/um/os-Linux/start_up.c      |    7 ++++---
 5 files changed, 22 insertions(+), 16 deletions(-)

diff -puN arch/um/include/common-offsets.h~uml-remove-page_size-from-libc-code arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-remove-page_size-from-libc-code
+++ a/arch/um/include/common-offsets.h
@@ -9,6 +9,7 @@ OFFSET(HOST_TASK_REGS, task_struct, thre
 OFFSET(HOST_TASK_PID, task_struct, pid);
 
 DEFINE(UM_KERN_PAGE_SIZE, PAGE_SIZE);
+DEFINE(UM_KERN_PAGE_MASK, PAGE_MASK);
 DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
 
 DEFINE_STR(UM_KERN_EMERG, KERN_EMERG);
diff -puN arch/um/os-Linux/main.c~uml-remove-page_size-from-libc-code arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-remove-page_size-from-libc-code
+++ a/arch/um/os-Linux/main.c
@@ -24,6 +24,7 @@
 #include "uml-config.h"
 #include "os.h"
 #include "um_malloc.h"
+#include "kern_constants.h"
 
 /* Set in main, unchanged thereafter */
 char *linux_prog;
@@ -232,7 +233,8 @@ void *__wrap_malloc(int size)
 
 	if(!CAN_KMALLOC())
 		return __real_malloc(size);
-	else if(size <= PAGE_SIZE) /* finding contiguos pages can be hard*/
+	else if(size <= UM_KERN_PAGE_SIZE)
+		/* finding contiguous pages can be hard*/
 		ret = um_kmalloc(size);
 	else ret = um_vmalloc(size);
 
diff -puN arch/um/os-Linux/skas/mem.c~uml-remove-page_size-from-libc-code arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-remove-page_size-from-libc-code
+++ a/arch/um/os-Linux/skas/mem.c
@@ -25,6 +25,7 @@
 #include "sysdep/ptrace.h"
 #include "sysdep/stub.h"
 #include "init.h"
+#include "kern_constants.h"
 
 extern unsigned long batch_syscall_stub, __syscall_stub_start;
 
@@ -149,8 +150,8 @@ long run_syscall_stub(struct mm_id * mm_
 	*stack = 0;
 	multi_op_count++;
 
-	if(!done && ((((unsigned long) stack) & ~PAGE_MASK) <
-		     PAGE_SIZE - 10 * sizeof(long))){
+	if(!done && ((((unsigned long) stack) & ~UM_KERN_PAGE_MASK) <
+		     UM_KERN_PAGE_SIZE - 10 * sizeof(long))){
 		*addr = stack;
 		return 0;
 	}
@@ -168,8 +169,8 @@ long syscall_stub_data(struct mm_id * mm
 	/* If *addr still is uninitialized, it *must* contain NULL.
 	 * Thus in this case do_syscall_stub correctly won't be called.
 	 */
-	if((((unsigned long) *addr) & ~PAGE_MASK) >=
-	   PAGE_SIZE - (10 + data_count) * sizeof(long)) {
+	if((((unsigned long) *addr) & ~UM_KERN_PAGE_MASK) >=
+	   UM_KERN_PAGE_SIZE - (10 + data_count) * sizeof(long)) {
 		ret = do_syscall_stub(mm_idp, addr);
 		/* in case of error, don't overwrite data on stack */
 		if(ret)
@@ -183,8 +184,8 @@ long syscall_stub_data(struct mm_id * mm
 
 	memcpy(stack + 1, data, data_count * sizeof(long));
 
-	*stub_addr = (void *)(((unsigned long)(stack + 1) & ~PAGE_MASK) +
-			      UML_CONFIG_STUB_DATA);
+	*stub_addr = (void *)(((unsigned long)(stack + 1) &
+			       ~UM_KERN_PAGE_MASK) + UML_CONFIG_STUB_DATA);
 
 	return 0;
 }
diff -puN arch/um/os-Linux/skas/process.c~uml-remove-page_size-from-libc-code arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-remove-page_size-from-libc-code
+++ a/arch/um/os-Linux/skas/process.c
@@ -252,11 +252,12 @@ int start_userspace(unsigned long stub_s
 	unsigned long sp;
 	int pid, status, n, flags;
 
-	stack = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC,
+	stack = mmap(NULL, UM_KERN_PAGE_SIZE,
+		     PROT_READ | PROT_WRITE | PROT_EXEC,
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if(stack == MAP_FAILED)
 		panic("start_userspace : mmap failed, errno = %d", errno);
-	sp = (unsigned long) stack + PAGE_SIZE - sizeof(void *);
+	sp = (unsigned long) stack + UM_KERN_PAGE_SIZE - sizeof(void *);
 
 	flags = CLONE_FILES | SIGCHLD;
 	if(proc_mm) flags |= CLONE_VM;
@@ -279,7 +280,7 @@ int start_userspace(unsigned long stub_s
 		panic("start_userspace : PTRACE_OLDSETOPTIONS failed, errno=%d\n",
 		      errno);
 
-	if(munmap(stack, PAGE_SIZE) < 0)
+	if(munmap(stack, UM_KERN_PAGE_SIZE) < 0)
 		panic("start_userspace : munmap failed, errno = %d\n", errno);
 
 	return(pid);
@@ -365,7 +366,7 @@ static int __init init_thread_regs(void)
 	thread_regs[REGS_IP_INDEX] = UML_CONFIG_STUB_CODE +
 				(unsigned long) stub_clone_handler -
 				(unsigned long) &__syscall_stub_start;
-	thread_regs[REGS_SP_INDEX] = UML_CONFIG_STUB_DATA + PAGE_SIZE -
+	thread_regs[REGS_SP_INDEX] = UML_CONFIG_STUB_DATA + UM_KERN_PAGE_SIZE -
 		sizeof(void *);
 #ifdef __SIGNAL_FRAMESIZE
 	thread_regs[REGS_SP_INDEX] -= __SIGNAL_FRAMESIZE;
@@ -453,7 +454,7 @@ void map_stub_pages(int fd, unsigned lon
 				      .u         =
 				      { .mmap    =
 					{ .addr    = code,
-					  .len     = PAGE_SIZE,
+					  .len     = UM_KERN_PAGE_SIZE,
 					  .prot    = PROT_EXEC,
 					  .flags   = MAP_FIXED | MAP_PRIVATE,
 					  .fd      = code_fd,
@@ -476,7 +477,7 @@ void map_stub_pages(int fd, unsigned lon
 				  .u         =
 				  { .mmap    =
 				    { .addr    = data,
-				      .len     = PAGE_SIZE,
+				      .len     = UM_KERN_PAGE_SIZE,
 				      .prot    = PROT_READ | PROT_WRITE,
 				      .flags   = MAP_FIXED | MAP_SHARED,
 				      .fd      = map_fd,
diff -puN arch/um/os-Linux/start_up.c~uml-remove-page_size-from-libc-code arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-remove-page_size-from-libc-code
+++ a/arch/um/os-Linux/start_up.c
@@ -107,11 +107,12 @@ static int start_ptraced_child(void **st
 	unsigned long sp;
 	int pid, n, status;
 
-	stack = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC,
+	stack = mmap(NULL, UM_KERN_PAGE_SIZE,
+		     PROT_READ | PROT_WRITE | PROT_EXEC,
 		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if(stack == MAP_FAILED)
 		fatal_perror("check_ptrace : mmap failed");
-	sp = (unsigned long) stack + PAGE_SIZE - sizeof(void *);
+	sp = (unsigned long) stack + UM_KERN_PAGE_SIZE - sizeof(void *);
 	pid = clone(ptrace_child, (void *) sp, SIGCHLD, NULL);
 	if(pid < 0)
 		fatal_perror("start_ptraced_child : clone failed");
@@ -153,7 +154,7 @@ static int stop_ptraced_child(int pid, v
 		ret = -1;
 	}
 
-	if(munmap(stack, PAGE_SIZE) < 0)
+	if(munmap(stack, UM_KERN_PAGE_SIZE) < 0)
 		fatal_perror("check_ptrace : munmap failed");
 	return ret;
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-remove-page_size-from-libc-code.patch
uml-kill-x86_64-stack_top_max.patch
hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
