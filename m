Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535303C2794
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896813; cv=none; b=p7cEwoO3G/lvH7LKkbCD7aPoemKlpteWor+OTXdyOdGkxSbr8ex2qPQruqUBoqaMCpr/P4LhrHzPKIPTlRy+/H8iN0N3DOd7l9Gq0zYw03Ttzva0bwFAKI4nwfVi6q/vnleZZxJbycOzZSf05BBOAmoi8PqrVcQcWAgHnSOutoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896813; c=relaxed/simple;
	bh=70fFcXsuu11o6Xa2JotAGuIUvRcDZ62LM34n6gE2nPw=;
	h=Date:To:From:Subject:Message-Id; b=uVLE+Mi0t2rKSlQt89DYrybwWPJxWSyU6b3cjltda7TPJJlhQ4nN86KgOc9qcUPX26zFhZm/9qD5hYKu1u48GYp7lSeHtUCFkOcefvDGn8t2uwunt0Tn/hG1PM2BSNXkFQNPvXlv79gnHYGCtthiwz0uktOeKdXfWeMiMet4aFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nk+5Iyl3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nk+5Iyl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5641F00A3A;
	Wed,  5 Aug 2026 02:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896812;
	bh=ey5px5irWLTFeopp80Ut9dN00DCvGa1Oj+2leb8ECNg=;
	h=Date:To:From:Subject;
	b=nk+5Iyl3r1u+0f7M3aH4GbNPSEwtd8ReaCPOuTWA+pbgiQc2KQK9IjF+OChCeYMP2
	 +rnjoEgIHSq3G4Hq6g8fm0AasfQd2Xx0JgYiNC8eerDqnIKb+sQa/vGs1971bgrvs8
	 nXDtxwiNZvPTAvRpE9xkWlR1idYpclBvDTupFr80=
Date: Tue, 04 Aug 2026 19:26:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ryan.roberts@arm.com,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch removed from -mm tree
Message-Id: <20260805022652.1D5641F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: refactor anon folio unmap in try_to_unmap_one
has been removed from the -mm tree.  Its filename was
     mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: refactor anon folio unmap in try_to_unmap_one
Date: Thu, 30 Jul 2026 09:45:55 +0000

Refactor anonymous swapbacked folio unmap to ttu_anon_swapbacked_folio(). 
While at it, rename the remaining subpage variables to page; folios have
pages, not subpages.

No functional change intended.

Link: https://lore.kernel.org/20260730094559.418003-5-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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
 
 		/* unmap_poisoned_folio() only refs order-0 folios */
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

mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

