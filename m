Return-Path: <SRS0=MO2u=DC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD52C4346E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0A7520EDD
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601001904;
	bh=sTRdmbpmqR0Z2JGmk7hl7/1blaioraC1t8ujVM6oz/0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ub5p4bNhVbRHeX98hHRw/1HEyqtE1SuTCL5jGbtsWoh0seqWeJmBK6h9JTbAF6eAE
	 HgzXKv2l7BZuoC5BAY0HNM1cs8JQvg2aqsgyWrWZ2C2QgmnWbQSWGAj0AYgPrO5g7d
	 FoVDdxWo5uHY09x25jhAAkV1sVmQgfVGG0GVvLPo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgIYCpE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Sep 2020 22:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbgIYCpE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Sep 2020 22:45:04 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEE8520809;
        Fri, 25 Sep 2020 02:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601001903;
        bh=sTRdmbpmqR0Z2JGmk7hl7/1blaioraC1t8ujVM6oz/0=;
        h=Date:From:To:Subject:From;
        b=PxK22EzKbNlJtzEbsgZ4AskvZVuZGN8lWnrHkARYBfgr/VeYf32QUqIKJfcWvgfoo
         DI3JSSdNlHvGb5V712cSecKxRmIq5ONBFqP1DcvZ5xKP4asp3We2AYZ/6pJL6lWpiQ
         BZjtw3IhDhsifUx/rwNTitTMlzIpWpE1iwAPPIek=
Date:   Thu, 24 Sep 2020 19:45:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, gerald.schaefer@linux.ibm.com,
        christophe.leroy@csgroup.eu, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com
Subject:  +
 mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64-fix.patch added to
 -mm tree
Message-ID: <20200925024502.bdAdI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: drop hugetlb_advanced_tests()
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64-fix.patch

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

mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64-fix.patch

