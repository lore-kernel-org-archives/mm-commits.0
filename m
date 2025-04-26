Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4E5195FE8
	for <mm-commits@vger.kernel.org>; Sat, 26 Apr 2025 00:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745627250; cv=none; b=ZizflnXf4EuJjwU8iaFKIbAot3ews1nslXAp3IV01gA9IdKsAtVk9M7L7ZQu5UWrgl6sSxm9U130s+2Z8y8VYPhFPR5NkbPAWkQVcVepLkkUR/ABv/jqTF5WNJXk+1ed6bkLNOUSTMSOaVHjmbvX1+FqHL0TyILNYraY72FjsPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745627250; c=relaxed/simple;
	bh=Dk0DjBiJuO/zX0l+WhGB/6GolFaqjlz1bylu5xu1zww=;
	h=Date:To:From:Subject:Message-Id; b=nrIbfL4IihXgfsCjnDdKe9GAVzPynfpzY/o/ylBxOsYLtt5pKLD6U14qhPqMjxuKSxz+92nfthwJpjXZJvUBMreMIHlw/5QdBsO8HAXkoY6C71gOAGSejgcQ6WoZoAzxpy+Ve4QNfRddUYfE1QUInVMrdrUvLjqGZPIUUS8m9Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ievM6Yfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ievM6Yfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F5BC4CEE4;
	Sat, 26 Apr 2025 00:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745627249;
	bh=Dk0DjBiJuO/zX0l+WhGB/6GolFaqjlz1bylu5xu1zww=;
	h=Date:To:From:Subject:From;
	b=ievM6Yfodqyx+4VOrl/hZtdV61tdi+DTM58UFxE1W/R8kDHW3WBCT9rTzPOzChqwH
	 ZrmHJ/6LzT3DSnUzEq/1RIR2cV4f8B4srYiHzg4xPm/hCG95DA1/CwV6TMiomG+vpJ
	 HD0qZ5aTjWmsCMaeQF7cnNMW56Wv/306cg4KtQVs=
Date: Fri, 25 Apr 2025 17:27:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,revest@google.com,linmiaohe@huawei.com,hughd@google.com,gshan@redhat.com,david@redhat.com,gavinguo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-useless-folio-pointers-passing.patch added to mm-unstable branch
Message-Id: <20250426002729.40F5BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: remove useless folio pointers passing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-remove-useless-folio-pointers-passing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-remove-useless-folio-pointers-passing.patch

This patch will later appear in the mm-unstable branch at
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
From: Gavin Guo <gavinguo@igalia.com>
Subject: mm/huge_memory: remove useless folio pointers passing
Date: Fri, 25 Apr 2025 18:38:59 +0800

Since the previous commit "mm/huge_memory: Adjust try_to_migrate_one() and
split_huge_pmd_locked()" has simplified the logic by leveraging the folio
verification in page_vma_mapped_walk(), this patch removes the unnecessary
folio pointers passing.

Link: https://lkml.kernel.org/r/20250425103859.825879-3-gavinguo@igalia.com
Link: https://lore.kernel.org/all/98d1d195-7821-4627-b518-83103ade56c0@redhat.com/
Link: https://lore.kernel.org/all/91599a3c-e69e-4d79-bac5-5013c96203d7@redhat.com/
Signed-off-by: Gavin Guo <gavinguo@igalia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Florent Revest <revest@google.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   15 +++++++--------
 mm/huge_memory.c        |   16 ++++++++--------
 mm/memory.c             |    4 ++--
 mm/mprotect.c           |    2 +-
 mm/rmap.c               |    4 ++--
 5 files changed, 20 insertions(+), 21 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-remove-useless-folio-pointers-passing
+++ a/include/linux/huge_mm.h
@@ -395,7 +395,7 @@ static inline int split_huge_page(struct
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long address, bool freeze, struct folio *folio);
+		unsigned long address, bool freeze);
 
 #define split_huge_pmd(__vma, __pmd, __address)				\
 	do {								\
@@ -403,12 +403,11 @@ void __split_huge_pmd(struct vm_area_str
 		if (is_swap_pmd(*____pmd) || pmd_trans_huge(*____pmd)	\
 					|| pmd_devmap(*____pmd))	\
 			__split_huge_pmd(__vma, __pmd, __address,	\
-						false, NULL);		\
+					 false);			\
 	}  while (0)
 
-
 void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
-		bool freeze, struct folio *folio);
+		bool freeze);
 
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long address);
@@ -501,7 +500,7 @@ static inline bool thp_migration_support
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
-			   pmd_t *pmd, bool freeze, struct folio *folio);
+			   pmd_t *pmd, bool freeze);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
 
@@ -576,12 +575,12 @@ static inline void deferred_split_folio(
 	do { } while (0)
 
 static inline void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long address, bool freeze, struct folio *folio) {}
+		unsigned long address, bool freeze) {}
 static inline void split_huge_pmd_address(struct vm_area_struct *vma,
-		unsigned long address, bool freeze, struct folio *folio) {}
+		unsigned long address, bool freeze) {}
 static inline void split_huge_pmd_locked(struct vm_area_struct *vma,
 					 unsigned long address, pmd_t *pmd,
-					 bool freeze, struct folio *folio) {}
+					 bool freeze) {}
 
 static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 					 unsigned long addr, pmd_t *pmdp,
--- a/mm/huge_memory.c~mm-huge_memory-remove-useless-folio-pointers-passing
+++ a/mm/huge_memory.c
@@ -1785,7 +1785,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 		pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
-		__split_huge_pmd(src_vma, src_pmd, addr, false, NULL);
+		__split_huge_pmd(src_vma, src_pmd, addr, false);
 		return -EAGAIN;
 	}
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
@@ -2007,7 +2007,7 @@ unlock_fallback:
 	folio_unlock(folio);
 	spin_unlock(vmf->ptl);
 fallback:
-	__split_huge_pmd(vma, vmf->pmd, vmf->address, false, NULL);
+	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
 	return VM_FAULT_FALLBACK;
 }
 
@@ -3080,7 +3080,7 @@ static void __split_huge_pmd_locked(stru
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
-			   pmd_t *pmd, bool freeze, struct folio *folio)
+			   pmd_t *pmd, bool freeze)
 {
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
 	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
@@ -3089,7 +3089,7 @@ void split_huge_pmd_locked(struct vm_are
 }
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long address, bool freeze, struct folio *folio)
+		unsigned long address, bool freeze)
 {
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
@@ -3099,20 +3099,20 @@ void __split_huge_pmd(struct vm_area_str
 				(address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 	ptl = pmd_lock(vma->vm_mm, pmd);
-	split_huge_pmd_locked(vma, range.start, pmd, freeze, folio);
+	split_huge_pmd_locked(vma, range.start, pmd, freeze);
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
 }
 
 void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
-		bool freeze, struct folio *folio)
+		bool freeze)
 {
 	pmd_t *pmd = mm_find_pmd(vma->vm_mm, address);
 
 	if (!pmd)
 		return;
 
-	__split_huge_pmd(vma, pmd, address, freeze, folio);
+	__split_huge_pmd(vma, pmd, address, freeze);
 }
 
 static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
@@ -3124,7 +3124,7 @@ static inline void split_huge_pmd_if_nee
 	if (!IS_ALIGNED(address, HPAGE_PMD_SIZE) &&
 	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
 			 ALIGN(address, HPAGE_PMD_SIZE)))
-		split_huge_pmd_address(vma, address, false, NULL);
+		split_huge_pmd_address(vma, address, false);
 }
 
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
--- a/mm/memory.c~mm-huge_memory-remove-useless-folio-pointers-passing
+++ a/mm/memory.c
@@ -1808,7 +1808,7 @@ static inline unsigned long zap_pmd_rang
 		next = pmd_addr_end(addr, end);
 		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
-				__split_huge_pmd(vma, pmd, addr, false, NULL);
+				__split_huge_pmd(vma, pmd, addr, false);
 			else if (zap_huge_pmd(tlb, vma, pmd, addr)) {
 				addr = next;
 				continue;
@@ -5932,7 +5932,7 @@ static inline vm_fault_t wp_huge_pmd(str
 
 split:
 	/* COW or write-notify handled on pte level: split pmd. */
-	__split_huge_pmd(vma, vmf->pmd, vmf->address, false, NULL);
+	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
 
 	return VM_FAULT_FALLBACK;
 }
--- a/mm/mprotect.c~mm-huge_memory-remove-useless-folio-pointers-passing
+++ a/mm/mprotect.c
@@ -379,7 +379,7 @@ again:
 		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
 			    pgtable_split_needed(vma, cp_flags)) {
-				__split_huge_pmd(vma, pmd, addr, false, NULL);
+				__split_huge_pmd(vma, pmd, addr, false);
 				/*
 				 * For file-backed, the pmd could have been
 				 * cleared; make sure pmd populated if
--- a/mm/rmap.c~mm-huge_memory-remove-useless-folio-pointers-passing
+++ a/mm/rmap.c
@@ -1944,7 +1944,7 @@ static bool try_to_unmap_one(struct foli
 				 * restart so we can process the PTE-mapped THP.
 				 */
 				split_huge_pmd_locked(vma, pvmw.address,
-						      pvmw.pmd, false, folio);
+						      pvmw.pmd, false);
 				flags &= ~TTU_SPLIT_HUGE_PMD;
 				page_vma_mapped_walk_restart(&pvmw);
 				continue;
@@ -2320,7 +2320,7 @@ static bool try_to_migrate_one(struct fo
 		if (!pvmw.pte) {
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				split_huge_pmd_locked(vma, pvmw.address,
-						      pvmw.pmd, true, NULL);
+						      pvmw.pmd, true);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
_

Patches currently in -mm which might be from gavinguo@igalia.com are

mm-huge_memory-fix-dereferencing-invalid-pmd-migration-entry.patch
mm-huge_memory-adjust-try_to_migrate_one-and-split_huge_pmd_locked.patch
mm-huge_memory-remove-useless-folio-pointers-passing.patch

