Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD701C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83CE6216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881259;
	bh=2F9TKbxWAv6FAsPh43ZPLyUxrffRaKgBblGP5MsF9Z4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xAdjWJVbdbemM9xea663ED/3EtYaMcUs10s4lcHcfeKZUhVICGcOt3xD8Amis8NPz
	 i5VZ9O6x2fL2U8bzQ3Q4jodGJP3fpXscGNfqKnBxJVCrcOdMacD7JaqvQmXuf8L4bO
	 2VIbzWNVaYq8LDLIV9il3Zl4j9BFGeVN0Y61frcI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391648AbgJPUri (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391117AbgJPUri (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:47:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4C1D2145D;
        Fri, 16 Oct 2020 20:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881258;
        bh=2F9TKbxWAv6FAsPh43ZPLyUxrffRaKgBblGP5MsF9Z4=;
        h=Date:From:To:Subject:From;
        b=g49ZOov/pD4AnWL5Wpofjunm57VRvf6nzY5zUQLiw9lwe5GVEFNOqCuAIX1p9TQw+
         0CCciLHhK6KuB1Lgq0b0ROyZEcZKb8tkKUEZ2m1h/hiI6SGra3L5gbVnx8O35pE2tJ
         gEal3H59DsoRqPvoeqFpH0hNf2mp6WRFtHkZ0c9s=
Date:   Fri, 16 Oct 2020 13:47:37 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au
Subject:  [merged]
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-set=5Fpte-pmd-pud-dont-use-set=5F=5F?=
 =?US-ASCII?Q?at-to-update-an-existing-pte-entry.patch?= removed from -mm
 tree
Message-ID: <20201016204737.kwclj3F9F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/set_pte/pmd/pud: don't use set_*_at to update an existing pte entry
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-set_pte-pmd-pud-dont-use-set__at-to-update-an-existing-pte-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/set_pte/pmd/pud: don't use set_*_at to update an existing pte entry

set_pte_at() should not be used to set a pte entry at locations that
already holds a valid pte entry.  Architectures like ppc64 don't do TLB
invalidate in set_pte_at() and hence expect it to be used to set locations
that are not a valid PTE.

Link: https://lkml.kernel.org/r/20200902114222.181353-8-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
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


