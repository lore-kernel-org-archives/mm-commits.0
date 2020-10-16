Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3A1C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F75420897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817498;
	bh=Nb9tQGDI8yHhkaGfKu7Xm2mtYuc1EFEfYccGxgvNkBI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=F54glJ2PBvvTgG+P1nBrcFJH0AB4YgIjKdvEHmFgXBeSRQrE/iqBaZR9VAXEkEJhq
	 b5+X4R7zby1EG5Zag1FfS7STZfW8xhXYXF/NYR1coumgx4UDwdZRkPU6EaEtab6XIX
	 /bvgELW1QC4C7e78L+7jfQSBuH6jMitt1fowB4D4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392129AbgJPDE6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDE6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:04:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25F6C20789;
        Fri, 16 Oct 2020 03:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817497;
        bh=Nb9tQGDI8yHhkaGfKu7Xm2mtYuc1EFEfYccGxgvNkBI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ewyyvFffkJzIaSs8TjuROlUbfjCETUvrOl78ns49Pt66AbvRlzkp12Nq9ui2Id9tD
         NHc41Z1FK8oyXTwGeOa8iVdyN4bre3bv+PPO8e0FcyzzhlNwNn8CPWpkghpiOG2149
         PBVhFwMIfutbWddoSmdo1fIPDEaVZFbS4KLIs53s=
Date:   Thu, 15 Oct 2020 20:04:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 011/156] mm/debug_vm_pgtable/thp: use page table
 depost/withdraw with THP
Message-ID: <20201016030456.5r1S0YG4g%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
