From: akpm@linux-foundation.org
Subject: - cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:25 -0800
Message-ID: <200802080808.m1888646014620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57017 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932642AbYBHIUi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.shutemov@gmail.com, dwmw2@infradead.org, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Cleanup asm/{elf,page,user}.h: #ifdef __KERNEL__ is no longer needed
has been removed from the -mm tree.  Its filename was
     cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Cleanup asm/{elf,page,user}.h: #ifdef __KERNEL__ is no longer needed
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>

asm/elf.h, asm/page.h and asm/user.h don't export to userspace now, so we can
drop #ifdef __KERNEL__ for them.

[k.shutemov@gmail.com: remove #ifdef __KERNEL_]
Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
Reviewed-by: David Woodhouse <dwmw2@infradead.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/elf.h       |    3 ---
 include/asm-alpha/page.h      |    3 ---
 include/asm-arm/elf.h         |    3 ---
 include/asm-arm/page.h        |    5 -----
 include/asm-avr32/elf.h       |    2 --
 include/asm-avr32/page.h      |    4 ----
 include/asm-blackfin/elf.h    |    2 --
 include/asm-blackfin/page.h   |    3 ---
 include/asm-cris/elf.h        |    3 ---
 include/asm-cris/page.h       |    4 ----
 include/asm-frv/elf.h         |    2 --
 include/asm-frv/page.h        |    4 ----
 include/asm-h8300/elf.h       |    2 --
 include/asm-h8300/page.h      |    4 ----
 include/asm-ia64/elf.h        |    3 ---
 include/asm-ia64/page.h       |    3 ---
 include/asm-m32r/elf.h        |    2 --
 include/asm-m32r/page.h       |    2 --
 include/asm-m68k/elf.h        |    2 --
 include/asm-m68k/page.h       |    5 -----
 include/asm-m68knommu/elf.h   |    2 --
 include/asm-m68knommu/page.h  |    4 ----
 include/asm-mips/elf.h        |    4 ----
 include/asm-mips/page.h       |    5 -----
 include/asm-mips/user.h       |    4 ----
 include/asm-parisc/elf.h      |    3 ---
 include/asm-parisc/page.h     |    4 ----
 include/asm-powerpc/page.h    |    3 ---
 include/asm-powerpc/page_32.h |    2 --
 include/asm-powerpc/page_64.h |    2 --
 include/asm-powerpc/user.h    |    4 ----
 include/asm-s390/elf.h        |    2 --
 include/asm-s390/page.h       |    3 ---
 include/asm-sh/page.h         |    3 ---
 include/asm-sparc/elf.h       |    3 ---
 include/asm-sparc/page.h      |    4 ----
 include/asm-sparc64/elf.h     |    4 ----
 include/asm-sparc64/page.h    |    3 ---
 include/asm-v850/elf.h        |    2 --
 include/asm-v850/page.h       |    4 ----
 include/asm-v850/user.h       |    4 ----
 include/asm-x86/elf.h         |    3 ---
 include/asm-x86/user.h        |   14 +++-----------
 include/asm-xtensa/elf.h      |    3 ---
 include/asm-xtensa/page.h     |    3 ---
 45 files changed, 3 insertions(+), 150 deletions(-)

diff -puN include/asm-alpha/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-alpha/elf.h
--- a/include/asm-alpha/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-alpha/elf.h
@@ -144,8 +144,6 @@ extern int dump_elf_task_fp(elf_fpreg_t 
 	: amask (AMASK_CIX) ? "ev6" : "ev67");	\
 })
 
-#ifdef __KERNEL__
-
 #define SET_PERSONALITY(EX, IBCS2)				\
 	set_personality(((EX).e_flags & EF_ALPHA_32BIT)		\
 	   ? PER_LINUX_32BIT : (IBCS2) ? PER_SVR4 : PER_LINUX)
@@ -164,5 +162,4 @@ extern int alpha_l3_cacheshape;
     NEW_AUX_ENT(AT_L3_CACHESHAPE, alpha_l3_cacheshape);		\
   } while (0)
 
-#endif /* __KERNEL__ */
 #endif /* __ASM_ALPHA_ELF_H */
diff -puN include/asm-alpha/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-alpha/page.h
--- a/include/asm-alpha/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-alpha/page.h
@@ -1,8 +1,6 @@
 #ifndef _ALPHA_PAGE_H
 #define _ALPHA_PAGE_H
 
-#ifdef __KERNEL__
-
 #include <linux/const.h>
 #include <asm/pal.h>
 
@@ -98,5 +96,4 @@ typedef unsigned long pgprot_t;
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
 #endif /* _ALPHA_PAGE_H */
diff -puN include/asm-arm/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-arm/elf.h
--- a/include/asm-arm/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-arm/elf.h
@@ -41,7 +41,6 @@ typedef struct user_fp elf_fpregset_t;
 #endif
 #define ELF_ARCH	EM_ARM
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 /*
  * This yields a string that ld.so will use to load implementation
@@ -115,5 +114,3 @@ extern char elf_platform[];
 	} while (0)
 
 #endif
-
-#endif
diff -puN include/asm-arm/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-arm/page.h
--- a/include/asm-arm/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-arm/page.h
@@ -10,9 +10,6 @@
 #ifndef _ASMARM_PAGE_H
 #define _ASMARM_PAGE_H
 
-
-#ifdef __KERNEL__
-
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT		12
 #define PAGE_SIZE		(1UL << PAGE_SHIFT)
@@ -192,6 +189,4 @@ typedef unsigned long pgprot_t;
 
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
-
 #endif
diff -puN include/asm-avr32/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-avr32/elf.h
--- a/include/asm-avr32/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-avr32/elf.h
@@ -103,8 +103,6 @@ typedef struct user_fpu_struct elf_fpreg
 
 #define ELF_PLATFORM  (NULL)
 
-#ifdef __KERNEL__
 #define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX_32BIT)
-#endif
 
 #endif /* __ASM_AVR32_ELF_H */
diff -puN include/asm-avr32/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-avr32/page.h
--- a/include/asm-avr32/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-avr32/page.h
@@ -8,8 +8,6 @@
 #ifndef __ASM_AVR32_PAGE_H
 #define __ASM_AVR32_PAGE_H
 
-#ifdef __KERNEL__
-
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
 #ifdef __ASSEMBLY__
