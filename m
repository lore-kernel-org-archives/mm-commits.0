From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:16:22 -0800
Message-ID: <200702282316.l1SNGMpO030056@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47208 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbXB1XQ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:16:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     From: Jeremy Fitzhardinge <jeremy@goop.org>
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: From: Jeremy Fitzhardinge <jeremy@goop.org>


This patch introduces paravirt_ops hooks to control how the kernel's
initial pagetable is set up.

In the case of a native boot, the very early bootstrap code creates a
simple non-PAE pagetable to map the kernel and physical memory.  When
the VM subsystem is initialized, it creates a proper pagetable which
respects the PAE mode, large pages, etc.

When booting under a hypervisor, there are many possibilities for what
paging environment the hypervisor establishes for the guest kernel, so
the constructon of the kernel's pagetable depends on the hypervisor.

In the case of Xen, the hypervisor boots the kernel with a fully
constructed pagetable, which is already using PAE if necessary.  Also,
Xen requires particular care when constructing pagetables to make sure
all pagetables are always mapped read-only.

In order to make this easier, kernel's initial pagetable construction
has been changed to only allocate and initialize a pagetable page if
there's no page already present in the pagetable.  This allows the Xen
paravirt backend to make a copy of the hypervisor-provided pagetable,
allowing the kernel to establish any more mappings it needs while
keeping the existing ones.

A slightly subtle point which is worth highlighting here is that Xen
requires all kernel mappings to share the same pte_t pages between all
pagetables, so that updating a kernel page's mapping in one pagetable
is reflected in all other pagetables.  This makes it possible to
allocate a page and attach it to a pagetable without having to
explicitly enumerate that page's mapping in all pagetables.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

--

===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |   40 +++++++++++++++
 arch/i386/mm/init.c         |   87 +++++++++++++++++++---------------
 include/asm-i386/paravirt.h |   54 +++++++++++++++++++++
 include/asm-i386/pgtable.h  |    3 +
 4 files changed, 148 insertions(+), 36 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable
+++ a/arch/i386/kernel/paravirt.c
@@ -380,6 +380,43 @@ static void native_io_delay(void)
 	asm volatile("outb %al,$0x80");
 }
 
+void native_pagetable_setup_start(pgd_t *base)
+{
+#ifdef CONFIG_X86_PAE
+	int i;
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
+	memset(&base[USER_PTRS_PER_PGD], 0, sizeof(pgd_t));
+#endif
+}
+
+void native_pagetable_setup_done(pgd_t *base)
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
+
 static void native_flush_tlb(void)
 {
 	__native_flush_tlb();
@@ -627,6 +664,9 @@ struct paravirt_ops paravirt_ops = {
 #endif
 	.set_lazy_mode = (void *)native_nop,
 
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
@@ -337,19 +347,32 @@ extern void __init remap_numa_kva(void);
 #define remap_numa_kva() do {} while (0)
 #endif
 
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
 static void __init pagetable_init (void)
 {
-	unsigned long vaddr;
+	unsigned long vaddr, end;
 	pgd_t *pgd_base = swapper_pg_dir;
 
-#ifdef CONFIG_X86_PAE
-	int i;
-	/* Init entries of the first-level page table to the zero page */
-	for (i = 0; i < PTRS_PER_PGD; i++)
-		set_pgd(pgd_base + i, __pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
-#else
-	paravirt_alloc_pd(__pa(swapper_pg_dir) >> PAGE_SHIFT);
-#endif
+	paravirt_pagetable_setup_start(pgd_base);
 
 	/* Enable PSE if available */
 	if (cpu_has_pse) {
@@ -371,20 +394,12 @@ static void __init pagetable_init (void)
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
@@ -50,6 +50,9 @@ struct paravirt_ops
 	char *(*memory_setup)(void);
 	void (*init_IRQ)(void);
 
+	void (*pagetable_setup_start)(pgd_t *pgd_base);
+	void (*pagetable_setup_done)(pgd_t *pgd_base);
+
 	void (*banner)(void);
 
 	unsigned long (*get_wallclock)(void);
@@ -185,6 +188,8 @@ struct paravirt_ops
 
 extern struct paravirt_ops paravirt_ops;
 
+void native_pagetable_setup_start(pgd_t *pgd);
+
 #ifdef CONFIG_X86_PAE
 unsigned long long native_pte_val(pte_t);
 unsigned long long native_pmd_val(pmd_t);
@@ -389,6 +394,17 @@ static inline void setup_secondary_clock
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
 
 void native_set_pte(pte_t *ptep, pte_t pteval);
 void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval);
@@ -615,5 +631,43 @@ static inline unsigned long __raw_local_
 	call *paravirt_ops+PARAVIRT_read_cr0
 
 #endif /* __ASSEMBLY__ */
+#else  /* !CONFIG_PARAVIRT */
+#include <asm/pgtable.h>
+
+static inline void paravirt_pagetable_setup_start(pgd_t *base)
+{
+#ifdef CONFIG_X86_PAE
+	int i;
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
+	memset(&base[USER_PTRS_PER_PGD], 0, sizeof(pgd_t));
+#endif
+}
+
+static inline void paravirt_pagetable_setup_done(pgd_t *base)
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
 #endif /* CONFIG_PARAVIRT */
 #endif	/* __ASM_PARAVIRT_H */
diff -puN include/asm-i386/pgtable.h~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable
+++ a/include/asm-i386/pgtable.h
@@ -15,7 +15,10 @@
 #include <asm/processor.h>
 #include <asm/fixmap.h>
 #include <linux/threads.h>
+
+#ifdef CONFIG_PARAVIRT		/* guarded to prevent cyclic dependency */
 #include <asm/paravirt.h>
+#endif
 
 #ifndef _I386_BITOPS_H
 #include <asm/bitops.h>
_

Patches currently in -mm which might be from jeremy@goop.org are

make-hvc_consolec-compile-on-non-powerpc-remove-no_irq.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-some-generic-early-printk-boot-console-fixups.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
