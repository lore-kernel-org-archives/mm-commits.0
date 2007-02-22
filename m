From: akpm@linux-foundation.org
Subject: - xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch removed from -mm tree
Date: Wed, 21 Feb 2007 18:36:09 -0800
Message-ID: <200702220236.l1M2a9wA001991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34259 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbXBVChG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:37:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Xen-paravirt: allow paravirt backend to choose kernel PMD sharing
has been removed from the -mm tree.  Its filename was
     xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Xen-paravirt: allow paravirt backend to choose kernel PMD sharing
From: Jeremy Fitzhardinge <jeremy@goop.org>

Xen does not allow guests to have the kernel pmd shared between page tables,
so parameterize pgtable.c to allow both modes of operation.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c            |    1 
 arch/i386/mm/fault.c                   |    6 +-
 arch/i386/mm/pageattr.c                |    2 
 arch/i386/mm/pgtable.c                 |   57 ++++++++++++++---------
 include/asm-i386/page.h                |    7 +-
 include/asm-i386/paravirt.h            |    1 
 include/asm-i386/pgtable-2level-defs.h |    2 
 include/asm-i386/pgtable-2level.h      |    2 
 include/asm-i386/pgtable-3level-defs.h |    6 ++
 include/asm-i386/pgtable-3level.h      |   16 +-----
 include/asm-i386/pgtable.h             |    7 ++
 11 files changed, 66 insertions(+), 41 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/arch/i386/kernel/paravirt.c
@@ -604,6 +604,7 @@ struct paravirt_ops paravirt_ops = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
 	.kernel_rpl = 0,
+	.shared_kernel_pmd = 1,	/* Only used when CONFIG_X86_PAE is set */
 
  	.patch = native_patch,
 	.banner = default_banner,
diff -puN arch/i386/mm/fault.c~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/arch/i386/mm/fault.c
@@ -602,8 +602,7 @@ do_sigbus:
 	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
 }
 
-#ifndef CONFIG_X86_PAE
-void vmalloc_sync_all(void)
+void _vmalloc_sync_all(void)
 {
 	/*
 	 * Note that races in the updates of insync and start aren't
@@ -615,6 +614,8 @@ void vmalloc_sync_all(void)
 	static unsigned long start = TASK_SIZE;
 	unsigned long address;
 
+	BUG_ON(SHARED_KERNEL_PMD);
+
 	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
 	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
 		if (!test_bit(pgd_index(address), insync)) {
@@ -637,4 +638,3 @@ void vmalloc_sync_all(void)
 			start = address + PGDIR_SIZE;
 	}
 }
-#endif
diff -puN arch/i386/mm/pageattr.c~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing arch/i386/mm/pageattr.c
--- a/arch/i386/mm/pageattr.c~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/arch/i386/mm/pageattr.c
@@ -91,7 +91,7 @@ static void set_pmd_pte(pte_t *kpte, uns
 	unsigned long flags;
 
 	set_pte_atomic(kpte, pte); 	/* change init_mm */
-	if (PTRS_PER_PMD > 1)
+	if (SHARED_KERNEL_PMD)
 		return;
 
 	spin_lock_irqsave(&pgd_lock, flags);
diff -puN arch/i386/mm/pgtable.c~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/arch/i386/mm/pgtable.c
@@ -243,31 +243,42 @@ static void pgd_ctor(pgd_t *pgd)
 	unsigned long flags;
 
 	if (PTRS_PER_PMD == 1) {
+		/* !PAE, no pagetable sharing */
 		memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
-		spin_lock_irqsave(&pgd_lock, flags);
-	}
-
-	clone_pgd_range(pgd + USER_PTRS_PER_PGD,
-			swapper_pg_dir + USER_PTRS_PER_PGD,
-			KERNEL_PGD_PTRS);
 
-	if (PTRS_PER_PMD > 1)
-		return;
+		clone_pgd_range(pgd + USER_PTRS_PER_PGD,
+				swapper_pg_dir + USER_PTRS_PER_PGD,
+				KERNEL_PGD_PTRS);
 
-	/* must happen under lock */
-	paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
-			__pa(swapper_pg_dir) >> PAGE_SHIFT,
-			USER_PTRS_PER_PGD, PTRS_PER_PGD - USER_PTRS_PER_PGD);
+		spin_lock_irqsave(&pgd_lock, flags);
 
-	pgd_list_add(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+		/* must happen under lock */
+		paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
+					__pa(swapper_pg_dir) >> PAGE_SHIFT,
+					USER_PTRS_PER_PGD,
+					PTRS_PER_PGD - USER_PTRS_PER_PGD);
+
+		pgd_list_add(pgd);
+		spin_unlock_irqrestore(&pgd_lock, flags);
+	} else {
+		/* PAE, PMD may be shared */
+		if (SHARED_KERNEL_PMD) {
+			clone_pgd_range((pgd_t *)pgd + USER_PTRS_PER_PGD,
+					swapper_pg_dir + USER_PTRS_PER_PGD,
+					KERNEL_PGD_PTRS);
+		} else {
+			spin_lock_irqsave(&pgd_lock, flags);
+			pgd_list_add(pgd);
+			spin_unlock_irqrestore(&pgd_lock, flags);
+		}
+	}
 }
 
 static void pgd_dtor(pgd_t *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
 
-	if (PTRS_PER_PMD == 1)
+	if (SHARED_KERNEL_PMD)
 		return;
 
 	paravirt_release_pd(__pa(pgd) >> PAGE_SHIFT);
@@ -281,19 +292,25 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	int i;
 	pgd_t *pgd = kmem_cache_alloc(pgd_cache, GFP_KERNEL);
 
-	if (pgd)
+	if (likely(pgd))
 		pgd_ctor(pgd);
 
-	if (PTRS_PER_PMD == 1 || !pgd)
+	if (PTRS_PER_PMD == 1 || unlikely(!pgd))
 		return pgd;
 
-	for (i = 0; i < USER_PTRS_PER_PGD; ++i) {
+	for (i = 0; i < (SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD); ++i) {
 		pmd_t *pmd = kmem_cache_alloc(pmd_cache, GFP_KERNEL);
-		if (!pmd)
+		if (unlikely(!pmd))
 			goto out_oom;
+
+		if (i >= USER_PTRS_PER_PGD)
+			memcpy(pmd, (void *)pgd_page_vaddr(swapper_pg_dir[i]),
+			       sizeof(pmd_t) * PTRS_PER_PMD);
+
 		paravirt_alloc_pd(__pa(pmd) >> PAGE_SHIFT);
 		set_pgd(&pgd[i], __pgd(1 + __pa(pmd)));
 	}
+
 	return pgd;
 
 out_oom:
@@ -314,7 +331,7 @@ void pgd_free(pgd_t *pgd)
 
 	/* in the PAE case user pgd entries are overwritten before usage */
 	if (PTRS_PER_PMD > 1)
-		for (i = 0; i < USER_PTRS_PER_PGD; ++i) {
+		for (i = 0; i < (SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD); ++i) {
 			pgd_t pgdent = pgd[i];
 			void* pmd = (void *)__va(pgd_val(pgdent)-1);
 			paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
diff -puN include/asm-i386/page.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/page.h
--- a/include/asm-i386/page.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/page.h
@@ -50,21 +50,23 @@ typedef struct { unsigned long long pgpr
 #ifndef CONFIG_PARAVIRT
 #define pmd_val(x)	((x).pmd)
 #define pte_val(x)	((x).pte_low | ((unsigned long long)(x).pte_high << 32))
+#define __pte(x) ((pte_t) { .pte_low = (x), .pte_high = ((x) >> 32) } )
 #define __pmd(x) ((pmd_t) { (x) } )
 #endif	/* CONFIG_PARAVIRT */
 #define HPAGE_SHIFT	21
 #include <asm-generic/pgtable-nopud.h>
-#else
+#else  /* !CONFIG_X86_PAE */
 typedef struct { unsigned long pte_low; } pte_t;
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
 #define boot_pte_t pte_t /* or would you rather have a typedef */
 #ifndef CONFIG_PARAVIRT
+#define __pte(x) ((pte_t) { (x) })
 #define pte_val(x)	((x).pte_low)
 #endif
 #define HPAGE_SHIFT	22
 #include <asm-generic/pgtable-nopmd.h>
-#endif
+#endif	/* CONFIG_X86_PAE */
 #define PTE_MASK	PAGE_MASK
 
 #ifdef CONFIG_HUGETLB_PAGE
@@ -79,7 +81,6 @@ typedef struct { unsigned long pgprot; }
 
 #ifndef CONFIG_PARAVIRT
 #define pgd_val(x)	((x).pgd)
-#define __pte(x) ((pte_t) { (x) } )
 #define __pgd(x) ((pgd_t) { (x) } )
 #endif
 
diff -puN include/asm-i386/paravirt.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/paravirt.h
@@ -34,6 +34,7 @@ struct mm_struct;
 struct paravirt_ops
 {
 	unsigned int kernel_rpl;
+	int shared_kernel_pmd;
  	int paravirt_enabled;
 	const char *name;
 
diff -puN include/asm-i386/pgtable-2level-defs.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/pgtable-2level-defs.h
--- a/include/asm-i386/pgtable-2level-defs.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/pgtable-2level-defs.h
@@ -1,6 +1,8 @@
 #ifndef _I386_PGTABLE_2LEVEL_DEFS_H
 #define _I386_PGTABLE_2LEVEL_DEFS_H
 
+#define SHARED_KERNEL_PMD	0
+
 /*
  * traditional i386 two-level paging structure:
  */
diff -puN include/asm-i386/pgtable-2level.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/pgtable-2level.h
@@ -65,6 +65,4 @@ static inline int pte_exec_kernel(pte_t 
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_low })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-void vmalloc_sync_all(void);
-
 #endif /* _I386_PGTABLE_2LEVEL_H */
diff -puN include/asm-i386/pgtable-3level-defs.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/pgtable-3level-defs.h
--- a/include/asm-i386/pgtable-3level-defs.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/pgtable-3level-defs.h
@@ -1,6 +1,12 @@
 #ifndef _I386_PGTABLE_3LEVEL_DEFS_H
 #define _I386_PGTABLE_3LEVEL_DEFS_H
 
+#ifdef CONFIG_PARAVIRT
+#define SHARED_KERNEL_PMD	(paravirt_ops.shared_kernel_pmd)
+#else
+#define SHARED_KERNEL_PMD	1
+#endif
+
 /*
  * PGDIR_SHIFT determines what a top-level page table entry can map
  */
diff -puN include/asm-i386/pgtable-3level.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/pgtable-3level.h
--- a/include/asm-i386/pgtable-3level.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/pgtable-3level.h
@@ -153,20 +153,14 @@ extern unsigned long long __supported_pt
 
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
@@ -186,6 +180,4 @@ static inline pmd_t pfn_pmd(unsigned lon
 
 #define __pmd_free_tlb(tlb, x)		do { } while (0)
 
-#define vmalloc_sync_all() ((void)0)
-
 #endif /* _I386_PGTABLE_3LEVEL_H */
diff -puN include/asm-i386/pgtable.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/pgtable.h
@@ -242,6 +242,13 @@ static inline pte_t pte_mkyoung(pte_t pt
 static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte_low |= _PAGE_RW; return pte; }
 static inline pte_t pte_mkhuge(pte_t pte)	{ (pte).pte_low |= _PAGE_PSE; return pte; }
 
+extern void _vmalloc_sync_all(void);
+static inline void vmalloc_sync_all(void)
+{
+	if (!SHARED_KERNEL_PMD)
+		_vmalloc_sync_all();
+}
+
 #ifdef CONFIG_X86_PAE
 # include <asm/pgtable-3level.h>
 #else
_

Patches currently in -mm which might be from jeremy@goop.org are

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
