From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-add-tests-validating-arch-helpers-fo?=
 =?US-ASCII?Q?r-core-mm-features.patch?= added to -mm tree
Date: Mon, 06 Jul 2020 16:28:24 -0700
Message-ID: <20200706232824.LV5wPRu38%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgGFX21 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 19:28:27 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, corbet@lwn.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, kirill@shutemov.name, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, rppt@kernel.org, rppt@linux.ibm.com, tglx@linutronix.de, vgupta@synopsys.com, will@kernel.org, ziy@nvidia.com


The patch titled
     Subject: mm/debug_vm_pgtable: add tests validating arch helpers for core MM features
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: add tests validating arch helpers for core MM features

Patch series "mm/debug_vm_pgtable: Add some more tests", v4.

This series adds some more arch page table helper validation tests which
are related to core and advanced memory functions.  This also creates a
documentation, enlisting expected semantics for all page table helpers as
suggested by Mike Rapoport previously
(https://lkml.org/lkml/2020/1/30/40).

There are many TRANSPARENT_HUGEPAGE and ARCH_HAS_TRANSPARENT_HUGEPAGE_PUD
ifdefs scattered across the test.  But consolidating all the fallback
stubs is not very straight forward because
ARCH_HAS_TRANSPARENT_HUGEPAGE_PUD is not explicitly dependent on
ARCH_HAS_TRANSPARENT_HUGEPAGE.

Tested on arm64, x86 platforms but only build tested on all other enabled
platforms through ARCH_HAS_DEBUG_VM_PGTABLE i.e powerpc, arc, s390.  The
following failure on arm64 still exists which was mentioned previously. 
It will be fixed with the upcoming THP migration on arm64 enablement
series.

WARNING .... mm/debug_vm_pgtable.c:860 debug_vm_pgtable+0x940/0xa54
WARN_ON(!pmd_present(pmd_mkinvalid(pmd_mkhuge(pmd))))


This patch (of 4):

This adds new tests validating arch page table helpers for these following
core memory features.  These tests create and test specific mapping types
at various page table levels.

1. SPECIAL mapping
2. PROTNONE mapping
3. DEVMAP mapping
4. SOFTDIRTY mapping
5. SWAP mapping
6. MIGRATION mapping
7. HUGETLB mapping
8. THP mapping

Link: http://lkml.kernel.org/r/1593996516-7186-1-git-send-email-anshuman.khandual@arm.com
Link: http://lkml.kernel.org/r/1593996516-7186-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Vineet Gupta <vgupta@synopsys.com>	[arc]
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |  302 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 301 insertions(+), 1 deletion(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features
+++ a/mm/debug_vm_pgtable.c
@@ -282,6 +282,278 @@ static void __init pmd_populate_tests(st
 	WARN_ON(pmd_bad(pmd));
 }
 
+static void __init pte_special_tests(unsigned long pfn, pgprot_t prot)
+{
+	pte_t pte = pfn_pte(pfn, prot);
+
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL))
+		return;
+
+	WARN_ON(!pte_special(pte_mkspecial(pte)));
+}
+
+static void __init pte_protnone_tests(unsigned long pfn, pgprot_t prot)
+{
+	pte_t pte = pfn_pte(pfn, prot);
+
+	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+		return;
+
+	WARN_ON(!pte_protnone(pte));
+	WARN_ON(!pte_present(pte));
+}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static void __init pmd_protnone_tests(unsigned long pfn, pgprot_t prot)
+{
+	pmd_t pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
+
+	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+		return;
+
+	WARN_ON(!pmd_protnone(pmd));
+	WARN_ON(!pmd_present(pmd));
+}
+#else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
+static void __init pmd_protnone_tests(unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+#ifdef CONFIG_ARCH_HAS_PTE_DEVMAP
+static void __init pte_devmap_tests(unsigned long pfn, pgprot_t prot)
+{
+	pte_t pte = pfn_pte(pfn, prot);
+
+	WARN_ON(!pte_devmap(pte_mkdevmap(pte)));
+}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static void __init pmd_devmap_tests(unsigned long pfn, pgprot_t prot)
+{
+	pmd_t pmd = pfn_pmd(pfn, prot);
+
+	WARN_ON(!pmd_devmap(pmd_mkdevmap(pmd)));
+}
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot)
+{
+	pud_t pud = pfn_pud(pfn, prot);
+
+	WARN_ON(!pud_devmap(pud_mkdevmap(pud)));
+}
+#else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+#else  /* CONFIG_TRANSPARENT_HUGEPAGE */
+static void __init pmd_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#else
+static void __init pte_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_devmap_tests(unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
+
+static void __init pte_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+{
+	pte_t pte = pfn_pte(pfn, prot);
+
+	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+		return;
+
+	WARN_ON(!pte_soft_dirty(pte_mksoft_dirty(pte)));
+	WARN_ON(pte_soft_dirty(pte_clear_soft_dirty(pte)));
+}
+
+static void __init pte_swap_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+{
+	pte_t pte = pfn_pte(pfn, prot);
+
+	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+		return;
+
+	WARN_ON(!pte_swp_soft_dirty(pte_swp_mksoft_dirty(pte)));
+	WARN_ON(pte_swp_soft_dirty(pte_swp_clear_soft_dirty(pte)));
+}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static void __init pmd_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+{
+	pmd_t pmd = pfn_pmd(pfn, prot);
+
+	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+		return;
+
+	WARN_ON(!pmd_soft_dirty(pmd_mksoft_dirty(pmd)));
+	WARN_ON(pmd_soft_dirty(pmd_clear_soft_dirty(pmd)));
+}
+
+static void __init pmd_swap_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+{
+	pmd_t pmd = pfn_pmd(pfn, prot);
+
+	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) ||
+		!IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
+		return;
+
+	WARN_ON(!pmd_swp_soft_dirty(pmd_swp_mksoft_dirty(pmd)));
+	WARN_ON(pmd_swp_soft_dirty(pmd_swp_clear_soft_dirty(pmd)));
+}
+#else  /* !CONFIG_ARCH_HAS_PTE_DEVMAP */
+static void __init pmd_soft_dirty_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_swap_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
+{
+}
+#endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
+
+static void __init pte_swap_tests(unsigned long pfn, pgprot_t prot)
+{
+	swp_entry_t swp;
+	pte_t pte;
+
+	pte = pfn_pte(pfn, prot);
+	swp = __pte_to_swp_entry(pte);
+	pte = __swp_entry_to_pte(swp);
+	WARN_ON(pfn != pte_pfn(pte));
+}
+
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+static void __init pmd_swap_tests(unsigned long pfn, pgprot_t prot)
+{
+	swp_entry_t swp;
+	pmd_t pmd;
+
+	pmd = pfn_pmd(pfn, prot);
+	swp = __pmd_to_swp_entry(pmd);
+	pmd = __swp_entry_to_pmd(swp);
+	WARN_ON(pfn != pmd_pfn(pmd));
+}
+#else  /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
+static void __init pmd_swap_tests(unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
+static void __init swap_migration_tests(void)
+{
+	struct page *page;
+	swp_entry_t swp;
+
+	if (!IS_ENABLED(CONFIG_MIGRATION))
+		return;
+	/*
+	 * swap_migration_tests() requires a dedicated page as it needs to
+	 * be locked before creating a migration entry from it. Locking the
+	 * page that actually maps kernel text ('start_kernel') can be real
+	 * problematic. Lets allocate a dedicated page explicitly for this
+	 * purpose that will be freed subsequently.
+	 */
+	page = alloc_page(GFP_KERNEL);
+	if (!page) {
+		pr_err("page allocation failed\n");
+		return;
+	}
+
+	/*
+	 * make_migration_entry() expects given page to be
+	 * locked, otherwise it stumbles upon a BUG_ON().
+	 */
+	__SetPageLocked(page);
+	swp = make_migration_entry(page, 1);
+	WARN_ON(!is_migration_entry(swp));
+	WARN_ON(!is_write_migration_entry(swp));
+
+	make_migration_entry_read(&swp);
+	WARN_ON(!is_migration_entry(swp));
+	WARN_ON(is_write_migration_entry(swp));
+
+	swp = make_migration_entry(page, 0);
+	WARN_ON(!is_migration_entry(swp));
+	WARN_ON(is_write_migration_entry(swp));
+	__ClearPageLocked(page);
+	__free_page(page);
+}
+
+#ifdef CONFIG_HUGETLB_PAGE
+static void __init hugetlb_basic_tests(unsigned long pfn, pgprot_t prot)
+{
+	struct page *page;
+	pte_t pte;
+
+	/*
+	 * Accessing the page associated with the pfn is safe here,
+	 * as it was previously derived from a real kernel symbol.
+	 */
+	page = pfn_to_page(pfn);
+	pte = mk_huge_pte(page, prot);
+
+	WARN_ON(!huge_pte_dirty(huge_pte_mkdirty(pte)));
+	WARN_ON(!huge_pte_write(huge_pte_mkwrite(huge_pte_wrprotect(pte))));
+	WARN_ON(huge_pte_write(huge_pte_wrprotect(huge_pte_mkwrite(pte))));
+
+#ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
+	pte = pfn_pte(pfn, prot);
+
+	WARN_ON(!pte_huge(pte_mkhuge(pte)));
+#endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
+}
+#else  /* !CONFIG_HUGETLB_PAGE */
+static void __init hugetlb_basic_tests(unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_HUGETLB_PAGE */
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static void __init pmd_thp_tests(unsigned long pfn, pgprot_t prot)
+{
+	pmd_t pmd;
+
+	if (!has_transparent_hugepage())
+		return;
+
+	/*
+	 * pmd_trans_huge() and pmd_present() must return positive after
+	 * MMU invalidation with pmd_mkinvalid(). This behavior is an
+	 * optimization for transparent huge page. pmd_trans_huge() must
+	 * be true if pmd_page() returns a valid THP to avoid taking the
+	 * pmd_lock when others walk over non transhuge pmds (i.e. there
+	 * are no THP allocated). Especially when splitting a THP and
+	 * removing the present bit from the pmd, pmd_trans_huge() still
+	 * needs to return true. pmd_present() should be true whenever
+	 * pmd_trans_huge() returns true.
+	 */
+	pmd = pfn_pmd(pfn, prot);
+	WARN_ON(!pmd_trans_huge(pmd_mkhuge(pmd)));
+
+#ifndef __HAVE_ARCH_PMDP_INVALIDATE
+	WARN_ON(!pmd_trans_huge(pmd_mkinvalid(pmd_mkhuge(pmd))));
+	WARN_ON(!pmd_present(pmd_mkinvalid(pmd_mkhuge(pmd))));
+#endif /* __HAVE_ARCH_PMDP_INVALIDATE */
+}
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static void __init pud_thp_tests(unsigned long pfn, pgprot_t prot)
+{
+	pud_t pud;
+
+	if (!has_transparent_hugepage())
+		return;
+
+	pud = pfn_pud(pfn, prot);
+	WARN_ON(!pud_trans_huge(pud_mkhuge(pud)));
+
+	/*
+	 * pud_mkinvalid() has been dropped for now. Enable back
+	 * these tests when it comes back with a modified pud_present().
+	 *
+	 * WARN_ON(!pud_trans_huge(pud_mkinvalid(pud_mkhuge(pud))));
+	 * WARN_ON(!pud_present(pud_mkinvalid(pud_mkhuge(pud))));
+	 */
+}
+#else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+static void __init pud_thp_tests(unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+#else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
+static void __init pmd_thp_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_thp_tests(unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 static unsigned long __init get_random_vaddr(void)
 {
 	unsigned long random_vaddr, random_pages, total_user_pages;
@@ -303,7 +575,7 @@ static int __init debug_vm_pgtable(void)
 	pmd_t *pmdp, *saved_pmdp, pmd;
 	pte_t *ptep;
 	pgtable_t saved_ptep;
-	pgprot_t prot;
+	pgprot_t prot, protnone;
 	phys_addr_t paddr;
 	unsigned long vaddr, pte_aligned, pmd_aligned;
 	unsigned long pud_aligned, p4d_aligned, pgd_aligned;
@@ -319,6 +591,12 @@ static int __init debug_vm_pgtable(void)
 	}
 
 	/*
+	 * __P000 (or even __S000) will help create page table entries with
+	 * PROT_NONE permission as required for pxx_protnone_tests().
+	 */
+	protnone = __P000;
+
+	/*
 	 * PFN for mapping at PTE level is determined from a standard kernel
 	 * text symbol. But pfns for higher page table levels are derived by
 	 * masking lower bits of this real pfn. These derived pfns might not
@@ -373,6 +651,28 @@ static int __init debug_vm_pgtable(void)
 	p4d_populate_tests(mm, p4dp, saved_pudp);
 	pgd_populate_tests(mm, pgdp, saved_p4dp);
 
+	pte_special_tests(pte_aligned, prot);
+	pte_protnone_tests(pte_aligned, protnone);
+	pmd_protnone_tests(pmd_aligned, protnone);
+
+	pte_devmap_tests(pte_aligned, prot);
+	pmd_devmap_tests(pmd_aligned, prot);
+	pud_devmap_tests(pud_aligned, prot);
+
+	pte_soft_dirty_tests(pte_aligned, prot);
+	pmd_soft_dirty_tests(pmd_aligned, prot);
+	pte_swap_soft_dirty_tests(pte_aligned, prot);
+	pmd_swap_soft_dirty_tests(pmd_aligned, prot);
+
+	pte_swap_tests(pte_aligned, prot);
+	pmd_swap_tests(pmd_aligned, prot);
+
+	swap_migration_tests();
+	hugetlb_basic_tests(pte_aligned, prot);
+
+	pmd_thp_tests(pmd_aligned, prot);
+	pud_thp_tests(pud_aligned, prot);
+
 	p4d_free(mm, saved_p4dp);
 	pud_free(mm, saved_pudp);
 	pmd_free(mm, saved_pmdp);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features.patch
mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers.patch
mm-debug_vm_pgtable-add-debug-prints-for-individual-tests.patch
documentation-mm-add-descriptions-for-arch-page-table-helpers.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch
