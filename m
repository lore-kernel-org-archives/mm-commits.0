Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EAACC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23FA320B1F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816086;
	bh=P9OEfhkFnRhAcZwgGc5XjanLmO2tkktV9hbLWyt5FZY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=SuNZj1bN15/+T0QO46aowf56DCFLbINYySkpDrLRNHqPZacydTMIXxKBXLAMNx3jq
	 x2RSlTpU7MFjgo+EoxaJZW5ZBRyymo1pfX0BkAaq9Cm2uzWvjHnHqrMRuaPcqMRJ1S
	 IuMoVcWDWTLRDInbMFFmAXGdg9cqG2wwKstIGnkw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404285AbgJPClZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732990AbgJPClZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:41:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5818820878;
        Fri, 16 Oct 2020 02:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816082;
        bh=P9OEfhkFnRhAcZwgGc5XjanLmO2tkktV9hbLWyt5FZY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QVKbkdC4SKki41YPeQhyvFZ8L1mV0YoQIKMN6cGvvV/A1AxajiArPBkQNA1mvXRMx
         7D4PI/GIy8I8+ucQ+9llalSjEaHPn933A0UBXo8AesipduTfZEDAtQywkcnKsXOeXk
         VfVWYMq+louLe815mCp7HruJhn0MYSJLKBJpaNS8=
Date:   Thu, 15 Oct 2020 19:41:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 007/156] mm/debug_vm_pgtable/THP: mark the pte
 entry huge before using set_pmd/pud_at
Message-ID: <20201016024121.hxwVjFK14%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/THP: mark the pte entry huge before using set_pmd/pud_at

kernel expects entries to be marked huge before we use
set_pmd_at()/set_pud_at().

Link: https://lkml.kernel.org/r/20200902114222.181353-7-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-thp-mark-the-pte-entry-huge-before-using-set_pmd-pud_at
+++ a/mm/debug_vm_pgtable.c
@@ -155,7 +155,7 @@ static void __init pmd_advanced_tests(st
 				      unsigned long pfn, unsigned long vaddr,
 				      pgprot_t prot)
 {
-	pmd_t pmd = pfn_pmd(pfn, prot);
+	pmd_t pmd;
 
 	if (!has_transparent_hugepage())
 		return;
@@ -164,19 +164,19 @@ static void __init pmd_advanced_tests(st
 	/* Align the address wrt HPAGE_PMD_SIZE */
 	vaddr = (vaddr & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE;
 
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
 	set_pmd_at(mm, vaddr, pmdp, pmd);
 	pmdp_set_wrprotect(mm, vaddr, pmdp);
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(pmd_write(pmd));
 
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
 	set_pmd_at(mm, vaddr, pmdp, pmd);
 	pmdp_huge_get_and_clear(mm, vaddr, pmdp);
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(!pmd_none(pmd));
 
-	pmd = pfn_pmd(pfn, prot);
+	pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
 	pmd = pmd_wrprotect(pmd);
 	pmd = pmd_mkclean(pmd);
 	set_pmd_at(mm, vaddr, pmdp, pmd);
@@ -236,7 +236,7 @@ static void __init pmd_huge_tests(pmd_t
 
 static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot)
 {
-	pmd_t pmd = pfn_pmd(pfn, prot);
+	pmd_t pmd = pmd_mkhuge(pfn_pmd(pfn, prot));
 
 	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
 		return;
@@ -276,7 +276,7 @@ static void __init pud_advanced_tests(st
 				      unsigned long pfn, unsigned long vaddr,
 				      pgprot_t prot)
 {
-	pud_t pud = pfn_pud(pfn, prot);
+	pud_t pud;
 
 	if (!has_transparent_hugepage())
 		return;
@@ -285,25 +285,27 @@ static void __init pud_advanced_tests(st
 	/* Align the address wrt HPAGE_PUD_SIZE */
 	vaddr = (vaddr & HPAGE_PUD_MASK) + HPAGE_PUD_SIZE;
 
+	pud = pud_mkhuge(pfn_pud(pfn, prot));
 	set_pud_at(mm, vaddr, pudp, pud);
 	pudp_set_wrprotect(mm, vaddr, pudp);
 	pud = READ_ONCE(*pudp);
 	WARN_ON(pud_write(pud));
 
 #ifndef __PAGETABLE_PMD_FOLDED
-	pud = pfn_pud(pfn, prot);
+	pud = pud_mkhuge(pfn_pud(pfn, prot));
 	set_pud_at(mm, vaddr, pudp, pud);
 	pudp_huge_get_and_clear(mm, vaddr, pudp);
 	pud = READ_ONCE(*pudp);
 	WARN_ON(!pud_none(pud));
 
-	pud = pfn_pud(pfn, prot);
+	pud = pud_mkhuge(pfn_pud(pfn, prot));
 	set_pud_at(mm, vaddr, pudp, pud);
 	pudp_huge_get_and_clear_full(mm, vaddr, pudp, 1);
 	pud = READ_ONCE(*pudp);
 	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
-	pud = pfn_pud(pfn, prot);
+
+	pud = pud_mkhuge(pfn_pud(pfn, prot));
 	pud = pud_wrprotect(pud);
 	pud = pud_mkclean(pud);
 	set_pud_at(mm, vaddr, pudp, pud);
_
