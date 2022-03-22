Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8232EC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiCVVnf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236075AbiCVVnQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:43:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62935F25C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:41:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 719D96101E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA76DC340EC;
        Tue, 22 Mar 2022 21:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985307;
        bh=6Ox1Cq4jv+rMUGMZobKy2Bxyrl25aNYX2jq5jSm2Dm0=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=I22S8OTiko93Apyew/HmJi6rZnupb8MaEjcgx1gvaXQQg5abLlPK43W8ttcaT+Lao
         Qujotaa5U9uqKWRgfr4WZape37qNBTUyn9m2p6CYAP5LTdE+JMDS/qv0JTa+2cDxH6
         n8ZmlU967jmxyE6Lz5nIKMpHJc6JMR0r0rFPjWfU=
Date:   Tue, 22 Mar 2022 14:41:47 -0700
To:     will@kernel.org, paulus@samba.org, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 064/227] mm: merge pte_mkhuge() call into arch_make_huge_pte()
Message-Id: <20220322214147.CA76DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: merge pte_mkhuge() call into arch_make_huge_pte()

Each call into pte_mkhuge() is invariably followed by
arch_make_huge_pte().  Instead arch_make_huge_pte() can accommodate
pte_mkhuge() at the beginning.  This updates generic fallback stub for
arch_make_huge_pte() and available platforms definitions.  This makes huge
pte creation much cleaner and easier to follow.

Link: https://lkml.kernel.org/r/1643860669-26307-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c                      |    1 +
 arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h |    4 ++--
 arch/sparc/mm/hugetlbpage.c                      |    1 +
 include/linux/hugetlb.h                          |    2 +-
 mm/hugetlb.c                                     |    3 +--
 mm/vmalloc.c                                     |    1 -
 6 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~mm-merge-pte_mkhuge-call-into-arch_make_huge_pte
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -347,6 +347,7 @@ pte_t arch_make_huge_pte(pte_t entry, un
 {
 	size_t pagesize = 1UL << shift;
 
+	entry = pte_mkhuge(entry);
 	if (pagesize == CONT_PTE_SIZE) {
 		entry = pte_mkcont(entry);
 	} else if (pagesize == CONT_PMD_SIZE) {
--- a/arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h~mm-merge-pte_mkhuge-call-into-arch_make_huge_pte
+++ a/arch/powerpc/include/asm/nohash/32/hugetlb-8xx.h
@@ -71,9 +71,9 @@ static inline pte_t arch_make_huge_pte(p
 	size_t size = 1UL << shift;
 
 	if (size == SZ_16K)
-		return __pte(pte_val(entry) & ~_PAGE_HUGE);
+		return __pte(pte_val(entry) | _PAGE_SPS);
 	else
-		return entry;
+		return __pte(pte_val(entry) | _PAGE_SPS | _PAGE_HUGE);
 }
 #define arch_make_huge_pte arch_make_huge_pte
 #endif
--- a/arch/sparc/mm/hugetlbpage.c~mm-merge-pte_mkhuge-call-into-arch_make_huge_pte
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -181,6 +181,7 @@ pte_t arch_make_huge_pte(pte_t entry, un
 {
 	pte_t pte;
 
+	entry = pte_mkhuge(entry);
 	pte = hugepage_shift_to_tte(entry, shift);
 
 #ifdef CONFIG_SPARC64
--- a/include/linux/hugetlb.h~mm-merge-pte_mkhuge-call-into-arch_make_huge_pte
+++ a/include/linux/hugetlb.h
@@ -754,7 +754,7 @@ static inline void arch_clear_hugepage_f
 static inline pte_t arch_make_huge_pte(pte_t entry, unsigned int shift,
 				       vm_flags_t flags)
 {
-	return entry;
+	return pte_mkhuge(entry);
 }
 #endif
 
--- a/mm/hugetlb.c~mm-merge-pte_mkhuge-call-into-arch_make_huge_pte
+++ a/mm/hugetlb.c
@@ -4637,7 +4637,6 @@ static pte_t make_huge_pte(struct vm_are
 					   vma->vm_page_prot));
 	}
 	entry = pte_mkyoung(entry);
-	entry = pte_mkhuge(entry);
 	entry = arch_make_huge_pte(entry, shift, vma->vm_flags);
 
 	return entry;
@@ -6171,7 +6170,7 @@ unsigned long hugetlb_change_protection(
 			unsigned int shift = huge_page_shift(hstate_vma(vma));
 
 			old_pte = huge_ptep_modify_prot_start(vma, address, ptep);
-			pte = pte_mkhuge(huge_pte_modify(old_pte, newprot));
+			pte = huge_pte_modify(old_pte, newprot);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
--- a/mm/vmalloc.c~mm-merge-pte_mkhuge-call-into-arch_make_huge_pte
+++ a/mm/vmalloc.c
@@ -118,7 +118,6 @@ static int vmap_pte_range(pmd_t *pmd, un
 		if (size != PAGE_SIZE) {
 			pte_t entry = pfn_pte(pfn, prot);
 
-			entry = pte_mkhuge(entry);
 			entry = arch_make_huge_pte(entry, ilog2(size), 0);
 			set_huge_pte_at(&init_mm, addr, pte, entry);
 			pfn += PFN_DOWN(size);
_
