From: akpm@linux-foundation.org
Subject: - m32r-fix-pte_to_pgoff.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:13 -0700
Message-ID: <200705120533.l4C5XDwZ002089@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbXELFdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takata@linux-m32r.org, hitoshiy@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: fix pte_to_pgoff(),  pgoff_to_pte() and __swp_type() macros
has been removed from the -mm tree.  Its filename was
     m32r-fix-pte_to_pgoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m32r: fix pte_to_pgoff(),  pgoff_to_pte() and __swp_type() macros
From: Hirokazu Takata <takata@linux-m32r.org>

This patch is required to handle file-mapped or swapped-out pages
correctly.

- Fix pte_to_pgoff() and pgoff_to_pte() macros not to include
  _PAGE_PROTNONE bit of PTE.
  Mask value for { ACCESSED, N, (R, W, X), L, G } is not 0xef but 0x7f.
- Fix __swp_type() macro for MAX_SWAPFILES_SHIFT(=5), which is defined
  in include/linux/swap.h.

* M32R TLB format

     [0]    [1:19]           [20:23]       [24:31]
     +-----------------------+----+-------------+
     |          VPN          |0000|    ASID     |
     +-----------------------+----+-------------+
     +-+---------------------+----+-+---+-+-+-+-+
     |0         PPN          |0000|N|AC |L|G|V| |
     +-+---------------------+----+-+---+-+-+-+-+
                                ||   RWX     | |
* software bits in PTE          ||           | +-- _PAGE_FILE | _PAGE_DIRTY
                                ||           +---- _PAGE_PRESENT
                                |+---------------- _PAGE_ACCESSED
                                +----------------- _PAGE_PROTNONE

Signed-off-by: Hitoshi Yamamoto <hitoshiy@linux-m32r.org>
Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m32r/pgtable-2level.h |    4 ++--
 include/asm-m32r/pgtable.h        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-m32r/pgtable-2level.h~m32r-fix-pte_to_pgoff include/asm-m32r/pgtable-2level.h
--- a/include/asm-m32r/pgtable-2level.h~m32r-fix-pte_to_pgoff
+++ a/include/asm-m32r/pgtable-2level.h
@@ -71,8 +71,8 @@ static inline pmd_t *pmd_offset(pgd_t * 
 #define pfn_pmd(pfn, prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
 #define PTE_FILE_MAX_BITS	29
-#define pte_to_pgoff(pte)	(((pte_val(pte) >> 2) & 0xef) | (((pte_val(pte) >> 10)) << 7))
-#define pgoff_to_pte(off)	((pte_t) { (((off) & 0xef) << 2) | (((off) >> 7) << 10) | _PAGE_FILE })
+#define pte_to_pgoff(pte)	(((pte_val(pte) >> 2) & 0x7f) | (((pte_val(pte) >> 10)) << 7))
+#define pgoff_to_pte(off)	((pte_t) { (((off) & 0x7f) << 2) | (((off) >> 7) << 10) | _PAGE_FILE })
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_M32R_PGTABLE_2LEVEL_H */
diff -puN include/asm-m32r/pgtable.h~m32r-fix-pte_to_pgoff include/asm-m32r/pgtable.h
--- a/include/asm-m32r/pgtable.h~m32r-fix-pte_to_pgoff
+++ a/include/asm-m32r/pgtable.h
@@ -366,7 +366,7 @@ static inline void pmd_set(pmd_t * pmdp,
 #define pte_unmap_nested(pte)	do { } while (0)
 
 /* Encode and de-code a swap entry */
-#define __swp_type(x)			(((x).val >> 2) & 0x3f)
+#define __swp_type(x)			(((x).val >> 2) & 0x1f)
 #define __swp_offset(x)			((x).val >> 10)
 #define __swp_entry(type, offset)	\
 	((swp_entry_t) { ((type) << 2) | ((offset) << 10) })
_

Patches currently in -mm which might be from takata@linux-m32r.org are

origin.patch
