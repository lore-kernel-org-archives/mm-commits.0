From: akpm@osdl.org
Subject: + x86-fix-vdso-mapping-for-aout-executables.patch added to -mm tree
Date: Sat, 27 Jan 2007 14:02:42 -0800
Message-ID: <200701272202.l0RM2gnp017475@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbXA0WDC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 17:03:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: parag.warudkar@gmail.com, ak@suse.de, benh@kernel.crashing.org, joerg@hydrops.han.de, lethal@linux-sh.org, paulus@samba.org


The patch titled
     x86: fix vdso mapping for aout executables
has been added to the -mm tree.  Its filename is
     x86-fix-vdso-mapping-for-aout-executables.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: fix vdso mapping for aout executables
From: "Parag Warudkar" <parag.warudkar@gmail.com>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=7891

  "In kernel 2.6.18 the vdso page is no longer mapped for a.out binaries. 
   For instance a program using sleep will sigsegv on delivery of SIGALRM (to
   be precise: on return from signal handling).  I tested this using a static
   a.out binary.  This program does work in 2.6.17 .  

   cat /proc/pid/smaps does show that vdso is not mapped in 2.6.18 for an
   a.out binary.  I had a look at fs/binfmt_elf.c and found that the vdso
   pages is mapped using arch_setup_additional_pages from
   arch/i386/kernel/sysenter.c for elf."


- Give i386, x86_64, powerpc and sh a new
  CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES

- Create a new include/linux/interp.h which has:

	struct linux_binprm;
	#ifdef CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES
	extern int arch_setup_additional_pages(struct linux_binprm *bprm,
                                       int executable_stack);
	#else
	static inline int arch_setup_additional_pages(struct linux_binprm *bprm,
                                       int executable_stack)
	{
		return 0;
	}
	#endif

- include <linux/interp.h> from binfmt_elf.c and binfmt_aout.c and from
  all the files which implement arch_setup_additional_pages().

- Remove the #ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES from binfmt_elf.c

- Add the call to arch_setup_additional_pages() in binfmt_aout.h.

- EXPORT_SYMBOL(arch_setup_additional_pages) for all arches referred
above - binfmt_aout.c can be built as module on all architectures and
it needs to call arch_setup_additional_pages

- For x86_64 - remove
   #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
   #define arch_setup_additional_pages syscall32_setup_pages
  from ia32_binfmt.c and instead use arch_setup_additional_pages as an
exported wrapper over  syscall32_setup_pages

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Joerg Ahrens <joerg@hydrops.han.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/Kconfig                  |    5 +++++
 arch/i386/kernel/sysenter.c        |    2 ++
 arch/powerpc/Kconfig               |    5 +++++
 arch/powerpc/kernel/vdso.c         |    2 ++
 arch/sh/Kconfig                    |    5 +++++
 arch/sh/kernel/vsyscall/vsyscall.c |    2 ++
 arch/x86_64/Kconfig                |    5 +++++
 arch/x86_64/ia32/ia32_aout.c       |    9 +++++++++
 arch/x86_64/ia32/ia32_binfmt.c     |    5 +----
 arch/x86_64/ia32/syscall32.c       |    7 +++++++
 fs/binfmt_aout.c                   |    9 ++++++++-
 fs/binfmt_elf.c                    |    3 +--
 include/asm-i386/elf.h             |    7 -------
 include/asm-powerpc/elf.h          |    5 -----
 include/asm-sh/elf.h               |    6 ------
 include/linux/interp.h             |   17 +++++++++++++++++
 16 files changed, 69 insertions(+), 25 deletions(-)

diff -puN arch/i386/Kconfig~x86-fix-vdso-mapping-for-aout-executables arch/i386/Kconfig
--- a/arch/i386/Kconfig~x86-fix-vdso-mapping-for-aout-executables
+++ a/arch/i386/Kconfig
@@ -625,6 +625,11 @@ config ARCH_SELECT_MEMORY_MODEL
 config ARCH_POPULATES_NODE_MAP
 	def_bool y
 
+config ARCH_HAS_SETUP_ADDITIONAL_PAGES
+       bool
+       default y
+       depends on X86_32
+
 source "mm/Kconfig"
 
 config HIGHPTE
diff -puN arch/i386/kernel/sysenter.c~x86-fix-vdso-mapping-for-aout-executables arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~x86-fix-vdso-mapping-for-aout-executables
+++ a/arch/i386/kernel/sysenter.c
@@ -17,6 +17,7 @@
 #include <linux/elf.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/interp.h>
 
 #include <asm/cpufeature.h>
 #include <asm/msr.h>
@@ -168,6 +169,7 @@ up_fail:
 	up_write(&mm->mmap_sem);
 	return ret;
 }
+EXPORT_SYMBOL(arch_setup_additional_pages);
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
diff -puN arch/powerpc/Kconfig~x86-fix-vdso-mapping-for-aout-executables arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~x86-fix-vdso-mapping-for-aout-executables
+++ a/arch/powerpc/Kconfig
@@ -45,6 +45,11 @@ config ARCH_HAS_ILOG2_U32
 	bool
 	default y
 
+config ARCH_HAS_SETUP_ADDITIONAL_PAGES
+       bool
+       default y
+       depends on PPC32 || PPC64
+
 config ARCH_HAS_ILOG2_U64
 	bool
 	default y if 64BIT
diff -puN arch/powerpc/kernel/vdso.c~x86-fix-vdso-mapping-for-aout-executables arch/powerpc/kernel/vdso.c
--- a/arch/powerpc/kernel/vdso.c~x86-fix-vdso-mapping-for-aout-executables
+++ a/arch/powerpc/kernel/vdso.c
@@ -22,6 +22,7 @@
 #include <linux/elf.h>
 #include <linux/security.h>
 #include <linux/bootmem.h>
+#include <linux/interp.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -312,6 +313,7 @@ int arch_setup_additional_pages(struct l
 	up_write(&mm->mmap_sem);
 	return rc;
 }
+EXPORT_SYMBOL(arch_setup_additional_pages);
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
diff -puN arch/sh/Kconfig~x86-fix-vdso-mapping-for-aout-executables arch/sh/Kconfig
--- a/arch/sh/Kconfig~x86-fix-vdso-mapping-for-aout-executables
+++ a/arch/sh/Kconfig
@@ -67,6 +67,11 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config ARCH_HAS_SETUP_ADDITIONAL_PAGES
+       bool
+       default y
+       depends on SUPERH
+
 source "init/Kconfig"
 
 menu "System type"
diff -puN arch/sh/kernel/vsyscall/vsyscall.c~x86-fix-vdso-mapping-for-aout-executables arch/sh/kernel/vsyscall/vsyscall.c
--- a/arch/sh/kernel/vsyscall/vsyscall.c~x86-fix-vdso-mapping-for-aout-executables
+++ a/arch/sh/kernel/vsyscall/vsyscall.c
@@ -17,6 +17,7 @@
 #include <linux/gfp.h>
 #include <linux/module.h>
 #include <linux/elf.h>
+#include <linux/interp.h>
 
 /*
  * Should the kernel map a VDSO page into processes and pass its
@@ -125,6 +126,7 @@ up_fail:
 	up_write(&mm->mmap_sem);
 	return ret;
 }
+EXPORT_SYMBOL(arch_setup_additional_pages);
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
diff -puN arch/x86_64/ia32/ia32_aout.c~x86-fix-vdso-mapping-for-aout-executables arch/x86_64/ia32/ia32_aout.c
--- a/arch/x86_64/ia32/ia32_aout.c~x86-fix-vdso-mapping-for-aout-executables
+++ a/arch/x86_64/ia32/ia32_aout.c
@@ -25,6 +25,7 @@
 #include <linux/binfmts.h>
 #include <linux/personality.h>
 #include <linux/init.h>
+#include <linux/interp.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -411,6 +412,14 @@ beyond_if:
 		return retval;
 	}
 
+	retval = arch_setup_additional_pages(bprm, EXSTACK_DEFAULT);
+
+	if (retval < 0) {
+                /* Someone check-me: is this error path enough? */
+                send_sig(SIGKILL, current, 0);
+                return retval;
+        }
+
 	current->mm->start_stack =
 		(unsigned long)create_aout_tables((char __user *)bprm->p, bprm);
 	/* start thread */
