From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch added to
 -mm tree
Date: Tue, 14 Apr 2020 17:40:18 -0700
Message-ID: <20200415004018.SNkxVw-7x%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733064AbgDOAkV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Apr 2020 20:40:21 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org, catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org, fenghua.yu@intel.com, geert+renesas@glider.be, gxt@pku.edu.cn, james.morse@arm.com, jonas@southpole.se, julien.thierry.kdev@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, maz@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, rppt@linux.ibm.com, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, suzuki.poulose@arm.com, tony.luck@intel.com, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: drop __pXd_offset() macros that duplicate pXd_index() ones
has been added to the -mm tree.  Its filename is
     sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch

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
Subject: sh: drop __pXd_offset() macros that duplicate pXd_index() ones

The __pXd_offset() macros are identical to the pXd_index() macros and
there is no point to keep both of them.  All architectures define and use
pXd_index() so let's keep only those to make mips consistent with the rest
of the kernel.

Link: http://lkml.kernel.org/r/20200414153455.21744-11-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: James Morse <james.morse@arm.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/pgtable_32.h |    5 ++---
 arch/sh/include/asm/pgtable_64.h |    5 ++---
 arch/sh/mm/init.c                |    6 +++---
 3 files changed, 7 insertions(+), 9 deletions(-)

--- a/arch/sh/include/asm/pgtable_32.h~sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -407,13 +407,12 @@ static inline pte_t pte_modify(pte_t pte
 /* to find an entry in a page-table-directory. */
 #define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
 #define pgd_offset(mm, address)	((mm)->pgd + pgd_index(address))
-#define __pgd_offset(address)	pgd_index(address)
 
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(address)	pgd_offset(&init_mm, address)
 
-#define __pud_offset(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-#define __pmd_offset(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
+#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
+#define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
 /* Find an entry in the third-level page table.. */
 #define pte_index(address)	((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
--- a/arch/sh/include/asm/pgtable_64.h~sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones
+++ a/arch/sh/include/asm/pgtable_64.h
@@ -46,14 +46,13 @@ static __inline__ void set_pte(pte_t *pt
 
 /* To find an entry in a generic PGD. */
 #define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define __pgd_offset(address) pgd_index(address)
 #define pgd_offset(mm, address) ((mm)->pgd+pgd_index(address))
 
 /* To find an entry in a kernel PGD. */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
-#define __pud_offset(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-#define __pmd_offset(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
+#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
+/* #define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1)) */
 
 /*
  * PMD level access routines. Same notes as above.
--- a/arch/sh/mm/init.c~sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones
+++ a/arch/sh/mm/init.c
@@ -172,9 +172,9 @@ void __init page_table_range_init(unsign
 	unsigned long vaddr;
 
 	vaddr = start;
-	i = __pgd_offset(vaddr);
-	j = __pud_offset(vaddr);
-	k = __pmd_offset(vaddr);
+	i = pgd_index(vaddr);
+	j = pud_index(vaddr);
+	k = pmd_index(vaddr);
 	pgd = pgd_base + i;
 
 	for ( ; (i < PTRS_PER_PGD) && (vaddr != end); pgd++, i++) {
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
mm-rename-free_area_init_node-to-free_area_init_memoryless_node.patch
mm-clean-up-free_area_init_node-and-its-helpers.patch
mm-simplify-find_min_pfn_with_active_regions.patch
docs-vm-update-memory-models-documentation.patch
