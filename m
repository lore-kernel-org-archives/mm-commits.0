Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5DDC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B166121D40
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881249;
	bh=hREl/i/Sh1Giz4/MGPrVjyqb+NpYZTS4z1y8Db2PSgw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TyFwpWBiKnkLbB9VpeqE5Z/y5Xcv6TQFmGJygumsUKFbXCNxOVBVKiLY4GDyaRRDI
	 YbUNpw5V3uQKOLYbAJMN/H4pxLB9lXYbAsZ998PON9d7L9i/nvNHgifF4qQkB+zT+P
	 DPdzHtZ34mJP0aU5ONVfn8oCu5msVHHKOZtCgyts=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391055AbgJPUr3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390822AbgJPUr2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:47:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C553C214DB;
        Fri, 16 Oct 2020 20:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881246;
        bh=hREl/i/Sh1Giz4/MGPrVjyqb+NpYZTS4z1y8Db2PSgw=;
        h=Date:From:To:Subject:From;
        b=hTbNsitqEPfIGAyyz3HPUl3k+OcDuA4qYajXXUD72wrrqG5JwJaeg53kAuaMaI2Hb
         agzMWml5f3BjsidTCx6c5s6Ht5Y58jtAt1cfrsl7oQKHEH8nwq1F+9/luM8CdVocJN
         qwofd8asyrecdtN3eT+30SnkIMEFYQX6E8psmKtI=
Date:   Fri, 16 Oct 2020 13:47:25 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au
Subject:  [merged]
 powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch removed from
 -mm tree
Message-ID: <20201016204725.Y7rUXq-VY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: move setting pte specific flags to pfn_pte
has been removed from the -mm tree.  Its filename was
     powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


