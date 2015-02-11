From: akpm@linux-foundation.org
Subject: [merged] sh-drop-_page_file-and-pte_file-related-helpers.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 12:22:49 -0800
Message-ID: <54dbba19.2Y/jd7s975gG+Lbv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbbBKUWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:22:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: drop _PAGE_FILE and pte_file()-related helpers
has been removed from the -mm tree.  Its filename was
     sh-drop-_page_file-and-pte_file-related-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: sh: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/pgtable_32.h |   30 +++--------------------------
 arch/sh/include/asm/pgtable_64.h |    9 --------
 2 files changed, 5 insertions(+), 34 deletions(-)

diff -puN arch/sh/include/asm/pgtable_32.h~sh-drop-_page_file-and-pte_file-related-helpers arch/sh/include/asm/pgtable_32.h
--- a/arch/sh/include/asm/pgtable_32.h~sh-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -26,8 +26,6 @@
  *   and timing control which (together with bit 0) are moved into the
  *   old-style PTEA on the parts that support it.
  *
- * XXX: Leave the _PAGE_FILE and _PAGE_WT overhaul for a rainy day.
- *
  * SH-X2 MMUs and extended PTEs
  *
  * SH-X2 supports an extended mode TLB with split data arrays due to the
@@ -51,7 +49,6 @@
 #define _PAGE_PRESENT	0x100		/* V-bit   : page is valid */
 #define _PAGE_PROTNONE	0x200		/* software: if not present  */
 #define _PAGE_ACCESSED	0x400		/* software: page referenced */
-#define _PAGE_FILE	_PAGE_WT	/* software: pagecache or swap? */
 #define _PAGE_SPECIAL	0x800		/* software: special page */
 
 #define _PAGE_SZ_MASK	(_PAGE_SZ0 | _PAGE_SZ1)
@@ -105,14 +102,13 @@ static inline unsigned long copy_ptea_at
 /* Mask which drops unused bits from the PTEL value */
 #if defined(CONFIG_CPU_SH3)
 #define _PAGE_CLEAR_FLAGS	(_PAGE_PROTNONE | _PAGE_ACCESSED| \
-				 _PAGE_FILE	| _PAGE_SZ1	| \
-				 _PAGE_HW_SHARED)
+				  _PAGE_SZ1	| _PAGE_HW_SHARED)
 #elif defined(CONFIG_X2TLB)
 /* Get rid of the legacy PR/SZ bits when using extended mode */
 #define _PAGE_CLEAR_FLAGS	(_PAGE_PROTNONE | _PAGE_ACCESSED | \
-				 _PAGE_FILE | _PAGE_PR_MASK | _PAGE_SZ_MASK)
+				 _PAGE_PR_MASK | _PAGE_SZ_MASK)
 #else
-#define _PAGE_CLEAR_FLAGS	(_PAGE_PROTNONE | _PAGE_ACCESSED | _PAGE_FILE)
+#define _PAGE_CLEAR_FLAGS	(_PAGE_PROTNONE | _PAGE_ACCESSED)
 #endif
 
 #define _PAGE_FLAGS_HARDWARE_MASK	(phys_addr_mask() & ~(_PAGE_CLEAR_FLAGS))
@@ -343,7 +339,6 @@ static inline void set_pte(pte_t *ptep,
 #define pte_not_present(pte)	(!((pte).pte_low & _PAGE_PRESENT))
 #define pte_dirty(pte)		((pte).pte_low & _PAGE_DIRTY)
 #define pte_young(pte)		((pte).pte_low & _PAGE_ACCESSED)
-#define pte_file(pte)		((pte).pte_low & _PAGE_FILE)
 #define pte_special(pte)	((pte).pte_low & _PAGE_SPECIAL)
 
 #ifdef CONFIG_X2TLB
@@ -445,7 +440,6 @@ static inline pte_t pte_modify(pte_t pte
  * Encode and de-code a swap entry
  *
  * Constraints:
- *	_PAGE_FILE at bit 0
  *	_PAGE_PRESENT at bit 8
  *	_PAGE_PROTNONE at bit 9
  *
@@ -453,9 +447,7 @@ static inline pte_t pte_modify(pte_t pte
  * swap offset into bits 10:30. For the 64-bit PTE case, we keep the
  * preserved bits in the low 32-bits and use the upper 32 as the swap
  * offset (along with a 5-bit type), following the same approach as x86
- * PAE. This keeps the logic quite simple, and allows for a full 32
- * PTE_FILE_MAX_BITS, as opposed to the 29-bits we're constrained with
- * in the pte_low case.
+ * PAE. This keeps the logic quite simple.
  *
  * As is evident by the Alpha code, if we ever get a 64-bit unsigned
  * long (swp_entry_t) to match up with the 64-bit PTEs, this all becomes
@@ -471,13 +463,6 @@ static inline pte_t pte_modify(pte_t pte
 #define __pte_to_swp_entry(pte)		((swp_entry_t){ (pte).pte_high })
 #define __swp_entry_to_pte(x)		((pte_t){ 0, (x).val })
 
-/*
- * Encode and decode a nonlinear file mapping entry
- */
-#define pte_to_pgoff(pte)		((pte).pte_high)
-#define pgoff_to_pte(off)		((pte_t) { _PAGE_FILE, (off) })
-
-#define PTE_FILE_MAX_BITS		32
 #else
 #define __swp_type(x)			((x).val & 0xff)
 #define __swp_offset(x)			((x).val >> 10)
@@ -485,13 +470,6 @@ static inline pte_t pte_modify(pte_t pte
 
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) >> 1 })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val << 1 })
-
-/*
- * Encode and decode a nonlinear file mapping entry
- */
-#define PTE_FILE_MAX_BITS	29
-#define pte_to_pgoff(pte)	(pte_val(pte) >> 1)
-#define pgoff_to_pte(off)	((pte_t) { ((off) << 1) | _PAGE_FILE })
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -puN arch/sh/include/asm/pgtable_64.h~sh-drop-_page_file-and-pte_file-related-helpers arch/sh/include/asm/pgtable_64.h
--- a/arch/sh/include/asm/pgtable_64.h~sh-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/sh/include/asm/pgtable_64.h
@@ -107,7 +107,6 @@ static __inline__ void set_pte(pte_t *pt
 #define _PAGE_DEVICE	0x001  /* CB0: if uncacheable, 1->device (i.e. no write-combining or reordering at bus level) */
 #define _PAGE_CACHABLE	0x002  /* CB1: uncachable/cachable */
 #define _PAGE_PRESENT	0x004  /* software: page referenced */
-#define _PAGE_FILE	0x004  /* software: only when !present */
 #define _PAGE_SIZE0	0x008  /* SZ0-bit : size of page */
 #define _PAGE_SIZE1	0x010  /* SZ1-bit : size of page */
 #define _PAGE_SHARED	0x020  /* software: reflects PTEH's SH */
@@ -129,7 +128,7 @@ static __inline__ void set_pte(pte_t *pt
 #define _PAGE_WIRED	_PAGE_EXT(0x001) /* software: wire the tlb entry */
 #define _PAGE_SPECIAL	_PAGE_EXT(0x002)
 
-#define _PAGE_CLEAR_FLAGS	(_PAGE_PRESENT | _PAGE_FILE | _PAGE_SHARED | \
+#define _PAGE_CLEAR_FLAGS	(_PAGE_PRESENT | _PAGE_SHARED | \
 				 _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_WIRED)
 
 /* Mask which drops software flags */
@@ -260,7 +259,6 @@ static __inline__ void set_pte(pte_t *pt
  */
 static inline int pte_dirty(pte_t pte)  { return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)  { return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)   { return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_write(pte_t pte)  { return pte_val(pte) & _PAGE_WRITE; }
 static inline int pte_special(pte_t pte){ return pte_val(pte) & _PAGE_SPECIAL; }
 
@@ -304,11 +302,6 @@ static inline pte_t pte_modify(pte_t pte
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/* Encode and decode a nonlinear file mapping entry */
-#define PTE_FILE_MAX_BITS		29
-#define pte_to_pgoff(pte)		(pte_val(pte))
-#define pgoff_to_pte(off)		((pte_t) { (off) | _PAGE_FILE })
-
 #endif /* !__ASSEMBLY__ */
 
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch
sparc32-fix-broken-set_pte.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
microblaze-define-__pagetable_pmd_folded.patch
mm-make-first_user_address-unsigned-long-on-all-archs.patch
mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch
arm-define-__pagetable_pmd_folded-for-lpae.patch
mm-account-pmd-page-tables-to-the-process.patch
mm-account-pmd-page-tables-to-the-process-fix.patch
mm-account-pmd-page-tables-to-the-process-fix-2.patch
mm-account-pmd-page-tables-to-the-process-fix-3.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix-2.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma.patch
mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch
mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags.patch
mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch
mm-gup-use-get_user_pages_unlocked.patch
mm-gup-kvm-use-get_user_pages_unlocked.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
pagewalk-improve-vma-handling.patch
pagewalk-add-walk_page_vma.patch
smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch
pagemap-use-walk-vma-instead-of-calling-find_vma.patch
numa_maps-fix-typo-in-gather_hugetbl_stats.patch
numa_maps-remove-numa_maps-vma.patch
memcg-cleanup-preparation-for-page-table-walk.patch
arch-powerpc-mm-subpage-protc-use-walk-vma-and-walk_page_vma.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
mm-do-not-use-mm-nr_pmds-on-mmu-configurations.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch

