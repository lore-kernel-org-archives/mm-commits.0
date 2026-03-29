Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBDA2641CA
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744893; cv=none; b=p4v1z6XZV1DnF1B8E7k6Jjmu3rAcsysoDHJA+ySDKxfgMgyv2sykbryv96xSLK3L1QKeidLmxlN1PQrK78x4qgtfvLWuycuY378O3UdO8Uqw8yuoU4p0Ps65JEh7w0cR+wgRT1K8wU+RNlqO6AdQV/GS6pI36ddzaGCZzS/dooY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744893; c=relaxed/simple;
	bh=dTLIF7BzJsPlwYVyKUGcKHKbri7+FUvDyw8BJt2UHcQ=;
	h=Date:To:From:Subject:Message-Id; b=QoOlnvwG5IIAT1sLLIGAO8rEJkYqSr0xqwJMz6MnKq3u94NqYDvCkFK9+FXWXgw3/91RWZfhX9ivFdCTwyfOOUFVOhUDaOf8XUho9kNuJro7/r5ZtXZFMLlBnov42MAqEhLDKKb/U5nJXUjH2qZOcgG+RNcsZtxVWUTWHmRYnr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k2/BXboA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k2/BXboA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0ECBC4CEF7;
	Sun, 29 Mar 2026 00:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744892;
	bh=dTLIF7BzJsPlwYVyKUGcKHKbri7+FUvDyw8BJt2UHcQ=;
	h=Date:To:From:Subject:From;
	b=k2/BXboAAj4hO0t6+DnweTWayiVROV98li9KtYWBL6UDIalwiBS0ICCdEaynlJlkI
	 dP184JR/ZBfyY1TqwHoGT0Bnw0MzVsgeEeq1fvNTyhCJolUnyT/UH2Tg6pTA1KPzIH
	 SkVfgT5acpJicUgv3w3IaNSEaPpUykEoWPva7t28=
Date: Sat, 28 Mar 2026 17:41:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,mhocko@suse.com,luckd0g@163.com,liam.howlett@oracle.com,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch removed from -mm tree
Message-Id: <20260329004132.A0ECBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: check map count under mmap write lock and abstract
has been removed from the -mm tree.  Its filename was
     mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/mremap: check map count under mmap write lock and abstract
Date: Wed, 11 Mar 2026 17:24:38 +0000

We are checking the mmap count in check_mremap_params(), prior to
obtaining an mmap write lock, which means that accesses to
current->mm->map_count might race with this field being updated.

Resolve this by only checking this field after the mmap write lock is held.

Additionally, abstract this check into a helper function with extensive
ASCII documentation of what's going on.

Link: https://lkml.kernel.org/r/18be0b48eaa8e8804eb745974ee729c3ade0c687.1773249037.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reported-by: Jianzhou Zhao <luckd0g@163.com>
Closes: https://lore.kernel.org/all/1a7d4c26.6b46.19cdbe7eaf0.Coremail.luckd0g@163.com/
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   88 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 13 deletions(-)

--- a/mm/mremap.c~mm-mremap-check-map-count-under-mmap-write-lock-and-abstract
+++ a/mm/mremap.c
@@ -1028,6 +1028,75 @@ static void vrm_stat_account(struct vma_
 		mm->locked_vm += pages;
 }
 
+static bool __check_map_count_against_split(struct mm_struct *mm,
+					    bool before_unmaps)
+{
+	const int sys_map_count = get_sysctl_max_map_count();
+	int map_count = mm->map_count;
+
+	mmap_assert_write_locked(mm);
+
+	/*
+	 * At the point of shrinking the VMA, if new_len < old_len, we unmap
+	 * thusly in the worst case:
+	 *
+	 *              old_addr+old_len                    old_addr+old_len
+	 * |---------------.----.---------|    |---------------|    |---------|
+	 * |               .    .         | -> |      +1       | -1 |   +1    |
+	 * |---------------.----.---------|    |---------------|    |---------|
+	 *        old_addr+new_len                     old_addr+new_len
+	 *
+	 * At the point of removing the portion of an existing VMA to make space
+	 * for the moved VMA if MREMAP_FIXED, we unmap thusly in the worst case:
+	 *
+	 *   new_addr   new_addr+new_len         new_addr   new_addr+new_len
+	 * |----.---------------.---------|    |----|               |---------|
+	 * |    .               .         | -> | +1 |      -1       |   +1    |
+	 * |----.---------------.---------|    |----|               |---------|
+	 *
+	 * Therefore, before we consider the move anything, we have to account
+	 * for 2 additional VMAs possibly being created upon these unmappings.
+	 */
+	if (before_unmaps)
+		map_count += 2;
+
+	/*
+	 * At the point of MOVING the VMA:
+	 *
+	 * We start by copying a VMA, which creates an additional VMA if no
+	 * merge occurs, then if not MREMAP_DONTUNMAP, we unmap the source VMA.
+	 * In the worst case we might then observe:
+	 *
+	 *   new_addr   new_addr+new_len         new_addr   new_addr+new_len
+	 * |----|               |---------|    |----|---------------|---------|
+	 * |    |               |         | -> |    |      +1       |         |
+	 * |----|               |---------|    |----|---------------|---------|
+	 *
+	 *   old_addr   old_addr+old_len         old_addr   old_addr+old_len
+	 * |----.---------------.---------|    |----|               |---------|
+	 * |    .               .         | -> | +1 |      -1       |   +1    |
+	 * |----.---------------.---------|    |----|               |---------|
+	 *
+	 * Therefore we must check to ensure we have headroom of 2 additional
+	 * VMAs.
+	 */
+	return map_count + 2 <= sys_map_count;
+}
+
+/* Do we violate the map count limit if we split VMAs when moving the VMA? */
+static bool check_map_count_against_split(void)
+{
+	return __check_map_count_against_split(current->mm,
+					       /*before_unmaps=*/false);
+}
+
+/* Do we violate the map count limit if we split VMAs prior to early unmaps? */
+static bool check_map_count_against_split_early(void)
+{
+	return __check_map_count_against_split(current->mm,
+					       /*before_unmaps=*/true);
+}
+
 /*
  * Perform checks before attempting to write a VMA prior to it being
  * moved.
@@ -1045,7 +1114,7 @@ static unsigned long prep_move_vma(struc
 	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
 	 * source, which may split, causing a net increase of 2 mappings.
 	 */
-	if (current->mm->map_count + 2 > get_sysctl_max_map_count())
+	if (!check_map_count_against_split())
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1804,18 +1873,6 @@ static unsigned long check_mremap_params
 	if (vrm_overlaps(vrm))
 		return -EINVAL;
 
-	/*
-	 * We may unmap twice before invoking move_vma(), that is if new_len <
-	 * old_len (shrinking), and in the MREMAP_FIXED case, unmapping part of
-	 * a VMA located at the destination.
-	 *
-	 * In the worst case, both unmappings will cause splits, resulting in a
-	 * net increased map count of 2. In move_vma() we check for headroom of
-	 * 2 additional mappings, so check early to avoid bailing out then.
-	 */
-	if (current->mm->map_count + 4 > get_sysctl_max_map_count())
-		return -ENOMEM;
-
 	return 0;
 }
 
@@ -1925,6 +1982,11 @@ static unsigned long do_mremap(struct vm
 		return -EINTR;
 	vrm->mmap_locked = true;
 
+	if (!check_map_count_against_split_early()) {
+		mmap_write_unlock(mm);
+		return -ENOMEM;
+	}
+
 	if (vrm_move_only(vrm)) {
 		res = remap_move(vrm);
 	} else {
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

