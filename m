Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEFBC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6D8D20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814331;
	bh=m2f/lZu+8xpH/ypRF5ufsh193QVwlb3fBVNsMMcYVXQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=P9nHIMFhh8A4gTkAVfKetyjoDP1qNKmzLyF0ZoA0zTGDfcP2SOtKcwRtObOC2pHKJ
	 cW+UxS7ejKzN0U9aReRtRfl7SVC0N4a3HRhej5lMYCEA3UC5o+WSfAL00jMOhAsVYg
	 uEPDhR1UMIStq5RyQJXAU24AmVbyRwCkGwf+aDMs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404040AbgJPCML (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404030AbgJPCMK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:12:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F9DD2073A;
        Fri, 16 Oct 2020 02:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814330;
        bh=m2f/lZu+8xpH/ypRF5ufsh193QVwlb3fBVNsMMcYVXQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fdPCS44HyOemJ/OZ5hluBFy3dmWzof42eURy4e2nNKYDMvL5iOfJ8yqlVDpGnZkKF
         rHhfAJM0rPF8bIh3X8WsE7eWIsR4Owgaz4oU9oynoyWOlyZnoyWnqRZ6P8TBlU42O+
         Ap9JS9VwG6/BVAG5f0mWC7/mVgwIEr2AGdu4dDko=
Date:   Thu, 15 Oct 2020 19:12:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, gerald.schaefer@linux.ibm.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64-fix.patch removed
 from -mm tree
Message-ID: <20201016021209.xze-76Q-2%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: drop hugetlb_advanced_tests()
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64-fix.patch

This patch was dropped because it was folded into mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64.patch

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: drop hugetlb_advanced_tests()

hugetlb_advanced_tests() has now stopped working on i386 platform due to
some recent changes with respect to page table lock.  The test never
worked on ppc64 platform, which resulted in disabling it selectively. 
Let's just drop hugetlb_advanced_tests() for now and in the process free
up the entire test from the only platform specific test execution path.

https://lore.kernel.org/lkml/289c3fdb-1394-c1af-bdc4-5542907089dc@linux.ibm.com/#t

Link: https://lkml.kernel.org/r/1600914446-21890-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   55 ----------------------------------------
 1 file changed, 55 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64-fix
+++ a/mm/debug_vm_pgtable.c
@@ -810,59 +810,8 @@ static void __init hugetlb_basic_tests(u
 	WARN_ON(!pte_huge(pte_mkhuge(pte)));
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 }
-
-#ifndef CONFIG_PPC_BOOK3S_64
-static void __init hugetlb_advanced_tests(struct mm_struct *mm,
-					  struct vm_area_struct *vma,
-					  pte_t *ptep, unsigned long pfn,
-					  unsigned long vaddr, pgprot_t prot)
-{
-	struct page *page = pfn_to_page(pfn);
-	pte_t pte = ptep_get(ptep);
-	unsigned long paddr = __pfn_to_phys(pfn) & PMD_MASK;
-
-	pr_debug("Validating HugeTLB advanced\n");
-	pte = pte_mkhuge(mk_pte(pfn_to_page(PHYS_PFN(paddr)), prot));
-	set_huge_pte_at(mm, vaddr, ptep, pte);
-	barrier();
-	WARN_ON(!pte_same(pte, huge_ptep_get(ptep)));
-	huge_pte_clear(mm, vaddr, ptep, PMD_SIZE);
-	pte = huge_ptep_get(ptep);
-	WARN_ON(!huge_pte_none(pte));
-
-	pte = mk_huge_pte(page, prot);
-	set_huge_pte_at(mm, vaddr, ptep, pte);
-	barrier();
-	huge_ptep_set_wrprotect(mm, vaddr, ptep);
-	pte = huge_ptep_get(ptep);
-	WARN_ON(huge_pte_write(pte));
-
-	pte = mk_huge_pte(page, prot);
-	set_huge_pte_at(mm, vaddr, ptep, pte);
-	barrier();
-	huge_ptep_get_and_clear(mm, vaddr, ptep);
-	pte = huge_ptep_get(ptep);
-	WARN_ON(!huge_pte_none(pte));
-
-	pte = mk_huge_pte(page, prot);
-	pte = huge_pte_wrprotect(pte);
-	set_huge_pte_at(mm, vaddr, ptep, pte);
-	barrier();
-	pte = huge_pte_mkwrite(pte);
-	pte = huge_pte_mkdirty(pte);
-	huge_ptep_set_access_flags(vma, vaddr, ptep, pte, 1);
-	pte = huge_ptep_get(ptep);
-	WARN_ON(!(huge_pte_write(pte) && huge_pte_dirty(pte)));
-}
-#endif
 #else  /* !CONFIG_HUGETLB_PAGE */
 static void __init hugetlb_basic_tests(unsigned long pfn, pgprot_t prot) { }
-static void __init hugetlb_advanced_tests(struct mm_struct *mm,
-					  struct vm_area_struct *vma,
-					  pte_t *ptep, unsigned long pfn,
-					  unsigned long vaddr, pgprot_t prot)
-{
-}
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -1067,10 +1016,6 @@ static int __init debug_vm_pgtable(void)
 	pud_populate_tests(mm, pudp, saved_pmdp);
 	spin_unlock(ptl);
 
-#ifndef CONFIG_PPC_BOOK3S_64
-	hugetlb_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
-#endif
-
 	spin_lock(&mm->page_table_lock);
 	p4d_clear_tests(mm, p4dp);
 	pgd_clear_tests(mm, pgdp);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64.patch

