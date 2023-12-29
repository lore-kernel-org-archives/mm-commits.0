Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6895F13AED
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ppeEoUXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F5AC433C8;
	Fri, 29 Dec 2023 20:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880113;
	bh=4PC9SD0rMN4KbSsgz4zZTMuUI4btEVcmZ6wzg966V6o=;
	h=Date:To:From:Subject:From;
	b=ppeEoUXzHEUQmdNB52VH42hofDbgndWPQzHJLHbZal+GyhNuJHhq4OD9Ec8NLP7z5
	 wAnRbp8QtXFc0PVBxB03Ixi3C2/KZ2xAqJBETrSArNvq5BsC47EXUrq5ppJl/XqdVK
	 iq3w/nLBUaU/uUvMYhxAf+WfUv93/FDPBEZ1iaXA=
Date: Fri, 29 Dec 2023 12:01:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-page_remove_rmap-folio_remove_rmap_pte.patch removed from -mm tree
Message-Id: <20231229200153.32F5AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: page_remove_rmap() -> folio_remove_rmap_pte()
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-page_remove_rmap-folio_remove_rmap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate_device: page_remove_rmap() -> folio_remove_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:53 +0100

Let's convert migrate_vma_collect_pmd().  While at it, perform more folio
conversion.

Link: https://lkml.kernel.org/r/20231220224504.646757-30-david@redhat.com
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

 mm/migrate_device.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-page_remove_rmap-folio_remove_rmap_pte
+++ a/mm/migrate_device.c
@@ -107,6 +107,7 @@ again:
 
 	for (; addr < end; addr += PAGE_SIZE, ptep++) {
 		unsigned long mpfn = 0, pfn;
+		struct folio *folio;
 		struct page *page;
 		swp_entry_t entry;
 		pte_t pte;
@@ -168,41 +169,43 @@ again:
 		}
 
 		/*
-		 * By getting a reference on the page we pin it and that blocks
+		 * By getting a reference on the folio we pin it and that blocks
 		 * any kind of migration. Side effect is that it "freezes" the
 		 * pte.
 		 *
-		 * We drop this reference after isolating the page from the lru
-		 * for non device page (device page are not on the lru and thus
+		 * We drop this reference after isolating the folio from the lru
+		 * for non device folio (device folio are not on the lru and thus
 		 * can't be dropped from it).
 		 */
-		get_page(page);
+		folio = page_folio(page);
+		folio_get(folio);
 
 		/*
-		 * We rely on trylock_page() to avoid deadlock between
+		 * We rely on folio_trylock() to avoid deadlock between
 		 * concurrent migrations where each is waiting on the others
-		 * page lock. If we can't immediately lock the page we fail this
+		 * folio lock. If we can't immediately lock the folio we fail this
 		 * migration as it is only best effort anyway.
 		 *
-		 * If we can lock the page it's safe to set up a migration entry
-		 * now. In the common case where the page is mapped once in a
+		 * If we can lock the folio it's safe to set up a migration entry
+		 * now. In the common case where the folio is mapped once in a
 		 * single process setting up the migration entry now is an
 		 * optimisation to avoid walking the rmap later with
 		 * try_to_migrate().
 		 */
-		if (trylock_page(page)) {
+		if (folio_trylock(folio)) {
 			bool anon_exclusive;
 			pte_t swp_pte;
 
 			flush_cache_page(vma, addr, pte_pfn(pte));
-			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
+			anon_exclusive = folio_test_anon(folio) &&
+					  PageAnonExclusive(page);
 			if (anon_exclusive) {
 				pte = ptep_clear_flush(vma, addr, ptep);
 
 				if (page_try_share_anon_rmap(page)) {
 					set_pte_at(mm, addr, ptep, pte);
-					unlock_page(page);
-					put_page(page);
+					folio_unlock(folio);
+					folio_put(folio);
 					mpfn = 0;
 					goto next;
 				}
@@ -214,7 +217,7 @@ again:
 
 			/* Set the dirty flag on the folio now the pte is gone. */
 			if (pte_dirty(pte))
-				folio_mark_dirty(page_folio(page));
+				folio_mark_dirty(folio);
 
 			/* Setup special migration page table entry */
 			if (mpfn & MIGRATE_PFN_WRITE)
@@ -248,16 +251,16 @@ again:
 
 			/*
 			 * This is like regular unmap: we remove the rmap and
-			 * drop page refcount. Page won't be freed, as we took
-			 * a reference just above.
+			 * drop the folio refcount. The folio won't be freed, as
+			 * we took a reference just above.
 			 */
-			page_remove_rmap(page, vma, false);
-			put_page(page);
+			folio_remove_rmap_pte(folio, page, vma);
+			folio_put(folio);
 
 			if (pte_present(pte))
 				unmapped++;
 		} else {
-			put_page(page);
+			folio_put(folio);
 			mpfn = 0;
 		}
 
_

Patches currently in -mm which might be from david@redhat.com are


