From: akpm@linux-foundation.org
Subject: + i386-fix-assumed-to-be-contiguous-leaf-page-tables-for-kmap_atomic-region.patch added to -mm tree
Date: Thu, 15 Jan 2009 16:00:06 -0800
Message-ID: <200901160000.n0G006SJ027635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754980AbZAPAAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 19:00:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, andi@firstfloor.org, hpa@zytor.com, mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de


The patch titled
     i386: fix assumed to be contiguous leaf page tables  for kmap_atomic region
has been added to the -mm tree.  Its filename is
     i386-fix-assumed-to-be-contiguous-leaf-page-tables-for-kmap_atomic-region.patch

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
Subject: i386: fix assumed to be contiguous leaf page tables  for kmap_atomic region
From: "Jan Beulich" <jbeulich@novell.com>

Debugging and original patch from Nick Piggin <npiggin@suse.de>

The early fixmap pmd entry inserted at the very top of the KVA is causing the
subsequent fixmap mapping code to not provide physically linear pte pages over
the kmap atomic portion of the fixmap (which relies on said property to
calculate pte addresses).

This has caused weird boot failures in kmap_atomic much later in the boot
process (initial userspace faults) on a 32-bit PAE system with a larger number
of CPUs (smaller CPU counts tend not to run over into the next page so don't
show up the problem).

Solve this by attempting to clear out the page table, and copy any of its
entries to the new one. Also, add a bug if a nonlinear condition is encounted
and can't be resolved, which might save some hours of debugging if this fragile
scheme ever breaks again...

Once we have such logic, we can also use it to eliminate the early ioremap
trickery around the page table setup for the fixmap area.  This also fixes
potential issues with FIX_* entries sharing the leaf page table with the
early ioremap ones getting discarded by early_ioremap_clear() and not
restored by early_ioremap_reset().  It at once eliminates the temporary
(and configuration, namely NR_CPUS, dependent) unavailability of early
fixed mappings during the time the fixmap area page tables get
constructed.

Finally, also replace the hard coded calculation of the initial table space
needed for the fixmap area with a proper one, allowing kernels configured for
large CPU counts to actually boot.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/io.h |    1 
 arch/x86/mm/init_32.c     |   46 +++++++++++++++++++++++++++++++++---
 arch/x86/mm/ioremap.c     |   25 -------------------
 3 files changed, 43 insertions(+), 29 deletions(-)

diff -puN arch/x86/include/asm/io.h~i386-fix-assumed-to-be-contiguous-leaf-page-tables-for-kmap_atomic-region arch/x86/include/asm/io.h
--- a/arch/x86/include/asm/io.h~i386-fix-assumed-to-be-contiguous-leaf-page-tables-for-kmap_atomic-region
+++ a/arch/x86/include/asm/io.h
@@ -99,7 +99,6 @@ extern void __iomem *ioremap_wc(unsigned
  * A boot-time mapping is currently limited to at most 16 pages.
  */
 extern void early_ioremap_init(void);
-extern void early_ioremap_clear(void);
 extern void early_ioremap_reset(void);
 extern void __iomem *early_ioremap(unsigned long offset, unsigned long size);
 extern void __iomem *early_memremap(unsigned long offset, unsigned long size);
diff -puN arch/x86/mm/init_32.c~i386-fix-assumed-to-be-contiguous-leaf-page-tables-for-kmap_atomic-region arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~i386-fix-assumed-to-be-contiguous-leaf-page-tables-for-kmap_atomic-region
+++ a/arch/x86/mm/init_32.c
@@ -154,6 +154,11 @@ page_table_range_init(unsigned long star
 	unsigned long vaddr;
 	pgd_t *pgd;
 	pmd_t *pmd;
+#ifdef CONFIG_HIGHMEM
+	pte_t *lastpte = NULL;
+	int pmd_idx_kmap_begin = fix_to_virt(FIX_KMAP_END) >> PMD_SHIFT;
+	int pmd_idx_kmap_end = fix_to_virt(FIX_KMAP_BEGIN) >> PMD_SHIFT;
+#endif
 
 	vaddr = start;
 	pgd_idx = pgd_index(vaddr);
@@ -165,7 +170,43 @@ page_table_range_init(unsigned long star
 		pmd = pmd + pmd_index(vaddr);
 		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end);
 							pmd++, pmd_idx++) {
-			one_page_table_init(pmd);
+			pte_t *pte;
+
+			pte = one_page_table_init(pmd);
+#ifdef CONFIG_HIGHMEM
+			/*
+			 * Something (early fixmap) may already have put a pte
+			 * page here, which causes the page table allocation
+			 * to become nonlinear. Attempt to fix it, and if it
+			 * is still nonlinear then we have to bug.
+			 */
+			if (pmd_idx_kmap_begin != pmd_idx_kmap_end
+			    && (vaddr >> PMD_SHIFT) >= pmd_idx_kmap_begin
+			    && (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end
+			    && ((__pa(pte) >> PAGE_SHIFT) < table_start
+				|| (__pa(pte) >> PAGE_SHIFT) >= table_end)) {
+				pte_t *newpte;
+				int i;
+
+				BUG_ON(after_init_bootmem);
+				newpte = alloc_low_page();
+				for (i = 0; i < PTRS_PER_PTE; i++)
+					set_pte(newpte + i, pte[i]);
+
+				paravirt_alloc_pte(&init_mm,
+						   __pa(newpte) >> PAGE_SHIFT);
+				set_pmd(pmd, __pmd(__pa(newpte)|_PAGE_TABLE));
+				BUG_ON(newpte != pte_offset_kernel(pmd, 0));
+				__flush_tlb_all();
+
+				paravirt_release_pte(__pa(pte) >> PAGE_SHIFT);
+				pte = newpte;
+			}
+			BUG_ON(vaddr < fix_to_virt(FIX_KMAP_BEGIN - 1)
+			       && vaddr > fix_to_virt(FIX_KMAP_END)
+			       && lastpte && lastpte + PTRS_PER_PTE != pte);
+			lastpte = pte;
+#endif
 
 			vaddr += PMD_SIZE;
 		}
@@ -508,7 +549,6 @@ static void __init early_ioremap_page_ta
 	 * Fixed mappings, only the page table structure has to be
 	 * created - mappings will be set by set_fixmap():
 	 */
-	early_ioremap_clear();
 	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
 	end = (FIXADDR_TOP + PMD_SIZE - 1) & PMD_MASK;
 	page_table_range_init(vaddr, end, pgd_base);
@@ -801,7 +841,7 @@ static void __init find_early_table_spac
 	tables += PAGE_ALIGN(ptes * sizeof(pte_t));
 
 	/* for fixmap */
-	tables += PAGE_SIZE * 2;
+	tables += PAGE_ALIGN(__end_of_fixed_addresses * sizeof(pte_t));
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
diff -puN arch/x86/mm/ioremap.c~i386-fix-assumed-to-be-contiguous-leaf-page-tables-for-kmap_atomic-region arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~i386-fix-assumed-to-be-contiguous-leaf-page-tables-for-kmap_atomic-region
+++ a/arch/x86/mm/ioremap.c
@@ -557,34 +557,9 @@ void __init early_ioremap_init(void)
 	}
 }
 
-void __init early_ioremap_clear(void)
-{
-	pmd_t *pmd;
-
-	if (early_ioremap_debug)
-		printk(KERN_INFO "early_ioremap_clear()\n");
-
-	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
-	pmd_clear(pmd);
-	paravirt_release_pte(__pa(bm_pte) >> PAGE_SHIFT);
-	__flush_tlb_all();
-}
-
 void __init early_ioremap_reset(void)
 {
-	enum fixed_addresses idx;
-	unsigned long addr, phys;
-	pte_t *pte;
