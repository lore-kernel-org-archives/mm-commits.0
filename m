From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-consolidate-pud_index-and-pud_offset-definitions.patch added to -mm tree
Date: Fri, 15 May 2020 14:16:14 -0700
Message-ID: <20200515211614.dFQQRrGGt%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgEOVQS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 May 2020 17:16:18 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: consolidate pud_index() and pud_offset() definitions
has been added to the -mm tree.  Its filename is
     mm-consolidate-pud_index-and-pud_offset-definitions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consolidate-pud_index-and-pud_offset-definitions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consolidate-pud_index-and-pud_offset-definitions.patch

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
Subject: mm: consolidate pud_index() and pud_offset() definitions

All architectures that have at least four-level page tables define
pud_offset() as an entry in the array of PUDs indexed by the pud_index(),
where pud_index() is

	(address >> PUD_SHIFT) & (PTRS_PER_PUD - 1)

For the most architectures the pud_offset() implementation relies on the
availability of pud_page_vaddr() that converts a PUD entry value to the
virtual address of the page containing PUD array.

Let's use such implementation as a generic and drop most of the
definitions of pud_index() and pud_offset() in <asm/pgtable.h> files.

The architectures that didn't provide pud_page_vaddr() are updated to have
that defined.

The generic implementation can be overridden by an architecture and this
ability is currently in use by there architectures:
* s390 has custom definitions of all page table accessors

Link: http://lkml.kernel.org/r/20200514170327.31389-12-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
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

 arch/arm64/include/asm/pgtable.h                |    8 ++++---
 arch/csky/include/asm/pgtable.h                 |    2 -
 arch/ia64/include/asm/pgtable.h                 |    6 -----
 arch/mips/include/asm/pgtable-32.h              |    1 
 arch/mips/include/asm/pgtable-64.h              |    7 ------
 arch/powerpc/include/asm/book3s/64/pgtable.h    |    4 ---
 arch/powerpc/include/asm/nohash/64/pgtable-4k.h |    4 ---
 arch/s390/include/asm/pgtable.h                 |    1 
 arch/sh/include/asm/pgtable_32.h                |    2 -
 arch/sh/include/asm/pgtable_64.h                |    2 -
 arch/sparc/include/asm/pgtable_64.h             |    5 ----
 arch/x86/include/asm/pgtable.h                  |   11 ---------
 include/asm-generic/pgtable-nopud.h             |    1 
 include/linux/pgtable.h                         |   16 ++++++++++++++
 14 files changed, 23 insertions(+), 47 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/arm64/include/asm/pgtable.h
@@ -626,11 +626,13 @@ static inline phys_addr_t p4d_page_paddr
 	return __p4d_to_phys(p4d);
 }
 
-/* Find an entry in the frst-level page table. */
-#define pud_index(addr)		(((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
+static inline unsigned long p4d_page_vaddr(p4d_t p4d)
+{
+	return (unsigned long)__va(p4d_page_paddr(p4d));
+}
 
+/* Find an entry in the frst-level page table. */
 #define pud_offset_phys(dir, addr)	(p4d_page_paddr(READ_ONCE(*(dir))) + pud_index(addr) * sizeof(pud_t))
-#define pud_offset(dir, addr)		((pud_t *)__va(pud_offset_phys((dir), (addr))))
 
 #define pud_set_fixmap(addr)		((pud_t *)set_fixmap_offset(FIX_PUD, addr))
 #define pud_set_fixmap_offset(p4d, addr)	pud_set_fixmap(pud_offset_phys(p4d, addr))
--- a/arch/csky/include/asm/pgtable.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/csky/include/asm/pgtable.h
@@ -220,8 +220,6 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return pte;
 }
 
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(address)	pgd_offset(&init_mm, address)
 
--- a/arch/ia64/include/asm/pgtable.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/ia64/include/asm/pgtable.h
@@ -383,12 +383,6 @@ pgd_offset (const struct mm_struct *mm,
    here.  */
 #define pgd_offset_gate(mm, addr)	pgd_offset_k(addr)
 
-#if CONFIG_PGTABLE_LEVELS == 4
-/* Find an entry in the second-level page table.. */
-#define pud_offset(dir,addr) \
-	((pud_t *) p4d_page_vaddr(*(dir)) + (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1)))
-#endif
-
 /* atomic versions of the some PTE manipulations: */
 
 static inline int
--- a/arch/mips/include/asm/pgtable-32.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/mips/include/asm/pgtable-32.h
@@ -199,7 +199,6 @@ static inline pte_t pfn_pte(unsigned lon
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
 #define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
 
 /* to find an entry in a page-table-directory */
 #define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
--- a/arch/mips/include/asm/pgtable-64.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -172,8 +172,6 @@
 
 extern pte_t invalid_pte_table[PTRS_PER_PTE];
 
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
-
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
  * For 4-level pagetables we defines these ourselves, for 3-level the
@@ -222,11 +220,6 @@ static inline unsigned long p4d_page_vad
 
 #define p4d_index(address)	(((address) >> P4D_SHIFT) & (PTRS_PER_P4D - 1))
 
-static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
-{
-	return (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
-}
-
 static inline void set_p4d(p4d_t *p4d, p4d_t p4dval)
 {
 	*p4d = p4dval;
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1009,7 +1009,6 @@ extern struct page *p4d_page(p4d_t p4d);
 #define p4d_page_vaddr(p4d)	__va(p4d_val(p4d) & ~P4D_MASKED_BITS)
 
 #define pgd_index(address) (((address) >> (PGDIR_SHIFT)) & (PTRS_PER_PGD - 1))
-#define pud_index(address) (((address) >> (PUD_SHIFT)) & (PTRS_PER_PUD - 1))
 
 /*
  * Find an entry in a page-table-directory.  We combine the address region
@@ -1018,9 +1017,6 @@ extern struct page *p4d_page(p4d_t p4d);
 
 #define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
 
-#define pud_offset(p4dp, addr)	\
-	(((pud_t *) p4d_page_vaddr(*(p4dp))) + pud_index(addr))
-
 /* to find an entry in a kernel page-table-directory */
 /* This now only contains the vmalloc pages */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
--- a/arch/powerpc/include/asm/nohash/64/pgtable-4k.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/powerpc/include/asm/nohash/64/pgtable-4k.h
@@ -78,10 +78,6 @@ extern struct page *p4d_page(p4d_t p4d);
 
 #endif /* !__ASSEMBLY__ */
 
-#define pud_offset(p4dp, addr)	\
-  (((pud_t *) p4d_page_vaddr(*(p4dp))) + \
-    (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1)))
-
 #define pud_ERROR(e) \
 	pr_err("%s:%d: bad pud %08lx.\n", __FILE__, __LINE__, pud_val(e))
 
--- a/arch/s390/include/asm/pgtable.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/s390/include/asm/pgtable.h
@@ -1274,6 +1274,7 @@ static inline pud_t *pud_offset(p4d_t *p
 		return (pud_t *) p4d_deref(*p4d) + pud_index(address);
 	return (pud_t *) p4d;
 }
+#define pud_offset pud_offset
 
 static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 {
--- a/arch/sh/include/asm/pgtable_32.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -415,8 +415,6 @@ static inline unsigned long pmd_page_vad
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(address)	pgd_offset(&init_mm, address)
 
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-
 #ifdef CONFIG_X2TLB
 #define pte_ERROR(e) \
 	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, \
--- a/arch/sh/include/asm/pgtable_64.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/sh/include/asm/pgtable_64.h
@@ -51,8 +51,6 @@ static __inline__ void set_pte(pte_t *pt
 /* To find an entry in a kernel PGD. */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-
 /*
  * PMD level access routines. Same notes as above.
  */
--- a/arch/sparc/include/asm/pgtable_64.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -896,11 +896,6 @@ static inline unsigned long pud_pfn(pud_
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
-/* Find an entry in the third-level page table.. */
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
-#define pud_offset(p4dp, address)	\
-	((pud_t *) p4d_page_vaddr(*(p4dp)) + pud_index(address))
-
 /* We cannot include <linux/mm_types.h> at this point yet: */
 extern struct mm_struct init_mm;
 
--- a/arch/x86/include/asm/pgtable.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/arch/x86/include/asm/pgtable.h
@@ -895,11 +895,6 @@ static inline int pud_large(pud_t pud)
 }
 #endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
-static inline unsigned long pud_index(unsigned long address)
-{
-	return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
-}
-
 #if CONFIG_PGTABLE_LEVELS > 3
 static inline int p4d_none(p4d_t p4d)
 {
@@ -922,12 +917,6 @@ static inline unsigned long p4d_page_vad
  */
 #define p4d_page(p4d)	pfn_to_page(p4d_pfn(p4d))
 
-/* Find an entry in the third-level page table.. */
-static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
-{
-	return (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
-}
-
 static inline int p4d_bad(p4d_t p4d)
 {
 	unsigned long ignore_flags = _KERNPG_TABLE | _PAGE_USER;
--- a/include/asm-generic/pgtable-nopud.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/include/asm-generic/pgtable-nopud.h
@@ -43,6 +43,7 @@ static inline pud_t *pud_offset(p4d_t *p
 {
 	return (pud_t *)p4d;
 }
+#define pud_offset pud_offset
 
 #define pud_val(x)				(p4d_val((x).p4d))
 #define __pud(x)				((pud_t) { __p4d(x) })
--- a/include/linux/pgtable.h~mm-consolidate-pud_index-and-pud_offset-definitions
+++ a/include/linux/pgtable.h
@@ -53,6 +53,14 @@ static inline unsigned long pmd_index(un
 #define pmd_index pmd_index
 #endif
 
+#ifndef pud_index
+static inline unsigned long pud_index(unsigned long address)
+{
+	return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
+}
+#define pud_index pud_index
+#endif
+
 #ifndef pte_offset_kernel
 static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
 {
@@ -80,6 +88,14 @@ static inline pmd_t *pmd_offset(pud_t *p
 #define pmd_offset pmd_offset
 #endif
 
+#ifndef pud_offset
+static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
+{
+	return (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
+}
+#define pud_offset pud_offset
+#endif
+
 /*
  * In many cases it is known that a virtual address is mapped at PMD or PTE
  * level, so instead of traversing all the page table levels, we can get a
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