diff -puN arch/x86_64/ia32/ia32_binfmt.c~x86-fix-vdso-mapping-for-aout-executables arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~x86-fix-vdso-mapping-for-aout-executables
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -14,6 +14,7 @@
 #include <linux/binfmts.h>
 #include <linux/mm.h>
 #include <linux/security.h>
+#include <linux/interp.h>
 
 #include <asm/segment.h> 
 #include <asm/ptrace.h>
@@ -258,10 +259,6 @@ MODULE_AUTHOR("Eric Youngdale, Andi Klee
 
 static void elf32_init(struct pt_regs *);
 
-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
-#define arch_setup_additional_pages syscall32_setup_pages
-extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
-
 #include "../../../fs/binfmt_elf.c" 
 
 static void elf32_init(struct pt_regs *regs)
diff -puN arch/x86_64/ia32/syscall32.c~x86-fix-vdso-mapping-for-aout-executables arch/x86_64/ia32/syscall32.c
--- a/arch/x86_64/ia32/syscall32.c~x86-fix-vdso-mapping-for-aout-executables
+++ a/arch/x86_64/ia32/syscall32.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/stringify.h>
 #include <linux/security.h>
+#include <linux/interp.h>
 #include <asm/proto.h>
 #include <asm/tlbflush.h>
 #include <asm/ia32_unistd.h>
@@ -90,6 +91,12 @@ const char *arch_vma_name(struct vm_area
 	return NULL;
 }
 
+int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
+{
+	return syscall32_setup_pages(struct linux_binprm *bprm, int exstack);
+}
+EXPORT_SYMBOL(arch_setup_additional_pages);
+
 static int __init init_syscall32(void)
 { 
 	syscall32_page = (void *)get_zeroed_page(GFP_KERNEL); 
diff -puN arch/x86_64/Kconfig~x86-fix-vdso-mapping-for-aout-executables arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86-fix-vdso-mapping-for-aout-executables
+++ a/arch/x86_64/Kconfig
@@ -398,6 +398,11 @@ config HAVE_ARCH_EARLY_PFN_TO_NID
 	def_bool y
 	depends on NUMA
 
+config ARCH_HAS_SETUP_ADDITIONAL_PAGES
+       bool
+       default y
+       depends on X86_64
+
 config OUT_OF_LINE_PFN_TO_PAGE
 	def_bool y
 	depends on DISCONTIGMEM
diff -puN fs/binfmt_aout.c~x86-fix-vdso-mapping-for-aout-executables fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~x86-fix-vdso-mapping-for-aout-executables
+++ a/fs/binfmt_aout.c
@@ -22,6 +22,7 @@
 #include <linux/user.h>
 #include <linux/slab.h>
 #include <linux/binfmts.h>
+#include <linux/interp.h>
 #include <linux/personality.h>
 #include <linux/init.h>
 
@@ -269,7 +270,7 @@ static int load_aout_binary(struct linux
 	unsigned long fd_offset;
 	unsigned long rlim;
 	int retval;
-
+	int executable_stack = EXSTACK_DEFAULT;
 	ex = *((struct exec *) bprm->buf);		/* exec-header */
 	if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != OMAGIC &&
 	     N_MAGIC(ex) != QMAGIC && N_MAGIC(ex) != NMAGIC) ||
@@ -433,6 +434,12 @@ static int load_aout_binary(struct linux
 beyond_if:
 	set_binfmt(&aout_format);
 
+	retval = arch_setup_additional_pages(bprm, executable_stack);
+        if (retval < 0) {
+                send_sig(SIGKILL, current, 0);
+                return retval;
+        }
+
 	retval = set_brk(current->mm->start_brk, current->mm->brk);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
diff -puN fs/binfmt_elf.c~x86-fix-vdso-mapping-for-aout-executables fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~x86-fix-vdso-mapping-for-aout-executables
+++ a/fs/binfmt_elf.c
@@ -38,6 +38,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/random.h>
+#include <linux/interp.h>
 #include <linux/elf.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
@@ -974,13 +975,11 @@ static int load_elf_binary(struct linux_
 
 	set_binfmt(&elf_format);
 
-#ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
 	retval = arch_setup_additional_pages(bprm, executable_stack);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
 	}
-#endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGES */
 
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
diff -puN include/asm-i386/elf.h~x86-fix-vdso-mapping-for-aout-executables include/asm-i386/elf.h
--- a/include/asm-i386/elf.h~x86-fix-vdso-mapping-for-aout-executables
+++ a/include/asm-i386/elf.h
@@ -153,13 +153,6 @@ extern void __kernel_vsyscall;
 
 #define VDSO_ENTRY		VDSO_SYM(&__kernel_vsyscall)
 
-#ifndef CONFIG_COMPAT_VDSO
-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
-struct linux_binprm;
-extern int arch_setup_additional_pages(struct linux_binprm *bprm,
-                                       int executable_stack);
-#endif
-
 extern unsigned int vdso_enabled;
 
 #define ARCH_DLINFO						\
diff -puN include/asm-powerpc/elf.h~x86-fix-vdso-mapping-for-aout-executables include/asm-powerpc/elf.h
--- a/include/asm-powerpc/elf.h~x86-fix-vdso-mapping-for-aout-executables
+++ a/include/asm-powerpc/elf.h
@@ -266,11 +266,6 @@ extern int dcache_bsize;
 extern int icache_bsize;
 extern int ucache_bsize;
 
-/* vDSO has arch_setup_additional_pages */
-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
-struct linux_binprm;
-extern int arch_setup_additional_pages(struct linux_binprm *bprm,
-				       int executable_stack);
 #define VDSO_AUX_ENT(a,b) NEW_AUX_ENT(a,b);
 
 /*
diff -puN include/asm-sh/elf.h~x86-fix-vdso-mapping-for-aout-executables include/asm-sh/elf.h
--- a/include/asm-sh/elf.h~x86-fix-vdso-mapping-for-aout-executables
+++ a/include/asm-sh/elf.h
@@ -121,12 +121,6 @@ extern int dump_task_fpu (struct task_st
 #endif
 
 #ifdef CONFIG_VSYSCALL
-/* vDSO has arch_setup_additional_pages */
-#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
-struct linux_binprm;
-extern int arch_setup_additional_pages(struct linux_binprm *bprm,
-				       int executable_stack);
-
 extern unsigned int vdso_enabled;
 extern void __kernel_vsyscall;
 
diff -puN /dev/null include/linux/interp.h
--- /dev/null
+++ a/include/linux/interp.h
@@ -0,0 +1,17 @@
+/* interp.h */
+#ifndef _LINUX_INTERP_H
+#define _LINUX_INTERP_H
+
+struct linux_binprm;
+#ifdef CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES
+extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+					int executable_stack);
+#else
+static inline int arch_setup_additional_pages(struct linux_binprm *bprm,
+				int executable_stack)
+{
+	return 0;
+}
+#endif
+
+#endif /* interp.h */
_

Patches currently in -mm which might be from parag.warudkar@gmail.com are

x86-fix-vdso-mapping-for-aout-executables.patch
