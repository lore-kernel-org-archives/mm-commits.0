Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2EDC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5279120897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816104;
	bh=2MmKW2JhmIMFZIOpDejchO9il/DiQmYY5LeKIrTs+UQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=WsTfhvW4GENsVDFYVIBqThzgU+jZz8fqUJz1aO4izkJd3s4yTg7AjB7g3wzLV/vZe
	 vq/s+9f4xU8BDVGLaRW+orgxcrthnBgzFb5pv2ifaOItecDQkVXiBjHh3QKd+ddJ61
	 NTs+7EoKcVceudk8T32Zzzw9TWaDzJbNpiwS499E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732990AbgJPClo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgJPCln (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:41:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4FF72087D;
        Fri, 16 Oct 2020 02:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816103;
        bh=2MmKW2JhmIMFZIOpDejchO9il/DiQmYY5LeKIrTs+UQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JPsdi8E6G5+IG1tI1vHCMvJ5qdMmBVxCac9vqwoPaukhb0kLgF6dcZnJUuewsx9Fq
         OLurv7kLcZMkpHSnX07zUEa9qmZ0n7OUwZbc59/qtCbgxtAo+VhAsACzYq3KUxg6xZ
         p0cVRZ9LsFMB+HD3lN+mJOIJLGvd0vA4ndgywylA=
Date:   Thu, 15 Oct 2020 19:41:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 013/156] mm/debug_vm_pgtable/hugetlb: disable
 hugetlb test on ppc64
Message-ID: <20201016024142.AFENONcbw%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/hugetlb: disable hugetlb test on ppc64

The seems to be missing quite a lot of details w.r.t allocating the
correct pgtable_t page (huge_pte_alloc()), holding the right lock
(huge_pte_lock()) etc.  The vma used is also not a hugetlb VMA.

ppc64 do have runtime checks within CONFIG_DEBUG_VM for most of these. 
Hence disable the test on ppc64.

[anshuman.khandual@arm.com: drop hugetlb_advanced_tests()]
  Link: https://lore.kernel.org/lkml/289c3fdb-1394-c1af-bdc4-5542907089dc@linux.ibm.com/#t
  Link: https://lkml.kernel.org/r/1600914446-21890-1-git-send-email-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/20200902114222.181353-13-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   51 ----------------------------------------
 1 file changed, 51 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64
+++ a/mm/debug_vm_pgtable.c
@@ -810,57 +810,8 @@ static void __init hugetlb_basic_tests(u
 	WARN_ON(!pte_huge(pte_mkhuge(pte)));
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 }
-
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
@@ -1065,8 +1016,6 @@ static int __init debug_vm_pgtable(void)
 	pud_populate_tests(mm, pudp, saved_pmdp);
 	spin_unlock(ptl);
 
-	hugetlb_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
-
 	spin_lock(&mm->page_table_lock);
 	p4d_clear_tests(mm, p4dp);
 	pgd_clear_tests(mm, pgdp);
_
