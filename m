Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78CA1DB125
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 19:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762542452; cv=none; b=u15vZCqI4ez8cHOWWEvqHshvy97eZoukdVJOtJdnI4luUJyIbbkIhVSFaEHCdbB4I7+KQODICLRyqvFLwaZfl+OiP1KZ5H7F9Hlc3ZbJimosbm7fEOPlRpB+Uqcg3kADv8YB5nqT9cklKzQvm71jZ5CNv2eF+YRU5vGYb+9c8EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762542452; c=relaxed/simple;
	bh=jtHUqpr3nFPcICYhbaBSvZW4+JZz3AODXX+VdjB3PAg=;
	h=Date:To:From:Subject:Message-Id; b=QmHQL9CZdQdl1NWcnu9vDD+NBX7uy/1XwGhuJH/iCkRxktsiQzyHwKkRU8RUauomef7bN/Xm4j7XPAP6mgsA7RLBNofY/Sbw2KBMpwG0M1RMNtO8yx28ML9XZdKj3Xj0RILpHAZ7u4wrhikvJz6lEZMCU58cvLLbBYF/h1oLzkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ChsHbqgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ChsHbqgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC64C4CEF5;
	Fri,  7 Nov 2025 19:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762542452;
	bh=jtHUqpr3nFPcICYhbaBSvZW4+JZz3AODXX+VdjB3PAg=;
	h=Date:To:From:Subject:From;
	b=ChsHbqgfhWXSydO5L2fFjjjkK6sW8d6LBmx/+IOZwV7ix5mKqRh6AVATh9AZAJacQ
	 4ng+lq/pOe69oVcpihdXvg0WG33QENnSI1ZTQXAOpUP/ozCJSBjrW2YMzUaicr2Ras
	 xVNIZWrZJak56wggLtvx+k2eHRUsQbL81x2MmLX4=
Date: Fri, 07 Nov 2025 11:07:31 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch added to mm-new branch
Message-Id: <20251107190732.5FC64C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
has been added to the -mm mm-new branch.  Its filename is
     mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch

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
Subject: mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
Date: Fri, 7 Nov 2025 16:11:47 +0000

This patch adds the ability to atomically set VMA flags with only the mmap
read/VMA read lock held.

As this could be hugely problematic for VMA flags in general given that
all other accesses are non-atomic and serialised by the mmap/VMA locks, we
implement this with a strict allow-list - that is, only designated flags
are allowed to do this.

We make VM_MAYBE_GUARD one of these flags.

Link: https://lkml.kernel.org/r/cda9d4c073d773ef6c2cf2939d66cf80544cff40.1762531708.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/include/linux/mm.h~mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such
+++ a/include/linux/mm.h
@@ -518,6 +518,9 @@ extern unsigned int kobjsize(const void
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+/* These flags can be updated atomically via VMA/mmap read lock. */
+#define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
+
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
 # define VM_ARCH_CLEAR	VM_NONE
@@ -860,6 +863,45 @@ static inline void vm_flags_mod(struct v
 	__vm_flags_mod(vma, set, clear);
 }
 
+static inline bool __vma_flag_atomic_valid(struct vm_area_struct *vma,
+				       int bit)
+{
+	const vm_flags_t mask = BIT(bit);
+
+	/* Only specific flags are permitted */
+	if (WARN_ON_ONCE(!(mask & VM_ATOMIC_SET_ALLOWED)))
+		return false;
+
+	return true;
+}
+
+/*
+ * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
+ * valid flags are allowed to do this.
+ */
+static inline void vma_flag_set_atomic(struct vm_area_struct *vma, int bit)
+{
+	/* mmap read lock/VMA read lock must be held. */
+	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
+		vma_assert_locked(vma);
+
+	if (__vma_flag_atomic_valid(vma, bit))
+		set_bit(bit, &vma->__vm_flags);
+}
+
+/*
+ * Test for VMA flag atomically. Requires no locks. Only specific valid flags
+ * are allowed to do this.
+ *
+ * This is necessarily racey, so callers must ensure that serialisation is
+ * achieved through some other means, or that races are permissible.
+ */
+static inline bool vma_flag_test_atomic(struct vm_area_struct *vma, int bit)
+{
+	if (__vma_flag_atomic_valid(vma, bit))
+		return test_bit(bit, &vma->__vm_flags);
+}
+
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
 {
 	vma->vm_ops = NULL;
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
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-uses-of-is_swap_pte-when-leafent_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-leafent_from_pmd.patch
mm-replace-pmd_to_swp_entry-with-leafent_from_pmd-fix.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead.patch
mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead-fix.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-leafent_from_pte.patch
mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-implement-sticky-vma-flags.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch

