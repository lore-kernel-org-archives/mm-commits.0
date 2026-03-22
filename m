Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9337040DFD8
	for <mm-commits@vger.kernel.org>; Sun, 22 Mar 2026 00:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774139847; cv=none; b=eueFDjahrm3xc34eMXr9x9HN1qtkpJxIsOFrxNBMUG4qyNOLPacJ1GWRhANOCX1EIvdnUZIkYSuEXrD+7jrmsp5zcmNeGKmhfbtX3qfic6aQ9FP8gBS//iPCu/axiB1rrcEEo3zLoh5KcTt/DJjt5NUjVk+y2ejF3W9cGsMMfhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774139847; c=relaxed/simple;
	bh=rrYvNSa+Ppr06++8fHn+jwqTTELxHy1GUiK1J+d8xAw=;
	h=Date:To:From:Subject:Message-Id; b=T/Ve5wqlEf00s36wjLPDtWryayoXFc8JZPYBZiubcnZd0QladnjZ6Ren92lku/XsOvlH/fcHW39VnrzPn5DF4enCST9tV82Bj4T32VfsYYkrO5RxAy2P5o2JFOcuHpdiOd+T+KOXvFVTWuD2tc13qS6k7zInPzyeSa7t0YFIdvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sqhEAaOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sqhEAaOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465E2C19421;
	Sun, 22 Mar 2026 00:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774139847;
	bh=rrYvNSa+Ppr06++8fHn+jwqTTELxHy1GUiK1J+d8xAw=;
	h=Date:To:From:Subject:From;
	b=sqhEAaOOvg2xCsnk+1hmZpoPA+HMkHuMkdmZqNj/JO3YyLtlvsgkinxR6mrNaOVan
	 VP5U4IoF/UDf44HYnZAe4RHrxOoKbxieRsoTom9JupffpkhTr6GBm76ulqCgPQA/Dj
	 75Cb79U1eVx6a2RvPqphn86hdW4er5zqAXrLyb+k=
Date: Sat, 21 Mar 2026 17:37:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sashal@kernel.org,riel@surriel.com,liam.howlett@oracle.com,jiakaipeanut@gmail.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-rmap-clear-vma-anon_vma-on-error.patch removed from -mm tree
Message-Id: <20260322003727.465E2C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: clear vma->anon_vma on error
has been removed from the -mm tree.  Its filename was
     mm-rmap-clear-vma-anon_vma-on-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/rmap: clear vma->anon_vma on error
Date: Wed, 18 Mar 2026 12:26:32 +0000

Commit 542eda1a8329 ("mm/rmap: improve anon_vma_clone(),
unlink_anon_vmas() comments, add asserts") alters the way errors are
handled, but overlooked one important aspect of clean up.

When a VMA encounters an error state in anon_vma_clone() (that is, on
attempted allocation of anon_vma_chain objects), it cleans up partially
established state in cleanup_partial_anon_vmas(), before returning an
error.

However, this occurs prior to anon_vma->num_active_vmas being incremented,
and it also fails to clear the VMA's vma->anon_vma field, which remains in
place.

This is immediately an inconsistent state, because
anon_vma->num_active_vmas is supposed to track the number of VMAs whose
vma->anon_vma field references that anon_vma, and now that count is
off-by-negative-1 for each VMA for which this error state has occurred.

When VMAs are unlinked from this anon_vma, unlink_anon_vmas() will
eventually underflow anon_vma->num_active_vmas, which will trigger a
warning.

This will always eventually happen, as we unlink anon_vma's at process
teardown.

It could also cause maybe_reuse_anon_vma() to incorrectly permit the reuse
of an anon_vma which has active VMAs attached, which will lead to a
persistently invalid state.

The solution is to clear the VMA's anon_vma field when we clean up partial
state, as the fact we are doing so indicates clearly that the VMA is not
correctly integrated into the anon_vma tree and thus this field is
invalid.

Link: https://lkml.kernel.org/r/20260318122632.63404-1-ljs@kernel.org
Fixes: 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reported-by: Sasha Levin <sashal@kernel.org>
Closes: https://lore.kernel.org/linux-mm/20260302151547.2389070-1-sashal@kernel.org/
Reported-by: Jiakai Xu <jiakaipeanut@gmail.com>
Closes: https://lore.kernel.org/linux-mm/CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com/
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Tested-by: Jiakai Xu <jiakaipeanut@gmail.com>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sasha Levin (Microsoft) <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/rmap.c~mm-rmap-clear-vma-anon_vma-on-error
+++ a/mm/rmap.c
@@ -457,6 +457,13 @@ static void cleanup_partial_anon_vmas(st
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
+
+	/*
+	 * The anon_vma assigned to this VMA is no longer valid, as we were not
+	 * able to correctly clone AVC state. Avoid inconsistent anon_vma tree
+	 * state by resetting.
+	 */
+	vma->anon_vma = NULL;
 }
 
 /**
_

Patches currently in -mm which might be from ljs@kernel.org are

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

