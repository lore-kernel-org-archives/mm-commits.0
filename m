Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490772868A9
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 21:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763157238; cv=none; b=Y05TwsSQCrGeI+DjLrghWxRU0RFaIm+ZCQYPQdtiN314EuSxXEyeWTNrAtYh83fvqd8d4jdLCuyeqgLeNi1uc7cbL/b2WFszZ/IiIX1TV104KRkcBm0QX+iyyECLu6cit5YNBLqFYeq9JllEICBvYbesjJzWVl3BC6yClsuGPPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763157238; c=relaxed/simple;
	bh=lox+fiv7dWmXgKk/Y0ugL99pqQOP+wSmWn4gxckgTCU=;
	h=Date:To:From:Subject:Message-Id; b=uoWyefrebT1p2F/79KtQ4xINDqKpQSjWH8XGfmIIPlzehMGS20RYS6UDT/M7LUZ8/OfUQ6k0ZsxFUbTkX0ahLBm7HNoYNGUfxqNW5otzhPPnJ7nrzW9t5tfICJCJcX67rNgeV1df2dMKAqwMqebqbVg+s72qE3TkVRO5LnP1/KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vRmIhH+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vRmIhH+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A69C4CEF5;
	Fri, 14 Nov 2025 21:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763157238;
	bh=lox+fiv7dWmXgKk/Y0ugL99pqQOP+wSmWn4gxckgTCU=;
	h=Date:To:From:Subject:From;
	b=vRmIhH+D0NtegXTYcW3K5NDNnQ79qLoY+uSBNZf7XL3s19uPIaYl5219O7tM1ppTq
	 A8zabhikBA49yEEVkOZZKNqniWhj+nQqqtADqHBu6nhcMWq9oYuC1a2ohd3CFZ9/fl
	 mYJZY/XceRD/1XxEClBVPSypXqaVDHnu36HlD2PM=
Date: Fri, 14 Nov 2025 13:53:57 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-propagate-vm_softdirty-on-merge.patch added to mm-new branch
Message-Id: <20251114215357.F2A69C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: propagate VM_SOFTDIRTY on merge
has been added to the -mm mm-new branch.  Its filename is
     mm-propagate-vm_softdirty-on-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-propagate-vm_softdirty-on-merge.patch

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
Subject: mm: propagate VM_SOFTDIRTY on merge
Date: Fri, 14 Nov 2025 17:53:18 +0000

Patch series "make VM_SOFTDIRTY a sticky VMA flag".

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.


This patch (of 2):

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.

This is because currently we simply ignore VM_SOFTDIRTY for the purposes
of merge, so one VMA may possess the flag and another not, and whichever
happens to be the target VMA will be the one upon which the merge is
performed which may or may not have VM_SOFTDIRTY set.

Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
which solves this issue.

Additionally update VMA userland tests to propagate changes.

Link: https://lkml.kernel.org/r/cover.1763142412.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |   23 +++++++++++------------
 tools/testing/vma/vma_internal.h |   23 +++++++++++------------
 2 files changed, 22 insertions(+), 24 deletions(-)

--- a/include/linux/mm.h~mm-propagate-vm_softdirty-on-merge
+++ a/include/linux/mm.h
@@ -532,29 +532,28 @@ extern unsigned int kobjsize(const void
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
+ *
  * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
  *                  mapped page tables may contain metadata not described by the
  *                  VMA and thus any merged VMA may also contain this metadata,
  *                  and thus we must make this flag sticky.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
- *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *                which should propagate to all VMAs, but the other does not,
- *                the merge should still proceed with the merge logic applying
- *                sticky flags to the final VMA.
+ * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
+ *             which should propagate to all VMAs, but the other does not,
+ *             the merge should still proceed with the merge logic applying
+ *             sticky flags to the final VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are
--- a/tools/testing/vma/vma_internal.h~mm-propagate-vm_softdirty-on-merge
+++ a/tools/testing/vma/vma_internal.h
@@ -122,29 +122,28 @@ extern unsigned long dac_mmap_min_addr;
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
+ *
  * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
  *                  mapped page tables may contain metadata not described by the
  *                  VMA and thus any merged VMA may also contain this metadata,
  *                  and thus we must make this flag sticky.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
- *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *                which should propagate to all VMAs, but the other does not,
- *                the merge should still proceed with the merge logic applying
- *                sticky flags to the final VMA.
+ * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
+ *             which should propagate to all VMAs, but the other does not,
+ *             the merge should still proceed with the merge logic applying
+ *             sticky flags to the final VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are
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
mm-rename-walk_page_range_mm.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-propagate-vm_softdirty-on-merge.patch
testing-selftests-mm-add-soft-dirty-merge-self-test.patch

