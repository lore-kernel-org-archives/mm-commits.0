From: akpm@linux-foundation.org
Subject: [merged] nios2-drop-_page_file-and-pte_file-related-helpers.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:22:39 -0800
Message-ID: <54dbba0f.UX87hP1k1tK0NJPM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbbBKUWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:22:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, lftan@altera.com, tklauser@distanz.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: nios2: drop _PAGE_FILE and pte_file()-related helpers
has been removed from the -mm tree.  Its filename was
     nios2-drop-_page_file-and-pte_file-related-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: nios2: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ley Foon Tan <lftan@altera.com>
Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/include/asm/pgtable-bits.h |    1 -
 arch/nios2/include/asm/pgtable.h      |   10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff -puN arch/nios2/include/asm/pgtable-bits.h~nios2-drop-_page_file-and-pte_file-related-helpers arch/nios2/include/asm/pgtable-bits.h
--- a/arch/nios2/include/asm/pgtable-bits.h~nios2-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/nios2/include/asm/pgtable-bits.h
@@ -30,6 +30,5 @@
 #define _PAGE_PRESENT	(1<<25)	/* PTE contains a translation */
 #define _PAGE_ACCESSED	(1<<26)	/* page referenced */
 #define _PAGE_DIRTY	(1<<27)	/* dirty page */
-#define _PAGE_FILE	(1<<28)	/* PTE used for file mapping or swap */
 
 #endif /* _ASM_NIOS2_PGTABLE_BITS_H */
diff -puN arch/nios2/include/asm/pgtable.h~nios2-drop-_page_file-and-pte_file-related-helpers arch/nios2/include/asm/pgtable.h
--- a/arch/nios2/include/asm/pgtable.h~nios2-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/nios2/include/asm/pgtable.h
@@ -112,8 +112,6 @@ static inline int pte_dirty(pte_t pte)
 	{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		\
 	{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)		\
-	{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_special(pte_t pte)	{ return 0; }
 
 #define pgprot_noncached pgprot_noncached
@@ -272,8 +270,7 @@ static inline void pte_clear(struct mm_s
 		__FILE__, __LINE__, pgd_val(e))
 
 /*
- * Encode and decode a swap entry (must be !pte_none(pte) && !pte_present(pte)
- * && !pte_file(pte)):
+ * Encode and decode a swap entry (must be !pte_none(pte) && !pte_present(pte):
  *
  * 31 30 29 28 27 26 25 24 23 22 21 20 19 18 ...  1  0
  *  0  0  0  0 type.  0  0  0  0  0  0 offset.........
@@ -290,11 +287,6 @@ static inline void pte_clear(struct mm_s
 #define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 
-/* Encode and decode a nonlinear file mapping entry */
-#define PTE_FILE_MAX_BITS	25
-#define pte_to_pgoff(pte)	(pte_val(pte) & 0x1ffffff)
-#define pgoff_to_pte(off)	__pte(((off) & 0x1ffffff) | _PAGE_FILE)
-
 #define kern_addr_valid(addr)		(1)
 
 #include <asm-generic/pgtable.h>
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

