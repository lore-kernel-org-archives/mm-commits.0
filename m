From: akpm@linux-foundation.org
Subject: + mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch added
 to -mm tree
Date: Tue, 06 Jan 2015 15:34:02 -0800
Message-ID: <54ac70ea.Z0dFG3aa703c0BJF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbbAFXeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove rest usage of VM_NONLINEAR and pte_file()
has been added to the -mm tree.  Its filename is
     mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch

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
Subject: mm: remove rest usage of VM_NONLINEAR and pte_file()

One bit in ->vm_flags is unused now!

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_vma_manager.c |    3 -
 include/linux/mm.h                |    1 
 include/linux/swapops.h           |    4 -
 mm/debug.c                        |    1 
 mm/gup.c                          |    2 
 mm/ksm.c                          |    2 
 mm/madvise.c                      |    4 -
 mm/memcontrol.c                   |    4 -
 mm/memory.c                       |   76 +++++++++++++---------------
 mm/mincore.c                      |    9 ---
 mm/mprotect.c                     |    2 
 mm/mremap.c                       |    2 
 mm/msync.c                        |    5 -
 13 files changed, 47 insertions(+), 68 deletions(-)

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
@@ -4928,8 +4928,6 @@ static struct page *mc_handle_file_pte(s
 	mapping = vma->vm_file->f_mapping;
 	if (pte_none(ptent))
 		pgoff = linear_page_index(vma, addr);
-	else /* pte_file(ptent) is true */
-		pgoff = pte_to_pgoff(ptent);
 
 	/* page is moved even if it's not RSS of this task(page-faulted). */
 #ifdef CONFIG_SWAP
@@ -4961,7 +4959,7 @@ static enum mc_target_type get_mctgt_typ
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
@@ -811,42 +811,40 @@ copy_one_pte(struct mm_struct *dst_mm, s
 
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
@@ -1020,11 +1018,9 @@ int copy_page_range(struct mm_struct *ds
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

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch

