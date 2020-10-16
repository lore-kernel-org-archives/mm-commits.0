Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4142EC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E461D2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817490;
	bh=R8MvZO8HFgDtthPWLbBLJPixYMX4AjnweHkHRwnPqGA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=f227ZRVUrRHgBZcvIBRsKmyyp1/dM73P4uEfYGu5QrzflveEfO1C7BVELpBjw8XFy
	 FNrp0laKHsja0o3VwQkNeGQHmeZl3doeLfW/oK/J4Zui2WrmwssexvOZNdqc50YItu
	 M0FeSIlk4aBo6IANgUMA4Bqx9wkaL+xP86NOd320=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389017AbgJPDEt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDEt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:04:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A56720878;
        Fri, 16 Oct 2020 03:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817487;
        bh=R8MvZO8HFgDtthPWLbBLJPixYMX4AjnweHkHRwnPqGA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hJUOZYC5y5u2BwbMpDY6rXRUWZfKpAofY31Rk3jMeQv0WjqU2Hln1mtXEIvPjUNrV
         KsHTMl6YVtRRl/8PfaiLNwYlzWBOGpKAkVxvMi1dBryovXc/WGM04VE7OgLjUNIqz1
         hs3GoCKNmAvlB61xqDQ6Cl9yKSUB9/+uJDeRqOjQ=
Date:   Thu, 15 Oct 2020 20:04:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 008/156] mm/debug_vm_pgtable/set_pte/pmd/pud:
 don't use set_*_at to update an existing pte entry
Message-ID: <20201016030446.tCgbGXj1w%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
