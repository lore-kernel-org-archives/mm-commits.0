Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1484D5CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957029; cv=none; b=oebcRdd0DxRUXtvY6+8uO7LYeFlm53oKHeZxYH++Z7q1d7pidOTdFldurVwk5ETu6pN9PHFg7i4aI70q9RxYr9Uq+/gevOS4NQqgXTpUwse5MggvnNnewAeUSwJ+CX3lM+87DTYLx7g3Utouu0T5VDEoUTfEmYPtZfLBV/+LrZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957029; c=relaxed/simple;
	bh=h/C1I7sn8sJPjby/A2lRVFXIoV28fncfiqx+bVNv00k=;
	h=Date:To:From:Subject:Message-Id; b=h0oaWHeTpFo41ZcrnZRfcZIWKiMANX64QDnGXD96YOjdnIW6GKDAl5DV7Q1/wqJQfdOA7xt6g6UnFVVIbtZ95mPGogGbJ/0fznr8UBiLG9a13tiAqCFM4vtKQngw2cJL/eYOg7dOC+XWESxLtGwRSr/Txmy5MNkdalnwQlY+Bxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dlBBLgQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dlBBLgQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC05C113CC;
	Mon,  6 May 2024 00:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957029;
	bh=h/C1I7sn8sJPjby/A2lRVFXIoV28fncfiqx+bVNv00k=;
	h=Date:To:From:Subject:From;
	b=dlBBLgQ/1QMNDQL0ZVWcj4+ldNszBsKryUGfODFe1h+Qh+rt8dsGilfdUgZEWYmyJ
	 aHJiI2Cb4fE/0TDDM3sJv7xReswy5dI9y/MqCS/ylR355sfnwHNLpYtJ7MEwQaRHRx
	 9CKHKtu60Xu3P1PhnAoywyQeuPNwaIho1YNFx7+c=
Date: Sun, 05 May 2024 17:57:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-use-folio-in-write_protect_page.patch removed from -mm tree
Message-Id: <20240506005708.DCC05C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: use folio in write_protect_page
has been removed from the -mm tree.  Its filename was
     mm-ksm-use-folio-in-write_protect_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: use folio in write_protect_page
Date: Thu, 11 Apr 2024 14:17:08 +0800

Compound page is checked and skipped before write_protect_page() called,
use folio to save a few compound_head checks.

Link: https://lkml.kernel.org/r/20240411061713.1847574-8-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-folio-in-write_protect_page
+++ a/mm/ksm.c
@@ -1289,23 +1289,24 @@ static u32 calc_checksum(struct page *pa
 	return checksum;
 }
 
-static int write_protect_page(struct vm_area_struct *vma, struct page *page,
+static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 			      pte_t *orig_pte)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	DEFINE_PAGE_VMA_WALK(pvmw, page, vma, 0, 0);
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, 0, 0);
 	int swapped;
 	int err = -EFAULT;
 	struct mmu_notifier_range range;
 	bool anon_exclusive;
 	pte_t entry;
 
-	pvmw.address = page_address_in_vma(page, vma);
+	if (WARN_ON_ONCE(folio_test_large(folio)))
+		return err;
+
+	pvmw.address = page_address_in_vma(&folio->page, vma);
 	if (pvmw.address == -EFAULT)
 		goto out;
 
-	BUG_ON(PageTransCompound(page));
-
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, pvmw.address,
 				pvmw.address + PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1315,12 +1316,12 @@ static int write_protect_page(struct vm_
 	if (WARN_ONCE(!pvmw.pte, "Unexpected PMD mapping?"))
 		goto out_unlock;
 
-	anon_exclusive = PageAnonExclusive(page);
+	anon_exclusive = PageAnonExclusive(&folio->page);
 	entry = ptep_get(pvmw.pte);
 	if (pte_write(entry) || pte_dirty(entry) ||
 	    anon_exclusive || mm_tlb_flush_pending(mm)) {
-		swapped = PageSwapCache(page);
-		flush_cache_page(vma, pvmw.address, page_to_pfn(page));
+		swapped = folio_test_swapcache(folio);
+		flush_cache_page(vma, pvmw.address, folio_pfn(folio));
 		/*
 		 * Ok this is tricky, when get_user_pages_fast() run it doesn't
 		 * take any lock, therefore the check that we are going to make
@@ -1340,20 +1341,20 @@ static int write_protect_page(struct vm_
 		 * Check that no O_DIRECT or similar I/O is in progress on the
 		 * page
 		 */
-		if (page_mapcount(page) + 1 + swapped != page_count(page)) {
+		if (folio_mapcount(folio) + 1 + swapped != folio_ref_count(folio)) {
 			set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 			goto out_unlock;
 		}
 
 		/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
 		if (anon_exclusive &&
-		    folio_try_share_anon_rmap_pte(page_folio(page), page)) {
+		    folio_try_share_anon_rmap_pte(folio, &folio->page)) {
 			set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 			goto out_unlock;
 		}
 
 		if (pte_dirty(entry))
-			set_page_dirty(page);
+			folio_mark_dirty(folio);
 		entry = pte_mkclean(entry);
 
 		if (pte_write(entry))
@@ -1519,7 +1520,7 @@ static int try_to_merge_one_page(struct
 	 * ptes are necessarily already write-protected.  But in either
 	 * case, we need to lock and check page_count is not raised.
 	 */
-	if (write_protect_page(vma, page, &orig_pte) == 0) {
+	if (write_protect_page(vma, page_folio(page), &orig_pte) == 0) {
 		if (!kpage) {
 			/*
 			 * While we hold page lock, upgrade page from
_

Patches currently in -mm which might be from alexs@kernel.org are


