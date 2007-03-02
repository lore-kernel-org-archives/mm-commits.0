From: akpm@linux-foundation.org
Subject: + xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:03:07 -0800
Message-ID: <200703020203.l222380T029551@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34964 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422760AbXCBCDV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:03:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, mingo@elte.hu, wli@holomorphy.com


The patch titled
     xen-paravirt_ops: paravirt_ops: hooks to set up initial pagetable
has been added to the -mm tree.  Its filename is
     xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xen-paravirt_ops: paravirt_ops: hooks to set up initial pagetable
From: Jeremy Fitzhardinge <jeremy@goop.org>

This patch introduces paravirt_ops hooks to control how the kernel's initial
pagetable is set up.

In the case of a native boot, the very early bootstrap code creates a simple
non-PAE pagetable to map the kernel and physical memory.  When the VM
subsystem is initialized, it creates a proper pagetable which respects the PAE
mode, large pages, etc.

When booting under a hypervisor, there are many possibilities for what paging
environment the hypervisor establishes for the guest kernel, so the
constructon of the kernel's pagetable depends on the hypervisor.

In the case of Xen, the hypervisor boots the kernel with a fully constructed
pagetable, which is already using PAE if necessary.  Also, Xen requires
particular care when constructing pagetables to make sure all pagetables are
always mapped read-only.

In order to make this easier, kernel's initial pagetable construction has been
changed to only allocate and initialize a pagetable page if there's no page
already present in the pagetable.  This allows the Xen paravirt backend to
make a copy of the hypervisor-provided pagetable, allowing the kernel to
establish any more mappings it needs while keeping the existing ones.

A slightly subtle point which is worth highlighting here is that Xen requires
all kernel mappings to share the same pte_t pages between all pagetables, so
that updating a kernel page's mapping in one pagetable is reflected in all
other pagetables.  This makes it possible to allocate a page and attach it to
a pagetable without having to explicitly enumerate that page's mapping in all
pagetables.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    3 
 arch/i386/mm/init.c         |  125 ++++++++++++++++++++++++----------
 include/asm-i386/paravirt.h |   17 ++++
 include/asm-i386/pgtable.h  |   16 ++++
 4 files changed, 126 insertions(+), 35 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable
+++ a/arch/i386/kernel/paravirt.c
@@ -474,6 +474,9 @@ struct paravirt_ops paravirt_ops = {
 #endif
 	.set_lazy_mode = paravirt_nop,
 
+	.pagetable_setup_start = native_pagetable_setup_start,
+	.pagetable_setup_done = native_pagetable_setup_done,
+
 	.flush_tlb_user = native_flush_tlb,
 	.flush_tlb_kernel = native_flush_tlb_global,
 	.flush_tlb_single = native_flush_tlb_single,
diff -puN arch/i386/mm/init.c~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable
+++ a/arch/i386/mm/init.c
@@ -42,6 +42,7 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
+#include <asm/paravirt.h>
 
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
@@ -62,6 +63,7 @@ static pmd_t * __init one_md_table_init(
 		
 #ifdef CONFIG_X86_PAE
 	pmd_table = (pmd_t *) alloc_bootmem_low_pages(PAGE_SIZE);
+
 	paravirt_alloc_pd(__pa(pmd_table) >> PAGE_SHIFT);
 	set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 	pud = pud_offset(pgd, 0);
@@ -83,12 +85,10 @@ static pte_t * __init one_page_table_ini
 {
 	if (pmd_none(*pmd)) {
 		pte_t *page_table = (pte_t *) alloc_bootmem_low_pages(PAGE_SIZE);
+
 		paravirt_alloc_pt(__pa(page_table) >> PAGE_SHIFT);
 		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
-		if (page_table != pte_offset_kernel(pmd, 0))
-			BUG();	
-
-		return page_table;
+		BUG_ON(page_table != pte_offset_kernel(pmd, 0));
 	}
 	
 	return pte_offset_kernel(pmd, 0);
@@ -119,7 +119,7 @@ static void __init page_table_range_init
 	pgd = pgd_base + pgd_idx;
 
 	for ( ; (pgd_idx < PTRS_PER_PGD) && (vaddr != end); pgd++, pgd_idx++) {
-		if (pgd_none(*pgd)) 
+		if (!(pgd_val(*pgd) & _PAGE_PRESENT))
 			one_md_table_init(pgd);
 		pud = pud_offset(pgd, vaddr);
 		pmd = pmd_offset(pud, vaddr);
@@ -158,7 +158,11 @@ static void __init kernel_physical_mappi
 	pfn = 0;
 
 	for (; pgd_idx < PTRS_PER_PGD; pgd++, pgd_idx++) {
-		pmd = one_md_table_init(pgd);
+		if (!(pgd_val(*pgd) & _PAGE_PRESENT))
+			pmd = one_md_table_init(pgd);
+		else
+			pmd = pmd_offset(pud_offset(pgd, PAGE_OFFSET), PAGE_OFFSET);
+
 		if (pfn >= max_low_pfn)
 			continue;
 		for (pmd_idx = 0; pmd_idx < PTRS_PER_PMD && pfn < max_low_pfn; pmd++, pmd_idx++) {
@@ -167,20 +171,26 @@ static void __init kernel_physical_mappi
 			/* Map with big pages if possible, otherwise create normal page tables. */
 			if (cpu_has_pse) {
 				unsigned int address2 = (pfn + PTRS_PER_PTE - 1) * PAGE_SIZE + PAGE_OFFSET + PAGE_SIZE-1;
-
-				if (is_kernel_text(address) || is_kernel_text(address2))
-					set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
-				else
-					set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE));
+				if (!pmd_present(*pmd)) {
+					if (is_kernel_text(address) || is_kernel_text(address2))
+						set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
+					else
+						set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE));
+				}
 				pfn += PTRS_PER_PTE;
 			} else {
 				pte = one_page_table_init(pmd);
 
-				for (pte_ofs = 0; pte_ofs < PTRS_PER_PTE && pfn < max_low_pfn; pte++, pfn++, pte_ofs++) {
-						if (is_kernel_text(address))
-							set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
-						else
-							set_pte(pte, pfn_pte(pfn, PAGE_KERNEL));
+				for (pte_ofs = 0;
+				     pte_ofs < PTRS_PER_PTE && pfn < max_low_pfn;
+				     pte++, pfn++, pte_ofs++, address += PAGE_SIZE) {
+					if (pte_present(*pte))
+						continue;
+
+					if (is_kernel_text(address))
+						set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
+					else
+						set_pte(pte, pfn_pte(pfn, PAGE_KERNEL));
 				}
 			}
 		}
@@ -337,19 +347,74 @@ extern void __init remap_numa_kva(void);
 #define remap_numa_kva() do {} while (0)
 #endif
 
-static void __init pagetable_init (void)
+void __init native_pagetable_setup_start(pgd_t *base)
 {
-	unsigned long vaddr;
-	pgd_t *pgd_base = swapper_pg_dir;
-
 #ifdef CONFIG_X86_PAE
 	int i;
-	/* Init entries of the first-level page table to the zero page */
-	for (i = 0; i < PTRS_PER_PGD; i++)
-		set_pgd(pgd_base + i, __pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
+
+	/*
+	 * Init entries of the first-level page table to the
+	 * zero page, if they haven't already been set up.
+	 *
+	 * In a normal native boot, we'll be running on a
+	 * pagetable rooted in swapper_pg_dir, but not in PAE
+	 * mode, so this will end up clobbering the mappings
+	 * for the lower 24Mbytes of the address space,
+	 * without affecting the kernel address space.
+	 */
+	for (i = 0; i < USER_PTRS_PER_PGD; i++)
+		set_pgd(&base[i],
+			__pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
+
+	/* Make sure kernel address space is empty so that a pagetable
+	   will be allocated for it. */
+	memset(&base[USER_PTRS_PER_PGD], 0,
+	       KERNEL_PGD_PTRS * sizeof(pgd_t));
 #else
 	paravirt_alloc_pd(__pa(swapper_pg_dir) >> PAGE_SHIFT);
 #endif
+}
+
+void __init native_pagetable_setup_done(pgd_t *base)
+{
+#ifdef CONFIG_X86_PAE
+	/*
+	 * Add low memory identity-mappings - SMP needs it when
+	 * starting up on an AP from real-mode. In the non-PAE
+	 * case we already have these mappings through head.S.
+	 * All user-space mappings are explicitly cleared after
+	 * SMP startup.
+	 */
+	set_pgd(&base[0], base[USER_PTRS_PER_PGD]);
+#endif
+}
+
+/*
+ * Build a proper pagetable for the kernel mappings.  Up until this
+ * point, we've been running on some set of pagetables constructed by
+ * the boot process.
+ *
+ * If we're booting on native hardware, this will be a pagetable
+ * constructed in arch/i386/kernel/head.S, and not running in PAE mode
+ * (even if we'll end up running in PAE).  The root of the pagetable
+ * will be swapper_pg_dir.
+ *
+ * If we're booting paravirtualized under a hypervisor, then there are
+ * more options: we may already be running PAE, and the pagetable may
+ * or may not be based in swapper_pg_dir.  In any case,
+ * paravirt_pagetable_setup_start() will set up swapper_pg_dir
+ * appropriately for the rest of the initialization to work.
+ *
+ * In general, pagetable_init() assumes that the pagetable may already
+ * be partially populated, and so it avoids stomping on any existing
+ * mappings.
+ */
+static void __init pagetable_init (void)
+{
+	unsigned long vaddr, end;
+	pgd_t *pgd_base = swapper_pg_dir;
+
+	paravirt_pagetable_setup_start(pgd_base);
 
 	/* Enable PSE if available */
 	if (cpu_has_pse) {
@@ -371,20 +436,12 @@ static void __init pagetable_init (void)
 	 * created - mappings will be set by set_fixmap():
 	 */
 	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
-	page_table_range_init(vaddr, 0, pgd_base);
+	end = (FIXADDR_TOP + PMD_SIZE - 1) & PMD_MASK;
+	page_table_range_init(vaddr, end, pgd_base);
 
 	permanent_kmaps_init(pgd_base);
 
-#ifdef CONFIG_X86_PAE
-	/*
-	 * Add low memory identity-mappings - SMP needs it when
-	 * starting up on an AP from real-mode. In the non-PAE
-	 * case we already have these mappings through head.S.
-	 * All user-space mappings are explicitly cleared after
-	 * SMP startup.
-	 */
-	set_pgd(&pgd_base[0], pgd_base[USER_PTRS_PER_PGD]);
-#endif
+	paravirt_pagetable_setup_done(pgd_base);
 }
 
 #if defined(CONFIG_SOFTWARE_SUSPEND) || defined(CONFIG_ACPI_SLEEP)
diff -puN include/asm-i386/paravirt.h~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable
+++ a/include/asm-i386/paravirt.h
@@ -2,10 +2,11 @@
 #define __ASM_PARAVIRT_H
 /* Various instructions on x86 need to be replaced for
  * para-virtualization: those hooks are defined here. */
+
+#ifdef CONFIG_PARAVIRT
 #include <linux/stringify.h>
 #include <asm/page.h>
 
-#ifdef CONFIG_PARAVIRT
 /* These are the most performance critical ops, so we want to be able to patch
  * callers */
 #define PARAVIRT_IRQ_DISABLE 0
@@ -49,6 +50,9 @@ struct paravirt_ops
 	char *(*memory_setup)(void);
 	void (*init_IRQ)(void);
 
+	void (*pagetable_setup_start)(pgd_t *pgd_base);
+	void (*pagetable_setup_done)(pgd_t *pgd_base);
+
 	void (*banner)(void);
 
 	unsigned long (*get_wallclock)(void);
@@ -363,6 +367,17 @@ static inline void setup_secondary_clock
 }
 #endif
 
+static inline void paravirt_pagetable_setup_start(pgd_t *base)
+{
+	if (paravirt_ops.pagetable_setup_start)
+		(*paravirt_ops.pagetable_setup_start)(base);
+}
+
+static inline void paravirt_pagetable_setup_done(pgd_t *base)
+{
+	if (paravirt_ops.pagetable_setup_done)
+		(*paravirt_ops.pagetable_setup_done)(base);
+}
 
 #ifdef CONFIG_SMP
 static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
diff -puN include/asm-i386/pgtable.h~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable
+++ a/include/asm-i386/pgtable.h
@@ -497,6 +497,22 @@ do {									\
  * tables contain all the necessary information.
  */
 #define update_mmu_cache(vma,address,pte) do { } while (0)
+
+void native_pagetable_setup_start(pgd_t *base);
+void native_pagetable_setup_done(pgd_t *base);
+
+#ifndef CONFIG_PARAVIRT
+static inline void paravirt_pagetable_setup_start(pgd_t *base)
+{
+	native_pagetable_setup_start(base);
+}
+
+static inline void paravirt_pagetable_setup_done(pgd_t *base)
+{
+	native_pagetable_setup_done(base);
+}
+#endif	/* !CONFIG_PARAVIRT */
+
 #endif /* !__ASSEMBLY__ */
 
 #ifdef CONFIG_FLATMEM
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
xen-paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
