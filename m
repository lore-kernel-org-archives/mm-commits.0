Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1DB14283
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SVuEBLER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673DFC433C7;
	Fri, 29 Dec 2023 20:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880118;
	bh=XRUKWd9o+6BgTP1wkFr1B/lOOYiA6Uii0WWpMYNwLQQ=;
	h=Date:To:From:Subject:From;
	b=SVuEBLERRzGM/eF+QRVEZ6mbThOGIZsfP1aK1MhdgiUJbAbQydJf95Fe11AMbVDlF
	 mYjMZMsyZ12LXiw++/Vo84bw9Sr5Q2mMoJHjX5jbeE90urYTPgat8sL1DNaMpy5COu
	 pVPznnFAeFO3EIKlbZQ0SWAeYuYLHRCj7z/E4xNY=
Date: Fri, 29 Dec 2023 12:01:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-introduce-folio_try_dup_anon_rmap_.patch removed from -mm tree
Message-Id: <20231229200158.673DFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: introduce folio_try_dup_anon_rmap_[pte|ptes|pmd]()
has been removed from the -mm tree.  Its filename was
     mm-rmap-introduce-folio_try_dup_anon_rmap_.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: introduce folio_try_dup_anon_rmap_[pte|ptes|pmd]()
Date: Wed, 20 Dec 2023 23:44:58 +0100

The last user of page_needs_cow_for_dma() and __page_dup_rmap() are gone,
remove them.

Add folio_try_dup_anon_rmap_ptes() right away, we want to perform rmap
baching during fork() soon.

Link: https://lkml.kernel.org/r/20231220224504.646757-35-david@redhat.com
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

 include/linux/mm.h   |    6 -
 include/linux/rmap.h |  150 ++++++++++++++++++++++++++++-------------
 2 files changed, 106 insertions(+), 50 deletions(-)

--- a/include/linux/mm.h~mm-rmap-introduce-folio_try_dup_anon_rmap_
+++ a/include/linux/mm.h
@@ -1975,12 +1975,6 @@ static inline bool folio_needs_cow_for_d
 	return folio_maybe_dma_pinned(folio);
 }
 
-static inline bool page_needs_cow_for_dma(struct vm_area_struct *vma,
-					  struct page *page)
-{
-	return folio_needs_cow_for_dma(vma, page_folio(page));
-}
-
 /**
  * is_zero_page - Query if a page is a zero page
  * @page: The page to query
--- a/include/linux/rmap.h~mm-rmap-introduce-folio_try_dup_anon_rmap_
+++ a/include/linux/rmap.h
@@ -362,68 +362,130 @@ static inline void folio_dup_file_rmap_p
 #endif
 }
 
-static inline void __page_dup_rmap(struct page *page, bool compound)
+static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
+		struct page *page, int nr_pages, struct vm_area_struct *src_vma,
+		enum rmap_level level)
 {
-	VM_WARN_ON(folio_test_hugetlb(page_folio(page)));
+	bool maybe_pinned;
+	int i;
 
-	if (compound) {
-		struct folio *folio = (struct folio *)page;
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
-		VM_BUG_ON_PAGE(compound && !PageHead(page), page);
+	/*
+	 * If this folio may have been pinned by the parent process,
+	 * don't allow to duplicate the mappings but instead require to e.g.,
+	 * copy the subpage immediately for the child so that we'll always
+	 * guarantee the pinned folio won't be randomly replaced in the
+	 * future on write faults.
+	 */
+	maybe_pinned = likely(!folio_is_device_private(folio)) &&
+		       unlikely(folio_needs_cow_for_dma(src_vma, folio));
+
+	/*
+	 * No need to check+clear for already shared PTEs/PMDs of the
+	 * folio. But if any page is PageAnonExclusive, we must fallback to
+	 * copying if the folio maybe pinned.
+	 */
+	switch (level) {
+	case RMAP_LEVEL_PTE:
+		if (unlikely(maybe_pinned)) {
+			for (i = 0; i < nr_pages; i++)
+				if (PageAnonExclusive(page + i))
+					return -EBUSY;
+		}
+		do {
+			if (PageAnonExclusive(page))
+				ClearPageAnonExclusive(page);
+			atomic_inc(&page->_mapcount);
+		} while (page++, --nr_pages > 0);
+		break;
+	case RMAP_LEVEL_PMD:
+		if (PageAnonExclusive(page)) {
+			if (unlikely(maybe_pinned))
+				return -EBUSY;
+			ClearPageAnonExclusive(page);
+		}
 		atomic_inc(&folio->_entire_mapcount);
-	} else {
-		atomic_inc(&page->_mapcount);
+		break;
 	}
