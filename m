Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF4CC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABA0220897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817473;
	bh=Xp2NxTMc2t88xor0f64gTNqFNqCCRES4fc1ua6TJsOA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KjoLEwjqGhL5H32MhD6W3/xPG/SWySuwMyXBYz7v6YIrZ3vzywsU8QGIXDKs4BrTN
	 TIMJ6aVAg4TlojZpgXxXJgJC/ObISo4MgNt+ryfYO5mT3KeRmIdFk1bI2aOtdLNDtX
	 pYpcoUOtEpdtF2uGImb1cGt6YHQA2DEZOjrUqzdk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732552AbgJPDEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDEd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:04:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FC9E20789;
        Fri, 16 Oct 2020 03:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817470;
        bh=Xp2NxTMc2t88xor0f64gTNqFNqCCRES4fc1ua6TJsOA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CbA+k0BKoy18rCpvwRGuy8Dldhta1itTdaxmlxcihj2DdEW02cDIDq1JY8iCj8J+h
         vjA0ubYc24IZDL1CxYgX4WWJIBMrO9obkssEstXSZBEiJwnQUSrk/fuUzcRDZfN1Jk
         mZQV7Kjqoe8L+pS2ZrvVZvxiM5/BmdrhIB2phuSE=
Date:   Thu, 15 Oct 2020 20:04:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 003/156] powerpc/mm: move setting pte specific
 flags to pfn_pte
Message-ID: <20201016030429.CKJF7rcVx%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mm: move setting pte specific flags to pfn_pte

powerpc used to set the pte specific flags in set_pte_at().  This is
different from other architectures.  To be consistent with other
architecture update pfn_pte to set _PAGE_PTE on ppc64.  Also, drop now
unused pte_mkpte.

We add a VM_WARN_ON() to catch the usage of calling set_pte_at() without
setting _PAGE_PTE bit.  We will remove that after a few releases.

With respect to huge pmd entries, pmd_mkhuge() takes care of adding the
_PAGE_PTE bit.

[akpm@linux-foundation.org: whitespace fix, per Christophe]
Link: https://lkml.kernel.org/r/20200902114222.181353-3-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |   15 +++++++++------
 arch/powerpc/include/asm/nohash/pgtable.h    |    5 -----
 arch/powerpc/mm/pgtable.c                    |    5 -----
 3 files changed, 9 insertions(+), 16 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -615,7 +615,7 @@ static inline pte_t pfn_pte(unsigned lon
 	VM_BUG_ON(pfn >> (64 - PAGE_SHIFT));
 	VM_BUG_ON((pfn << PAGE_SHIFT) & ~PTE_RPN_MASK);
 
-	return __pte(((pte_basic_t)pfn << PAGE_SHIFT) | pgprot_val(pgprot));
+	return __pte(((pte_basic_t)pfn << PAGE_SHIFT) | pgprot_val(pgprot) | _PAGE_PTE);
 }
 
 static inline unsigned long pte_pfn(pte_t pte)
@@ -651,11 +651,6 @@ static inline pte_t pte_mkexec(pte_t pte
 	return __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_EXEC));
 }
 
-static inline pte_t pte_mkpte(pte_t pte)
-{
-	return __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_PTE));
-}
-
 static inline pte_t pte_mkwrite(pte_t pte)
 {
 	/*
@@ -819,6 +814,14 @@ static inline int pte_none(pte_t pte)
 static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte, int percpu)
 {
+
+	VM_WARN_ON(!(pte_raw(pte) & cpu_to_be64(_PAGE_PTE)));
+	/*
+	 * Keep the _PAGE_PTE added till we are sure we handle _PAGE_PTE
+	 * in all the callers.
+	 */
+	pte = __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_PTE));
+
 	if (radix_enabled())
 		return radix__set_pte_at(mm, addr, ptep, pte, percpu);
 	return hash__set_pte_at(mm, addr, ptep, pte, percpu);
--- a/arch/powerpc/include/asm/nohash/pgtable.h~powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte
+++ a/arch/powerpc/include/asm/nohash/pgtable.h
@@ -140,11 +140,6 @@ static inline pte_t pte_mkold(pte_t pte)
 	return __pte(pte_val(pte) & ~_PAGE_ACCESSED);
 }
 
-static inline pte_t pte_mkpte(pte_t pte)
-{
-	return pte;
-}
-
 static inline pte_t pte_mkspecial(pte_t pte)
 {
 	return __pte(pte_val(pte) | _PAGE_SPECIAL);
--- a/arch/powerpc/mm/pgtable.c~powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte
+++ a/arch/powerpc/mm/pgtable.c
@@ -184,9 +184,6 @@ void set_pte_at(struct mm_struct *mm, un
 	 */
 	VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));
 
-	/* Add the pte bit when trying to set a pte */
-	pte = pte_mkpte(pte);
-
 	/* Note: mm->context.id might not yet have been assigned as
 	 * this context might not have been activated yet when this
 	 * is called.
@@ -275,8 +272,6 @@ void set_huge_pte_at(struct mm_struct *m
 	 */
 	VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));
 
-	pte = pte_mkpte(pte);
-
 	pte = set_pte_filter(pte);
 
 	val = pte_val(pte);
_
