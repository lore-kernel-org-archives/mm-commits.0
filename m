Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCA730BBBF
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 02:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783562830; cv=none; b=IASKrhNh/WLcfnWWm47seHn9zJliEEuJHCxsysoI0rq6sanoBLXyW8gl3o/M+424swWdnUFVTbu6OpAY2EOZ+UabV1QqfECg4biPkFHBswl3v+vNVQVpNBoqWOMeXV5a2ZeT4ptuerX01VqNEtpPxV3X5+mz1Ih9QitS9dmJph8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783562830; c=relaxed/simple;
	bh=48OenhGSoRjKimOfdvt2PLbd+M96yp2gKVBlRqEpThI=;
	h=Date:To:From:Subject:Message-Id; b=RjJElbPci5xHzzGNxohkYA+4a1dICU4IyAuDsTM0cnh/04mEDOaKy9DKg+HSaRVnUuybrjRBG7EnQDqms4/q4xg8qOEm6rCiVuxkH8F/VGBiWlR5122LvLDAv02ceiD91a5Lt4drhI3fdbuxqExcHqv7k3YTUusiBJ9e1KfJVTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nauko8ia; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nauko8ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41021F000E9;
	Thu,  9 Jul 2026 02:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783562828;
	bh=f8G/xZ2Y5uLIHlZ078PZVnqZHon/p4UrwlhatvJbIzI=;
	h=Date:To:From:Subject;
	b=nauko8iaA7/TLQmzZnaZfP5/NpAWHmAw6kufvNanTgwOQs/PPuR+ZYzOacICrSWpa
	 8RDf5zIH3F2UV8fFPxBwYkdnLU9hBH95WK/vIeQBX8AmrYHObEPud0uoZWTeLe+jF1
	 c7aHCdcdN60QHUvpDqQgSpoIF8NDxLU/XbvnjcfE=
Date: Wed, 08 Jul 2026 19:07:08 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch added to mm-new branch
Message-Id: <20260709020708.D41021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
has been added to the -mm mm-new branch.  Its filename is
     mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Date: Wed, 8 Jul 2026 12:14:09 +0100

Three mm paths outside the fault handler gate on the uffd PTE bit today:
khugepaged (skip collapse on ranges carrying markers), rmap (cap unmap
batching), and GUP (force a fault through gup_can_follow_protnone). 
Extend each to treat VM_UFFD_RWP the same as VM_UFFD_WP; otherwise per-PTE
RWP state is silently destroyed or bypassed.

khugepaged: try_collapse_pte_mapped_thp() and
file_backed_vma_is_retractable() already refuse to collapse or retract
page tables on ranges carrying the uffd PTE bit.  Broaden the VMA
predicate from userfaultfd_wp() to userfaultfd_protected() so VM_UFFD_RWP
ranges get the same protection.  hpage_collapse_scan_pmd() needs no change
— its existing pte_uffd() check already catches an RWP PTE because it
carries the uffd bit.

rmap: folio_unmap_pte_batch() caps batching at 1 for VM_UFFD_RWP so the
restore path handles each PTE with its own marker.

GUP: gup_can_follow_protnone() forces a fault on VM_UFFD_RWP VMAs
regardless of FOLL_HONOR_NUMA_FAULT.  RWP uses protnone as an
access-tracking marker, not for NUMA hinting, so any GUP — read or write
— must go through the userfaultfd fault path.

Link: https://lore.kernel.org/20260708111417.173443-9-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: James Houghton <jthoughton@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   16 +++++++++++++++-
 mm/khugepaged.c    |   18 +++++++++++-------
 mm/rmap.c          |    2 +-
 3 files changed, 27 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup
+++ a/include/linux/mm.h
@@ -4670,12 +4670,26 @@ static inline int vm_fault_to_errno(vm_f
 
 /*
  * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
- * a (NUMA hinting) fault is required.
+ * a (NUMA hinting or userfaultfd RWP) fault is required.
  */
 static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
 					   unsigned int flags)
 {
 	/*
+	 * VM_UFFD_RWP uses protnone as an access-tracking marker, not for
+	 * NUMA hinting. GUP must always take a fault so the access is
+	 * delivered to userfaultfd, regardless of FOLL_HONOR_NUMA_FAULT.
+	 *
+	 * Only do so while the VMA is accessible. If it has been made
+	 * inaccessible (e.g. mprotect(PROT_NONE)), fall through to the guard
+	 * below: forcing a fault there would loop, as handle_mm_fault() makes
+	 * no progress on protnone in an inaccessible VMA, and the access is
+	 * denied regardless of RWP anyway.
+	 */
+	if (vma_test_single_mask(vma, VMA_UFFD_RWP) && vma_is_accessible(vma))
+		return false;
+
+	/*
 	 * If callers don't want to honor NUMA hinting faults, no need to
 	 * determine if we would actually have to trigger a NUMA hinting fault.
 	 */
--- a/mm/khugepaged.c~mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup
+++ a/mm/khugepaged.c
@@ -1893,8 +1893,11 @@ static enum scan_result try_collapse_pte
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
-	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
-	if (userfaultfd_wp(vma))
+	/*
+	 * Keep pmd pgtable while the uffd bit is in use; see comment in
+	 * retract_page_tables().
+	 */
+	if (userfaultfd_protected(vma))
 		return SCAN_PTE_UFFD;
 
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
@@ -2107,13 +2110,14 @@ static bool file_backed_vma_is_retractab
 		return false;
 
 	/*
-	 * When a vma is registered with uffd-wp, we cannot recycle
+	 * When a vma is registered with uffd-wp or RWP, we cannot recycle
 	 * the page table because there may be pte markers installed.
-	 * Other vmas can still have the same file mapped hugely, but
-	 * skip this one: it will always be mapped in small page size
-	 * for uffd-wp registered ranges.
+	 * VM_UFFD_RWP ranges similarly rely on per-PTE uffd state
+	 * and cannot be recycled to a shared PMD. Other vmas can still
+	 * have the same file mapped hugely, but skip this one: it will
+	 * always be mapped in small page size for these registrations.
 	 */
-	if (userfaultfd_wp(vma))
+	if (userfaultfd_protected(vma))
 		return false;
 
 	/*
--- a/mm/rmap.c~mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup
+++ a/mm/rmap.c
@@ -1965,7 +1965,7 @@ static inline unsigned int folio_unmap_p
 	if (pte_unused(pte))
 		return 1;
 
-	if (userfaultfd_wp(vma))
+	if (userfaultfd_protected(vma))
 		return 1;
 
 	/*
_

Patches currently in -mm which might be from kas@kernel.org are

mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch
fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch
mm-decouple-protnone-helpers-from-config_numa_balancing.patch
mm-rename-uffd-wp-pte-bit-macros-to-uffd.patch
mm-rename-uffd-wp-pte-accessors-to-uffd.patch
userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api.patch
mm-add-vm_uffd_rwp-vma-flag.patch
mm-add-mm_cp_uffd_rwp-change_protection-flag.patch
mm-preserve-rwp-marker-across-pte-rewrites.patch
mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch
userfaultfd-add-uffdio_register_mode_rwp-and-uffdio_rwprotect-plumbing.patch
mm-userfaultfd-add-rwp-fault-delivery-and-expose-uffdio_register_mode_rwp.patch
mm-pagemap-add-page_is_accessed-for-rwp-tracking.patch
userfaultfd-add-uffd_feature_rwp_async-for-async-fault-resolution.patch
userfaultfd-add-uffdio_set_mode-for-runtime-sync-async-toggle.patch
selftests-mm-add-userfaultfd-rwp-tests.patch
documentation-userfaultfd-document-rwp-working-set-tracking.patch

