Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A67715359A
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714666311; cv=none; b=cLcaOBux4CZFmCI+hflI/srMPJ5ruV/is3AzF0Cesq1GyzHqdJjLuTe1xdLDMsmj/gcDEn4DLZh23ocDTWib9y8yrbMBnlwj4NPxscnSKA8VShXGiDfHzEaud1PSMy2HozFRz0SbnK/qYHVOpbR8QtcLq7N/e+m+SCUWDjzUHdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714666311; c=relaxed/simple;
	bh=EX26v2tnNfW5LoOILWXsoPdEORO90YxTW9STH5wBC8Y=;
	h=Date:To:From:Subject:Message-Id; b=JaSxo0YD6bJot7hzQbiuZErX0wsozrE2D1W8JOzkviWKUKPenO7JkASwGO8xcfEyq6H9gCWep8cb6bt2Ph6SGwuDcliZaylo19iTE0qiBJaG1Ld/n70m/bT6L+gCcT2hznKIyJsARfskn0QT2JZtj46yDjVDFNk2W+4vIwpSlRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GMraeClZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GMraeClZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDB2C113CC;
	Thu,  2 May 2024 16:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714666311;
	bh=EX26v2tnNfW5LoOILWXsoPdEORO90YxTW9STH5wBC8Y=;
	h=Date:To:From:Subject:From;
	b=GMraeClZsO8gmySm06snVPG7MJ17NYUTnolrB/IhCvoSS7l3XUVNXvh+tzVcj4rqo
	 qR587DzHytQjAVKg+aPRBM29knRiI6cCWXesjLsEVqP2nLHXRpbPvS5Sw0Oym5axFj
	 N+oDzmIHWwdRBYGA227+tJpR++BnWN3hrbbIBsHM=
Date: Thu, 02 May 2024 09:11:49 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,xiehuan09@gmail.com,willy@infradead.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,sj@kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,maskray@google.com,fengwei.yin@intel.com,david@redhat.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop.patch added to mm-unstable branch
Message-Id: <20240502161151.1CDB2C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: integrate PMD-mapped folio splitting into pagewalk loop
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/rmap: integrate PMD-mapped folio splitting into pagewalk loop
Date: Wed, 1 May 2024 12:26:59 +0800

In preparation for supporting try_to_unmap_one() to unmap PMD-mapped
folios, start the pagewalk first, then call split_huge_pmd_address() to
split the folio.

Link: https://lkml.kernel.org/r/20240501042700.83974-3-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: SeongJae Park <sj@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   20 ++++++++++++++++++
 mm/huge_memory.c        |   42 +++++++++++++++++++-------------------
 mm/rmap.c               |   24 ++++++++++++++++-----
 3 files changed, 60 insertions(+), 26 deletions(-)

--- a/include/linux/huge_mm.h~mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop
+++ a/include/linux/huge_mm.h
@@ -409,6 +409,20 @@ static inline bool thp_migration_support
 	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
 }
 
+void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
+			   pmd_t *pmd, bool freeze, struct folio *folio);
+
+static inline void align_huge_pmd_range(struct vm_area_struct *vma,
+					unsigned long *start,
+					unsigned long *end)
+{
+	*start = ALIGN(*start, HPAGE_PMD_SIZE);
+	*end = ALIGN_DOWN(*end, HPAGE_PMD_SIZE);
+
+	VM_WARN_ON_ONCE(vma->vm_start > *start);
+	VM_WARN_ON_ONCE(vma->vm_end < *end);
+}
+
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline bool folio_test_pmd_mappable(struct folio *folio)
@@ -471,6 +485,12 @@ static inline void __split_huge_pmd(stru
 		unsigned long address, bool freeze, struct folio *folio) {}
 static inline void split_huge_pmd_address(struct vm_area_struct *vma,
 		unsigned long address, bool freeze, struct folio *folio) {}
+static inline void split_huge_pmd_locked(struct vm_area_struct *vma,
+					 unsigned long address, pmd_t *pmd,
+					 bool freeze, struct folio *folio) {}
+static inline void align_huge_pmd_range(struct vm_area_struct *vma,
+					unsigned long *start,
+					unsigned long *end) {}
 
 #define split_huge_pud(__vma, __pmd, __address)	\
 	do { } while (0)
--- a/mm/huge_memory.c~mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop
+++ a/mm/huge_memory.c
@@ -2583,6 +2583,27 @@ static void __split_huge_pmd_locked(stru
 	pmd_populate(mm, pmd, pgtable);
 }
 
+void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
+			   pmd_t *pmd, bool freeze, struct folio *folio)
+{
+	VM_WARN_ON_ONCE(folio && !folio_test_pmd_mappable(folio));
+	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
+	VM_WARN_ON_ONCE(folio && !folio_test_locked(folio));
+	VM_BUG_ON(freeze && !folio);
+
+	/*
+	 * When the caller requests to set up a migration entry, we
+	 * require a folio to check the PMD against. Otherwise, there
+	 * is a risk of replacing the wrong folio.
+	 */
+	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
+	    is_pmd_migration_entry(*pmd)) {
+		if (folio && folio != pmd_folio(*pmd))
+			return;
+		__split_huge_pmd_locked(vma, pmd, address, freeze);
+	}
+}
+
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze, struct folio *folio)
 {
@@ -2594,26 +2615,7 @@ void __split_huge_pmd(struct vm_area_str
 				(address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 	ptl = pmd_lock(vma->vm_mm, pmd);
-
-	/*
-	 * If caller asks to setup a migration entry, we need a folio to check
-	 * pmd against. Otherwise we can end up replacing wrong folio.
-	 */
-	VM_BUG_ON(freeze && !folio);
-	VM_WARN_ON_ONCE(folio && !folio_test_locked(folio));
-
-	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
-	    is_pmd_migration_entry(*pmd)) {
-		/*
-		 * It's safe to call pmd_page when folio is set because it's
-		 * guaranteed that pmd is present.
-		 */
-		if (folio && folio != pmd_folio(*pmd))
-			goto out;
-		__split_huge_pmd_locked(vma, pmd, range.start, freeze);
-	}
-
-out:
+	split_huge_pmd_locked(vma, range.start, pmd, freeze, folio);
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
 }
--- a/mm/rmap.c~mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop
+++ a/mm/rmap.c
@@ -1637,9 +1637,6 @@ static bool try_to_unmap_one(struct foli
 	if (flags & TTU_SYNC)
 		pvmw.flags = PVMW_SYNC;
 
-	if (flags & TTU_SPLIT_HUGE_PMD)
-		split_huge_pmd_address(vma, address, false, folio);
-
 	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
 	 * For hugetlb, it could be much worse if we need to do pud
@@ -1651,6 +1648,8 @@ static bool try_to_unmap_one(struct foli
 	range.end = vma_address_end(&pvmw);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, range.end);
+	if (flags & TTU_SPLIT_HUGE_PMD)
+		align_huge_pmd_range(vma, &range.start, &range.end);
 	if (folio_test_hugetlb(folio)) {
 		/*
 		 * If sharing is possible, start and end will be adjusted
@@ -1665,9 +1664,6 @@ static bool try_to_unmap_one(struct foli
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
-		/* Unexpected PMD-mapped THP? */
-		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
-
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
 		 */
@@ -1679,6 +1675,22 @@ static bool try_to_unmap_one(struct foli
 			goto walk_done_err;
 		}
 
+		if (!pvmw.pte && (flags & TTU_SPLIT_HUGE_PMD)) {
+			/*
+			 * We temporarily have to drop the PTL and start once
+			 * again from that now-PTE-mapped page table.
+			 */
+			split_huge_pmd_locked(vma, range.start, pvmw.pmd, false,
+					      folio);
+			pvmw.pmd = NULL;
+			spin_unlock(pvmw.ptl);
+			flags &= ~TTU_SPLIT_HUGE_PMD;
+			continue;
+		}
+
+		/* Unexpected PMD-mapped THP? */
+		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
+
 		pfn = pte_pfn(ptep_get(pvmw.pte));
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		address = pvmw.address;
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-madvise-introduce-clear_young_dirty_ptes-batch-helper.patch
mm-arm64-override-clear_young_dirty_ptes-batch-helper.patch
mm-memory-add-any_dirty-optional-pointer-to-folio_pte_batch.patch
mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch
mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch
mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop.patch
mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch

