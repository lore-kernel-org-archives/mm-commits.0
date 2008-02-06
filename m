From: akpm@linux-foundation.org
Subject: + uml-runtime-host-vmsplit-detection.patch added to -mm tree
Date: Wed, 06 Feb 2008 14:20:14 -0800
Message-ID: <200802062220.m16MKETb000623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760630AbYBFWUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 17:20:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, miklos@szeredi.hu


The patch titled
     uml: runtime host VMSPLIT detection
has been added to the -mm tree.  Its filename is
     uml-runtime-host-vmsplit-detection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: runtime host VMSPLIT detection
From: Jeff Dike <jdike@addtoit.com>

Calculate TASK_SIZE at run-time by figuring out the host's VMSPLIT - this is
needed on i386 if UML is to run on hosts with varying VMSPLITs without
recompilation.

TASK_SIZE is now defined in terms of a variable, task_size.  This gets rid of
an include of pgtable.h from processor.h, which can cause include loops.

On i386, task_size is calculated early in boot by probing the address space in
a binary search to figure out where the boundary between usable and non-usable
memory is.  This tries to make sure that a page that is considered to be in
userspace is, or can be made, read-write.  I'm concerned about a system-global
VDSO page in kernel memory being hit and considered to be a userspace page.

On x86_64, task_size is just the old value of CONFIG_TOP_ADDR.

A bunch of config variable are gone now.  CONFIG_TOP_ADDR is directly replaced
by TASK_SIZE.  NEST_LEVEL is gone since the relocation of the stubs makes it
irrelevant.  All the HOST_VMSPLIT stuff is gone.  All references to these in
arch/um/Makefile are also gone.

I noticed and fixed a missing extern in os.h when adding os_get_task_size.

Note: This has been revised to fix the 32-bit UML on 64-bit host bug that
Miklos ran into.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig                         |   11 --
 arch/um/Kconfig.i386                    |   37 ------
 arch/um/Kconfig.x86_64                  |    4 
 arch/um/Makefile                        |   11 --
 arch/um/defconfig                       |    3 
 arch/um/include/as-layout.h             |    2 
 arch/um/include/os.h                    |    5 
 arch/um/kernel/exec.c                   |    2 
 arch/um/kernel/um_arch.c                |   16 ++
 arch/um/os-Linux/sys-i386/Makefile      |    2 
 arch/um/os-Linux/sys-i386/task_size.c   |  120 ++++++++++++++++++++++
 arch/um/os-Linux/sys-x86_64/Makefile    |    2 
 arch/um/os-Linux/sys-x86_64/task_size.c |    5 
 include/asm-um/fixmap.h                 |    3 
 include/asm-um/processor-generic.h      |    5 
 15 files changed, 153 insertions(+), 75 deletions(-)

diff -puN arch/um/Kconfig~uml-runtime-host-vmsplit-detection arch/um/Kconfig
--- a/arch/um/Kconfig~uml-runtime-host-vmsplit-detection
+++ a/arch/um/Kconfig
@@ -203,17 +203,6 @@ config NR_CPUS
 	depends on SMP
 	default "32"
 
-config NEST_LEVEL
-	int "Nesting level"
-	default "0"
-	help
-          This is set to the number of layers of UMLs that this UML will be run
-          in.  Normally, this is zero, meaning that it will run directly on the
-          host.  Setting it to one will build a UML that can run inside a UML
-          that is running on the host.  Generally, if you intend this UML to run
-          inside another UML, set CONFIG_NEST_LEVEL to one more than the host
-          UML.
-
 config HIGHMEM
 	bool "Highmem support (EXPERIMENTAL)"
 	depends on !64BIT && EXPERIMENTAL
diff -puN arch/um/Kconfig.i386~uml-runtime-host-vmsplit-detection arch/um/Kconfig.i386
--- a/arch/um/Kconfig.i386~uml-runtime-host-vmsplit-detection
+++ a/arch/um/Kconfig.i386
@@ -23,43 +23,6 @@ config SEMAPHORE_SLEEPERS
 	bool
 	default y
 
-choice
-	prompt "Host memory split"
-	default HOST_VMSPLIT_3G
-	help
-        This is needed when the host kernel on which you run has a non-default
-	(like 2G/2G) memory split, instead of the customary 3G/1G. If you did
-	not recompile your own kernel but use the default distro's one, you can
-	safely accept the "Default split" option.
-
-	It can be enabled on recent (>=2.6.16-rc2) vanilla kernels via
-	CONFIG_VM_SPLIT_*, or on previous kernels with special patches (-ck
-	patchset by Con Kolivas, or other ones) - option names match closely the
-	host CONFIG_VM_SPLIT_* ones.
-
-	A lower setting (where 1G/3G is lowest and 3G/1G is higher) will
-	tolerate even more "normal" host kernels, but an higher setting will be
-	stricter.
-
-	So, if you do not know what to do here, say 'Default split'.
-
-config HOST_VMSPLIT_3G
-	bool "Default split (3G/1G user/kernel host split)"
-config HOST_VMSPLIT_3G_OPT
-	bool "3G/1G user/kernel host split (for full 1G low memory)"
-config HOST_VMSPLIT_2G
-	bool "2G/2G user/kernel host split"
-config HOST_VMSPLIT_1G
-	bool "1G/3G user/kernel host split"
-endchoice
-
-config TOP_ADDR
-	hex
-	default 0xB0000000 if HOST_VMSPLIT_3G_OPT
-	default 0x78000000 if HOST_VMSPLIT_2G
-	default 0x40000000 if HOST_VMSPLIT_1G
-	default 0xC0000000
-
 config 3_LEVEL_PGTABLES
 	bool "Three-level pagetables (EXPERIMENTAL)"
 	default n
diff -puN arch/um/Kconfig.x86_64~uml-runtime-host-vmsplit-detection arch/um/Kconfig.x86_64
--- a/arch/um/Kconfig.x86_64~uml-runtime-host-vmsplit-detection
+++ a/arch/um/Kconfig.x86_64
@@ -15,10 +15,6 @@ config SEMAPHORE_SLEEPERS
 	bool
 	default y
 
-config TOP_ADDR
- 	hex
-	default 0x7fc0000000
-
 config 3_LEVEL_PGTABLES
        bool
        default y
diff -puN arch/um/Makefile~uml-runtime-host-vmsplit-detection arch/um/Makefile
--- a/arch/um/Makefile~uml-runtime-host-vmsplit-detection
+++ a/arch/um/Makefile
@@ -79,13 +79,6 @@ KERNEL_DEFINES = $(strip -Derrno=kernel_
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
 KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
 
-# These are needed for clean and mrproper, since in that case .config is not
-# included; the values here are meaningless
-
-CONFIG_NEST_LEVEL ?= 0
-
-SIZE = ($(CONFIG_NEST_LEVEL) * 0x20000000)
-
 PHONY += linux
 
 all: linux
@@ -120,10 +113,6 @@ CFLAGS_NO_HARDENING := $(call cc-option,
 CONFIG_KERNEL_STACK_ORDER ?= 2
 STACK_SIZE := $(shell echo $$[ 4096 * (1 << $(CONFIG_KERNEL_STACK_ORDER)) ] )
 
-ifndef START
-  START = $(shell echo $$[ $(TOP_ADDR) - $(SIZE) ] )
-endif
-
 CPPFLAGS_vmlinux.lds = -U$(SUBARCH) -DSTART=$(START) -DELF_ARCH=$(ELF_ARCH) \
 	-DELF_FORMAT="$(ELF_FORMAT)" -DKERNEL_STACK_SIZE=$(STACK_SIZE)
 
diff -puN arch/um/defconfig~uml-runtime-host-vmsplit-detection arch/um/defconfig
--- a/arch/um/defconfig~uml-runtime-host-vmsplit-detection
+++ a/arch/um/defconfig
@@ -56,8 +56,6 @@ CONFIG_X86_TSC=y
 CONFIG_UML_X86=y
 # CONFIG_64BIT is not set
 CONFIG_SEMAPHORE_SLEEPERS=y
-# CONFIG_HOST_2G_2G is not set
-CONFIG_TOP_ADDR=0xc0000000
 # CONFIG_3_LEVEL_PGTABLES is not set
 CONFIG_ARCH_HAS_SC_SIGNALS=y
 CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA=y
@@ -81,7 +79,6 @@ CONFIG_HOSTFS=y
 # CONFIG_HPPFS is not set
 CONFIG_MCONSOLE=y
 CONFIG_MAGIC_SYSRQ=y
-CONFIG_NEST_LEVEL=0
 # CONFIG_HIGHMEM is not set
 CONFIG_KERNEL_STACK_ORDER=0
 
diff -puN arch/um/include/as-layout.h~uml-runtime-host-vmsplit-detection arch/um/include/as-layout.h
--- a/arch/um/include/as-layout.h~uml-runtime-host-vmsplit-detection
+++ a/arch/um/include/as-layout.h
@@ -57,6 +57,8 @@ extern unsigned long _stext, _etext, _sd
 extern unsigned long _unprotected_end;
 extern unsigned long brk_start;
 
+extern unsigned long host_task_size;
+
 extern int linux_main(int argc, char **argv);
 
 extern void (*sig_info[])(int, struct uml_pt_regs *);
diff -puN arch/um/include/os.h~uml-runtime-host-vmsplit-detection arch/um/include/os.h
--- a/arch/um/include/os.h~uml-runtime-host-vmsplit-detection
+++ a/arch/um/include/os.h
@@ -295,6 +295,9 @@ extern void maybe_sigio_broken(int fd, i
 extern int os_arch_prctl(int pid, int code, unsigned long *addr);
 
 /* tty.c */
-int get_pty(void);
+extern int get_pty(void);
+
+/* sys-$ARCH/task_size.c */
+extern unsigned long os_get_task_size(void);
 
 #endif
diff -puN arch/um/kernel/exec.c~uml-runtime-host-vmsplit-detection arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-runtime-host-vmsplit-detection
+++ a/arch/um/kernel/exec.c
@@ -25,7 +25,7 @@ void flush_thread(void)
 
 	ret = unmap(&current->mm->context.id, 0, STUB_START, 0, &data);
 	ret = ret || unmap(&current->mm->context.id, STUB_END,
-			   TASK_SIZE - STUB_END, 1, &data);
+			   host_task_size - STUB_END, 1, &data);
 	if (ret) {
 		printk(KERN_ERR "flush_thread - clearing address space failed, "
 		       "err = %d\n", ret);
diff -puN arch/um/kernel/um_arch.c~uml-runtime-host-vmsplit-detection arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-runtime-host-vmsplit-detection
+++ a/arch/um/kernel/um_arch.c
@@ -241,6 +241,11 @@ static struct notifier_block panic_exit_
 };
 
 /* Set during early boot */
+unsigned long task_size;
+EXPORT_SYMBOL(task_size);
+
+unsigned long host_task_size;
+
 unsigned long brk_start;
 unsigned long end_iomem;
 EXPORT_SYMBOL(end_iomem);
@@ -267,6 +272,13 @@ int __init linux_main(int argc, char **a
 	if (have_root == 0)
 		add_arg(DEFAULT_COMMAND_LINE);
 
+	host_task_size = os_get_task_size();
+	/*
+	 * TASK_SIZE needs to be PGDIR_SIZE aligned or else exit_mmap craps
+	 * out
+	 */
+	task_size = host_task_size & PGDIR_MASK;
+
 	/* OS sanity checks that need to happen before the kernel runs */
 	os_early_checks();
 
@@ -303,7 +315,7 @@ int __init linux_main(int argc, char **a
 
 	highmem = 0;
 	iomem_size = (iomem_size + PAGE_SIZE - 1) & PAGE_MASK;
-	max_physmem = CONFIG_TOP_ADDR - uml_physmem - iomem_size - MIN_VMALLOC;
+	max_physmem = TASK_SIZE - uml_physmem - iomem_size - MIN_VMALLOC;
 
 	/*
 	 * Zones have to begin on a 1 << MAX_ORDER page boundary,
@@ -335,7 +347,7 @@ int __init linux_main(int argc, char **a
 	}
 
 	virtmem_size = physmem_size;
-	avail = CONFIG_TOP_ADDR - start_vm;
+	avail = TASK_SIZE - start_vm;
 	if (physmem_size > avail)
 		virtmem_size = avail;
 	end_vm = start_vm + virtmem_size;
diff -puN arch/um/os-Linux/sys-i386/Makefile~uml-runtime-host-vmsplit-detection arch/um/os-Linux/sys-i386/Makefile
--- a/arch/um/os-Linux/sys-i386/Makefile~uml-runtime-host-vmsplit-detection
+++ a/arch/um/os-Linux/sys-i386/Makefile
@@ -3,7 +3,7 @@
 # Licensed under the GPL
 #
 
-obj-y = registers.o signal.o tls.o
+obj-y = registers.o signal.o task_size.o tls.o
 
 USER_OBJS := $(obj-y)
 
diff -puN /dev/null arch/um/os-Linux/sys-i386/task_size.c
--- /dev/null
+++ a/arch/um/os-Linux/sys-i386/task_size.c
@@ -0,0 +1,120 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <sys/mman.h>
+#include "longjmp.h"
+#include "kern_constants.h"
+
+static jmp_buf buf;
+
+static void segfault(int sig)
+{
+	longjmp(buf, 1);
+}
+
+static int page_ok(unsigned long page)
+{
+	unsigned long *address = (unsigned long *) (page << UM_KERN_PAGE_SHIFT);
+	unsigned long n = ~0UL;
+	void *mapped = NULL;
+	int ok = 0;
+
+	/*
+	 * First see if the page is readable.  If it is, it may still
+	 * be a VDSO, so we go on to see if it's writable.  If not
+	 * then try mapping memory there.  If that fails, then we're
+	 * still in the kernel area.  As a sanity check, we'll fail if
+	 * the mmap succeeds, but gives us an address different from
+	 * what we wanted.
+	 */
+	if (setjmp(buf) == 0)
+		n = *address;
+	else {
+		mapped = mmap(address, UM_KERN_PAGE_SIZE,
+			      PROT_READ | PROT_WRITE,
+			      MAP_FIXED | MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		if (mapped == MAP_FAILED)
+			return 0;
+		if (mapped != address)
+			goto out;
+	}
+
+	/*
+	 * Now, is it writeable?  If so, then we're in user address
+	 * space.  If not, then try mprotecting it and try the write
+	 * again.
+	 */
+	if (setjmp(buf) == 0) {
+		*address = n;
+		ok = 1;
+		goto out;
+	} else if (mprotect(address, UM_KERN_PAGE_SIZE,
+			    PROT_READ | PROT_WRITE) != 0)
+		goto out;
+
+	if (setjmp(buf) == 0) {
+		*address = n;
+		ok = 1;
+	}
+
+ out:
+	if (mapped != NULL)
+		munmap(mapped, UM_KERN_PAGE_SIZE);
+	return ok;
+}
+
+unsigned long os_get_task_size(void)
+{
+	struct sigaction sa, old;
+	unsigned long bottom = 0;
+	/*
+	 * A 32-bit UML on a 64-bit host gets confused about the VDSO at
+	 * 0xffffe000.  It is mapped, is readable, can be reprotected writeable
+	 * and written.  However, exec discovers later that it can't be
+	 * unmapped.  So, just set the highest address to be checked to just
+	 * below it.  This might waste some address space on 4G/4G 32-bit
+	 * hosts, but shouldn't hurt otherwise.
+	 */
+	unsigned long top = 0xffffd000 >> UM_KERN_PAGE_SHIFT;
+	unsigned long test;
+
+	printf("Locating the top of the address space ... ");
+	fflush(stdout);
+
+	/*
+	 * We're going to be longjmping out of the signal handler, so
+	 * SA_DEFER needs to be set.
+	 */
+	sa.sa_handler = segfault;
+	sigemptyset(&sa.sa_mask);
+	sa.sa_flags = SA_NODEFER;
+	sigaction(SIGSEGV, &sa, &old);
+
+	if (!page_ok(bottom)) {
+		fprintf(stderr, "Address 0x%x no good?\n",
+			bottom << UM_KERN_PAGE_SHIFT);
+		exit(1);
+	}
+
+	/* This could happen with a 4G/4G split */
+	if (page_ok(top))
+		goto out;
+
+	do {
+		test = bottom + (top - bottom) / 2;
+		if (page_ok(test))
+			bottom = test;
+		else
+			top = test;
+	} while (top - bottom > 1);
+
+out:
+	/* Restore the old SIGSEGV handling */
+	sigaction(SIGSEGV, &old, NULL);
+
+	top <<= UM_KERN_PAGE_SHIFT;
+	printf("0x%x\n", top);
+	fflush(stdout);
+
+	return top;
+}
diff -puN arch/um/os-Linux/sys-x86_64/Makefile~uml-runtime-host-vmsplit-detection arch/um/os-Linux/sys-x86_64/Makefile
--- a/arch/um/os-Linux/sys-x86_64/Makefile~uml-runtime-host-vmsplit-detection
+++ a/arch/um/os-Linux/sys-x86_64/Makefile
@@ -3,7 +3,7 @@
 # Licensed under the GPL
 #
 
-obj-y = registers.o prctl.o signal.o
+obj-y = registers.o prctl.o signal.o task_size.o
 
 USER_OBJS := $(obj-y)
 
diff -puN /dev/null arch/um/os-Linux/sys-x86_64/task_size.c
--- /dev/null
+++ a/arch/um/os-Linux/sys-x86_64/task_size.c
@@ -0,0 +1,5 @@
+unsigned long os_get_task_size(unsigned long shift)
+{
+	/* The old value of CONFIG_TOP_ADDR */
+	return 0x7fc0000000;
+}
diff -puN include/asm-um/fixmap.h~uml-runtime-host-vmsplit-detection include/asm-um/fixmap.h
--- a/include/asm-um/fixmap.h~uml-runtime-host-vmsplit-detection
+++ a/include/asm-um/fixmap.h
@@ -1,6 +1,7 @@
 #ifndef __UM_FIXMAP_H
 #define __UM_FIXMAP_H
 
+#include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/kmap_types.h>
 #include <asm/archparam.h>
@@ -57,7 +58,7 @@ extern void __set_fixmap (enum fixed_add
  * at the top of mem..
  */
 
-#define FIXADDR_TOP	(CONFIG_TOP_ADDR - 2 * PAGE_SIZE)
+#define FIXADDR_TOP	(TASK_SIZE - 2 * PAGE_SIZE)
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
 
diff -puN include/asm-um/processor-generic.h~uml-runtime-host-vmsplit-detection include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~uml-runtime-host-vmsplit-detection
+++ a/include/asm-um/processor-generic.h
@@ -11,7 +11,6 @@ struct pt_regs;
 struct task_struct;
 
 #include "asm/ptrace.h"
-#include "asm/pgtable.h"
 #include "registers.h"
 #include "sysdep/archsetjmp.h"
 
@@ -92,7 +91,9 @@ static inline void mm_copy_segments(stru
 /*
  * User space process size: 3GB (default).
  */
-#define TASK_SIZE (CONFIG_TOP_ADDR & PGDIR_MASK)
+extern unsigned long task_size;
+
+#define TASK_SIZE (task_size)
 
 #undef STACK_TOP
 #undef STACK_TOP_MAX
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
git-kvm.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
uml-runtime-host-vmsplit-detection.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-x86_64-should-copy-%fs-during-fork.patch
uml-fix-mm_context-memory-leak.patch
