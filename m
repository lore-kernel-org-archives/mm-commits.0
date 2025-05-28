Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4725C1898FB
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 02:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748399960; cv=none; b=f/SXQYg3NJOevjUKwnTxKfyZmn7f3tZ5TtNlMbSRUH+Snn2E9IC6lD7HzvgKs+rsyazSJLQKuzOWHZaWqRddK1Wom0iUnHQNuRC5bn9JosRgyOosF1pgDGSQCTb5RbjUGcPVgvtXwh63eMRF77gw+G1SxvpeIG7zmkeKxkp2ISs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748399960; c=relaxed/simple;
	bh=UFiBPMlvvo6NOp2MRElryy5vmu93fivnai0ZYav/Y9M=;
	h=Date:To:From:Subject:Message-Id; b=XMCrHR9KtukWzwywidneqZOAC69wUYf70BXNkvUCna0O/dgamLFxeQ9NSfy38SIEByzWzXr/Hntr07sYOmuo9DoTMMUTJJeZ95jckz0yWBhV+WdtdwVNYVm2/KQixB4VJE4CpJdkjkWUw5a7pP9UUnUMdMIrFdAVjwLjXLxR9q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y1xXNBfT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y1xXNBfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EEBC4CEEA;
	Wed, 28 May 2025 02:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748399959;
	bh=UFiBPMlvvo6NOp2MRElryy5vmu93fivnai0ZYav/Y9M=;
	h=Date:To:From:Subject:From;
	b=y1xXNBfTAJ5Ye3fWFe4exfYQJwrVIBrpz5NI0DnK3Jrif03YIg72XjqJkj/d7+aZr
	 926uh/xDs7BiZQaBMfCB2KMVWXsQ4TPNjeUuJvPVqJrnlrQrCmztu7NLnYPRc4+3ZQ
	 9tWEgvX9vR4BsZ2rQ/cXXpkdOBmlhcqKVfvVEO08=
Date: Tue, 27 May 2025 19:39:18 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch removed from -mm tree
Message-Id: <20250528023919.72EEBC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: convert use of struct page to folio in __unmap_hugepage_range()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


