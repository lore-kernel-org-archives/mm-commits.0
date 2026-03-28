Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47446239E80
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 17:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774717226; cv=none; b=CBlPJD//7R6TMvjY0gTrneAFAXH9JT/8cgkD4NC5B6CUx5+10AuBIfcfWEWTMMCcseiYPPvlSNz5XQzJ4RKkX8M4qud3TeFcr1PSBiGJ5GUYfaELn1fjhAzdLOH7Mv8hr3JLlAvo37zod15O4QqneU0Of7HDRAm6uypFTk56Kw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774717226; c=relaxed/simple;
	bh=LYPrt38NH6F8rkzLDnRi70SM03dHV6QMBjVcgOOXrPQ=;
	h=Date:To:From:Subject:Message-Id; b=qDkNYC68c31L8ozqVW2IY6kjIWgmktDPTgsudeED8GZSyUsRcYZ8gJUdgbDpjd35NJ+M9x6p+94xfUfQ23fA/fG1aUb7KXcWff/DyBSM72msVo7wAasbaEaT2HRBv+q+ssz1kOighCHuwdGsld+bCS1QTgUm6+ru5LLTI7kRlns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vh74tdoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vh74tdoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE9AC4CEF7;
	Sat, 28 Mar 2026 17:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774717225;
	bh=LYPrt38NH6F8rkzLDnRi70SM03dHV6QMBjVcgOOXrPQ=;
	h=Date:To:From:Subject:From;
	b=Vh74tdoPA1S0qIBKMPonktz0XZPzSoFmKnZhWy2XNcNGrjiUaRm/G7yx+CoVFfUBe
	 mxbTcETZbmSEUwvObK4xwz2WMJQsYwbXqcttAsmryHScit2panhvSXxj5yLW3jkNx8
	 sF4yO9NBSIf/AHCV+UrlTwKYal1Vydy97RYJY0Xw=
Date: Sat, 28 Mar 2026 10:00:25 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd-fix.patch removed from -mm tree
Message-Id: <20260328170025.CFE9AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd-fix
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd-fix.patch

This patch was dropped because it was folded into mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd.patch

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd-fix
Date: Mon, 23 Mar 2026 11:22:32 +0000

avoid bisection hazard

Link: https://lkml.kernel.org/r/d0cc6161-77a4-42ba-a411-96c23c78df1b@lucifer.local
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd-fix
+++ a/mm/huge_memory.c
@@ -2481,7 +2481,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present,
 				   &has_deposit);
 	else if (is_huge_zero_pmd(orig_pmd))
-		has_deposit = !vma_is_dax(vma);
+		has_deposit = has_deposit || !vma_is_dax(vma);
 
 	if (has_deposit)
 		zap_deposited_table(mm, pmd);
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
mm-huge_memory-add-and-use-has_deposited_pgtable.patch
mm-huge_memory-add-and-use-has_deposited_pgtable-fix.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch

