Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F5A3A5437
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 21:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774560575; cv=none; b=IDscw5UOpV4+34NEHK3WbStINHGy9StBuGWq2z6gLOY+mnQQrO4ZaM7RPsdXpsyNXHJ5B/tu7PahMPIzaPAB9eIPv5LM0lHUNxBAwOrN5viXqYx0sZ6SrgBZ0/3bj8svcvGDBgfZAad28Rm7Gqmx0zwl8qnwC+I08aVbZmAnhpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774560575; c=relaxed/simple;
	bh=5E5UGJ34th6jX4uMtGeEUKwv8Pf8RrLLZCE8XKrmolo=;
	h=Date:To:From:Subject:Message-Id; b=S5ctjc1RCBSJJ5dZCEbPGwikASBIZKikJU+YFJzYOIgZZjVKtcadhT3SSyhM9Xqgb15zRoY7bUKiYs1DnzaHxRe2q6FlAc9CxW3QpimGW9D19ZqV/Nk/a79bEjfAooeMV2jqNCXeqYYfiWxD51SCst6qbRqelTndsLiaMHfYA18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PEN+B/R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PEN+B/R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A49FC19423;
	Thu, 26 Mar 2026 21:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774560575;
	bh=5E5UGJ34th6jX4uMtGeEUKwv8Pf8RrLLZCE8XKrmolo=;
	h=Date:To:From:Subject:From;
	b=PEN+B/R34/bMOoCG6CZ8hYftXgNdXcYqWYDbDUBdSrURx6gYocb2cIeKfyW6T4kcZ
	 pd9hOgUTwlNQq2z2GNXbFKLPt2/DxCqEsE2q1l4VkZOgTVLS3uMCEO0+IeX1Bht3/Z
	 WZwXeXBd/W9ZZ1MEH+zxwj6O6a0CoyCRXr6MlGgo=
Date: Thu, 26 Mar 2026 14:29:35 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,kasong@tencent.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-mglru-entry-to-reflect-current-status.patch added to mm-unstable branch
Message-Id: <20260326212935.8A49FC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update MGLRU entry to reflect current status
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-update-mglru-entry-to-reflect-current-status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-mglru-entry-to-reflect-current-status.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: MAINTAINERS: update MGLRU entry to reflect current status
Date: Thu, 26 Mar 2026 18:56:29 +0000

We are moving to a far more proactive model of maintainership within mm
and thus put a great deal of emphasis on sub-maintainers being active
within the community both in terms of code contributions and review.

The MGLRU has not had much activity since being added to the kernel and
the current maintainers who kindly stepped up have unfortunately not been
able to contribute a great deal to it for over a year, nor engage all that
heavily in review.

As a result, and within no negative connotations implied whatsoever, it
seems appropriate to downgrade the current maintainers to reviewers.

At this time nobody is quite exercising the maintainer role in this area
of the kernel, but there is encouraging activity from a number of people
who are trusted elsewhere in the kernel, and who have contributed relevant
work or review.

Therefore add further reviewers, and at this stage - to reflect the
reality on the ground - we will not have any sub-maintainers listed at
all.

Each of the files listed are shared with other sections in MAINTAINERS, so
this doesn't reduce sub-maintainer coverage.

Link: https://lkml.kernel.org/r/20260326185629.355476-1-ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-update-mglru-entry-to-reflect-current-status
+++ a/MAINTAINERS
@@ -16757,8 +16757,12 @@ F:	mm/migrate_device.c
 
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Axel Rasmussen <axelrasmussen@google.com>
-M:	Yuanchu Xie <yuanchu@google.com>
+R:	Kairui Song <kasong@tencent.com>
+R:	Qi Zheng <qi.zheng@linux.dev>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
+R:	Barry Song <baohua@kernel.org>
+R:	Axel Rasmussen <axelrasmussen@google.com>
+R:	Yuanchu Xie <yuanchu@google.com>
 R:	Wei Xu <weixugc@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
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

