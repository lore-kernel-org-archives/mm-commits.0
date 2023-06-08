Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58703C7EE25
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jun 2023 23:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236994AbjFHX2P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jun 2023 19:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbjFHX2J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jun 2023 19:28:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8FE30EB
        for <mm-commits@vger.kernel.org>; Thu,  8 Jun 2023 16:28:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CD4C651BD
        for <mm-commits@vger.kernel.org>; Thu,  8 Jun 2023 23:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3B1C433EF;
        Thu,  8 Jun 2023 23:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686266881;
        bh=4gnRJvCQyWadu3KQPhxxByPM5w8diScuTDwh9tB4ghw=;
        h=Date:To:From:Subject:From;
        b=c2QLcaKn8Hp/ZT+00i/i+hSEKZMCZsRoj3C46vumpY/+AyI0Fzfd+abXibxi2i+3/
         SedmFi64f9tmAHVVkEbQoMgiYojv+iEs5H4bepnXrEAWoFdemWyMspXVxac5ZAClfg
         O08TW5bBvl1FpQOdt8CfctmptJ/Cz9N5oIlZPHV0=
Date:   Thu, 08 Jun 2023 16:28:01 -0700
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
Subject: + m68k-allow-pte_offset_map-to-fail.patch added to mm-unstable branch
Message-Id: <20230608232801.CA3B1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: allow pte_offset_map[_lock]() to fail
has been added to the -mm mm-unstable branch.  Its filename is
     m68k-allow-pte_offset_map-to-fail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-allow-pte_offset_map-to-fail.patch

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
Subject: m68k: allow pte_offset_map[_lock]() to fail
Date: Thu, 8 Jun 2023 12:15:16 -0700 (PDT)

In rare transient cases, not yet made possible, pte_offset_map() and
pte_offset_map_lock() may not find a page table: handle appropriately.

Restructure cf_tlb_miss() with a pte_unmap() (previously omitted)
at label out, followed by one local_irq_restore() for all.

Link: https://lkml.kernel.org/r/795f6a7-bcca-cdf-ad2a-fbdaa232998c@google.com
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

 arch/m68k/include/asm/mmu_context.h |    6 ++-
 arch/m68k/kernel/sys_m68k.c         |    2 +
 arch/m68k/mm/mcfmmu.c               |   52 ++++++++++----------------
 3 files changed, 27 insertions(+), 33 deletions(-)

--- a/arch/m68k/include/asm/mmu_context.h~m68k-allow-pte_offset_map-to-fail
+++ a/arch/m68k/include/asm/mmu_context.h
@@ -99,7 +99,7 @@ static inline void load_ksp_mmu(struct t
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
+	pte_t *pte = NULL;
 	unsigned long mmuar;
 
 	local_irq_save(flags);
@@ -139,7 +139,7 @@ static inline void load_ksp_mmu(struct t
 
 	pte = (mmuar >= PAGE_OFFSET) ? pte_offset_kernel(pmd, mmuar)
 				     : pte_offset_map(pmd, mmuar);
-	if (pte_none(*pte) || !pte_present(*pte))
+	if (!pte || pte_none(*pte) || !pte_present(*pte))
 		goto bug;
 
 	set_pte(pte, pte_mkyoung(*pte));
@@ -161,6 +161,8 @@ static inline void load_ksp_mmu(struct t
 bug:
 	pr_info("ksp load failed: mm=0x%p ksp=0x08%lx\n", mm, mmuar);
 end:
+	if (pte && mmuar < PAGE_OFFSET)
+		pte_unmap(pte);
 	local_irq_restore(flags);
 }
 
--- a/arch/m68k/kernel/sys_m68k.c~m68k-allow-pte_offset_map-to-fail
+++ a/arch/m68k/kernel/sys_m68k.c
@@ -488,6 +488,8 @@ sys_atomic_cmpxchg_32(unsigned long newv
 		if (!pmd_present(*pmd))
 			goto bad_access;
 		pte = pte_offset_map_lock(mm, pmd, (unsigned long)mem, &ptl);
+		if (!pte)
+			goto bad_access;
 		if (!pte_present(*pte) || !pte_dirty(*pte)
 		    || !pte_write(*pte)) {
 			pte_unmap_unlock(pte, ptl);
--- a/arch/m68k/mm/mcfmmu.c~m68k-allow-pte_offset_map-to-fail
+++ a/arch/m68k/mm/mcfmmu.c
@@ -91,7 +91,8 @@ int cf_tlb_miss(struct pt_regs *regs, in
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
+	pte_t *pte = NULL;
+	int ret = -1;
 	int asid;
 
 	local_irq_save(flags);
@@ -100,47 +101,33 @@ int cf_tlb_miss(struct pt_regs *regs, in
 		regs->pc + (extension_word * sizeof(long));
 
 	mm = (!user_mode(regs) && KMAPAREA(mmuar)) ? &init_mm : current->mm;
-	if (!mm) {
-		local_irq_restore(flags);
-		return -1;
-	}
+	if (!mm)
+		goto out;
 
 	pgd = pgd_offset(mm, mmuar);
-	if (pgd_none(*pgd))  {
-		local_irq_restore(flags);
-		return -1;
-	}
+	if (pgd_none(*pgd))
+		goto out;
 
 	p4d = p4d_offset(pgd, mmuar);
-	if (p4d_none(*p4d)) {
-		local_irq_restore(flags);
-		return -1;
-	}
+	if (p4d_none(*p4d))
+		goto out;
 
 	pud = pud_offset(p4d, mmuar);
-	if (pud_none(*pud)) {
-		local_irq_restore(flags);
-		return -1;
-	}
+	if (pud_none(*pud))
+		goto out;
 
 	pmd = pmd_offset(pud, mmuar);
-	if (pmd_none(*pmd)) {
-		local_irq_restore(flags);
-		return -1;
-	}
+	if (pmd_none(*pmd))
+		goto out;
 
 	pte = (KMAPAREA(mmuar)) ? pte_offset_kernel(pmd, mmuar)
 				: pte_offset_map(pmd, mmuar);
-	if (pte_none(*pte) || !pte_present(*pte)) {
-		local_irq_restore(flags);
-		return -1;
-	}
+	if (!pte || pte_none(*pte) || !pte_present(*pte))
+		goto out;
 
 	if (write) {
-		if (!pte_write(*pte)) {
-			local_irq_restore(flags);
-			return -1;
-		}
+		if (!pte_write(*pte))
+			goto out;
 		set_pte(pte, pte_mkdirty(*pte));
 	}
 
@@ -161,9 +148,12 @@ int cf_tlb_miss(struct pt_regs *regs, in
 		mmu_write(MMUOR, MMUOR_ACC | MMUOR_UAA);
 	else
 		mmu_write(MMUOR, MMUOR_ITLB | MMUOR_ACC | MMUOR_UAA);
-
+	ret = 0;
+out:
+	if (pte && !KMAPAREA(mmuar))
+		pte_unmap(pte);
 	local_irq_restore(flags);
-	return 0;
+	return ret;
 }
 
 void __init cf_bootmem_alloc(void)
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

