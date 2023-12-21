Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0D078E64
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a8IeW+vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F52C433C7;
	Thu, 21 Dec 2023 22:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197784;
	bh=mR/K21m8yR8BsGqLRnIsA/5IblDgN5Jmm3nGCiiO340=;
	h=Date:To:From:Subject:From;
	b=a8IeW+vs6tV1Hy/1y3jQgBg1mbgO1VrjG9AObFdirGkJ0TRdSw9ZmgvgFZOuon6jt
	 LVig4QaaioLUB+qM8V5KFDDatTpAq9J9lYpx4eRRxKNcYFqV7ylxq9eOa0fXH8ZOX2
	 qtRxNKv9oPBO0rgmusQFcUK3QiXjktZvuFR4u+rA=
Date: Thu, 21 Dec 2023 14:29:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-introduce-folio_add_anon_rmap_.patch added to mm-unstable branch
Message-Id: <20231221222944.55F52C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: introduce folio_add_anon_rmap_[pte|ptes|pmd]()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-introduce-folio_add_anon_rmap_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-introduce-folio_add_anon_rmap_.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: introduce folio_add_anon_rmap_[pte|ptes|pmd]()
Date: Wed, 20 Dec 2023 23:44:38 +0100

Let's mimic what we did with folio_add_file_rmap_*() so we can similarly
replace page_add_anon_rmap() next.

Make the compiler always special-case on the granularity by using
__always_inline.

For the PageAnonExclusive sanity checks, when adding a PMD mapping, we're
now also checking each individual subpage covered by that PMD, instead of
only the head page.

Note that the new functions ignore the RMAP_COMPOUND flag, which we will
remove as soon as page_add_anon_rmap() is gone.

Link: https://lkml.kernel.org/r/20231220224504.646757-15-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    6 ++
 mm/rmap.c            |  122 +++++++++++++++++++++++++++--------------
 2 files changed, 89 insertions(+), 39 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-introduce-folio_add_anon_rmap_
+++ a/include/linux/rmap.h
@@ -233,6 +233,12 @@ static inline void __folio_rmap_sanity_c
  * rmap interfaces called when adding or removing pte of page
  */
 void folio_move_anon_rmap(struct folio *, struct vm_area_struct *);
+void folio_add_anon_rmap_ptes(struct folio *, struct page *, int nr_pages,
+		struct vm_area_struct *, unsigned long address, rmap_t flags);
+#define folio_add_anon_rmap_pte(folio, page, vma, address, flags) \
+	folio_add_anon_rmap_ptes(folio, page, 1, vma, address, flags)
+void folio_add_anon_rmap_pmd(struct folio *, struct page *,
+		struct vm_area_struct *, unsigned long address, rmap_t flags);
 void page_add_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
 void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
--- a/mm/rmap.c~mm-rmap-introduce-folio_add_anon_rmap_
+++ a/mm/rmap.c
@@ -1299,40 +1299,20 @@ void page_add_anon_rmap(struct page *pag
 		unsigned long address, rmap_t flags)
 {
 	struct folio *folio = page_folio(page);
-	atomic_t *mapped = &folio->_nr_pages_mapped;
-	int nr = 0, nr_pmdmapped = 0;
-	bool compound = flags & RMAP_COMPOUND;
-	bool first;
-
-	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
-
-	/* Is page being mapped by PTE? Is this its first map to be added? */
-	if (likely(!compound)) {
-		first = atomic_inc_and_test(&page->_mapcount);
-		nr = first;
-		if (first && folio_test_large(folio)) {
-			nr = atomic_inc_return_relaxed(mapped);
-			nr = (nr < COMPOUND_MAPPED);
-		}
-	} else if (folio_test_pmd_mappable(folio)) {
-		/* That test is redundant: it's for safety or to optimize out */
 
-		first = atomic_inc_and_test(&folio->_entire_mapcount);
-		if (first) {
-			nr = atomic_add_return_relaxed(COMPOUND_MAPPED, mapped);
-			if (likely(nr < COMPOUND_MAPPED + COMPOUND_MAPPED)) {
-				nr_pmdmapped = folio_nr_pages(folio);
-				nr = nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
-				/* Raced ahead of a remove and another add? */
-				if (unlikely(nr < 0))
-					nr = 0;
-			} else {
-				/* Raced ahead of a remove of COMPOUND_MAPPED */
-				nr = 0;
-			}
-		}
-	}
+	if (likely(!(flags & RMAP_COMPOUND)))
+		folio_add_anon_rmap_pte(folio, page, vma, address, flags);
+	else
+		folio_add_anon_rmap_pmd(folio, page, vma, address, flags);
+}
+
+static __always_inline void __folio_add_anon_rmap(struct folio *folio,
+		struct page *page, int nr_pages, struct vm_area_struct *vma,
+		unsigned long address, rmap_t flags, enum rmap_level level)
+{
+	int i, nr, nr_pmdmapped = 0;
 
+	nr = __folio_add_rmap(folio, page, nr_pages, level, &nr_pmdmapped);
 	if (nr_pmdmapped)
 		__lruvec_stat_mod_folio(folio, NR_ANON_THPS, nr_pmdmapped);
 	if (nr)
@@ -1346,18 +1326,34 @@ void page_add_anon_rmap(struct page *pag
 		 * folio->index right when not given the address of the head
 		 * page.
 		 */
-		VM_WARN_ON_FOLIO(folio_test_large(folio) && !compound, folio);
+		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
+				 level != RMAP_LEVEL_PMD, folio);
 		__folio_set_anon(folio, vma, address,
 				 !!(flags & RMAP_EXCLUSIVE));
 	} else if (likely(!folio_test_ksm(folio))) {
 		__page_check_anon_rmap(folio, page, vma, address);
 	}
-	if (flags & RMAP_EXCLUSIVE)
-		SetPageAnonExclusive(page);
-	/* While PTE-mapping a THP we have a PMD and a PTE mapping. */
-	VM_WARN_ON_FOLIO((atomic_read(&page->_mapcount) > 0 ||
-			  (folio_test_large(folio) && folio_entire_mapcount(folio) > 1)) &&
-			 PageAnonExclusive(page), folio);
+
+	if (flags & RMAP_EXCLUSIVE) {
+		switch (level) {
+		case RMAP_LEVEL_PTE:
+			for (i = 0; i < nr_pages; i++)
+				SetPageAnonExclusive(page + i);
+			break;
+		case RMAP_LEVEL_PMD:
+			SetPageAnonExclusive(page);
+			break;
+		}
+	}
+	for (i = 0; i < nr_pages; i++) {
+		struct page *cur_page = page + i;
+
+		/* While PTE-mapping a THP we have a PMD and a PTE mapping. */
+		VM_WARN_ON_FOLIO((atomic_read(&cur_page->_mapcount) > 0 ||
+				  (folio_test_large(folio) &&
+				   folio_entire_mapcount(folio) > 1)) &&
+				 PageAnonExclusive(cur_page), folio);
+	}
 
 	/*
 	 * For large folio, only mlock it if it's fully mapped to VMA. It's
@@ -1370,6 +1366,54 @@ void page_add_anon_rmap(struct page *pag
 }
 
 /**
+ * folio_add_anon_rmap_ptes - add PTE mappings to a page range of an anon folio
+ * @folio:	The folio to add the mappings to
+ * @page:	The first page to add
+ * @nr_pages:	The number of pages which will be mapped
+ * @vma:	The vm area in which the mappings are added
+ * @address:	The user virtual address of the first page to map
+ * @flags:	The rmap flags
+ *
+ * The page range of folio is defined by [first_page, first_page + nr_pages)
+ *
+ * The caller needs to hold the page table lock, and the page must be locked in
+ * the anon_vma case: to serialize mapping,index checking after setting,
+ * and to ensure that an anon folio is not being upgraded racily to a KSM folio
+ * (but KSM folios are never downgraded).
+ */
+void folio_add_anon_rmap_ptes(struct folio *folio, struct page *page,
+		int nr_pages, struct vm_area_struct *vma, unsigned long address,
+		rmap_t flags)
+{
+	__folio_add_anon_rmap(folio, page, nr_pages, vma, address, flags,
+			      RMAP_LEVEL_PTE);
+}
+
+/**
+ * folio_add_anon_rmap_pmd - add a PMD mapping to a page range of an anon folio
+ * @folio:	The folio to add the mapping to
+ * @page:	The first page to add
+ * @vma:	The vm area in which the mapping is added
+ * @address:	The user virtual address of the first page to map
+ * @flags:	The rmap flags
+ *
+ * The page range of folio is defined by [first_page, first_page + HPAGE_PMD_NR)
+ *
+ * The caller needs to hold the page table lock, and the page must be locked in
+ * the anon_vma case: to serialize mapping,index checking after setting.
+ */
+void folio_add_anon_rmap_pmd(struct folio *folio, struct page *page,
+		struct vm_area_struct *vma, unsigned long address, rmap_t flags)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	__folio_add_anon_rmap(folio, page, HPAGE_PMD_NR, vma, address, flags,
+			      RMAP_LEVEL_PMD);
+#else
+	WARN_ON_ONCE(true);
+#endif
+}
+
+/**
  * folio_add_new_anon_rmap - Add mapping to a new anonymous folio.
  * @folio:	The folio to add the mapping to.
  * @vma:	the vm area in which the mapping is added
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-rename-hugepage_add-to-hugetlb_add.patch
mm-rmap-introduce-and-use-hugetlb_remove_rmap.patch
mm-rmap-introduce-and-use-hugetlb_add_file_rmap.patch
mm-rmap-introduce-and-use-hugetlb_try_dup_anon_rmap.patch
mm-rmap-introduce-and-use-hugetlb_try_share_anon_rmap.patch
mm-rmap-add-hugetlb-sanity-checks-for-anon-rmap-handling.patch
mm-rmap-convert-folio_add_file_rmap_range-into-folio_add_file_rmap_.patch
mm-memory-page_add_file_rmap-folio_add_file_rmap_.patch
mm-huge_memory-page_add_file_rmap-folio_add_file_rmap_pmd.patch
mm-migrate-page_add_file_rmap-folio_add_file_rmap_pte.patch
mm-userfaultfd-page_add_file_rmap-folio_add_file_rmap_pte.patch
mm-rmap-remove-page_add_file_rmap.patch
mm-rmap-factor-out-adding-folio-mappings-into-__folio_add_rmap.patch
mm-rmap-introduce-folio_add_anon_rmap_.patch
mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked.patch
mm-huge_memory-page_add_anon_rmap-folio_add_anon_rmap_pmd.patch
mm-migrate-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-swapfile-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-memory-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-rmap-remove-page_add_anon_rmap.patch
mm-rmap-remove-rmap_compound.patch
mm-rmap-introduce-folio_remove_rmap_.patch
kernel-events-uprobes-page_remove_rmap-folio_remove_rmap_pte.patch
mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd.patch
mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte.patch
mm-ksm-page_remove_rmap-folio_remove_rmap_pte.patch
mm-memory-page_remove_rmap-folio_remove_rmap_pte.patch
mm-migrate_device-page_remove_rmap-folio_remove_rmap_pte.patch
mm-rmap-page_remove_rmap-folio_remove_rmap_pte.patch
documentation-stop-referring-to-page_remove_rmap.patch
mm-rmap-remove-page_remove_rmap.patch
mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_.patch
mm-rmap-introduce-folio_try_dup_anon_rmap_.patch
mm-huge_memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pmd.patch
mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte.patch
mm-rmap-remove-page_try_dup_anon_rmap.patch
mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_.patch
mm-rmap-rename-compound_mapped-to-entirely_mapped.patch
mm-remove-one-last-reference-to-page_add__rmap.patch

