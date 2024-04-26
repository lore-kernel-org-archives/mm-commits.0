Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B99180BF0
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104163; cv=none; b=QlhdY6wuVj1qfxm93vO7WyoSN6kUPkUNIcN4gt/o0EyFipqRJcGdm4036lhmr8CYe1uCEJJivOheAAYnkFXRoujQ9F1cDea66LnyYonGp1AP955ZmYK13mOwp2Pv3nyjRWCyV9gu+dLJhfXaY6kTmNa4y2Yw2BNyltdM5tr8Mbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104163; c=relaxed/simple;
	bh=1kofUCMtoxxodm/Cqr/UPY9CXL8wdIS96lVdjD3QP5I=;
	h=Date:To:From:Subject:Message-Id; b=VWhl4iMUitwsLzJDcgEoHWa0GVYlEpnVgvzKlPAYXTJK0eqZqObEpuavjviIQRVZ9KcTSQb3HzPX7GdimXpObfQnZcsI0+/I4y1sflwVo1kNoihunl5LZxx+lm92byZJSLzu5lNbfm4e/d2U6/61r8bhJ8BBBORY/LOo0hRokNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xq4dFi31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xq4dFi31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CC1C116B1;
	Fri, 26 Apr 2024 04:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104163;
	bh=1kofUCMtoxxodm/Cqr/UPY9CXL8wdIS96lVdjD3QP5I=;
	h=Date:To:From:Subject:From;
	b=Xq4dFi31AvHdAkAxp1whi4jqaAVui9PWRB23ZWT6OSyKm5zOxsn4BFgZHQcQ+jJ6n
	 TcXrnY90Kkp38njJNwlacRm9BrHHvET3PJkBr+BgH49SrFDr+PxsfJIBvpP5cJWC05
	 Mcju0HEWQQdxvb3Xk0qlStH45tlFFxv5ByP/OGxc=
Date: Thu, 25 Apr 2024 21:02:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault.patch removed from -mm tree
Message-Id: <20240426040242.E5CC1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: convert hugetlb_no_page() to use struct vm_fault
has been removed from the -mm tree.  Its filename was
     hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: hugetlb: convert hugetlb_no_page() to use struct vm_fault
Date: Mon, 1 Apr 2024 13:26:50 -0700

hugetlb_no_page() can use the struct vm_fault passed in from
hugetlb_fault(). This alleviates the stack by consolidating 7
variables into a single struct.

[vishal.moola@gmail.com:  simplify hugetlb_no_page() arguments]
  Link: https://lkml.kernel.org/r/ZhQtN8y5zud8iI1u@fedora
Link: https://lkml.kernel.org/r/20240401202651.31440-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   63 ++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

--- a/mm/hugetlb.c~hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault
+++ a/mm/hugetlb.c
@@ -6188,23 +6188,19 @@ static bool hugetlb_pte_stable(struct hs
 	return same;
 }
 
-static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
-			struct vm_area_struct *vma,
-			struct address_space *mapping, pgoff_t idx,
-			unsigned long address, pte_t *ptep,
-			pte_t old_pte, unsigned int flags,
+static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 			struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
+	struct mm_struct *mm = vma->vm_mm;
 	struct hstate *h = hstate_vma(vma);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 	int anon_rmap = 0;
 	unsigned long size;
 	struct folio *folio;
 	pte_t new_pte;
-	spinlock_t *ptl;
-	unsigned long haddr = address & huge_page_mask(h);
 	bool new_folio, new_pagecache_folio = false;
-	u32 hash = hugetlb_fault_mutex_hash(mapping, idx);
+	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -6223,10 +6219,10 @@ static vm_fault_t hugetlb_no_page(struct
 	 * before we get page_table_lock.
 	 */
 	new_folio = false;
-	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
+	folio = filemap_lock_hugetlb_folio(h, mapping, vmf->pgoff);
 	if (IS_ERR(folio)) {
 		size = i_size_read(mapping->host) >> huge_page_shift(h);
-		if (idx >= size)
+		if (vmf->pgoff >= size)
 			goto out;
 		/* Check for page in userfault range */
 		if (userfaultfd_missing(vma)) {
@@ -6247,7 +6243,7 @@ static vm_fault_t hugetlb_no_page(struct
 			 * never happen on the page after UFFDIO_COPY has
 			 * correctly installed the page and returned.
 			 */
-			if (!hugetlb_pte_stable(h, mm, ptep, old_pte)) {
+			if (!hugetlb_pte_stable(h, mm, vmf->pte, vmf->orig_pte)) {
 				ret = 0;
 				goto out;
 			}
@@ -6262,7 +6258,7 @@ static vm_fault_t hugetlb_no_page(struct
 				goto out;
 		}
 
-		folio = alloc_hugetlb_folio(vma, haddr, 0);
+		folio = alloc_hugetlb_folio(vma, vmf->address, 0);
 		if (IS_ERR(folio)) {
 			/*
 			 * Returning error will result in faulting task being
@@ -6276,18 +6272,20 @@ static vm_fault_t hugetlb_no_page(struct
 			 * here.  Before returning error, get ptl and make
 			 * sure there really is no pte entry.
 			 */
-			if (hugetlb_pte_stable(h, mm, ptep, old_pte))
+			if (hugetlb_pte_stable(h, mm, vmf->pte, vmf->orig_pte))
 				ret = vmf_error(PTR_ERR(folio));
 			else
 				ret = 0;
 			goto out;
 		}
-		clear_huge_page(&folio->page, address, pages_per_huge_page(h));
+		clear_huge_page(&folio->page, vmf->real_address,
+				pages_per_huge_page(h));
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
 		if (vma->vm_flags & VM_MAYSHARE) {
-			int err = hugetlb_add_to_page_cache(folio, mapping, idx);
+			int err = hugetlb_add_to_page_cache(folio, mapping,
+							vmf->pgoff);
 			if (err) {
 				/*
 				 * err can't be -EEXIST which implies someone
@@ -6296,7 +6294,8 @@ static vm_fault_t hugetlb_no_page(struct
 				 * to the page cache. So it's safe to call
 				 * restore_reserve_on_error() here.
 				 */
-				restore_reserve_on_error(h, vma, haddr, folio);
+				restore_reserve_on_error(h, vma, vmf->address,
+							folio);
 				folio_put(folio);
 				ret = VM_FAULT_SIGBUS;
 				goto out;
@@ -6323,7 +6322,7 @@ static vm_fault_t hugetlb_no_page(struct
 			folio_unlock(folio);
 			folio_put(folio);
 			/* See comment in userfaultfd_missing() block above */
-			if (!hugetlb_pte_stable(h, mm, ptep, old_pte)) {
+			if (!hugetlb_pte_stable(h, mm, vmf->pte, vmf->orig_pte)) {
 				ret = 0;
 				goto out;
 			}
@@ -6338,23 +6337,23 @@ static vm_fault_t hugetlb_no_page(struct
 	 * any allocations necessary to record that reservation occur outside
 	 * the spinlock.
 	 */
-	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
-		if (vma_needs_reservation(h, vma, haddr) < 0) {
+	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
+		if (vma_needs_reservation(h, vma, vmf->address) < 0) {
 			ret = VM_FAULT_OOM;
 			goto backout_unlocked;
 		}
 		/* Just decrements count, does not deallocate */
-		vma_end_reservation(h, vma, haddr);
+		vma_end_reservation(h, vma, vmf->address);
 	}
 
-	ptl = huge_pte_lock(h, mm, ptep);
+	vmf->ptl = huge_pte_lock(h, mm, vmf->pte);
 	ret = 0;
 	/* If pte changed from under us, retry */
-	if (!pte_same(huge_ptep_get(ptep), old_pte))
+	if (!pte_same(huge_ptep_get(vmf->pte), vmf->orig_pte))
 		goto backout;
 
 	if (anon_rmap)
-		hugetlb_add_new_anon_rmap(folio, vma, haddr);
+		hugetlb_add_new_anon_rmap(folio, vma, vmf->address);
 	else
 		hugetlb_add_file_rmap(folio);
 	new_pte = make_huge_pte(vma, &folio->page, ((vma->vm_flags & VM_WRITE)
@@ -6363,17 +6362,18 @@ static vm_fault_t hugetlb_no_page(struct
 	 * If this pte was previously wr-protected, keep it wr-protected even
 	 * if populated.
 	 */
-	if (unlikely(pte_marker_uffd_wp(old_pte)))
+	if (unlikely(pte_marker_uffd_wp(vmf->orig_pte)))
 		new_pte = huge_pte_mkuffd_wp(new_pte);
-	set_huge_pte_at(mm, haddr, ptep, new_pte, huge_page_size(h));
+	set_huge_pte_at(mm, vmf->address, vmf->pte, new_pte, huge_page_size(h));
 
 	hugetlb_count_add(pages_per_huge_page(h), mm);
-	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
+	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_wp(mm, vma, address, ptep, flags, folio, ptl, vmf);
+		ret = hugetlb_wp(mm, vma, vmf->real_address, vmf->pte,
+				vmf->flags, folio, vmf->ptl, vmf);
 	}
 
-	spin_unlock(ptl);
+	spin_unlock(vmf->ptl);
 
 	/*
 	 * Only set hugetlb_migratable in newly allocated pages.  Existing pages
@@ -6390,10 +6390,10 @@ out:
 	return ret;
 
 backout:
-	spin_unlock(ptl);
+	spin_unlock(vmf->ptl);
 backout_unlocked:
 	if (new_folio && !new_pagecache_folio)
-		restore_reserve_on_error(h, vma, haddr, folio);
+		restore_reserve_on_error(h, vma, vmf->address, folio);
 
 	folio_unlock(folio);
 	folio_put(folio);
@@ -6489,8 +6489,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		 * hugetlb_no_page will drop vma lock and hugetlb fault
 		 * mutex internally, which make us return immediately.
 		 */
-		return hugetlb_no_page(mm, vma, mapping, vmf.pgoff, address,
-					vmf.pte, vmf.orig_pte, flags, &vmf);
+		return hugetlb_no_page(mapping, &vmf);
 	}
 
 	ret = 0;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


