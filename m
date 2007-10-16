From: akpm@linux-foundation.org
Subject: - uml-fix-stub-address-calculations.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:08 -0700
Message-ID: <200710162039.l9GKd8MO015519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935722AbXJPVTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:19:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix stub address calculations
has been removed from the -mm tree.  Its filename was
     uml-fix-stub-address-calculations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix stub address calculations
From: Jeff Dike <jdike@addtoit.com>

The calculation of CONFIG_STUB_CODE and CONFIG_STUB_DATA didn't take into
account anything but 3G/1G and 2G/2G, leaving the other vmsplits out in the
cold.

I'd rather not duplicate the four known host vmsplit cases for each of these
symbols.  I'd also like to calculate them based on the highest userspace
address.

The Kconfig language seems not to allow calculation of hex constants, so I
moved this to as-layout.h.  CONFIG_STUB_CODE, CONFIG_STUB_DATA, and
CONFIG_STUB_START are now gone.  In their place are STUB_CODE, STUB_DATA, and
STUB_START in as-layout.h.

i386 and x86_64 seem to differ as to whether an unadorned constant is an int
or a long, so I cast them to unsigned long so they can be printed
consistently.  However, they are also used in stub.S, where C types don't work
so well.  So, there are ASM_ versions of these constants for use in stub.S.  I
also ifdef-ed the non-asm-friendly portion of as-layout.h.

With this in place, most of the rest of this patch is changing CONFIG_STUB_*
to STUB_*, except in stub.S, where they are changed to ASM_STUB_*.

defconfig has the old symbols deleted.

I also print these addresses out in case there is any problem mapping them on
the host.

The two stub.S files had some trailing whitespace, so that is cleaned up here.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.i386                 |   14 --------------
 arch/um/Kconfig.x86_64               |   14 +-------------
 arch/um/defconfig                    |    3 ---
 arch/um/include/as-layout.h          |   24 ++++++++++++++++++++++++
 arch/um/include/sysdep-i386/stub.h   |   11 ++++++-----
 arch/um/include/sysdep-x86_64/stub.h |   13 +++++++------
 arch/um/kernel/exec.c                |    3 ++-
 arch/um/kernel/skas/clone.c          |    6 +++---
 arch/um/kernel/skas/mmu.c            |    5 +++--
 arch/um/kernel/skas/process.c        |    2 +-
 arch/um/kernel/tlb.c                 |    6 +++---
 arch/um/kernel/um_arch.c             |    3 ++-
 arch/um/os-Linux/skas/mem.c          |    8 ++++----
 arch/um/os-Linux/skas/process.c      |   21 +++++++++++----------
 arch/um/sys-i386/stub.S              |    9 +++++----
 arch/um/sys-i386/stub_segv.c         |    4 ++--
 arch/um/sys-x86_64/stub.S            |    9 +++++----
 arch/um/sys-x86_64/stub_segv.c       |    3 ++-
 18 files changed, 81 insertions(+), 77 deletions(-)

diff -puN arch/um/Kconfig.i386~uml-fix-stub-address-calculations arch/um/Kconfig.i386
--- a/arch/um/Kconfig.i386~uml-fix-stub-address-calculations
+++ a/arch/um/Kconfig.i386
@@ -65,20 +65,6 @@ config 3_LEVEL_PGTABLES
 	However, this it experimental on 32-bit architectures, so if unsure say
 	N (on x86-64 it's automatically enabled, instead, as it's safe there).
 
-config STUB_CODE
-	hex
-	default 0xbfffe000 if !HOST_VMSPLIT_2G
-	default 0x7fffe000 if HOST_VMSPLIT_2G
-
-config STUB_DATA
-	hex
-	default 0xbffff000 if !HOST_VMSPLIT_2G
-	default 0x7ffff000 if HOST_VMSPLIT_2G
-
-config STUB_START
-	hex
-	default STUB_CODE
-
 config ARCH_HAS_SC_SIGNALS
 	bool
 	default y
