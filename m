Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F323FE362;
	Fri, 27 Mar 2026 17:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633974; cv=none; b=fzhJWgnYII8SNx7+IOrEOlTqyYGEWzK3dGHl8Uw6HXNv/87H2cJ/mMMbwYgDYizeBSkYHiyAlcJA6PzPbxfz/tS/+e5npJVmdwlh2GdzgCXYMBesK9wYzUXMxhiCT60JqLmvkGIMp6wCGu9TYvn5PNRU54c+uWt6t5C2wx4c+0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633974; c=relaxed/simple;
	bh=DupfEdME4n3J9GIhP++80G1+fIhn11d9i7wblGyQNuI=;
	h=Date:To:From:Subject:Message-Id; b=ZEDYldSKF5RAOSn7t1241F5+b+JUeEvKYae6pxHpzRGZHQ1LotyiAKEDNrvuhova7cfr4EpQWQgA3dH4EcDr6j45x0Lp5T+gWJFfbpIUzFJsH0EdtoGLh/5diu0bDpF4Q3f9JlU0caUOVOjbmHJds+VC9UhuWzmKgSOt4wCtQrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C3epP8Tp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C3epP8Tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7BEC19423;
	Fri, 27 Mar 2026 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774633974;
	bh=DupfEdME4n3J9GIhP++80G1+fIhn11d9i7wblGyQNuI=;
	h=Date:To:From:Subject:From;
	b=C3epP8TpVQuIx/tagNUBT/rViKmu6HsCJULOR82QXHJWDYcqVDfRtz2dYEmJgYO24
	 XzzRUiF6ERsnuTdILGcMwjTSUXuLjLjgLJzQXCVkXWUYsDXE4Fow/WJjw6NW5BrBAD
	 FqEPMgljUEq45agu6S79N/eg/SDMZfJikz7Z5NBw=
Date: Fri, 27 Mar 2026 10:52:54 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,liam.howlett@oracle.com,jeffxu@chromium.org,jannh@google.com,david@kernel.org,antonius@bluedragonsec.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mseal-update-vma-end-correctly-on-merge.patch removed from -mm tree
Message-Id: <20260327175254.AE7BEC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: update VMA end correctly on merge
has been removed from the -mm tree.  Its filename was
     mm-mseal-update-vma-end-correctly-on-merge.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/mseal: update VMA end correctly on merge
Date: Fri, 27 Mar 2026 09:06:40 +0000

Previously we stored the end of the current VMA in curr_end, and then upon
iterating to the next VMA updated curr_start to curr_end to advance to the
next VMA.

However, this doesn't take into account the fact that a VMA might be
updated due to a merge by vma_modify_flags(), which can result in curr_end
being stale and thus, upon setting curr_start to curr_end, ending up with
an incorrect curr_start on the next iteration.

Resolve the issue by setting curr_end to vma->vm_end unconditionally to
ensure this value remains updated should this occur.

Link: https://lkml.kernel.org/r/20260327090640.146308-1-ljs@kernel.org
Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reported-by: Antonius <antonius@bluedragonsec.com>
Closes: https://lore.kernel.org/linux-mm/CAK8a0jwWGj9-SgFk0yKFh7i8jMkwKm5b0ao9=kmXWjO54veX2g@mail.gmail.com/
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mseal.c~mm-mseal-update-vma-end-correctly-on-merge
+++ a/mm/mseal.c
@@ -66,7 +66,7 @@ static int mseal_apply(struct mm_struct
 		prev = vma;
 
 	for_each_vma_range(vmi, vma, end) {
-		const unsigned long curr_end = MIN(vma->vm_end, end);
+		unsigned long curr_end = MIN(vma->vm_end, end);
 
 		if (!(vma->vm_flags & VM_SEALED)) {
 			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
@@ -76,6 +76,7 @@ static int mseal_apply(struct mm_struct
 			if (IS_ERR(vma))
 				return PTR_ERR(vma);
 			vm_flags_set(vma, VM_SEALED);
+			curr_end = vma->vm_end; /* Merge may have updated. */
 		}
 
 		prev = vma;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-rename-vma-flag-helpers-to-be-more-readable.patch
mm-add-vma_desc_test_all-and-use-it.patch
mm-always-inline-__mk_vma_flags-and-invoked-functions.patch
mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch
mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch
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
mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd-fix.patch
mm-huge_memory-add-and-use-has_deposited_pgtable.patch
mm-huge_memory-add-and-use-has_deposited_pgtable-fix.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch

