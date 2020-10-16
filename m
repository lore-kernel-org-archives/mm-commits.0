Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57C7C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88FC920878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817495;
	bh=w9k448aA6A/hhRrd1A8IOBr9/yYNOl+sdi+ZSsFlIIk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=usijq1lpjFBE0Pj1HSWfGaWFyp6qQOuFozff/XW6gqqYLEMers5wLYOd3gO8n6Bid
	 Zd9Efg7blE6SLSbK8NbyMM6HzUU1DgWR9lSw6RsIHcZDbipgGM7Ar3gS0vlzY1cA8v
	 Uf3HNvElngNBhZmLNvNzrqRruEgs1sRy2IMA3CLg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392031AbgJPDEz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDEy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:04:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0BCF2087D;
        Fri, 16 Oct 2020 03:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817494;
        bh=w9k448aA6A/hhRrd1A8IOBr9/yYNOl+sdi+ZSsFlIIk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sa4BgVRtrn99a3nKLl0HG1D0A8HuufdcRBiAkDl3DwDakaRG7Y4CuWRiS8Clmxubo
         dkSm0PeMEmQU0icLiwrZWfCZTnfPaIRLA5uribF3o850IY0kuqyUY6zSkYPiZ76AWE
         ohgk1WPGHiv95Uncv6BF07L5M9it/EVbvxObQyNo=
Date:   Thu, 15 Oct 2020 20:04:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 010/156] mm/debug_vm_pgtable/locks: take correct
 page table lock
Message-ID: <20201016030453.liTVXpxTW%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/locks: take correct page table lock

Make sure we call pte accessors with correct lock held.

Link: https://lkml.kernel.org/r/20200902114222.181353-10-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-locks-take-correct-page-table-lock
+++ a/mm/debug_vm_pgtable.c
@@ -1035,30 +1035,39 @@ static int __init debug_vm_pgtable(void)
 
 	hugetlb_basic_tests(pte_aligned, prot);
 
-	pte_clear_tests(mm, ptep, vaddr);
-	pmd_clear_tests(mm, pmdp);
-	pud_clear_tests(mm, pudp);
-	p4d_clear_tests(mm, p4dp);
-	pgd_clear_tests(mm, pgdp);
+	/*
+	 * Page table modifying tests. They need to hold
+	 * proper page table lock.
+	 */
 
 	ptl = pte_lockptr(mm, pmdp);
 	spin_lock(ptl);
-
+	pte_clear_tests(mm, ptep, vaddr);
 	pte_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
-	pmd_advanced_tests(mm, vma, pmdp, pmd_aligned, vaddr, prot);
-	pud_advanced_tests(mm, vma, pudp, pud_aligned, vaddr, prot);
-	hugetlb_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
-
+	pte_unmap_unlock(ptep, ptl);
 
+	ptl = pmd_lock(mm, pmdp);
+	pmd_clear_tests(mm, pmdp);
+	pmd_advanced_tests(mm, vma, pmdp, pmd_aligned, vaddr, prot);
 	pmd_huge_tests(pmdp, pmd_aligned, prot);
+	pmd_populate_tests(mm, pmdp, saved_ptep);
+	spin_unlock(ptl);
+
+	ptl = pud_lock(mm, pudp);
+	pud_clear_tests(mm, pudp);
+	pud_advanced_tests(mm, vma, pudp, pud_aligned, vaddr, prot);
 	pud_huge_tests(pudp, pud_aligned, prot);
+	pud_populate_tests(mm, pudp, saved_pmdp);
+	spin_unlock(ptl);
 
-	pte_unmap_unlock(ptep, ptl);
+	hugetlb_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
 
-	pmd_populate_tests(mm, pmdp, saved_ptep);
-	pud_populate_tests(mm, pudp, saved_pmdp);
+	spin_lock(&mm->page_table_lock);
+	p4d_clear_tests(mm, p4dp);
+	pgd_clear_tests(mm, pgdp);
 	p4d_populate_tests(mm, p4dp, saved_pudp);
 	pgd_populate_tests(mm, pgdp, saved_p4dp);
+	spin_unlock(&mm->page_table_lock);
 
 	p4d_free(mm, saved_p4dp);
 	pud_free(mm, saved_pudp);
_
