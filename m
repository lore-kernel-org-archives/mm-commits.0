Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565D314006
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iqBvYYGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED53C433C7;
	Fri, 29 Dec 2023 20:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880109;
	bh=Ift1Hd9BpEtFiJM05DfFf7MHM74qALYygYY0pnKRSnc=;
	h=Date:To:From:Subject:From;
	b=iqBvYYGDv3M9WlL3YVVA9+E0JLgQRDcrPQVzu7vePRUliZxZDENGPms7jJ2RRjUIv
	 5JvL3R2dXH1WOeSr0rOCJfmR43PSUl3gvGvQB0ie3aP5KK3p2aAahc+IBjsIF3gamk
	 J3WcJ0dsI8KL2eIHKL/giIKxJxC+aK9wMMpXdlkw=
Date: Fri, 29 Dec 2023 12:01:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd.patch removed from -mm tree
Message-Id: <20231229200149.1ED53C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: page_remove_rmap() -> folio_remove_rmap_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: page_remove_rmap() -> folio_remove_rmap_pmd()
Date: Wed, 20 Dec 2023 23:44:49 +0100

Let's convert zap_huge_pmd() and set_pmd_migration_entry().  While at it,
perform some more folio conversion.

Link: https://lkml.kernel.org/r/20231220224504.646757-26-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd
+++ a/mm/huge_memory.c
@@ -1898,7 +1898,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 
 		if (pmd_present(orig_pmd)) {
 			page = pmd_page(orig_pmd);
-			page_remove_rmap(page, vma, true);
+			folio_remove_rmap_pmd(page_folio(page), page, vma);
 			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
 		} else if (thp_migration_supported()) {
@@ -2433,12 +2433,13 @@ static void __split_huge_pmd_locked(stru
 			page = pfn_swap_entry_to_page(entry);
 		} else {
 			page = pmd_page(old_pmd);
-			if (!PageDirty(page) && pmd_dirty(old_pmd))
-				set_page_dirty(page);
-			if (!PageReferenced(page) && pmd_young(old_pmd))
-				SetPageReferenced(page);
-			page_remove_rmap(page, vma, true);
-			put_page(page);
+			folio = page_folio(page);
+			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
+				folio_set_dirty(folio);
+			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
+				folio_set_referenced(folio);
+			folio_remove_rmap_pmd(folio, page, vma);
+			folio_put(folio);
 		}
 		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
 		return;
@@ -2593,7 +2594,7 @@ static void __split_huge_pmd_locked(stru
 	pte_unmap(pte - 1);
 
 	if (!pmd_migration)
-		page_remove_rmap(page, vma, true);
+		folio_remove_rmap_pmd(folio, page, vma);
 	if (freeze)
 		put_page(page);
 
@@ -3536,6 +3537,7 @@ late_initcall(split_huge_pages_debugfs);
 int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
+	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma = pvmw->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address = pvmw->address;
@@ -3551,14 +3553,14 @@ int set_pmd_migration_entry(struct page_
 	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 
 	/* See page_try_share_anon_rmap(): invalidate PMD first. */
-	anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
+	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
 	if (anon_exclusive && page_try_share_anon_rmap(page)) {
 		set_pmd_at(mm, address, pvmw->pmd, pmdval);
 		return -EBUSY;
 	}
 
 	if (pmd_dirty(pmdval))
-		set_page_dirty(page);
+		folio_set_dirty(folio);
 	if (pmd_write(pmdval))
 		entry = make_writable_migration_entry(page_to_pfn(page));
 	else if (anon_exclusive)
@@ -3575,8 +3577,8 @@ int set_pmd_migration_entry(struct page_
 	if (pmd_uffd_wp(pmdval))
 		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
-	page_remove_rmap(page, vma, true);
-	put_page(page);
+	folio_remove_rmap_pmd(folio, page, vma);
+	folio_put(folio);
 	trace_set_migration_pmd(address, pmd_val(pmdswp));
 
 	return 0;
_

Patches currently in -mm which might be from david@redhat.com are


