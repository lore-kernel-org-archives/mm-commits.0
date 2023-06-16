Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF71EB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 17:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjFPRv3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 13:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjFPRv2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 13:51:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530D11FF7
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 10:51:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E36AD621FB
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 17:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3766AC433C0;
        Fri, 16 Jun 2023 17:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686937886;
        bh=hI334yjRY72k0vSVHzsGjVa5pyVOZrAhTZoEe/kZHuM=;
        h=Date:To:From:Subject:From;
        b=yu+YBoWZB6S2u6T+XY65b4saaj/1T5Zc5Jabp27H8wsF0bcTZBMPiwjoAkJT3601B
         LAjAVAATH2ix7c0L4FKuO01aRQrZ5XGvd/r9yFGv55Zw8z8UX4Shnb6bdbRzst5oY9
         y5ktmW5P1cK3UhFPW9Imk3xWmFcNCXIpkoUH+QhE=
Date:   Fri, 16 Jun 2023 10:51:25 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mips-update_mmu_cache-can-replace-__update_tlb-fix.patch removed from -mm tree
Message-Id: <20230616175126.3766AC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: update_mmu_cache() can replace __update_tlb(): fix
has been removed from the -mm tree.  Its filename was
     mips-update_mmu_cache-can-replace-__update_tlb-fix.patch

This patch was dropped because it was folded into mips-update_mmu_cache-can-replace-__update_tlb.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mips: update_mmu_cache() can replace __update_tlb(): fix
Date: Fri, 9 Jun 2023 01:08:52 -0700 (PDT)

I expect this to fix the
arch/mips/mm/tlb-r4k.c:300:16: warning: variable 'pmdp' set but not used
reported by the kernel test robot; but I am uncomfortable rearranging
lines in this tlb_probe_hazard() area, and would be glad for review and
testing by someone familiar with mips - thanks in advance!

Link: https://lkml.kernel.org/r/6852be98-64e6-6092-d1c-13124b97bc75@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306091304.cNVIspK0-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/tlb-r4k.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/mips/mm/tlb-r4k.c~mips-update_mmu_cache-can-replace-__update_tlb-fix
+++ a/arch/mips/mm/tlb-r4k.c
@@ -293,11 +293,13 @@ void local_flush_tlb_one(unsigned long p
 void update_mmu_cache(struct vm_area_struct *vma,
 		      unsigned long address, pte_t *ptep)
 {
-	unsigned long flags;
+#ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 	pgd_t *pgdp;
 	p4d_t *p4dp;
 	pud_t *pudp;
 	pmd_t *pmdp;
+#endif
+	unsigned long flags;
 	int idx, pid;
 
 	/*
@@ -316,15 +318,15 @@ void update_mmu_cache(struct vm_area_str
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
 	if (ptep == (pte_t *)pmdp) {
 		unsigned long lo;
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

