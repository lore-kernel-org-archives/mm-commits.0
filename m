From: akpm@linux-foundation.org
Subject: [merged]
 mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch removed
 from -mm tree
Date: Wed, 11 Feb 2015 12:21:50 -0800
Message-ID: <54dbb9de.bJK/rEb9M2rMnQh9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbbBKUVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop support of non-linear mapping from fault codepath
has been removed from the -mm tree.  Its filename was
     mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop support of non-linear mapping from fault codepath

We don't create non-linear mappings anymore.  Let's drop code which
handles them on page fault.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   16 ++++------
 mm/memory.c        |   65 +++++--------------------------------------
 2 files changed, 16 insertions(+), 65 deletions(-)

diff -puN include/linux/mm.h~mm-drop-support-of-non-linear-mapping-from-fault-codepath include/linux/mm.h
--- a/include/linux/mm.h~mm-drop-support-of-non-linear-mapping-from-fault-codepath
+++ a/include/linux/mm.h
@@ -206,21 +206,19 @@ extern unsigned int kobjsize(const void
 extern pgprot_t protection_map[16];
 
 #define FAULT_FLAG_WRITE	0x01	/* Fault was a write access */
-#define FAULT_FLAG_NONLINEAR	0x02	/* Fault was via a nonlinear mapping */
-#define FAULT_FLAG_MKWRITE	0x04	/* Fault was mkwrite of existing pte */
-#define FAULT_FLAG_ALLOW_RETRY	0x08	/* Retry fault if blocking */
-#define FAULT_FLAG_RETRY_NOWAIT	0x10	/* Don't drop mmap_sem and wait when retrying */
-#define FAULT_FLAG_KILLABLE	0x20	/* The fault task is in SIGKILL killable region */
-#define FAULT_FLAG_TRIED	0x40	/* second try */
-#define FAULT_FLAG_USER		0x80	/* The fault originated in userspace */
+#define FAULT_FLAG_MKWRITE	0x02	/* Fault was mkwrite of existing pte */
+#define FAULT_FLAG_ALLOW_RETRY	0x04	/* Retry fault if blocking */
+#define FAULT_FLAG_RETRY_NOWAIT	0x08	/* Don't drop mmap_sem and wait when retrying */
+#define FAULT_FLAG_KILLABLE	0x10	/* The fault task is in SIGKILL killable region */
+#define FAULT_FLAG_TRIED	0x20	/* Second try */
+#define FAULT_FLAG_USER		0x40	/* The fault originated in userspace */
 
 /*
  * vm_fault is filled by the the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
  * of VM_FAULT_xxx flags that give details about how the fault was handled.
  *
- * pgoff should be used in favour of virtual_address, if possible. If pgoff
- * is used, one may implement ->remap_pages to get nonlinear mapping support.
+ * pgoff should be used in favour of virtual_address, if possible.
  */
 struct vm_fault {
 	unsigned int flags;		/* FAULT_FLAG_xxx flags */
diff -puN mm/memory.c~mm-drop-support-of-non-linear-mapping-from-fault-codepath mm/memory.c
--- a/mm/memory.c~mm-drop-support-of-non-linear-mapping-from-fault-codepath
+++ a/mm/memory.c
@@ -1901,12 +1901,11 @@ int apply_to_page_range(struct mm_struct
 EXPORT_SYMBOL_GPL(apply_to_page_range);
 
 /*
- * handle_pte_fault chooses page fault handler according to an entry
- * which was read non-atomically.  Before making any commitment, on
- * those architectures or configurations (e.g. i386 with PAE) which
- * might give a mix of unmatched parts, do_swap_page and do_nonlinear_fault
- * must check under lock before unmapping the pte and proceeding
- * (but do_wp_page is only called after already making such a check;
+ * handle_pte_fault chooses page fault handler according to an entry which was
+ * read non-atomically.  Before making any commitment, on those architectures
+ * or configurations (e.g. i386 with PAE) which might give a mix of unmatched
+ * parts, do_swap_page must check under lock before unmapping the pte and
+ * proceeding (but do_wp_page is only called after already making such a check;
  * and do_anonymous_page can safely check later on).
  */
 static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
@@ -2712,8 +2711,6 @@ void do_set_pte(struct vm_area_struct *v
 	entry = mk_pte(page, vma->vm_page_prot);
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-	else if (pte_file(*pte) && pte_file_soft_dirty(*pte))
-		entry = pte_mksoft_dirty(entry);
 	if (anon) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 		page_add_new_anon_rmap(page, vma, address);
@@ -2848,8 +2845,7 @@ static int do_read_fault(struct mm_struc
 	 * if page by the offset is not ready to be mapped (cold cache or
 	 * something).
 	 */
-	if (vma->vm_ops->map_pages && !(flags & FAULT_FLAG_NONLINEAR) &&
-	    fault_around_bytes >> PAGE_SHIFT > 1) {
+	if (vma->vm_ops->map_pages && fault_around_bytes >> PAGE_SHIFT > 1) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))
@@ -2994,7 +2990,7 @@ static int do_shared_fault(struct mm_str
  * The mmap_sem may have been released depending on flags and our
  * return value.  See filemap_fault() and __lock_page_or_retry().
  */
-static int do_linear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
+static int do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
 		unsigned int flags, pte_t orig_pte)
 {
@@ -3011,46 +3007,6 @@ static int do_linear_fault(struct mm_str
 	return do_shared_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
-/*
- * Fault of a previously existing named mapping. Repopulate the pte
- * from the encoded file_pte if possible. This enables swappable
- * nonlinear vmas.
- *
- * We enter with non-exclusive mmap_sem (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
- * We return with pte unmapped and unlocked.
- * The mmap_sem may have been released depending on flags and our
- * return value.  See filemap_fault() and __lock_page_or_retry().
- */
-static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
-		unsigned long address, pte_t *page_table, pmd_t *pmd,
-		unsigned int flags, pte_t orig_pte)
-{
-	pgoff_t pgoff;
-
-	flags |= FAULT_FLAG_NONLINEAR;
-
-	if (!pte_unmap_same(mm, pmd, page_table, orig_pte))
-		return 0;
-
-	if (unlikely(!(vma->vm_flags & VM_NONLINEAR))) {
-		/*
-		 * Page table corrupted: show pte and kill process.
-		 */
-		print_bad_pte(vma, address, orig_pte, NULL);
-		return VM_FAULT_SIGBUS;
-	}
-
-	pgoff = pte_to_pgoff(orig_pte);
-	if (!(flags & FAULT_FLAG_WRITE))
-		return do_read_fault(mm, vma, address, pmd, pgoff, flags,
-				orig_pte);
-	if (!(vma->vm_flags & VM_SHARED))
-		return do_cow_fault(mm, vma, address, pmd, pgoff, flags,
-				orig_pte);
-	return do_shared_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
-}
-
 static int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
 				unsigned long addr, int page_nid,
 				int *flags)
@@ -3178,15 +3134,12 @@ static int handle_pte_fault(struct mm_st
 		if (pte_none(entry)) {
 			if (vma->vm_ops) {
 				if (likely(vma->vm_ops->fault))
-					return do_linear_fault(mm, vma, address,
-						pte, pmd, flags, entry);
+					return do_fault(mm, vma, address, pte,
+							pmd, flags, entry);
 			}
 			return do_anonymous_page(mm, vma, address,
 						 pte, pmd, flags);
 		}
-		if (pte_file(entry))
-			return do_nonlinear_fault(mm, vma, address,
-					pte, pmd, flags, entry);
 		return do_swap_page(mm, vma, address,
 					pte, pmd, flags, entry);
 	}
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

