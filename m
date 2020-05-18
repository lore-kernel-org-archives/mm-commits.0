From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-2.patch added
 to -mm tree
Date: Mon, 18 May 2020 15:52:25 -0700
Message-ID: <20200518225225.h0PDoJHVi%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgERWw0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 18:52:26 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com, sfr@canb.auug.org.au


The patch titled
     Subject: powerpc/kasan: fix PMD access in kasan_unmap_early_shadow_vmalloc()
has been added to the -mm tree.  Its filename is
     mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: powerpc/kasan: fix PMD access in kasan_unmap_early_shadow_vmalloc()

The introduction of the generic shortcuts for PMD entry access broke PMD
access in kasan_unmap_early_shadow_vmalloc() because the name used in
powerpc for the same helper was different from the generic one.

Link: http://lkml.kernel.org/r/20200516172304.GC1059226@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kbuild test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/kasan/kasan_init_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/kasan/kasan_init_32.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-2
+++ a/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -121,7 +121,7 @@ static void __init kasan_unmap_early_sha
 	phys_addr_t pa = __pa(kasan_early_shadow_page);
 
 	for (k_cur = k_start & PAGE_MASK; k_cur < k_end; k_cur += PAGE_SIZE) {
-		pmd_t *pmd = pmd_ptr_k(k_cur);
+		pmd_t *pmd = pmd_off_k(k_cur);
 		pte_t *ptep = pte_offset_kernel(pmd, k_cur);
 
 		if ((pte_val(*ptep) & PTE_RPN_MASK) != pa)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls.patch
mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch
mm-remove-config_have_memblock_node_map-option.patch
mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes.patch
mm-use-free_area_init-instead-of-free_area_init_nodes.patch
alpha-simplify-detection-of-memory-zone-boundaries.patch
arm-simplify-detection-of-memory-zone-boundaries.patch
arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch
csky-simplify-detection-of-memory-zone-boundaries.patch
m68k-mm-simplify-detection-of-memory-zone-boundaries.patch
parisc-simplify-detection-of-memory-zone-boundaries.patch
sparc32-simplify-detection-of-memory-zone-boundaries.patch
unicore32-simplify-detection-of-memory-zone-boundaries.patch
xtensa-simplify-detection-of-memory-zone-boundaries.patch
mm-remove-early_pfn_in_nid-and-config_nodes_span_other_nodes.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2.patch
mm-rename-free_area_init_node-to-free_area_init_memoryless_node.patch
mm-clean-up-free_area_init_node-and-its-helpers.patch
mm-simplify-find_min_pfn_with_active_regions.patch
docs-vm-update-memory-models-documentation.patch
h8300-remove-usage-of-__arch_use_5level_hack.patch
arm-add-support-for-folded-p4d-page-tables.patch
arm-add-support-for-folded-p4d-page-tables-fix.patch
arm64-add-support-for-folded-p4d-page-tables.patch
hexagon-remove-__arch_use_5level_hack.patch
ia64-add-support-for-folded-p4d-page-tables.patch
nios2-add-support-for-folded-p4d-page-tables.patch
openrisc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables-fix.patch
sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch
sh-add-support-for-folded-p4d-page-tables.patch
unicore32-remove-__arch_use_5level_hack.patch
asm-generic-remove-pgtable-nop4d-hackh.patch
mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph.patch
mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included.patch
mm-introduce-include-linux-pgtableh.patch
mm-reorder-includes-after-introduction-of-linux-pgtableh.patch
csky-replace-definitions-of-__pxd_offset-with-pxd_index.patch
m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons.patch
m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch
x86-mm-simplify-init_trampoline-and-surrounding-logic.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-2.patch
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pmd_index-and-pmd_offset-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
