Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17B5BE65
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 00:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751590761; cv=none; b=TADCEOq7Co8azQyp0Q3iCLMSBp1ooxdpI/fkOjYMU59nxXkI+grxSCydPLpOhkMn10Fi/Dz3tif7JHxNLpYq+cZFg8SvC3peJABHVMnS1pPOahYUmU9SjH6X3oiMtAljfu0HMwesnjKN+tMCmBbeOFoKBqkl/99G8PXw1/5KouQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751590761; c=relaxed/simple;
	bh=gexj3o34+C51Zab6DGiPgmzSMSQXmuc28IiZCrwQFJA=;
	h=Date:To:From:Subject:Message-Id; b=rrO3q1YsykdfXDaBN9BIIQsv5clLZ9y6IiPlAD77DSC6lD5ZPcQ065Xqvhhriao4IVotxGt/RZ+1gMV9tCjBrGRVq2kKmV4Bk1JaMJi6aZABUIO0axhimWlHPvv17PvSJnwcZyjeB5kxBWYAAUWzOTwYbP1+HlD8TBnRC625qz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iNV4ifpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iNV4ifpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB94C4CEEE;
	Fri,  4 Jul 2025 00:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751590760;
	bh=gexj3o34+C51Zab6DGiPgmzSMSQXmuc28IiZCrwQFJA=;
	h=Date:To:From:Subject:From;
	b=iNV4ifpbYX4cNfy55tQhrcuENH0jyrh7nJ8nhp52fZxbdIR0g/CwgNHpY+kmHa3/h
	 ctwvvENAyUrFFpWAO/oFHVOlWtTP+Lm4kLad0HHRKhSR0vIjKz4Cz6ZgG+UKqM/pTV
	 J/aIiK/2tA9DxkfdRvxWHI26J5rPqadOYqRuoGuk=
Date: Thu, 03 Jul 2025 17:59:20 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,bagasdotme@gmail.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-add-mthp-support.patch added to mm-new branch
Message-Id: <20250704005920.BCB94C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: add mTHP support
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-add-mthp-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-add-mthp-support.patch

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
From: Nico Pache <npache@redhat.com>
Subject: khugepaged: add mTHP support
Date: Tue, 1 Jul 2025 23:57:34 -0600

Introduce the ability for khugepaged to collapse to different mTHP sizes. 
While scanning PMD ranges for potential collapse candidates, keep track of
pages in KHUGEPAGED_MIN_MTHP_ORDER chunks via a bitmap.  Each bit
represents a utilized region of order KHUGEPAGED_MIN_MTHP_ORDER ptes.  If
mTHPs are enabled we remove the restriction of max_ptes_none during the
scan phase so we dont bailout early and miss potential mTHP candidates.

After the scan is complete we will perform binary recursion on the bitmap
to determine which mTHP size would be most efficient to collapse to. 
max_ptes_none will be scaled by the attempted collapse order to determine
how full a THP must be to be eligible.

If a mTHP collapse is attempted, but contains swapped out, or shared
pages, we dont perform the collapse.

For non-PMD collapse we must leave the anon VMA write locked until after
we collapse the mTHP-- in the PMD case all the pages are isolated, but in
the non-PMD case this is not true, and we must keep the lock to prevent
changes to the VMA from occurring.

Link: https://lkml.kernel.org/r/20250702055742.102808-8-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Reported-by:Takashi Iwai <tiwai@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  135 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 94 insertions(+), 41 deletions(-)

--- a/mm/khugepaged.c~khugepaged-add-mthp-support
+++ a/mm/khugepaged.c
@@ -1124,13 +1124,14 @@ static int collapse_huge_page(struct mm_
 {
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
-	pte_t *pte;
+	pte_t *pte = NULL, mthp_pte;
 	pgtable_t pgtable;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int result = SCAN_FAIL;
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
+	unsigned long _address = address + offset * PAGE_SIZE;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -1146,13 +1147,13 @@ static int collapse_huge_page(struct mm_
 		*mmap_locked = false;
 	}
 
-	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
+	result = alloc_charge_folio(&folio, mm, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
-					 BIT(HPAGE_PMD_ORDER));
+	*mmap_locked = true;
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc, BIT(order));
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1170,13 +1171,14 @@ static int collapse_huge_page(struct mm_
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
-		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-				referenced, HPAGE_PMD_ORDER);
+		result = __collapse_huge_page_swapin(mm, vma, _address, pmd,
+				referenced, order);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
 
 	mmap_read_unlock(mm);
+	*mmap_locked = false;
 	/*
 	 * Prevent all access to pagetables with the exception of
 	 * gup_fast later handled by the ptep_clear_flush and the VM
@@ -1186,8 +1188,7 @@ static int collapse_huge_page(struct mm_
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
-					 BIT(HPAGE_PMD_ORDER));
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc, BIT(order));
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -1198,11 +1199,12 @@ static int collapse_huge_page(struct mm_
 	vma_start_write(vma);
 	anon_vma_lock_write(vma->anon_vma);
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
-				address + HPAGE_PMD_SIZE);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, _address,
+				_address + (PAGE_SIZE << order));
 	mmu_notifier_invalidate_range_start(&range);
 
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
+
 	/*
 	 * This removes any huge TLB entry from the CPU so we won't allow
 	 * huge and small TLB entries for the same virtual address to
@@ -1216,18 +1218,16 @@ static int collapse_huge_page(struct mm_
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_remove_table_sync_one();
 
-	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
+	pte = pte_offset_map_lock(mm, &_pmd, _address, &pte_ptl);
 	if (pte) {
-		result = __collapse_huge_page_isolate(vma, address, pte, cc,
-					&compound_pagelist, HPAGE_PMD_ORDER);
+		result = __collapse_huge_page_isolate(vma, _address, pte, cc,
+					&compound_pagelist, order);
 		spin_unlock(pte_ptl);
 	} else {
 		result = SCAN_PMD_NULL;
 	}
 
 	if (unlikely(result != SCAN_SUCCEED)) {
-		if (pte)
-			pte_unmap(pte);
 		spin_lock(pmd_ptl);
 		BUG_ON(!pmd_none(*pmd));
 		/*
@@ -1242,17 +1242,17 @@ static int collapse_huge_page(struct mm_
 	}
 
 	/*
-	 * All pages are isolated and locked so anon_vma rmap
-	 * can't run anymore.
+	 * For PMD collapse all pages are isolated and locked so anon_vma
+	 * rmap can't run anymore
 	 */
-	anon_vma_unlock_write(vma->anon_vma);
+	if (order == HPAGE_PMD_ORDER)
+		anon_vma_unlock_write(vma->anon_vma);
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
-					   vma, address, pte_ptl,
-					   &compound_pagelist, HPAGE_PMD_ORDER);
-	pte_unmap(pte);
+					   vma, _address, pte_ptl,
+					   &compound_pagelist, order);
 	if (unlikely(result != SCAN_SUCCEED))
-		goto out_up_write;
+		goto out_unlock_anon_vma;
 
 	/*
 	 * The smp_wmb() inside __folio_mark_uptodate() ensures the
@@ -1260,25 +1260,46 @@ static int collapse_huge_page(struct mm_
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
-	pgtable = pmd_pgtable(_pmd);
+	if (order == HPAGE_PMD_ORDER) {
+		pgtable = pmd_pgtable(_pmd);
+		_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
+		_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
+
+		spin_lock(pmd_ptl);
+		BUG_ON(!pmd_none(*pmd));
+		folio_add_new_anon_rmap(folio, vma, _address, RMAP_EXCLUSIVE);
+		folio_add_lru_vma(folio, vma);
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		set_pmd_at(mm, address, pmd, _pmd);
+		update_mmu_cache_pmd(vma, address, pmd);
+		deferred_split_folio(folio, false);
+		spin_unlock(pmd_ptl);
+	} else { /* mTHP collapse */
+		mthp_pte = mk_pte(&folio->page, vma->vm_page_prot);
+		mthp_pte = maybe_mkwrite(pte_mkdirty(mthp_pte), vma);
 
-	_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
-	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
+		spin_lock(pmd_ptl);
+		BUG_ON(!pmd_none(*pmd));
+		folio_ref_add(folio, (1 << order) - 1);
+		folio_add_new_anon_rmap(folio, vma, _address, RMAP_EXCLUSIVE);
+		folio_add_lru_vma(folio, vma);
+		set_ptes(vma->vm_mm, _address, pte, mthp_pte, (1 << order));
+		update_mmu_cache_range(NULL, vma, _address, pte, (1 << order));
 
-	spin_lock(pmd_ptl);
-	BUG_ON(!pmd_none(*pmd));
-	folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
-	folio_add_lru_vma(folio, vma);
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
-	set_pmd_at(mm, address, pmd, _pmd);
-	update_mmu_cache_pmd(vma, address, pmd);
-	deferred_split_folio(folio, false);
-	spin_unlock(pmd_ptl);
+		smp_wmb(); /* make pte visible before pmd */
+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
+		spin_unlock(pmd_ptl);
+	}
 
 	folio = NULL;
 
 	result = SCAN_SUCCEED;
+out_unlock_anon_vma:
+	if (order != HPAGE_PMD_ORDER)
+		anon_vma_unlock_write(vma->anon_vma);
 out_up_write:
+	if (pte)
+		pte_unmap(pte);
 	mmap_write_unlock(mm);
 out_nolock:
 	*mmap_locked = false;
@@ -1354,31 +1375,57 @@ static int khugepaged_scan_pmd(struct mm
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
+	int i;
 	int result = SCAN_FAIL, referenced = 0;
 	int none_or_zero = 0, shared = 0;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long _address;
+	unsigned long enabled_orders;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
+	bool is_pmd_only;
 	bool writable = false;
-
+	int chunk_none_count = 0;
+	int scaled_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER);
+	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
 	result = find_pmd_or_thp_or_none(mm, address, &pmd);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
+	bitmap_zero(cc->mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
+	bitmap_zero(cc->mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
+
+	enabled_orders = thp_vma_allowable_orders(vma, vma->vm_flags,
+		tva_flags, THP_ORDERS_ALL_ANON);
+
+	is_pmd_only = (enabled_orders == (1 << HPAGE_PMD_ORDER));
+
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!pte) {
 		result = SCAN_PMD_NULL;
 		goto out;
 	}
 
-	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, _address += PAGE_SIZE) {
+	for (i = 0; i < HPAGE_PMD_NR; i++) {
+		/*
+		 * we are reading in KHUGEPAGED_MIN_MTHP_NR page chunks. if
+		 * there are pages in this chunk keep track of it in the bitmap
+		 * for mTHP collapsing.
+		 */
+		if (i % KHUGEPAGED_MIN_MTHP_NR == 0) {
+			if (chunk_none_count <= scaled_none)
+				bitmap_set(cc->mthp_bitmap,
+					   i / KHUGEPAGED_MIN_MTHP_NR, 1);
+			chunk_none_count = 0;
+		}
+
+		_pte = pte + i;
+		_address = address + i * PAGE_SIZE;
 		pte_t pteval = ptep_get(_pte);
 		if (is_swap_pte(pteval)) {
 			++unmapped;
@@ -1401,10 +1448,11 @@ static int khugepaged_scan_pmd(struct mm
 			}
 		}
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+			++chunk_none_count;
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
+			    (!cc->is_khugepaged || !is_pmd_only ||
+				none_or_zero <= khugepaged_max_ptes_none)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -1500,6 +1548,7 @@ static int khugepaged_scan_pmd(struct mm
 								     address)))
 			referenced++;
 	}
+
 	if (!writable) {
 		result = SCAN_PAGE_RO;
 	} else if (cc->is_khugepaged &&
@@ -1512,8 +1561,12 @@ static int khugepaged_scan_pmd(struct mm
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		result = collapse_huge_page(mm, address, referenced,
-					    unmapped, cc, mmap_locked, HPAGE_PMD_ORDER, 0);
+		result = khugepaged_scan_bitmap(mm, address, referenced, unmapped, cc,
+			       mmap_locked, enabled_orders);
+		if (result > 0)
+			result = SCAN_SUCCEED;
+		else
+			result = SCAN_FAIL;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
_

Patches currently in -mm which might be from npache@redhat.com are

khugepaged-rename-hpage_collapse_-to-khugepaged_.patch
introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse.patch
khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
khugepaged-introduce-khugepaged_scan_bitmap-for-mthp-support.patch
khugepaged-add-mthp-support.patch
khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
khugepaged-allow-madvise_collapse-to-check-all-anonymous-mthp-orders.patch
khugepaged-improve-tracepoints-for-mthp-orders.patch
khugepaged-add-per-order-mthp-khugepaged-stats.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

