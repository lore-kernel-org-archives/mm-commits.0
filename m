Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB4A522A
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717010446; cv=none; b=lkrhdLjSrt04bfePFfqAfzqRYj4uFSexBjVA4yfY4apcGbD1jiRT2vhWOauZsOFKBfJ6odOJaAq8lg5ZXMPWcTztEljAjVokiZR9rW41GfMIFNkNeFSMtRA/it1uGKqoLO/NfTeBmAQaB5kpYDht/8sSR9jcjzN4XxJ+0k8xQiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717010446; c=relaxed/simple;
	bh=ReW2tkOZlnhI8AXRLcLQMxXjCZfaGGe4vsEDkrXyKQ0=;
	h=Date:To:From:Subject:Message-Id; b=nAhvtuvi8EyCNceyc9CeknBVAUaMcV2Il2Rq5+R98VxBwtXeYUgOX622XopxI5YtymF6G79f6Jf8XljBf/ITAtzCMV18k8y4QZa8to+/7SMtKdRrawm6FRnX1r4KfRkvBkXHOAgHGmUaCZW6gUzrT7gpn7VSF+jRZxszWsXeAEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VPSdo1ro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VPSdo1ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E91EC113CC;
	Wed, 29 May 2024 19:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717010445;
	bh=ReW2tkOZlnhI8AXRLcLQMxXjCZfaGGe4vsEDkrXyKQ0=;
	h=Date:To:From:Subject:From;
	b=VPSdo1roGNGVrAr3tVwiJY9dZrmgUB06R1qA9yRrb+H3nq70IS3ZNoxoLhMNQH82I
	 za+3kmN6naOHQI4ObFKllyxLIGUNCNKLYwQtUINpIbdecEYgr5ZBGOMJrwkicxKjZ+
	 pRG8DP62xoK7QGQUb+uzfCb+r0J660TYFnQQ5m84=
Date: Wed, 29 May 2024 12:20:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,v-songbaohua@oppo.com,surenb@google.com,ryan.roberts@arm.com,rafael@kernel.org,pavel@ucw.cz,len.brown@intel.com,khalid.aziz@oracle.com,kasong@tencent.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,davem@davemloft.net,chrisl@kernel.org,baolin.wang@linux.alibaba.com,andreas@gaisler.com,hanchuanhua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-entirely-map-large-folios-found-in-swapcache.patch added to mm-unstable branch
Message-Id: <20240529192045.7E91EC113CC@smtp.kernel.org>
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
Date: Wed, 29 May 2024 20:28:24 +1200

When a large folio is found in the swapcache, the current implementation
requires calling do_swap_page() nr_pages times, resulting in nr_pages page
faults.  This patch opts to map the entire large folio at once to minimize
page faults.  Additionally, redundant checks and early exits for ARM64 MTE
restoring are removed.

Link: https://lkml.kernel.org/r/20240529082824.150954-7-21cnbao@gmail.com
Signed-off-by: Chuanhua Han <hanchuanhua@oppo.com>
Co-developed-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   59 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 11 deletions(-)

--- a/mm/memory.c~mm-swap-entirely-map-large-folios-found-in-swapcache
+++ a/mm/memory.c
@@ -4016,6 +4016,10 @@ vm_fault_t do_swap_page(struct vm_fault
 	pte_t pte;
 	vm_fault_t ret = 0;
 	void *shadow = NULL;
+	int nr_pages;
+	unsigned long page_idx;
+	unsigned long address;
+	pte_t *ptep;
 
 	if (!pte_unmap_same(vmf))
 		goto out;
@@ -4214,6 +4218,38 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out_nomap;
 	}
 
+	nr_pages = 1;
+	page_idx = 0;
+	address = vmf->address;
+	ptep = vmf->pte;
+	if (folio_test_large(folio) && folio_test_swapcache(folio)) {
+		int nr = folio_nr_pages(folio);
+		unsigned long idx = folio_page_idx(folio, page);
+		unsigned long folio_start = address - idx * PAGE_SIZE;
+		unsigned long folio_end = folio_start + nr * PAGE_SIZE;
+		pte_t *folio_ptep;
+		pte_t folio_pte;
+
+		if (unlikely(folio_start < max(address & PMD_MASK, vma->vm_start)))
+			goto check_folio;
+		if (unlikely(folio_end > pmd_addr_end(address, vma->vm_end)))
+			goto check_folio;
+
+		folio_ptep = vmf->pte - idx;
+		folio_pte = ptep_get(folio_ptep);
+		if (!pte_same(folio_pte, pte_move_swp_offset(vmf->orig_pte, -idx)) ||
+		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
+			goto check_folio;
+
+		page_idx = idx;
+		address = folio_start;
+		ptep = folio_ptep;
+		nr_pages = nr;
+		entry = folio->swap;
+		page = &folio->page;
+	}
+
+check_folio:
 	/*
 	 * PG_anon_exclusive reuses PG_mappedtodisk for anon pages. A swap pte
 	 * must never point at an anonymous page in the swapcache that is
@@ -4273,12 +4309,12 @@ vm_fault_t do_swap_page(struct vm_fault
 	 * We're already holding a reference on the page but haven't mapped it
 	 * yet.
 	 */
-	swap_free(entry);
+	swap_free_nr(entry, nr_pages);
 	if (should_try_to_free_swap(folio, vma, vmf->flags))
 		folio_free_swap(folio);
 
-	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
-	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
+	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
 	pte = mk_pte(page, vma->vm_page_prot);
 
 	/*
@@ -4295,27 +4331,28 @@ vm_fault_t do_swap_page(struct vm_fault
 		}
 		rmap_flags |= RMAP_EXCLUSIVE;
 	}
-	flush_icache_page(vma, page);
+	folio_ref_add(folio, nr_pages - 1);
+	flush_icache_pages(vma, page, nr_pages);
 	if (pte_swp_soft_dirty(vmf->orig_pte))
 		pte = pte_mksoft_dirty(pte);
 	if (pte_swp_uffd_wp(vmf->orig_pte))
 		pte = pte_mkuffd_wp(pte);
-	vmf->orig_pte = pte;
+	vmf->orig_pte = pte_advance_pfn(pte, page_idx);
 
 	/* ksm created a completely new copy */
 	if (unlikely(folio != swapcache && swapcache)) {
-		folio_add_new_anon_rmap(folio, vma, vmf->address);
+		folio_add_new_anon_rmap(folio, vma, address);
 		folio_add_lru_vma(folio, vma);
 	} else {
-		folio_add_anon_rmap_pte(folio, page, vma, vmf->address,
+		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
 					rmap_flags);
 	}
 
 	VM_BUG_ON(!folio_test_anon(folio) ||
 			(pte_write(pte) && !PageAnonExclusive(page)));
-	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
-	arch_do_swap_page_nr(vma->vm_mm, vma, vmf->address,
-			pte, vmf->orig_pte, 1);
+	set_ptes(vma->vm_mm, address, ptep, pte, nr_pages);
+	arch_do_swap_page_nr(vma->vm_mm, vma, address,
+			pte, pte, nr_pages);
 
 	folio_unlock(folio);
 	if (folio != swapcache && swapcache) {
@@ -4339,7 +4376,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	}
 
 	/* No need to invalidate - it was non-present before */
-	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
+	update_mmu_cache_range(vmf, vma, address, ptep, nr_pages);
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
_

Patches currently in -mm which might be from hanchuanhua@oppo.com are

mm-swap-introduce-swap_free_nr-for-batched-swap_free.patch
mm-swap-make-should_try_to_free_swap-support-large-folio.patch
mm-swap-entirely-map-large-folios-found-in-swapcache.patch