+	return 0;
+}
+
+/**
+ * folio_try_dup_anon_rmap_ptes - try duplicating PTE mappings of a page range
+ *				  of a folio
+ * @folio:	The folio to duplicate the mappings of
+ * @page:	The first page to duplicate the mappings of
+ * @nr_pages:	The number of pages of which the mapping will be duplicated
+ * @src_vma:	The vm area from which the mappings are duplicated
+ *
+ * The page range of the folio is defined by [page, page + nr_pages)
+ *
+ * The caller needs to hold the page table lock and the
+ * vma->vma_mm->write_protect_seq.
+ *
+ * Duplicating the mappings can only fail if the folio may be pinned; device
+ * private folios cannot get pinned and consequently this function cannot fail
+ * for them.
+ *
+ * If duplicating the mappings succeeded, the duplicated PTEs have to be R/O in
+ * the parent and the child. They must *not* be writable after this call
+ * succeeded.
+ *
+ * Returns 0 if duplicating the mappings succeeded. Returns -EBUSY otherwise.
+ */
+static inline int folio_try_dup_anon_rmap_ptes(struct folio *folio,
+		struct page *page, int nr_pages, struct vm_area_struct *src_vma)
+{
+	return __folio_try_dup_anon_rmap(folio, page, nr_pages, src_vma,
+					 RMAP_LEVEL_PTE);
 }
+#define folio_try_dup_anon_rmap_pte(folio, page, vma) \
+	folio_try_dup_anon_rmap_ptes(folio, page, 1, vma)
 
 /**
- * page_try_dup_anon_rmap - try duplicating a mapping of an already mapped
- *			    anonymous page
- * @page: the page to duplicate the mapping for
- * @compound: the page is mapped as compound or as a small page
- * @vma: the source vma
+ * folio_try_dup_anon_rmap_pmd - try duplicating a PMD mapping of a page range
+ *				 of a folio
+ * @folio:	The folio to duplicate the mapping of
+ * @page:	The first page to duplicate the mapping of
+ * @src_vma:	The vm area from which the mapping is duplicated
+ *
+ * The page range of the folio is defined by [page, page + HPAGE_PMD_NR)
  *
- * The caller needs to hold the PT lock and the vma->vma_mm->write_protect_seq.
+ * The caller needs to hold the page table lock and the
+ * vma->vma_mm->write_protect_seq.
  *
- * Duplicating the mapping can only fail if the page may be pinned; device
- * private pages cannot get pinned and consequently this function cannot fail.
+ * Duplicating the mapping can only fail if the folio may be pinned; device
+ * private folios cannot get pinned and consequently this function cannot fail
+ * for them.
  *
- * If duplicating the mapping succeeds, the page has to be mapped R/O into
- * the parent and the child. It must *not* get mapped writable after this call.
+ * If duplicating the mapping succeeds, the duplicated PMD has to be R/O in
+ * the parent and the child. They must *not* be writable after this call
+ * succeeded.
  *
  * Returns 0 if duplicating the mapping succeeded. Returns -EBUSY otherwise.
  */
+static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
+		struct page *page, struct vm_area_struct *src_vma)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return __folio_try_dup_anon_rmap(folio, page, HPAGE_PMD_NR, src_vma,
+					 RMAP_LEVEL_PMD);
+#else
+	WARN_ON_ONCE(true);
+	return -EBUSY;
+#endif
+}
+
 static inline int page_try_dup_anon_rmap(struct page *page, bool compound,
 					 struct vm_area_struct *vma)
 {
-	VM_BUG_ON_PAGE(!PageAnon(page), page);
-
-	/*
-	 * No need to check+clear for already shared pages, including KSM
-	 * pages.
-	 */
-	if (!PageAnonExclusive(page))
-		goto dup;
-
-	/*
-	 * If this page may have been pinned by the parent process,
-	 * don't allow to duplicate the mapping but instead require to e.g.,
-	 * copy the page immediately for the child so that we'll always
-	 * guarantee the pinned page won't be randomly replaced in the
-	 * future on write faults.
-	 */
-	if (likely(!is_device_private_page(page)) &&
-	    unlikely(page_needs_cow_for_dma(vma, page)))
-		return -EBUSY;
+	struct folio *folio = page_folio(page);
 
-	ClearPageAnonExclusive(page);
-	/*
-	 * It's okay to share the anon page between both processes, mapping
-	 * the page R/O into both processes.
-	 */
-dup:
-	__page_dup_rmap(page, compound);
-	return 0;
+	if (likely(!compound))
+		return folio_try_dup_anon_rmap_pte(folio, page, vma);
+	return folio_try_dup_anon_rmap_pmd(folio, page, vma);
 }
 
 /**
_

Patches currently in -mm which might be from david@redhat.com are


