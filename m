Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199F14A07
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773958614; cv=none; b=BDSYLyoRaXmZcxzOT9U7K611ydT0mDpj4/QMsDhoaSF8lPZowV/u+r+i1by5yK5xBxR64wJkhD+IIVeHCJNZ26q60WODCG78Hnnk26i6umTeIZAn94mPz49BauiGXxN/WPdk5rvwu+C37Nzrbai6HebIMI5nVv+0DRhUqThObKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773958614; c=relaxed/simple;
	bh=qJgEFMp4TYyNfMeB193Rq5TVcZ7N9zXvY5s48gz814g=;
	h=Date:To:From:Subject:Message-Id; b=upVlyvCNUou3fPqykxk0Z8xLsQGNolL9BnLCgV/L/j2DHa7fsDdqCA+qXBDY4ALC7DZrXgZxb8BX2siQhQ3Y4HsQRvWvA+q0q2L8Be8KmO4FjIfHSUIGKUVII9tv4K5QmrVkB54mqPxPbaM2RZu8aIapTCumNwYUjvz69Qs/ojQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LTHAnHfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LTHAnHfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1DCC19424;
	Thu, 19 Mar 2026 22:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773958613;
	bh=qJgEFMp4TYyNfMeB193Rq5TVcZ7N9zXvY5s48gz814g=;
	h=Date:To:From:Subject:From;
	b=LTHAnHfB4jjjzuisKC2RaQ8i7ZACATP5Q28MjbFlzIX87cZJdrQtDIds4+4rkGY//
	 sJL8q5BA6syjPJ79GjqDwQW0ACgDAwjuHPxqf4I/+c5lBMTmPzHXBggZSmYdKXKF6u
	 MYR6ckKEopm4L2hj6KNSoMkfmCViiDG5KsxW818Q=
Date: Thu, 19 Mar 2026 15:16:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,kirill@shutemov.name,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-simplify-vma_is_specal_huge.patch added to mm-new branch
Message-Id: <20260319221653.8A1DCC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: simplify vma_is_specal_huge()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-simplify-vma_is_specal_huge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-simplify-vma_is_specal_huge.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: simplify vma_is_specal_huge()
Date: Thu, 19 Mar 2026 13:00:07 +0000

Patch series "mm/huge_memory: refactor zap_huge_pmd()", v2.

zap_huge_pmd() is overly complicated, clean it up and also add an assert
in the case that we encounter a buggy PMD entry that doesn't match
expectations.

This is motivated by a bug discovered [0] where the PMD entry was none of:

* A non-DAX, PFN or mixed map.
* The huge zero folio
* A present PMD entry
* A softleaf entry

In zap_huge_pmd(), but due to the bug we manged to reach this code.

It is useful to explicitly call this out rather than have an arbitrary
NULL pointer dereference happen, which also improves understanding of
what's going on.


This patch (of 9):

This function is confused - it overloads the term 'special' yet again,
checks for DAX but in many cases the code explicitly excludes DAX before
invoking the predicate.

It also unnecessarily checks for vma->vm_file - this has to be present for
a driver to have set VMA_MIXEDMAP_BIT or VMA_PFNMAP_BIT.

In fact, a far simpler form of this is to reverse the DAX predicate and
return false if DAX is set.

This makes sense from the point of view of 'special' as in
vm_normal_page(), as DAX actually does potentially have retrievable
folios.

Also there's no need to have this in mm.h so move it to huge_memory.c.

Link: https://lkml.kernel.org/r/cover.1773924928.git.ljs@kernel.org
Link: https://lkml.kernel.org/r/613669b1b2082d34f5632907003ae3874eff2ed9.1773924928.git.ljs@kernel.org
Link: https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/ [0]
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++--
 include/linux/mm.h      |   16 ----------------
 mm/huge_memory.c        |   30 +++++++++++++++++++++++-------
 3 files changed, 25 insertions(+), 25 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-simplify-vma_is_specal_huge
+++ a/include/linux/huge_mm.h
@@ -83,7 +83,7 @@ extern struct kobj_attribute thpsize_shm
  * file is never split and the MAX_PAGECACHE_ORDER limit does not apply to
  * it.  Same to PFNMAPs where there's neither page* nor pagecache.
  */
-#define THP_ORDERS_ALL_SPECIAL		\
+#define THP_ORDERS_ALL_SPECIAL_DAX	\
 	(BIT(PMD_ORDER) | BIT(PUD_ORDER))
 #define THP_ORDERS_ALL_FILE_DEFAULT	\
 	((BIT(MAX_PAGECACHE_ORDER + 1) - 1) & ~BIT(0))
@@ -92,7 +92,7 @@ extern struct kobj_attribute thpsize_shm
  * Mask of all large folio orders supported for THP.
  */
 #define THP_ORDERS_ALL	\
-	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
+	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL_DAX | THP_ORDERS_ALL_FILE_DEFAULT)
 
 enum tva_type {
 	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
--- a/include/linux/mm.h~mm-huge_memory-simplify-vma_is_specal_huge
+++ a/include/linux/mm.h
@@ -5078,22 +5078,6 @@ long copy_folio_from_user(struct folio *
 			   const void __user *usr_src,
 			   bool allow_pagefault);
 
-/**
- * vma_is_special_huge - Are transhuge page-table entries considered special?
- * @vma: Pointer to the struct vm_area_struct to consider
- *
- * Whether transhuge page-table entries are considered "special" following
- * the definition in vm_normal_page().
- *
- * Return: true if transhuge page-table entries should be considered special,
- * false otherwise.
- */
-static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
-{
-	return vma_is_dax(vma) || (vma->vm_file &&
-				   (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
-}
-
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if MAX_NUMNODES > 1
--- a/mm/huge_memory.c~mm-huge_memory-simplify-vma_is_specal_huge
+++ a/mm/huge_memory.c
@@ -103,6 +103,14 @@ static inline bool file_thp_enabled(stru
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
+/* If returns true, we are unable to access the VMA's folios. */
+static bool vma_is_special_huge(struct vm_area_struct *vma)
+{
+	if (vma_is_dax(vma))
+		return false;
+	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 enum tva_type type,
@@ -116,8 +124,8 @@ unsigned long __thp_vma_allowable_orders
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_special_huge(vma))
-		supported_orders = THP_ORDERS_ALL_SPECIAL;
+	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
+		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
@@ -2338,7 +2346,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 						tlb->fullmm);
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
+	if (vma_is_special_huge(vma)) {
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
@@ -2840,7 +2848,7 @@ int zap_huge_pud(struct mmu_gather *tlb,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
+	if (vma_is_special_huge(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -2991,7 +2999,7 @@ static void __split_huge_pmd_locked(stru
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
+		if (vma_is_special_huge(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4517,8 +4525,16 @@ next:
 
 static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
 {
-	return vma_is_special_huge(vma) || (vma->vm_flags & VM_IO) ||
-		    is_vm_hugetlb_page(vma);
+	if (vma_is_dax(vma))
+		return true;
+	if (vma_is_special_huge(vma))
+		return true;
+	if (vma_test(vma, VMA_IO_BIT))
+		return true;
+	if (is_vm_hugetlb_page(vma))
+		return true;
+
+	return false;
 }
 
 static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-zswap-add-missing-kunmap_local.patch
mm-rmap-clear-vma-anon_vma-on-error.patch
mm-rename-vma-flag-helpers-to-be-more-readable.patch
mm-add-vma_desc_test_all-and-use-it.patch
mm-always-inline-__mk_vma_flags-and-invoked-functions.patch
mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch
mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix.patch
mm-mremap-correct-invalid-map-count-check.patch
mm-abstract-reading-sysctl_max_map_count-and-read_once.patch
mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch
mm-vma-add-vma_flags_empty-vma_flags_and-vma_flags_diff_pair.patch
tools-testing-vma-add-unit-tests-flag-empty-diff_pair-and.patch
mm-vma-add-further-vma_flags_t-unions.patch
tools-testing-vma-convert-bulk-of-test-code-to-vma_flags_t.patch
mm-vma-use-new-vma-flags-for-sticky-flags-logic.patch
tools-testing-vma-fix-vma-flag-tests.patch
mm-vma-add-append_vma_flags-helper.patch
tools-testing-vma-add-simple-test-for-append_vma_flags.patch
mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter.patch
mm-vma-introduce-vma_flags_same.patch
mm-vma-introduce-_to_-helpers.patch
tools-testing-vma-test-that-legacy-flag-helpers-work-correctly.patch
mm-vma-introduce-vma_test-and-make-inlining-consistent.patch
tools-testing-vma-update-vma-flag-tests-to-test-vma_test.patch
mm-introduce-vma_flags_count-and-vma_test_single_mask.patch
tools-testing-vma-test-vma_flags_countvma_test_single_mask.patch
mm-convert-do_brk_flags-to-use-vma_flags_t.patch
mm-update-vma_supports_mlock-to-use-new-vma-flags.patch
mm-vma-introduce-vma_clear_flags.patch
tools-testing-vma-update-vma-tests-to-test-vma_clear_flags.patch
mm-vma-convert-as-much-as-we-can-in-mm-vmac-to-vma_flags_t.patch
mm-vma-convert-vma_modify_flags-to-use-vma_flags_t.patch
mm-vma-convert-__mmap_region-to-use-vma_flags_t.patch
mm-various-small-mmap_prepare-cleanups.patch
mm-add-documentation-for-the-mmap_prepare-file-operation-callback.patch
mm-document-vm_operations_struct-open-the-same-as-close.patch
mm-add-vm_ops-mapped-hook.patch
fs-afs-correctly-drop-reference-count-on-mapping-failure.patch
mm-add-mmap_action_simple_ioremap.patch
misc-open-dice-replace-deprecated-mmap-hook-with-mmap_prepare.patch
hpet-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mtdchar-replace-deprecated-mmap-hook-with-mmap_prepare-clean-up.patch
stm-replace-deprecated-mmap-hook-with-mmap_prepare.patch
staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers.patch
drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare.patch
uio-replace-deprecated-mmap-hook-with-mmap_prepare-in-uio_info.patch
mm-add-mmap_action_map_kernel_pages.patch
mm-on-remap-assert-that-input-range-within-the-proposed-vma.patch
mm-huge_memory-simplify-vma_is_specal_huge.patch
mm-huge-avoid-big-else-branch-in-zap_huge_pmd.patch
mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc.patch
mm-huge_memory-handle-buggy-pmd-entry-in-zap_huge_pmd.patch
mm-huge_memory-add-a-common-exit-path-to-zap_huge_pmd.patch
mm-huge_memory-remove-unnecessary-vm_bug_on_page.patch
mm-huge_memory-deduplicate-zap-deposited-table-call.patch
mm-huge_memory-deduplicate-zap_huge_pmd-further-by-tracking-state.patch
mm-huge_memory-have-zap_huge_pmd-use-vm_normal_folio_pmd.patch

