From: akpm@linux-foundation.org
Subject: - paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:00 -0700
Message-ID: <200704132330.l3DNU0xh012670@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60602 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030891AbXDMXaR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: Add pagetable accessors to pack and unpack pagetable entries
has been removed from the -mm tree.  Its filename was
     paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt_ops: Add pagetable accessors to pack and unpack pagetable entries
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add a set of accessors to pack, unpack and modify page table entries (at all
levels).  This allows a paravirt implementation to control the contents of
pgd/pmd/pte entries.  For example, Xen uses this to convert the
(pseudo-)physical address into a machine address when populating a pagetable
entry, and converting back to pphys address when an entry is read.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c       |   84 ++++------------------------
 arch/i386/kernel/vmi.c            |    6 +-
 include/asm-i386/page.h           |   79 ++++++++++++++++++++++----
 include/asm-i386/paravirt.h       |   52 +++++++++++++----
 include/asm-i386/pgtable-2level.h |   26 +++++++-
 include/asm-i386/pgtable-3level.h |   63 ++++++++++++---------
 include/asm-i386/pgtable.h        |    2 
 7 files changed, 184 insertions(+), 128 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/arch/i386/kernel/paravirt.c
@@ -117,78 +117,6 @@ static void native_flush_tlb_single(u32 
 	__native_flush_tlb_single(addr);
 }
 
-#ifndef CONFIG_X86_PAE
-static void native_set_pte(pte_t *ptep, pte_t pteval)
-{
-	*ptep = pteval;
-}
-
-static void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval)
-{
-	*ptep = pteval;
-}
-
-static void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	*pmdp = pmdval;
-}
-
-#else /* CONFIG_X86_PAE */
-
-static void native_set_pte(pte_t *ptep, pte_t pte)
-{
-	ptep->pte_high = pte.pte_high;
-	smp_wmb();
-	ptep->pte_low = pte.pte_low;
-}
-
-static void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
-{
-	ptep->pte_high = pte.pte_high;
-	smp_wmb();
-	ptep->pte_low = pte.pte_low;
-}
-
-static void native_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
-{
-	ptep->pte_low = 0;
-	smp_wmb();
-	ptep->pte_high = pte.pte_high;
-	smp_wmb();
-	ptep->pte_low = pte.pte_low;
-}
-
-static void native_set_pte_atomic(pte_t *ptep, pte_t pteval)
-{
-	set_64bit((unsigned long long *)ptep,pte_val(pteval));
-}
-
-static void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	set_64bit((unsigned long long *)pmdp,pmd_val(pmdval));
-}
-
-static void native_set_pud(pud_t *pudp, pud_t pudval)
-{
-	*pudp = pudval;
-}
-
-static void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	ptep->pte_low = 0;
-	smp_wmb();
-	ptep->pte_high = 0;
-}
-
-static void native_pmd_clear(pmd_t *pmd)
-{
-	u32 *tmp = (u32 *)pmd;
-	*tmp = 0;
-	smp_wmb();
-	*(tmp + 1) = 0;
-}
-#endif /* CONFIG_X86_PAE */
-
 /* These are in entry.S */
 extern void native_iret(void);
 extern void native_irq_enable_sysexit(void);
@@ -282,14 +210,26 @@ struct paravirt_ops paravirt_ops = {
 	.set_pmd = native_set_pmd,
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
+
+	.ptep_get_and_clear = native_ptep_get_and_clear,
+
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
 	.set_pte_present = native_set_pte_present,
 	.set_pud = native_set_pud,
 	.pte_clear = native_pte_clear,
 	.pmd_clear = native_pmd_clear,
+
+	.pmd_val = native_pmd_val,
+	.make_pmd = native_make_pmd,
 #endif
 
+	.pte_val = native_pte_val,
+	.pgd_val = native_pgd_val,
+
+	.make_pte = native_make_pte,
+	.make_pgd = native_make_pgd,
+
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
diff -puN arch/i386/kernel/vmi.c~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/arch/i386/kernel/vmi.c
@@ -442,13 +442,13 @@ static void vmi_release_pd(u32 pfn)
         ((level) | (is_current_as(mm, user) ?                           \
                 (VMI_PAGE_DEFER | VMI_PAGE_CURRENT_AS | ((addr) & VMI_PAGE_VA_MASK)) : 0))
 
-static void vmi_update_pte(struct mm_struct *mm, u32 addr, pte_t *ptep)
+static void vmi_update_pte(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.update_pte(ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
 }
 
-static void vmi_update_pte_defer(struct mm_struct *mm, u32 addr, pte_t *ptep)
+static void vmi_update_pte_defer(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.update_pte(ptep, vmi_flags_addr_defer(mm, addr, VMI_PAGE_PT, 0));
@@ -461,7 +461,7 @@ static void vmi_set_pte(pte_t *ptep, pte
 	vmi_ops.set_pte(pte, ptep, VMI_PAGE_PT);
 }
 
-static void vmi_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
+static void vmi_set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
 {
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
diff -puN include/asm-i386/page.h~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries include/asm-i386/page.h
--- a/include/asm-i386/page.h~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/include/asm-i386/page.h
@@ -12,7 +12,6 @@
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-
 #ifdef CONFIG_X86_USE_3DNOW
 
 #include <asm/mmx.h>
@@ -42,26 +41,81 @@
  * These are used to make use of C type-checking..
  */
 extern int nx_enabled;
+
 #ifdef CONFIG_X86_PAE
 extern unsigned long long __supported_pte_mask;
 typedef struct { unsigned long pte_low, pte_high; } pte_t;
 typedef struct { unsigned long long pmd; } pmd_t;
 typedef struct { unsigned long long pgd; } pgd_t;
 typedef struct { unsigned long long pgprot; } pgprot_t;
-#define pmd_val(x)	((x).pmd)
-#define pte_val(x)	((x).pte_low | ((unsigned long long)(x).pte_high << 32))
-#define __pmd(x) ((pmd_t) { (x) } )
+
+static inline unsigned long long native_pgd_val(pgd_t pgd)
+{
+	return pgd.pgd;
+}
+
+static inline unsigned long long native_pmd_val(pmd_t pmd)
+{
+	return pmd.pmd;
+}
+
+static inline unsigned long long native_pte_val(pte_t pte)
+{
+	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
+}
+
+static inline pgd_t native_make_pgd(unsigned long long val)
+{
+	return (pgd_t) { val };
+}
+
+static inline pmd_t native_make_pmd(unsigned long long val)
+{
+	return (pmd_t) { val };
+}
+
+static inline pte_t native_make_pte(unsigned long long val)
+{
+	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
+}
+
+#ifndef CONFIG_PARAVIRT
+#define pmd_val(x)	native_pmd_val(x)
+#define __pmd(x)	native_make_pmd(x)
+#endif
+
 #define HPAGE_SHIFT	21
 #include <asm-generic/pgtable-nopud.h>
-#else
+#else  /* !CONFIG_X86_PAE */
 typedef struct { unsigned long pte_low; } pte_t;
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
 #define boot_pte_t pte_t /* or would you rather have a typedef */
-#define pte_val(x)	((x).pte_low)
+
+static inline unsigned long native_pgd_val(pgd_t pgd)
+{
+	return pgd.pgd;
+}
+
+static inline unsigned long native_pte_val(pte_t pte)
+{
+	return pte.pte_low;
+}
+
+static inline pgd_t native_make_pgd(unsigned long val)
+{
+	return (pgd_t) { val };
+}
+
+static inline pte_t native_make_pte(unsigned long val)
+{
+	return (pte_t) { .pte_low = val };
+}
+
 #define HPAGE_SHIFT	22
 #include <asm-generic/pgtable-nopmd.h>
-#endif
+#endif	/* CONFIG_X86_PAE */
+
 #define PTE_MASK	PAGE_MASK
 
 #ifdef CONFIG_HUGETLB_PAGE
@@ -71,13 +125,16 @@ typedef struct { unsigned long pgprot; }
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 #endif
 
-#define pgd_val(x)	((x).pgd)
 #define pgprot_val(x)	((x).pgprot)
-
-#define __pte(x) ((pte_t) { (x) } )
-#define __pgd(x) ((pgd_t) { (x) } )
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
+#ifndef CONFIG_PARAVIRT
+#define pgd_val(x)	native_pgd_val(x)
+#define __pgd(x)	native_make_pgd(x)
+#define pte_val(x)	native_pte_val(x)
+#define __pte(x)	native_make_pte(x)
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 /* to align the pointer to the (next) page boundary */
diff -puN include/asm-i386/paravirt.h~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/include/asm-i386/paravirt.h
@@ -2,7 +2,6 @@
 #define __ASM_PARAVIRT_H
 /* Various instructions on x86 need to be replaced for
  * para-virtualization: those hooks are defined here. */
-#include <linux/linkage.h>
 #include <linux/stringify.h>
 #include <asm/page.h>
 
@@ -25,6 +24,8 @@
 #define CLBR_ANY 0x7
 
 #ifndef __ASSEMBLY__
+#include <linux/types.h>
+
 struct thread_struct;
 struct Xgt_desc_struct;
 struct tss_struct;
@@ -55,11 +56,6 @@ struct paravirt_ops
 	int (*set_wallclock)(unsigned long);
 	void (*time_init)(void);
 
-	/* All the function pointers here are declared as "fastcall"
-	   so that we get a specific register-based calling
-	   convention.  This makes it easier to implement inline
-	   assembler replacements. */
-
 	void (*cpuid)(unsigned int *eax, unsigned int *ebx,
 		      unsigned int *ecx, unsigned int *edx);
 
@@ -139,16 +135,33 @@ struct paravirt_ops
 	void (*release_pd)(u32 pfn);
 
 	void (*set_pte)(pte_t *ptep, pte_t pteval);
-	void (*set_pte_at)(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval);
+	void (*set_pte_at)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pteval);
 	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
-	void (*pte_update)(struct mm_struct *mm, u32 addr, pte_t *ptep);
-	void (*pte_update_defer)(struct mm_struct *mm, u32 addr, pte_t *ptep);
+	void (*pte_update)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+	void (*pte_update_defer)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+
+ 	pte_t (*ptep_get_and_clear)(pte_t *ptep);
+
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
-	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte);
+ 	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte);
 	void (*set_pud)(pud_t *pudp, pud_t pudval);
-	void (*pte_clear)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+ 	void (*pte_clear)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 	void (*pmd_clear)(pmd_t *pmdp);
+
+	unsigned long long (*pte_val)(pte_t);
+	unsigned long long (*pmd_val)(pmd_t);
+	unsigned long long (*pgd_val)(pgd_t);
+
+	pte_t (*make_pte)(unsigned long long pte);
+	pmd_t (*make_pmd)(unsigned long long pmd);
+	pgd_t (*make_pgd)(unsigned long long pgd);
+#else
+	unsigned long (*pte_val)(pte_t);
+	unsigned long (*pgd_val)(pgd_t);
+
+	pte_t (*make_pte)(unsigned long pte);
+	pgd_t (*make_pgd)(unsigned long pgd);
 #endif
 
 	void (*set_lazy_mode)(int mode);
@@ -219,6 +232,8 @@ static inline void __cpuid(unsigned int 
 #define read_cr4_safe(x) paravirt_ops.read_cr4_safe()
 #define write_cr4(x) paravirt_ops.write_cr4(x)
 
+#define raw_ptep_get_and_clear(xp)	(paravirt_ops.ptep_get_and_clear(xp))
+
 static inline void raw_safe_halt(void)
 {
 	paravirt_ops.safe_halt();
@@ -304,6 +319,17 @@ static inline void halt(void)
 	(paravirt_ops.write_idt_entry((dt), (entry), (low), (high)))
 #define set_iopl_mask(mask) (paravirt_ops.set_iopl_mask(mask))
 
+#define __pte(x)	paravirt_ops.make_pte(x)
+#define __pgd(x)	paravirt_ops.make_pgd(x)
+
+#define pte_val(x)	paravirt_ops.pte_val(x)
+#define pgd_val(x)	paravirt_ops.pgd_val(x)
+
+#ifdef CONFIG_X86_PAE
+#define __pmd(x)	paravirt_ops.make_pmd(x)
+#define pmd_val(x)	paravirt_ops.pmd_val(x)
+#endif
+
 /* The paravirtualized I/O functions */
 static inline void slow_down_io(void) {
 	paravirt_ops.io_delay();
@@ -344,6 +370,7 @@ static inline void setup_secondary_clock
 }
 #endif
 
+
 #ifdef CONFIG_SMP
 static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 				    unsigned long start_esp)
@@ -371,7 +398,8 @@ static inline void set_pte(pte_t *ptep, 
 	paravirt_ops.set_pte(ptep, pteval);
 }
 
-static inline void set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval)
+static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pteval)
 {
 	paravirt_ops.set_pte_at(mm, addr, ptep, pteval);
 }
diff -puN include/asm-i386/pgtable-2level.h~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/include/asm-i386/pgtable-2level.h
@@ -11,10 +11,23 @@
  * within a page table are directly modified.  Thus, the following
  * hook is made available.
  */
+static inline void native_set_pte(pte_t *ptep , pte_t pte)
+{
+	*ptep = pte;
+}
+static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
+				     pte_t *ptep , pte_t pte)
+{
+	native_set_pte(ptep, pte);
+}
+static inline void native_set_pmd(pmd_t *pmdp, pmd_t pmd)
+{
+	*pmdp = pmd;
+}
 #ifndef CONFIG_PARAVIRT
-#define set_pte(pteptr, pteval) (*(pteptr) = pteval)
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
-#define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
+#define set_pte(pteptr, pteval)		native_set_pte(pteptr, pteval)
+#define set_pte_at(mm,addr,ptep,pteval) native_set_pte_at(mm, addr, ptep, pteval)
+#define set_pmd(pmdptr, pmdval)		native_set_pmd(pmdptr, pmdval)
 #endif
 
 #define set_pte_atomic(pteptr, pteval) set_pte(pteptr,pteval)
@@ -23,11 +36,14 @@
 #define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 
-#define raw_ptep_get_and_clear(xp)	__pte(xchg(&(xp)->pte_low, 0))
+static inline pte_t native_ptep_get_and_clear(pte_t *xp)
+{
+	return __pte(xchg(&xp->pte_low, 0));
+}
 
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
 #define pte_none(x)		(!(x).pte_low)
-#define pte_pfn(x)		((unsigned long)(((x).pte_low >> PAGE_SHIFT)))
+#define pte_pfn(x)		(pte_val(x) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
diff -puN include/asm-i386/pgtable-3level.h~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries include/asm-i386/pgtable-3level.h
--- a/include/asm-i386/pgtable-3level.h~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/include/asm-i386/pgtable-3level.h
@@ -42,20 +42,23 @@ static inline int pte_exec_kernel(pte_t 
 	return pte_x(pte);
 }
 
-#ifndef CONFIG_PARAVIRT
 /* Rules for using set_pte: the pte being assigned *must* be
  * either not present or in a state where the hardware will
  * not attempt to update the pte.  In places where this is
  * not possible, use pte_get_and_clear to obtain the old pte
  * value and then use set_pte to update it.  -ben
  */
-static inline void set_pte(pte_t *ptep, pte_t pte)
+static inline void native_set_pte(pte_t *ptep, pte_t pte)
 {
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
 }
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
+static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
+				     pte_t *ptep , pte_t pte)
+{
+	native_set_pte(ptep, pte);
+}
 
 /*
  * Since this is only called on user PTEs, and the page fault handler
@@ -63,7 +66,8 @@ static inline void set_pte(pte_t *ptep, 
  * we are justified in merely clearing the PTE present bit, followed
  * by a set.  The ordering here is important.
  */
-static inline void set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
+static inline void native_set_pte_present(struct mm_struct *mm, unsigned long addr,
+					  pte_t *ptep, pte_t pte)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
@@ -72,32 +76,48 @@ static inline void set_pte_present(struc
 	ptep->pte_low = pte.pte_low;
 }
 
