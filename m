Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BBC364940
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 19:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439088; cv=none; b=nxZ2pfbmFtr+KJABe3eIsf8rAK9eKWoBJkg7uAdLIenriu9sJBz8uiNWsSFW7z+K2/Don2UbK4ow2aNqbaigRlT88IODNDlJv0OmUoTTElbusZ3tyWBvtbTOu2LyWaM6O6+ZTYoLceeLGVdTm/JCogXCm3DDx8z3IKU9Mdc0IEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439088; c=relaxed/simple;
	bh=OatrlWV9fheIDWsWopTEk9aGMSBJCPMI2ljVx+Ed2LA=;
	h=Date:To:From:Subject:Message-Id; b=VI6PkdPsxoxPUpaPsCDqea9Rfw09sld9ToI9IONyuajj0u1lAb1YntXsouIN0eom4qrLJhJjlx29x4JM4nzEY2xP58FFqLEqITOQPSZJLCeUQgh8z3e5+B49pHr56iKsaUOcmj2tDOlRZx5h1Feb95EDXrULCHjRxMFGZi0tRNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tEB+QVT2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tEB+QVT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE481F00A3A;
	Thu, 30 Jul 2026 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785439087;
	bh=monFH4/4WqGIpT7vb1NkgQLuboYSbRyIg6wV5/XkCpA=;
	h=Date:To:From:Subject;
	b=tEB+QVT2ey1NejPb7+r37TfTUcCfkITfdB5+c3DSZM76SQpb/LUX/rBWS5D4xuvSh
	 w4cSlbciZQrBPVceAyID02ISiFMCnxNTQ0DGB+xDJUGX4HUYITLTnK3gA5dX+lScSF
	 S+w3aeVAWwt4Ac2cbitaRWrJd71ft3wHe2XGXJiI=
Date: Thu, 30 Jul 2026 12:18:06 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch removed from -mm tree
Message-Id: <20260730191807.0EE481F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: refactor anon folio unmap in try_to_unmap_one
has been removed from the -mm tree.  Its filename was
     mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: refactor anon folio unmap in try_to_unmap_one
Date: Mon, 13 Jul 2026 05:00:47 +0000

Refactor anonymous swapbacked folio unmap to ttu_anon_swapbacked_folio(). 
While at it, rename the remaining subpage variables to page; folios have
pages, not subpages.

No functional change intended.

Link: https://lore.kernel.org/20260713050050.1017741-5-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
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

 mm/rmap.c |  115 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 47 deletions(-)

--- a/mm/rmap.c~mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -2112,6 +2112,66 @@ static bool ttu_anon_lazyfree_folio(stru
 	return true;
 }
 
+static pte_t swp_pte_prepare(swp_entry_t entry, pte_t old_pte,
+		bool anon_exclusive)
+{
+	pte_t swp_pte = swp_entry_to_pte(entry);
+
+	if (anon_exclusive)
+		swp_pte = pte_swp_mkexclusive(swp_pte);
+
+	if (likely(pte_present(old_pte))) {
+		if (pte_soft_dirty(old_pte))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_uffd(old_pte))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	} else {
+		/* Device-exclusive entry */
+		if (pte_swp_soft_dirty(old_pte))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_swp_uffd(old_pte))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	}
+
+	return swp_pte;
+}
+
+static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
+		struct folio *folio, struct page *page, unsigned long address,
+		pte_t *ptep, pte_t pteval)
+{
+	const bool anon_exclusive = folio_test_anon(folio) &&
+				    PageAnonExclusive(page);
+	swp_entry_t entry = page_swap_entry(page);
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (folio_dup_swap(folio, page) < 0)
+		return false;
+
+	/*
+	 * arch_unmap_one() is expected to be a NOP on
+	 * architectures where we could have PFN swap PTEs,
+	 * so we'll not check/care.
+	 */
+	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+		folio_put_swap(folio, page);
+		return false;
+	}
+
+	/* See folio_try_share_anon_rmap(): clear PTE first. */
+	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, page)) {
+		folio_put_swap(folio, page);
+		return false;
+	}
+
+	mm_prepare_for_swap_entries(mm);
+	dec_mm_counter(mm, MM_ANONPAGES);
+	inc_mm_counter(mm, MM_SWAPENTS);
+	set_pte_at(mm, address, ptep,
+		   swp_pte_prepare(entry, pteval, anon_exclusive));
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2120,9 +2180,9 @@ static bool try_to_unmap_one(struct foli
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	bool anon_exclusive, ret = true;
+	bool ret = true;
 	pte_t pteval;
-	struct page *subpage;
+	struct page *page;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long nr_pages = 1, end_addr;
@@ -2233,9 +2293,7 @@ static bool try_to_unmap_one(struct foli
 			pfn = softleaf_to_pfn(entry);
 		}
 
-		subpage = folio_page(folio, pfn - folio_pfn(folio));
-		anon_exclusive = folio_test_anon(folio) &&
-				 PageAnonExclusive(subpage);
+		page = folio_page(folio, pfn - folio_pfn(folio));
 
 		if (likely(pte_present(pteval))) {
 			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
@@ -2274,7 +2332,7 @@ static bool try_to_unmap_one(struct foli
 
 		/* With TTU_HWPOISON, we only expect small folios here. */
 		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
-			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
+			pteval = swp_entry_to_pte(make_hwpoison_entry(page));
 			dec_mm_counter(mm, mm_counter(folio));
 			set_pte_at(mm, address, pvmw.pte, pteval);
 		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
@@ -2291,8 +2349,6 @@ static bool try_to_unmap_one(struct foli
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			swp_entry_t entry = page_swap_entry(subpage);
-			pte_t swp_pte;
 			/*
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
@@ -2313,47 +2369,12 @@ static bool try_to_unmap_one(struct foli
 				goto finish_unmap;
 			}
 
-			if (folio_dup_swap(folio, subpage) < 0) {
+			if (!ttu_anon_swapbacked_folio(vma, folio, page, address,
+						pvmw.pte, pteval)) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
-
-			/*
-			 * arch_unmap_one() is expected to be a NOP on
-			 * architectures where we could have PFN swap PTEs,
-			 * so we'll not check/care.
-			 */
-			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				folio_put_swap(folio, subpage);
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
-
-			/* See folio_try_share_anon_rmap(): clear PTE first. */
-			if (anon_exclusive &&
-			    folio_try_share_anon_rmap_pte(folio, subpage)) {
-				folio_put_swap(folio, subpage);
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
-			mm_prepare_for_swap_entries(mm);
-			dec_mm_counter(mm, MM_ANONPAGES);
-			inc_mm_counter(mm, MM_SWAPENTS);
-			swp_pte = swp_entry_to_pte(entry);
-			if (anon_exclusive)
-				swp_pte = pte_swp_mkexclusive(swp_pte);
-			if (likely(pte_present(pteval))) {
-				if (pte_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			}
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			goto finish_unmap;
 		} else {
 			/*
 			 * This is a locked file-backed folio,
@@ -2369,7 +2390,7 @@ static bool try_to_unmap_one(struct foli
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 finish_unmap:
-		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
+		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch
mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

