Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D225E266576
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744891; cv=none; b=SSzZqo2OxAtRf5uwm06kD+ZrULUcNDf928uYUsL+5VF7yVzcvET3J5fxVU6Fcw6zUrGVq7O8mPCjC+rfoGQSd1fbpk//evJE7yurtk4mPUotlmKzDt9gPNNG3riPfxAIRNd/sjKWpoAo1Xx1z+hPWAyz67/ABTS92/rAa1/EtLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744891; c=relaxed/simple;
	bh=wcadeTWqNTMfMlU32BrgoHJ4zbABZSSNzkjcZm/gIqk=;
	h=Date:To:From:Subject:Message-Id; b=Kq3LQAt6oFfipctoz3i325PXbvus4UDj3Cyily3RkdVLvdT/HWPP0xHJC7RtY/FE3AKtTIAZdNcW+q9ISSfzHYF45KOYIU5tljeyVgL1pADV9XbsXoQthdgOvyQUwOteCvhbnd9suNKWxBxCc4wQmaBzWRu5XBPLjMPfo3ehaZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sfKggEOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sfKggEOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB38C4CEF7;
	Sun, 29 Mar 2026 00:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744891;
	bh=wcadeTWqNTMfMlU32BrgoHJ4zbABZSSNzkjcZm/gIqk=;
	h=Date:To:From:Subject:From;
	b=sfKggEOkH5Bm2B/2bZMzW/gEnqDUc+ZDerqCowucBVv7AoljK/8GSDDnTTu7lwBJn
	 U9NP/8dMF15/kH+qHonN5AAP/JqVFf/8QAxMb8CUI3BOqbXmw6khjwZEBH5xi+pFQd
	 SZqqX/796PGol4kEjAjTBpBRn9zLYIR9aP6I9Zdg=
Date: Sat, 28 Mar 2026 17:41:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,mhocko@suse.com,luckd0g@163.com,liam.howlett@oracle.com,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-abstract-reading-sysctl_max_map_count-and-read_once.patch removed from -mm tree
Message-Id: <20260329004131.5DB38C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: abstract reading sysctl_max_map_count, and READ_ONCE()
has been removed from the -mm tree.  Its filename was
     mm-abstract-reading-sysctl_max_map_count-and-read_once.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: abstract reading sysctl_max_map_count, and READ_ONCE()
Date: Wed, 11 Mar 2026 17:24:37 +0000

Concurrent reads and writes of sysctl_max_map_count are possible, so we
should READ_ONCE() and WRITE_ONCE().

The sysctl procfs logic already enforces WRITE_ONCE(), so abstract the
read side with get_sysctl_max_map_count().

While we're here, also move the field to mm/internal.h and add the getter
there since only mm interacts with it, there's no need for anybody else to
have access.

Finally, update the VMA userland tests to reflect the change.

Link: https://lkml.kernel.org/r/0715259eb37cbdfde4f9e5db92a20ec7110a1ce5.1773249037.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Jianzhou Zhao <luckd0g@163.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h                 |    2 --
 mm/internal.h                      |    6 ++++++
 mm/mmap.c                          |    2 +-
 mm/mremap.c                        |    4 ++--
 mm/nommu.c                         |    2 +-
 mm/vma.c                           |    6 +++---
 tools/testing/vma/include/custom.h |    3 ---
 tools/testing/vma/include/dup.h    |    9 +++++++++
 tools/testing/vma/main.c           |    2 ++
 9 files changed, 24 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/include/linux/mm.h
@@ -207,8 +207,6 @@ static inline void __mm_zero_struct_page
 #define MAPCOUNT_ELF_CORE_MARGIN	(5)
 #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
 
