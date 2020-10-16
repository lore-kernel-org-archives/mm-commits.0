Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25B4C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D4CD20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817492;
	bh=a+Q6tng9yEJEn0c9F53t+CcwARLlRM+MRIb0jQg5DMU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=PbaWFEMV0KchbTkeifYV22ZCegoPbzRAmERnN6Os7n2RdQ8r2JBeBjHawI5RNhjV3
	 ETVKUCYNyr69jfNB2Hk3UF2yZR2BcaARQ/VZx73puVE8sbV9Amb3hc6Tc4WbRqUYcM
	 EB/aSKDFJPxXpacVsolYETtS5Lee276R01iL8p1Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389928AbgJPDEw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDEv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:04:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A8B720789;
        Fri, 16 Oct 2020 03:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817490;
        bh=a+Q6tng9yEJEn0c9F53t+CcwARLlRM+MRIb0jQg5DMU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GoVHQl/UMmRaHWjrF6D1aku7Np1BL4thMVfrFwCVOCPmqUCr6nmb89sJlVBxiRxYN
         3lNLa41KBga/SWbrGVp3FBSmhOXUbBNiOEB4chuqVQoYrs9UtWetvrrnYD/HQVEmmT
         miUGhVdrBokUA/CzVT+KTTJjXdSlyLqEy4gkycPI=
Date:   Thu, 15 Oct 2020 20:04:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 009/156] mm/debug_vm_pgtable/locks: move non page
 table modifying test together
Message-ID: <20201016030449.zcTGKU6Yz%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/locks: move non page table modifying test together

This will help in adding proper locks in a later patch

Link: https://lkml.kernel.org/r/20200902114222.181353-9-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   51 +++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-locks-move-non-page-table-modifying-test-together
+++ a/mm/debug_vm_pgtable.c
@@ -986,7 +986,7 @@ static int __init debug_vm_pgtable(void)
 	p4dp = p4d_alloc(mm, pgdp, vaddr);
 	pudp = pud_alloc(mm, p4dp, vaddr);
 	pmdp = pmd_alloc(mm, pudp, vaddr);
-	ptep = pte_alloc_map_lock(mm, pmdp, vaddr, &ptl);
+	ptep = pte_alloc_map(mm, pmdp, vaddr);
 
 	/*
 	 * Save all the page table page addresses as the page table
@@ -1006,33 +1006,12 @@ static int __init debug_vm_pgtable(void)
 	p4d_basic_tests(p4d_aligned, prot);
 	pgd_basic_tests(pgd_aligned, prot);
 
-	pte_clear_tests(mm, ptep, vaddr);
-	pmd_clear_tests(mm, pmdp);
-	pud_clear_tests(mm, pudp);
-	p4d_clear_tests(mm, p4dp);
-	pgd_clear_tests(mm, pgdp);
-
-	pte_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
-	pmd_advanced_tests(mm, vma, pmdp, pmd_aligned, vaddr, prot);
-	pud_advanced_tests(mm, vma, pudp, pud_aligned, vaddr, prot);
-	hugetlb_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
-
 	pmd_leaf_tests(pmd_aligned, prot);
 	pud_leaf_tests(pud_aligned, prot);
 
-	pmd_huge_tests(pmdp, pmd_aligned, prot);
-	pud_huge_tests(pudp, pud_aligned, prot);
-
 	pte_savedwrite_tests(pte_aligned, protnone);
 	pmd_savedwrite_tests(pmd_aligned, protnone);
 
-	pte_unmap_unlock(ptep, ptl);
-
-	pmd_populate_tests(mm, pmdp, saved_ptep);
-	pud_populate_tests(mm, pudp, saved_pmdp);
-	p4d_populate_tests(mm, p4dp, saved_pudp);
-	pgd_populate_tests(mm, pgdp, saved_p4dp);
-
 	pte_special_tests(pte_aligned, prot);
 	pte_protnone_tests(pte_aligned, protnone);
 	pmd_protnone_tests(pmd_aligned, protnone);
@@ -1050,11 +1029,37 @@ static int __init debug_vm_pgtable(void)
 	pmd_swap_tests(pmd_aligned, prot);
 
 	swap_migration_tests();
-	hugetlb_basic_tests(pte_aligned, prot);
 
 	pmd_thp_tests(pmd_aligned, prot);
 	pud_thp_tests(pud_aligned, prot);
 
+	hugetlb_basic_tests(pte_aligned, prot);
+
+	pte_clear_tests(mm, ptep, vaddr);
+	pmd_clear_tests(mm, pmdp);
+	pud_clear_tests(mm, pudp);
+	p4d_clear_tests(mm, p4dp);
+	pgd_clear_tests(mm, pgdp);
+
+	ptl = pte_lockptr(mm, pmdp);
+	spin_lock(ptl);
+
+	pte_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
+	pmd_advanced_tests(mm, vma, pmdp, pmd_aligned, vaddr, prot);
+	pud_advanced_tests(mm, vma, pudp, pud_aligned, vaddr, prot);
+	hugetlb_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
+
+
+	pmd_huge_tests(pmdp, pmd_aligned, prot);
+	pud_huge_tests(pudp, pud_aligned, prot);
+
+	pte_unmap_unlock(ptep, ptl);
+
+	pmd_populate_tests(mm, pmdp, saved_ptep);
+	pud_populate_tests(mm, pudp, saved_pmdp);
+	p4d_populate_tests(mm, p4dp, saved_pudp);
+	pgd_populate_tests(mm, pgdp, saved_p4dp);
+
 	p4d_free(mm, saved_p4dp);
 	pud_free(mm, saved_pudp);
 	pmd_free(mm, saved_pmdp);
_