diff -puN arch/um/Kconfig.x86_64~uml-fix-stub-address-calculations arch/um/Kconfig.x86_64
--- a/arch/um/Kconfig.x86_64~uml-fix-stub-address-calculations
+++ a/arch/um/Kconfig.x86_64
@@ -17,24 +17,12 @@ config SEMAPHORE_SLEEPERS
 
 config TOP_ADDR
  	hex
-	default 0x80000000
+	default 0x7fc0000000
 
 config 3_LEVEL_PGTABLES
        bool
        default y
 
-config STUB_CODE
-	hex
-	default 0x7fbfffe000
-
-config STUB_DATA
-	hex
-	default 0x7fbffff000
-
-config STUB_START
-	hex
-	default STUB_CODE
-
 config ARCH_HAS_SC_SIGNALS
 	bool
 	default n
diff -puN arch/um/defconfig~uml-fix-stub-address-calculations arch/um/defconfig
--- a/arch/um/defconfig~uml-fix-stub-address-calculations
+++ a/arch/um/defconfig
@@ -59,9 +59,6 @@ CONFIG_SEMAPHORE_SLEEPERS=y
 # CONFIG_HOST_2G_2G is not set
 CONFIG_TOP_ADDR=0xc0000000
 # CONFIG_3_LEVEL_PGTABLES is not set
-CONFIG_STUB_CODE=0xbfffe000
-CONFIG_STUB_DATA=0xbffff000
-CONFIG_STUB_START=0xbfffe000
 CONFIG_ARCH_HAS_SC_SIGNALS=y
 CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA=y
 CONFIG_GENERIC_HWEIGHT=y
diff -puN arch/um/include/as-layout.h~uml-fix-stub-address-calculations arch/um/include/as-layout.h
--- a/arch/um/include/as-layout.h~uml-fix-stub-address-calculations
+++ a/arch/um/include/as-layout.h
@@ -6,6 +6,28 @@
 #ifndef __START_H__
 #define __START_H__
 
