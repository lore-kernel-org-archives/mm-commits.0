Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EF6C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E78BC20723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026932;
	bh=qkChyn7t1JhCm01jmHPW8BjlW3rk58byYAEtb6nvE9I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jJ1T5IgUU4GEn3KqAyobsNJEKNV47pNGvLe0agDvCvqmoJY4RiyjGJqT8iKSuD+Jh
	 UW+5w/gdeX+sTBnTvBw/0HpsgmK/BnJ8Vp7Z2BsThP25YbGMWcykzU5gNvao4vTbVe
	 TCZILcA52J3LAxaNHQ/VlDl8Z6Rg5KM/9jJ4kJxo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgHJCfb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:31 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DBFD206C3;
        Mon, 10 Aug 2020 02:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026930;
        bh=qkChyn7t1JhCm01jmHPW8BjlW3rk58byYAEtb6nvE9I=;
        h=Date:From:To:Subject:From;
        b=2R/Hy25iUdHRdL6wmWnr0rLg3jLiUvXwkuJX1f2xZHYfnYOvz86iJQlZWa0akaKGu
         FKNrwDICM3pSHfCGWP5kQNF3EkB9W8XOktDX/79hTLHGi0304vb/3OsolSnEghLOdH
         /+Qm8s0Ftl4NH3nd7DpyOBvFSXhaGs1CV2LBBIxM=
Date:   Sun, 09 Aug 2020 19:35:29 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        corbet@lwn.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        hpa@zytor.com, kirill@shutemov.name, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com,
        paul.walmsley@sifive.com, paulus@samba.org, rppt@kernel.org,
        rppt@linux.ibm.com, steven.price@arm.com, tglx@linutronix.de,
        vgupta@synopsys.com, will@kernel.org, ziy@nvidia.com
Subject:  [merged]
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-add-tests-validating-advanced-arch-?=
 =?US-ASCII?Q?page-table-helpers.patch?= removed from -mm tree
Message-ID: <20200810023529.HGIBOY3O9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: add tests validating advanced arch page table helpers
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: add tests validating advanced arch page table helpers

This adds new tests validating for these following arch advanced page
table helpers.  These tests create and test specific mapping types at
various page table levels.

1. pxxp_set_wrprotect()
2. pxxp_get_and_clear()
3. pxxp_set_access_flags()
4. pxxp_get_and_clear_full()
5. pxxp_test_and_clear_young()
6. pxx_leaf()
7. pxx_set_huge()
8. pxx_(clear|mk)_savedwrite()
9. huge_pxxp_xxx()

[anshuman.khandual@arm.com: drop RANDOM_ORVALUE from hugetlb_advanced_tests()]
  Link: http://lkml.kernel.org/r/1594610587-4172-3-git-send-email-anshuman.khandual@arm.com
Link: http://lkml.kernel.org/r/1593996516-7186-3-git-send-email-anshuman.khandual@arm.com
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
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |  312 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 312 insertions(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers
+++ a/mm/debug_vm_pgtable.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/pfn_t.h>
 #include <linux/printk.h>
+#include <linux/pgtable.h>
 #include <linux/random.h>
 #include <linux/spinlock.h>
 #include <linux/swap.h>
@@ -28,6 +29,7 @@
 #include <linux/start_kernel.h>
 #include <linux/sched/mm.h>
 #include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
 
 #define VMFLAGS	(VM_READ|VM_WRITE|VM_EXEC)
 
@@ -55,6 +57,55 @@ static void __init pte_basic_tests(unsig
 	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte))));
 }
 
+static void __init pte_advanced_tests(struct mm_struct *mm,
+				      struct vm_area_struct *vma, pte_t *ptep,
+				      unsigned long pfn, unsigned long vaddr,
+				      pgprot_t prot)
+{
+	pte_t pte = pfn_pte(pfn, prot);
+
+	pte = pfn_pte(pfn, prot);
+	set_pte_at(mm, vaddr, ptep, pte);
+	ptep_set_wrprotect(mm, vaddr, ptep);
+	pte = ptep_get(ptep);
+	WARN_ON(pte_write(pte));
+
+	pte = pfn_pte(pfn, prot);
+	set_pte_at(mm, vaddr, ptep, pte);
+	ptep_get_and_clear(mm, vaddr, ptep);
+	pte = ptep_get(ptep);
+	WARN_ON(!pte_none(pte));
+
+	pte = pfn_pte(pfn, prot);
+	pte = pte_wrprotect(pte);
+	pte = pte_mkclean(pte);
+	set_pte_at(mm, vaddr, ptep, pte);
+	pte = pte_mkwrite(pte);
+	pte = pte_mkdirty(pte);
+	ptep_set_access_flags(vma, vaddr, ptep, pte, 1);
+	pte = ptep_get(ptep);
+	WARN_ON(!(pte_write(pte) && pte_dirty(pte)));
+
+	pte = pfn_pte(pfn, prot);
+	set_pte_at(mm, vaddr, ptep, pte);
+	ptep_get_and_clear_full(mm, vaddr, ptep, 1);
+	pte = ptep_get(ptep);
+	WARN_ON(!pte_none(pte));
+
+	pte = pte_mkyoung(pte);
+	set_pte_at(mm, vaddr, ptep, pte);
+	ptep_test_and_clear_young(vma, vaddr, ptep);
+	pte = ptep_get(ptep);
+	WARN_ON(pte_young(pte));
+}
+
+static void __init pte_savedwrite_tests(unsigned long pfn, pgprot_t prot)
+{
+	pte_t pte = pfn_pte(pfn, prot);
+
+	WARN_ON(!pte_savedwrite(pte_mk_savedwrite(pte_clear_savedwrite(pte))));
+	WARN_ON(pte_savedwrite(pte_clear_savedwrite(pte_mk_savedwrite(pte))));
+}
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void __init pmd_basic_tests(unsigned long pfn, pgprot_t prot)
 {
@@ -77,6 +128,90 @@ static void __init pmd_basic_tests(unsig
 	WARN_ON(!pmd_bad(pmd_mkhuge(pmd)));
 }
 
+static void __init pmd_advanced_tests(struct mm_struct *mm,
+				      struct vm_area_struct *vma, pmd_t *pmdp,
+				      unsigned long pfn, unsigned long vaddr,
+				      pgprot_t prot)
+{
+	pmd_t pmd = pfn_pmd(pfn, prot);
+
+	if (!has_transparent_hugepage())
+		return;
+
+	/* Align the address wrt HPAGE_PMD_SIZE */
+	vaddr = (vaddr & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE;
+
+	pmd = pfn_pmd(pfn, prot);
+	set_pmd_at(mm, vaddr, pmdp, pmd);
+	pmdp_set_wrprotect(mm, vaddr, pmdp);
+	pmd = READ_ONCE(*pmdp);
+	WARN_ON(pmd_write(pmd));
+
+	pmd = pfn_pmd(pfn, prot);
+	set_pmd_at(mm, vaddr, pmdp, pmd);
+	pmdp_huge_get_and_clear(mm, vaddr, pmdp);
+	pmd = READ_ONCE(*pmdp);
+	WARN_ON(!pmd_none(pmd));
+
+	pmd = pfn_pmd(pfn, prot);
+	pmd = pmd_wrprotect(pmd);
+	pmd = pmd_mkclean(pmd);
+	set_pmd_at(mm, vaddr, pmdp, pmd);
+	pmd = pmd_mkwrite(pmd);
+	pmd = pmd_mkdirty(pmd);
+	pmdp_set_access_flags(vma, vaddr, pmdp, pmd, 1);
+	pmd = READ_ONCE(*pmdp);
+	WARN_ON(!(pmd_write(pmd) && pmd_dirty(pmd)));
+
+	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
+	set_pmd_at(mm, vaddr, pmdp, pmd);
+	pmdp_huge_get_and_clear_full(vma, vaddr, pmdp, 1);
+	pmd = READ_ONCE(*pmdp);
+	WARN_ON(!pmd_none(pmd));
+
+	pmd = pmd_mkyoung(pmd);
+	set_pmd_at(mm, vaddr, pmdp, pmd);
+	pmdp_test_and_clear_young(vma, vaddr, pmdp);
+	pmd = READ_ONCE(*pmdp);
+	WARN_ON(pmd_young(pmd));
+}
+
+static void __init pmd_leaf_tests(unsigned long pfn, pgprot_t prot)
+{
+	pmd_t pmd = pfn_pmd(pfn, prot);
+
+	/*
+	 * PMD based THP is a leaf entry.
+	 */
+	pmd = pmd_mkhuge(pmd);
+	WARN_ON(!pmd_leaf(pmd));
+}
+
+static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot)
+{
+	pmd_t pmd;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+		return;
+	/*
+	 * X86 defined pmd_set_huge() verifies that the given
+	 * PMD is not a populated non-leaf entry.
+	 */
+	WRITE_ONCE(*pmdp, __pmd(0));
+	WARN_ON(!pmd_set_huge(pmdp, __pfn_to_phys(pfn), prot));
+	WARN_ON(!pmd_clear_huge(pmdp));
+	pmd = READ_ONCE(*pmdp);
+	WARN_ON(!pmd_none(pmd));
+}
+
+static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot)
+{
+	pmd_t pmd = pfn_pmd(pfn, prot);
+
+	WARN_ON(!pmd_savedwrite(pmd_mk_savedwrite(pmd_clear_savedwrite(pmd))));
+	WARN_ON(pmd_savedwrite(pmd_clear_savedwrite(pmd_mk_savedwrite(pmd))));
+}
+
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static void __init pud_basic_tests(unsigned long pfn, pgprot_t prot)
 {
@@ -100,12 +235,119 @@ static void __init pud_basic_tests(unsig
 	 */
 	WARN_ON(!pud_bad(pud_mkhuge(pud)));
 }
+
+static void __init pud_advanced_tests(struct mm_struct *mm,
+				      struct vm_area_struct *vma, pud_t *pudp,
+				      unsigned long pfn, unsigned long vaddr,
+				      pgprot_t prot)
+{
+	pud_t pud = pfn_pud(pfn, prot);
+
+	if (!has_transparent_hugepage())
+		return;
+
+	/* Align the address wrt HPAGE_PUD_SIZE */
+	vaddr = (vaddr & HPAGE_PUD_MASK) + HPAGE_PUD_SIZE;
+
+	set_pud_at(mm, vaddr, pudp, pud);
+	pudp_set_wrprotect(mm, vaddr, pudp);
+	pud = READ_ONCE(*pudp);
+	WARN_ON(pud_write(pud));
+
+#ifndef __PAGETABLE_PMD_FOLDED
+	pud = pfn_pud(pfn, prot);
+	set_pud_at(mm, vaddr, pudp, pud);
+	pudp_huge_get_and_clear(mm, vaddr, pudp);
+	pud = READ_ONCE(*pudp);
+	WARN_ON(!pud_none(pud));
+
+	pud = pfn_pud(pfn, prot);
+	set_pud_at(mm, vaddr, pudp, pud);
+	pudp_huge_get_and_clear_full(mm, vaddr, pudp, 1);
+	pud = READ_ONCE(*pudp);
+	WARN_ON(!pud_none(pud));
+#endif /* __PAGETABLE_PMD_FOLDED */
+	pud = pfn_pud(pfn, prot);
+	pud = pud_wrprotect(pud);
+	pud = pud_mkclean(pud);
+	set_pud_at(mm, vaddr, pudp, pud);
+	pud = pud_mkwrite(pud);
+	pud = pud_mkdirty(pud);
+	pudp_set_access_flags(vma, vaddr, pudp, pud, 1);
+	pud = READ_ONCE(*pudp);
+	WARN_ON(!(pud_write(pud) && pud_dirty(pud)));
+
+	pud = pud_mkyoung(pud);
+	set_pud_at(mm, vaddr, pudp, pud);
+	pudp_test_and_clear_young(vma, vaddr, pudp);
+	pud = READ_ONCE(*pudp);
+	WARN_ON(pud_young(pud));
+}
+
+static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot)
+{
+	pud_t pud = pfn_pud(pfn, prot);
+
+	/*
+	 * PUD based THP is a leaf entry.
+	 */
+	pud = pud_mkhuge(pud);
+	WARN_ON(!pud_leaf(pud));
+}
+
+static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
+{
+	pud_t pud;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+		return;
+	/*
+	 * X86 defined pud_set_huge() verifies that the given
+	 * PUD is not a populated non-leaf entry.
+	 */
+	WRITE_ONCE(*pudp, __pud(0));
+	WARN_ON(!pud_set_huge(pudp, __pfn_to_phys(pfn), prot));
+	WARN_ON(!pud_clear_huge(pudp));
+	pud = READ_ONCE(*pudp);
+	WARN_ON(!pud_none(pud));
+}
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 static void __init pud_basic_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_advanced_tests(struct mm_struct *mm,
+				      struct vm_area_struct *vma, pud_t *pudp,
+				      unsigned long pfn, unsigned long vaddr,
+				      pgprot_t prot)
+{
+}
+static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
+{
+}
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_basic_tests(unsigned long pfn, pgprot_t prot) { }
 static void __init pud_basic_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_advanced_tests(struct mm_struct *mm,
+				      struct vm_area_struct *vma, pmd_t *pmdp,
+				      unsigned long pfn, unsigned long vaddr,
+				      pgprot_t prot)
+{
+}
+static void __init pud_advanced_tests(struct mm_struct *mm,
+				      struct vm_area_struct *vma, pud_t *pudp,
+				      unsigned long pfn, unsigned long vaddr,
+				      pgprot_t prot)
+{
+}
+static void __init pmd_leaf_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot)
+{
+}
+static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
+{
+}
+static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static void __init p4d_basic_tests(unsigned long pfn, pgprot_t prot)
@@ -495,8 +737,56 @@ static void __init hugetlb_basic_tests(u
 	WARN_ON(!pte_huge(pte_mkhuge(pte)));
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 }
+
+static void __init hugetlb_advanced_tests(struct mm_struct *mm,
+					  struct vm_area_struct *vma,
+					  pte_t *ptep, unsigned long pfn,
+					  unsigned long vaddr, pgprot_t prot)
+{
+	struct page *page = pfn_to_page(pfn);
+	pte_t pte = ptep_get(ptep);
+	unsigned long paddr = __pfn_to_phys(pfn) & PMD_MASK;
+
+	pte = pte_mkhuge(mk_pte(pfn_to_page(PHYS_PFN(paddr)), prot));
+	set_huge_pte_at(mm, vaddr, ptep, pte);
+	barrier();
+	WARN_ON(!pte_same(pte, huge_ptep_get(ptep)));
+	huge_pte_clear(mm, vaddr, ptep, PMD_SIZE);
+	pte = huge_ptep_get(ptep);
+	WARN_ON(!huge_pte_none(pte));
+
+	pte = mk_huge_pte(page, prot);
+	set_huge_pte_at(mm, vaddr, ptep, pte);
+	barrier();
+	huge_ptep_set_wrprotect(mm, vaddr, ptep);
+	pte = huge_ptep_get(ptep);
+	WARN_ON(huge_pte_write(pte));
+
+	pte = mk_huge_pte(page, prot);
+	set_huge_pte_at(mm, vaddr, ptep, pte);
+	barrier();
+	huge_ptep_get_and_clear(mm, vaddr, ptep);
+	pte = huge_ptep_get(ptep);
+	WARN_ON(!huge_pte_none(pte));
+
+	pte = mk_huge_pte(page, prot);
+	pte = huge_pte_wrprotect(pte);
+	set_huge_pte_at(mm, vaddr, ptep, pte);
+	barrier();
+	pte = huge_pte_mkwrite(pte);
+	pte = huge_pte_mkdirty(pte);
+	huge_ptep_set_access_flags(vma, vaddr, ptep, pte, 1);
+	pte = huge_ptep_get(ptep);
+	WARN_ON(!(huge_pte_write(pte) && huge_pte_dirty(pte)));
+}
 #else  /* !CONFIG_HUGETLB_PAGE */
 static void __init hugetlb_basic_tests(unsigned long pfn, pgprot_t prot) { }
+static void __init hugetlb_advanced_tests(struct mm_struct *mm,
+					  struct vm_area_struct *vma,
+					  pte_t *ptep, unsigned long pfn,
+					  unsigned long vaddr, pgprot_t prot)
+{
+}
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -568,6 +858,7 @@ static unsigned long __init get_random_v
 
 static int __init debug_vm_pgtable(void)
 {
+	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	pgd_t *pgdp;
 	p4d_t *p4dp, *saved_p4dp;
@@ -596,6 +887,12 @@ static int __init debug_vm_pgtable(void)
 	 */
 	protnone = __P000;
 
+	vma = vm_area_alloc(mm);
+	if (!vma) {
+		pr_err("vma allocation failed\n");
+		return 1;
+	}
+
 	/*
 	 * PFN for mapping at PTE level is determined from a standard kernel
 	 * text symbol. But pfns for higher page table levels are derived by
@@ -644,6 +941,20 @@ static int __init debug_vm_pgtable(void)
 	p4d_clear_tests(mm, p4dp);
 	pgd_clear_tests(mm, pgdp);
 
+	pte_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
+	pmd_advanced_tests(mm, vma, pmdp, pmd_aligned, vaddr, prot);
+	pud_advanced_tests(mm, vma, pudp, pud_aligned, vaddr, prot);
+	hugetlb_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
+
+	pmd_leaf_tests(pmd_aligned, prot);
+	pud_leaf_tests(pud_aligned, prot);
+
+	pmd_huge_tests(pmdp, pmd_aligned, prot);
+	pud_huge_tests(pudp, pud_aligned, prot);
+
+	pte_savedwrite_tests(pte_aligned, prot);
+	pmd_savedwrite_tests(pmd_aligned, prot);
+
 	pte_unmap_unlock(ptep, ptl);
 
 	pmd_populate_tests(mm, pmdp, saved_ptep);
@@ -678,6 +989,7 @@ static int __init debug_vm_pgtable(void)
 	pmd_free(mm, saved_pmdp);
 	pte_free(mm, saved_ptep);
 
+	vm_area_free(vma);
 	mm_dec_nr_puds(mm);
 	mm_dec_nr_pmds(mm);
 	mm_dec_nr_ptes(mm);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-vmstat-add-events-for-thp-migration-without-split.patch

