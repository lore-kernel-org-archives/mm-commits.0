Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F47613AEB
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="um/SkN5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C973C433C7;
	Fri, 29 Dec 2023 20:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880097;
	bh=/GnJ1N3QvDrTFDsIYB21yu8DWeCROBvjC1RUpb0d4Bs=;
	h=Date:To:From:Subject:From;
	b=um/SkN5TALrcPXaHEDwW3Ysd+FIzYEJCwqeYEIimPccnZQA6hm7Wjn9lFcf5q5uTp
	 11yVuaxDzApWS7G1cxLNcH7zdSd2FUZJU4lpOe2PUJ0yetRp6S1lDeKD4C8LLpYXMX
	 3C0h0OaXWrvbJ3W+nQwMzdXXlNtNNr5QOdIyJiQM=
Date: Fri, 29 Dec 2023 12:01:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-factor-out-adding-folio-mappings-into-__folio_add_rmap.patch removed from -mm tree
Message-Id: <20231229200137.0C973C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: factor out adding folio mappings into __folio_add_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-factor-out-adding-folio-mappings-into-__folio_add_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: factor out adding folio mappings into __folio_add_rmap()
Date: Wed, 20 Dec 2023 23:44:37 +0100

Let's factor it out to prepare for reuse as we convert
page_add_anon_rmap() to folio_add_anon_rmap_[pte|ptes|pmd]().

Make the compiler always special-case on the granularity by using
__always_inline.

Link: https://lkml.kernel.org/r/20231220224504.646757-14-david@redhat.com
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

 mm/rmap.c |   78 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 34 deletions(-)

--- a/mm/rmap.c~mm-rmap-factor-out-adding-folio-mappings-into-__folio_add_rmap
+++ a/mm/rmap.c
@@ -1157,6 +1157,48 @@ int folio_total_mapcount(struct folio *f
 	return mapcount;
 }
 
+static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
+		struct page *page, int nr_pages, enum rmap_level level,
+		int *nr_pmdmapped)
+{
+	atomic_t *mapped = &folio->_nr_pages_mapped;
+	int first, nr = 0;
+
+	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
+
+	switch (level) {
+	case RMAP_LEVEL_PTE:
+		do {
+			first = atomic_inc_and_test(&page->_mapcount);
+			if (first && folio_test_large(folio)) {
+				first = atomic_inc_return_relaxed(mapped);
+				first = (first < COMPOUND_MAPPED);
+			}
+
+			if (first)
+				nr++;
+		} while (page++, --nr_pages > 0);
+		break;
+	case RMAP_LEVEL_PMD:
+		first = atomic_inc_and_test(&folio->_entire_mapcount);
+		if (first) {
+			nr = atomic_add_return_relaxed(COMPOUND_MAPPED, mapped);
+			if (likely(nr < COMPOUND_MAPPED + COMPOUND_MAPPED)) {
+				*nr_pmdmapped = folio_nr_pages(folio);
+				nr = *nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
+				/* Raced ahead of a remove and another add? */
+				if (unlikely(nr < 0))
+					nr = 0;
+			} else {
+				/* Raced ahead of a remove of COMPOUND_MAPPED */
+				nr = 0;
+			}
+		}
+		break;
+	}
+	return nr;
+}
+
 /**
  * folio_move_anon_rmap - move a folio to our anon_vma
  * @folio:	The folio to move to our anon_vma
@@ -1382,43 +1424,11 @@ static __always_inline void __folio_add_
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		enum rmap_level level)
 {
-	atomic_t *mapped = &folio->_nr_pages_mapped;
-	int nr = 0, nr_pmdmapped = 0, first;
+	int nr, nr_pmdmapped = 0;
 
 	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
-	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
-
-	switch (level) {
-	case RMAP_LEVEL_PTE:
-		do {
-			first = atomic_inc_and_test(&page->_mapcount);
-			if (first && folio_test_large(folio)) {
-				first = atomic_inc_return_relaxed(mapped);
-				first = (first < COMPOUND_MAPPED);
-			}
-
-			if (first)
-				nr++;
-		} while (page++, --nr_pages > 0);
-		break;
-	case RMAP_LEVEL_PMD:
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
-		break;
-	}
 
+	nr = __folio_add_rmap(folio, page, nr_pages, level, &nr_pmdmapped);
 	if (nr_pmdmapped)
 		__lruvec_stat_mod_folio(folio, folio_test_swapbacked(folio) ?
 			NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED, nr_pmdmapped);
_

Patches currently in -mm which might be from david@redhat.com are


