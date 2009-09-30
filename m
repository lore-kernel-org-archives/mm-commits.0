From: akpm@linux-foundation.org
Subject: + elf-kill-use_elf_core_dump.patch added to -mm tree
Date: Wed, 30 Sep 2009 15:42:39 -0700
Message-ID: <200909302242.n8UMgdIH031501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbZI3Wnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 18:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, hugh.dickins@tiscali.co.uk, linux-arch@vger.kernel.org, michal.simek@petalogix.com


The patch titled
     elf: kill USE_ELF_CORE_DUMP
has been added to the -mm tree.  Its filename is
     elf-kill-use_elf_core_dump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf: kill USE_ELF_CORE_DUMP
From: Christoph Hellwig <hch@lst.de>

Currently all architectures but microblaze unconditionally define
USE_ELF_CORE_DUMP.  The microblaze omission seems like an error to me, so
let's kill this ifdef and make sure we are the same everywhere.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <linux-arch@vger.kernel.org>
Cc: Michal Simek <michal.simek@petalogix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/elf.h      |    1 -
 arch/arm/include/asm/elf.h        |    1 -
 arch/avr32/include/asm/elf.h      |    1 -
 arch/blackfin/include/asm/elf.h   |    1 -
 arch/cris/include/asm/elf.h       |    2 --
 arch/frv/include/asm/elf.h        |    1 -
 arch/h8300/include/asm/elf.h      |    1 -
 arch/ia64/ia32/elfcore32.h        |    2 --
 arch/ia64/include/asm/elf.h       |    1 -
 arch/m32r/include/asm/elf.h       |    1 -
 arch/m68k/include/asm/elf.h       |    1 -
 arch/microblaze/include/asm/elf.h |    1 -
 arch/mips/include/asm/elf.h       |    1 -
 arch/mn10300/include/asm/elf.h    |    1 -
 arch/parisc/include/asm/elf.h     |    1 -
 arch/powerpc/include/asm/elf.h    |    1 -
 arch/s390/include/asm/elf.h       |    1 -
 arch/score/include/asm/elf.h      |    1 -
 arch/sh/include/asm/elf.h         |    1 -
 arch/sparc/include/asm/elf_32.h   |    2 --
 arch/sparc/include/asm/elf_64.h   |    1 -
 arch/um/sys-i386/asm/elf.h        |    1 -
 arch/um/sys-ppc/asm/elf.h         |    2 --
 arch/um/sys-x86_64/asm/elf.h      |    1 -
 arch/x86/include/asm/elf.h        |    1 -
 arch/xtensa/include/asm/elf.h     |    1 -
 fs/binfmt_elf.c                   |   11 +++--------
 fs/binfmt_elf_fdpic.c             |    8 ++++----
 fs/proc/base.c                    |    4 ++--
 29 files changed, 9 insertions(+), 44 deletions(-)

diff -puN arch/alpha/include/asm/elf.h~elf-kill-use_elf_core_dump arch/alpha/include/asm/elf.h
--- a/arch/alpha/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/alpha/include/asm/elf.h
@@ -81,7 +81,6 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_N
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_ALPHA
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	8192
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
diff -puN arch/arm/include/asm/elf.h~elf-kill-use_elf_core_dump arch/arm/include/asm/elf.h
--- a/arch/arm/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/arm/include/asm/elf.h
@@ -98,7 +98,6 @@ extern int elf_check_arch(const struct e
 extern int arm_elf_read_implies_exec(const struct elf32_hdr *, int);
 #define elf_read_implies_exec(ex,stk) arm_elf_read_implies_exec(&(ex), stk)
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
diff -puN arch/avr32/include/asm/elf.h~elf-kill-use_elf_core_dump arch/avr32/include/asm/elf.h
--- a/arch/avr32/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/avr32/include/asm/elf.h
@@ -77,7 +77,6 @@ typedef struct user_fpu_struct elf_fpreg
 #endif
 #define ELF_ARCH	EM_AVR32
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
diff -puN arch/blackfin/include/asm/elf.h~elf-kill-use_elf_core_dump arch/blackfin/include/asm/elf.h
--- a/arch/blackfin/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/blackfin/include/asm/elf.h
@@ -51,7 +51,6 @@ do {											\
 	_regs->p2	= _dynamic_addr;				\
 } while(0)
 
-#define USE_ELF_CORE_DUMP
 #define ELF_FDPIC_CORE_EFLAGS	EF_BFIN_FDPIC
 #define ELF_EXEC_PAGESIZE	4096
 
diff -puN arch/cris/include/asm/elf.h~elf-kill-use_elf_core_dump arch/cris/include/asm/elf.h
--- a/arch/cris/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/cris/include/asm/elf.h
@@ -64,8 +64,6 @@ typedef unsigned long elf_fpregset_t;
 #define EF_CRIS_VARIANT_COMMON_V10_V32	0x00000004
 /* End of excerpt from {binutils}/include/elf/cris.h.  */
 
-#define USE_ELF_CORE_DUMP
-
 #define ELF_EXEC_PAGESIZE	8192
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
diff -puN arch/frv/include/asm/elf.h~elf-kill-use_elf_core_dump arch/frv/include/asm/elf.h
--- a/arch/frv/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/frv/include/asm/elf.h
@@ -115,7 +115,6 @@ do {											\
 	__kernel_frame0_ptr->gr29	= 0;						\
 } while(0)
 
-#define USE_ELF_CORE_DUMP
 #define CORE_DUMP_USE_REGSET
 #define ELF_FDPIC_CORE_EFLAGS	EF_FRV_FDPIC
 #define ELF_EXEC_PAGESIZE	16384
diff -puN arch/h8300/include/asm/elf.h~elf-kill-use_elf_core_dump arch/h8300/include/asm/elf.h
--- a/arch/h8300/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/h8300/include/asm/elf.h
@@ -34,7 +34,6 @@ typedef unsigned long elf_fpregset_t;
 
 #define ELF_PLAT_INIT(_r)	_r->er1 = 0
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
diff -puN arch/ia64/ia32/elfcore32.h~elf-kill-use_elf_core_dump arch/ia64/ia32/elfcore32.h
--- a/arch/ia64/ia32/elfcore32.h~elf-kill-use_elf_core_dump
+++ a/arch/ia64/ia32/elfcore32.h
@@ -11,8 +11,6 @@
 #include <asm/intrinsics.h>
 #include <asm/uaccess.h>
 
-#define USE_ELF_CORE_DUMP 1
-
 /* Override elfcore.h */
 #define _LINUX_ELFCORE_H 1
 typedef unsigned int elf_greg_t;
diff -puN arch/ia64/include/asm/elf.h~elf-kill-use_elf_core_dump arch/ia64/include/asm/elf.h
--- a/arch/ia64/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/ia64/include/asm/elf.h
@@ -25,7 +25,6 @@
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_IA_64
 
-#define USE_ELF_CORE_DUMP
 #define CORE_DUMP_USE_REGSET
 
 /* Least-significant four bits of ELF header's e_flags are OS-specific.  The bits are
diff -puN arch/m32r/include/asm/elf.h~elf-kill-use_elf_core_dump arch/m32r/include/asm/elf.h
--- a/arch/m32r/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/m32r/include/asm/elf.h
@@ -102,7 +102,6 @@ typedef elf_fpreg_t elf_fpregset_t;
  */
 #define ELF_PLAT_INIT(_r, load_addr)	(_r)->r0 = 0
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /*
diff -puN arch/m68k/include/asm/elf.h~elf-kill-use_elf_core_dump arch/m68k/include/asm/elf.h
--- a/arch/m68k/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/m68k/include/asm/elf.h
@@ -59,7 +59,6 @@ typedef struct user_m68kfp_struct elf_fp
    is actually used on ASV.  */
 #define ELF_PLAT_INIT(_r, load_addr)	_r->a1 = 0
 
-#define USE_ELF_CORE_DUMP
 #ifndef CONFIG_SUN3
 #define ELF_EXEC_PAGESIZE	4096
 #else
diff -puN arch/microblaze/include/asm/elf.h~elf-kill-use_elf_core_dump arch/microblaze/include/asm/elf.h
--- a/arch/microblaze/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/microblaze/include/asm/elf.h
@@ -77,7 +77,6 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_N
 #define ELF_DATA	ELFDATA2MSB
 #endif
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 
diff -puN arch/mips/include/asm/elf.h~elf-kill-use_elf_core_dump arch/mips/include/asm/elf.h
--- a/arch/mips/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/mips/include/asm/elf.h
@@ -326,7 +326,6 @@ extern int dump_task_fpu(struct task_str
 #define ELF_CORE_COPY_FPREGS(tsk, elf_fpregs)			\
 	dump_task_fpu(tsk, elf_fpregs)
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /* This yields a mask that user programs can use to figure out what
diff -puN arch/mn10300/include/asm/elf.h~elf-kill-use_elf_core_dump arch/mn10300/include/asm/elf.h
--- a/arch/mn10300/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/mn10300/include/asm/elf.h
@@ -77,7 +77,6 @@ do {									\
 	_ur->a1   = 0;	_ur->a0   = 0;	_ur->d1   = 0;	_ur->d0   = 0;	\
 } while (0)
 
-#define USE_ELF_CORE_DUMP
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
diff -puN arch/parisc/include/asm/elf.h~elf-kill-use_elf_core_dump arch/parisc/include/asm/elf.h
--- a/arch/parisc/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/parisc/include/asm/elf.h
@@ -328,7 +328,6 @@ struct pt_regs;	/* forward declaration..
    such function.  */
 #define ELF_PLAT_INIT(_r, load_addr)       _r->gr[23] = 0
 
-#define USE_ELF_CORE_DUMP
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
diff -puN arch/powerpc/include/asm/elf.h~elf-kill-use_elf_core_dump arch/powerpc/include/asm/elf.h
--- a/arch/powerpc/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/powerpc/include/asm/elf.h
@@ -170,7 +170,6 @@ typedef elf_fpreg_t elf_vsrreghalf_t32[E
 #define elf_check_arch(x) ((x)->e_machine == ELF_ARCH)
 #define compat_elf_check_arch(x)	((x)->e_machine == EM_PPC)
 
-#define USE_ELF_CORE_DUMP
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
diff -puN arch/s390/include/asm/elf.h~elf-kill-use_elf_core_dump arch/s390/include/asm/elf.h
--- a/arch/s390/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/s390/include/asm/elf.h
@@ -143,7 +143,6 @@ extern unsigned int vdso_enabled;
 	} while (0)
 
 #define CORE_DUMP_USE_REGSET
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
diff -puN arch/score/include/asm/elf.h~elf-kill-use_elf_core_dump arch/score/include/asm/elf.h
--- a/arch/score/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/score/include/asm/elf.h
@@ -61,7 +61,6 @@ struct task_struct;
 struct pt_regs;
 
 #define CORE_DUMP_USE_REGSET
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /* This yields a mask that user programs can use to figure out what
diff -puN arch/sh/include/asm/elf.h~elf-kill-use_elf_core_dump arch/sh/include/asm/elf.h
--- a/arch/sh/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/sh/include/asm/elf.h
@@ -114,7 +114,6 @@ typedef struct user_fpu_struct elf_fpreg
  */
 #define CORE_DUMP_USE_REGSET
 
-#define USE_ELF_CORE_DUMP
 #define ELF_FDPIC_CORE_EFLAGS	EF_SH_FDPIC
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
diff -puN arch/sparc/include/asm/elf_32.h~elf-kill-use_elf_core_dump arch/sparc/include/asm/elf_32.h
--- a/arch/sparc/include/asm/elf_32.h~elf-kill-use_elf_core_dump
+++ a/arch/sparc/include/asm/elf_32.h
@@ -104,8 +104,6 @@ typedef struct {
 #define ELF_CLASS	ELFCLASS32
 #define ELF_DATA	ELFDATA2MSB
 
-#define USE_ELF_CORE_DUMP
-
 #define ELF_EXEC_PAGESIZE	4096
 
 
diff -puN arch/sparc/include/asm/elf_64.h~elf-kill-use_elf_core_dump arch/sparc/include/asm/elf_64.h
--- a/arch/sparc/include/asm/elf_64.h~elf-kill-use_elf_core_dump
+++ a/arch/sparc/include/asm/elf_64.h
@@ -152,7 +152,6 @@ typedef struct {
 					 (x)->e_machine == EM_SPARC32PLUS)
 #define compat_start_thread		start_thread32
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
diff -puN arch/um/sys-i386/asm/elf.h~elf-kill-use_elf_core_dump arch/um/sys-i386/asm/elf.h
--- a/arch/um/sys-i386/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/um/sys-i386/asm/elf.h
@@ -48,7 +48,6 @@ typedef struct user_i387_struct elf_fpre
 	PT_REGS_EAX(regs) = 0; \
 } while (0)
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE 4096
 
 #define ELF_ET_DYN_BASE (2 * TASK_SIZE / 3)
diff -puN arch/um/sys-ppc/asm/elf.h~elf-kill-use_elf_core_dump arch/um/sys-ppc/asm/elf.h
--- a/arch/um/sys-ppc/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/um/sys-ppc/asm/elf.h
@@ -17,8 +17,6 @@ extern long elf_aux_hwcap;
 #define ELF_CLASS ELFCLASS32
 #endif
 
-#define USE_ELF_CORE_DUMP
-
 #define R_386_NONE	0
 #define R_386_32	1
 #define R_386_PC32	2
diff -puN arch/um/sys-x86_64/asm/elf.h~elf-kill-use_elf_core_dump arch/um/sys-x86_64/asm/elf.h
--- a/arch/um/sys-x86_64/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/um/sys-x86_64/asm/elf.h
@@ -104,7 +104,6 @@ extern int elf_core_copy_fpregs(struct t
         clear_thread_flag(TIF_IA32);
 #endif
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE 4096
 
 #define ELF_ET_DYN_BASE (2 * TASK_SIZE / 3)
diff -puN arch/x86/include/asm/elf.h~elf-kill-use_elf_core_dump arch/x86/include/asm/elf.h
--- a/arch/x86/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/x86/include/asm/elf.h
@@ -255,7 +255,6 @@ extern int force_personality32;
 #endif /* !CONFIG_X86_32 */
 
 #define CORE_DUMP_USE_REGSET
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
diff -puN arch/xtensa/include/asm/elf.h~elf-kill-use_elf_core_dump arch/xtensa/include/asm/elf.h
--- a/arch/xtensa/include/asm/elf.h~elf-kill-use_elf_core_dump
+++ a/arch/xtensa/include/asm/elf.h
@@ -123,7 +123,6 @@ extern void xtensa_elf_core_copy_regs (x
 #define ELF_CLASS	ELFCLASS32
 #define ELF_ARCH	EM_XTENSA
 
-#define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /*
diff -puN fs/binfmt_elf.c~elf-kill-use_elf_core_dump fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-kill-use_elf_core_dump
+++ a/fs/binfmt_elf.c
@@ -44,7 +44,7 @@ static unsigned long elf_map(struct file
  * If we don't support core dumping, then supply a NULL so we
  * don't even try.
  */
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
 #else
 #define elf_core_dump	NULL
@@ -1101,12 +1101,7 @@ out:
 	return error;
 }
 
-/*
- * Note that some platforms still use traditional core dumps and not
- * the ELF core dump.  Each platform can select it as appropriate.
- */
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-
+#ifdef CONFIG_ELF_CORE
 /*
  * ELF core dumper
  *
@@ -2063,7 +2058,7 @@ out:
 	return has_dumped;
 }
 
-#endif		/* USE_ELF_CORE_DUMP */
+#endif		/* CONFIG_ELF_CORE */
 
 static int __init init_elf_binfmt(void)
 {
diff -puN fs/binfmt_elf_fdpic.c~elf-kill-use_elf_core_dump fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~elf-kill-use_elf_core_dump
+++ a/fs/binfmt_elf_fdpic.c
@@ -75,14 +75,14 @@ static int elf_fdpic_map_file_constdisp_
 static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *,
 					     struct file *, struct mm_struct *);
 
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 static int elf_fdpic_core_dump(long, struct pt_regs *, struct file *, unsigned long limit);
 #endif
 
 static struct linux_binfmt elf_fdpic_format = {
 	.module		= THIS_MODULE,
 	.load_binary	= load_elf_fdpic_binary,
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 	.core_dump	= elf_fdpic_core_dump,
 #endif
 	.min_coredump	= ELF_EXEC_PAGESIZE,
@@ -1200,7 +1200,7 @@ static int elf_fdpic_map_file_by_direct_
  *
  * Modelled on fs/binfmt_elf.c core dumper
  */
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 
 /*
  * These are the only things you should do on a core-file: use only these
@@ -1825,4 +1825,4 @@ cleanup:
 #undef NUM_NOTES
 }
 
-#endif		/* USE_ELF_CORE_DUMP */
+#endif		/* CONFIG_ELF_CORE */
diff -puN fs/proc/base.c~elf-kill-use_elf_core_dump fs/proc/base.c
--- a/fs/proc/base.c~elf-kill-use_elf_core_dump
+++ a/fs/proc/base.c
@@ -2201,7 +2201,7 @@ static const struct inode_operations pro
 
 #endif
 
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 static ssize_t proc_coredump_filter_read(struct file *file, char __user *buf,
 					 size_t count, loff_t *ppos)
 {
@@ -2557,7 +2557,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
-#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+#ifdef CONFIG_ELF_CORE
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
_

Patches currently in -mm which might be from hch@lst.de are

revert-m68k-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
linux-next.patch
avr32-convert-to-asm-generic-hardirqh.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics.patch
xtensa-convert-to-asm-generic-hardirqh.patch
elf-kill-use_elf_core_dump.patch

