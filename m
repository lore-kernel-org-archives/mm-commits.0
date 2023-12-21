Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E7C78E7F
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aFMtTvZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD91C433C8;
	Thu, 21 Dec 2023 22:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197814;
	bh=uBI5eaUW8XtbdLqDHcc4Q+LBOQ65ecGuEgQFDTTSoNY=;
	h=Date:To:From:Subject:From;
	b=aFMtTvZ4XCMv1OGaGp1QkLyW1uP1iPR5dGVr67yYDaPdIfUjiIYFWHzVO4ukKIB38
	 QS8mHbYvUYT0nOYbsfDGDJZXR4MRCXDU1BnNGOWkVCcibybSNG0z65kLuM58v4RUHs
	 s6Rj6QovD2DeUZkyAw901GUMOqAXwM3rWc1cAx44=
Date: Thu, 21 Dec 2023 14:30:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_.patch added to mm-unstable branch
Message-Id: <20231221223014.5DD91C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert page_try_share_anon_rmap() to folio_try_share_anon_rmap_[pte|pmd]()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_.patch

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
Subject: mm: convert page_try_share_anon_rmap() to folio_try_share_anon_rmap_[pte|pmd]()
Date: Wed, 20 Dec 2023 23:45:02 +0100

Let's convert it like we converted all the other rmap functions.  Don't
introduce folio_try_share_anon_rmap_ptes() for now, as we don't have a
user that wants rmap batching in sight.  Pretty easy to add later.

All users are easy to convert -- only ksm.c doesn't use folios yet but
that is left for future work -- so let's just do it in a single shot.

While at it, turn the BUG_ON into a WARN_ON_ONCE.

Note that page_try_share_anon_rmap() so far didn't care about pte/pmd
mappings (no compound parameter).  We're changing that so we can perform
better sanity checks and make the code actually more readable/consistent. 
For example, __folio_rmap_sanity_checks() will make sure that a PMD range
actually falls completely into the folio.

Link: https://lkml.kernel.org/r/20231220224504.646757-39-david@redhat.com
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

 include/linux/rmap.h |   96 ++++++++++++++++++++++++++++++-----------
 mm/gup.c             |    2 
 mm/huge_memory.c     |    9 ++-
 mm/internal.h        |    4 -
 mm/ksm.c             |    5 +-
 mm/migrate_device.c  |    2 
 mm/rmap.c            |   11 ++--
 7 files changed, 89 insertions(+), 40 deletions(-)

--- a/include/linux/rmap.h~mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_
+++ a/include/linux/rmap.h
@@ -269,7 +269,7 @@ static inline int hugetlb_try_dup_anon_r
 	return 0;
 }
 
-/* See page_try_share_anon_rmap() */
+/* See folio_try_share_anon_rmap_*() */
 static inline int hugetlb_try_share_anon_rmap(struct folio *folio)
 {
 	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -478,31 +478,15 @@ static inline int folio_try_dup_anon_rma
 #endif
 }
 
-/**
- * page_try_share_anon_rmap - try marking an exclusive anonymous page possibly
- *			      shared to prepare for KSM or temporary unmapping
- * @page: the exclusive anonymous page to try marking possibly shared
- *
- * The caller needs to hold the PT lock and has to have the page table entry
- * cleared/invalidated.
- *
- * This is similar to folio_try_dup_anon_rmap_*(), however, not used during
- * fork() to duplicate a mapping, but instead to prepare for KSM or temporarily
- * unmapping a page (swap, migration) via folio_remove_rmap_*().
- *
- * Marking the page shared can only fail if the page may be pinned; device
- * private pages cannot get pinned and consequently this function cannot fail.
- *
- * Returns 0 if marking the page possibly shared succeeded. Returns -EBUSY
- * otherwise.
- */
-static inline int page_try_share_anon_rmap(struct page *page)
+static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
+		struct page *page, int nr_pages, enum rmap_level level)
 {
-	VM_WARN_ON(folio_test_hugetlb(page_folio(page)));
-	VM_BUG_ON_PAGE(!PageAnon(page) || !PageAnonExclusive(page), page);
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
+	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
-	/* device private pages cannot get pinned via GUP. */
-	if (unlikely(is_device_private_page(page))) {
+	/* device private folios cannot get pinned via GUP. */
+	if (unlikely(folio_is_device_private(folio))) {
 		ClearPageAnonExclusive(page);
 		return 0;
 	}
@@ -553,7 +537,7 @@ static inline int page_try_share_anon_rm
 	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
 		smp_mb();
 
-	if (unlikely(page_maybe_dma_pinned(page)))
+	if (unlikely(folio_maybe_dma_pinned(folio)))
 		return -EBUSY;
 	ClearPageAnonExclusive(page);
 
@@ -566,6 +550,68 @@ static inline int page_try_share_anon_rm
 	return 0;
 }
 
+/**
+ * folio_try_share_anon_rmap_pte - try marking an exclusive anonymous page
+ *				   mapped by a PTE possibly shared to prepare
+ *				   for KSM or temporary unmapping
+ * @folio:	The folio to share a mapping of
+ * @page:	The mapped exclusive page
+ *
+ * The caller needs to hold the page table lock and has to have the page table
+ * entries cleared/invalidated.
+ *
+ * This is similar to folio_try_dup_anon_rmap_pte(), however, not used during
+ * fork() to duplicate mappings, but instead to prepare for KSM or temporarily
+ * unmapping parts of a folio (swap, migration) via folio_remove_rmap_pte().
+ *
+ * Marking the mapped page shared can only fail if the folio maybe pinned;
+ * device private folios cannot get pinned and consequently this function cannot
+ * fail.
+ *
+ * Returns 0 if marking the mapped page possibly shared succeeded. Returns
+ * -EBUSY otherwise.
+ */
+static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
+		struct page *page)
+{
+	return __folio_try_share_anon_rmap(folio, page, 1, RMAP_LEVEL_PTE);
+}
+
+/**
+ * folio_try_share_anon_rmap_pmd - try marking an exclusive anonymous page
+ *				   range mapped by a PMD possibly shared to
+ *				   prepare for temporary unmapping
+ * @folio:	The folio to share the mapping of
+ * @page:	The first page to share the mapping of
+ *
+ * The page range of the folio is defined by [page, page + HPAGE_PMD_NR)
+ *
+ * The caller needs to hold the page table lock and has to have the page table
+ * entries cleared/invalidated.
+ *
+ * This is similar to folio_try_dup_anon_rmap_pmd(), however, not used during
+ * fork() to duplicate a mapping, but instead to prepare for temporarily
+ * unmapping parts of a folio (swap, migration) via folio_remove_rmap_pmd().
+ *
+ * Marking the mapped pages shared can only fail if the folio maybe pinned;
+ * device private folios cannot get pinned and consequently this function cannot
+ * fail.
+ *
+ * Returns 0 if marking the mapped pages possibly shared succeeded. Returns
+ * -EBUSY otherwise.
+ */
+static inline int folio_try_share_anon_rmap_pmd(struct folio *folio,
+		struct page *page)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return __folio_try_share_anon_rmap(folio, page, HPAGE_PMD_NR,
+					   RMAP_LEVEL_PMD);
+#else
+	WARN_ON_ONCE(true);
+	return -EBUSY;
+#endif
+}
+
 /*
  * Called from mm/vmscan.c to handle paging out
  */
--- a/mm/gup.c~mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_
+++ a/mm/gup.c
@@ -177,7 +177,7 @@ struct folio *try_grab_folio(struct page
 	/*
 	 * Adjust the pincount before re-checking the PTE for changes.
 	 * This is essentially a smp_mb() and is paired with a memory
-	 * barrier in page_try_share_anon_rmap().
+	 * barrier in folio_try_share_anon_rmap_*().
 	 */
 	smp_mb__after_atomic();
 
--- a/mm/huge_memory.c~mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_
+++ a/mm/huge_memory.c
@@ -2523,10 +2523,11 @@ static void __split_huge_pmd_locked(stru
 		 * In case we cannot clear PageAnonExclusive(), split the PMD
 		 * only and let try_to_migrate_one() fail later.
 		 *
-		 * See page_try_share_anon_rmap(): invalidate PMD first.
+		 * See folio_try_share_anon_rmap_pmd(): invalidate PMD first.
 		 */
 		anon_exclusive = PageAnonExclusive(page);
-		if (freeze && anon_exclusive && page_try_share_anon_rmap(page))
+		if (freeze && anon_exclusive &&
+		    folio_try_share_anon_rmap_pmd(folio, page))
 			freeze = false;
 		if (!freeze) {
 			rmap_t rmap_flags = RMAP_NONE;
@@ -3554,9 +3555,9 @@ int set_pmd_migration_entry(struct page_
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
 	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 
-	/* See page_try_share_anon_rmap(): invalidate PMD first. */
+	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
 	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
-	if (anon_exclusive && page_try_share_anon_rmap(page)) {
+	if (anon_exclusive && folio_try_share_anon_rmap_pmd(folio, page)) {
 		set_pmd_at(mm, address, pvmw->pmd, pmdval);
 		return -EBUSY;
 	}
--- a/mm/internal.h~mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_
+++ a/mm/internal.h
@@ -1047,7 +1047,7 @@ enum {
  * * Ordinary GUP: Using the PT lock
  * * GUP-fast and fork(): mm->write_protect_seq
  * * GUP-fast and KSM or temporary unmapping (swap, migration): see
- *    page_try_share_anon_rmap()
+ *    folio_try_share_anon_rmap_*()
  *
  * Must be called with the (sub)page that's actually referenced via the
  * page table entry, which might not necessarily be the head page for a
@@ -1090,7 +1090,7 @@ static inline bool gup_must_unshare(stru
 		return is_cow_mapping(vma->vm_flags);
 	}
 
-	/* Paired with a memory barrier in page_try_share_anon_rmap(). */
+	/* Paired with a memory barrier in folio_try_share_anon_rmap_*(). */
 	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
 		smp_rmb();
 
--- a/mm/ksm.c~mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_
+++ a/mm/ksm.c
@@ -1331,8 +1331,9 @@ static int write_protect_page(struct vm_
 			goto out_unlock;
 		}
 
-		/* See page_try_share_anon_rmap(): clear PTE first. */
-		if (anon_exclusive && page_try_share_anon_rmap(page)) {
+		/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
+		if (anon_exclusive &&
+		    folio_try_share_anon_rmap_pte(page_folio(page), page)) {
 			set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 			goto out_unlock;
 		}
--- a/mm/migrate_device.c~mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_
+++ a/mm/migrate_device.c
@@ -202,7 +202,7 @@ again:
 			if (anon_exclusive) {
 				pte = ptep_clear_flush(vma, addr, ptep);
 
-				if (page_try_share_anon_rmap(page)) {
+				if (folio_try_share_anon_rmap_pte(folio, page)) {
 					set_pte_at(mm, addr, ptep, pte);
 					folio_unlock(folio);
 					folio_put(folio);
--- a/mm/rmap.c~mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_
+++ a/mm/rmap.c
@@ -1866,9 +1866,9 @@ static bool try_to_unmap_one(struct foli
 				break;
 			}
 
-			/* See page_try_share_anon_rmap(): clear PTE first. */
+			/* See folio_try_share_anon_rmap(): clear PTE first. */
 			if (anon_exclusive &&
-			    page_try_share_anon_rmap(subpage)) {
+			    folio_try_share_anon_rmap_pte(folio, subpage)) {
 				swap_free(entry);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
@@ -2142,7 +2142,8 @@ static bool try_to_migrate_one(struct fo
 			pte_t swp_pte;
 
 			if (anon_exclusive)
-				BUG_ON(page_try_share_anon_rmap(subpage));
+				WARN_ON_ONCE(folio_try_share_anon_rmap_pte(folio,
+									   subpage));
 
 			/*
 			 * Store the pfn of the page in a special migration
@@ -2213,7 +2214,7 @@ static bool try_to_migrate_one(struct fo
 			VM_BUG_ON_PAGE(pte_write(pteval) && folio_test_anon(folio) &&
 				       !anon_exclusive, subpage);
 
-			/* See page_try_share_anon_rmap(): clear PTE first. */
+			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
 			if (folio_test_hugetlb(folio)) {
 				if (anon_exclusive &&
 				    hugetlb_try_share_anon_rmap(folio)) {
@@ -2224,7 +2225,7 @@ static bool try_to_migrate_one(struct fo
 					break;
 				}
 			} else if (anon_exclusive &&
-				   page_try_share_anon_rmap(subpage)) {
+				   folio_try_share_anon_rmap_pte(folio, subpage)) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
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

