Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EBF31CA4E
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 18:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798825; cv=none; b=H45E1t8y4mUuktEi/8TlkZd+kzudsd4H6ZkflBK4Rg18urDcNpkmwsWDe4w/3y43ZT9S3IXewbVgdIjIYNkynC7TOUbQIb1xgoIHmI2paWEUyarJRSUmm6ChcK6R/ublNoF+W4/DHshY6+z3rzDiggc4uU8kVPM6YsR9RPbKLwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798825; c=relaxed/simple;
	bh=ZWHEquNMzRYGwx+8oaQ7ok7ADcsuxlZq8w9GN2qECKc=;
	h=Date:To:From:Subject:Message-Id; b=BuXDKVIoel61i/3i4oTMVNsIOIxRyn+B6VbXnBpuT9c6Qa1bJjaagNLeufjzeCJ9ZtQeS/ps2aq1GtjmkmiTOdAtSaV3M8cxI6YH4emO+qOeT30gOAte/aG6ILeKyJyuoh1MRBCx5HIBTXCMj3LEVYf+hiHJo+uPN5zf3UYlrVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a6eLRYbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a6eLRYbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59392C4CEFB;
	Mon, 10 Nov 2025 18:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762798825;
	bh=ZWHEquNMzRYGwx+8oaQ7ok7ADcsuxlZq8w9GN2qECKc=;
	h=Date:To:From:Subject:From;
	b=a6eLRYbuI5mF1G22Y7ysKXPA6+L+TcXED8YQalQUHzAwjdgTjOJmg9K+ULW2s9VO4
	 zETHe0q+2kswtIbrotQqfUrQ+mn1U06S7PV29jgQaJlixONreejntmxIvBMVc8JWYk
	 M+mdk7SexNo4DVftGagaet8CY7udOSl9PTfvm5Qo=
Date: Mon, 10 Nov 2025 10:20:24 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix.patch added to mm-new branch
Message-Id: <20251110182025.59392C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix.patch

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
Subject: mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix
Date: Mon, 10 Nov 2025 17:35:11 +0000

make sparse & clang happy

Link: https://lkml.kernel.org/r/b2fb32db-1edc-4420-ae42-96f1efa9b7f9@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix
+++ a/include/linux/mm.h
@@ -886,7 +886,7 @@ static inline void vma_flag_set_atomic(s
 		vma_assert_locked(vma);
 
 	if (__vma_flag_atomic_valid(vma, bit))
-		set_bit(bit, &vma->__vm_flags);
+		set_bit(bit, &ACCESS_PRIVATE(vma, __vm_flags));
 }
 
 /*
@@ -899,7 +899,9 @@ static inline void vma_flag_set_atomic(s
 static inline bool vma_flag_test_atomic(struct vm_area_struct *vma, int bit)
 {
 	if (__vma_flag_atomic_valid(vma, bit))
-		return test_bit(bit, &vma->__vm_flags);
+		return test_bit(bit, &vma->vm_flags);
+
+	return false;
 }
 
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
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
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch

