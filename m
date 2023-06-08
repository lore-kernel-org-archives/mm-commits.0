Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BDDC7EE45
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jun 2023 23:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjFHX2g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jun 2023 19:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbjFHX2V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jun 2023 19:28:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA68830EC
        for <mm-commits@vger.kernel.org>; Thu,  8 Jun 2023 16:28:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA41B651D6
        for <mm-commits@vger.kernel.org>; Thu,  8 Jun 2023 23:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A50C433D2;
        Thu,  8 Jun 2023 23:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686266898;
        bh=uBmr/gbpQ6rDdpRzISbiK9cA6aak2bVozIgXrA9XGUg=;
        h=Date:To:From:Subject:From;
        b=O4KMVLMG/UYvvdcnk0vJeZM+kn2jetiWGNMYDM1A8qA3072MuNrt4Nz+gBFmQslRi
         Ysh9v6+3P4frJjdE78CPVV7UactJpjSLOsquIOLE82f9Hjr9O+Crre4riqZtvQwH1W
         mAvTk6/K9fXlfPXBEeuNXOzqH8CTGxo4D1Tb187E=
Date:   Thu, 08 Jun 2023 16:28:17 -0700
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
Subject: + powerpc-allow-pte_offset_map-to-fail.patch added to mm-unstable branch
Message-Id: <20230608232817.F1A50C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: allow pte_offset_map[_lock]() to fail
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-allow-pte_offset_map-to-fail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-allow-pte_offset_map-to-fail.patch

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
Subject: powerpc: allow pte_offset_map[_lock]() to fail
Date: Thu, 8 Jun 2023 12:23:35 -0700 (PDT)

In rare transient cases, not yet made possible, pte_offset_map() and
pte_offset_map_lock() may not find a page table: handle appropriately.
Balance successful pte_offset_map() with pte_unmap() where omitted.

Link: https://lkml.kernel.org/r/54c8b578-ca9-a0f-bfd2-d72976f8d73a@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

 arch/powerpc/mm/book3s64/hash_tlb.c     |    4 ++++
 arch/powerpc/mm/book3s64/subpage_prot.c |    2 ++
 arch/powerpc/xmon/xmon.c                |    5 ++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/book3s64/hash_tlb.c~powerpc-allow-pte_offset_map-to-fail
+++ a/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -239,12 +239,16 @@ void flush_hash_table_pmd_range(struct m
 	local_irq_save(flags);
 	arch_enter_lazy_mmu_mode();
 	start_pte = pte_offset_map(pmd, addr);
+	if (!start_pte)
+		goto out;
 	for (pte = start_pte; pte < start_pte + PTRS_PER_PTE; pte++) {
 		unsigned long pteval = pte_val(*pte);
 		if (pteval & H_PAGE_HASHPTE)
 			hpte_need_flush(mm, addr, pte, pteval, 0);
 		addr += PAGE_SIZE;
 	}
+	pte_unmap(start_pte);
+out:
 	arch_leave_lazy_mmu_mode();
 	local_irq_restore(flags);
 }
--- a/arch/powerpc/mm/book3s64/subpage_prot.c~powerpc-allow-pte_offset_map-to-fail
+++ a/arch/powerpc/mm/book3s64/subpage_prot.c
@@ -71,6 +71,8 @@ static void hpte_flush_range(struct mm_s
 	if (pmd_none(*pmd))
 		return;
 	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!pte)
+		return;
 	arch_enter_lazy_mmu_mode();
 	for (; npages > 0; --npages) {
 		pte_update(mm, addr, pte, 0, 0, 0);
--- a/arch/powerpc/xmon/xmon.c~powerpc-allow-pte_offset_map-to-fail
+++ a/arch/powerpc/xmon/xmon.c
@@ -3376,12 +3376,15 @@ static void show_pte(unsigned long addr)
 	printf("pmdp @ 0x%px = 0x%016lx\n", pmdp, pmd_val(*pmdp));
 
 	ptep = pte_offset_map(pmdp, addr);
-	if (pte_none(*ptep)) {
+	if (!ptep || pte_none(*ptep)) {
+		if (ptep)
+			pte_unmap(ptep);
 		printf("no valid PTE\n");
 		return;
 	}
 
 	format_pte(ptep, pte_val(*ptep));
+	pte_unmap(ptep);
 
 	sync();
 	__delay(200);
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

