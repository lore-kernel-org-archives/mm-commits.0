Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979BD2417E0
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 23:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760052061; cv=none; b=buhT1mKaSqo6NLLWpjirl4NnR9xjEI6bMibCnzqA0a/73zSqzH++G/ZhEEMyLeExHLVXQQ4/1MwB/TWVad6tEYJhIyeiUGzuqShczS+TN78vcQfgHh+dNaCmeD9aB5McGlZeE1PcICP/du5vZdYmRxVmuwrCzTLCuFL25aOHzZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760052061; c=relaxed/simple;
	bh=BqRFqyuVGJfj6oby4Ni3/k8iDC2Dz3tZswAfuXGCHqI=;
	h=Date:To:From:Subject:Message-Id; b=OI0IAeGVhEYFkOuKe0vJ3YqypKoOizBJXBxxpMCtQXkQveTqLjipnHSyxh/eXMTX2vkSTVOZBmOy+N9hHJNlhc8WgwMqIyiX9rP1lwDu4kUvR4qWduzLCkUJoS5ErzhzbIYsw3aRLepuLcj0djEoJVdelKoYtwWBrYQhHrM3ifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eZyuDbN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eZyuDbN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25994C4CEE7;
	Thu,  9 Oct 2025 23:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760052061;
	bh=BqRFqyuVGJfj6oby4Ni3/k8iDC2Dz3tZswAfuXGCHqI=;
	h=Date:To:From:Subject:From;
	b=eZyuDbN28/a7qN27MXITh6zVqY3YQ+zkuhxBMc7dIm6uWVsKcd1rpiQOXAwO72AQQ
	 J1tQl3J3+ksLPCMYvyaGtrArHcdpSTaMaq5akNKrFYE3LHjQ8ABtPS9BAY5jSPKxpp
	 RVlIoon120F9mOhqoAFvUiRJ5bIERCvYBtBu4USw=
Date: Thu, 09 Oct 2025 16:21:00 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,peterx@redhat.com,ngeoffray@google.com,lorenzo.stoakes@oracle.com,kaleshsingh@google.com,jannh@google.com,harry.yoo@oracle.com,david@redhat.com,baohua@kernel.org,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-dont-lock-anon_vma-when-performing-uffdio_move.patch added to mm-new branch
Message-Id: <20251009232101.25994C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: don't lock anon_vma when performing UFFDIO_MOVE
has been added to the -mm mm-new branch.  Its filename is
     mm-userfaultfd-dont-lock-anon_vma-when-performing-uffdio_move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-dont-lock-anon_vma-when-performing-uffdio_move.patch

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
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: mm/userfaultfd: don't lock anon_vma when performing UFFDIO_MOVE
Date: Tue, 23 Sep 2025 00:10:19 -0700

Now that rmap_walk() is guaranteed to be called with the folio lock held,
we can stop serializing on the src VMA anon_vma lock when moving an
exclusive folio from a src VMA to a dst VMA in UFFDIO_MOVE ioctl.

When moving a folio, we modify folio->mapping through
folio_move_anon_rmap() and adjust folio->index accordingly.  Doing that
while we could have concurrent RMAP walks would be dangerous.  Therefore,
to avoid that, we had to acquire anon_vma of src VMA in write-mode.  That
meant that when multiple threads called UFFDIO_MOVE concurrently on
distinct pages of the same src VMA, they would serialize on it, hurting
scalability.

In addition to avoiding the scalability bottleneck, this patch also
simplifies the complicated lock dance that UFFDIO_MOVE has to go through
between RCU, folio-lock, ptl, and anon_vma.

folio_move_anon_rmap() already enforces that the folio is locked.  So when
we have the folio locked we can no longer race with concurrent rmap_walk()
as used by folio_referenced() and others who call it on unlocked non-KSM
anon folios, and therefore the anon_vma lock is no longer required.

Note that this handling is now the same as for other
folio_move_anon_rmap() users that also do not hold the anon_vma lock --
namely COW reuse handling (do_wp_page()->wp_can_reuse_anon_folio(),
do_huge_pmd_wp_page(), and hugetlb_wp()).  These users never required the
anon_vma lock as they are only moving the anon VMA closer to the anon_vma
leaf of the VMA, for example, from an anon_vma root to a leaf of that
root.  rmap walks were always able to tolerate that scenario.

Link: https://lkml.kernel.org/r/20250923071019.775806-3-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   22 ---------------
 mm/userfaultfd.c |   62 +++++++--------------------------------------
 2 files changed, 12 insertions(+), 72 deletions(-)

--- a/mm/huge_memory.c~mm-userfaultfd-dont-lock-anon_vma-when-performing-uffdio_move
+++ a/mm/huge_memory.c
@@ -2700,7 +2700,6 @@ int move_pages_huge_pmd(struct mm_struct
 	pmd_t _dst_pmd, src_pmdval;
 	struct page *src_page;
 	struct folio *src_folio;
-	struct anon_vma *src_anon_vma;
 	spinlock_t *src_ptl, *dst_ptl;
 	pgtable_t src_pgtable;
 	struct mmu_notifier_range range;
@@ -2749,23 +2748,9 @@ int move_pages_huge_pmd(struct mm_struct
 				src_addr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
-	if (src_folio) {
+	if (src_folio)
 		folio_lock(src_folio);
 
-		/*
-		 * split_huge_page walks the anon_vma chain without the page
-		 * lock. Serialize against it with the anon_vma lock, the page
-		 * lock is not enough.
-		 */
-		src_anon_vma = folio_get_anon_vma(src_folio);
-		if (!src_anon_vma) {
-			err = -EAGAIN;
-			goto unlock_folio;
-		}
-		anon_vma_lock_write(src_anon_vma);
-	} else
-		src_anon_vma = NULL;
-
 	dst_ptl = pmd_lockptr(mm, dst_pmd);
 	double_pt_lock(src_ptl, dst_ptl);
 	if (unlikely(!pmd_same(*src_pmd, src_pmdval) ||
@@ -2810,11 +2795,6 @@ int move_pages_huge_pmd(struct mm_struct
 	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
 unlock_ptls:
 	double_pt_unlock(src_ptl, dst_ptl);
-	if (src_anon_vma) {
-		anon_vma_unlock_write(src_anon_vma);
-		put_anon_vma(src_anon_vma);
-	}
-unlock_folio:
 	/* unblock rmap walks */
 	if (src_folio)
 		folio_unlock(src_folio);
--- a/mm/userfaultfd.c~mm-userfaultfd-dont-lock-anon_vma-when-performing-uffdio_move
+++ a/mm/userfaultfd.c
@@ -1035,8 +1035,7 @@ static inline bool is_pte_pages_stable(p
  */
 static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
 						 unsigned long src_addr,
-						 pte_t *src_pte, pte_t *dst_pte,
-						 struct anon_vma *src_anon_vma)
+						 pte_t *src_pte, pte_t *dst_pte)
 {
 	pte_t orig_dst_pte, orig_src_pte;
 	struct folio *folio;
@@ -1052,8 +1051,7 @@ static struct folio *check_ptes_for_batc
 	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
 	if (!folio || !folio_trylock(folio))
 		return NULL;
-	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) ||
-	    folio_anon_vma(folio) != src_anon_vma) {
+	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)) {
 		folio_unlock(folio);
 		return NULL;
 	}
@@ -1061,9 +1059,8 @@ static struct folio *check_ptes_for_batc
 }
 
 /*
- * Moves src folios to dst in a batch as long as they share the same
- * anon_vma as the first folio, are not large, and can successfully
- * take the lock via folio_trylock().
+ * Moves src folios to dst in a batch as long as they are not large, and can
+ * successfully take the lock via folio_trylock().
  */
 static long move_present_ptes(struct mm_struct *mm,
 			      struct vm_area_struct *dst_vma,
@@ -1073,8 +1070,7 @@ static long move_present_ptes(struct mm_
 			      pte_t orig_dst_pte, pte_t orig_src_pte,
 			      pmd_t *dst_pmd, pmd_t dst_pmdval,
 			      spinlock_t *dst_ptl, spinlock_t *src_ptl,
-			      struct folio **first_src_folio, unsigned long len,
-			      struct anon_vma *src_anon_vma)
+			      struct folio **first_src_folio, unsigned long len)
 {
 	int err = 0;
 	struct folio *src_folio = *first_src_folio;
@@ -1132,8 +1128,8 @@ static long move_present_ptes(struct mm_
 		src_pte++;
 
 		folio_unlock(src_folio);
-		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte,
-							dst_pte, src_anon_vma);
+		src_folio = check_ptes_for_batched_move(src_vma, src_addr,
+							src_pte, dst_pte);
 		if (!src_folio)
 			break;
 	}
@@ -1263,7 +1259,6 @@ static long move_pages_ptes(struct mm_st
 	pmd_t dummy_pmdval;
 	pmd_t dst_pmdval;
 	struct folio *src_folio = NULL;
-	struct anon_vma *src_anon_vma = NULL;
 	struct mmu_notifier_range range;
 	long ret = 0;
 
@@ -1347,9 +1342,9 @@ retry:
 		}
 
 		/*
-		 * Pin and lock both source folio and anon_vma. Since we are in
-		 * RCU read section, we can't block, so on contention have to
-		 * unmap the ptes, obtain the lock and retry.
+		 * Pin and lock source folio. Since we are in RCU read section,
+		 * we can't block, so on contention have to unmap the ptes,
+		 * obtain the lock and retry.
 		 */
 		if (!src_folio) {
 			struct folio *folio;
@@ -1423,33 +1418,11 @@ retry:
 			goto retry;
 		}
 
-		if (!src_anon_vma) {
-			/*
-			 * folio_referenced walks the anon_vma chain
-			 * without the folio lock. Serialize against it with
-			 * the anon_vma lock, the folio lock is not enough.
-			 */
-			src_anon_vma = folio_get_anon_vma(src_folio);
-			if (!src_anon_vma) {
-				/* page was unmapped from under us */
-				ret = -EAGAIN;
-				goto out;
-			}
-			if (!anon_vma_trylock_write(src_anon_vma)) {
-				pte_unmap(src_pte);
-				pte_unmap(dst_pte);
-				src_pte = dst_pte = NULL;
-				/* now we can block and wait */
-				anon_vma_lock_write(src_anon_vma);
-				goto retry;
-			}
-		}
-
 		ret = move_present_ptes(mm, dst_vma, src_vma,
 					dst_addr, src_addr, dst_pte, src_pte,
 					orig_dst_pte, orig_src_pte, dst_pmd,
 					dst_pmdval, dst_ptl, src_ptl, &src_folio,
-					len, src_anon_vma);
+					len);
 	} else {
 		struct folio *folio = NULL;
 
@@ -1515,10 +1488,6 @@ retry:
 	}
 
 out:
-	if (src_anon_vma) {
-		anon_vma_unlock_write(src_anon_vma);
-		put_anon_vma(src_anon_vma);
-	}
 	if (src_folio) {
 		folio_unlock(src_folio);
 		folio_put(src_folio);
@@ -1792,15 +1761,6 @@ static void uffd_move_unlock(struct vm_a
  * virtual regions without knowing if there are transparent hugepage
  * in the regions or not, but preventing the risk of having to split
  * the hugepmd during the remap.
- *
- * If there's any rmap walk that is taking the anon_vma locks without
- * first obtaining the folio lock (the only current instance is
- * folio_referenced), they will have to verify if the folio->mapping
- * has changed after taking the anon_vma lock. If it changed they
- * should release the lock and retry obtaining a new anon_vma, because
- * it means the anon_vma was changed by move_pages() before the lock
- * could be obtained. This is the only additional complexity added to
- * the rmap code to provide this anonymous page remapping functionality.
  */
 ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 		   unsigned long src_start, unsigned long len, __u64 mode)
_

Patches currently in -mm which might be from lokeshgidra@google.com are

mm-always-call-rmap_walk-on-locked-folios.patch
mm-userfaultfd-dont-lock-anon_vma-when-performing-uffdio_move.patch

