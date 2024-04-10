Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8497F181BBF
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712783333; cv=none; b=TWSkAbtp2BUKpKgNrBDXtyobYZb/WrtEpsv+YOPrYWhbOmjHFZvRP9ao56F7XTS/U6zanLhcTefxx150AS0SW40my192QCWIQVCSEWpvzUHeJInJ2wuEyFpaR9uuRLhqTKCnxt/dkw5dbuAZ/NEN83txJlIjhphqhEa2yBuTS5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712783333; c=relaxed/simple;
	bh=ZEdbR6x4eb5iLrD2pNssYFqz1xKILvxZwv3fPKKq4R4=;
	h=Date:To:From:Subject:Message-Id; b=LeJGwCOPr3OcUOhhsug9a3XggQT9IY/lnLI/Ur7Xnd81RB0IitMsdYInh8dyb7pNxMAFJjmITUblI+snM9YTUYuyXO6PxJ0kifLct3esLcnYLeyjrbJWMQ4tZ8Adnz29lVU6ldfkOJGyv0eRcZcDxKZD6WifnLMkXM5ErLsu4bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XoqCvESJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XoqCvESJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA49C433C7;
	Wed, 10 Apr 2024 21:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712783333;
	bh=ZEdbR6x4eb5iLrD2pNssYFqz1xKILvxZwv3fPKKq4R4=;
	h=Date:To:From:Subject:From;
	b=XoqCvESJ1A1fWEr2CP417+2FG87ME97Q/tmICzt/9XQ2Wh8uYlswMsA6lYOyo6JAA
	 NZnYqb1iNOWxkocLmH9eiKZAP4n8vu+pGIfjrWAuKufe92U1FMQcCkJXi7j1MEtw3R
	 2vMDBOnIMsqPoiMDUuFQPyA8WjTlFeqNAlJHBJU4=
Date: Wed, 10 Apr 2024 14:08:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,v-songbaohua@oppo.com,ryan.roberts@arm.com,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,hanchuanhua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-entirely-map-large-folios-found-in-swapcache.patch added to mm-unstable branch
Message-Id: <20240410210852.DFA49C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: entirely map large folios found in swapcache
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-entirely-map-large-folios-found-in-swapcache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-entirely-map-large-folios-found-in-swapcache.patch

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
From: Chuanhua Han <hanchuanhua@oppo.com>
Subject: mm: swap: entirely map large folios found in swapcache
Date: Tue, 9 Apr 2024 20:26:30 +1200

When a large folio is found in the swapcache, the current implementation
requires calling do_swap_page() nr_pages times, resulting in nr_pages page
faults.  This patch opts to map the entire large folio at once to minimize
page faults.  Additionally, redundant checks and early exits for ARM64 MTE
restoring are removed.

Link: https://lkml.kernel.org/r/20240409082631.187483-5-21cnbao@gmail.com
Signed-off-by: Chuanhua Han <hanchuanhua@oppo.com>
Co-developed-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   64 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 12 deletions(-)

--- a/mm/memory.c~mm-swap-entirely-map-large-folios-found-in-swapcache
+++ a/mm/memory.c
@@ -3944,6 +3944,10 @@ vm_fault_t do_swap_page(struct vm_fault
 	pte_t pte;
 	vm_fault_t ret = 0;
 	void *shadow = NULL;
+	int nr_pages = 1;
+	unsigned long start_address = vmf->address;
+	pte_t *start_pte = vmf->pte;
+	bool any_swap_shared = false;
 
 	if (!pte_unmap_same(vmf))
 		goto out;
@@ -4134,6 +4138,35 @@ vm_fault_t do_swap_page(struct vm_fault
 	 */
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 			&vmf->ptl);
+
+	/* We hit large folios in swapcache */
+	if (start_pte && folio_test_large(folio) && folio_test_swapcache(folio)) {
+		int nr = folio_nr_pages(folio);
+		int idx = folio_page_idx(folio, page);
+		unsigned long folio_start = vmf->address - idx * PAGE_SIZE;
+		unsigned long folio_end = folio_start + nr * PAGE_SIZE;
+		pte_t *folio_ptep;
+		pte_t folio_pte;
+
+		if (unlikely(folio_start < max(vmf->address & PMD_MASK, vma->vm_start)))
+			goto check_pte;
+		if (unlikely(folio_end > pmd_addr_end(vmf->address, vma->vm_end)))
+			goto check_pte;
+
+		folio_ptep = vmf->pte - idx;
+		folio_pte = ptep_get(folio_ptep);
+		if (!is_swap_pte(folio_pte) || non_swap_entry(pte_to_swp_entry(folio_pte)) ||
+		    swap_pte_batch(folio_ptep, nr, folio_pte, &any_swap_shared) != nr)
+			goto check_pte;
+
+		start_address = folio_start;
+		start_pte = folio_ptep;
+		nr_pages = nr;
+		entry = folio->swap;
+		page = &folio->page;
+	}
+
+check_pte:
 	if (unlikely(!vmf->pte || !pte_same(ptep_get(vmf->pte), vmf->orig_pte)))
 		goto out_nomap;
 
@@ -4187,6 +4220,10 @@ vm_fault_t do_swap_page(struct vm_fault
 			 */
 			exclusive = false;
 		}
+
+		/* Reuse the whole large folio iff all entries are exclusive */
+		if (nr_pages > 1 && any_swap_shared)
+			exclusive = false;
 	}
 
 	/*
@@ -4201,12 +4238,14 @@ vm_fault_t do_swap_page(struct vm_fault
 	 * We're already holding a reference on the page but haven't mapped it
 	 * yet.
 	 */
-	swap_free(entry);
+	swap_free_nr(entry, nr_pages);
 	if (should_try_to_free_swap(folio, vma, vmf->flags))
 		folio_free_swap(folio);
 
-	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
-	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
+	folio_ref_add(folio, nr_pages - 1);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
+	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
+
 	pte = mk_pte(page, vma->vm_page_prot);
 
 	/*
@@ -4216,33 +4255,34 @@ vm_fault_t do_swap_page(struct vm_fault
 	 * exclusivity.
 	 */
 	if (!folio_test_ksm(folio) &&
-	    (exclusive || folio_ref_count(folio) == 1)) {
+	    (exclusive || (folio_ref_count(folio) == nr_pages &&
+			   folio_nr_pages(folio) == nr_pages))) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 			vmf->flags &= ~FAULT_FLAG_WRITE;
 		}
 		rmap_flags |= RMAP_EXCLUSIVE;
 	}
-	flush_icache_page(vma, page);
+	flush_icache_pages(vma, page, nr_pages);
 	if (pte_swp_soft_dirty(vmf->orig_pte))
 		pte = pte_mksoft_dirty(pte);
 	if (pte_swp_uffd_wp(vmf->orig_pte))
 		pte = pte_mkuffd_wp(pte);
-	vmf->orig_pte = pte;
 
 	/* ksm created a completely new copy */
 	if (unlikely(folio != swapcache && swapcache)) {
-		folio_add_new_anon_rmap(folio, vma, vmf->address);
+		folio_add_new_anon_rmap(folio, vma, start_address);
 		folio_add_lru_vma(folio, vma);
 	} else {
-		folio_add_anon_rmap_pte(folio, page, vma, vmf->address,
-					rmap_flags);
+		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, start_address,
+					 rmap_flags);
 	}
 
 	VM_BUG_ON(!folio_test_anon(folio) ||
 			(pte_write(pte) && !PageAnonExclusive(page)));
-	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
-	arch_do_swap_page(vma->vm_mm, vma, vmf->address, pte, vmf->orig_pte);
+	set_ptes(vma->vm_mm, start_address, start_pte, pte, nr_pages);
+	vmf->orig_pte = ptep_get(vmf->pte);
+	arch_do_swap_page(vma->vm_mm, vma, start_address, pte, pte);
 
 	folio_unlock(folio);
 	if (folio != swapcache && swapcache) {
@@ -4266,7 +4306,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	}
 
 	/* No need to invalidate - it was non-present before */
-	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
+	update_mmu_cache_range(vmf, vma, start_address, start_pte, nr_pages);
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
_

Patches currently in -mm which might be from hanchuanhua@oppo.com are

mm-swap-introduce-swap_free_nr-for-batched-swap_free.patch
mm-swap-make-should_try_to_free_swap-support-large-folio.patch
mm-swap-entirely-map-large-folios-found-in-swapcache.patch

