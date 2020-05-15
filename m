From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch added
 to -mm tree
Date: Fri, 15 May 2020 14:15:30 -0700
Message-ID: <20200515211530.Z3x33A0Hr%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgEOVPd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 May 2020 17:15:33 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.org, ysato@users.sourceforge.jp


The patch titled
     Subject: m68k/mm: move {cache,nocahe}_page() definitions close to their user
has been added to the -mm tree.  Its filename is
     m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch

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
Subject: m68k/mm: move {cache,nocahe}_page() definitions close to their user

The cache_page() and nocache_page() functions are only used by the
motorola MMU variant for setting caching attributes for the page table
pages.

Move the definitions of these functions from
arch/m68k/include/asm/motorola_pgtable.h closer to their usage in
arch/m68k/mm/motorola.c and drop unused definition in
arch/m68k/include/asm/mcf_pgtable.h.

Link: http://lkml.kernel.org/r/20200514170327.31389-7-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/mcf_pgtable.h      |   40 -------------------
 arch/m68k/include/asm/motorola_pgtable.h |   44 ---------------------
 arch/m68k/mm/motorola.c                  |   43 ++++++++++++++++++++
 3 files changed, 43 insertions(+), 84 deletions(-)

--- a/arch/m68k/include/asm/mcf_pgtable.h~m68k-mm-move-cachenocahe_page-definitions-close-to-their-user
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -329,46 +329,6 @@ extern pgd_t kernel_pg_dir[PTRS_PER_PGD]
 	((pte_t *) __pmd_page(*(dir)) + __pte_offset(address))
 
 /*
- * Disable caching for page at given kernel virtual address.
- */
-static inline void nocache_page(void *vaddr)
-{
-	pgd_t *dir;
-	p4d_t *p4dp;
-	pud_t *pudp;
-	pmd_t *pmdp;
-	pte_t *ptep;
-	unsigned long addr = (unsigned long) vaddr;
-
-	dir = pgd_offset_k(addr);
-	p4dp = p4d_offset(dir, addr);
-	pudp = pud_offset(p4dp, addr);
-	pmdp = pmd_offset(pudp, addr);
-	ptep = pte_offset_kernel(pmdp, addr);
-	*ptep = pte_mknocache(*ptep);
-}
-
-/*
- * Enable caching for page at given kernel virtual address.
- */
-static inline void cache_page(void *vaddr)
-{
-	pgd_t *dir;
-	p4d_t *p4dp;
-	pud_t *pudp;
-	pmd_t *pmdp;
-	pte_t *ptep;
-	unsigned long addr = (unsigned long) vaddr;
-
-	dir = pgd_offset_k(addr);
-	p4dp = p4d_offset(dir, addr);
-	pudp = pud_offset(p4dp, addr);
-	pmdp = pmd_offset(pudp, addr);
-	ptep = pte_offset_kernel(pmdp, addr);
-	*ptep = pte_mkcache(*ptep);
-}
-
-/*
  * Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e))
  */
 #define __swp_type(x)		((x).val & 0xFF)
--- a/arch/m68k/include/asm/motorola_pgtable.h~m68k-mm-move-cachenocahe_page-definitions-close-to-their-user
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -227,50 +227,6 @@ static inline pte_t *pte_offset_kernel(p
 #define pte_offset_map(pmdp,address) ((pte_t *)__pmd_page(*pmdp) + (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
 #define pte_unmap(pte)		((void)0)
 
-/* Prior to calling these routines, the page should have been flushed
- * from both the cache and ATC, or the CPU might not notice that the
- * cache setting for the page has been changed. -jskov
- */
-static inline void nocache_page(void *vaddr)
-{
-	unsigned long addr = (unsigned long)vaddr;
-
-	if (CPU_IS_040_OR_060) {
-		pgd_t *dir;
-		p4d_t *p4dp;
-		pud_t *pudp;
-		pmd_t *pmdp;
-		pte_t *ptep;
-
-		dir = pgd_offset_k(addr);
-		p4dp = p4d_offset(dir, addr);
-		pudp = pud_offset(p4dp, addr);
-		pmdp = pmd_offset(pudp, addr);
-		ptep = pte_offset_kernel(pmdp, addr);
-		*ptep = pte_mknocache(*ptep);
-	}
-}
-
-static inline void cache_page(void *vaddr)
-{
-	unsigned long addr = (unsigned long)vaddr;
-
-	if (CPU_IS_040_OR_060) {
-		pgd_t *dir;
-		p4d_t *p4dp;
-		pud_t *pudp;
-		pmd_t *pmdp;
-		pte_t *ptep;
-
-		dir = pgd_offset_k(addr);
-		p4dp = p4d_offset(dir, addr);
-		pudp = pud_offset(p4dp, addr);
-		pmdp = pmd_offset(pudp, addr);
-		ptep = pte_offset_kernel(pmdp, addr);
-		*ptep = pte_mkcache(*ptep);
-	}
-}
-
 /* Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e)) */
 #define __swp_type(x)		(((x).val >> 4) & 0xff)
 #define __swp_offset(x)		((x).val >> 12)
--- a/arch/m68k/mm/motorola.c~m68k-mm-move-cachenocahe_page-definitions-close-to-their-user
+++ a/arch/m68k/mm/motorola.c
@@ -45,6 +45,49 @@ unsigned long mm_cachebits;
 EXPORT_SYMBOL(mm_cachebits);
 #endif
 
+/* Prior to calling these routines, the page should have been flushed
+ * from both the cache and ATC, or the CPU might not notice that the
+ * cache setting for the page has been changed. -jskov
+ */
+static inline void nocache_page(void *vaddr)
+{
+	unsigned long addr = (unsigned long)vaddr;
+
+	if (CPU_IS_040_OR_060) {
+		pgd_t *dir;
+		p4d_t *p4dp;
+		pud_t *pudp;
+		pmd_t *pmdp;
+		pte_t *ptep;
+
+		dir = pgd_offset_k(addr);
+		p4dp = p4d_offset(dir, addr);
+		pudp = pud_offset(p4dp, addr);
+		pmdp = pmd_offset(pudp, addr);
+		ptep = pte_offset_kernel(pmdp, addr);
+		*ptep = pte_mknocache(*ptep);
+	}
+}
+
+static inline void cache_page(void *vaddr)
+{
+	unsigned long addr = (unsigned long)vaddr;
+
+	if (CPU_IS_040_OR_060) {
+		pgd_t *dir;
+		p4d_t *p4dp;
+		pud_t *pudp;
+		pmd_t *pmdp;
+		pte_t *ptep;
+
+		dir = pgd_offset_k(addr);
+		p4dp = p4d_offset(dir, addr);
+		pudp = pud_offset(p4dp, addr);
+		pmdp = pmd_offset(pudp, addr);
+		ptep = pte_offset_kernel(pmdp, addr);
+		*ptep = pte_mkcache(*ptep);
+	}
+}
 
 /*
  * Motorola 680x0 user's manual recommends using uncached memory for address
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
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pmd_index-and-pmd_offset-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
