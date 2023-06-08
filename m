Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735ECC7EE25
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jun 2023 23:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbjFHX2J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jun 2023 19:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbjFHX2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jun 2023 19:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809EA30D4
        for <mm-commits@vger.kernel.org>; Thu,  8 Jun 2023 16:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14CAB64CD6
        for <mm-commits@vger.kernel.org>; Thu,  8 Jun 2023 23:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6734DC433D2;
        Thu,  8 Jun 2023 23:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686266877;
        bh=vdV45J7nHaY1VJEU7O6kJIU7MvFlmOEoLiVj3C3Zgac=;
        h=Date:To:From:Subject:From;
        b=puBZMocsdo6G4qvB88/zFV6+DUQnxw4i4TnhMcb49Hjk61R2aOs0koZG70TIsojo/
         ASDaZpea7vCYDQ24uBPcgR02Qu8BYrfRjHX6CuLTcHyGjFZPfA0ABPTex1bLhVoKgj
         SBeaxViSFvbvmeMhEhF9rZT6WCntIVqmCgXi5I9s=
Date:   Thu, 08 Jun 2023 16:27:56 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, will@kernel.org, tsbogend@alpha.franken.de,
        tglx@linutronix.de, surenb@google.com, rppt@kernel.org,
        peterz@infradead.org, palmer@rivosync.com, palmer@dabbelt.com,
        mpe@ellerman.id.au, monstr@monstr.eu, mingo@elte.hu,
        mike.kravetz@oracle.com, linux@armlinux.org.uk,
        kirill.shutemov@linux.intel.com, jcmvbkbc@gmail.com,
        imbrenda@linux.ibm.com, hpa@zytor.com, hca@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, deller@gmx.de, david@redhat.com,
        davem@davemloft.net, dave.anglin@bell.net, chris@zankel.net,
        catalin.marinas@arm.com, borntraeger@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, alexghiti@rivosinc.com,
        agordeev@linux.ibm.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-hugetlb-pte_alloc_huge-pte_offset_huge.patch added to mm-unstable branch
Message-Id: <20230608232757.6734DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/hugetlb: pte_alloc_huge() pte_offset_huge()
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-hugetlb-pte_alloc_huge-pte_offset_huge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-hugetlb-pte_alloc_huge-pte_offset_huge.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: arm64/hugetlb: pte_alloc_huge() pte_offset_huge()
Date: Thu, 8 Jun 2023 12:13:13 -0700 (PDT)

pte_alloc_map() expects to be followed by pte_unmap(), but hugetlb omits
that: to keep balance in future, use the recently added pte_alloc_huge()
instead; with pte_offset_huge() a better name for pte_offset_kernel().

Link: https://lkml.kernel.org/r/5849464-7191-40c5-c55f-fba9c3802e5d@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John David Anglin <dave.anglin@bell.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmer@rivosync.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-pte_alloc_huge-pte_offset_huge
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -307,14 +307,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 			return NULL;
 
 		WARN_ON(addr & (sz - 1));
-		/*
-		 * Note that if this code were ever ported to the
-		 * 32-bit arm platform then it will cause trouble in
-		 * the case where CONFIG_HIGHPTE is set, since there
-		 * will be no pte_unmap() to correspond with this
-		 * pte_alloc_map().
-		 */
-		ptep = pte_alloc_map(mm, pmdp, addr);
+		ptep = pte_alloc_huge(mm, pmdp, addr);
 	} else if (sz == PMD_SIZE) {
 		if (want_pmd_share(vma, addr) && pud_none(READ_ONCE(*pudp)))
 			ptep = huge_pmd_share(mm, vma, addr, pudp);
@@ -366,7 +359,7 @@ pte_t *huge_pte_offset(struct mm_struct
 		return (pte_t *)pmdp;
 
 	if (sz == CONT_PTE_SIZE)
-		return pte_offset_kernel(pmdp, (addr & CONT_PTE_MASK));
+		return pte_offset_huge(pmdp, (addr & CONT_PTE_MASK));
 
 	return NULL;
 }
_

Patches currently in -mm which might be from hughd@google.com are

arm-allow-pte_offset_map-to-fail.patch
arm64-allow-pte_offset_map-to-fail.patch
arm64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
ia64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
m68k-allow-pte_offset_map-to-fail.patch
microblaze-allow-pte_offset_map-to-fail.patch
mips-update_mmu_cache-can-replace-__update_tlb.patch
parisc-add-pte_unmap-to-balance-get_ptep.patch
parisc-unmap_uncached_pte-use-pte_offset_kernel.patch
parisc-hugetlb-pte_alloc_huge-pte_offset_huge.patch
powerpc-kvmppc_unmap_free_pmd-pte_offset_kernel.patch
powerpc-allow-pte_offset_map-to-fail.patch
powerpc-hugetlb-pte_alloc_huge.patch
riscv-hugetlb-pte_alloc_huge-pte_offset_huge.patch
s390-allow-pte_offset_map_lock-to-fail.patch
s390-gmap-use-pte_unmap_unlock-not-spin_unlock.patch
sh-hugetlb-pte_alloc_huge-pte_offset_huge.patch
sparc-hugetlb-pte_alloc_huge-pte_offset_huge.patch
sparc-allow-pte_offset_map-to-fail.patch
sparc-iounit-and-iommu-use-pte_offset_kernel.patch
x86-allow-get_locked_pte-to-fail.patch
x86-sme_populate_pgd-use-pte_offset_kernel.patch
xtensa-add-pte_unmap-to-balance-pte_offset_map.patch

