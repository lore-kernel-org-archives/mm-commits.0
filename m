Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD19DC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B85821655
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881268;
	bh=DOntC81GM0RnPqOQfYF3NDUXDVnDzGGvTkLChLEQJWE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mP/6jQW6lWRkPMS8B7N39QUQuOSIWhALE02SYohTTetUwHuIbGM2rOZ+5Kg2otDJL
	 AcUioXmBbW0MYB2uk65FYX//CkEZf+P9od+vRD2jdNNQqkt7c/rz/6GWzeSAnpHATP
	 wL9IJxJ2kcg3cpGsncDryHpGXIezkW1OEUMfEPgc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392573AbgJPUrs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391117AbgJPUrr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:47:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFDD82145D;
        Fri, 16 Oct 2020 20:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881267;
        bh=DOntC81GM0RnPqOQfYF3NDUXDVnDzGGvTkLChLEQJWE=;
        h=Date:From:To:Subject:From;
        b=JL+7E5RC72oGpaVDjgk0LnK9/F6+Y8YBD79cu6MdDbDFK4pBpE+zgJLAagwv884+I
         mbyST55GEoiavjhL7/mhIm9ul2Uzw0mDizYMkrMxfC5YuDKk/Nda7q0rWiyZNmLh2i
         EOptuhdGym8neTPUWmyphf61ayqzPAjkDvTF63dA=
Date:   Fri, 16 Oct 2020 13:47:46 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au
Subject:  [merged]
 mm-debug_vm_pgtable-thp-use-page-table-depost-withdraw-with-thp.patch
 removed from -mm tree
Message-ID: <20201016204746.5wCHvRVwo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/thp: use page table depost/withdraw with THP
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-thp-use-page-table-depost-withdraw-with-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/thp: use page table depost/withdraw with THP

Architectures like ppc64 use deposited page table while updating the huge
pte entries.

Link: https://lkml.kernel.org/r/20200902114222.181353-11-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
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


