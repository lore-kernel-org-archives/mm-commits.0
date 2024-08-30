Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B404F1C1ADA
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057428; cv=none; b=uByyM3KtX4CCzeti1kEgm4lamn6vCWHFz2+UZUZ7BaNob+Ib+SgAUcad68HyTIXHd6wOvYMI1nP7pRUTfYodVBRSSD02VqMkq+X8DwZ03t6MwlxGQWXAt43X+i8w2JMKcpn4PIju0w8B/6JfWxmsHQM+hrl5ZGqgd+iKrkYilJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057428; c=relaxed/simple;
	bh=TIPORRAFiK3w4TyVphwd4rCHsKlOdPXzsRLVnUMdTfQ=;
	h=Date:To:From:Subject:Message-Id; b=DHc2hMMaIhfnQDpgbX0iZv1OM9mA9ILwx0l974v2M4C+WiReOI2ld54v/yCHAqtjl9YUfUrivybeTNXiwASy7XC14XJjqD3UjSPnrXYT0GsU7XufQeMvauTT9u/S0bXG5VXsgXQGSIGVF0JBAv09DprBEvhJA1djTDQl4/L2uEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g68wRFSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g68wRFSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C630C4CEC2;
	Fri, 30 Aug 2024 22:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725057428;
	bh=TIPORRAFiK3w4TyVphwd4rCHsKlOdPXzsRLVnUMdTfQ=;
	h=Date:To:From:Subject:From;
	b=g68wRFSP3kGNYGFnibMus5HqcH0nKSaJLCNSCK/zX45cAe81KFmG2GkGeT/xUJezo
	 5a7zMvEOGIrhLeLYT5W6509SpDsYsla6zLb3fuqYr94SYPyE/HCWazPxtay/gTUnMH
	 fbnBnb+Nz2kTGz3T+g44e2qN9uYUrt0lggdQmYk0=
Date: Fri, 30 Aug 2024 15:37:07 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,willy@infradead.org,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,npache@redhat.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch added to mm-unstable branch
Message-Id: <20240830223708.5C630C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remap unused subpages to shared zeropage when splitting isolated thp
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm: remap unused subpages to shared zeropage when splitting isolated thp
Date: Fri, 30 Aug 2024 11:03:36 +0100

Here being unused means containing only zeros and inaccessible to
userspace.  When splitting an isolated thp under reclaim or migration, the
unused subpages can be mapped to the shared zeropage, hence saving memory.
This is particularly helpful when the internal fragmentation of a thp is
high, i.e.  it has many untouched subpages.

This is also a prerequisite for THP low utilization shrinker which will be
introduced in later patches, where underutilized THPs are split, and the
zero-filled pages are freed saving memory.

Link: https://lkml.kernel.org/r/20240830100438.3623486-3-usamaarif642@gmail.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Tested-by: Shuang Zhai <zhais@google.com>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    7 +++
 mm/huge_memory.c     |    8 ++--
 mm/migrate.c         |   72 +++++++++++++++++++++++++++++++++++------
 mm/migrate_device.c  |    4 +-
 4 files changed, 75 insertions(+), 16 deletions(-)

--- a/include/linux/rmap.h~mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp
+++ a/include/linux/rmap.h
@@ -745,7 +745,12 @@ int folio_mkclean(struct folio *);
 int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		      struct vm_area_struct *vma);
 
-void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked);
+enum rmp_flags {
+	RMP_LOCKED		= 1 << 0,
+	RMP_USE_SHARED_ZEROPAGE	= 1 << 1,
+};
+
+void remove_migration_ptes(struct folio *src, struct folio *dst, int flags);
 
 /*
  * rmap_walk_control: To control rmap traversing for specific needs
--- a/mm/huge_memory.c~mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp
+++ a/mm/huge_memory.c
@@ -3020,7 +3020,7 @@ bool unmap_huge_pmd_locked(struct vm_are
 	return false;
 }
 
-static void remap_page(struct folio *folio, unsigned long nr)
+static void remap_page(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
 
@@ -3028,7 +3028,7 @@ static void remap_page(struct folio *fol
 	if (!folio_test_anon(folio))
 		return;
 	for (;;) {
-		remove_migration_ptes(folio, folio, true);
+		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
 		i += folio_nr_pages(folio);
 		if (i >= nr)
 			break;
@@ -3240,7 +3240,7 @@ static void __split_huge_page(struct pag
 
 	if (nr_dropped)
 		shmem_uncharge(folio->mapping->host, nr_dropped);
-	remap_page(folio, nr);
+	remap_page(folio, nr, PageAnon(head) ? RMP_USE_SHARED_ZEROPAGE : 0);
 
 	/*
 	 * set page to its compound_head when split to non order-0 pages, so
@@ -3542,7 +3542,7 @@ fail:
 		if (mapping)
 			xas_unlock(&xas);
 		local_irq_enable();
-		remap_page(folio, folio_nr_pages(folio));
+		remap_page(folio, folio_nr_pages(folio), 0);
 		ret = -EAGAIN;
 	}
 
--- a/mm/migrate.c~mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp
+++ a/mm/migrate.c
@@ -204,13 +204,57 @@ bool isolate_folio_to_list(struct folio
 	return true;
 }
 
+static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
+					  struct folio *folio,
+					  unsigned long idx)
+{
+	struct page *page = folio_page(folio, idx);
+	bool contains_data;
+	pte_t newpte;
+	void *addr;
+
+	VM_BUG_ON_PAGE(PageCompound(page), page);
+	VM_BUG_ON_PAGE(!PageAnon(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(pte_present(*pvmw->pte), page);
+
+	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
+	    mm_forbids_zeropage(pvmw->vma->vm_mm))
+		return false;
+
+	/*
+	 * The pmd entry mapping the old thp was flushed and the pte mapping
+	 * this subpage has been non present. If the subpage is only zero-filled
+	 * then map it to the shared zeropage.
+	 */
+	addr = kmap_local_page(page);
+	contains_data = memchr_inv(addr, 0, PAGE_SIZE);
+	kunmap_local(addr);
+
+	if (contains_data)
+		return false;
+
+	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
+					pvmw->vma->vm_page_prot));
+	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
+
+	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
+	return true;
+}
+
+struct rmap_walk_arg {
+	struct folio *folio;
+	bool map_unused_to_zeropage;
+};
+
 /*
  * Restore a potential migration pte to a working pte entry
  */
 static bool remove_migration_pte(struct folio *folio,
-		struct vm_area_struct *vma, unsigned long addr, void *old)
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
 {
-	DEFINE_FOLIO_VMA_WALK(pvmw, old, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
+	struct rmap_walk_arg *rmap_walk_arg = arg;
+	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
@@ -234,6 +278,9 @@ static bool remove_migration_pte(struct
 			continue;
 		}
 #endif
+		if (rmap_walk_arg->map_unused_to_zeropage &&
+		    try_to_map_unused_to_zeropage(&pvmw, folio, idx))
+			continue;
 
 		folio_get(folio);
 		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
@@ -312,14 +359,21 @@ static bool remove_migration_pte(struct
  * Get rid of all migration entries and replace them by
  * references to the indicated page.
  */
-void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked)
+void remove_migration_ptes(struct folio *src, struct folio *dst, int flags)
 {
+	struct rmap_walk_arg rmap_walk_arg = {
+		.folio = src,
+		.map_unused_to_zeropage = flags & RMP_USE_SHARED_ZEROPAGE,
+	};
+
 	struct rmap_walk_control rwc = {
 		.rmap_one = remove_migration_pte,
-		.arg = src,
+		.arg = &rmap_walk_arg,
 	};
 
-	if (locked)
+	VM_BUG_ON_FOLIO((flags & RMP_USE_SHARED_ZEROPAGE) && (src != dst), src);
+
+	if (flags & RMP_LOCKED)
 		rmap_walk_locked(dst, &rwc);
 	else
 		rmap_walk(dst, &rwc);
@@ -934,7 +988,7 @@ static int writeout(struct address_space
 	 * At this point we know that the migration attempt cannot
 	 * be successful.
 	 */
-	remove_migration_ptes(folio, folio, false);
+	remove_migration_ptes(folio, folio, 0);
 
 	rc = mapping->a_ops->writepage(&folio->page, &wbc);
 
@@ -1098,7 +1152,7 @@ static void migrate_folio_undo_src(struc
 				   struct list_head *ret)
 {
 	if (page_was_mapped)
-		remove_migration_ptes(src, src, false);
+		remove_migration_ptes(src, src, 0);
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)
 		put_anon_vma(anon_vma);
@@ -1336,7 +1390,7 @@ static int migrate_folio_move(free_folio
 		lru_add_drain();
 
 	if (old_page_state & PAGE_WAS_MAPPED)
-		remove_migration_ptes(src, dst, false);
+		remove_migration_ptes(src, dst, 0);
 
 out_unlock_both:
 	folio_unlock(dst);
@@ -1474,7 +1528,7 @@ static int unmap_and_move_huge_page(new_
 
 	if (page_was_mapped)
 		remove_migration_ptes(src,
-			rc == MIGRATEPAGE_SUCCESS ? dst : src, false);
+			rc == MIGRATEPAGE_SUCCESS ? dst : src, 0);
 
 unlock_put_anon:
 	folio_unlock(dst);
--- a/mm/migrate_device.c~mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp
+++ a/mm/migrate_device.c
@@ -424,7 +424,7 @@ static unsigned long migrate_device_unma
 			continue;
 
 		folio = page_folio(page);
-		remove_migration_ptes(folio, folio, false);
+		remove_migration_ptes(folio, folio, 0);
 
 		src_pfns[i] = 0;
 		folio_unlock(folio);
@@ -840,7 +840,7 @@ void migrate_device_finalize(unsigned lo
 			dst = src;
 		}
 
-		remove_migration_ptes(src, dst, false);
+		remove_migration_ptes(src, dst, 0);
 		folio_unlock(src);
 
 		if (folio_is_zone_device(src))
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch
mm-swap-remove-boilerplate-fix.patch
mm-hugetlb_vmemmap-batch-hvo-work-when-demoting.patch
mm-contig_alloc-support-__gfp_comp.patch
mm-cma-add-cma_allocfree_folio.patch
mm-cma-add-cma_allocfree_folio-fix.patch
mm-hugetlb-use-__gfp_comp-for-gigantic-folios.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

