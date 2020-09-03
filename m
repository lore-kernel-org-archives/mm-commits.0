Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC14C43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74418206CA
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168349;
	bh=KZn2GNILbGG6cptKmG5Nb42EyT/aJA+bRGP/4kT5wkw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=AxXqAqasdcym2HwlpXPrlpq807dpXTdhM+QVtbNQyiCWaTcCt9p93zQrdNGNpSGfe
	 UMqE+SscKFrRSfIrSXHBsghjf0v79LNHZUr5ec2VNB8bqmQDa9ft/+VW+xQDDirZwp
	 SqTGhWgRXQWhQpTjyXPXKEuRHG3I3ZfQWOSeAOv4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgICVZs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbgICVZr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:25:47 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4120206EF;
        Thu,  3 Sep 2020 21:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168346;
        bh=KZn2GNILbGG6cptKmG5Nb42EyT/aJA+bRGP/4kT5wkw=;
        h=Date:From:To:Subject:From;
        b=05DcX2g0H4NQEiPg/ctocx4pJtXVowonYjP1jR1HEWLTTQ4Fv+XxCTGgtHsC23jXa
         McT7YpXTurxC56WQ993XmAQsEdT3cDf9XYS5elOTknvYJSFBK7BAezc8LUpiKNNM2l
         Q2kLUSmdW4gyw6GF4UozrT0Bf7V1sKMUO9dYoTwk=
Date:   Thu, 03 Sep 2020 14:25:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com
Subject:  +
 =?us-ascii?Q?mm-debug=5Fvm=5Fpgtable-set=5Fpte-pmd-pud-dont-use-set=5F=5F?=
 =?us-ascii?Q?at-to-update-an-existing-pte-entry.patch?= added to -mm tree
Message-ID: <20200903212546.dnoW-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/set_pte/pmd/pud: don't use set_*_at to update an existing pte entry
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-set_pte-pmd-pud-dont-use-set__at-to-update-an-existing-pte-entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-set_pte-pmd-pud-dont-use-set__at-to-update-an-existing-pte-entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-set_pte-pmd-pud-dont-use-set__at-to-update-an-existing-pte-entry.patch

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
Subject: mm/debug_vm_pgtable/set_pte/pmd/pud: don't use set_*_at to update an existing pte entry

set_pte_at() should not be used to set a pte entry at locations that
already holds a valid pte entry.  Architectures like ppc64 don't do TLB
invalidate in set_pte_at() and hence expect it to be used to set locations
that are not a valid PTE.

Link: https://lkml.kernel.org/r/20200902114222.181353-8-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-set_pte-pmd-pud-dont-use-set__at-to-update-an-existing-pte-entry
+++ a/mm/debug_vm_pgtable.c
@@ -79,15 +79,18 @@ static void __init pte_advanced_tests(st
 {
 	pte_t pte = pfn_pte(pfn, prot);
 
+	/*
+	 * Architectures optimize set_pte_at by avoiding TLB flush.
+	 * This requires set_pte_at to be not used to update an
+	 * existing pte entry. Clear pte before we do set_pte_at
+	 */
+
 	pr_debug("Validating PTE advanced\n");
 	pte = pfn_pte(pfn, prot);
 	set_pte_at(mm, vaddr, ptep, pte);
 	ptep_set_wrprotect(mm, vaddr, ptep);
 	pte = ptep_get(ptep);
 	WARN_ON(pte_write(pte));
-
-	pte = pfn_pte(pfn, prot);
-	set_pte_at(mm, vaddr, ptep, pte);
 	ptep_get_and_clear(mm, vaddr, ptep);
 	pte = ptep_get(ptep);
 	WARN_ON(!pte_none(pte));
@@ -101,13 +104,11 @@ static void __init pte_advanced_tests(st
 	ptep_set_access_flags(vma, vaddr, ptep, pte, 1);
 	pte = ptep_get(ptep);
 	WARN_ON(!(pte_write(pte) && pte_dirty(pte)));
-
-	pte = pfn_pte(pfn, prot);
-	set_pte_at(mm, vaddr, ptep, pte);
 	ptep_get_and_clear_full(mm, vaddr, ptep, 1);
 	pte = ptep_get(ptep);
 	WARN_ON(!pte_none(pte));
 
+	pte = pfn_pte(pfn, prot);
 	pte = pte_mkyoung(pte);
 	set_pte_at(mm, vaddr, ptep, pte);
 	ptep_test_and_clear_young(vma, vaddr, ptep);
@@ -169,9 +170,6 @@ static void __init pmd_advanced_tests(st
 	pmdp_set_wrprotect(mm, vaddr, pmdp);
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(pmd_write(pmd));
-
-	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
-	set_pmd_at(mm, vaddr, pmdp, pmd);
 	pmdp_huge_get_and_clear(mm, vaddr, pmdp);
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(!pmd_none(pmd));
@@ -185,13 +183,11 @@ static void __init pmd_advanced_tests(st
 	pmdp_set_access_flags(vma, vaddr, pmdp, pmd, 1);
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(!(pmd_write(pmd) && pmd_dirty(pmd)));
-
-	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
-	set_pmd_at(mm, vaddr, pmdp, pmd);
 	pmdp_huge_get_and_clear_full(vma, vaddr, pmdp, 1);
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(!pmd_none(pmd));
 
+	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
 	pmd = pmd_mkyoung(pmd);
 	set_pmd_at(mm, vaddr, pmdp, pmd);
 	pmdp_test_and_clear_young(vma, vaddr, pmdp);
@@ -292,17 +288,9 @@ static void __init pud_advanced_tests(st
 	WARN_ON(pud_write(pud));
 
 #ifndef __PAGETABLE_PMD_FOLDED
-	pud = pud_mkhuge(pfn_pud(pfn, prot));
-	set_pud_at(mm, vaddr, pudp, pud);
 	pudp_huge_get_and_clear(mm, vaddr, pudp);
 	pud = READ_ONCE(*pudp);
 	WARN_ON(!pud_none(pud));
-
-	pud = pud_mkhuge(pfn_pud(pfn, prot));
-	set_pud_at(mm, vaddr, pudp, pud);
-	pudp_huge_get_and_clear_full(mm, vaddr, pudp, 1);
-	pud = READ_ONCE(*pudp);
-	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
 
 	pud = pud_mkhuge(pfn_pud(pfn, prot));
@@ -315,6 +303,13 @@ static void __init pud_advanced_tests(st
 	pud = READ_ONCE(*pudp);
 	WARN_ON(!(pud_write(pud) && pud_dirty(pud)));
 
+#ifndef __PAGETABLE_PMD_FOLDED
+	pudp_huge_get_and_clear_full(mm, vaddr, pudp, 1);
+	pud = READ_ONCE(*pudp);
+	WARN_ON(!pud_none(pud));
+#endif /* __PAGETABLE_PMD_FOLDED */
+
+	pud = pud_mkhuge(pfn_pud(pfn, prot));
 	pud = pud_mkyoung(pud);
 	set_pud_at(mm, vaddr, pudp, pud);
 	pudp_test_and_clear_young(vma, vaddr, pudp);
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

