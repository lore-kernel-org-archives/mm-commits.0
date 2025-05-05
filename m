Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAE9274FF5
	for <mm-commits@vger.kernel.org>; Mon,  5 May 2025 22:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746482636; cv=none; b=StG+NeNgANn8dULOM52r3/AFInFhGZmqkZCKTlcDsc8G2VlB2tBwLNo+tXfvCMKmaA7fSLzoCjFC0QsHcPDYStn+GjY1FJA6J2atiDBNuLde3bbsfB9uPAjNggRtJapYEujPY83heEx4GYxQa6cHmUmt95vgJNmFryIuBU5hkfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746482636; c=relaxed/simple;
	bh=u/S1Jm8nClXqCn+9fMoFF9loDByW5iLQGoYKR604GOQ=;
	h=Date:To:From:Subject:Message-Id; b=vAv8laNIBZEj5GNrlXWXsNllsOI/5a55CaQWQjz6YuxHyxmFGrCMyawL6dTuJgSbLldSvkDVJF+cjumzxVS0hwY6iJvY1cRWDSaxIxvCZ5GovBEUaO2+/qIyLZ5MMKBjQYA0ax8wKe3puDTbblf+wr6QwmoXMXCAqmjESVWwhdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rNLMw+gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rNLMw+gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D12C4CEE4;
	Mon,  5 May 2025 22:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746482635;
	bh=u/S1Jm8nClXqCn+9fMoFF9loDByW5iLQGoYKR604GOQ=;
	h=Date:To:From:Subject:From;
	b=rNLMw+gh4ls6UAMzELaNqpccTVniBWYevRgaeNXpRSQfuv02Bc0AOrs5vfQqhPoo3
	 2gC8KcTK7Z00rYMEo0PNQyY8vWDDH+EwqfkhCC8LwPeUnd2xjlg+sIUFL7CnGoDSrM
	 jk12nN9V1i8grwxDuL32LQyrX5VCzANU4C7V5VPY=
Date: Mon, 05 May 2025 15:03:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch added to mm-unstable branch
Message-Id: <20250505220355.78D12C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: convert use of struct page to folio in __unmap_hugepage_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch

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
From: Fan Ni <fan.ni@samsung.com>
Subject: mm/hugetlb: convert use of struct page to folio in __unmap_hugepage_range()
Date: Mon, 5 May 2025 11:22:44 -0700

In __unmap_hugepage_range(), the "page" pointer always points to the first
page of a huge page, which guarantees there is a folio associating with
it.  Convert the "page" pointer to use folio.

Link: https://lkml.kernel.org/r/20250505182345.506888-6-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range
+++ a/mm/hugetlb.c
@@ -5843,11 +5843,11 @@ void __unmap_hugepage_range(struct mmu_g
 			    struct folio *folio, zap_flags_t zap_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	const bool folio_provided = !!folio;
 	unsigned long address;
 	pte_t *ptep;
 	pte_t pte;
 	spinlock_t *ptl;
-	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
 	bool adjust_reservation = false;
@@ -5911,14 +5911,13 @@ void __unmap_hugepage_range(struct mmu_g
 			continue;
 		}
 
-		page = pte_page(pte);
 		/*
 		 * If a folio is supplied, it is because a specific
 		 * folio is being unmapped, not a range. Ensure the folio we
 		 * are about to unmap is the actual folio of interest.
 		 */
-		if (folio) {
-			if (page_folio(page) != folio) {
+		if (folio_provided) {
+			if (folio != page_folio(pte_page(pte))) {
 				spin_unlock(ptl);
 				continue;
 			}
@@ -5928,12 +5927,14 @@ void __unmap_hugepage_range(struct mmu_g
 			 * looking like data was lost
 			 */
 			set_vma_resv_flags(vma, HPAGE_RESV_UNMAPPED);
+		} else {
+			folio = page_folio(pte_page(pte));
 		}
 
 		pte = huge_ptep_get_and_clear(mm, address, ptep, sz);
 		tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
 		if (huge_pte_dirty(pte))
-			set_page_dirty(page);
+			folio_mark_dirty(folio);
 		/* Leave a uffd-wp pte marker if needed */
 		if (huge_pte_uffd_wp(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
@@ -5941,7 +5942,7 @@ void __unmap_hugepage_range(struct mmu_g
 					make_pte_marker(PTE_MARKER_UFFD_WP),
 					sz);
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
-		hugetlb_remove_rmap(page_folio(page));
+		hugetlb_remove_rmap(folio);
 
 		/*
 		 * Restore the reservation for anonymous page, otherwise the
@@ -5950,8 +5951,8 @@ void __unmap_hugepage_range(struct mmu_g
 		 * reservation bit.
 		 */
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
-		    folio_test_anon(page_folio(page))) {
-			folio_set_hugetlb_restore_reserve(page_folio(page));
+		    folio_test_anon(folio)) {
+			folio_set_hugetlb_restore_reserve(folio);
 			/* Reservation to be adjusted after the spin lock */
 			adjust_reservation = true;
 		}
@@ -5975,16 +5976,17 @@ void __unmap_hugepage_range(struct mmu_g
 				 * count will not be incremented by free_huge_folio.
 				 * Act as if we consumed the reservation.
 				 */
-				folio_clear_hugetlb_restore_reserve(page_folio(page));
+				folio_clear_hugetlb_restore_reserve(folio);
 			else if (rc)
 				vma_add_reservation(h, vma, address);
 		}
 
-		tlb_remove_page_size(tlb, page, huge_page_size(h));
+		tlb_remove_page_size(tlb, folio_page(folio, 0),
+				     folio_size(folio));
 		/*
 		 * If we were instructed to unmap a specific folio, we're done.
 		 */
-		if (folio)
+		if (folio_provided)
 			break;
 	}
 	tlb_end_vma(tlb, vma);
_

Patches currently in -mm which might be from fan.ni@samsung.com are

mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-pass-folio-instead-of-head-page-to-trace-events.patch
mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch

