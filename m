From: akpm@linux-foundation.org
Subject: - xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch removed from -mm tree
Date: Wed, 21 Feb 2007 18:35:57 -0800
Message-ID: <200702220235.l1M2Zvxc001967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34255 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbXBVChE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:37:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Xen-paravirt: add pagetable accessors to pack and unpack pagetable entries
has been removed from the -mm tree.  Its filename was
     xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Xen-paravirt: add pagetable accessors to pack and unpack pagetable entries
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add a set of accessors to pack, unpack and modify page table entries (at all
levels).  This allows a paravirt implementation to control the contents of
pgd/pmd/pte entries.  For example, Xen uses this to convert the
(pseudo-)physical address into a machine address when populating a pagetable
entry, and converting back to pphys address when an entry is read.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c       |  116 +++++++++++++++++++++++++---
 arch/i386/kernel/vmlinux.lds.S    |    3 
 include/asm-i386/page.h           |   16 +++
 include/asm-i386/paravirt.h       |   68 +++++++++++++++-
 include/asm-i386/pgtable-2level.h |    5 -
 include/asm-i386/pgtable-3level.h |   27 +++---
 6 files changed, 201 insertions(+), 34 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/arch/i386/kernel/paravirt.c
@@ -34,7 +34,7 @@
 #include <asm/tlbflush.h>
 
 /* nop stub */
-static void native_nop(void)
+void native_nop(void)
 {
 }
 
@@ -400,38 +400,76 @@ static void native_flush_tlb_single(u32 
 }
 
 #ifndef CONFIG_X86_PAE
-static void native_set_pte(pte_t *ptep, pte_t pteval)
+void native_set_pte(pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
 }
 
-static void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval)
+void native_set_pte_at(struct mm_struct *mm, u32 addr,
+		       pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
 }
 
-static void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
+void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	*pmdp = pmdval;
 }
 
+unsigned long native_pte_val(pte_t pte)
+{
+	return pte.pte_low;
+}
+
+unsigned long native_pmd_val(pmd_t pmd)
+{
+	BUG();
+	return 0;
+}
+
+unsigned long native_pgd_val(pgd_t pgd)
+{
+	return pgd.pgd;
+}
+
+pte_t native_make_pte(unsigned long pte)
+{
+	return (pte_t){ pte };
+}
+
+pmd_t native_make_pmd(unsigned long pmd)
+{
+	BUG();
+}
+
+pgd_t native_make_pgd(unsigned long pgd)
+{
+	return (pgd_t){ pgd };
+}
+
+pte_t native_ptep_get_and_clear(pte_t *ptep)
+{
+	return __pte(xchg(&(ptep)->pte_low, 0));
+}
+
 #else /* CONFIG_X86_PAE */
 
-static void native_set_pte(pte_t *ptep, pte_t pte)
+void native_set_pte(pte_t *ptep, pte_t pte)
 {
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
 }
 
-static void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
+void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
 {
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
 }
 
-static void native_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
+void native_set_pte_present(struct mm_struct *mm, u32 addr,
+			    pte_t *ptep, pte_t pte)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
@@ -440,35 +478,78 @@ static void native_set_pte_present(struc
 	ptep->pte_low = pte.pte_low;
 }
 
-static void native_set_pte_atomic(pte_t *ptep, pte_t pteval)
+void native_set_pte_atomic(pte_t *ptep, pte_t pteval)
 {
 	set_64bit((unsigned long long *)ptep,pte_val(pteval));
 }
 
-static void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
+void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	set_64bit((unsigned long long *)pmdp,pmd_val(pmdval));
 }
 
-static void native_set_pud(pud_t *pudp, pud_t pudval)
+void native_set_pud(pud_t *pudp, pud_t pudval)
 {
 	*pudp = pudval;
 }
 
-static void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+void native_pte_clear(struct mm_struct *mm, u32 addr, pte_t *ptep)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
 	ptep->pte_high = 0;
 }
 
-static void native_pmd_clear(pmd_t *pmd)
+void native_pmd_clear(pmd_t *pmd)
 {
 	u32 *tmp = (u32 *)pmd;
 	*tmp = 0;
 	smp_wmb();
 	*(tmp + 1) = 0;
 }
+
+unsigned long long native_pte_val(pte_t pte)
+{
+	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
+}
+
+unsigned long long native_pmd_val(pmd_t pmd)
+{
+	return pmd.pmd;
+}
+
+unsigned long long native_pgd_val(pgd_t pgd)
+{
+	return pgd.pgd;
+}
+
+pte_t native_make_pte(unsigned long long pte)
+{
+	return (pte_t){ pte };
+}
+
+pmd_t native_make_pmd(unsigned long long pmd)
+{
+	return (pmd_t){ pmd };
+}
+
+pgd_t native_make_pgd(unsigned long long pgd)
+{
+	return (pgd_t){ pgd };
+}
+
+pte_t native_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res;
+
+	/* xchg acts as a barrier before the setting of the high bits */
+	res.pte_low = xchg(&ptep->pte_low, 0);
+	res.pte_high = ptep->pte_high;
+	ptep->pte_high = 0;
+
+	return res;
+}
+
 #endif /* CONFIG_X86_PAE */
 
 /* These are in entry.S */
@@ -561,6 +642,9 @@ struct paravirt_ops paravirt_ops = {
 	.set_pmd = native_set_pmd,
 	.pte_update = (void *)native_nop,
 	.pte_update_defer = (void *)native_nop,
+
+	.ptep_get_and_clear = native_ptep_get_and_clear,
+
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
 	.set_pte_present = native_set_pte_present,
@@ -569,6 +653,14 @@ struct paravirt_ops paravirt_ops = {
 	.pmd_clear = native_pmd_clear,
 #endif
 
+	.pte_val = native_pte_val,
+	.pmd_val = native_pmd_val,
+	.pgd_val = native_pgd_val,
+
+	.make_pte = native_make_pte,
+	.make_pmd = native_make_pmd,
+	.make_pgd = native_make_pgd,
+
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
diff -puN arch/i386/kernel/vmlinux.lds.S~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -22,6 +22,9 @@
 #include <asm/cache.h>
 #include <asm/boot.h>
 
+#undef ENTRY
+#undef ALIGN
+
 OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
diff -puN include/asm-i386/page.h~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries include/asm-i386/page.h
--- a/include/asm-i386/page.h~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/include/asm-i386/page.h
@@ -12,7 +12,6 @@
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-
 #ifdef CONFIG_X86_USE_3DNOW
 
 #include <asm/mmx.h>
@@ -48,9 +47,11 @@ typedef struct { unsigned long pte_low, 
 typedef struct { unsigned long long pmd; } pmd_t;
 typedef struct { unsigned long long pgd; } pgd_t;
 typedef struct { unsigned long long pgprot; } pgprot_t;
+#ifndef CONFIG_PARAVIRT
 #define pmd_val(x)	((x).pmd)
 #define pte_val(x)	((x).pte_low | ((unsigned long long)(x).pte_high << 32))
 #define __pmd(x) ((pmd_t) { (x) } )
+#endif	/* CONFIG_PARAVIRT */
 #define HPAGE_SHIFT	21
 #include <asm-generic/pgtable-nopud.h>
 #else
@@ -58,7 +59,9 @@ typedef struct { unsigned long pte_low; 
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
 #define boot_pte_t pte_t /* or would you rather have a typedef */
+#ifndef CONFIG_PARAVIRT
 #define pte_val(x)	((x).pte_low)
+#endif
 #define HPAGE_SHIFT	22
 #include <asm-generic/pgtable-nopmd.h>
 #endif
@@ -71,12 +74,14 @@ typedef struct { unsigned long pgprot; }
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 #endif
 
-#define pgd_val(x)	((x).pgd)
 #define pgprot_val(x)	((x).pgprot)
+#define __pgprot(x)	((pgprot_t) { (x) } )
 
+#ifndef CONFIG_PARAVIRT
+#define pgd_val(x)	((x).pgd)
 #define __pte(x) ((pte_t) { (x) } )
 #define __pgd(x) ((pgd_t) { (x) } )
-#define __pgprot(x)	((pgprot_t) { (x) } )
+#endif
 
 #endif /* !__ASSEMBLY__ */
 
@@ -143,6 +148,11 @@ extern int page_is_ram(unsigned long pag
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
+#ifdef CONFIG_PARAVIRT
+/* After pte_t, etc, have been defined */
+#include <asm/paravirt.h>
+#endif
+
 #ifndef CONFIG_COMPAT_VDSO
 #define __HAVE_ARCH_GATE_AREA 1
 #endif
diff -puN include/asm-i386/paravirt.h~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/include/asm-i386/paravirt.h
@@ -25,6 +25,8 @@
 #define CLBR_ANY 0x7
 
 #ifndef __ASSEMBLY__
+#include <linux/types.h>
+
 struct thread_struct;
 struct Xgt_desc_struct;
 struct tss_struct;
@@ -140,12 +142,31 @@ struct paravirt_ops
 	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
 	void (*pte_update)(struct mm_struct *mm, u32 addr, pte_t *ptep);
 	void (*pte_update_defer)(struct mm_struct *mm, u32 addr, pte_t *ptep);
+
+ 	pte_t (*ptep_get_and_clear)(pte_t *ptep);
+
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
-	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte);
+ 	void (*set_pte_present)(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte);
 	void (*set_pud)(pud_t *pudp, pud_t pudval);
-	void (*pte_clear)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+ 	void (*pte_clear)(struct mm_struct *mm, u32 addr, pte_t *ptep);
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
+	unsigned long (*pmd_val)(pmd_t);
+	unsigned long (*pgd_val)(pgd_t);
+
+	pte_t (*make_pte)(unsigned long pte);
+	pmd_t (*make_pmd)(unsigned long pmd);
+	pgd_t (*make_pgd)(unsigned long pgd);
 #endif
 
 	void (*set_lazy_mode)(int mode);
@@ -164,6 +185,24 @@ struct paravirt_ops
 
 extern struct paravirt_ops paravirt_ops;
 
+#ifdef CONFIG_X86_PAE
+unsigned long long native_pte_val(pte_t);
+unsigned long long native_pmd_val(pmd_t);
+unsigned long long native_pgd_val(pgd_t);
+
+pte_t native_make_pte(unsigned long long pte);
+pmd_t native_make_pmd(unsigned long long pmd);
+pgd_t native_make_pgd(unsigned long long pgd);
+#else
+unsigned long native_pte_val(pte_t);
+unsigned long native_pmd_val(pmd_t);
+unsigned long native_pgd_val(pgd_t);
+
+pte_t native_make_pte(unsigned long pte);
+pmd_t native_make_pmd(unsigned long pmd);
+pgd_t native_make_pgd(unsigned long pgd);
+#endif
+
 #define paravirt_enabled() (paravirt_ops.paravirt_enabled)
 
 static inline void load_esp0(struct tss_struct *tss,
@@ -216,6 +255,8 @@ static inline void __cpuid(unsigned int 
 #define read_cr4_safe(x) paravirt_ops.read_cr4_safe()
 #define write_cr4(x) paravirt_ops.write_cr4(x)
 
+#define raw_ptep_get_and_clear(xp)	(paravirt_ops.ptep_get_and_clear(xp))
+
 static inline void raw_safe_halt(void)
 {
 	paravirt_ops.safe_halt();
@@ -297,6 +338,17 @@ static inline void halt(void)
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
@@ -337,6 +389,18 @@ static inline void setup_secondary_clock
 }
 #endif
 
+
+void native_set_pte(pte_t *ptep, pte_t pteval);
+void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval);
+void native_set_pmd(pmd_t *pmdp, pmd_t pmdval);
+void native_set_pte_present(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte);
+void native_set_pte_atomic(pte_t *ptep, pte_t pteval);
+void native_set_pud(pud_t *pudp, pud_t pudval);
+void native_pte_clear(struct mm_struct *mm, u32 addr, pte_t *ptep);
+void native_pmd_clear(pmd_t *pmd);
+pte_t native_ptep_get_and_clear(pte_t *ptep);
+void native_nop(void);
+
 #ifdef CONFIG_SMP
 static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 				    unsigned long start_esp)
diff -puN include/asm-i386/pgtable-2level.h~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/include/asm-i386/pgtable-2level.h
@@ -15,6 +15,7 @@
 #define set_pte(pteptr, pteval) (*(pteptr) = pteval)
 #define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 #define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
+#define raw_ptep_get_and_clear(xp)	__pte(xchg(&(xp)->pte_low, 0))
 #endif
 
 #define set_pte_atomic(pteptr, pteval) set_pte(pteptr,pteval)
@@ -23,11 +24,9 @@
 #define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 
-#define raw_ptep_get_and_clear(xp)	__pte(xchg(&(xp)->pte_low, 0))
-
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
 #define pte_none(x)		(!(x).pte_low)
-#define pte_pfn(x)		((unsigned long)(((x).pte_low >> PAGE_SHIFT)))
+#define pte_pfn(x)		(pte_val(x) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
diff -puN include/asm-i386/pgtable-3level.h~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries include/asm-i386/pgtable-3level.h
--- a/include/asm-i386/pgtable-3level.h~xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries
+++ a/include/asm-i386/pgtable-3level.h
@@ -98,6 +98,18 @@ static inline void pmd_clear(pmd_t *pmd)
 	smp_wmb();
 	*(tmp + 1) = 0;
 }
+
+static inline pte_t raw_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res;
+
+	/* xchg acts as a barrier before the setting of the high bits */
+	res.pte_low = xchg(&ptep->pte_low, 0);
+	res.pte_high = ptep->pte_high;
+	ptep->pte_high = 0;
+
+	return res;
+}
 #endif
 
 /*
@@ -119,18 +131,6 @@ static inline void pud_clear (pud_t * pu
 #define pmd_offset(pud, address) ((pmd_t *) pud_page(*(pud)) + \
 			pmd_index(address))
 
-static inline pte_t raw_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res;
-
-	/* xchg acts as a barrier before the setting of the high bits */
-	res.pte_low = xchg(&ptep->pte_low, 0);
-	res.pte_high = ptep->pte_high;
-	ptep->pte_high = 0;
-
-	return res;
-}
-
 #define __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t a, pte_t b)
 {
@@ -146,8 +146,7 @@ static inline int pte_none(pte_t pte)
 
 static inline unsigned long pte_pfn(pte_t pte)
 {
-	return (pte.pte_low >> PAGE_SHIFT) |
-		(pte.pte_high << (32 - PAGE_SHIFT));
+	return pte_val(pte) >> PAGE_SHIFT;
 }
 
 extern unsigned long long __supported_pte_mask;
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt-remove-ctor-for-pgd-cache.patch
xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch
xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt-allocate-and-free-vmalloc-areas.patch
xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
xen-paravirt-add-xen-interface-header-files.patch
xen-paravirt-core-xen-implementation.patch
xen-paravirt-core-xen-implementation-fix.patch
xen-paravirt-add-the-xen-virtual-console-driver.patch
xen-paravirt-add-xen-grant-table-support.patch
xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt-add-xen-virtual-block-device-driver.patch
xen-paravirt-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
