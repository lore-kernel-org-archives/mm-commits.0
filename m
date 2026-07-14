Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9037137D11C
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 02:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783995965; cv=none; b=OZ8WFB9dDd+1sYCSP4OQF5V0JptiM9l5Bi41K1jBHDLI4E9r6+Z+SegNiwtzZmzmvGvzO1OAe6C3pzaPrHblwe+ZnTms6jWA1Q0ZW6qG1+AUoOwsHfHuJzLWcqR00ggU3/m5zWFz/TOlCsaQV/o0P7qx24QefqTkovxGi33YxrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783995965; c=relaxed/simple;
	bh=vlC4o4Z1G2bPS724qHOmodkDcB2IUn92jKsrHmtDrGw=;
	h=Date:To:From:Subject:Message-Id; b=MCBC16UBQksV/jUc9c7CdVe2YZugkvkNr37zs175wuwsRrMPBKB3P+8zmd9E3+wGQ5Bi+kEmmPavvRMkCuGSPTF+Y0k/IxUCzX6RDOI1Ia8Xu2wXjMYtSMXg0WaoMc3ZGBM8xgSylO8QtAqabtI/4ckKk37vLV5z/eCzd+26lCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HF7YYFk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HF7YYFk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A15A1F000E9;
	Tue, 14 Jul 2026 02:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783995963;
	bh=r09tzu8XfxCv3g3GF78y5jMdlIkk30xa/SN1C2SnmKU=;
	h=Date:To:From:Subject;
	b=HF7YYFk/aMU07C8CTk90mMnzsKHTIEXhlBSXI3xXpa9ZYNFNtB5FzHqaRtA+e/+Ds
	 dUqCwYmhXHcH5PJ3FulFop7PH0OHAVQo2iGqVMy7sxjqdfxA5/Meg5NRRSQiJaoMMx
	 UEdpQdIzN+mIia3HITWSiw0ed8zaST87P/RBarLY=
Date: Mon, 13 Jul 2026 19:26:02 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch added to mm-new branch
Message-Id: <20260714022603.1A15A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update generic_get_unmapped_area[_topdown]() to use vma_flags_t
has been added to the -mm mm-new branch.  Its filename is
     mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch

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
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm: update generic_get_unmapped_area[_topdown]() to use vma_flags_t
Date: Sat, 11 Jul 2026 19:45:01 +0100

As part of the changes converting VMA flags from a system word size to a
bitmap, extend this change to generic_get_unmapped_area() and
generic_get_unmapped_area_topdown(), which also allows us to convert
stack_guard_placement() as well.

We retain arch_get_unmapped_area() and arch_get_unmapped_area_topdown()
as-is for now, using legacy_to_vma_flags() as necessary to do so.

No functional change intended.

Link: https://lore.kernel.org/20260711-b4-vma-flags-mm-v2-4-0fa2357d5431@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/slice.c |    6 ++++--
 include/linux/sched/mm.h         |    4 ++--
 mm/mmap.c                        |   16 ++++++++--------
 3 files changed, 14 insertions(+), 12 deletions(-)

--- a/arch/powerpc/mm/book3s64/slice.c~mm-update-generic_get_unmapped_area-to-use-vma_flags_t
+++ a/arch/powerpc/mm/book3s64/slice.c
@@ -659,7 +659,8 @@ unsigned long arch_get_unmapped_area(str
 	unsigned int psize;
 
 	if (radix_enabled())
-		return generic_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
+		return generic_get_unmapped_area(filp, addr, len, pgoff, flags,
+						 legacy_to_vma_flags(vm_flags));
 
 	if (filp && is_file_hugepages(filp))
 		psize = file_to_psize(filp);
@@ -679,7 +680,8 @@ unsigned long arch_get_unmapped_area_top
 	unsigned int psize;
 
 	if (radix_enabled())
-		return generic_get_unmapped_area_topdown(filp, addr0, len, pgoff, flags, vm_flags);
+		return generic_get_unmapped_area_topdown(filp, addr0, len,
+				pgoff, flags, legacy_to_vma_flags(vm_flags));
 
 	if (filp && is_file_hugepages(filp))
 		psize = file_to_psize(filp);
--- a/include/linux/sched/mm.h~mm-update-generic_get_unmapped_area-to-use-vma_flags_t
+++ a/include/linux/sched/mm.h
@@ -200,11 +200,11 @@ unsigned long mm_get_unmapped_area_vmafl
 unsigned long
 generic_get_unmapped_area(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags, vm_flags_t vm_flags);
+			  unsigned long flags, vma_flags_t vma_flags);
 unsigned long
 generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 				  unsigned long len, unsigned long pgoff,
-				  unsigned long flags, vm_flags_t vm_flags);
+				  unsigned long flags, vma_flags_t vma_flags);
 #else
 static inline void arch_pick_mmap_layout(struct mm_struct *mm,
 					 const struct rlimit *rlim_stack) {}
--- a/mm/mmap.c~mm-update-generic_get_unmapped_area-to-use-vma_flags_t
+++ a/mm/mmap.c
@@ -657,9 +657,9 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
  * Determine if the allocation needs to ensure that there is no
  * existing mapping within it's guard gaps, for use as start_gap.
  */
-static inline unsigned long stack_guard_placement(vm_flags_t vm_flags)
+static inline unsigned long stack_guard_placement(vma_flags_t vma_flags)
 {
-	if (vm_flags & VM_SHADOW_STACK)
+	if (vma_flags_test_single_mask(&vma_flags, VMA_SHADOW_STACK))
 		return PAGE_SIZE;
 
 	return 0;
@@ -701,7 +701,7 @@ unsigned long vm_unmapped_area(struct vm
 unsigned long
 generic_get_unmapped_area(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags, vm_flags_t vm_flags)
+			  unsigned long flags, vma_flags_t vma_flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
@@ -726,7 +726,7 @@ generic_get_unmapped_area(struct file *f
 	info.length = len;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = mmap_end;
-	info.start_gap = stack_guard_placement(vm_flags);
+	info.start_gap = stack_guard_placement(vma_flags);
 	if (filp && is_file_hugepages(filp))
 		info.align_mask = huge_page_mask_align(filp);
 	return vm_unmapped_area(&info);
@@ -739,7 +739,7 @@ arch_get_unmapped_area(struct file *filp
 		       unsigned long flags, vm_flags_t vm_flags)
 {
 	return generic_get_unmapped_area(filp, addr, len, pgoff, flags,
-					 vm_flags);
+					 legacy_to_vma_flags(vm_flags));
 }
 #endif
 
@@ -750,7 +750,7 @@ arch_get_unmapped_area(struct file *filp
 unsigned long
 generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 				  unsigned long len, unsigned long pgoff,
-				  unsigned long flags, vm_flags_t vm_flags)
+				  unsigned long flags, vma_flags_t vma_flags)
 {
 	struct vm_area_struct *vma, *prev;
 	struct mm_struct *mm = current->mm;
@@ -778,7 +778,7 @@ generic_get_unmapped_area_topdown(struct
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
-	info.start_gap = stack_guard_placement(vm_flags);
+	info.start_gap = stack_guard_placement(vma_flags);
 	if (filp && is_file_hugepages(filp))
 		info.align_mask = huge_page_mask_align(filp);
 	addr = vm_unmapped_area(&info);
@@ -807,7 +807,7 @@ arch_get_unmapped_area_topdown(struct fi
 			       unsigned long flags, vm_flags_t vm_flags)
 {
 	return generic_get_unmapped_area_topdown(filp, addr, len, pgoff, flags,
-						 vm_flags);
+						 legacy_to_vma_flags(vm_flags));
 }
 #endif
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
x86-mm-pat-acquire-mmap-lock-on-page-table-free-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-move-alloc-tag-to-mm.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch

