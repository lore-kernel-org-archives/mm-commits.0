Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999E315CD74
	for <mm-commits@vger.kernel.org>; Sat, 21 Jun 2025 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750532726; cv=none; b=exYg6Z0X3w4ir/Fyvn0B0oBe/e8XcpJ/dXYca7L2PW3fQY+UO0tsbAg1Wp3SKED9ZrKpucvnU0Oienxik7vymzaBDxR8CsA7HPD8+G7d8OPTftxePkLyswmeSmunuYnsNWTk6HDJeenGpup6a5cuHuPCL0jtjnwNRvp9HotAnVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750532726; c=relaxed/simple;
	bh=PgbhTGvAHvJyteaDrukFeS3dd+N1HWGlYk8+ki9Vbxc=;
	h=Date:To:From:Subject:Message-Id; b=FEk12AHN4/MuIjGUYTRT8/L4oytx+nsOVdrOp/BGMTbMMejjSBDyc6sE6ssLxoLnwOE1ntRDFOfMzrgbPqXvwKg1yS3W9J4Xtipnxf9V4vgpu281mIe9ubB2KgO1TYh0pAOIa+pEw4pa9hrCKcjHq77Tqw+cHHU8GbS3H/u+N7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lRIe43Fy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lRIe43Fy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AEBC4CEE7;
	Sat, 21 Jun 2025 19:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750532726;
	bh=PgbhTGvAHvJyteaDrukFeS3dd+N1HWGlYk8+ki9Vbxc=;
	h=Date:To:From:Subject:From;
	b=lRIe43FyqkytAxy+zdZlF+B5DU7vj1UsXr4v2L1CrYPz6b9LOwp+Rh3UG3hlHMm5w
	 I99gy5FlT47bKKf+qOaYIBnUKpWICakfa4v7Jrd345N8/i/tnCc8ELonVtxajyVFgx
	 ffZHC5TkWR9bXdt6vv1bny9JNMzvuJjxB9v8CAvo=
Date: Sat, 21 Jun 2025 12:05:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch added to mm-new branch
Message-Id: <20250621190526.35AEBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: eliminate very confusing manipulation of prev VMA
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch

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
Subject: mm/madvise: eliminate very confusing manipulation of prev VMA
Date: Fri, 20 Jun 2025 16:33:05 +0100

The madvise code has for the longest time had very confusing code around
the 'prev' VMA pointer passed around various functions which, in all cases
except madvise_update_vma(), is unused and instead simply updated as soon
as the function is invoked.

To compound the confusion, the prev pointer is also used to indicate to
the caller that the mmap lock has been dropped and that we can therefore
not safely access the end of the current VMA (which might have been
updated by madvise_update_vma()).

Clear up this confusion by not setting prev = vma anywhere except in
madvise_walk_vmas(), update all references to prev which will always be
equal to vma after madvise_vma_behavior() is invoked, and adding a flag to
indicate that the lock has been dropped to make this explicit.

Additionally, drop a redundant BUG_ON() from madvise_collapse(), which is
simply reiterating the BUG_ON(mmap_locked) above it (note that BUG_ON() is
not appropriate here, but we leave existing code as-is).

We finally adjust the madvise_walk_vmas() logic to be a little clearer -
delaying the assignment of the end of the range to the start of the new
range until the last moment and handling the lock being dropped scenario
immediately.

Additionally add some explanatory comments.

Link: https://lkml.kernel.org/r/63d281c5df2e64225ab5b4bda398b45e22818701.1750433500.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    9 +---
 mm/khugepaged.c         |    9 +---
 mm/madvise.c            |   77 +++++++++++++++++++-------------------
 3 files changed, 47 insertions(+), 48 deletions(-)

--- a/include/linux/huge_mm.h~mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma
+++ a/include/linux/huge_mm.h
@@ -433,9 +433,8 @@ change_huge_pud(struct mmu_gather *tlb,
 
 int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
 		     int advice);
-int madvise_collapse(struct vm_area_struct *vma,
-		     struct vm_area_struct **prev,
-		     unsigned long start, unsigned long end);
+int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
+		     unsigned long end, bool *lock_dropped);
 void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
 			   unsigned long end, struct vm_area_struct *next);
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
@@ -596,8 +595,8 @@ static inline int hugepage_madvise(struc
 }
 
 static inline int madvise_collapse(struct vm_area_struct *vma,
-				   struct vm_area_struct **prev,
-				   unsigned long start, unsigned long end)
+				   unsigned long start,
+				   unsigned long end, bool *lock_dropped)
 {
 	return -EINVAL;
 }
--- a/mm/khugepaged.c~mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma
+++ a/mm/khugepaged.c
@@ -2727,8 +2727,8 @@ static int madvise_collapse_errno(enum s
 	}
 }
 
-int madvise_collapse(struct vm_area_struct *vma, struct vm_area_struct **prev,
-		     unsigned long start, unsigned long end)
+int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
+		     unsigned long end, bool *lock_dropped)
 {
 	struct collapse_control *cc;
 	struct mm_struct *mm = vma->vm_mm;
@@ -2739,8 +2739,6 @@ int madvise_collapse(struct vm_area_stru
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	*prev = vma;
-
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
 		return -EINVAL;
 
@@ -2788,7 +2786,7 @@ int madvise_collapse(struct vm_area_stru
 							 &mmap_locked, cc);
 		}
 		if (!mmap_locked)
-			*prev = NULL;  /* Tell caller we dropped mmap_lock */
+			*lock_dropped = true;
 
 handle_result:
 		switch (result) {
@@ -2798,7 +2796,6 @@ handle_result:
 			break;
 		case SCAN_PTE_MAPPED_HUGEPAGE:
 			BUG_ON(mmap_locked);
-			BUG_ON(*prev);
 			mmap_read_lock(mm);
 			result = collapse_pte_mapped_thp(mm, addr, true);
 			mmap_read_unlock(mm);
--- a/mm/madvise.c~mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma
+++ a/mm/madvise.c
@@ -75,7 +75,9 @@ struct madvise_behavior {
 	 */
 	struct madvise_behavior_range range;
 	/* The VMA and VMA preceding it (if applicable) currently targeted. */
-	struct vm_area_struct *prev, *vma;
+	struct vm_area_struct *prev;
+	struct vm_area_struct *vma;
+	bool lock_dropped;
 };
 
 #ifdef CONFIG_ANON_VMA_NAME
@@ -188,10 +190,8 @@ static int madvise_update_vma(vm_flags_t
 	struct anon_vma_name *anon_name = madv_behavior->anon_name;
 	VMA_ITERATOR(vmi, madv_behavior->mm, range->start);
 
-	if (new_flags == vma->vm_flags && anon_vma_name_eq(anon_vma_name(vma), anon_name)) {
-		madv_behavior->prev = vma;
+	if (new_flags == vma->vm_flags && anon_vma_name_eq(anon_vma_name(vma), anon_name))
 		return 0;
-	}
 
 	vma = vma_modify_flags_name(&vmi, madv_behavior->prev, vma,
 			range->start, range->end, new_flags, anon_name);
@@ -199,7 +199,6 @@ static int madvise_update_vma(vm_flags_t
 		return PTR_ERR(vma);
 
 	madv_behavior->vma = vma;
-	madv_behavior->prev = vma;
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
@@ -301,6 +300,12 @@ static void shmem_swapin_range(struct vm
 }
 #endif		/* CONFIG_SWAP */
 
+static void mark_mmap_lock_dropped(struct madvise_behavior *madv_behavior)
+{
+	VM_WARN_ON_ONCE(madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK);
+	madv_behavior->lock_dropped = true;
+}
+
 /*
  * Schedule all required I/O operations.  Do not wait for completion.
  */
@@ -313,7 +318,6 @@ static long madvise_willneed(struct madv
 	unsigned long end = madv_behavior->range.end;
 	loff_t offset;
 
-	madv_behavior->prev = vma;
 #ifdef CONFIG_SWAP
 	if (!file) {
 		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
@@ -342,7 +346,7 @@ static long madvise_willneed(struct madv
 	 * vma's reference to the file) can go away as soon as we drop
 	 * mmap_lock.
 	 */
-	madv_behavior->prev = NULL;	/* tell sys_madvise we drop mmap_lock */
+	mark_mmap_lock_dropped(madv_behavior);
 	get_file(file);
 	offset = (loff_t)(start - vma->vm_start)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
@@ -633,7 +637,6 @@ static long madvise_cold(struct madvise_
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct mmu_gather tlb;
 
-	madv_behavior->prev = vma;
 	if (!can_madv_lru_vma(vma))
 		return -EINVAL;
 
@@ -665,7 +668,6 @@ static long madvise_pageout(struct madvi
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma = madv_behavior->vma;
 
-	madv_behavior->prev = vma;
 	if (!can_madv_lru_vma(vma))
 		return -EINVAL;
 
@@ -954,7 +956,6 @@ static long madvise_dontneed_free(struct
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	int behavior = madv_behavior->behavior;
 
-	madv_behavior->prev = madv_behavior->vma;
 	if (!madvise_dontneed_free_valid_vma(madv_behavior))
 		return -EINVAL;
 
@@ -964,8 +965,7 @@ static long madvise_dontneed_free(struct
 	if (!userfaultfd_remove(madv_behavior->vma, range->start, range->end)) {
 		struct vm_area_struct *vma;
 
-		madv_behavior->prev = NULL; /* mmap_lock has been dropped, prev is stale */
-
+		mark_mmap_lock_dropped(madv_behavior);
 		mmap_read_lock(mm);
 		madv_behavior->vma = vma = vma_lookup(mm, range->start);
 		if (!vma)
@@ -1064,7 +1064,7 @@ static long madvise_remove(struct madvis
 	unsigned long start = madv_behavior->range.start;
 	unsigned long end = madv_behavior->range.end;
 
-	madv_behavior->prev = NULL; /* tell sys_madvise we drop mmap_lock */
+	mark_mmap_lock_dropped(madv_behavior);
 
 	if (vma->vm_flags & VM_LOCKED)
 		return -EINVAL;
@@ -1183,7 +1183,6 @@ static long madvise_guard_install(struct
 	long err;
 	int i;
 
-	madv_behavior->prev = vma;
 	if (!is_valid_guard_vma(vma, /* allow_locked = */false))
 		return -EINVAL;
 
@@ -1293,7 +1292,6 @@ static long madvise_guard_remove(struct
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_behavior_range *range = &madv_behavior->range;
 
-	madv_behavior->prev = vma;
 	/*
 	 * We're ok with removing guards in mlock()'d ranges, as this is a
 	 * non-destructive action.
@@ -1336,8 +1334,8 @@ static int madvise_vma_behavior(struct m
 	case MADV_DONTNEED_LOCKED:
 		return madvise_dontneed_free(madv_behavior);
 	case MADV_COLLAPSE:
-		return madvise_collapse(vma, &madv_behavior->prev,
-					range->start, range->end);
+		return madvise_collapse(vma, range->start, range->end,
+			&madv_behavior->lock_dropped);
 	case MADV_GUARD_INSTALL:
 		return madvise_guard_install(madv_behavior);
 	case MADV_GUARD_REMOVE:
@@ -1589,7 +1587,6 @@ static bool try_vma_read_lock(struct mad
 		vma_end_read(vma);
 		goto take_mmap_read_lock;
 	}
-	madv_behavior->prev = vma; /* Not currently required. */
 	madv_behavior->vma = vma;
 	return true;
 
@@ -1617,7 +1614,7 @@ int madvise_walk_vmas(struct madvise_beh
 	unsigned long last_end = range->end;
 	int unmapped_error = 0;
 	int error;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *prev, *vma;
 
 	/*
 	 * If VMA read lock is supported, apply madvise to a single VMA
@@ -1630,24 +1627,23 @@ int madvise_walk_vmas(struct madvise_beh
 		return error;
 	}
 
-	/*
-	 * If the interval [start,end) covers some unmapped address
-	 * ranges, just ignore them, but return -ENOMEM at the end.
-	 * - different from the way of handling in mlock etc.
-	 */
-	vma = find_vma_prev(mm, range->start, &madv_behavior->prev);
+	vma = find_vma_prev(mm, range->start, &prev);
 	if (vma && range->start > vma->vm_start)
-		madv_behavior->prev = vma;
+		prev = vma;
 
 	for (;;) {
-		struct vm_area_struct *prev;
-
 		/* Still start < end. */
 		if (!vma)
 			return -ENOMEM;
 
 		/* Here start < (last_end|vma->vm_end). */
 		if (range->start < vma->vm_start) {
+			/*
+			 * This indicates a gap between VMAs in the input
+			 * range. This does not cause the operation to abort,
+			 * rather we simply return -ENOMEM to indicate that this
+			 * has happened, but carry on.
+			 */
 			unmapped_error = -ENOMEM;
 			range->start = vma->vm_start;
 			if (range->start >= last_end)
@@ -1658,21 +1654,28 @@ int madvise_walk_vmas(struct madvise_beh
 		range->end = min(vma->vm_end, last_end);
 
 		/* Here vma->vm_start <= range->start < range->end <= (last_end|vma->vm_end). */
+		madv_behavior->prev = prev;
 		madv_behavior->vma = vma;
 		error = madvise_vma_behavior(madv_behavior);
 		if (error)
 			return error;
-		prev = madv_behavior->prev;
+		if (madv_behavior->lock_dropped) {
+			/* We dropped the mmap lock, we can't ref the VMA. */
+			prev = NULL;
+			vma = NULL;
+			madv_behavior->lock_dropped = false;
+		} else {
+			prev = vma;
+			vma = madv_behavior->vma;
+		}
 
-		range->start = range->end;
-		if (prev && range->start < prev->vm_end)
-			range->start = prev->vm_end;
-		if (range->start >= last_end)
+		if (vma && range->end < vma->vm_end)
+			range->end = vma->vm_end;
+		if (range->end >= last_end)
 			break;
-		if (prev)
-			vma = find_vma(mm, prev->vm_end);
-		else	/* madvise_remove dropped mmap_lock */
-			vma = find_vma(mm, range->start);
+
+		vma = find_vma(mm, vma ? vma->vm_end : range->end);
+		range->start = range->end;
 	}
 
 	return unmapped_error;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-files-to-mm-page-alloc-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch

