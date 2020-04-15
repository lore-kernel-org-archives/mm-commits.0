From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-add-support-for-folded-p4d-page-tables.patch added
 to -mm tree
Date: Tue, 14 Apr 2020 17:40:22 -0700
Message-ID: <20200415004022.ruzi_wZVt%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733064AbgDOAk0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Apr 2020 20:40:26 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org, catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org, fenghua.yu@intel.com, geert+renesas@glider.be, gxt@pku.edu.cn, james.morse@arm.com, jonas@southpole.se, julien.thierry.kdev@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, maz@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, rppt@linux.ibm.com, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, suzuki.poulose@arm.com, tony.luck@intel.com, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: add support for folded p4d page tables
has been added to the -mm tree.  Its filename is
     sh-add-support-for-folded-p4d-page-tables.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-add-support-for-folded-p4d-page-tables.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-add-support-for-folded-p4d-page-tables.patch

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
Subject: sh: add support for folded p4d page tables

Implement primitives necessary for the 4th level folding, add walks of p4d
level where appropriate and remove usage of __ARCH_USE_5LEVEL_HACK.

Link: http://lkml.kernel.org/r/20200414153455.21744-12-rppt@kernel.org
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

 arch/sh/include/asm/pgtable-2level.h |    1 
 arch/sh/include/asm/pgtable-3level.h |    1 
 arch/sh/kernel/io_trapped.c          |    7 +++++-
 arch/sh/mm/cache-sh4.c               |    4 ++-
 arch/sh/mm/cache-sh5.c               |    7 +++++-
 arch/sh/mm/fault.c                   |   26 ++++++++++++++++++++---
 arch/sh/mm/hugetlbpage.c             |   28 ++++++++++++++++---------
 arch/sh/mm/init.c                    |    9 +++++++-
 arch/sh/mm/kmap.c                    |    2 -
 arch/sh/mm/tlbex_32.c                |    6 ++++-
 arch/sh/mm/tlbex_64.c                |    7 +++++-
 11 files changed, 76 insertions(+), 22 deletions(-)

--- a/arch/sh/include/asm/pgtable-2level.h~sh-add-support-for-folded-p4d-page-tables
+++ a/arch/sh/include/asm/pgtable-2level.h
@@ -2,7 +2,6 @@
 #ifndef __ASM_SH_PGTABLE_2LEVEL_H
 #define __ASM_SH_PGTABLE_2LEVEL_H
 
-#define __ARCH_USE_5LEVEL_HACK
 #include <asm-generic/pgtable-nopmd.h>
 
 /*
--- a/arch/sh/include/asm/pgtable-3level.h~sh-add-support-for-folded-p4d-page-tables
+++ a/arch/sh/include/asm/pgtable-3level.h
@@ -2,7 +2,6 @@
 #ifndef __ASM_SH_PGTABLE_3LEVEL_H
 #define __ASM_SH_PGTABLE_3LEVEL_H
 
-#define __ARCH_USE_5LEVEL_HACK
 #include <asm-generic/pgtable-nopud.h>
 
 /*
--- a/arch/sh/kernel/io_trapped.c~sh-add-support-for-folded-p4d-page-tables
+++ a/arch/sh/kernel/io_trapped.c
@@ -136,6 +136,7 @@ EXPORT_SYMBOL_GPL(match_trapped_io_handl
 static struct trapped_io *lookup_tiop(unsigned long address)
 {
 	pgd_t *pgd_k;
+	p4d_t *p4d_k;
 	pud_t *pud_k;
 	pmd_t *pmd_k;
 	pte_t *pte_k;
@@ -145,7 +146,11 @@ static struct trapped_io *lookup_tiop(un
 	if (!pgd_present(*pgd_k))
 		return NULL;
 
-	pud_k = pud_offset(pgd_k, address);
+	p4d_k = p4d_offset(pgd_k, address);
+	if (!p4d_present(*p4d_k))
+		return NULL;
+
+	pud_k = pud_offset(p4d_k, address);
 	if (!pud_present(*pud_k))
 		return NULL;
 
--- a/arch/sh/mm/cache-sh4.c~sh-add-support-for-folded-p4d-page-tables
+++ a/arch/sh/mm/cache-sh4.c
@@ -209,6 +209,7 @@ static void sh4_flush_cache_page(void *a
 	unsigned long address, pfn, phys;
 	int map_coherent = 0;
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
@@ -224,7 +225,8 @@ static void sh4_flush_cache_page(void *a
 		return;
 
 	pgd = pgd_offset(vma->vm_mm, address);
-	pud = pud_offset(pgd, address);
+	p4d = p4d_offset(pgd, address);
+	pud = pud_offset(p4d, address);
 	pmd = pmd_offset(pud, address);
 	pte = pte_offset_kernel(pmd, address);
 
--- a/arch/sh/mm/cache-sh5.c~sh-add-support-for-folded-p4d-page-tables
+++ a/arch/sh/mm/cache-sh5.c
@@ -383,6 +383,7 @@ static void sh64_dcache_purge_user_pages
 				unsigned long addr, unsigned long end)
 {
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
@@ -397,7 +398,11 @@ static void sh64_dcache_purge_user_pages
 	if (pgd_bad(*pgd))
 		return;
 
-	pud = pud_offset(pgd, addr);
+	p4d = p4d_offset(pgd, addr);
+	if (p4d_none(*p4d) || p4d_bad(*p4d))
+		return;
+
+	pud = pud_offset(p4d, addr);
 	if (pud_none(*pud) || pud_bad(*pud))
 		return;
 
--- a/arch/sh/mm/fault.c~sh-add-support-for-folded-p4d-page-tables
+++ a/arch/sh/mm/fault.c
@@ -53,6 +53,7 @@ static void show_pte(struct mm_struct *m
 		 (u64)pgd_val(*pgd));
 
 	do {
+		p4d_t *p4d;
 		pud_t *pud;
 		pmd_t *pmd;
 		pte_t *pte;
@@ -65,7 +66,20 @@ static void show_pte(struct mm_struct *m
 			break;
 		}
 
-		pud = pud_offset(pgd, addr);
+		p4d = p4d_offset(pgd, addr);
+		if (PTRS_PER_P4D != 1)
+			pr_cont(", *p4d=%0*Lx", (u32)(sizeof(*p4d) * 2),
+			        (u64)p4d_val(*p4d));
+
+		if (p4d_none(*p4d))
+			break;
+
+		if (p4d_bad(*p4d)) {
+			pr_cont("(bad)");
+			break;
+		}
+
+		pud = pud_offset(p4d, addr);
 		if (PTRS_PER_PUD != 1)
 			pr_cont(", *pud=%0*llx", (u32)(sizeof(*pud) * 2),
 				(u64)pud_val(*pud));
@@ -107,6 +121,7 @@ static inline pmd_t *vmalloc_sync_one(pg
 {
 	unsigned index = pgd_index(address);
 	pgd_t *pgd_k;
+	p4d_t *p4d, *p4d_k;
 	pud_t *pud, *pud_k;
 	pmd_t *pmd, *pmd_k;
 
@@ -116,8 +131,13 @@ static inline pmd_t *vmalloc_sync_one(pg
 	if (!pgd_present(*pgd_k))
 		return NULL;
 
-	pud = pud_offset(pgd, address);
-	pud_k = pud_offset(pgd_k, address);
+	p4d = p4d_offset(pgd, address);
+	p4d_k = p4d_offset(pgd_k, address);
+	if (!p4d_present(*p4d_k))
+		return NULL;
+
+	pud = pud_offset(p4d, address);
+	pud_k = pud_offset(p4d_k, address);
 	if (!pud_present(*pud_k))
 		return NULL;
 
--- a/arch/sh/mm/hugetlbpage.c~sh-add-support-for-folded-p4d-page-tables
+++ a/arch/sh/mm/hugetlbpage.c
@@ -26,17 +26,21 @@ pte_t *huge_pte_alloc(struct mm_struct *
 			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte = NULL;
 
 	pgd = pgd_offset(mm, addr);
 	if (pgd) {
-		pud = pud_alloc(mm, pgd, addr);
-		if (pud) {
-			pmd = pmd_alloc(mm, pud, addr);
-			if (pmd)
-				pte = pte_alloc_map(mm, pmd, addr);
+		p4d = p4d_alloc(mm, pgd, addr);
+		if (p4d) {
+			pud = pud_alloc(mm, p4d, addr);
+			if (pud) {
+				pmd = pmd_alloc(mm, pud, addr);
+				if (pmd)
+					pte = pte_alloc_map(mm, pmd, addr);
+			}
 		}
 	}
 
@@ -47,17 +51,21 @@ pte_t *huge_pte_offset(struct mm_struct
 		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte = NULL;
 
 	pgd = pgd_offset(mm, addr);
 	if (pgd) {
-		pud = pud_offset(pgd, addr);
-		if (pud) {
-			pmd = pmd_offset(pud, addr);
-			if (pmd)
-				pte = pte_offset_map(pmd, addr);
+		p4d = p4d_offset(pgd, addr);
+		if (p4d) {
+			pud = pud_offset(p4d, addr);
+			if (pud) {
+				pmd = pmd_offset(pud, addr);
+				if (pmd)
+					pte = pte_offset_map(pmd, addr);
+			}
 		}
 	}
 
--- a/arch/sh/mm/init.c~sh-add-support-for-folded-p4d-page-tables
+++ a/arch/sh/mm/init.c
@@ -45,6 +45,7 @@ void __init __weak plat_mem_setup(void)
 static pte_t *__get_pte_phys(unsigned long addr)
 {
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 
@@ -54,7 +55,13 @@ static pte_t *__get_pte_phys(unsigned lo
 		return NULL;
 	}
 
-	pud = pud_alloc(NULL, pgd, addr);
+	p4d = p4d_alloc(NULL, pgd, addr);
+	if (unlikely(!p4d)) {
+		p4d_ERROR(*p4d);
+		return NULL;
+	}
+
+	pud = pud_alloc(NULL, p4d, addr);
 	if (unlikely(!pud)) {
 		pud_ERROR(*pud);
 		return NULL;
--- a/arch/sh/mm/kmap.c~sh-add-support-for-folded-p4d-page-tables
+++ a/arch/sh/mm/kmap.c
@@ -15,7 +15,7 @@
 #include <asm/cacheflush.h>
 
 #define kmap_get_fixmap_pte(vaddr)                                     \
-	pte_offset_kernel(pmd_offset(pud_offset(pgd_offset_k(vaddr), (vaddr)), (vaddr)), (vaddr))
+	pte_offset_kernel(pmd_offset(pud_offset(p4d_offset(pgd_offset_k(vaddr), (vaddr)), (vaddr)), (vaddr)), vaddr)
 
 static pte_t *kmap_coherent_pte;
 
--- a/arch/sh/mm/tlbex_32.c~sh-add-support-for-folded-p4d-page-tables
+++ a/arch/sh/mm/tlbex_32.c
@@ -23,6 +23,7 @@ handle_tlbmiss(struct pt_regs *regs, uns
 	       unsigned long address)
 {
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
@@ -42,7 +43,10 @@ handle_tlbmiss(struct pt_regs *regs, uns
 		pgd = pgd_offset(current->mm, address);
 	}
 
-	pud = pud_offset(pgd, address);
+	p4d = p4d_offset(pgd, address);
+	if (p4d_none_or_clear_bad(p4d))
+		return 1;
+	pud = pud_offset(p4d, address);
 	if (pud_none_or_clear_bad(pud))
 		return 1;
 	pmd = pmd_offset(pud, address);
--- a/arch/sh/mm/tlbex_64.c~sh-add-support-for-folded-p4d-page-tables
+++ a/arch/sh/mm/tlbex_64.c
@@ -44,6 +44,7 @@ static int handle_tlbmiss(unsigned long
 			  unsigned long address)
 {
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
@@ -58,7 +59,11 @@ static int handle_tlbmiss(unsigned long
 		pgd = pgd_offset(current->mm, address);
 	}
 
-	pud = pud_offset(pgd, address);
+	p4d = p4d_offset(pgd, address);
+	if (p4d_none(*p4d) || !p4d_present(*p4d))
+		return 1;
+
+	pud = pud_offset(p4d, address);
 	if (pud_none(*pud) || !pud_present(*pud))
 		return 1;
 
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
