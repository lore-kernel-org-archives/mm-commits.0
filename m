Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F99EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjFSXKt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFSXKs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:10:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA0CF9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:10:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE08960F2D
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D528C433C0;
        Mon, 19 Jun 2023 23:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216246;
        bh=QX9h7Hk0NdGvYpQrCVjbbWAYcRsuoFl2FCrqUvSDmSo=;
        h=Date:To:From:Subject:From;
        b=lliUhOldyer9QQme9K6cG9DuJ1pcoQ72GZajBz0FUqV3dYDZoT9t/eAN/oGpBhGHK
         K6EznM6jmKtsevHsS6ynx5udztKrNjtwPFmdC0MX0y3Nb6Tq3h60fzRjFkQGyK4tcp
         rklTOXl9hzWu8a9l6T36hzqS/S2oypYDWtWQYr40=
Date:   Mon, 19 Jun 2023 16:10:45 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-allow-pte_offset_map-to-fail-fix.patch removed from -mm tree
Message-Id: <20230619231046.1D528C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: allow pte_offset_map[_lock]() to fail: fix
has been removed from the -mm tree.  Its filename was
     mm-memory-allow-pte_offset_map-to-fail-fix.patch

This patch was dropped because it was folded into perf-core-allow-pte_offset_map-to-fail.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memory: allow pte_offset_map[_lock]() to fail: fix
Date: Thu, 15 Jun 2023 16:10:00 -0700 (PDT)

__wp_page_copy_user() was liable to call update_mmu_tlb() with NULL
vmf->pte in two places: not a problem today, but could become a problem
later when pte_offset_map_lock() fails.

Link: https://lkml.kernel.org/r/1a4db221-7872-3594-57ce-42369945ec8d@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-allow-pte_offset_map-to-fail-fix
+++ a/mm/memory.c
@@ -2846,7 +2846,8 @@ static inline int __wp_page_copy_user(st
 			 * Other thread has already handled the fault
 			 * and update local tlb only
 			 */
-			update_mmu_tlb(vma, addr, vmf->pte);
+			if (vmf->pte)
+				update_mmu_tlb(vma, addr, vmf->pte);
 			ret = -EAGAIN;
 			goto pte_unlock;
 		}
@@ -2870,7 +2871,8 @@ static inline int __wp_page_copy_user(st
 		vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
 		if (unlikely(!vmf->pte || !pte_same(*vmf->pte, vmf->orig_pte))) {
 			/* The PTE changed under us, update local tlb */
-			update_mmu_tlb(vma, addr, vmf->pte);
+			if (vmf->pte)
+				update_mmu_tlb(vma, addr, vmf->pte);
 			ret = -EAGAIN;
 			goto pte_unlock;
 		}
_

Patches currently in -mm which might be from hughd@google.com are

arm-allow-pte_offset_map-to-fail.patch
arm64-allow-pte_offset_map-to-fail.patch
arm64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
ia64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
m68k-allow-pte_offset_map-to-fail.patch
microblaze-allow-pte_offset_map-to-fail.patch
mips-add-pte_unmap-to-balance-pte_offset_map.patch
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

