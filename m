Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA1F27B345
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 18:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799975; cv=none; b=OfQC4C8Jq4W2UfEpHKtDzh2Y2j3Jo7gzF7IJuRPyMw8EI9XDZHJ0D1M+iU2ESjGX/VfXLstaOa9lgXE1jsW3fHrrOPmikv86WkZ9ZjOjTPU6BYhZy4PzmI3N8ExMH1AaTuGk5SI6RIEncdGHZWTele0RGe48ZmvvdNnkE/5VyhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799975; c=relaxed/simple;
	bh=tbRUScvHNTopValTZGLp0I/dNYzj22Y1Zu3TPyBZoxE=;
	h=Date:To:From:Subject:Message-Id; b=WDkgV7L6vENZc2QoT17RDSg0rnt8dbtGj5ctffAJnhab+BRjK/UMA4LfeRvk1u61muxIlp4anAYW5atnIgdPREviYeyJHToi+KKTpBAp3jRyJvIjLwLOKxRE5UbFUSRRt0clzm5JoBZDPpWOBH/hZl+BHv97KHc47nmWiDNRZBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tj87QlCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tj87QlCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62675C116D0;
	Mon, 10 Nov 2025 18:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762799974;
	bh=tbRUScvHNTopValTZGLp0I/dNYzj22Y1Zu3TPyBZoxE=;
	h=Date:To:From:Subject:From;
	b=Tj87QlCN9cmrIGBgCLzef+5DJ2mfcAf97mWO8/yNIEhgcRB9aEejyTMjGm6/hH5fO
	 YUl2tVADFE4pSXI740nbzywI/aj3k3ZG1FQZTvCC0nTS7wgq5Symrcf5NsaVp8nQXi
	 9R/uraLIp1d1rat3FuU6eX9UXoZcLHMwLbRQMb8Y=
Date: Mon, 10 Nov 2025 10:39:33 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix.patch added to mm-new branch
Message-Id: <20251110183934.62675C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix
Date: Mon, 10 Nov 2025 17:41:15 +0000

trivial comment fixup

Link: https://lkml.kernel.org/r/0de18722-d638-48b5-8649-7b621f6f7648@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix
+++ a/mm/khugepaged.c
@@ -1806,9 +1806,8 @@ static void retract_page_tables(struct a
 		 * userfaultfd_wp() vmas.  But since the mmap_lock is not held,
 		 * it is still possible for a racing userfaultfd_ioctl() or
 		 * madvise() to have inserted ptes or markers.  Now that we hold
-		 * ptlock, repeating the anon_vma check protects from one
-		 * category, and repeating the userfaultfd_wp() check from
-		 * another.
+		* ptlock, repeating the retractable checks protects us from
+		* races against the prior checks.
 		 */
 		if (likely(file_backed_vma_is_retractable(vma))) {
 			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-vma-remove-unused-function-make-internal-functions-static.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-introduce-io_remap_pfn_range_.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-vma-small-vma-lock-cleanups.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch
mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix.patch
mm-implement-sticky-vma-flags.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch

