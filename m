Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC61C433E2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B98206E7
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168354;
	bh=5h88aW0/eeMwzpel+fiuqIelT3O1yImjMeVDEH929Zw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DIMcmd2lCbx+ujP6PkE4MjrNyttCp+pJNiAQ6q10vT0lg1/gp0f+oMA2MSKGhdWqR
	 8hT5QhVGDDvTyPVjfISa9URc2zQVznOp1cdnohUm/Fx21oIq9ohz+3rDHyGTWG3WkS
	 60rDUZ2477SvfAc/9e1l6EZt9JA6awaYQltjm5UU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgICVZy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728436AbgICVZx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:25:53 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96D82206D4;
        Thu,  3 Sep 2020 21:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168352;
        bh=5h88aW0/eeMwzpel+fiuqIelT3O1yImjMeVDEH929Zw=;
        h=Date:From:To:Subject:From;
        b=lfvUfrctkYgj9A6rHDA3nbJrQe5UmAggs5Sxx4cR5KWbRlX/dEQxWEl1WDHgaVhF5
         u5MdED9KrTkd1wkU7LLeo4y6qVU0CfRagB3F2HU+CHzSbVw6hTFgC0S0mY1qDwNwET
         KV2ei37zmiOeBNpRoR9UEkFxu37OzB8SgA2iWQ98=
Date:   Thu, 03 Sep 2020 14:25:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com
Subject:  +
 mm-debug_vm_pgtable-thp-use-page-table-depost-withdraw-with-thp.patch added
 to -mm tree
Message-ID: <20200903212552.o4Xct%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/thp: use page table depost/withdraw with THP
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-thp-use-page-table-depost-withdraw-with-thp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-thp-use-page-table-depost-withdraw-with-thp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-thp-use-page-table-depost-withdraw-with-thp.patch

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
Subject: mm/debug_vm_pgtable/thp: use page table depost/withdraw with THP

Architectures like ppc64 use deposited page table while updating the huge
pte entries.

Link: https://lkml.kernel.org/r/20200902114222.181353-11-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-thp-use-page-table-depost-withdraw-with-thp
+++ a/mm/debug_vm_pgtable.c
@@ -154,7 +154,7 @@ static void __init pmd_basic_tests(unsig
 static void __init pmd_advanced_tests(struct mm_struct *mm,
 				      struct vm_area_struct *vma, pmd_t *pmdp,
 				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot)
+				      pgprot_t prot, pgtable_t pgtable)
 {
 	pmd_t pmd;
 
@@ -165,6 +165,8 @@ static void __init pmd_advanced_tests(st
 	/* Align the address wrt HPAGE_PMD_SIZE */
 	vaddr = (vaddr & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE;
 
+	pgtable_trans_huge_deposit(mm, pmdp, pgtable);
+
 	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
 	set_pmd_at(mm, vaddr, pmdp, pmd);
 	pmdp_set_wrprotect(mm, vaddr, pmdp);
@@ -193,6 +195,8 @@ static void __init pmd_advanced_tests(st
 	pmdp_test_and_clear_young(vma, vaddr, pmdp);
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(pmd_young(pmd));
+
+	pgtable = pgtable_trans_huge_withdraw(mm, pmdp);
 }
 
 static void __init pmd_leaf_tests(unsigned long pfn, pgprot_t prot)
@@ -371,7 +375,7 @@ static void __init pud_basic_tests(unsig
 static void __init pmd_advanced_tests(struct mm_struct *mm,
 				      struct vm_area_struct *vma, pmd_t *pmdp,
 				      unsigned long pfn, unsigned long vaddr,
-				      pgprot_t prot)
+				      pgprot_t prot, pgtable_t pgtable)
 {
 }
 static void __init pud_advanced_tests(struct mm_struct *mm,
@@ -1048,7 +1052,7 @@ static int __init debug_vm_pgtable(void)
 
 	ptl = pmd_lock(mm, pmdp);
 	pmd_clear_tests(mm, pmdp);
-	pmd_advanced_tests(mm, vma, pmdp, pmd_aligned, vaddr, prot);
+	pmd_advanced_tests(mm, vma, pmdp, pmd_aligned, vaddr, prot, saved_ptep);
 	pmd_huge_tests(pmdp, pmd_aligned, prot);
 	pmd_populate_tests(mm, pmdp, saved_ptep);
 	spin_unlock(ptl);
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

