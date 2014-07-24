From: akpm@linux-foundation.org
Subject: + arm64ia64ppcs390shtileumx86mm-remove-default-gate-area.patch
 added to -mm tree
Date: Thu, 24 Jul 2014 16:18:51 -0700
Message-ID: <53d1945b.ujF1zaMQb4bibkTz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:44572 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934768AbaGXXSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 19:18:52 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so994708iec.1
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 16:18:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@amacapital.net, Nathan_Lynch@mentor.com, benh@kernel.crashing.org, catalin.marinas@arm.com, cmetcalf@tilera.com, fenghua.yu@intel.com, heiko.carstens@de.ibm.com, hpa@linux.intel.com, hpa@zytor.com, jdike@addtoit.com, mingo@redhat.com, nathan_lynch@mentor.com, paulus@samba.org, richard@nod.at, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64,ia64,ppc,s390,sh,tile,um,x86,mm: remove default gate area
has been added to the -mm tree.  Its filename is
     arm64ia64ppcs390shtileumx86mm-remove-default-gate-area.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64ia64ppcs390shtileumx86mm-remove-default-gate-area.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64ia64ppcs390shtileumx86mm-remove-default-gate-area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Lutomirski <luto@amacapital.net>
Subject: arm64,ia64,ppc,s390,sh,tile,um,x86,mm: remove default gate area

The core mm code will provide a default gate area based on
FIXADDR_USER_START and FIXADDR_USER_END if
!defined(__HAVE_ARCH_GATE_AREA) && defined(AT_SYSINFO_EHDR).

This default is only useful for ia64.  arm64, ppc, s390, sh, tile, 64-bit
UML, and x86_32 have their own code just to disable it.  arm, 32-bit UML,
and x86_64 have gate areas, but they have their own implementations.

This gets rid of the default and moves the code into ia64.

This should save some code on architectures without a gate area: it's now
possible to inline the gate_area functions in the default case.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Nathan Lynch <nathan_lynch@mentor.com>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org> [in principle]
Acked-by: Richard Weinberger <richard@nod.at> [for um]
Acked-by: Will Deacon <will.deacon@arm.com> [for arm64]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nathan Lynch <Nathan_Lynch@mentor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/page.h      |    3 --
 arch/arm64/kernel/vdso.c           |   19 -------------
 arch/ia64/include/asm/page.h       |    2 +
 arch/ia64/mm/init.c                |   31 ++++++++++++++++++++++
 arch/powerpc/include/asm/page.h    |    3 --
 arch/powerpc/kernel/vdso.c         |   16 -----------
 arch/s390/include/asm/page.h       |    2 -
 arch/s390/kernel/vdso.c            |   15 ----------
 arch/sh/include/asm/page.h         |    5 ---
 arch/sh/kernel/vsyscall/vsyscall.c |   15 ----------
 arch/tile/include/asm/page.h       |    6 ----
 arch/tile/kernel/vdso.c            |   15 ----------
 arch/um/include/asm/page.h         |    5 +++
 arch/x86/include/asm/page.h        |    1 
 arch/x86/include/asm/page_64.h     |    2 +
 arch/x86/um/asm/elf.h              |    1 
 arch/x86/um/mem_64.c               |   15 ----------
 arch/x86/vdso/vdso32-setup.c       |   19 -------------
 include/linux/mm.h                 |   17 ++++++++----
 mm/memory.c                        |   38 ---------------------------
 mm/nommu.c                         |    5 ---
 21 files changed, 53 insertions(+), 182 deletions(-)

diff -puN arch/arm64/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/arm64/include/asm/page.h
--- a/arch/arm64/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/arm64/include/asm/page.h
@@ -28,9 +28,6 @@
 #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
-/* We do define AT_SYSINFO_EHDR but don't use the gate mechanism */
-#define __HAVE_ARCH_GATE_AREA		1
-
 #ifndef __ASSEMBLY__
 
 #ifdef CONFIG_ARM64_64K_PAGES
diff -puN arch/arm64/kernel/vdso.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/arm64/kernel/vdso.c
--- a/arch/arm64/kernel/vdso.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/arm64/kernel/vdso.c
@@ -187,25 +187,6 @@ const char *arch_vma_name(struct vm_area
 }
 
 /*
- * We define AT_SYSINFO_EHDR, so we need these function stubs to keep
- * Linux happy.
- */
-int in_gate_area_no_mm(unsigned long addr)
-{
-	return 0;
-}
-
-int in_gate_area(struct mm_struct *mm, unsigned long addr)
-{
-	return 0;
-}
-
-struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
-{
-	return NULL;
-}
-
-/*
  * Update the vDSO data page to keep in sync with kernel timekeeping.
  */
 void update_vsyscall(struct timekeeper *tk)
diff -puN arch/ia64/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/ia64/include/asm/page.h
--- a/arch/ia64/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/ia64/include/asm/page.h
@@ -231,4 +231,6 @@ get_order (unsigned long size)
 #define PERCPU_ADDR		(-PERCPU_PAGE_SIZE)
 #define LOAD_OFFSET		(KERNEL_START - KERNEL_TR_PAGE_SIZE)
 
+#define __HAVE_ARCH_GATE_AREA	1
+
 #endif /* _ASM_IA64_PAGE_H */
diff -puN arch/ia64/mm/init.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/ia64/mm/init.c
@@ -278,6 +278,37 @@ setup_gate (void)
 	ia64_patch_gate();
 }
 
+static struct vm_area_struct gate_vma;
+
+static int __init gate_vma_init(void)
+{
+	gate_vma.vm_mm = NULL;
+	gate_vma.vm_start = FIXADDR_USER_START;
+	gate_vma.vm_end = FIXADDR_USER_END;
+	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
+	gate_vma.vm_page_prot = __P101;
+
+	return 0;
+}
+__initcall(gate_vma_init);
+
+struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
+{
+	return &gate_vma;
+}
+
+int in_gate_area_no_mm(unsigned long addr)
+{
+	if ((addr >= FIXADDR_USER_START) && (addr < FIXADDR_USER_END))
+		return 1;
+	return 0;
+}
+
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
+{
+	return in_gate_area_no_mm(addr);
+}
+
 void ia64_mmu_init(void *my_cpu_data)
 {
 	unsigned long pta, impl_va_bits;
diff -puN arch/powerpc/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/powerpc/include/asm/page.h
--- a/arch/powerpc/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/powerpc/include/asm/page.h
@@ -48,9 +48,6 @@ extern unsigned int HPAGE_SHIFT;
 #define HUGE_MAX_HSTATE		(MMU_PAGE_COUNT-1)
 #endif
 
-/* We do define AT_SYSINFO_EHDR but don't use the gate mechanism */
-#define __HAVE_ARCH_GATE_AREA		1
-
 /*
  * Subtle: (1 << PAGE_SHIFT) is an int, not an unsigned long. So if we
  * assign PAGE_MASK to a larger type it gets extended the way we want
diff -puN arch/powerpc/kernel/vdso.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/powerpc/kernel/vdso.c
--- a/arch/powerpc/kernel/vdso.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/powerpc/kernel/vdso.c
@@ -840,19 +840,3 @@ static int __init vdso_init(void)
 	return 0;
 }
 arch_initcall(vdso_init);
-
-int in_gate_area_no_mm(unsigned long addr)
-{
-	return 0;
-}
-
-int in_gate_area(struct mm_struct *mm, unsigned long addr)
-{
-	return 0;
-}
-
-struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
-{
-	return NULL;
-}
-
diff -puN arch/s390/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/s390/include/asm/page.h
--- a/arch/s390/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/s390/include/asm/page.h
@@ -162,6 +162,4 @@ static inline int devmem_is_allowed(unsi
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
-#define __HAVE_ARCH_GATE_AREA 1
-
 #endif /* _S390_PAGE_H */
diff -puN arch/s390/kernel/vdso.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/s390/kernel/vdso.c
--- a/arch/s390/kernel/vdso.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/s390/kernel/vdso.c
@@ -316,18 +316,3 @@ static int __init vdso_init(void)
 	return 0;
 }
 early_initcall(vdso_init);
-
-int in_gate_area_no_mm(unsigned long addr)
-{
-	return 0;
-}
-
-int in_gate_area(struct mm_struct *mm, unsigned long addr)
-{
-	return 0;
-}
-
-struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
-{
-	return NULL;
-}
diff -puN arch/sh/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/sh/include/asm/page.h
--- a/arch/sh/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/sh/include/asm/page.h
@@ -186,11 +186,6 @@ typedef struct page *pgtable_t;
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
-/* vDSO support */
-#ifdef CONFIG_VSYSCALL
-#define __HAVE_ARCH_GATE_AREA
-#endif
-
 /*
  * Some drivers need to perform DMA into kmalloc'ed buffers
  * and so we have to increase the kmalloc minalign for this.
diff -puN arch/sh/kernel/vsyscall/vsyscall.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/sh/kernel/vsyscall/vsyscall.c
--- a/arch/sh/kernel/vsyscall/vsyscall.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/sh/kernel/vsyscall/vsyscall.c
@@ -92,18 +92,3 @@ const char *arch_vma_name(struct vm_area
 
 	return NULL;
 }
-
-struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
-{
-	return NULL;
-}
-
-int in_gate_area(struct mm_struct *mm, unsigned long address)
-{
-	return 0;
-}
-
-int in_gate_area_no_mm(unsigned long address)
-{
-	return 0;
-}
diff -puN arch/tile/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/tile/include/asm/page.h
--- a/arch/tile/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/tile/include/asm/page.h
@@ -39,12 +39,6 @@
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 
 /*
- * We do define AT_SYSINFO_EHDR to support vDSO,
- * but don't use the gate mechanism.
- */
-#define __HAVE_ARCH_GATE_AREA		1
-
-/*
  * If the Kconfig doesn't specify, set a maximum zone order that
  * is enough so that we can create huge pages from small pages given
  * the respective sizes of the two page types.  See <linux/mmzone.h>.
diff -puN arch/tile/kernel/vdso.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/tile/kernel/vdso.c
--- a/arch/tile/kernel/vdso.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/tile/kernel/vdso.c
@@ -121,21 +121,6 @@ const char *arch_vma_name(struct vm_area
 	return NULL;
 }
 
-struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
-{
-	return NULL;
-}
-
-int in_gate_area(struct mm_struct *mm, unsigned long address)
-{
-	return 0;
-}
-
-int in_gate_area_no_mm(unsigned long address)
-{
-	return 0;
-}
-
 int setup_vdso_pages(void)
 {
 	struct page **pagelist;
diff -puN arch/um/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/um/include/asm/page.h
--- a/arch/um/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/um/include/asm/page.h
@@ -119,4 +119,9 @@ extern unsigned long uml_physmem;
 #include <asm-generic/getorder.h>
 
 #endif	/* __ASSEMBLY__ */
+
+#ifdef CONFIG_X86_32
+#define __HAVE_ARCH_GATE_AREA 1
+#endif
+
 #endif	/* __UM_PAGE_H */
diff -puN arch/x86/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/x86/include/asm/page.h
--- a/arch/x86/include/asm/page.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/x86/include/asm/page.h
@@ -70,7 +70,6 @@ extern bool __virt_addr_valid(unsigned l
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
-#define __HAVE_ARCH_GATE_AREA 1
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 
 #endif	/* __KERNEL__ */
diff -puN arch/x86/include/asm/page_64.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/x86/include/asm/page_64.h
--- a/arch/x86/include/asm/page_64.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/x86/include/asm/page_64.h
@@ -39,4 +39,6 @@ void copy_page(void *to, void *from);
 
 #endif	/* !__ASSEMBLY__ */
 
+#define __HAVE_ARCH_GATE_AREA 1
+
 #endif /* _ASM_X86_PAGE_64_H */
diff -puN arch/x86/um/asm/elf.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/x86/um/asm/elf.h
--- a/arch/x86/um/asm/elf.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/x86/um/asm/elf.h
@@ -216,6 +216,5 @@ extern long elf_aux_hwcap;
 #define ELF_HWCAP (elf_aux_hwcap)
 
 #define SET_PERSONALITY(ex) do ; while(0)
-#define __HAVE_ARCH_GATE_AREA 1
 
 #endif
diff -puN arch/x86/um/mem_64.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/x86/um/mem_64.c
--- a/arch/x86/um/mem_64.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/x86/um/mem_64.c
@@ -9,18 +9,3 @@ const char *arch_vma_name(struct vm_area
 
 	return NULL;
 }
-
-struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
-{
-	return NULL;
-}
-
-int in_gate_area(struct mm_struct *mm, unsigned long addr)
-{
-	return 0;
-}
-
-int in_gate_area_no_mm(unsigned long addr)
-{
-	return 0;
-}
diff -puN arch/x86/vdso/vdso32-setup.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area arch/x86/vdso/vdso32-setup.c
--- a/arch/x86/vdso/vdso32-setup.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/arch/x86/vdso/vdso32-setup.c
@@ -115,23 +115,6 @@ static __init int ia32_binfmt_init(void)
 	return 0;
 }
 __initcall(ia32_binfmt_init);
-#endif
-
-#else  /* CONFIG_X86_32 */
-
-struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
-{
-	return NULL;
-}
-
-int in_gate_area(struct mm_struct *mm, unsigned long addr)
-{
-	return 0;
-}
-
-int in_gate_area_no_mm(unsigned long addr)
-{
-	return 0;
-}
+#endif /* CONFIG_SYSCTL */
 
 #endif	/* CONFIG_X86_64 */
diff -puN include/linux/mm.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area include/linux/mm.h
--- a/include/linux/mm.h~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/include/linux/mm.h
@@ -2008,13 +2008,20 @@ static inline bool kernel_page_present(s
 #endif /* CONFIG_HIBERNATION */
 #endif
 
+#ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
-#ifdef	__HAVE_ARCH_GATE_AREA
-int in_gate_area_no_mm(unsigned long addr);
-int in_gate_area(struct mm_struct *mm, unsigned long addr);
+extern int in_gate_area_no_mm(unsigned long addr);
+extern int in_gate_area(struct mm_struct *mm, unsigned long addr);
 #else
-int in_gate_area_no_mm(unsigned long addr);
-#define in_gate_area(mm, addr) ({(void)mm; in_gate_area_no_mm(addr);})
+static inline struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
+{
+	return NULL;
+}
+static inline int in_gate_area_no_mm(unsigned long addr) { return 0; }
+static inline int in_gate_area(struct mm_struct *mm, unsigned long addr)
+{
+	return 0;
+}
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
 #ifdef CONFIG_SYSCTL
diff -puN mm/memory.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area mm/memory.c
--- a/mm/memory.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/mm/memory.c
@@ -3433,44 +3433,6 @@ int __pmd_alloc(struct mm_struct *mm, pu
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-#if !defined(__HAVE_ARCH_GATE_AREA)
-
-#if defined(AT_SYSINFO_EHDR)
-static struct vm_area_struct gate_vma;
-
-static int __init gate_vma_init(void)
-{
-	gate_vma.vm_mm = NULL;
-	gate_vma.vm_start = FIXADDR_USER_START;
-	gate_vma.vm_end = FIXADDR_USER_END;
-	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
-	gate_vma.vm_page_prot = __P101;
-
-	return 0;
-}
-__initcall(gate_vma_init);
-#endif
-
-struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
-{
-#ifdef AT_SYSINFO_EHDR
-	return &gate_vma;
-#else
-	return NULL;
-#endif
-}
-
-int in_gate_area_no_mm(unsigned long addr)
-{
-#ifdef AT_SYSINFO_EHDR
-	if ((addr >= FIXADDR_USER_START) && (addr < FIXADDR_USER_END))
-		return 1;
-#endif
-	return 0;
-}
-
-#endif	/* __HAVE_ARCH_GATE_AREA */
-
 static int __follow_pte(struct mm_struct *mm, unsigned long address,
 		pte_t **ptepp, spinlock_t **ptlp)
 {
diff -puN mm/nommu.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area mm/nommu.c
--- a/mm/nommu.c~arm64ia64ppcs390shtileumx86mm-remove-default-gate-area
+++ a/mm/nommu.c
@@ -1981,11 +1981,6 @@ error:
 	return -ENOMEM;
 }
 
-int in_gate_area_no_mm(unsigned long addr)
-{
-	return 0;
-}
-
 int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	BUG();
_

Patches currently in -mm which might be from luto@amacapital.net are

arm64ia64ppcs390shtileumx86mm-remove-default-gate-area.patch
linux-next.patch
mm-allow-drivers-to-prevent-new-writable-mappings.patch
shm-add-sealing-api.patch
shm-add-memfd_create-syscall.patch
selftests-add-memfd_create-sealing-tests.patch
selftests-add-memfd-sealing-page-pinning-tests.patch
shm-wait-for-pins-to-be-released-when-sealing.patch
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time-fix.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-kexec-kdump-on-efi-systems.patch
kexec-verify-the-signature-of-signed-pe-bzimage.patch

