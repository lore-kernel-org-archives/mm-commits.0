Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293E3C07548
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE818206CA
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168362;
	bh=kTDRlzIMWvfhO3hqnMyX6CDOvtEUNpLRVBL29B8Qzew=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=U2eNnFnx+MHiaJoBnMHbnBr2y/3mejH5rG/3yqI2xKD35B/bdEGh6n+YgUEEzxNtH
	 xYzqE3izg3JUu3g/YPVfVrHHl6GpmpPqN+UbdvKN9VTzMzjPVbOT4qs4T+hbi+61wh
	 VKQmHwTvsYTAsDt3ralD9BGr7EFXzBPTVgzinTFY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgICV0B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728436AbgICVZ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:25:59 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E58020709;
        Thu,  3 Sep 2020 21:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168358;
        bh=kTDRlzIMWvfhO3hqnMyX6CDOvtEUNpLRVBL29B8Qzew=;
        h=Date:From:To:Subject:From;
        b=XHKaWVN8sHFjIJXvkeCmEx38vc+UKke12WgTrVsviaDY/GIr4PJvJNNbRgVCVA3S0
         5nl6WWB6RFlpaWhpAJ+0e3b0i7L5BAmCSKbRlfH9LdZ3u5X7NRqazaXTg42xWI8V5P
         BEs1emNsF7ju5T5X9rRozVwScDTWst2t/bC8jfDw=
Date:   Thu, 03 Sep 2020 14:25:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com
Subject:  +
 mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test.patch added to -mm tree
Message-ID: <20200903212558.vag10%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: avoid none pte in pte_clear_test
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test.patch

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
Subject: mm/debug_vm_pgtable: avoid none pte in pte_clear_test

pte_clear_tests operate on an existing pte entry.  Make sure that is not a
none pte entry.

Link: https://lkml.kernel.org/r/20200902114222.181353-14-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test
+++ a/mm/debug_vm_pgtable.c
@@ -542,9 +542,10 @@ static void __init pgd_populate_tests(st
 #endif /* PAGETABLE_P4D_FOLDED */
 
 static void __init pte_clear_tests(struct mm_struct *mm, pte_t *ptep,
-				   unsigned long vaddr)
+				   unsigned long pfn, unsigned long vaddr,
+				   pgprot_t prot)
 {
-	pte_t pte = ptep_get(ptep);
+	pte_t pte = pfn_pte(pfn, prot);
 
 	pr_debug("Validating PTE clear\n");
 	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
@@ -1049,7 +1050,7 @@ static int __init debug_vm_pgtable(void)
 
 	ptl = pte_lockptr(mm, pmdp);
 	spin_lock(ptl);
-	pte_clear_tests(mm, ptep, vaddr);
+	pte_clear_tests(mm, ptep, pte_aligned, vaddr, prot);
 	pte_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
 	pte_unmap_unlock(ptep, ptl);
 
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