@@ -107,6 +105,4 @@ static inline int get_order(unsigned lon
  */
 #define HIGHMEM_START		0x20000000UL
 
-#endif /* __KERNEL__ */
-
 #endif /* __ASM_AVR32_PAGE_H */
diff -puN include/asm-blackfin/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-blackfin/elf.h
--- a/include/asm-blackfin/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-blackfin/elf.h
@@ -120,8 +120,6 @@ do {											\
 
 #define ELF_PLATFORM  (NULL)
 
-#ifdef __KERNEL__
 #define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
-#endif
 
 #endif
diff -puN include/asm-blackfin/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-blackfin/page.h
--- a/include/asm-blackfin/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-blackfin/page.h
@@ -11,8 +11,6 @@
 #endif
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
-#ifdef __KERNEL__
-
 #include <asm/setup.h>
 
 #ifndef __ASSEMBLY__
@@ -88,6 +86,5 @@ extern unsigned long memory_end;
 #include <asm-generic/page.h>
 
 #endif				/* __ASSEMBLY__ */
-#endif				/* __KERNEL__ */
 
 #endif				/* _BLACKFIN_PAGE_H */
diff -puN include/asm-cris/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-cris/elf.h
--- a/include/asm-cris/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-cris/elf.h
@@ -45,7 +45,6 @@ typedef unsigned long elf_fpregset_t;
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_CRIS
 
-#ifdef __KERNEL__
 #include <asm/arch/elf.h>
 
 /* The master for these definitions is {binutils}/include/elf/cris.h:  */
@@ -91,6 +90,4 @@ typedef unsigned long elf_fpregset_t;
 
 #define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
 
-#endif /* __KERNEL__ */
-
 #endif
diff -puN include/asm-cris/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-cris/page.h
--- a/include/asm-cris/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-cris/page.h
@@ -1,8 +1,6 @@
 #ifndef _CRIS_PAGE_H
 #define _CRIS_PAGE_H
 
-#ifdef __KERNEL__
-
 #include <asm/arch/page.h>
 #include <linux/const.h>
 
@@ -74,7 +72,5 @@ typedef struct { unsigned long pgprot; }
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _CRIS_PAGE_H */
 
diff -puN include/asm-frv/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-frv/elf.h
--- a/include/asm-frv/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-frv/elf.h
@@ -137,8 +137,6 @@ do {											\
 
 #define ELF_PLATFORM  (NULL)
 
-#ifdef __KERNEL__
 #define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
-#endif
 
 #endif
diff -puN include/asm-frv/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-frv/page.h
--- a/include/asm-frv/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-frv/page.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_PAGE_H
 #define _ASM_PAGE_H
 
-#ifdef __KERNEL__
-
 #include <asm/virtconvert.h>
 #include <asm/mem-layout.h>
 #include <asm/sections.h>
@@ -79,6 +77,4 @@ extern unsigned long max_pfn;
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_PAGE_H */
diff -puN include/asm-h8300/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-h8300/elf.h
--- a/include/asm-h8300/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-h8300/elf.h
@@ -55,9 +55,7 @@ typedef unsigned long elf_fpregset_t;
 
 #define ELF_PLATFORM  (NULL)
 
-#ifdef __KERNEL__
 #define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX)
-#endif
 
 #define R_H8_NONE       0
 #define R_H8_DIR32      1
diff -puN include/asm-h8300/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-h8300/page.h
--- a/include/asm-h8300/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-h8300/page.h
@@ -1,8 +1,6 @@
 #ifndef _H8300_PAGE_H
 #define _H8300_PAGE_H
 
-#ifdef __KERNEL__
-
 /* PAGE_SHIFT determines the page size */
 
 #define PAGE_SHIFT	(12)
@@ -79,6 +77,4 @@ extern unsigned long memory_end;
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _H8300_PAGE_H */
diff -puN include/asm-ia64/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-ia64/elf.h
--- a/include/asm-ia64/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-ia64/elf.h
@@ -177,7 +177,6 @@ extern void ia64_elf_core_copy_regs (str
    relevant until we have real hardware to play with... */
 #define ELF_PLATFORM	NULL
 
-#ifdef __KERNEL__
 #define SET_PERSONALITY(ex, ibcs2)	set_personality(PER_LINUX)
 #define elf_read_implies_exec(ex, executable_stack)					\
 	((executable_stack!=EXSTACK_DISABLE_X) && ((ex).e_flags & EF_IA_64_LINUX_EXECUTABLE_STACK) != 0)
@@ -248,6 +247,4 @@ do {									\
 	}								\
 } while (0)
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_IA64_ELF_H */
diff -puN include/asm-ia64/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-ia64/page.h
--- a/include/asm-ia64/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-ia64/page.h
@@ -7,8 +7,6 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>
  */
 
-# ifdef __KERNEL__
-
 #include <asm/intrinsics.h>
 #include <asm/types.h>
 
@@ -227,5 +225,4 @@ get_order (unsigned long size)
 					 (((current->personality & READ_IMPLIES_EXEC) != 0)	\
 					  ? VM_EXEC : 0))
 
-# endif /* __KERNEL__ */
 #endif /* _ASM_IA64_PAGE_H */
diff -puN include/asm-m32r/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-m32r/elf.h
--- a/include/asm-m32r/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-m32r/elf.h
@@ -129,8 +129,6 @@ typedef elf_fpreg_t elf_fpregset_t;
    intent than poking at uname or /proc/cpuinfo.  */
 #define ELF_PLATFORM	(NULL)
 
-#ifdef __KERNEL__
 #define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX)
-#endif
 
 #endif  /* _ASM_M32R__ELF_H */
diff -puN include/asm-m32r/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-m32r/page.h
--- a/include/asm-m32r/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-m32r/page.h
@@ -6,7 +6,6 @@
 #define PAGE_SIZE	(1UL << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 extern void clear_page(void *to);
@@ -87,5 +86,4 @@ typedef struct { unsigned long pgprot; }
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
 #endif /* _ASM_M32R_PAGE_H */
diff -puN include/asm-m68k/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-m68k/elf.h
--- a/include/asm-m68k/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-m68k/elf.h
@@ -114,8 +114,6 @@ typedef struct user_m68kfp_struct elf_fp
 
 #define ELF_PLATFORM  (NULL)
 
-#ifdef __KERNEL__
 #define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
-#endif
 
 #endif
diff -puN include/asm-m68k/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-m68k/page.h
--- a/include/asm-m68k/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-m68k/page.h
@@ -1,9 +1,6 @@
 #ifndef _M68K_PAGE_H
 #define _M68K_PAGE_H
 
-
-#ifdef __KERNEL__
-
 #include <linux/const.h>
 
 /* PAGE_SHIFT determines the page size */
@@ -230,6 +227,4 @@ static inline __attribute_const__ int __
 
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _M68K_PAGE_H */
diff -puN include/asm-m68knommu/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-m68knommu/elf.h
--- a/include/asm-m68knommu/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-m68knommu/elf.h
@@ -105,8 +105,6 @@ typedef struct user_m68kfp_struct elf_fp
 
 #define ELF_PLATFORM  (NULL)
 
-#ifdef __KERNEL__
 #define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
-#endif
 
 #endif
diff -puN include/asm-m68knommu/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-m68knommu/page.h
--- a/include/asm-m68knommu/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-m68knommu/page.h
@@ -1,8 +1,6 @@
 #ifndef _M68KNOMMU_PAGE_H
 #define _M68KNOMMU_PAGE_H
 
-#ifdef __KERNEL__
-
 /* PAGE_SHIFT determines the page size */
 
 #define PAGE_SHIFT	(12)
@@ -78,6 +76,4 @@ extern unsigned long memory_end;
 
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _M68KNOMMU_PAGE_H */
diff -puN include/asm-mips/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-mips/elf.h
--- a/include/asm-mips/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-mips/elf.h
@@ -239,8 +239,6 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_N
 
 #endif /* !defined(ELF_ARCH) */
 
-#ifdef __KERNEL__
-
 struct mips_abi;
 
 extern struct mips_abi mips_abi;
@@ -328,8 +326,6 @@ extern int dump_task_fpu(struct task_str
 #define ELF_CORE_COPY_FPREGS(tsk, elf_fpregs)			\
 	dump_task_fpu(tsk, elf_fpregs)
 
-#endif /* __KERNEL__ */
-
 #define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
diff -puN include/asm-mips/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-mips/page.h
--- a/include/asm-mips/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-mips/page.h
@@ -9,9 +9,6 @@
 #ifndef _ASM_PAGE_H
 #define _ASM_PAGE_H
 
-
-#ifdef __KERNEL__
-
 #include <spaces.h>
 
 /*
@@ -190,6 +187,4 @@ typedef struct { unsigned long pgprot; }
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif /* defined (__KERNEL__) */
-
 #endif /* _ASM_PAGE_H */
diff -puN include/asm-mips/user.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-mips/user.h
--- a/include/asm-mips/user.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-mips/user.h
@@ -8,8 +8,6 @@
 #ifndef _ASM_USER_H
 #define _ASM_USER_H
 
-#ifdef __KERNEL__
-
 #include <asm/page.h>
 #include <asm/reg.h>
 
@@ -57,6 +55,4 @@ struct user {
 #define HOST_DATA_START_ADDR	(u.start_data)
 #define HOST_STACK_END_ADDR	(u.start_stack + u.u_ssize * NBPG)
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_USER_H */
diff -puN include/asm-parisc/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-parisc/elf.h
--- a/include/asm-parisc/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-parisc/elf.h
@@ -237,14 +237,11 @@ typedef unsigned long elf_greg_t;
 
 #define ELF_PLATFORM  ("PARISC\0" /*+((boot_cpu_data.x86-3)*5) */)
 
-#ifdef __KERNEL__
 #define SET_PERSONALITY(ex, ibcs2) \
 	current->personality = PER_LINUX; \
 	current->thread.map_base = DEFAULT_MAP_BASE; \
 	current->thread.task_size = DEFAULT_TASK_SIZE \
 
-#endif
-
 /*
  * Fill in general registers in a core dump.  This saves pretty
  * much the same registers as hp-ux, although in a different order.
diff -puN include/asm-parisc/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-parisc/page.h
--- a/include/asm-parisc/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-parisc/page.h
@@ -1,8 +1,6 @@
 #ifndef _PARISC_PAGE_H
 #define _PARISC_PAGE_H
 
-#ifdef __KERNEL__
-
 #include <linux/const.h>
 
 #if defined(CONFIG_PARISC_PAGE_SIZE_4KB)
@@ -175,6 +173,4 @@ extern int npmem_ranges;
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _PARISC_PAGE_H */
diff -puN include/asm-powerpc/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-powerpc/page.h
--- a/include/asm-powerpc/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-powerpc/page.h
@@ -10,7 +10,6 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#ifdef __KERNEL__
 #include <asm/asm-compat.h>
 #include <asm/kdump.h>
 
@@ -194,6 +193,4 @@ struct vm_area_struct;
 #include <asm-generic/memory_model.h>
 #endif /* __ASSEMBLY__ */
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_POWERPC_PAGE_H */
diff -puN include/asm-powerpc/page_32.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-powerpc/page_32.h
--- a/include/asm-powerpc/page_32.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-powerpc/page_32.h
@@ -1,6 +1,5 @@
 #ifndef _ASM_POWERPC_PAGE_32_H
 #define _ASM_POWERPC_PAGE_32_H
-#ifdef __KERNEL__
 
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_DEFAULT_FLAGS32
 
@@ -32,5 +31,4 @@ extern void copy_page(void *to, void *fr
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_PAGE_32_H */
diff -puN include/asm-powerpc/page_64.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-powerpc/page_64.h
--- a/include/asm-powerpc/page_64.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-powerpc/page_64.h
@@ -1,6 +1,5 @@
 #ifndef _ASM_POWERPC_PAGE_64_H
 #define _ASM_POWERPC_PAGE_64_H
-#ifdef __KERNEL__
 
 /*
  * Copyright (C) 2001 PPC64 Team, IBM Corp
@@ -183,5 +182,4 @@ do {						\
 
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_PAGE_64_H */
diff -puN include/asm-powerpc/user.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-powerpc/user.h
--- a/include/asm-powerpc/user.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-powerpc/user.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_POWERPC_USER_H
 #define _ASM_POWERPC_USER_H
 
-#ifdef __KERNEL__
-
 #include <asm/ptrace.h>
 #include <asm/page.h>
 
@@ -50,6 +48,4 @@ struct user {
 #define HOST_TEXT_START_ADDR	(u.start_code)
 #define HOST_DATA_START_ADDR	(u.start_data)
 #define HOST_STACK_END_ADDR	(u.start_stack + u.u_ssize * NBPG)
-
-#endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_USER_H */
diff -puN include/asm-s390/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-s390/elf.h
--- a/include/asm-s390/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-s390/elf.h
@@ -113,7 +113,6 @@
 typedef s390_fp_regs elf_fpregset_t;
 typedef s390_regs elf_gregset_t;
 
-#ifdef __KERNEL__
 #include <linux/sched.h>	/* for task_struct */
 #include <asm/system.h>		/* for save_access_regs */
 
@@ -214,6 +213,5 @@ do {							\
 	clear_thread_flag(TIF_31BIT);			\
 } while (0)
 #endif /* __s390x__ */
-#endif
 
 #endif
diff -puN include/asm-s390/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-s390/page.h
--- a/include/asm-s390/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-s390/page.h
@@ -19,7 +19,6 @@
 #define PAGE_DEFAULT_ACC	0
 #define PAGE_DEFAULT_KEY	(PAGE_DEFAULT_ACC << 4)
 
-#ifdef __KERNEL__
 #include <asm/setup.h>
 #ifndef __ASSEMBLY__
 
@@ -172,6 +171,4 @@ static inline int pfn_valid(unsigned lon
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _S390_PAGE_H */
diff -puN include/asm-sh/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-sh/page.h
--- a/include/asm-sh/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-sh/page.h
@@ -7,8 +7,6 @@
 
 #include <linux/const.h>
 
-#ifdef __KERNEL__
-
 /* PAGE_SHIFT determines the page size */
 #if defined(CONFIG_PAGE_SIZE_4KB)
 # define PAGE_SHIFT	12
@@ -178,5 +176,4 @@ typedef struct { unsigned long pgd; } pg
 #define ARCH_SLAB_MINALIGN	8
 #endif
 
-#endif /* __KERNEL__ */
 #endif /* __ASM_SH_PAGE_H */
diff -puN include/asm-sparc/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-sparc/elf.h
--- a/include/asm-sparc/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-sparc/elf.h
@@ -85,7 +85,6 @@ typedef struct {
 	unsigned int	pr_q[64];
 } elf_fpregset_t;
 
-#ifdef __KERNEL__
 #include <asm/mbus.h>
 #include <asm/uaccess.h>
 
@@ -166,6 +165,4 @@ do {	unsigned long *dest = &(__elf_regs[
 
 #define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
 
-#endif /* __KERNEL__ */
-
 #endif /* !(__ASMSPARC_ELF_H) */
diff -puN include/asm-sparc/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-sparc/page.h
--- a/include/asm-sparc/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-sparc/page.h
@@ -8,8 +8,6 @@
 #ifndef _SPARC_PAGE_H
 #define _SPARC_PAGE_H
 
-#ifdef __KERNEL__
-
 #ifdef CONFIG_SUN4
 #define PAGE_SHIFT   13
 #else
@@ -163,6 +161,4 @@ extern unsigned long pfn_base;
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _SPARC_PAGE_H */
diff -puN include/asm-sparc64/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-sparc64/elf.h
--- a/include/asm-sparc64/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-sparc64/elf.h
@@ -7,11 +7,9 @@
  */
 
 #include <asm/ptrace.h>
-#ifdef __KERNEL__
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/spitfire.h>
-#endif
 
 /*
  * Sparc section types
@@ -175,7 +173,6 @@ static inline unsigned int sparc64_elf_h
 
 #define ELF_PLATFORM	(NULL)
 
-#ifdef __KERNEL__
 #define SET_PERSONALITY(ex, ibcs2)			\
 do {	unsigned long new_flags = current_thread_info()->flags; \
 	new_flags &= _TIF_32BIT;			\
@@ -194,6 +191,5 @@ do {	unsigned long new_flags = current_t
 	else if (current->personality != PER_LINUX32)	\
 		set_personality(PER_LINUX);		\
 } while (0)
-#endif
 
 #endif /* !(__ASM_SPARC64_ELF_H) */
diff -puN include/asm-sparc64/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-sparc64/page.h
--- a/include/asm-sparc64/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-sparc64/page.h
@@ -3,8 +3,6 @@
 #ifndef _SPARC64_PAGE_H
 #define _SPARC64_PAGE_H
 
-#ifdef __KERNEL__
-
 #include <linux/const.h>
 
 #if defined(CONFIG_SPARC64_PAGE_SIZE_8KB)
@@ -143,5 +141,4 @@ typedef unsigned long pgprot_t;
 
 #include <asm-generic/page.h>
 
-#endif /* __KERNEL__ */
 #endif /* _SPARC64_PAGE_H */
diff -puN include/asm-v850/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-v850/elf.h
--- a/include/asm-v850/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-v850/elf.h
@@ -94,8 +94,6 @@ typedef struct user_fpu_struct elf_fpreg
 	0;								      \
   } while (0)
 
-#ifdef __KERNEL__
 #define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX_32BIT)
-#endif
 
 #endif /* __V850_ELF_H__ */
diff -puN include/asm-v850/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-v850/page.h
--- a/include/asm-v850/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-v850/page.h
@@ -14,8 +14,6 @@
 #ifndef __V850_PAGE_H__
 #define __V850_PAGE_H__
 
-#ifdef __KERNEL__
-
 #include <asm/machdep.h>
 
 
@@ -126,6 +124,4 @@ typedef unsigned long pgprot_t;
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif /* KERNEL */
-
 #endif /* __V850_PAGE_H__ */
diff -puN include/asm-v850/user.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-v850/user.h
--- a/include/asm-v850/user.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-v850/user.h
@@ -3,8 +3,6 @@
 
 /* Adapted from <asm-ppc/user.h>.  */
 
-#ifdef __KERNEL__
-
 #include <linux/ptrace.h>
 #include <asm/page.h>
 
@@ -51,6 +49,4 @@ struct user {
 #define HOST_DATA_START_ADDR	(u.start_data)
 #define HOST_STACK_END_ADDR	(u.start_stack + u.u_ssize * NBPG)
 
-#endif /* __KERNEL__ */
-
 #endif /* __V850_USER_H__ */
diff -puN include/asm-x86/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-x86/elf.h
--- a/include/asm-x86/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-x86/elf.h
@@ -72,7 +72,6 @@ typedef struct user_fxsr_struct elf_fpxr
 
 #endif
 
-#ifdef __KERNEL__
 #include <asm/vdso.h>
 
 extern unsigned int vdso_enabled;
@@ -321,6 +320,4 @@ extern int syscall32_setup_pages(struct 
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #define arch_randomize_brk arch_randomize_brk
 
-#endif /* __KERNEL__ */
-
 #endif
diff -puN include/asm-x86/user.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-x86/user.h
--- a/include/asm-x86/user.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-x86/user.h
@@ -1,13 +1,5 @@
-#ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "user_32.h"
-# else
-#  include "user_64.h"
-# endif
+#ifdef CONFIG_X86_32
+# include "user_32.h"
 #else
-# ifdef __i386__
-#  include "user_32.h"
-# else
-#  include "user_64.h"
-# endif
+# include "user_64.h"
 #endif
diff -puN include/asm-xtensa/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-xtensa/elf.h
--- a/include/asm-xtensa/elf.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-xtensa/elf.h
@@ -257,8 +257,6 @@ extern void xtensa_elf_core_copy_regs (x
        _r->areg[12]=0; _r->areg[13]=0;   _r->areg[14]=0; _r->areg[15]=0; \
   } while (0)
 
-#ifdef __KERNEL__
-
 #define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX_32BIT)
 
 struct task_struct;
@@ -272,5 +270,4 @@ extern void do_save_fpregs (elf_fpregset
 extern int do_restore_fpregs (elf_fpregset_t*, struct pt_regs*,
 			      struct task_struct*);
 
-#endif	/* __KERNEL__ */
 #endif	/* _XTENSA_ELF_H */
diff -puN include/asm-xtensa/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed include/asm-xtensa/page.h
--- a/include/asm-xtensa/page.h~cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed
+++ a/include/asm-xtensa/page.h
@@ -11,8 +11,6 @@
 #ifndef _XTENSA_PAGE_H
 #define _XTENSA_PAGE_H
 
-#ifdef __KERNEL__
-
 #include <asm/processor.h>
 #include <asm/types.h>
 #include <asm/cache.h>
@@ -174,5 +172,4 @@ extern void copy_user_page(void*, void*,
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#endif /* __KERNEL__ */
 #endif /* _XTENSA_PAGE_H */
_

Patches currently in -mm which might be from k.shutemov@gmail.com are

origin.patch