+#include "uml-config.h"
+#include "kern_constants.h"
+
+/*
+ * Assembly doesn't want any casting, but C does, so define these
+ * without casts here, and define new symbols with casts inside the C
+ * section.
+ */
+#define ASM_STUB_CODE (UML_CONFIG_TOP_ADDR - 2 * UM_KERN_PAGE_SIZE)
+#define ASM_STUB_DATA (UML_CONFIG_TOP_ADDR - UM_KERN_PAGE_SIZE)
+#define ASM_STUB_START ASM_STUB_CODE
+
+/*
+ * This file is included by the assembly stubs, which just want the
+ * definitions above.
+ */
+#ifndef __ASSEMBLY__
+
+#define STUB_CODE ((unsigned long) ASM_STUB_CODE)
+#define STUB_DATA ((unsigned long) ASM_STUB_DATA)
+#define STUB_START ((unsigned long) ASM_STUB_START)
+
 #include "sysdep/ptrace.h"
 
 struct cpu_task {
@@ -32,3 +54,5 @@ extern int linux_main(int argc, char **a
 extern void (*sig_info[])(int, struct uml_pt_regs *);
 
 #endif
+
+#endif
diff -puN arch/um/include/sysdep-i386/stub.h~uml-fix-stub-address-calculations arch/um/include/sysdep-i386/stub.h
--- a/arch/um/include/sysdep-i386/stub.h~uml-fix-stub-address-calculations
+++ a/arch/um/include/sysdep-i386/stub.h
@@ -9,6 +9,7 @@
 #include <sys/mman.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
+#include "as-layout.h"
 #include "stub-data.h"
 #include "kern_constants.h"
 #include "uml-config.h"
@@ -89,12 +90,12 @@ static inline void remap_stack(int fd, u
 {
 	__asm__ volatile ("movl %%eax,%%ebp ; movl %0,%%eax ; int $0x80 ;"
 			  "movl %7, %%ebx ; movl %%eax, (%%ebx)"
-			  : : "g" (STUB_MMAP_NR), "b" (UML_CONFIG_STUB_DATA), 
-			    "c" (UM_KERN_PAGE_SIZE), 
+			  : : "g" (STUB_MMAP_NR), "b" (STUB_DATA),
+			    "c" (UM_KERN_PAGE_SIZE),
 			    "d" (PROT_READ | PROT_WRITE),
-			    "S" (MAP_FIXED | MAP_SHARED), "D" (fd), 
-			    "a" (offset), 
-			    "i" (&((struct stub_data *) UML_CONFIG_STUB_DATA)->err) 
+			    "S" (MAP_FIXED | MAP_SHARED), "D" (fd),
+			    "a" (offset),
+			    "i" (&((struct stub_data *) STUB_DATA)->err)
 			  : "memory");
 }
 
diff -puN arch/um/include/sysdep-x86_64/stub.h~uml-fix-stub-address-calculations arch/um/include/sysdep-x86_64/stub.h
--- a/arch/um/include/sysdep-x86_64/stub.h~uml-fix-stub-address-calculations
+++ a/arch/um/include/sysdep-x86_64/stub.h
@@ -9,6 +9,7 @@
 #include <sys/mman.h>
 #include <asm/unistd.h>
 #include <sysdep/ptrace_user.h>
+#include "as-layout.h"
 #include "stub-data.h"
 #include "kern_constants.h"
 #include "uml-config.h"
@@ -94,13 +95,13 @@ static inline void remap_stack(long fd, 
 {
 	__asm__ volatile ("movq %4,%%r10 ; movq %5,%%r8 ; "
 			  "movq %6, %%r9; " __syscall "; movq %7, %%rbx ; "
-			  "movq %%rax, (%%rbx)": 
-			  : "a" (STUB_MMAP_NR), "D" (UML_CONFIG_STUB_DATA), 
-			    "S" (UM_KERN_PAGE_SIZE), 
-			    "d" (PROT_READ | PROT_WRITE), 
-                            "g" (MAP_FIXED | MAP_SHARED), "g" (fd), 
+			  "movq %%rax, (%%rbx)":
+			  : "a" (STUB_MMAP_NR), "D" (STUB_DATA),
+			    "S" (UM_KERN_PAGE_SIZE),
+			    "d" (PROT_READ | PROT_WRITE),
+                            "g" (MAP_FIXED | MAP_SHARED), "g" (fd),
 			    "g" (offset),
-			    "i" (&((struct stub_data *) UML_CONFIG_STUB_DATA)->err)
+			    "i" (&((struct stub_data *) STUB_DATA)->err)
 			  : __syscall_clobber, "r10", "r8", "r9" );
 }
 
diff -puN arch/um/kernel/exec.c~uml-fix-stub-address-calculations arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-fix-stub-address-calculations
+++ a/arch/um/kernel/exec.c
@@ -11,6 +11,7 @@
 #include "asm/current.h"
 #include "asm/processor.h"
 #include "asm/uaccess.h"
+#include "as-layout.h"
 #include "mem_user.h"
 #include "skas.h"
 #include "os.h"
@@ -18,7 +19,7 @@
 void flush_thread(void)
 {
 	void *data = NULL;
-	unsigned long end = proc_mm ? task_size : CONFIG_STUB_START;
+	unsigned long end = proc_mm ? task_size : STUB_START;
 	int ret;
 
 	arch_flush_thread(&current->thread.arch);
diff -puN arch/um/kernel/skas/clone.c~uml-fix-stub-address-calculations arch/um/kernel/skas/clone.c
--- a/arch/um/kernel/skas/clone.c~uml-fix-stub-address-calculations
+++ a/arch/um/kernel/skas/clone.c
@@ -4,6 +4,7 @@
 #include <sys/time.h>
 #include <asm/unistd.h>
 #include <asm/page.h>
+#include "as-layout.h"
 #include "ptrace_user.h"
 #include "skas.h"
 #include "stub-data.h"
@@ -21,12 +22,11 @@
 void __attribute__ ((__section__ (".__syscall_stub")))
 stub_clone_handler(void)
 {
-	struct stub_data *data = (struct stub_data *) UML_CONFIG_STUB_DATA;
+	struct stub_data *data = (struct stub_data *) STUB_DATA;
 	long err;
 
 	err = stub_syscall2(__NR_clone, CLONE_PARENT | CLONE_FILES | SIGCHLD,
-			    UML_CONFIG_STUB_DATA + UM_KERN_PAGE_SIZE / 2 -
-			    sizeof(void *));
+			    STUB_DATA + UM_KERN_PAGE_SIZE / 2 - sizeof(void *));
 	if(err != 0)
 		goto out;
 
diff -puN arch/um/kernel/skas/mmu.c~uml-fix-stub-address-calculations arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~uml-fix-stub-address-calculations
+++ a/arch/um/kernel/skas/mmu.c
@@ -7,6 +7,7 @@
 #include "linux/sched.h"
 #include "asm/pgalloc.h"
 #include "asm/pgtable.h"
+#include "as-layout.h"
 #include "os.h"
 #include "skas.h"
 
@@ -83,12 +84,12 @@ int init_new_context(struct task_struct 
 		 */
 		mm->pgd[USER_PTRS_PER_PGD] = __pgd(0);
 
-		ret = init_stub_pte(mm, CONFIG_STUB_CODE,
+		ret = init_stub_pte(mm, STUB_CODE,
 				    (unsigned long) &__syscall_stub_start);
 		if (ret)
 			goto out_free;
 
-		ret = init_stub_pte(mm, CONFIG_STUB_DATA, stack);
+		ret = init_stub_pte(mm, STUB_DATA, stack);
 		if (ret)
 			goto out_free;
 
diff -puN arch/um/kernel/skas/process.c~uml-fix-stub-address-calculations arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c~uml-fix-stub-address-calculations
+++ a/arch/um/kernel/skas/process.c
@@ -18,7 +18,7 @@ int new_mm(unsigned long stack)
 		return fd;
 
 	if (skas_needs_stub)
-		map_stub_pages(fd, CONFIG_STUB_CODE, CONFIG_STUB_DATA, stack);
+		map_stub_pages(fd, STUB_CODE, STUB_DATA, stack);
 
 	return fd;
 }
diff -puN arch/um/kernel/tlb.c~uml-fix-stub-address-calculations arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-fix-stub-address-calculations
+++ a/arch/um/kernel/tlb.c
@@ -485,8 +485,8 @@ void __flush_tlb_one(unsigned long addr)
 static void fix_range(struct mm_struct *mm, unsigned long start_addr,
 		      unsigned long end_addr, int force)
 {
-	if (!proc_mm && (end_addr > CONFIG_STUB_START))
-		end_addr = CONFIG_STUB_START;
+	if (!proc_mm && (end_addr > STUB_START))
+		end_addr = STUB_START;
 
 	fix_range_common(mm, start_addr, end_addr, force);
 }
@@ -510,7 +510,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 	if (atomic_read(&mm->mm_users) == 0)
 		return;
 
-	end = proc_mm ? task_size : CONFIG_STUB_START;
+	end = proc_mm ? task_size : STUB_START;
 	fix_range(mm, 0, end, 0);
 }
 
diff -puN arch/um/kernel/um_arch.c~uml-fix-stub-address-calculations arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-fix-stub-address-calculations
+++ a/arch/um/kernel/um_arch.c
@@ -242,7 +242,8 @@ static unsigned long set_task_sizes_skas
 
 	if (!skas_needs_stub)
 		*task_size_out = host_task_size;
-	else *task_size_out = CONFIG_STUB_START & PGDIR_MASK;
+	else
+		*task_size_out = STUB_START & PGDIR_MASK;
 
 	return host_task_size;
 }
diff -puN arch/um/os-Linux/skas/mem.c~uml-fix-stub-address-calculations arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-fix-stub-address-calculations
+++ a/arch/um/os-Linux/skas/mem.c
@@ -10,6 +10,7 @@
 #include <sys/mman.h>
 #include "init.h"
 #include "kern_constants.h"
+#include "as-layout.h"
 #include "mm_id.h"
 #include "os.h"
 #include "proc_mm.h"
@@ -40,7 +41,7 @@ static unsigned long syscall_regs[MAX_RE
 static int __init init_syscall_regs(void)
 {
 	get_safe_registers(syscall_regs);
-	syscall_regs[REGS_IP_INDEX] = UML_CONFIG_STUB_CODE +
+	syscall_regs[REGS_IP_INDEX] = STUB_CODE +
 		((unsigned long) &batch_syscall_stub -
 		 (unsigned long) &__syscall_stub_start);
 	return 0;
@@ -93,8 +94,7 @@ static inline long do_syscall_stub(struc
 	ret = *((unsigned long *) mm_idp->stack);
 	offset = *((unsigned long *) mm_idp->stack + 1);
 	if (offset) {
-		data = (unsigned long *)(mm_idp->stack +
-					 offset - UML_CONFIG_STUB_DATA);
+		data = (unsigned long *)(mm_idp->stack + offset - STUB_DATA);
 		printk(UM_KERN_ERR "do_syscall_stub : ret = %ld, offset = %ld, "
 		       "data = %p\n", ret, offset, data);
 		syscall = (unsigned long *)((unsigned long)data + data[0]);
@@ -182,7 +182,7 @@ long syscall_stub_data(struct mm_id * mm
 	memcpy(stack + 1, data, data_count * sizeof(long));
 
 	*stub_addr = (void *)(((unsigned long)(stack + 1) &
-			       ~UM_KERN_PAGE_MASK) + UML_CONFIG_STUB_DATA);
+			       ~UM_KERN_PAGE_MASK) + STUB_DATA);
 
 	return 0;
 }
diff -puN arch/um/os-Linux/skas/process.c~uml-fix-stub-address-calculations arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-fix-stub-address-calculations
+++ a/arch/um/os-Linux/skas/process.c
@@ -191,22 +191,23 @@ static int userspace_tramp(void *stack)
 		int fd;
 		unsigned long long offset;
 		fd = phys_mapping(to_phys(&__syscall_stub_start), &offset);
-		addr = mmap64((void *) UML_CONFIG_STUB_CODE, UM_KERN_PAGE_SIZE,
+		addr = mmap64((void *) STUB_CODE, UM_KERN_PAGE_SIZE,
 			      PROT_EXEC, MAP_FIXED | MAP_PRIVATE, fd, offset);
 		if (addr == MAP_FAILED) {
-			printk(UM_KERN_ERR "mapping mmap stub failed, "
-			       "errno = %d\n", errno);
+			printk(UM_KERN_ERR "mapping mmap stub at 0x%lx failed, "
+			       "errno = %d\n", STUB_CODE, errno);
 			exit(1);
 		}
 
 		if (stack != NULL) {
 			fd = phys_mapping(to_phys(stack), &offset);
-			addr = mmap((void *) UML_CONFIG_STUB_DATA,
+			addr = mmap((void *) STUB_DATA,
 				    UM_KERN_PAGE_SIZE, PROT_READ | PROT_WRITE,
 				    MAP_FIXED | MAP_SHARED, fd, offset);
 			if (addr == MAP_FAILED) {
 				printk(UM_KERN_ERR "mapping segfault stack "
-				       "failed, errno = %d\n", errno);
+				       "at 0x%lx failed, errno = %d\n",
+				       STUB_DATA, errno);
 				exit(1);
 			}
 		}
@@ -214,11 +215,11 @@ static int userspace_tramp(void *stack)
 	if (!ptrace_faultinfo && (stack != NULL)) {
 		struct sigaction sa;
 
-		unsigned long v = UML_CONFIG_STUB_CODE +
+		unsigned long v = STUB_CODE +
 				  (unsigned long) stub_segv_handler -
 				  (unsigned long) &__syscall_stub_start;
 
-		set_sigstack((void *) UML_CONFIG_STUB_DATA, UM_KERN_PAGE_SIZE);
+		set_sigstack((void *) STUB_DATA, UM_KERN_PAGE_SIZE);
 		sigemptyset(&sa.sa_mask);
 		sigaddset(&sa.sa_mask, SIGIO);
 		sigaddset(&sa.sa_mask, SIGWINCH);
@@ -382,10 +383,10 @@ static int __init init_thread_regs(void)
 {
 	get_safe_registers(thread_regs);
 	/* Set parent's instruction pointer to start of clone-stub */
-	thread_regs[REGS_IP_INDEX] = UML_CONFIG_STUB_CODE +
+	thread_regs[REGS_IP_INDEX] = STUB_CODE +
 				(unsigned long) stub_clone_handler -
 				(unsigned long) &__syscall_stub_start;
-	thread_regs[REGS_SP_INDEX] = UML_CONFIG_STUB_DATA + UM_KERN_PAGE_SIZE -
+	thread_regs[REGS_SP_INDEX] = STUB_DATA + UM_KERN_PAGE_SIZE -
 		sizeof(void *);
 #ifdef __SIGNAL_FRAMESIZE
 	thread_regs[REGS_SP_INDEX] -= __SIGNAL_FRAMESIZE;
@@ -443,7 +444,7 @@ int copy_context_skas0(unsigned long new
 	 * child's stack and check it.
 	 */
 	wait_stub_done(pid);
-	if (child_data->err != UML_CONFIG_STUB_DATA)
+	if (child_data->err != STUB_DATA)
 		panic("copy_context_skas0 - stub-child reports error %ld\n",
 		      child_data->err);
 
diff -puN arch/um/sys-i386/stub.S~uml-fix-stub-address-calculations arch/um/sys-i386/stub.S
--- a/arch/um/sys-i386/stub.S~uml-fix-stub-address-calculations
+++ a/arch/um/sys-i386/stub.S
@@ -1,4 +1,5 @@
 #include "uml-config.h"
+#include "as-layout.h"
 
 	.globl syscall_stub
 .section .__syscall_stub, "x"
@@ -6,7 +7,7 @@
 	.globl batch_syscall_stub
 batch_syscall_stub:
 	/* load pointer to first operation */
-	mov	$(UML_CONFIG_STUB_DATA+8), %esp
+	mov	$(ASM_STUB_DATA+8), %esp
 
 again:
 	/* load length of additional data */
@@ -14,12 +15,12 @@ again:
 
 	/* if(length == 0) : end of list */
 	/* write possible 0 to header */
-	mov	%eax, UML_CONFIG_STUB_DATA+4
+	mov	%eax, ASM_STUB_DATA+4
 	cmpl	$0, %eax
 	jz	done
 
 	/* save current pointer */
-	mov	%esp, UML_CONFIG_STUB_DATA+4
+	mov	%esp, ASM_STUB_DATA+4
 
 	/* skip additional data */
 	add	%eax, %esp
@@ -45,7 +46,7 @@ again:
 
 done:
 	/* save return value */
-	mov	%eax, UML_CONFIG_STUB_DATA
+	mov	%eax, ASM_STUB_DATA
 
 	/* stop */
 	int3
diff -puN arch/um/sys-i386/stub_segv.c~uml-fix-stub-address-calculations arch/um/sys-i386/stub_segv.c
--- a/arch/um/sys-i386/stub_segv.c~uml-fix-stub-address-calculations
+++ a/arch/um/sys-i386/stub_segv.c
@@ -6,6 +6,7 @@
 #include <signal.h>
 #include <sys/select.h> /* The only way I can see to get sigset_t */
 #include <asm/unistd.h>
+#include "as-layout.h"
 #include "uml-config.h"
 #include "sysdep/stub.h"
 #include "sysdep/sigcontext.h"
@@ -17,8 +18,7 @@ stub_segv_handler(int sig)
 	struct sigcontext *sc = (struct sigcontext *) (&sig + 1);
 	int pid;
 
-	GET_FAULTINFO_FROM_SC(*((struct faultinfo *) UML_CONFIG_STUB_DATA),
-			      sc);
+	GET_FAULTINFO_FROM_SC(*((struct faultinfo *) STUB_DATA), sc);
 
 	pid = stub_syscall0(__NR_getpid);
 	stub_syscall2(__NR_kill, pid, SIGUSR1);
diff -puN arch/um/sys-x86_64/stub.S~uml-fix-stub-address-calculations arch/um/sys-x86_64/stub.S
--- a/arch/um/sys-x86_64/stub.S~uml-fix-stub-address-calculations
+++ a/arch/um/sys-x86_64/stub.S
@@ -1,4 +1,5 @@
 #include "uml-config.h"
+#include "as-layout.h"
 
 	.globl syscall_stub
 .section .__syscall_stub, "x"
@@ -7,18 +8,18 @@ syscall_stub:
 	/* We don't have 64-bit constants, so this constructs the address
 	 * we need.
 	 */
-	movq	$(UML_CONFIG_STUB_DATA >> 32), %rbx
+	movq	$(ASM_STUB_DATA >> 32), %rbx
 	salq	$32, %rbx
-	movq	$(UML_CONFIG_STUB_DATA & 0xffffffff), %rcx
+	movq	$(ASM_STUB_DATA & 0xffffffff), %rcx
 	or	%rcx, %rbx
 	movq	%rax, (%rbx)
 	int3
 
 	.globl batch_syscall_stub
 batch_syscall_stub:
-	mov	$(UML_CONFIG_STUB_DATA >> 32), %rbx
+	mov	$(ASM_STUB_DATA >> 32), %rbx
 	sal	$32, %rbx
-	mov	$(UML_CONFIG_STUB_DATA & 0xffffffff), %rax
+	mov	$(ASM_STUB_DATA & 0xffffffff), %rax
 	or	%rax, %rbx
 	/* load pointer to first operation */
 	mov	%rbx, %rsp
diff -puN arch/um/sys-x86_64/stub_segv.c~uml-fix-stub-address-calculations arch/um/sys-x86_64/stub_segv.c
--- a/arch/um/sys-x86_64/stub_segv.c~uml-fix-stub-address-calculations
+++ a/arch/um/sys-x86_64/stub_segv.c
@@ -6,6 +6,7 @@
 #include <stddef.h>
 #include <signal.h>
 #include <asm/unistd.h>
+#include "as-layout.h"
 #include "uml-config.h"
 #include "sysdep/sigcontext.h"
 #include "sysdep/faultinfo.h"
@@ -33,7 +34,7 @@ stub_segv_handler(int sig)
         int pid;
 
 	__asm__ __volatile__("movq %%rdx, %0" : "=g" (uc) :);
-	GET_FAULTINFO_FROM_SC(*((struct faultinfo *) UML_CONFIG_STUB_DATA),
+	GET_FAULTINFO_FROM_SC(*((struct faultinfo *) STUB_DATA),
 			      &uc->uc_mcontext);
 
 	pid = stub_syscall0(__NR_getpid);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