-extern int sysctl_max_map_count;
-
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
--- a/mm/internal.h~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/mm/internal.h
@@ -1863,4 +1863,10 @@ static inline int pmdp_test_and_clear_yo
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
+extern int sysctl_max_map_count;
+static inline int get_sysctl_max_map_count(void)
+{
+	return READ_ONCE(sysctl_max_map_count);
+}
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/mmap.c~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/mm/mmap.c
@@ -375,7 +375,7 @@ unsigned long do_mmap(struct file *file,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	/*
--- a/mm/mremap.c~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/mm/mremap.c
@@ -1045,7 +1045,7 @@ static unsigned long prep_move_vma(struc
 	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
 	 * source, which may split, causing a net increase of 2 mappings.
 	 */
-	if (current->mm->map_count + 2 > sysctl_max_map_count)
+	if (current->mm->map_count + 2 > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1813,7 +1813,7 @@ static unsigned long check_mremap_params
 	 * net increased map count of 2. In move_vma() we check for headroom of
 	 * 2 additional mappings, so check early to avoid bailing out then.
 	 */
-	if (current->mm->map_count + 4 > sysctl_max_map_count)
+	if (current->mm->map_count + 4 > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	return 0;
--- a/mm/nommu.c~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/mm/nommu.c
@@ -1317,7 +1317,7 @@ static int split_vma(struct vma_iterator
 		return -ENOMEM;
 
 	mm = vma->vm_mm;
-	if (mm->map_count >= sysctl_max_map_count)
+	if (mm->map_count >= get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	region = kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
--- a/mm/vma.c~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/mm/vma.c
@@ -590,7 +590,7 @@ out_free_vma:
 static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		     unsigned long addr, int new_below)
 {
-	if (vma->vm_mm->map_count >= sysctl_max_map_count)
+	if (vma->vm_mm->map_count >= get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	return __split_vma(vmi, vma, addr, new_below);
@@ -1394,7 +1394,7 @@ static int vms_gather_munmap_vmas(struct
 		 * its limit temporarily, to help free resources as expected.
 		 */
 		if (vms->end < vms->vma->vm_end &&
-		    vms->vma->vm_mm->map_count >= sysctl_max_map_count) {
+		    vms->vma->vm_mm->map_count >= get_sysctl_max_map_count()) {
 			error = -ENOMEM;
 			goto map_count_exceeded;
 		}
@@ -2868,7 +2868,7 @@ int do_brk_flags(struct vma_iterator *vm
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
--- a/tools/testing/vma/include/custom.h~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/tools/testing/vma/include/custom.h
@@ -21,9 +21,6 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
 #define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
 
-/* We hardcode this for now. */
-#define sysctl_max_map_count 0x1000000UL
-
 #define TASK_SIZE ((1ul << 47)-PAGE_SIZE)
 
 /*
--- a/tools/testing/vma/include/dup.h~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/tools/testing/vma/include/dup.h
@@ -419,6 +419,9 @@ struct vma_iterator {
 
 #define EMPTY_VMA_FLAGS ((vma_flags_t){ })
 
+#define MAPCOUNT_ELF_CORE_MARGIN	(5)
+#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
+
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
 	MMAP_NOTHING,		/* Mapping is complete, no further action. */
@@ -1342,3 +1345,9 @@ static inline void vma_set_file(struct v
 	swap(vma->vm_file, file);
 	fput(file);
 }
+
+extern int sysctl_max_map_count;
+static inline int get_sysctl_max_map_count(void)
+{
+	return READ_ONCE(sysctl_max_map_count);
+}
--- a/tools/testing/vma/main.c~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/tools/testing/vma/main.c
@@ -14,6 +14,8 @@
 #include "tests/mmap.c"
 #include "tests/vma.c"
 
+int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
+
 /* Helper functions which utilise static kernel functions. */
 
 struct vm_area_struct *merge_existing(struct vma_merge_struct *vmg)
_

Patches currently in -mm which might be from ljs@kernel.org are

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
tools-bitmap-add-missing-bitmap_copy-implementation.patch
mm-vma-convert-vma_modify_flags-to-use-vma_flags_t.patch
mm-vma-convert-__mmap_region-to-use-vma_flags_t.patch
mm-simplify-vma-flag-tests-of-excluded-flags.patch
mm-various-small-mmap_prepare-cleanups.patch
mm-add-documentation-for-the-mmap_prepare-file-operation-callback.patch
mm-document-vm_operations_struct-open-the-same-as-close.patch
mm-avoid-deadlock-when-holding-rmap-on-mmap_prepare-error.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer.patch
mm-vma-remove-superfluous-map-hold_file_rmap_lock.patch
mm-have-mmap_action_complete-handle-the-rmap-lock-and-unmap.patch
mm-add-vm_ops-mapped-hook.patch
fs-afs-revert-mmap_prepare-change.patch
fs-afs-restore-mmap_prepare-implementation.patch
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
mm-huge_memory-remove-unnecessary-sanity-checks.patch
mm-huge_memory-use-mm-instead-of-tlb-mm.patch
mm-huge_memory-separate-out-the-folio-part-of-zap_huge_pmd.patch
mm-add-softleaf_is_valid_pmd_entry-pmd_to_softleaf_folio.patch
mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd.patch
mm-huge_memory-add-and-use-has_deposited_pgtable.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch

