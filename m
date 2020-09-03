Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EF8C43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0B8C206EF
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168337;
	bh=DEq1pQiS73pRpSFROg6LtLzkQw8+vKLr0R11Y7CJONU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CIPwNFkBT+RIymzEiL0DO0t+Wr0HqjvwTxIbkuQrDBhHgs1Iv4hEhQRqjq0jpLcRD
	 sF6gXPU5SoElGiDsMxKO5KNACeiUTWeq7LH2zsCo/XhbfW4M5yP8sty6j4gBkfIYdo
	 +kyriBO9IaL9lCOXtNQfu86IMfdW+e+P+uk3tLHU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgICVZg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgICVZf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:25:35 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3841206D4;
        Thu,  3 Sep 2020 21:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168334;
        bh=DEq1pQiS73pRpSFROg6LtLzkQw8+vKLr0R11Y7CJONU=;
        h=Date:From:To:Subject:From;
        b=Id+4qbi1NkG0c6YmfU9r1rFjqJyKxQMZ/DYNQ7TzGaTEqTKBlFCHjV2ybEbUy8j4V
         len4yFCRGRcL/cS9RRiYcQSvO0XYa2kJ5GZ4VQ7HiNM0KjTwA4luFCNYqv64Vj1vNj
         z47jOjUOuYdLuqepI4UJhaktvobN31s6/grm1x9M=
Date:   Thu, 03 Sep 2020 14:25:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com
Subject:  +
 powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch added to -mm tree
Message-ID: <20200903212534.xE8PW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: move setting pte specific flags to pfn_pte
has been added to the -mm tree.  Its filename is
     powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mm: move setting pte specific flags to pfn_pte

powerpc used to set the pte specific flags in set_pte_at().  This is
different from other architectures.  To be consistent with other
architecture update pfn_pte to set _PAGE_PTE on ppc64.  Also, drop now
unused pte_mkpte.

We add a VM_WARN_ON() to catch the usage of calling set_pte_at() without
setting _PAGE_PTE bit.  We will remove that after a few releases.

With respect to huge pmd entries, pmd_mkhuge() takes care of adding the
_PAGE_PTE bit.

Link: https://lkml.kernel.org/r/20200902114222.181353-3-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |   15 +++++++++------
 arch/powerpc/include/asm/nohash/pgtable.h    |    5 -----
 arch/powerpc/mm/pgtable.c                    |    5 -----
 3 files changed, 9 insertions(+), 16 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -615,7 +615,7 @@ static inline pte_t pfn_pte(unsigned lon
 	VM_BUG_ON(pfn >> (64 - PAGE_SHIFT));
 	VM_BUG_ON((pfn << PAGE_SHIFT) & ~PTE_RPN_MASK);
 
-	return __pte(((pte_basic_t)pfn << PAGE_SHIFT) | pgprot_val(pgprot));
+	return __pte(((pte_basic_t)pfn << PAGE_SHIFT) | pgprot_val(pgprot) | _PAGE_PTE);
 }
 
 static inline unsigned long pte_pfn(pte_t pte)
@@ -651,11 +651,6 @@ static inline pte_t pte_mkexec(pte_t pte
 	return __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_EXEC));
 }
 
-static inline pte_t pte_mkpte(pte_t pte)
-{
-	return __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_PTE));
-}
-
 static inline pte_t pte_mkwrite(pte_t pte)
 {
 	/*
@@ -819,6 +814,14 @@ static inline int pte_none(pte_t pte)
 static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte, int percpu)
 {
+
+	VM_WARN_ON(!(pte_raw(pte) & cpu_to_be64(_PAGE_PTE)));
+	/*
+	 * Keep the _PAGE_PTE added till we are sure we handle _PAGE_PTE
+	 * in all the callers.
+	 */
+	 pte = __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_PTE));
+
 	if (radix_enabled())
 		return radix__set_pte_at(mm, addr, ptep, pte, percpu);
 	return hash__set_pte_at(mm, addr, ptep, pte, percpu);
--- a/arch/powerpc/include/asm/nohash/pgtable.h~powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte
+++ a/arch/powerpc/include/asm/nohash/pgtable.h
@@ -140,11 +140,6 @@ static inline pte_t pte_mkold(pte_t pte)
 	return __pte(pte_val(pte) & ~_PAGE_ACCESSED);
 }
 
-static inline pte_t pte_mkpte(pte_t pte)
-{
-	return pte;
-}
-
 static inline pte_t pte_mkspecial(pte_t pte)
 {
 	return __pte(pte_val(pte) | _PAGE_SPECIAL);
--- a/arch/powerpc/mm/pgtable.c~powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte
+++ a/arch/powerpc/mm/pgtable.c
@@ -184,9 +184,6 @@ void set_pte_at(struct mm_struct *mm, un
 	 */
 	VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));
 
-	/* Add the pte bit when trying to set a pte */
-	pte = pte_mkpte(pte);
-
 	/* Note: mm->context.id might not yet have been assigned as
 	 * this context might not have been activated yet when this
 	 * is called.
@@ -275,8 +272,6 @@ void set_huge_pte_at(struct mm_struct *m
 	 */
 	VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));
 
-	pte = pte_mkpte(pte);
-
 	pte = set_pte_filter(pte);
 
 	val = pte_val(pte);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

powerpc-mm-add-debug_vm-warn-for-pmd_clear.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch
mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value.patch
mm-debug_vm_pgtables-hugevmap-use-the-arch-helper-to-identify-huge-vmap-support.patch
mm-debug_vm_pgtable-savedwrite-enable-savedwrite-test-with-config_numa_balancing.patch
mm-debug_vm_pgtable-thp-mark-the-pte-entry-huge-before-using-set_pmd-pud_at.patch
mm-debug_vm_pgtable-set_pte-pmd-pud-dont-use-set__at-to-update-an-existing-pte-entry.patch
mm-debug_vm_pgtable-locks-move-non-page-table-modifying-test-together.patch
mm-debug_vm_pgtable-locks-take-correct-page-table-lock.patch
mm-debug_vm_pgtable-thp-use-page-table-depost-withdraw-with-thp.patch
mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries.patch
mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64.patch
mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test.patch

