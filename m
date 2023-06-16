Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D66EB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 17:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjFPRwH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 13:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjFPRwH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 13:52:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C17E5D
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 10:52:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF8E560EE0
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 17:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DE8C433C8;
        Fri, 16 Jun 2023 17:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686937924;
        bh=a6s98Re3R5J5/MznmvPF4D24QqzsDZxX/3vNDveZiy4=;
        h=Date:To:From:Subject:From;
        b=tdOwNDVCn+z+Gsd/peZg6z03iCxsZ/FWeQLUHTGpc+9H5BFD8MidEnZSMIMB73KMM
         YWfx4i0DXnG5Fu3SA9VoJa5ze5ma66t6GKrZT/evFGdQZZGA+sMrJUzokLEapHCG9U
         lqtBcjBTCCItLQ7FmluC8L0MUMkIpXRcg29uMPmk=
Date:   Fri, 16 Jun 2023 10:52:03 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, will@kernel.org, tsbogend@alpha.franken.de,
        tglx@linutronix.de, surenb@google.com, rppt@kernel.org,
        peterz@infradead.org, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@kernel.org, mike.kravetz@oracle.com,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, imbrenda@linux.ibm.com, hpa@zytor.com,
        hca@linux.ibm.com, glaubitz@physik.fu-berlin.de,
        gerg@linux-m68k.org, geert@linux-m68k.org, deller@gmx.de,
        david@redhat.com, davem@davemloft.net, dave.anglin@bell.net,
        chris@zankel.net, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        alexghiti@rivosinc.com, agordeev@linux.ibm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mips-update_mmu_cache-can-replace-__update_tlb.patch removed from -mm tree
Message-Id: <20230616175204.38DE8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: update_mmu_cache() can replace __update_tlb()
has been removed from the -mm tree.  Its filename was
     mips-update_mmu_cache-can-replace-__update_tlb.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mips: update_mmu_cache() can replace __update_tlb()
Date: Thu, 8 Jun 2023 12:17:24 -0700 (PDT)

Don't make update_mmu_cache() a wrapper around __update_tlb(): call it
directly, and use the ptep (or pmdp) provided by the caller, instead of
re-calling pte_offset_map() - which would raise a question of whether a
pte_unmap() is needed to balance it.

Check whether the "ptep" provided by the caller is actually the pmdp,
instead of testing pmd_huge(): or test pmd_huge() too and warn if it
disagrees?  This is "hazardous" territory: needs review and testing.

[hughd@google.com: fix build warning]
  Link: https://lkml.kernel.org/r/6852be98-64e6-6092-d1c-13124b97bc75@google.com
Link: https://lkml.kernel.org/r/178970b0-1539-8aac-76fd-972c6c46ec17@google.com
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
Cc: Ingo Molnar <mingo@kernel.org>
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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable.h |   15 +++------------
 arch/mips/mm/tlb-r3k.c          |    5 +++--
 arch/mips/mm/tlb-r4k.c          |   19 +++++++++----------
 3 files changed, 15 insertions(+), 24 deletions(-)

--- a/arch/mips/include/asm/pgtable.h~mips-update_mmu_cache-can-replace-__update_tlb
+++ a/arch/mips/include/asm/pgtable.h
@@ -565,15 +565,8 @@ static inline pte_t pte_swp_clear_exclus
 }
 #endif
 
-extern void __update_tlb(struct vm_area_struct *vma, unsigned long address,
-	pte_t pte);
-
-static inline void update_mmu_cache(struct vm_area_struct *vma,
-	unsigned long address, pte_t *ptep)
-{
-	pte_t pte = *ptep;
-	__update_tlb(vma, address, pte);
-}
+extern void update_mmu_cache(struct vm_area_struct *vma,
+	unsigned long address, pte_t *ptep);
 
 #define	__HAVE_ARCH_UPDATE_MMU_TLB
 #define update_mmu_tlb	update_mmu_cache
@@ -581,9 +574,7 @@ static inline void update_mmu_cache(stru
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
 	unsigned long address, pmd_t *pmdp)
 {
-	pte_t pte = *(pte_t *)pmdp;
-
-	__update_tlb(vma, address, pte);
+	update_mmu_cache(vma, address, (pte_t *)pmdp);
 }
 
 /*
--- a/arch/mips/mm/tlb-r3k.c~mips-update_mmu_cache-can-replace-__update_tlb
+++ a/arch/mips/mm/tlb-r3k.c
@@ -176,7 +176,8 @@ finish:
 	}
 }
 
-void __update_tlb(struct vm_area_struct *vma, unsigned long address, pte_t pte)
+void update_mmu_cache(struct vm_area_struct *vma,
+		      unsigned long address, pte_t *ptep)
 {
 	unsigned long asid_mask = cpu_asid_mask(&current_cpu_data);
 	unsigned long flags;
@@ -203,7 +204,7 @@ void __update_tlb(struct vm_area_struct
 	BARRIER;
 	tlb_probe();
 	idx = read_c0_index();
-	write_c0_entrylo0(pte_val(pte));
+	write_c0_entrylo0(pte_val(*ptep));
 	write_c0_entryhi(address | pid);
 	if (idx < 0) {					/* BARRIER */
 		tlb_write_random();
--- a/arch/mips/mm/tlb-r4k.c~mips-update_mmu_cache-can-replace-__update_tlb
+++ a/arch/mips/mm/tlb-r4k.c
@@ -290,14 +290,16 @@ void local_flush_tlb_one(unsigned long p
  * updates the TLB with the new pte(s), and another which also checks
  * for the R4k "end of page" hardware bug and does the needy.
  */
-void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
+void update_mmu_cache(struct vm_area_struct *vma,
+		      unsigned long address, pte_t *ptep)
 {
-	unsigned long flags;
+#ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 	pgd_t *pgdp;
 	p4d_t *p4dp;
 	pud_t *pudp;
 	pmd_t *pmdp;
-	pte_t *ptep;
+#endif
+	unsigned long flags;
 	int idx, pid;
 
 	/*
@@ -316,20 +318,19 @@ void __update_tlb(struct vm_area_struct
 		pid = read_c0_entryhi() & cpu_asid_mask(&current_cpu_data);
 		write_c0_entryhi(address | pid);
 	}
-	pgdp = pgd_offset(vma->vm_mm, address);
 	mtc0_tlbw_hazard();
 	tlb_probe();
 	tlb_probe_hazard();
+	idx = read_c0_index();
+#ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
+	pgdp = pgd_offset(vma->vm_mm, address);
 	p4dp = p4d_offset(pgdp, address);
 	pudp = pud_offset(p4dp, address);
 	pmdp = pmd_offset(pudp, address);
-	idx = read_c0_index();
-#ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 	/* this could be a huge page  */
-	if (pmd_huge(*pmdp)) {
+	if (ptep == (pte_t *)pmdp) {
 		unsigned long lo;
 		write_c0_pagemask(PM_HUGE_MASK);
-		ptep = (pte_t *)pmdp;
 		lo = pte_to_entrylo(pte_val(*ptep));
 		write_c0_entrylo0(lo);
 		write_c0_entrylo1(lo + (HPAGE_SIZE >> 7));
@@ -344,8 +345,6 @@ void __update_tlb(struct vm_area_struct
 	} else
 #endif
 	{
-		ptep = pte_offset_map(pmdp, address);
-
 #if defined(CONFIG_PHYS_ADDR_T_64BIT) && defined(CONFIG_CPU_MIPS32)
 #ifdef CONFIG_XPA
 		write_c0_entrylo0(pte_to_entrylo(ptep->pte_high));
_

Patches currently in -mm which might be from hughd@google.com are

arm-allow-pte_offset_map-to-fail.patch
arm64-allow-pte_offset_map-to-fail.patch
arm64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
ia64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
m68k-allow-pte_offset_map-to-fail.patch
microblaze-allow-pte_offset_map-to-fail.patch
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
mm-use-pmdp_get_lockless-without-surplus-barrier.patch
mm-migrate-remove-cruft-from-migration_entry_waits.patch
mm-pgtable-kmap_local_page-instead-of-kmap_atomic.patch
mm-pgtable-allow-pte_offset_map-to-fail.patch
mm-filemap-allow-pte_offset_map_lock-to-fail.patch
mm-page_vma_mapped-delete-bogosity-in-page_vma_mapped_walk.patch
mm-page_vma_mapped-reformat-map_pte-with-less-indentation.patch
mm-page_vma_mapped-pte_offset_map_nolock-not-pte_lockptr.patch
mm-pagewalkers-action_again-if-pte_offset_map_lock-fails.patch
mm-pagewalk-walk_pte_range-allow-for-pte_offset_map.patch
mm-vmwgfx-simplify-pmd-pud-mapping-dirty-helpers.patch
mm-vmalloc-vmalloc_to_page-use-pte_offset_kernel.patch
mm-hmm-retry-if-pte_offset_map-fails.patch
mm-userfaultfd-retry-if-pte_offset_map-fails.patch
mm-userfaultfd-allow-pte_offset_map_lock-to-fail.patch
mm-debug_vm_pgtablepage_table_check-warn-pte-map-fails.patch
mm-various-give-up-if-pte_offset_map-fails.patch
mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
mm-mremap-retry-if-either-pte_offset_map_lock-fails.patch
mm-madvise-clean-up-pte_offset_map_lock-scans.patch
mm-madvise-clean-up-force_shm_swapin_readahead.patch
mm-swapoff-allow-pte_offset_map-to-fail.patch
mm-mglru-allow-pte_offset_map_nolock-to-fail.patch
mm-migrate_device-allow-pte_offset_map_lock-to-fail.patch
mm-gup-remove-foll_split_pmd-use-of-pmd_trans_unstable.patch
mm-huge_memory-split-huge-pmd-under-one-pte_offset_map.patch
mm-khugepaged-allow-pte_offset_map-to-fail.patch
mm-memory-allow-pte_offset_map-to-fail.patch
mm-memory-handle_pte_fault-use-pte_offset_map_nolock.patch
mm-pgtable-delete-pmd_trans_unstable-and-friends.patch
mm-swap-swap_vma_readahead-do-the-pte_offset_map.patch
perf-core-allow-pte_offset_map-to-fail.patch
mm-memory-allow-pte_offset_map-to-fail-fix.patch

