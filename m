Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC8FC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0668214DB
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881262;
	bh=OT1vxTDRU6SHAFn5hnehnFLP5JRvZzPFCGk0p1sNGW8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TtHWVlW0vr4hbFgE6k3G0u6XQ9tP1SIJxAZv1tGgz+aO6BvZS5X1GdzNlExIJHTnZ
	 SslMMpiY4koo4WbUzmURugdWdqJI4Bxvhfa0SDDrgGPwIdJ9tndhcfElszX603+5uV
	 CAX2Z1DuqL8vSGzt9gll48qojHh23N9sWfFQj5F0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391975AbgJPUrm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391117AbgJPUrm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:47:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBCE021655;
        Fri, 16 Oct 2020 20:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881261;
        bh=OT1vxTDRU6SHAFn5hnehnFLP5JRvZzPFCGk0p1sNGW8=;
        h=Date:From:To:Subject:From;
        b=DYMRViavnHMCsTMeiOBNGJKWYE2rwASn/ZD/59aAje1zetYgt/TgrljzfGXUdQNNe
         5JDvNQpRcyBGDVsxSQ6wXtcZqtnDGpHV2i08iMVVCXpgntzgltTyd9NtgN8uvrBKQV
         i/CnBfpIGSWaqe5kMQCVIqYjTG6/ZPWL99ypgJ4g=
Date:   Fri, 16 Oct 2020 13:47:40 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au
Subject:  [merged]
 mm-debug_vm_pgtable-locks-move-non-page-table-modifying-test-together.patch
 removed from -mm tree
Message-ID: <20201016204740.ZlMXpQBKU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/locks: move non page table modifying test together
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-locks-move-non-page-table-modifying-test-together.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


