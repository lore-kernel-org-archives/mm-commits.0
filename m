Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A87813AD18;
	Thu, 25 Jul 2024 20:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721940100; cv=none; b=N8b97WVulNjuNwjLlXyBwQUBGqy2mThPt6TwymKYo1PPZq1sKfdJ+T0emfncfyErhzHw+ERtF0STC7knIVgcM49btY2XgBrUr9ZWpD+9Hexp2PSukQDBTYwiChGNqUhyowHJWPSn4ureCZZCliZfewNU76mzzESSivP570ZOLAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721940100; c=relaxed/simple;
	bh=o1/hhDP+qkQgHteMC2U5IfLcaQOtEYal/PXFvOVqZtI=;
	h=Date:To:From:Subject:Message-Id; b=Bx21y+NUop7YtMGp+1yIT62hDOZrNm6ZF43QxV9yoVDgq1A6Np06WuHS0301GYcRAHjrlwW8PL6eQKqv3xqxQzaHYhhllahQf5oAqooRfTXnA+exqCNF+cjuHUzw2V2bgPvceA3R5B46reSTG7uxTtM4AAqtWeq1JoGSUGn80lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vcoHypMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vcoHypMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3840C32786;
	Thu, 25 Jul 2024 20:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721940099;
	bh=o1/hhDP+qkQgHteMC2U5IfLcaQOtEYal/PXFvOVqZtI=;
	h=Date:To:From:Subject:From;
	b=vcoHypMeiDDt5x4XFMzQ/OU0nT98dsVr+Xt8XIAKClfS/vkC40bC5KrqOFeVO37hn
	 UxTyvhPuoHV9WyPNGwzCiMqDxdH5zbdF+x414iMngxfmJrrcnwzclPZOrR/UWSXrGR
	 EXxzcfU/A9kSgW3tZMOoHTcHYjmE4y0x8T1L6GZI=
Date: Thu, 25 Jul 2024 13:41:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-let-pte_lockptr-consume-a-pte_t-pointer.patch added to mm-hotfixes-unstable branch
Message-Id: <20240725204139.D3840C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: let pte_lockptr() consume a pte_t pointer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-let-pte_lockptr-consume-a-pte_t-pointer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-let-pte_lockptr-consume-a-pte_t-pointer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: let pte_lockptr() consume a pte_t pointer
Date: Thu, 25 Jul 2024 20:39:54 +0200

Patch series "mm/hugetlb: fix hugetlb vs. core-mm PT locking".

Working on another generic page table walker that tries to avoid
special-casing hugetlb, I found a page table locking issue with hugetlb
folios that are not mapped using a single PMD/PUD.

For some hugetlb folio sizes, GUP will take different page table locks
when walking the page tables than hugetlb when modifying the page tables.

I did not actually try reproducing an issue, but looking at
follow_pmd_mask() where we might be rereading a PMD value multiple times
it's rather clear that concurrent modifications are rather unpleasant.

In follow_page_pte() we might be better in that regard -- ptep_get() does
a READ_ONCE() -- but who knows what else could happen concurrently in some
weird corner cases (e.g., hugetlb folio getting unmapped and freed).


This patch (of 2):

pte_lockptr() is the only *_lockptr() function that doesn't consume what
would be expected: it consumes a pmd_t pointer instead of a pte_t pointer.

Let's change that.  The two callers in pgtable-generic.c are easily
adjusted.  Adjust khugepaged.c:retract_page_tables() to simply do a
pte_offset_map_nolock() to obtain the lock, even though we won't actually
be traversing the page table.

This makes the code more similar to the other variants and avoids other
hacks to make the new pte_lockptr() version happy.  pte_lockptr() users
reside now only in pgtable-generic.c.

Maybe, using pte_offset_map_nolock() is the right thing to do because the
PTE table could have been removed in the meantime?  At least it sounds
more future proof if we ever have other means of page table reclaim.

It's not quite clear if holding the PTE table lock is really required:
what if someone else obtains the lock just after we unlock it?  But we'll
leave that as is for now, maybe there are good reasons.

This is a preparation for adapting hugetlb page table locking logic to
take the same locks as core-mm page table walkers would.

Link: https://lkml.kernel.org/r/20240725183955.2268884-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240725183955.2268884-2-david@redhat.com
Fixes: 9cb28da54643 ("mm/gup: handle hugetlb in the generic follow_page_mask code")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    7 ++++---
 mm/khugepaged.c      |   21 +++++++++++++++------
 mm/pgtable-generic.c |    4 ++--
 3 files changed, 21 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~mm-let-pte_lockptr-consume-a-pte_t-pointer
+++ a/include/linux/mm.h
@@ -2915,9 +2915,10 @@ static inline spinlock_t *ptlock_ptr(str
 }
 #endif /* ALLOC_SPLIT_PTLOCKS */
 
-static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
+static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pte_t *pte)
 {
-	return ptlock_ptr(page_ptdesc(pmd_page(*pmd)));
+	/* PTE page tables don't currently exceed a single page. */
+	return ptlock_ptr(virt_to_ptdesc(pte));
 }
 
 static inline bool ptlock_init(struct ptdesc *ptdesc)
@@ -2940,7 +2941,7 @@ static inline bool ptlock_init(struct pt
 /*
  * We use mm->page_table_lock to guard all pagetable pages of the mm.
  */
-static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
+static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pte_t *pte)
 {
 	return &mm->page_table_lock;
 }
--- a/mm/khugepaged.c~mm-let-pte_lockptr-consume-a-pte_t-pointer
+++ a/mm/khugepaged.c
@@ -1697,12 +1697,13 @@ static void retract_page_tables(struct a
 	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		struct mmu_notifier_range range;
+		bool retracted = false;
 		struct mm_struct *mm;
 		unsigned long addr;
 		pmd_t *pmd, pgt_pmd;
 		spinlock_t *pml;
 		spinlock_t *ptl;
-		bool skipped_uffd = false;
+		pte_t *pte;
 
 		/*
 		 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
@@ -1739,9 +1740,17 @@ static void retract_page_tables(struct a
 		mmu_notifier_invalidate_range_start(&range);
 
 		pml = pmd_lock(mm, pmd);
-		ptl = pte_lockptr(mm, pmd);
+
+		/*
+		 * No need to check the PTE table content, but we'll grab the
+		 * PTE table lock while we zap it.
+		 */
+		pte = pte_offset_map_nolock(mm, pmd, addr, &ptl);
+		if (!pte)
+			goto unlock_pmd;
 		if (ptl != pml)
 			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+		pte_unmap(pte);
 
 		/*
 		 * Huge page lock is still held, so normally the page table
@@ -1752,20 +1761,20 @@ static void retract_page_tables(struct a
 		 * repeating the anon_vma check protects from one category,
 		 * and repeating the userfaultfd_wp() check from another.
 		 */
-		if (unlikely(vma->anon_vma || userfaultfd_wp(vma))) {
-			skipped_uffd = true;
-		} else {
+		if (likely(!vma->anon_vma && !userfaultfd_wp(vma))) {
 			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
 			pmdp_get_lockless_sync();
+			retracted = true;
 		}
 
 		if (ptl != pml)
 			spin_unlock(ptl);
+unlock_pmd:
 		spin_unlock(pml);
 
 		mmu_notifier_invalidate_range_end(&range);
 
-		if (!skipped_uffd) {
+		if (retracted) {
 			mm_dec_nr_ptes(mm);
 			page_table_check_pte_clear_range(mm, addr, pgt_pmd);
 			pte_free_defer(mm, pmd_pgtable(pgt_pmd));
--- a/mm/pgtable-generic.c~mm-let-pte_lockptr-consume-a-pte_t-pointer
+++ a/mm/pgtable-generic.c
@@ -313,7 +313,7 @@ pte_t *pte_offset_map_nolock(struct mm_s
 
 	pte = __pte_offset_map(pmd, addr, &pmdval);
 	if (likely(pte))
-		*ptlp = pte_lockptr(mm, &pmdval);
+		*ptlp = pte_lockptr(mm, pte);
 	return pte;
 }
 
@@ -371,7 +371,7 @@ again:
 	pte = __pte_offset_map(pmd, addr, &pmdval);
 	if (unlikely(!pte))
 		return pte;
-	ptl = pte_lockptr(mm, &pmdval);
+	ptl = pte_lockptr(mm, pte);
 	spin_lock(ptl);
 	if (likely(pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
 		*ptlp = ptl;
_

Patches currently in -mm which might be from david@redhat.com are

mm-let-pte_lockptr-consume-a-pte_t-pointer.patch
mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch

