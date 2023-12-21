Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A27F78E93
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y9Urzil2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5201DC433C7;
	Thu, 21 Dec 2023 22:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197795;
	bh=JE6JMkkzg/siv9cUojP73RZoCWuwp1TQjwqPEHqUl78=;
	h=Date:To:From:Subject:From;
	b=y9Urzil2LgauoT3W140rov+x6T243Q3hyzNmk+EevBVf4YeqASalQSbF7Zre/CJAe
	 HPrGF6MX5nhfkVyODKSLt2Yk2c1f/RLA1MsOsqbi1uVsLau6WQzt5X1yfqKo3QOcM/
	 vU7xxt4ZmmD4rQGFmgkbdWVWAvAHYUdaERU/joew=
Date: Thu, 21 Dec 2023 14:29:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-introduce-folio_remove_rmap_.patch added to mm-unstable branch
Message-Id: <20231221222955.5201DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: introduce folio_remove_rmap_[pte|ptes|pmd]()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-introduce-folio_remove_rmap_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-introduce-folio_remove_rmap_.patch

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
Subject: mm/rmap: introduce folio_remove_rmap_[pte|ptes|pmd]()
Date: Wed, 20 Dec 2023 23:44:47 +0100

Let's mimic what we did with folio_add_file_rmap_*() and
folio_add_anon_rmap_*() so we can similarly replace page_remove_rmap()
next.

Make the compiler always special-case on the granularity by using
__always_inline.

We're adding folio_remove_rmap_ptes() handling right away, as we want to
use that soon for batching rmap operations when unmapping PTE-mapped large
folios.

Link: https://lkml.kernel.org/r/20231220224504.646757-24-david@redhat.com
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

 include/linux/rmap.h |    6 +++
 mm/rmap.c            |   80 +++++++++++++++++++++++++++++++++--------
 2 files changed, 71 insertions(+), 15 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-introduce-folio_remove_rmap_
+++ a/include/linux/rmap.h
@@ -243,6 +243,12 @@ void folio_add_file_rmap_pmd(struct foli
 		struct vm_area_struct *);
 void page_remove_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
+void folio_remove_rmap_ptes(struct folio *, struct page *, int nr_pages,
+		struct vm_area_struct *);
+#define folio_remove_rmap_pte(folio, page, vma) \
+	folio_remove_rmap_ptes(folio, page, 1, vma)
+void folio_remove_rmap_pmd(struct folio *, struct page *,
+		struct vm_area_struct *);
 
 void hugetlb_add_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
--- a/mm/rmap.c~mm-rmap-introduce-folio_remove_rmap_
+++ a/mm/rmap.c
@@ -1510,25 +1510,37 @@ void page_remove_rmap(struct page *page,
 		bool compound)
 {
 	struct folio *folio = page_folio(page);
+
+	if (likely(!compound))
+		folio_remove_rmap_pte(folio, page, vma);
+	else
+		folio_remove_rmap_pmd(folio, page, vma);
+}
+
+static __always_inline void __folio_remove_rmap(struct folio *folio,
+		struct page *page, int nr_pages, struct vm_area_struct *vma,
+		enum rmap_level level)
+{
 	atomic_t *mapped = &folio->_nr_pages_mapped;
-	int nr = 0, nr_pmdmapped = 0;
-	bool last;
+	int last, nr = 0, nr_pmdmapped = 0;
 	enum node_stat_item idx;
 
-	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
-	VM_BUG_ON_PAGE(compound && !PageHead(page), page);
+	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
-	/* Is page being unmapped by PTE? Is this its last map to be removed? */
-	if (likely(!compound)) {
-		last = atomic_add_negative(-1, &page->_mapcount);
-		nr = last;
-		if (last && folio_test_large(folio)) {
-			nr = atomic_dec_return_relaxed(mapped);
-			nr = (nr < COMPOUND_MAPPED);
-		}
-	} else if (folio_test_pmd_mappable(folio)) {
-		/* That test is redundant: it's for safety or to optimize out */
+	switch (level) {
+	case RMAP_LEVEL_PTE:
+		do {
+			last = atomic_add_negative(-1, &page->_mapcount);
+			if (last && folio_test_large(folio)) {
+				last = atomic_dec_return_relaxed(mapped);
+				last = (last < COMPOUND_MAPPED);
+			}
 
+			if (last)
+				nr++;
+		} while (page++, --nr_pages > 0);
+		break;
+	case RMAP_LEVEL_PMD:
 		last = atomic_add_negative(-1, &folio->_entire_mapcount);
 		if (last) {
 			nr = atomic_sub_return_relaxed(COMPOUND_MAPPED, mapped);
@@ -1543,6 +1555,7 @@ void page_remove_rmap(struct page *page,
 				nr = 0;
 			}
 		}
+		break;
 	}
 
 	if (nr_pmdmapped) {
@@ -1564,7 +1577,7 @@ void page_remove_rmap(struct page *page,
 		 * is still mapped.
 		 */
 		if (folio_test_large(folio) && folio_test_anon(folio))
-			if (!compound || nr < nr_pmdmapped)
+			if (level == RMAP_LEVEL_PTE || nr < nr_pmdmapped)
 				deferred_split_folio(folio);
 	}
 
@@ -1579,6 +1592,43 @@ void page_remove_rmap(struct page *page,
 	munlock_vma_folio(folio, vma);
 }
 
+/**
+ * folio_remove_rmap_ptes - remove PTE mappings from a page range of a folio
+ * @folio:	The folio to remove the mappings from
+ * @page:	The first page to remove
+ * @nr_pages:	The number of pages that will be removed from the mapping
+ * @vma:	The vm area from which the mappings are removed
+ *
+ * The page range of the folio is defined by [page, page + nr_pages)
+ *
+ * The caller needs to hold the page table lock.
+ */
+void folio_remove_rmap_ptes(struct folio *folio, struct page *page,
+		int nr_pages, struct vm_area_struct *vma)
+{
+	__folio_remove_rmap(folio, page, nr_pages, vma, RMAP_LEVEL_PTE);
+}
+
+/**
+ * folio_remove_rmap_pmd - remove a PMD mapping from a page range of a folio
+ * @folio:	The folio to remove the mapping from
+ * @page:	The first page to remove
+ * @vma:	The vm area from which the mapping is removed
+ *
+ * The page range of the folio is defined by [page, page + HPAGE_PMD_NR)
+ *
+ * The caller needs to hold the page table lock.
+ */
+void folio_remove_rmap_pmd(struct folio *folio, struct page *page,
+		struct vm_area_struct *vma)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	__folio_remove_rmap(folio, page, HPAGE_PMD_NR, vma, RMAP_LEVEL_PMD);
+#else
+	WARN_ON_ONCE(true);
+#endif
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
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

