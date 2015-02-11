From: akpm@linux-foundation.org
Subject: [merged] arm64-drop-pte_file-and-pte_file-related-helpers.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 12:22:09 -0800
Message-ID: <54dbb9f1.8h5RzSwthWZ5KRb+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbbBKUWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:22:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, catalin.marinas@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: drop PTE_FILE and pte_file()-related helpers
has been removed from the -mm tree.  Its filename was
     arm64-drop-pte_file-and-pte_file-related-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: arm64: drop PTE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

This patch also adjust __SWP_TYPE_SHIFT and increase number of bits
availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff -puN arch/arm64/include/asm/pgtable.h~arm64-drop-pte_file-and-pte_file-related-helpers arch/arm64/include/asm/pgtable.h
--- a/arch/arm64/include/asm/pgtable.h~arm64-drop-pte_file-and-pte_file-related-helpers
+++ a/arch/arm64/include/asm/pgtable.h
@@ -25,7 +25,6 @@
  * Software defined PTE bits definition.
  */
 #define PTE_VALID		(_AT(pteval_t, 1) << 0)
-#define PTE_FILE		(_AT(pteval_t, 1) << 2)	/* only when !pte_present() */
 #define PTE_DIRTY		(_AT(pteval_t, 1) << 55)
 #define PTE_SPECIAL		(_AT(pteval_t, 1) << 56)
 #define PTE_WRITE		(_AT(pteval_t, 1) << 57)
@@ -469,13 +468,12 @@ extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 /*
  * Encode and decode a swap entry:
  *	bits 0-1:	present (must be zero)
- *	bit  2:		PTE_FILE
- *	bits 3-8:	swap type
- *	bits 9-57:	swap offset
+ *	bits 2-7:	swap type
+ *	bits 8-57:	swap offset
  */
-#define __SWP_TYPE_SHIFT	3
+#define __SWP_TYPE_SHIFT	2
 #define __SWP_TYPE_BITS		6
-#define __SWP_OFFSET_BITS	49
+#define __SWP_OFFSET_BITS	50
 #define __SWP_TYPE_MASK		((1 << __SWP_TYPE_BITS) - 1)
 #define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
 #define __SWP_OFFSET_MASK	((1UL << __SWP_OFFSET_BITS) - 1)
@@ -493,18 +491,6 @@ extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
  */
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > __SWP_TYPE_BITS)
 
-/*
- * Encode and decode a file entry:
- *	bits 0-1:	present (must be zero)
- *	bit  2:		PTE_FILE
- *	bits 3-57:	file offset / PAGE_SIZE
- */
-#define pte_file(pte)		(pte_val(pte) & PTE_FILE)
-#define pte_to_pgoff(x)		(pte_val(x) >> 3)
-#define pgoff_to_pte(x)		__pte(((x) << 3) | PTE_FILE)
-
-#define PTE_FILE_MAX_BITS	55
-
 extern int kern_addr_valid(unsigned long addr);
 
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

