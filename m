From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-remove-=5F=5Farch=5Fhas=5F5level=5Fhack-and-include-asm?=
 =?US-ASCII?Q?-generic-5level-fixuph.patch?= removed from -mm tree
Date: Fri, 05 Jun 2020 13:17:05 -0700
Message-ID: <20200605201705.ku5pGH49i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728112AbgFEURH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:17:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org, catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org, fenghua.yu@intel.com, geert+renesas@glider.be, gxt@pku.edu.cn, james.morse@arm.com, jonas@southpole.se, julien.thierry.kdev@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, maz@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, rppt@linux.ibm.com, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, suzuki.poulose@arm.com, tony.luck@intel.com, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: remove __ARCH_HAS_5LEVEL_HACK and include/asm-generic/5level-fixup.h
has been removed from the -mm tree.  Its filename was
     mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: remove __ARCH_HAS_5LEVEL_HACK and include/asm-generic/5level-fixup.h

There are no architectures that use include/asm-generic/5level-fixup.h
therefore it can be removed along with __ARCH_HAS_5LEVEL_HACK define and
the code it surrounds

Link: http://lkml.kernel.org/r/20200414153455.21744-15-rppt@kernel.org
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

 include/asm-generic/5level-fixup.h |   59 ---------------------------
 include/linux/mm.h                 |    7 ---
 mm/kasan/init.c                    |   11 -----
 mm/memory.c                        |    8 ---
 4 files changed, 85 deletions(-)

--- a/include/asm-generic/5level-fixup.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _5LEVEL_FIXUP_H
-#define _5LEVEL_FIXUP_H
-
-#define __ARCH_HAS_5LEVEL_HACK
-#define __PAGETABLE_P4D_FOLDED 1
-
-#define P4D_SHIFT			PGDIR_SHIFT
-#define P4D_SIZE			PGDIR_SIZE
-#define P4D_MASK			PGDIR_MASK
-#define MAX_PTRS_PER_P4D		1
-#define PTRS_PER_P4D			1
-
-#define p4d_t				pgd_t
-
-#define pud_alloc(mm, p4d, address) \
-	((unlikely(pgd_none(*(p4d))) && __pud_alloc(mm, p4d, address)) ? \
-		NULL : pud_offset(p4d, address))
-
-#define p4d_alloc(mm, pgd, address)		(pgd)
-#define p4d_alloc_track(mm, pgd, address, mask)	(pgd)
-#define p4d_offset(pgd, start)			(pgd)
-
-#ifndef __ASSEMBLY__
-static inline int p4d_none(p4d_t p4d)
-{
-	return 0;
-}
-
-static inline int p4d_bad(p4d_t p4d)
-{
-	return 0;
-}
-
-static inline int p4d_present(p4d_t p4d)
-{
-	return 1;
-}
-#endif
-
-#define p4d_ERROR(p4d)			do { } while (0)
-#define p4d_clear(p4d)			pgd_clear(p4d)
-#define p4d_val(p4d)			pgd_val(p4d)
-#define p4d_populate(mm, p4d, pud)	pgd_populate(mm, p4d, pud)
-#define p4d_populate_safe(mm, p4d, pud)	pgd_populate(mm, p4d, pud)
-#define p4d_page(p4d)			pgd_page(p4d)
-#define p4d_page_vaddr(p4d)		pgd_page_vaddr(p4d)
-
-#define __p4d(x)			__pgd(x)
-#define set_p4d(p4dp, p4d)		set_pgd(p4dp, p4d)
-
-#undef p4d_free_tlb
-#define p4d_free_tlb(tlb, x, addr)	do { } while (0)
-#define p4d_free(mm, x)			do { } while (0)
-
-#undef  p4d_addr_end
-#define p4d_addr_end(addr, end)		(end)
-
-#endif
--- a/include/linux/mm.h~mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph
+++ a/include/linux/mm.h
@@ -2069,11 +2069,6 @@ int __pte_alloc_kernel(pmd_t *pmd);
 
 #if defined(CONFIG_MMU)
 
-/*
- * The following ifdef needed to get the 5level-fixup.h header to work.
- * Remove it when 5level-fixup.h has been removed.
- */
-#ifndef __ARCH_HAS_5LEVEL_HACK
 static inline p4d_t *p4d_alloc(struct mm_struct *mm, pgd_t *pgd,
 		unsigned long address)
 {
@@ -2102,8 +2097,6 @@ static inline p4d_t *p4d_alloc_track(str
 	return p4d_offset(pgd, address);
 }
 
-#endif /* !__ARCH_HAS_5LEVEL_HACK */
-
 static inline pud_t *pud_alloc_track(struct mm_struct *mm, p4d_t *p4d,
 				     unsigned long address,
 				     pgtbl_mod_mask *mod_mask)
--- a/mm/kasan/init.c~mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph
+++ a/mm/kasan/init.c
@@ -250,20 +250,9 @@ int __ref kasan_populate_early_shadow(co
 			 * 3,2 - level page tables where we don't have
 			 * puds,pmds, so pgd_populate(), pud_populate()
 			 * is noops.
-			 *
-			 * The ifndef is required to avoid build breakage.
-			 *
-			 * With 5level-fixup.h, pgd_populate() is not nop and
-			 * we reference kasan_early_shadow_p4d. It's not defined
-			 * unless 5-level paging enabled.
-			 *
-			 * The ifndef can be dropped once all KASAN-enabled
-			 * architectures will switch to pgtable-nop4d.h.
 			 */
-#ifndef __ARCH_HAS_5LEVEL_HACK
 			pgd_populate(&init_mm, pgd,
 					lm_alias(kasan_early_shadow_p4d));
-#endif
 			p4d = p4d_offset(pgd, addr);
 			p4d_populate(&init_mm, p4d,
 					lm_alias(kasan_early_shadow_pud));
--- a/mm/memory.c~mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph
+++ a/mm/memory.c
@@ -4436,19 +4436,11 @@ int __pud_alloc(struct mm_struct *mm, p4
 	smp_wmb(); /* See comment in __pte_alloc */
 
 	spin_lock(&mm->page_table_lock);
-#ifndef __ARCH_HAS_5LEVEL_HACK
 	if (!p4d_present(*p4d)) {
 		mm_inc_nr_puds(mm);
 		p4d_populate(mm, p4d, new);
 	} else	/* Another has populated it */
 		pud_free(mm, new);
-#else
-	if (!pgd_present(*p4d)) {
-		mm_inc_nr_puds(mm);
-		pgd_populate(mm, p4d, new);
-	} else	/* Another has populated it */
-		pud_free(mm, new);
-#endif /* __ARCH_HAS_5LEVEL_HACK */
 	spin_unlock(&mm->page_table_lock);
 	return 0;
 }
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

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
