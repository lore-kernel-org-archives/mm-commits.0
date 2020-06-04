From: akpm@linux-foundation.org
Subject: [folded-merged]
 powerpc-add-support-for-folded-p4d-page-tables-fix.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 16:05:51 -0700
Message-ID: <20200604230551.b-0km8CkU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgFDXPP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:15:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com, sfr@canb.auug.org.au


The patch titled
     Subject: powerpc-add-support-for-folded-p4d-page-tables-fix
has been removed from the -mm tree.  Its filename was
     powerpc-add-support-for-folded-p4d-page-tables-fix.patch

This patch was dropped because it was folded into powerpc-add-support-for-folded-p4d-page-tables.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: powerpc-add-support-for-folded-p4d-page-tables-fix

build fix

Link: http://lkml.kernel.org/r/20200423141845.GI13521@linux.ibm.com
Reported-by: kbuild test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/kasan/kasan_init_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/kasan/kasan_init_32.c~powerpc-add-support-for-folded-p4d-page-tables-fix
+++ a/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -121,7 +121,7 @@ static void __init kasan_unmap_early_sha
 	phys_addr_t pa = __pa(kasan_early_shadow_page);
 
 	for (k_cur = k_start & PAGE_MASK; k_cur < k_end; k_cur += PAGE_SIZE) {
-		pmd_t *pmd = pmd_offset(pud_offset(pgd_offset_k(k_cur), k_cur), k_cur);
+		pmd_t *pmd = pmd_ptr_k(k_cur);
 		pte_t *ptep = pte_offset_kernel(pmd, k_cur);
 
 		if ((pte_val(*ptep) & PTE_RPN_MASK) != pa)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

h8300-remove-usage-of-__arch_use_5level_hack.patch
arm-add-support-for-folded-p4d-page-tables.patch
arm64-add-support-for-folded-p4d-page-tables.patch
hexagon-remove-__arch_use_5level_hack.patch
ia64-add-support-for-folded-p4d-page-tables.patch
nios2-add-support-for-folded-p4d-page-tables.patch
openrisc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables.patch
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
x86-mm-simplify-init_trampoline-and-surrounding-logic-fix.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix.patch
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pmd_index-and-pmd_offset-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
