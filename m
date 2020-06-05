From: akpm@linux-foundation.org
Subject: [merged] asm-generic-remove-pgtable-nop4d-hackh.patch
 removed from -mm tree
Date: Fri, 05 Jun 2020 13:17:03 -0700
Message-ID: <20200605201703.eWrooyC6q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgFEURF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:17:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org, catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org, fenghua.yu@intel.com, geert+renesas@glider.be, gxt@pku.edu.cn, james.morse@arm.com, jonas@southpole.se, julien.thierry.kdev@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, maz@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, rppt@linux.ibm.com, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, suzuki.poulose@arm.com, tony.luck@intel.com, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: asm-generic: remove pgtable-nop4d-hack.h
has been removed from the -mm tree.  Its filename was
     asm-generic-remove-pgtable-nop4d-hackh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: asm-generic: remove pgtable-nop4d-hack.h

No architecture defines __ARCH_USE_5LEVEL_HACK and therefore
pgtable-nop4d-hack.h will be never actually included.

Remove it.

Link: http://lkml.kernel.org/r/20200414153455.21744-14-rppt@kernel.org
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

 include/asm-generic/pgtable-nop4d-hack.h |   64 ---------------------
 include/asm-generic/pgtable-nopud.h      |    4 -
 2 files changed, 68 deletions(-)

--- a/include/asm-generic/pgtable-nop4d-hack.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _PGTABLE_NOP4D_HACK_H
-#define _PGTABLE_NOP4D_HACK_H
-
-#ifndef __ASSEMBLY__
-#include <asm-generic/5level-fixup.h>
-
-#define __PAGETABLE_PUD_FOLDED 1
-
-/*
- * Having the pud type consist of a pgd gets the size right, and allows
- * us to conceptually access the pgd entry that this pud is folded into
- * without casting.
- */
-typedef struct { pgd_t pgd; } pud_t;
-
-#define PUD_SHIFT	PGDIR_SHIFT
-#define PTRS_PER_PUD	1
-#define PUD_SIZE	(1UL << PUD_SHIFT)
-#define PUD_MASK	(~(PUD_SIZE-1))
-
-/*
- * The "pgd_xxx()" functions here are trivial for a folded two-level
- * setup: the pud is never bad, and a pud always exists (as it's folded
- * into the pgd entry)
- */
-static inline int pgd_none(pgd_t pgd)		{ return 0; }
-static inline int pgd_bad(pgd_t pgd)		{ return 0; }
-static inline int pgd_present(pgd_t pgd)	{ return 1; }
-static inline void pgd_clear(pgd_t *pgd)	{ }
-#define pud_ERROR(pud)				(pgd_ERROR((pud).pgd))
-
-#define pgd_populate(mm, pgd, pud)		do { } while (0)
-#define pgd_populate_safe(mm, pgd, pud)		do { } while (0)
-/*
- * (puds are folded into pgds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pgd(pgdptr, pgdval)	set_pud((pud_t *)(pgdptr), (pud_t) { pgdval })
-
-static inline pud_t *pud_offset(pgd_t *pgd, unsigned long address)
-{
-	return (pud_t *)pgd;
-}
-
-#define pud_val(x)				(pgd_val((x).pgd))
-#define __pud(x)				((pud_t) { __pgd(x) })
-
-#define pgd_page(pgd)				(pud_page((pud_t){ pgd }))
-#define pgd_page_vaddr(pgd)			(pud_page_vaddr((pud_t){ pgd }))
-
-/*
- * allocating and freeing a pud is trivial: the 1-entry pud is
- * inside the pgd, so has no extra memory associated with it.
- */
-#define pud_alloc_one(mm, address)		NULL
-#define pud_free(mm, x)				do { } while (0)
-#define __pud_free_tlb(tlb, x, a)		do { } while (0)
-
-#undef  pud_addr_end
-#define pud_addr_end(addr, end)			(end)
-
-#endif /* __ASSEMBLY__ */
-#endif /* _PGTABLE_NOP4D_HACK_H */
--- a/include/asm-generic/pgtable-nopud.h~asm-generic-remove-pgtable-nop4d-hackh
+++ a/include/asm-generic/pgtable-nopud.h
@@ -4,9 +4,6 @@
 
 #ifndef __ASSEMBLY__
 
-#ifdef __ARCH_USE_5LEVEL_HACK
-#include <asm-generic/pgtable-nop4d-hack.h>
-#else
 #include <asm-generic/pgtable-nop4d.h>
 
 #define __PAGETABLE_PUD_FOLDED 1
@@ -65,5 +62,4 @@ static inline pud_t *pud_offset(p4d_t *p
 #define pud_addr_end(addr, end)			(end)
 
 #endif /* __ASSEMBLY__ */
-#endif /* !__ARCH_USE_5LEVEL_HACK */
 #endif /* _PGTABLE_NOPUD_H */
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