-#define set_pte_atomic(pteptr,pteval) \
-		set_64bit((unsigned long long *)(pteptr),pte_val(pteval))
-#define set_pmd(pmdptr,pmdval) \
-		set_64bit((unsigned long long *)(pmdptr),pmd_val(pmdval))
-#define set_pud(pudptr,pudval) \
-		(*(pudptr) = (pudval))
+static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
+{
+	set_64bit((unsigned long long *)(ptep),native_pte_val(pte));
+}
+static inline void native_set_pmd(pmd_t *pmdp, pmd_t pmd)
+{
+	set_64bit((unsigned long long *)(pmdp),native_pmd_val(pmd));
+}
+static inline void native_set_pud(pud_t *pudp, pud_t pud)
+{
+	*pudp = pud;
+}
 
 /*
  * For PTEs and PDEs, we must clear the P-bit first when clearing a page table
  * entry, so clear the bottom half first and enforce ordering with a compiler
  * barrier.
  */
-static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
 	ptep->pte_high = 0;
 }
 
-static inline void pmd_clear(pmd_t *pmd)
+static inline void native_pmd_clear(pmd_t *pmd)
 {
 	u32 *tmp = (u32 *)pmd;
 	*tmp = 0;
 	smp_wmb();
 	*(tmp + 1) = 0;
 }
+
+#ifndef CONFIG_PARAVIRT
+#define set_pte(ptep, pte)			native_set_pte(ptep, pte)
+#define set_pte_at(mm, addr, ptep, pte)		native_set_pte_at(mm, addr, ptep, pte)
+#define set_pte_present(mm, addr, ptep, pte)	native_set_pte_present(mm, addr, ptep, pte)
+#define set_pte_atomic(ptep, pte)		native_set_pte_atomic(ptep, pte)
+#define set_pmd(pmdp, pmd)			native_set_pmd(pmdp, pmd)
+#define set_pud(pudp, pud)			native_set_pud(pudp, pud)
+#define pte_clear(mm, addr, ptep)		native_pte_clear(mm, addr, ptep)
+#define pmd_clear(pmd)				native_pmd_clear(pmd)
 #endif
 
 /*
@@ -119,7 +139,7 @@ static inline void pud_clear (pud_t * pu
 #define pmd_offset(pud, address) ((pmd_t *) pud_page(*(pud)) + \
 			pmd_index(address))
 
-static inline pte_t raw_ptep_get_and_clear(pte_t *ptep)
+static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
 {
 	pte_t res;
 
@@ -146,28 +166,21 @@ static inline int pte_none(pte_t pte)
 
 static inline unsigned long pte_pfn(pte_t pte)
 {
-	return (pte.pte_low >> PAGE_SHIFT) |
-		(pte.pte_high << (32 - PAGE_SHIFT));
+	return pte_val(pte) >> PAGE_SHIFT;
 }
 
 extern unsigned long long __supported_pte_mask;
 
 static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
-	pte_t pte;
-
-	pte.pte_high = (page_nr >> (32 - PAGE_SHIFT)) | \
-					(pgprot_val(pgprot) >> 32);
-	pte.pte_high &= (__supported_pte_mask >> 32);
-	pte.pte_low = ((page_nr << PAGE_SHIFT) | pgprot_val(pgprot)) & \
-							__supported_pte_mask;
-	return pte;
+	return __pte((((unsigned long long)page_nr << PAGE_SHIFT) |
+		      pgprot_val(pgprot)) & __supported_pte_mask);
 }
 
 static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
 {
-	return __pmd((((unsigned long long)page_nr << PAGE_SHIFT) | \
-			pgprot_val(pgprot)) & __supported_pte_mask);
+	return __pmd((((unsigned long long)page_nr << PAGE_SHIFT) |
+		      pgprot_val(pgprot)) & __supported_pte_mask);
 }
 
 /*
diff -puN include/asm-i386/pgtable.h~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/include/asm-i386/pgtable.h
@@ -266,6 +266,8 @@ static inline pte_t pte_mkhuge(pte_t pte
 #define pte_update(mm, addr, ptep)		do { } while (0)
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
 #define paravirt_map_pt_hook(slot, va, pfn)	do { } while (0)
+
+#define raw_ptep_get_and_clear(xp)     native_ptep_get_and_clear(xp)
 #endif
 
 /*
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
x86-clean-up-identify_cpu-update.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
