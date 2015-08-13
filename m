From: akpm@linux-foundation.org
Subject: + mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax.patch added
 to -mm tree
Date: Wed, 12 Aug 2015 17:03:00 -0700
Message-ID: <55cbdeb4.6NBAsZhLyG/PMfx+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbHMADB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 20:03:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: take i_mmap_lock in unmap_mapping_range() for DAX
has been added to the -mm tree.  Its filename is
     mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: take i_mmap_lock in unmap_mapping_range() for DAX

DAX is not so special: we need i_mmap_lock to protect mapping->i_mmap.

__dax_pmd_fault() uses unmap_mapping_range() shoot out zero page from all
mappings.  We need to drop i_mmap_lock there to avoid lock deadlock.

Re-aquiring the lock should be fine since we check i_size after the
point.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c    |   35 +++++++++++++++++++----------------
 mm/memory.c |   11 ++---------
 2 files changed, 21 insertions(+), 25 deletions(-)

diff -puN fs/dax.c~mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax fs/dax.c
--- a/fs/dax.c~mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax
+++ a/fs/dax.c
@@ -554,6 +554,25 @@ int __dax_pmd_fault(struct vm_area_struc
 	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
 		goto fallback;
 
+	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
+		int i;
+		for (i = 0; i < PTRS_PER_PMD; i++)
+			clear_page(kaddr + i * PAGE_SIZE);
+		count_vm_event(PGMAJFAULT);
+		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+		result |= VM_FAULT_MAJOR;
+	}
+
+	/*
+	 * If we allocated new storage, make sure no process has any
+	 * zero pages covering this hole
+	 */
+	if (buffer_new(&bh)) {
+		i_mmap_unlock_write(mapping);
+		unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
+		i_mmap_lock_write(mapping);
+	}
+
 	/*
 	 * If a truncate happened while we were allocating blocks, we may
 	 * leave blocks allocated to the file that are beyond EOF.  We can't
@@ -568,13 +587,6 @@ int __dax_pmd_fault(struct vm_area_struc
 	if ((pgoff | PG_PMD_COLOUR) >= size)
 		goto fallback;
 
-	/*
-	 * If we allocated new storage, make sure no process has any
-	 * zero pages covering this hole
-	 */
-	if (buffer_new(&bh))
-		unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
-
 	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
@@ -605,15 +617,6 @@ int __dax_pmd_fault(struct vm_area_struc
 		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
 			goto fallback;
 
-		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-			int i;
-			for (i = 0; i < PTRS_PER_PMD; i++)
-				clear_page(kaddr + i * PAGE_SIZE);
-			count_vm_event(PGMAJFAULT);
-			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
-			result |= VM_FAULT_MAJOR;
-		}
-
 		result |= vmf_insert_pfn_pmd(vma, address, pmd, pfn, write);
 	}
 
diff -puN mm/memory.c~mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax mm/memory.c
--- a/mm/memory.c~mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax
+++ a/mm/memory.c
@@ -2426,17 +2426,10 @@ void unmap_mapping_range(struct address_
 	if (details.last_index < details.first_index)
 		details.last_index = ULONG_MAX;
 
-
-	/*
-	 * DAX already holds i_mmap_lock to serialise file truncate vs
-	 * page fault and page fault vs page fault.
-	 */
-	if (!IS_DAX(mapping->host))
-		i_mmap_lock_write(mapping);
+	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
-	if (!IS_DAX(mapping->host))
-		i_mmap_unlock_write(mapping);
+	i_mmap_unlock_write(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code-v7.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-introduce-vm_lockonfault-v7.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch
mm-fix-status-code-move_pages-returns-for-zero-page.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch
thp-fix-zap_huge_pmd-for-dax.patch
dax-dont-use-set_huge_zero_page.patch
dax-ensure-that-zero-pages-are-removed-from-other-processes.patch
mm-take-i_mmap_lock-in-unmap_mapping_range-for-dax.patch
mm-dax-use-i_mmap_unlock_write-in-do_cow_fault.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range.patch
vm_flags-vm_flags_t-and-__nocast.patch
mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
fix-list_poison12-offset.patch
use-poison_pointer_delta-for-poison-pointers.patch
remove-not-used-poison-pointer-macros.patch
unshare-unsharing-a-thread-does-not-require-unsharing-a-vm.patch
usernspidns-force-thread-group-sharing-not-signal-handler-sharing.patch
mm-mark-most-vm_operations_struct-const.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

