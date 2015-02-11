From: akpm@linux-foundation.org
Subject: [merged] mm-replace-vma-shareadlinear-with-vma-shared.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:58 -0800
Message-ID: <54dbb9e6.nSh+HSxhAxGariqG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbbBKUV7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace vma->sharead.linear with vma->shared
has been removed from the -mm tree.  Its filename was
     mm-replace-vma-shareadlinear-with-vma-shared.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: replace vma->sharead.linear with vma->shared

After removing vma->shared.nonlinear we have only one member of
vma->shared union, which doesn't make much sense.

This patch drops the union and move struct vma->shared.linear to
vma->shared.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 +++-----
 mm/interval_tree.c       |   34 +++++++++++++++++-----------------
 2 files changed, 20 insertions(+), 22 deletions(-)

diff -puN include/linux/mm_types.h~mm-replace-vma-shareadlinear-with-vma-shared include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-replace-vma-shareadlinear-with-vma-shared
+++ a/include/linux/mm_types.h
@@ -275,11 +275,9 @@ struct vm_area_struct {
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree.
 	 */
-	union {
-		struct {
-			struct rb_node rb;
-			unsigned long rb_subtree_last;
-		} linear;
+	struct {
+		struct rb_node rb;
+		unsigned long rb_subtree_last;
 	} shared;
 
 	/*
diff -puN mm/interval_tree.c~mm-replace-vma-shareadlinear-with-vma-shared mm/interval_tree.c
--- a/mm/interval_tree.c~mm-replace-vma-shareadlinear-with-vma-shared
+++ a/mm/interval_tree.c
@@ -21,8 +21,8 @@ static inline unsigned long vma_last_pgo
 	return v->vm_pgoff + ((v->vm_end - v->vm_start) >> PAGE_SHIFT) - 1;
 }
 
-INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.linear.rb,
-		     unsigned long, shared.linear.rb_subtree_last,
+INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
+		     unsigned long, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff,, vma_interval_tree)
 
 /* Insert node immediately after prev in the interval tree */
@@ -36,26 +36,26 @@ void vma_interval_tree_insert_after(stru
 
 	VM_BUG_ON_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
 
-	if (!prev->shared.linear.rb.rb_right) {
+	if (!prev->shared.rb.rb_right) {
 		parent = prev;
-		link = &prev->shared.linear.rb.rb_right;
+		link = &prev->shared.rb.rb_right;
 	} else {
-		parent = rb_entry(prev->shared.linear.rb.rb_right,
-				  struct vm_area_struct, shared.linear.rb);
-		if (parent->shared.linear.rb_subtree_last < last)
-			parent->shared.linear.rb_subtree_last = last;
-		while (parent->shared.linear.rb.rb_left) {
-			parent = rb_entry(parent->shared.linear.rb.rb_left,
-				struct vm_area_struct, shared.linear.rb);
-			if (parent->shared.linear.rb_subtree_last < last)
-				parent->shared.linear.rb_subtree_last = last;
+		parent = rb_entry(prev->shared.rb.rb_right,
+				  struct vm_area_struct, shared.rb);
+		if (parent->shared.rb_subtree_last < last)
+			parent->shared.rb_subtree_last = last;
+		while (parent->shared.rb.rb_left) {
+			parent = rb_entry(parent->shared.rb.rb_left,
+				struct vm_area_struct, shared.rb);
+			if (parent->shared.rb_subtree_last < last)
+				parent->shared.rb_subtree_last = last;
 		}
-		link = &parent->shared.linear.rb.rb_left;
+		link = &parent->shared.rb.rb_left;
 	}
 
-	node->shared.linear.rb_subtree_last = last;
-	rb_link_node(&node->shared.linear.rb, &parent->shared.linear.rb, link);
-	rb_insert_augmented(&node->shared.linear.rb, root,
+	node->shared.rb_subtree_last = last;
+	rb_link_node(&node->shared.rb, &parent->shared.rb, link);
+	rb_insert_augmented(&node->shared.rb, root,
 			    &vma_interval_tree_augment);
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

