From: akpm@linux-foundation.org
Subject: - paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:07 -0700
Message-ID: <200704132330.l3DNU7vN012710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60622 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030893AbXDMXaX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, clameter@sgi.com, jeremy@xensource.com, mingo@elte.hu, wli@holomorphy.com, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: Allow paravirt backend to choose kernel PMD sharing
has been removed from the -mm tree.  Its filename was
     paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt_ops: Allow paravirt backend to choose kernel PMD sharing
From: Jeremy Fitzhardinge <jeremy@goop.org>

Normally when running in PAE mode, the 4th PMD maps the kernel address space,
which can be shared among all processes (since they all need the same kernel
mappings).

Xen, however, does not allow guests to have the kernel pmd shared between page
tables, so parameterize pgtable.c to allow both modes of operation.

There are several side-effects of this.  One is that vmalloc will update the
kernel address space mappings, and those updates need to be propagated into
all processes if the kernel mappings are not intrinsically shared.  In the
non-PAE case, this is done by maintaining a pgd_list of all processes; this
list is used when all process pagetables must be updated.  pgd_list is
threaded via otherwise unused entries in the page structure for the pgd, which
means that the pgd must be page-sized for this to work.

Normally the PAE pgd is only 4x64 byte entries large, but Xen requires the PAE
pgd to page aligned anyway, so this patch forces the pgd to be page
aligned+sized when the kernel pmd is unshared, to accomodate both these
requirements.

Also, since there may be several distinct kernel pmds (if the user/kernel
split is below 3G), there's no point in allocating them from a slab cache;
they're just allocated with get_free_page and initialized appropriately.  (Of
course the could be cached if there is just a single kernel pmd - which is the
default with a 3G user/kernel split - but it doesn't seem worthwhile to add
yet another case into this code).

[ Many thanks to wli for review comments. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: William Lee Irwin III <wli@holomorphy.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Christoph Lameter <clameter@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c            |    1 
 arch/i386/mm/fault.c                   |    5 -
 arch/i386/mm/init.c                    |   18 ++++-
 arch/i386/mm/pageattr.c                |    2 
 arch/i386/mm/pgtable.c                 |   82 +++++++++++++++++++----
 include/asm-i386/paravirt.h            |    1 
 include/asm-i386/pgtable-2level-defs.h |    2 
 include/asm-i386/pgtable-2level.h      |    2 
 include/asm-i386/pgtable-3level-defs.h |    6 +
 include/asm-i386/pgtable-3level.h      |    2 
 include/asm-i386/pgtable.h             |    2 
 11 files changed, 99 insertions(+), 24 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/arch/i386/kernel/paravirt.c
@@ -132,6 +132,7 @@ struct paravirt_ops paravirt_ops = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
 	.kernel_rpl = 0,
+	.shared_kernel_pmd = 1,	/* Only used when CONFIG_X86_PAE is set */
 
  	.patch = native_patch,
 	.banner = default_banner,
diff -puN arch/i386/mm/fault.c~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/arch/i386/mm/fault.c
@@ -603,7 +603,6 @@ do_sigbus:
 	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
 }
 
-#ifndef CONFIG_X86_PAE
 void vmalloc_sync_all(void)
 {
 	/*
@@ -616,6 +615,9 @@ void vmalloc_sync_all(void)
 	static unsigned long start = TASK_SIZE;
 	unsigned long address;
 
+	if (SHARED_KERNEL_PMD)
+		return;
+
 	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
 	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
 		if (!test_bit(pgd_index(address), insync)) {
@@ -638,4 +640,3 @@ void vmalloc_sync_all(void)
 			start = address + PGDIR_SIZE;
 	}
 }
-#endif
diff -puN arch/i386/mm/init.c~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/arch/i386/mm/init.c
@@ -757,6 +757,8 @@ struct kmem_cache *pmd_cache;
 
 void __init pgtable_cache_init(void)
 {
+	size_t pgd_size = PTRS_PER_PGD*sizeof(pgd_t);
+
 	if (PTRS_PER_PMD > 1) {
 		pmd_cache = kmem_cache_create("pmd",
 					PTRS_PER_PMD*sizeof(pmd_t),
@@ -766,13 +768,23 @@ void __init pgtable_cache_init(void)
 					NULL);
 		if (!pmd_cache)
 			panic("pgtable_cache_init(): cannot create pmd cache");
+
+		if (!SHARED_KERNEL_PMD) {
+			/* If we're in PAE mode and have a non-shared
+			   kernel pmd, then the pgd size must be a
+			   page size.  This is because the pgd_list
+			   links through the page structure, so there
+			   can only be one pgd per page for this to
+			   work. */
+			pgd_size = PAGE_SIZE;
+		}
 	}
 	pgd_cache = kmem_cache_create("pgd",
-				PTRS_PER_PGD*sizeof(pgd_t),
-				PTRS_PER_PGD*sizeof(pgd_t),
+				pgd_size,
+				pgd_size,
 				0,
 				pgd_ctor,
-				PTRS_PER_PMD == 1 ? pgd_dtor : NULL);
+				(!SHARED_KERNEL_PMD) ? pgd_dtor : NULL);
 	if (!pgd_cache)
 		panic("pgtable_cache_init(): Cannot create pgd cache");
 }
diff -puN arch/i386/mm/pageattr.c~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing arch/i386/mm/pageattr.c
--- a/arch/i386/mm/pageattr.c~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/arch/i386/mm/pageattr.c
@@ -91,7 +91,7 @@ static void set_pmd_pte(pte_t *kpte, uns
 	unsigned long flags;
 
 	set_pte_atomic(kpte, pte); 	/* change init_mm */
-	if (PTRS_PER_PMD > 1)
+	if (SHARED_KERNEL_PMD)
 		return;
 
 	spin_lock_irqsave(&pgd_lock, flags);
diff -puN arch/i386/mm/pgtable.c~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/arch/i386/mm/pgtable.c
@@ -238,42 +238,94 @@ static inline void pgd_list_del(pgd_t *p
 		set_page_private(next, (unsigned long)pprev);
 }
 
+#if (PTRS_PER_PMD == 1)
+/* Non-PAE pgd constructor */
 void pgd_ctor(void *pgd, struct kmem_cache *cache, unsigned long unused)
 {
 	unsigned long flags;
 
-	if (PTRS_PER_PMD == 1) {
-		memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
-		spin_lock_irqsave(&pgd_lock, flags);
-	}
+	/* !PAE, no pagetable sharing */
+	memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
 
 	clone_pgd_range((pgd_t *)pgd + USER_PTRS_PER_PGD,
 			swapper_pg_dir + USER_PTRS_PER_PGD,
 			KERNEL_PGD_PTRS);
 
-	if (PTRS_PER_PMD > 1)
-		return;
+	spin_lock_irqsave(&pgd_lock, flags);
 
 	/* must happen under lock */
 	paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
-			__pa(swapper_pg_dir) >> PAGE_SHIFT,
-			USER_PTRS_PER_PGD, PTRS_PER_PGD - USER_PTRS_PER_PGD);
+				__pa(swapper_pg_dir) >> PAGE_SHIFT,
+				USER_PTRS_PER_PGD,
+				KERNEL_PGD_PTRS);
 
 	pgd_list_add(pgd);
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
+#else  /* PTRS_PER_PMD > 1 */
+/* PAE pgd constructor */
+void pgd_ctor(void *pgd, struct kmem_cache *cache, unsigned long unused)
+{
+	/* PAE, kernel PMD may be shared */
+
+	if (SHARED_KERNEL_PMD) {
+		clone_pgd_range((pgd_t *)pgd + USER_PTRS_PER_PGD,
+				swapper_pg_dir + USER_PTRS_PER_PGD,
+				KERNEL_PGD_PTRS);
+	} else {
+		unsigned long flags;
+
+		memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
+		spin_lock_irqsave(&pgd_lock, flags);
+		pgd_list_add(pgd);
+		spin_unlock_irqrestore(&pgd_lock, flags);
+	}
+}
+#endif	/* PTRS_PER_PMD */
 
-/* never called when PTRS_PER_PMD > 1 */
 void pgd_dtor(void *pgd, struct kmem_cache *cache, unsigned long unused)
 {
 	unsigned long flags; /* can be called from interrupt context */
 
+	BUG_ON(SHARED_KERNEL_PMD);
+
 	paravirt_release_pd(__pa(pgd) >> PAGE_SHIFT);
 	spin_lock_irqsave(&pgd_lock, flags);
 	pgd_list_del(pgd);
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
+#define UNSHARED_PTRS_PER_PGD				\
+	(SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD)
+
+/* If we allocate a pmd for part of the kernel address space, then
+   make sure its initialized with the appropriate kernel mappings.
+   Otherwise use a cached zeroed pmd.  */
+static pmd_t *pmd_cache_alloc(int idx)
+{
+	pmd_t *pmd;
+
+	if (idx >= USER_PTRS_PER_PGD) {
+		pmd = (pmd_t *)__get_free_page(GFP_KERNEL);
+
+		if (pmd)
+			memcpy(pmd,
+			       (void *)pgd_page_vaddr(swapper_pg_dir[idx]),
+			       sizeof(pmd_t) * PTRS_PER_PMD);
+	} else
+		pmd = kmem_cache_alloc(pmd_cache, GFP_KERNEL);
+
+	return pmd;
+}
+
+static void pmd_cache_free(pmd_t *pmd, int idx)
+{
+	if (idx >= USER_PTRS_PER_PGD)
+		free_page((unsigned long)pmd);
+	else
+		kmem_cache_free(pmd_cache, pmd);
+}
+
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	int i;
@@ -282,10 +334,12 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	if (PTRS_PER_PMD == 1 || !pgd)
 		return pgd;
 
-	for (i = 0; i < USER_PTRS_PER_PGD; ++i) {
-		pmd_t *pmd = kmem_cache_alloc(pmd_cache, GFP_KERNEL);
+ 	for (i = 0; i < UNSHARED_PTRS_PER_PGD; ++i) {
+		pmd_t *pmd = pmd_cache_alloc(i);
+
 		if (!pmd)
 			goto out_oom;
+
 		paravirt_alloc_pd(__pa(pmd) >> PAGE_SHIFT);
 		set_pgd(&pgd[i], __pgd(1 + __pa(pmd)));
 	}
@@ -296,7 +350,7 @@ out_oom:
 		pgd_t pgdent = pgd[i];
 		void* pmd = (void *)__va(pgd_val(pgdent)-1);
 		paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-		kmem_cache_free(pmd_cache, pmd);
+		pmd_cache_free(pmd, i);
 	}
 	kmem_cache_free(pgd_cache, pgd);
 	return NULL;
@@ -308,11 +362,11 @@ void pgd_free(pgd_t *pgd)
 
 	/* in the PAE case user pgd entries are overwritten before usage */
 	if (PTRS_PER_PMD > 1)
-		for (i = 0; i < USER_PTRS_PER_PGD; ++i) {
+		for (i = 0; i < UNSHARED_PTRS_PER_PGD; ++i) {
 			pgd_t pgdent = pgd[i];
 			void* pmd = (void *)__va(pgd_val(pgdent)-1);
 			paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-			kmem_cache_free(pmd_cache, pmd);
+			pmd_cache_free(pmd, i);
 		}
 	/* in the non-PAE case, free_pgtables() clears user pgd entries */
 	kmem_cache_free(pgd_cache, pgd);
diff -puN include/asm-i386/paravirt.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/paravirt.h
@@ -35,6 +35,7 @@ struct desc_struct;
 struct paravirt_ops
 {
 	unsigned int kernel_rpl;
+	int shared_kernel_pmd;
  	int paravirt_enabled;
 	const char *name;
 
diff -puN include/asm-i386/pgtable-2level-defs.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/pgtable-2level-defs.h
--- a/include/asm-i386/pgtable-2level-defs.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/pgtable-2level-defs.h
@@ -1,6 +1,8 @@
 #ifndef _I386_PGTABLE_2LEVEL_DEFS_H
 #define _I386_PGTABLE_2LEVEL_DEFS_H
 
+#define SHARED_KERNEL_PMD	0
+
 /*
  * traditional i386 two-level paging structure:
  */
diff -puN include/asm-i386/pgtable-2level.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/pgtable-2level.h
@@ -82,6 +82,4 @@ static inline int pte_exec_kernel(pte_t 
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_low })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-void vmalloc_sync_all(void);
-
 #endif /* _I386_PGTABLE_2LEVEL_H */
diff -puN include/asm-i386/pgtable-3level-defs.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/pgtable-3level-defs.h
--- a/include/asm-i386/pgtable-3level-defs.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing
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
diff -puN include/asm-i386/pgtable-3level.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/pgtable-3level.h
--- a/include/asm-i386/pgtable-3level.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/pgtable-3level.h
@@ -200,6 +200,4 @@ static inline pmd_t pfn_pmd(unsigned lon
 
 #define __pmd_free_tlb(tlb, x)		do { } while (0)
 
-#define vmalloc_sync_all() ((void)0)
-
 #endif /* _I386_PGTABLE_3LEVEL_H */
diff -puN include/asm-i386/pgtable.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing
+++ a/include/asm-i386/pgtable.h
@@ -243,6 +243,8 @@ static inline pte_t pte_mkyoung(pte_t pt
 static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte_low |= _PAGE_RW; return pte; }
 static inline pte_t pte_mkhuge(pte_t pte)	{ (pte).pte_low |= _PAGE_PSE; return pte; }
 
+extern void vmalloc_sync_all(void);
+
 #ifdef CONFIG_X86_PAE
 # include <asm/pgtable-3level.h>
 #else
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
