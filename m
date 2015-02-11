From: akpm@linux-foundation.org
Subject: [merged] score-drop-_page_file-and-pte_file-related-helpers.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:22:47 -0800
Message-ID: <54dbba17.hYREUSbbwZwuKOI2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbbBKUWs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:22:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, lennox.wu@gmail.com, liqin.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: drop _PAGE_FILE and pte_file()-related helpers
has been removed from the -mm tree.  Its filename was
     score-drop-_page_file-and-pte_file-related-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: score: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

This patch also increase number of bits availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/include/asm/pgtable-bits.h |    1 -
 arch/score/include/asm/pgtable.h      |   18 ++----------------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff -puN arch/score/include/asm/pgtable-bits.h~score-drop-_page_file-and-pte_file-related-helpers arch/score/include/asm/pgtable-bits.h
--- a/arch/score/include/asm/pgtable-bits.h~score-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/score/include/asm/pgtable-bits.h
@@ -6,7 +6,6 @@
 #define _PAGE_WRITE			(1<<7)	/* implemented in software */
 #define _PAGE_PRESENT			(1<<9)	/* implemented in software */
 #define _PAGE_MODIFIED			(1<<10)	/* implemented in software */
-#define _PAGE_FILE			(1<<10)
 
 #define _PAGE_GLOBAL			(1<<0)
 #define _PAGE_VALID			(1<<1)
diff -puN arch/score/include/asm/pgtable.h~score-drop-_page_file-and-pte_file-related-helpers arch/score/include/asm/pgtable.h
--- a/arch/score/include/asm/pgtable.h~score-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/score/include/asm/pgtable.h
@@ -90,15 +90,6 @@ static inline void pmd_clear(pmd_t *pmdp
 	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
 #define pte_unmap(pte) ((void)(pte))
 
-/*
- * Bits 9(_PAGE_PRESENT) and 10(_PAGE_FILE)are taken,
- * split up 30 bits of offset into this range:
- */
-#define PTE_FILE_MAX_BITS	30
-#define pte_to_pgoff(_pte)		\
-	(((_pte).pte & 0x1ff) | (((_pte).pte >> 11) << 9))
-#define pgoff_to_pte(off)		\
-	((pte_t) {((off) & 0x1ff) | (((off) >> 9) << 11) | _PAGE_FILE})
 #define __pte_to_swp_entry(pte)		\
 	((swp_entry_t) { pte_val(pte)})
 #define __swp_entry_to_pte(x)	((pte_t) {(x).val})
@@ -169,8 +160,8 @@ static inline pgprot_t pgprot_noncached(
 }
 
 #define __swp_type(x)		((x).val & 0x1f)
-#define __swp_offset(x) 	((x).val >> 11)
-#define __swp_entry(type, offset) ((swp_entry_t){(type) | ((offset) << 11)})
+#define __swp_offset(x) 	((x).val >> 10)
+#define __swp_entry(type, offset) ((swp_entry_t){(type) | ((offset) << 10)})
 
 extern unsigned long empty_zero_page;
 extern unsigned long zero_page_mask;
@@ -198,11 +189,6 @@ static inline int pte_young(pte_t pte)
 	return pte_val(pte) & _PAGE_ACCESSED;
 }
 
-static inline int pte_file(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_FILE;
-}
-
 #define pte_special(pte)	(0)
 
 static inline pte_t pte_wrprotect(pte_t pte)
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

