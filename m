Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C511C299A82
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 19:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783970762; cv=none; b=i70j3GPci+7pDzrTmHn0nMbW1X6+cPSZ6Qlh0axx4xV+ftZ8rHZc/+hBvnJHt8ooXkN9++oVOI2cvxYFbwSh9QvqeVIgEgfvqqF9jNQ1XQ3j6jVTOcZ6WunKOuTTKGw0ulhR7VhWRn2i68RQczlVF7A2bwv0krgVvFGN8AiOSUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783970762; c=relaxed/simple;
	bh=mozIYloH9sgU1BWl2GNxCeOWcDOc4fedw6uEOkJ3L3s=;
	h=Date:To:From:Subject:Message-Id; b=ACSR+7Tdlr+nJ/YMWChax7VA+0EWYCv62WR7xB6m/Em2GFSudCDCQFb3g1cTFINzA+RqX1Xi8MbRRV4eFJ1rwNHkcJZZXV/v9Mthd26fXAoIx5HUGR6O/F27ULIb+0VhUL/AsJ/JCMxDeWqMQbl6MwuqHCnYSjFRLGHPTvoo6/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sHi7jAt2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sHi7jAt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B281F000E9;
	Mon, 13 Jul 2026 19:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783970760;
	bh=J3zRXFRSMI702norTEdpHAK+DvBncZeIoGUWGJdcsPI=;
	h=Date:To:From:Subject;
	b=sHi7jAt2K6Cct7dRWak8QmhhucH7H/nTItafH6xJ1IP1pBQ92wdA70nzoy5Z1+2os
	 W7jiUGjmvpLqTKULmV/Cuvxo6a+EVNJZ55F1dqY2ZIGz/AYTBSZHBWEwDgHmLp6lrN
	 /Ln1fGsM1Yp5F4JlYlln+UHCqkpOVtZcfn6/U7pQ=
Date: Mon, 13 Jul 2026 12:26:00 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ryan.roberts@arm.com,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-add-try_to_unmap_hugetlb_one.patch added to mm-new branch
Message-Id: <20260713192600.76B281F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: Add try_to_unmap_hugetlb_one
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-add-try_to_unmap_hugetlb_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-add-try_to_unmap_hugetlb_one.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: Add try_to_unmap_hugetlb_one
Date: Mon, 13 Jul 2026 05:00:45 +0000

Simplify try_to_unmap_one() by separating the hugetlb parts into
try_to_unmap_hugetlb_one().

To understand the correctness of the refactoring, the following points
are noted:

1. try_to_unmap() is called for hugetlb folios only when they are
   hwpoisoned.

2. A hugetlb VMA cannot be mlocked.

3. page_vma_mapped_walk() returns at most one hugetlb mapping in a VMA,
   and that mapping points at the head PFN.

4. We won't ever process a softleaf entry that encodes a hugetlb folio;
   hugetlb folios are never swapped out, migration entries will be
   skipped (PVMW_MIGRATION not passed), and device-exclusive does not
   work for hugetlb.

5. The hwpoison entry is constructed from the poisoned folio, just as in
   the pre-refactor code. Any previous uffd-wp state is deliberately not
   preserved for the hwpoison entry.

6. TTU_HWPOISON is always present; for it to not be present, either the
   folio has to be in swapcache, or mapping_can_writeback() is true (see
   unmap_poisoned_folio), none of which is true for hugetlb folios.

7. Hugetlb uses separate counters from normal rss counters, therefore
   update_highwater_rss() need not be called.

While at it:

 - Change VM_BUG_* to VM_WARN_*.

 - Do not declare variables which are only used once.

 - Constify some variables.

 - Add some more VM_WARN_* to assert some invariants.

Except the above 4 points, no functional change intended.

Link: https://lore.kernel.org/20260713050050.1017741-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 
 mm/rmap.c               |  183 ++++++++++++++++++++------------------
 2 files changed, 98 insertions(+), 86 deletions(-)

--- a/include/linux/hugetlb.h~mm-rmap-add-try_to_unmap_hugetlb_one
+++ a/include/linux/hugetlb.h
@@ -1270,6 +1270,7 @@ static inline void hugetlb_count_sub(lon
 }
 
 pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+unsigned long huge_pte_dirty(pte_t pte);
 
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
--- a/mm/rmap.c~mm-rmap-add-try_to_unmap_hugetlb_one
+++ a/mm/rmap.c
@@ -1978,6 +1978,96 @@ static inline unsigned int folio_unmap_p
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+static bool try_to_unmap_hugetlb_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long address, void *arg)
+{
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
+	const unsigned long hsz = huge_page_size(hstate_vma(vma));
+	const enum ttu_flags flags = (enum ttu_flags)(long)arg;
+	struct mm_struct *mm = vma->vm_mm;
+	struct mmu_notifier_range range;
+	bool ret = true;
+	pte_t pteval;
+
+	/*
+	 * The try_to_unmap() is only passed a hugetlb folio in the case
+	 * where the hugetlb folio is poisoned.
+	 */
+	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
+	VM_WARN_ON_ONCE(!(flags & TTU_HWPOISON));
+
+	range.end = vma_address_end(&pvmw);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				address, range.end);
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	mmu_notifier_invalidate_range_start(&range);
+
+	/* There is only a single mapping in a VMA. */
+	if (!page_vma_mapped_walk(&pvmw))
+		goto range_end;
+
+	VM_WARN_ON_ONCE(address != pvmw.address);
+
+	pteval = huge_ptep_get(mm, address, pvmw.pte);
+	VM_WARN_ON_ONCE(!pte_present(pteval));
+	VM_WARN_ON_ONCE(pte_pfn(pteval) != folio_pfn(folio));
+
+	/*
+	 * huge_pmd_unshare may unmap an entire PMD page. There is no way of
+	 * knowing exactly which PMDs may be cached for this mm, so we must
+	 * flush them all. start/end were already adjusted above to cover this
+	 * range.
+	 */
+	flush_cache_range(vma, range.start, range.end);
+
+	/*
+	 * To call huge_pmd_unshare, i_mmap_rwsem must be held in write mode.
+	 * Caller needs to explicitly do this outside rmap routines.
+	 *
+	 * We also must hold hugetlb vma_lock in write mode. Lock order dictates
+	 * acquiring vma_lock BEFORE i_mmap_rwsem. We can only try lock here and
+	 * fail if unsuccessful.
+	 */
+	if (!folio_test_anon(folio)) {
+		struct mmu_gather tlb;
+
+		VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
+		if (!hugetlb_vma_trylock_write(vma)) {
+			ret = false;
+			goto walk_done;
+		}
+
+		tlb_gather_mmu_vma(&tlb, vma);
+		if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
+			hugetlb_vma_unlock_write(vma);
+			huge_pmd_unshare_flush(&tlb, vma);
+			tlb_finish_mmu(&tlb);
+			/*
+			 * The PMD table was unmapped, consequently unmapping
+			 * the folio.
+			 */
+			goto walk_done;
+		}
+		hugetlb_vma_unlock_write(vma);
+		tlb_finish_mmu(&tlb);
+	}
+	pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
+	if (huge_pte_dirty(pteval))
+		folio_mark_dirty(folio);
+
+	pteval = swp_entry_to_pte(make_hwpoison_entry(folio_page(folio, 0)));
+	hugetlb_count_sub(folio_nr_pages(folio), mm);
+	set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
+	hugetlb_remove_rmap(folio);
+	folio_put_refs(folio, 1);
+
+walk_done:
+	page_vma_mapped_walk_done(&pvmw);
+range_end:
+	mmu_notifier_invalidate_range_end(&range);
+	return ret;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -1993,7 +2083,6 @@ static bool try_to_unmap_one(struct foli
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
-	unsigned long hsz = 0;
 	int ptes = 0;
 
 	/*
@@ -2007,8 +2096,6 @@ static bool try_to_unmap_one(struct foli
 
 	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
-	 * For hugetlb, it could be much worse if we need to do pud
-	 * invalidation in the case of pmd sharing.
 	 *
 	 * Note that the folio can not be freed in this function as call of
 	 * try_to_unmap() must hold a reference on the folio.
@@ -2016,17 +2103,6 @@ static bool try_to_unmap_one(struct foli
 	range.end = vma_address_end(&pvmw);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, range.end);
-	if (folio_test_hugetlb(folio)) {
-		/*
-		 * If sharing is possible, start and end will be adjusted
-		 * accordingly.
-		 */
-		adjust_range_if_pmd_sharing_possible(vma, &range.start,
-						     &range.end);
-
-		/* We need the huge page size for set_huge_pte_at() */
-		hsz = huge_page_size(hstate_vma(vma));
-	}
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
@@ -2111,66 +2187,13 @@ static bool try_to_unmap_one(struct foli
 			const softleaf_t entry = softleaf_from_pte(pteval);
 
 			pfn = softleaf_to_pfn(entry);
-			VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-		if (folio_test_hugetlb(folio)) {
-			bool anon = folio_test_anon(folio);
-
-			/*
-			 * The try_to_unmap() is only passed a hugetlb folio
-			 * in the case where the hugetlb folio contains a
-			 * poisoned page.
-			 */
-			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
-			/*
-			 * huge_pmd_unshare may unmap an entire PMD page.
-			 * There is no way of knowing exactly which PMDs may
-			 * be cached for this mm, so we must flush them all.
-			 * start/end were already adjusted above to cover this
-			 * range.
-			 */
-			flush_cache_range(vma, range.start, range.end);
-
-			/*
-			 * To call huge_pmd_unshare, i_mmap_rwsem must be
-			 * held in write mode.  Caller needs to explicitly
-			 * do this outside rmap routines.
-			 *
-			 * We also must hold hugetlb vma_lock in write mode.
-			 * Lock order dictates acquiring vma_lock BEFORE
-			 * i_mmap_rwsem.  We can only try lock here and fail
-			 * if unsuccessful.
-			 */
-			if (!anon) {
-				struct mmu_gather tlb;
-
-				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-				if (!hugetlb_vma_trylock_write(vma))
-					goto walk_abort;
-
-				tlb_gather_mmu_vma(&tlb, vma);
-				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
-					hugetlb_vma_unlock_write(vma);
-					huge_pmd_unshare_flush(&tlb, vma);
-					tlb_finish_mmu(&tlb);
-					/*
-					 * The PMD table was unmapped,
-					 * consequently unmapping the folio.
-					 */
-					goto walk_done;
-				}
-				hugetlb_vma_unlock_write(vma);
-				tlb_finish_mmu(&tlb);
-			}
-			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
-			if (pte_dirty(pteval))
-				folio_mark_dirty(folio);
-		} else if (likely(pte_present(pteval))) {
+		if (likely(pte_present(pteval))) {
 			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
 			end_addr = address + nr_pages * PAGE_SIZE;
 			flush_cache_range(vma, address, end_addr);
@@ -2205,20 +2228,11 @@ static bool try_to_unmap_one(struct foli
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		/*
-		 * With TTU_HWPOISON, we only expect small folios or hugetlb
-		 * folios here for now.
-		 */
+		/* With TTU_HWPOISON, we only expect small folios here. */
 		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
-			if (folio_test_hugetlb(folio)) {
-				hugetlb_count_sub(folio_nr_pages(folio), mm);
-				set_huge_pte_at(mm, address, pvmw.pte, pteval,
-						hsz);
-			} else {
-				dec_mm_counter(mm, mm_counter(folio));
-				set_pte_at(mm, address, pvmw.pte, pteval);
-			}
+			dec_mm_counter(mm, mm_counter(folio));
+			set_pte_at(mm, address, pvmw.pte, pteval);
 		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
 			   !userfaultfd_armed(vma)) {
 			/*
@@ -2346,11 +2360,7 @@ static bool try_to_unmap_one(struct foli
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 discard:
-		if (unlikely(folio_test_hugetlb(folio))) {
-			hugetlb_remove_rmap(folio);
-		} else {
-			folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
-		}
+		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
@@ -2398,7 +2408,8 @@ static int folio_not_mapped(struct folio
 void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 {
 	struct rmap_walk_control rwc = {
-		.rmap_one = try_to_unmap_one,
+		.rmap_one = folio_test_hugetlb(folio) ?
+				try_to_unmap_hugetlb_one : try_to_unmap_one,
 		.arg = (void *)flags,
 		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch
mm-mprotect-drop-sub-from-batching-context.patch
arm64-make-huge_ptep_get-handled-unaligned-addresses.patch
mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-rmap-convert-page-folio-for-hwpoison-checks.patch
mm-rmap-add-try_to_unmap_hugetlb_one.patch
mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch
mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch

