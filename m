From: akpm@linux-foundation.org
Subject: [merged]
 mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:48 -0800
Message-ID: <54dbb9dc.FPRBmHFxNnq26gDI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbbBKUVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, balbi@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop support of non-linear mapping from unmap/zap codepath
has been removed from the -mm tree.  Its filename was
     mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop support of non-linear mapping from unmap/zap codepath

We have remap_file_pages(2) emulation in -mm tree for few release cycles
and we plan to have it mainline in v3.20. This patchset removes rest of
VM_NONLINEAR infrastructure.

Patches 1-8 take care about generic code. They are pretty
straight-forward and can be applied without other of patches.

Rest patches removes pte_file()-related stuff from architecture-specific
code. It usually frees up one bit in non-present pte. I've tried to reuse
that bit for swap offset, where I was able to figure out how to do that.

For obvious reason I cannot test all that arch-specific code and would
like to see acks from maintainers.

In total, remap_file_pages(2) required about 1.4K lines of not-so-trivial
kernel code. That's too much for functionality nobody uses.

Tested-by: Felipe Balbi <balbi@ti.com>



This patch (of 38):

We don't create non-linear mappings anymore. Let's drop code which
handles them on unmap/zap.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/madvise.c       |    9 ----
 mm/memory.c        |   88 +++++++++++--------------------------------
 3 files changed, 25 insertions(+), 73 deletions(-)

diff -puN include/linux/mm.h~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath include/linux/mm.h
--- a/include/linux/mm.h~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath
+++ a/include/linux/mm.h
@@ -1154,7 +1154,6 @@ extern void user_shm_unlock(size_t, stru
  * Parameter block passed down to zap_pte_range in exceptional cases.
  */
 struct zap_details {
-	struct vm_area_struct *nonlinear_vma;	/* Check page->index if set */
 	struct address_space *check_mapping;	/* Check page->mapping if set */
 	pgoff_t	first_index;			/* Lowest page->index to unmap */
 	pgoff_t last_index;			/* Highest page->index to unmap */
diff -puN mm/madvise.c~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath mm/madvise.c
--- a/mm/madvise.c~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath
+++ a/mm/madvise.c
@@ -278,14 +278,7 @@ static long madvise_dontneed(struct vm_a
 	if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
 		return -EINVAL;
 
-	if (unlikely(vma->vm_flags & VM_NONLINEAR)) {
-		struct zap_details details = {
-			.nonlinear_vma = vma,
-			.last_index = ULONG_MAX,
-		};
-		zap_page_range(vma, start, end - start, &details);
-	} else
-		zap_page_range(vma, start, end - start, NULL);
+	zap_page_range(vma, start, end - start, NULL);
 	return 0;
 }
 
diff -puN mm/memory.c~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath mm/memory.c
--- a/mm/memory.c~mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath
+++ a/mm/memory.c
@@ -1084,6 +1084,7 @@ static unsigned long zap_pte_range(struc
 	spinlock_t *ptl;
 	pte_t *start_pte;
 	pte_t *pte;
+	swp_entry_t entry;
 
 again:
 	init_rss_vec(rss);
@@ -1109,28 +1110,12 @@ again:
 				if (details->check_mapping &&
 				    details->check_mapping != page->mapping)
 					continue;
-				/*
-				 * Each page->index must be checked when
-				 * invalidating or truncating nonlinear.
-				 */
-				if (details->nonlinear_vma &&
-				    (page->index < details->first_index ||
-				     page->index > details->last_index))
-					continue;
 			}
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
 							tlb->fullmm);
 			tlb_remove_tlb_entry(tlb, pte, addr);
 			if (unlikely(!page))
 				continue;
-			if (unlikely(details) && details->nonlinear_vma
-			    && linear_page_index(details->nonlinear_vma,
-						addr) != page->index) {
-				pte_t ptfile = pgoff_to_pte(page->index);
-				if (pte_soft_dirty(ptent))
-					ptfile = pte_file_mksoft_dirty(ptfile);
-				set_pte_at(mm, addr, pte, ptfile);
-			}
 			if (PageAnon(page))
 				rss[MM_ANONPAGES]--;
 			else {
@@ -1153,33 +1138,25 @@ again:
 			}
 			continue;
 		}
-		/*
-		 * If details->check_mapping, we leave swap entries;
-		 * if details->nonlinear_vma, we leave file entries.
-		 */
+		/* If details->check_mapping, we leave swap entries. */
 		if (unlikely(details))
 			continue;
-		if (pte_file(ptent)) {
-			if (unlikely(!(vma->vm_flags & VM_NONLINEAR)))
-				print_bad_pte(vma, addr, ptent, NULL);
-		} else {
-			swp_entry_t entry = pte_to_swp_entry(ptent);
-
-			if (!non_swap_entry(entry))
-				rss[MM_SWAPENTS]--;
-			else if (is_migration_entry(entry)) {
-				struct page *page;
-
-				page = migration_entry_to_page(entry);
-
-				if (PageAnon(page))
-					rss[MM_ANONPAGES]--;
-				else
-					rss[MM_FILEPAGES]--;
-			}
-			if (unlikely(!free_swap_and_cache(entry)))
-				print_bad_pte(vma, addr, ptent, NULL);
+
+		entry = pte_to_swp_entry(ptent);
+		if (!non_swap_entry(entry))
+			rss[MM_SWAPENTS]--;
+		else if (is_migration_entry(entry)) {
+			struct page *page;
+
+			page = migration_entry_to_page(entry);
+
+			if (PageAnon(page))
+				rss[MM_ANONPAGES]--;
+			else
+				rss[MM_FILEPAGES]--;
 		}
+		if (unlikely(!free_swap_and_cache(entry)))
+			print_bad_pte(vma, addr, ptent, NULL);
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
@@ -1279,7 +1256,7 @@ static void unmap_page_range(struct mmu_
 	pgd_t *pgd;
 	unsigned long next;
 
-	if (details && !details->check_mapping && !details->nonlinear_vma)
+	if (details && !details->check_mapping)
 		details = NULL;
 
 	BUG_ON(addr >= end);
@@ -1373,7 +1350,7 @@ void unmap_vmas(struct mmu_gather *tlb,
  * @vma: vm_area_struct holding the applicable pages
  * @start: starting address of pages to zap
  * @size: number of bytes to zap
- * @details: details of nonlinear truncation or shared cache invalidation
+ * @details: details of shared cache invalidation
  *
  * Caller must protect the VMA list
  */
@@ -1399,7 +1376,7 @@ void zap_page_range(struct vm_area_struc
  * @vma: vm_area_struct holding the applicable pages
  * @address: starting address of pages to zap
  * @size: number of bytes to zap
- * @details: details of nonlinear truncation or shared cache invalidation
+ * @details: details of shared cache invalidation
  *
  * The range must fit into one VMA.
  */
@@ -2333,25 +2310,11 @@ static inline void unmap_mapping_range_t
 	}
 }
 
-static inline void unmap_mapping_range_list(struct list_head *head,
-					    struct zap_details *details)
-{
-	struct vm_area_struct *vma;
-
-	/*
-	 * In nonlinear VMAs there is no correspondence between virtual address
-	 * offset and file offset.  So we must perform an exhaustive search
-	 * across *all* the pages in each nonlinear VMA, not just the pages
-	 * whose virtual address lies outside the file truncation point.
-	 */
-	list_for_each_entry(vma, head, shared.nonlinear) {
-		details->nonlinear_vma = vma;
-		unmap_mapping_range_vma(vma, vma->vm_start, vma->vm_end, details);
-	}
-}
-
 /**
- * unmap_mapping_range - unmap the portion of all mmaps in the specified address_space corresponding to the specified page range in the underlying file.
+ * unmap_mapping_range - unmap the portion of all mmaps in the specified
+ * address_space corresponding to the specified page range in the underlying
+ * file.
+ *
  * @mapping: the address space containing mmaps to be unmapped.
  * @holebegin: byte in first page to unmap, relative to the start of
  * the underlying file.  This will be rounded down to a PAGE_SIZE
@@ -2380,7 +2343,6 @@ void unmap_mapping_range(struct address_
 	}
 
 	details.check_mapping = even_cows? NULL: mapping;
-	details.nonlinear_vma = NULL;
 	details.first_index = hba;
 	details.last_index = hba + hlen - 1;
 	if (details.last_index < details.first_index)
@@ -2390,8 +2352,6 @@ void unmap_mapping_range(struct address_
 	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
-	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
-		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
 	i_mmap_unlock_write(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
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

