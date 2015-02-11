From: akpm@linux-foundation.org
Subject: [merged] mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 12:22:00 -0800
Message-ID: <54dbb9e8.Si9pvEQsB2hEWZT1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbbBKUWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dan.carpenter@oracle.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove rest usage of VM_NONLINEAR and pte_file()
has been removed from the -mm tree.  Its filename was
     mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: remove rest usage of VM_NONLINEAR and pte_file()

One bit in ->vm_flags is unused now!

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_vma_manager.c |    3 -
 include/linux/mm.h                |    1 
 include/linux/swapops.h           |    4 -
 mm/debug.c                        |    1 
 mm/gup.c                          |    2 
 mm/ksm.c                          |    2 
 mm/madvise.c                      |    4 -
 mm/memcontrol.c                   |    7 --
 mm/memory.c                       |   76 +++++++++++++---------------
 mm/mincore.c                      |    9 ---
 mm/mprotect.c                     |    2 
 mm/mremap.c                       |    2 
 mm/msync.c                        |    5 -
 13 files changed, 48 insertions(+), 70 deletions(-)

diff -puN drivers/gpu/drm/drm_vma_manager.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file drivers/gpu/drm/drm_vma_manager.c
--- a/drivers/gpu/drm/drm_vma_manager.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/drivers/gpu/drm/drm_vma_manager.c
@@ -50,8 +50,7 @@
  *
  * You must not use multiple offset managers on a single address_space.
  * Otherwise, mm-core will be unable to tear down memory mappings as the VM will
- * no longer be linear. Please use VM_NONLINEAR in that case and implement your
- * own offset managers.
+ * no longer be linear.
  *
  * This offset manager works on page-based addresses. That is, every argument
  * and return code (with the exception of drm_vma_node_offset_addr()) is given
diff -puN include/linux/mm.h~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/include/linux/mm.h
@@ -138,7 +138,6 @@ extern unsigned int kobjsize(const void
 #define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
 #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
-#define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
 #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
 #define VM_ARCH_2	0x02000000
 #define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
diff -puN include/linux/swapops.h~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file include/linux/swapops.h
--- a/include/linux/swapops.h~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/include/linux/swapops.h
@@ -54,7 +54,7 @@ static inline pgoff_t swp_offset(swp_ent
 /* check whether a pte points to a swap entry */
 static inline int is_swap_pte(pte_t pte)
 {
-	return !pte_none(pte) && !pte_present_nonuma(pte) && !pte_file(pte);
+	return !pte_none(pte) && !pte_present_nonuma(pte);
 }
 #endif
 
@@ -66,7 +66,6 @@ static inline swp_entry_t pte_to_swp_ent
 {
 	swp_entry_t arch_entry;
 
-	BUG_ON(pte_file(pte));
 	if (pte_swp_soft_dirty(pte))
 		pte = pte_swp_clear_soft_dirty(pte);
 	arch_entry = __pte_to_swp_entry(pte);
@@ -82,7 +81,6 @@ static inline pte_t swp_entry_to_pte(swp
 	swp_entry_t arch_entry;
 
 	arch_entry = __swp_entry(swp_type(entry), swp_offset(entry));
-	BUG_ON(pte_file(__swp_entry_to_pte(arch_entry)));
 	return __swp_entry_to_pte(arch_entry);
 }
 
diff -puN mm/debug.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file mm/debug.c
--- a/mm/debug.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/mm/debug.c
@@ -130,7 +130,6 @@ static const struct trace_print_flags vm
 	{VM_ACCOUNT,			"account"	},
 	{VM_NORESERVE,			"noreserve"	},
 	{VM_HUGETLB,			"hugetlb"	},
-	{VM_NONLINEAR,			"nonlinear"	},
 #if defined(CONFIG_X86)
 	{VM_PAT,			"pat"		},
 #elif defined(CONFIG_PPC)
diff -puN mm/gup.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file mm/gup.c
--- a/mm/gup.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/mm/gup.c
@@ -55,7 +55,7 @@ retry:
 		 */
 		if (likely(!(flags & FOLL_MIGRATION)))
 			goto no_page;
-		if (pte_none(pte) || pte_file(pte))
+		if (pte_none(pte))
 			goto no_page;
 		entry = pte_to_swp_entry(pte);
 		if (!is_migration_entry(entry))
diff -puN mm/ksm.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file mm/ksm.c
--- a/mm/ksm.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/mm/ksm.c
@@ -1748,7 +1748,7 @@ int ksm_madvise(struct vm_area_struct *v
 		 */
 		if (*vm_flags & (VM_MERGEABLE | VM_SHARED  | VM_MAYSHARE   |
 				 VM_PFNMAP    | VM_IO      | VM_DONTEXPAND |
-				 VM_HUGETLB | VM_NONLINEAR | VM_MIXEDMAP))
+				 VM_HUGETLB | VM_MIXEDMAP))
 			return 0;		/* just ignore the advice */
 
 #ifdef VM_SAO
diff -puN mm/madvise.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file mm/madvise.c
--- a/mm/madvise.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/mm/madvise.c
@@ -155,7 +155,7 @@ static int swapin_walk_pmd_entry(pmd_t *
 		pte = *(orig_pte + ((index - start) / PAGE_SIZE));
 		pte_unmap_unlock(orig_pte, ptl);
 
-		if (pte_present(pte) || pte_none(pte) || pte_file(pte))
+		if (pte_present(pte) || pte_none(pte))
 			continue;
 		entry = pte_to_swp_entry(pte);
 		if (unlikely(non_swap_entry(entry)))
@@ -296,7 +296,7 @@ static long madvise_remove(struct vm_are
 
 	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
 
-	if (vma->vm_flags & (VM_LOCKED|VM_NONLINEAR|VM_HUGETLB))
+	if (vma->vm_flags & (VM_LOCKED | VM_HUGETLB))
 		return -EINVAL;
 
 	f = vma->vm_file;
diff -puN mm/memcontrol.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file mm/memcontrol.c
--- a/mm/memcontrol.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/mm/memcontrol.c
@@ -4926,10 +4926,7 @@ static struct page *mc_handle_file_pte(s
 		return NULL;
 
 	mapping = vma->vm_file->f_mapping;
-	if (pte_none(ptent))
-		pgoff = linear_page_index(vma, addr);
-	else /* pte_file(ptent) is true */
-		pgoff = pte_to_pgoff(ptent);
+	pgoff = linear_page_index(vma, addr);
 
 	/* page is moved even if it's not RSS of this task(page-faulted). */
 #ifdef CONFIG_SWAP
@@ -4961,7 +4958,7 @@ static enum mc_target_type get_mctgt_typ
 		page = mc_handle_present_pte(vma, addr, ptent);
 	else if (is_swap_pte(ptent))
 		page = mc_handle_swap_pte(vma, addr, ptent, &ent);
-	else if (pte_none(ptent) || pte_file(ptent))
+	else if (pte_none(ptent))
 		page = mc_handle_file_pte(vma, addr, ptent, &ent);
 
 	if (!page && !ent.val)
diff -puN mm/memory.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file mm/memory.c
--- a/mm/memory.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/mm/memory.c
@@ -813,42 +813,40 @@ copy_one_pte(struct mm_struct *dst_mm, s
 
 	/* pte contains position in swap or file, so copy. */
 	if (unlikely(!pte_present(pte))) {
-		if (!pte_file(pte)) {
-			swp_entry_t entry = pte_to_swp_entry(pte);
+		swp_entry_t entry = pte_to_swp_entry(pte);
 
-			if (likely(!non_swap_entry(entry))) {
-				if (swap_duplicate(entry) < 0)
-					return entry.val;
-
-				/* make sure dst_mm is on swapoff's mmlist. */
-				if (unlikely(list_empty(&dst_mm->mmlist))) {
-					spin_lock(&mmlist_lock);
-					if (list_empty(&dst_mm->mmlist))
-						list_add(&dst_mm->mmlist,
-							 &src_mm->mmlist);
-					spin_unlock(&mmlist_lock);
-				}
-				rss[MM_SWAPENTS]++;
-			} else if (is_migration_entry(entry)) {
-				page = migration_entry_to_page(entry);
-
-				if (PageAnon(page))
-					rss[MM_ANONPAGES]++;
-				else
-					rss[MM_FILEPAGES]++;
-
-				if (is_write_migration_entry(entry) &&
-				    is_cow_mapping(vm_flags)) {
-					/*
-					 * COW mappings require pages in both
-					 * parent and child to be set to read.
-					 */
-					make_migration_entry_read(&entry);
-					pte = swp_entry_to_pte(entry);
-					if (pte_swp_soft_dirty(*src_pte))
-						pte = pte_swp_mksoft_dirty(pte);
-					set_pte_at(src_mm, addr, src_pte, pte);
-				}
+		if (likely(!non_swap_entry(entry))) {
+			if (swap_duplicate(entry) < 0)
+				return entry.val;
+
+			/* make sure dst_mm is on swapoff's mmlist. */
+			if (unlikely(list_empty(&dst_mm->mmlist))) {
+				spin_lock(&mmlist_lock);
+				if (list_empty(&dst_mm->mmlist))
+					list_add(&dst_mm->mmlist,
+							&src_mm->mmlist);
+				spin_unlock(&mmlist_lock);
+			}
+			rss[MM_SWAPENTS]++;
+		} else if (is_migration_entry(entry)) {
+			page = migration_entry_to_page(entry);
+
+			if (PageAnon(page))
+				rss[MM_ANONPAGES]++;
+			else
+				rss[MM_FILEPAGES]++;
+
+			if (is_write_migration_entry(entry) &&
+					is_cow_mapping(vm_flags)) {
+				/*
+				 * COW mappings require pages in both
+				 * parent and child to be set to read.
+				 */
+				make_migration_entry_read(&entry);
+				pte = swp_entry_to_pte(entry);
+				if (pte_swp_soft_dirty(*src_pte))
+					pte = pte_swp_mksoft_dirty(pte);
+				set_pte_at(src_mm, addr, src_pte, pte);
 			}
 		}
 		goto out_set_pte;
@@ -1022,11 +1020,9 @@ int copy_page_range(struct mm_struct *ds
 	 * readonly mappings. The tradeoff is that copy_page_range is more
 	 * efficient than faulting.
 	 */
-	if (!(vma->vm_flags & (VM_HUGETLB | VM_NONLINEAR |
-			       VM_PFNMAP | VM_MIXEDMAP))) {
-		if (!vma->anon_vma)
-			return 0;
-	}
+	if (!(vma->vm_flags & (VM_HUGETLB | VM_PFNMAP | VM_MIXEDMAP)) &&
+			!vma->anon_vma)
+		return 0;
 
 	if (is_vm_hugetlb_page(vma))
 		return copy_hugetlb_page_range(dst_mm, src_mm, vma);
diff -puN mm/mincore.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file mm/mincore.c
--- a/mm/mincore.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/mm/mincore.c
@@ -124,17 +124,13 @@ static void mincore_pte_range(struct vm_
 	ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	do {
 		pte_t pte = *ptep;
-		pgoff_t pgoff;
 
 		next = addr + PAGE_SIZE;
 		if (pte_none(pte))
 			mincore_unmapped_range(vma, addr, next, vec);
 		else if (pte_present(pte))
 			*vec = 1;
-		else if (pte_file(pte)) {
-			pgoff = pte_to_pgoff(pte);
-			*vec = mincore_page(vma->vm_file->f_mapping, pgoff);
-		} else { /* pte is a swap entry */
+		else { /* pte is a swap entry */
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
 			if (non_swap_entry(entry)) {
@@ -145,9 +141,8 @@ static void mincore_pte_range(struct vm_
 				*vec = 1;
 			} else {
 #ifdef CONFIG_SWAP
-				pgoff = entry.val;
 				*vec = mincore_page(swap_address_space(entry),
-					pgoff);
+					entry.val);
 #else
 				WARN_ON(1);
 				*vec = 1;
diff -puN mm/mprotect.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file mm/mprotect.c
--- a/mm/mprotect.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/mm/mprotect.c
@@ -105,7 +105,7 @@ static unsigned long change_pte_range(st
 			}
 			if (updated)
 				pages++;
-		} else if (IS_ENABLED(CONFIG_MIGRATION) && !pte_file(oldpte)) {
+		} else if (IS_ENABLED(CONFIG_MIGRATION)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
 
 			if (is_write_migration_entry(entry)) {
diff -puN mm/mremap.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file mm/mremap.c
--- a/mm/mremap.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/mm/mremap.c
@@ -81,8 +81,6 @@ static pte_t move_soft_dirty_pte(pte_t p
 		pte = pte_mksoft_dirty(pte);
 	else if (is_swap_pte(pte))
 		pte = pte_swp_mksoft_dirty(pte);
-	else if (pte_file(pte))
-		pte = pte_file_mksoft_dirty(pte);
 #endif
 	return pte;
 }
diff -puN mm/msync.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file mm/msync.c
--- a/mm/msync.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file
+++ a/mm/msync.c
@@ -86,10 +86,7 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 				(vma->vm_flags & VM_SHARED)) {
 			get_file(file);
 			up_read(&mm->mmap_sem);
-			if (vma->vm_flags & VM_NONLINEAR)
-				error = vfs_fsync(file, 1);
-			else
-				error = vfs_fsync_range(file, fstart, fend, 1);
+			error = vfs_fsync_range(file, fstart, fend, 1);
 			fput(file);
 			if (error || start >= end)
 				goto out;
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

