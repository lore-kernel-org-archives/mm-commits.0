Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06AB143722
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 19:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723058893; cv=none; b=gy3qPM6+WXkew82tndxre8KiPh1e1CjU97AtaG1a8313OUXSKtzSKkN/NTjaD4TtPlOqOy8XX2WqzSKF10txg0HHKiZ46LGxJ7i2idLjrc8gXhf5xBHJHwmfqJhLHpqOXAXmrkIJVX4507trCf5fiyeygw3ei80KlIh5VNw+ICE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723058893; c=relaxed/simple;
	bh=/6LoTqfqAx89JoH5YtChS3dbEompBCocObchJKmtmqw=;
	h=Date:To:From:Subject:Message-Id; b=o7aTDUeuFnV7yOVLAyyiHi69AXpZeT6FMqvXSW0XFJ6SavM7wnEv7Q27eSY1N8+SsOWBA/8rpvmLOhBoCDGvbm6I/rWBuSJa6RBJVbS454OpeT/TAqRaVza9SlFzpTaJu09i6Gi7QJI3q7EePETFBdV6ZT+JgESKbiX/bs4cGuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sZD4n84D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sZD4n84D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8F2C32781;
	Wed,  7 Aug 2024 19:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723058892;
	bh=/6LoTqfqAx89JoH5YtChS3dbEompBCocObchJKmtmqw=;
	h=Date:To:From:Subject:From;
	b=sZD4n84Dd9LMrSmWcOtBb4nV6SkG1AEHRObduPf+V+k2Q6ZphakM/s4lMlAve2mZ9
	 oZUeRmJBcKpYP8HA+uu75prfr8+n8AXIpa1x11d4PRjE2D4+pR+jC7kUBJ9yKV/yDo
	 sA6F8sWoRlO1kvIo1cO92clqZCBP77Del550Gv2I=
Date: Wed, 07 Aug 2024 12:28:11 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,willy@infradead.org,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch added to mm-unstable branch
Message-Id: <20240807192812.4D8F2C32781@smtp.kernel.org>
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
Date: Wed, 7 Aug 2024 14:46:47 +0100

Here being unused means containing only zeros and inaccessible to
userspace.  When splitting an isolated thp under reclaim or migration, the
unused subpages can be mapped to the shared zeropage, hence saving memory.
This is particularly helpful when the internal fragmentation of a thp is
high, i.e.  it has many untouched subpages.

This is also a prerequisite for THP low utilization shrinker which will be
introduced in later patches, where underutilized THPs are split, and the
zero-filled pages are freed saving memory.

Link: https://lkml.kernel.org/r/20240807134732.3292797-3-usamaarif642@gmail.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Tested-by: Shuang Zhai <zhais@google.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 +
 mm/huge_memory.c     |    8 ++--
 mm/migrate.c         |   70 ++++++++++++++++++++++++++++++++++++-----
 mm/migrate_device.c  |    4 +-
 4 files changed, 70 insertions(+), 15 deletions(-)

--- a/include/linux/rmap.h~mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp
+++ a/include/linux/rmap.h
@@ -745,7 +745,8 @@ int folio_mkclean(struct folio *);
 int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		      struct vm_area_struct *vma);
 
-void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked);
+void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked,
+			   bool map_unused_to_zeropage);
 
 /*
  * rmap_walk_control: To control rmap traversing for specific needs
--- a/mm/huge_memory.c~mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp
+++ a/mm/huge_memory.c
@@ -2776,7 +2776,7 @@ bool unmap_huge_pmd_locked(struct vm_are
 	return false;
 }
 
-static void remap_page(struct folio *folio, unsigned long nr)
+static void remap_page(struct folio *folio, unsigned long nr, bool map_unused_to_zeropage)
 {
 	int i = 0;
 
@@ -2784,7 +2784,7 @@ static void remap_page(struct folio *fol
 	if (!folio_test_anon(folio))
 		return;
 	for (;;) {
-		remove_migration_ptes(folio, folio, true);
+		remove_migration_ptes(folio, folio, true, map_unused_to_zeropage);
 		i += folio_nr_pages(folio);
 		if (i >= nr)
 			break;
@@ -2994,7 +2994,7 @@ static void __split_huge_page(struct pag
 
 	if (nr_dropped)
 		shmem_uncharge(folio->mapping->host, nr_dropped);
-	remap_page(folio, nr);
+	remap_page(folio, nr, PageAnon(head));
 
 	/*
 	 * set page to its compound_head when split to non order-0 pages, so
@@ -3289,7 +3289,7 @@ fail:
 		if (mapping)
 			xas_unlock(&xas);
 		local_irq_enable();
-		remap_page(folio, folio_nr_pages(folio));
+		remap_page(folio, folio_nr_pages(folio), false);
 		ret = -EAGAIN;
 	}
 
--- a/mm/migrate.c~mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp
+++ a/mm/migrate.c
@@ -178,13 +178,56 @@ void putback_movable_pages(struct list_h
 	}
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
+	if (PageMlocked(page) || (pvmw->vma->vm_flags & VM_LOCKED))
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
+	if (contains_data || mm_forbids_zeropage(pvmw->vma->vm_mm))
+		return false;
+
+	newpte = pte_mkspecial(pfn_pte(page_to_pfn(ZERO_PAGE(pvmw->address)),
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
@@ -208,6 +251,9 @@ static bool remove_migration_pte(struct
 			continue;
 		}
 #endif
+		if (rmap_walk_arg->map_unused_to_zeropage &&
+		    try_to_map_unused_to_zeropage(&pvmw, folio, idx))
+			continue;
 
 		folio_get(folio);
 		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
@@ -286,13 +332,21 @@ static bool remove_migration_pte(struct
  * Get rid of all migration entries and replace them by
  * references to the indicated page.
  */
-void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked)
+void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked,
+			   bool map_unused_to_zeropage)
 {
+	struct rmap_walk_arg rmap_walk_arg = {
+		.folio = src,
+		.map_unused_to_zeropage = map_unused_to_zeropage,
+	};
+
 	struct rmap_walk_control rwc = {
 		.rmap_one = remove_migration_pte,
-		.arg = src,
+		.arg = &rmap_walk_arg,
 	};
 
+	VM_BUG_ON_FOLIO(map_unused_to_zeropage && src != dst, src);
+
 	if (locked)
 		rmap_walk_locked(dst, &rwc);
 	else
@@ -905,7 +959,7 @@ static int writeout(struct address_space
 	 * At this point we know that the migration attempt cannot
 	 * be successful.
 	 */
-	remove_migration_ptes(folio, folio, false);
+	remove_migration_ptes(folio, folio, false, false);
 
 	rc = mapping->a_ops->writepage(&folio->page, &wbc);
 
@@ -1069,7 +1123,7 @@ static void migrate_folio_undo_src(struc
 				   struct list_head *ret)
 {
 	if (page_was_mapped)
-		remove_migration_ptes(src, src, false);
+		remove_migration_ptes(src, src, false, false);
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)
 		put_anon_vma(anon_vma);
@@ -1307,7 +1361,7 @@ static int migrate_folio_move(free_folio
 		lru_add_drain();
 
 	if (old_page_state & PAGE_WAS_MAPPED)
-		remove_migration_ptes(src, dst, false);
+		remove_migration_ptes(src, dst, false, false);
 
 out_unlock_both:
 	folio_unlock(dst);
@@ -1445,7 +1499,7 @@ static int unmap_and_move_huge_page(new_
 
 	if (page_was_mapped)
 		remove_migration_ptes(src,
-			rc == MIGRATEPAGE_SUCCESS ? dst : src, false);
+			rc == MIGRATEPAGE_SUCCESS ? dst : src, false, false);
 
 unlock_put_anon:
 	folio_unlock(dst);
--- a/mm/migrate_device.c~mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp
+++ a/mm/migrate_device.c
@@ -424,7 +424,7 @@ static unsigned long migrate_device_unma
 			continue;
 
 		folio = page_folio(page);
-		remove_migration_ptes(folio, folio, false);
+		remove_migration_ptes(folio, folio, false, false);
 
 		src_pfns[i] = 0;
 		folio_unlock(folio);
@@ -837,7 +837,7 @@ void migrate_device_finalize(unsigned lo
 
 		src = page_folio(page);
 		dst = page_folio(newpage);
-		remove_migration_ptes(src, dst, false);
+		remove_migration_ptes(src, dst, false, false);
 		folio_unlock(src);
 
 		if (is_zone_device_page(page))
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch
mm-swap-remove-boilerplate-fix.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

