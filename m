Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B199A363C42
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 17:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238493; cv=none; b=cOqrl79zdX7xPo5DbnUMnYLrompVKregCmj1aptJ831Cbl+HC/zgdUpFzcYrxjIybYwuxh5EnsrocttW7aRD6Y1vopAOiEnovs8M+tI/x4dWu5Yb4hFWH30KOG+CaFZBvgbmp2x8GsS9q90NBM2ERQOeKy/uVBPiaLwC9sDFNW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238493; c=relaxed/simple;
	bh=ae25tcsM3gxjTkvzLDKYzdJpuxoVcHx6ctL0zqzy8qo=;
	h=Date:To:From:Subject:Message-Id; b=IzsSJ+IPlko0icqkTLjJxmTz1F2XecO9BmItN6W52Rc05+WjG07UDMl4dWgHqX8ICPxC2ZLMqHEihnX7cNO+zzC+Sm4ZiE6m6MMRQetwi+MVRieJqo+FfSKmuYxeeytejcTZYiaE1VdB8xXdby2/vJ88gOrpVD67BDwI8iq/bJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X8wixDEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X8wixDEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFD0C116D0;
	Mon, 12 Jan 2026 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768238493;
	bh=ae25tcsM3gxjTkvzLDKYzdJpuxoVcHx6ctL0zqzy8qo=;
	h=Date:To:From:Subject:From;
	b=X8wixDEcY7E6PWknxp1hUtdLQ/mSoZFpG1txxEq54xLA1Zb8/e6a6y4Mj8XnikOtr
	 zH80wwS5K8vuC70GbfseGpcwj7+/OYi5ratDGNMf3ATKsjB0bZJWLVCeQtlUyB53gR
	 whP447rdfGz/AzA+AupEcD7rH7bLsve1AoQNB85Q=
Date: Mon, 12 Jan 2026 09:21:32 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-introduce-page_is_unmovable.patch added to mm-new branch
Message-Id: <20260112172133.1AFD0C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_isolation: introduce page_is_unmovable()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-introduce-page_is_unmovable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-introduce-page_is_unmovable.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_isolation: introduce page_is_unmovable()
Date: Mon, 12 Jan 2026 23:09:50 +0800

Patch series "mm: accelerate gigantic folio allocation".

Optimize pfn_range_valid_contig() and replace_free_hugepage_folios() in
alloc_contig_frozen_pages() to speed up gigantic folio allocation.  The
allocation time for 120*1G folios drops from 3.605s to 0.431s.


This patch (of 5):

Factor out the check if a page is unmovable into a new helper, and will be
reused in the following patch.

No functional change intended, the minor changes are as follows,
1) Avoid unnecessary calls by checking CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
2) Directly call PageCompound since PageTransCompound may be dropped
3) Using folio_test_hugetlb()

Link: https://lkml.kernel.org/r/20260112150954.1802953-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20260112150954.1802953-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    2 
 mm/page_isolation.c            |  187 ++++++++++++++++---------------
 2 files changed, 101 insertions(+), 88 deletions(-)

--- a/include/linux/page-isolation.h~mm-page_isolation-introduce-page_is_unmovable
+++ a/include/linux/page-isolation.h
@@ -67,4 +67,6 @@ void undo_isolate_page_range(unsigned lo
 
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			enum pb_isolate_mode mode);
+bool page_is_unmovable(struct zone *zone, struct page *page,
+			enum pb_isolate_mode mode, unsigned long *step);
 #endif
--- a/mm/page_isolation.c~mm-page_isolation-introduce-page_is_unmovable
+++ a/mm/page_isolation.c
@@ -15,6 +15,100 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/page_isolation.h>
 
+bool page_is_unmovable(struct zone *zone, struct page *page,
+		enum pb_isolate_mode mode, unsigned long *step)
+{
+	/*
+	 * Both, bootmem allocations and memory holes are marked
+	 * PG_reserved and are unmovable. We can even have unmovable
+	 * allocations inside ZONE_MOVABLE, for example when
+	 * specifying "movablecore".
+	 */
+	if (PageReserved(page))
+		return true;
+
+	/*
+	 * If the zone is movable and we have ruled out all reserved
+	 * pages then it should be reasonably safe to assume the rest
+	 * is movable.
+	 */
+	if (zone_idx(zone) == ZONE_MOVABLE)
+		return false;
+
+	/*
+	 * Hugepages are not in LRU lists, but they're movable.
+	 * THPs are on the LRU, but need to be counted as #small pages.
+	 * We need not scan over tail pages because we don't
+	 * handle each tail page individually in migration.
+	 */
+	if (PageHuge(page) || PageCompound(page)) {
+		struct folio *folio = page_folio(page);
+
+		if (folio_test_hugetlb(folio)) {
+			struct hstate *h;
+
+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
+				return true;
+
+			/*
+			 * The huge page may be freed so can not
+			 * use folio_hstate() directly.
+			 */
+			h = size_to_hstate(folio_size(folio));
+			if (h && !hugepage_migration_supported(h))
+				return true;
+
+		} else if (!folio_test_lru(folio)) {
+			return true;
+		}
+
+		*step = folio_nr_pages(folio) - folio_page_idx(folio, page);
+		return false;
+	}
+
+	/*
+	 * We can't use page_count without pin a page
+	 * because another CPU can free compound page.
+	 * This check already skips compound tails of THP
+	 * because their page->_refcount is zero at all time.
+	 */
+	if (!page_ref_count(page)) {
+		if (PageBuddy(page))
+			*step = (1 << buddy_order(page));
+		return false;
+	}
+
+	/*
+	 * The HWPoisoned page may be not in buddy system, and
+	 * page_count() is not 0.
+	 */
+	if ((mode == PB_ISOLATE_MODE_MEM_OFFLINE) && PageHWPoison(page))
+		return false;
+
+	/*
+	 * We treat all PageOffline() pages as movable when offlining
+	 * to give drivers a chance to decrement their reference count
+	 * in MEM_GOING_OFFLINE in order to indicate that these pages
+	 * can be offlined as there are no direct references anymore.
+	 * For actually unmovable PageOffline() where the driver does
+	 * not support this, we will fail later when trying to actually
+	 * move these pages that still have a reference count > 0.
+	 * (false negatives in this function only)
+	 */
+	if ((mode == PB_ISOLATE_MODE_MEM_OFFLINE) && PageOffline(page))
+		return false;
+
+	if (PageLRU(page) || page_has_movable_ops(page))
+		return false;
+
+	/*
+	 * If there are RECLAIMABLE pages, we need to check
+	 * it.  But now, memory offline itself doesn't call
+	 * shrink_node_slabs() and it still to be fixed.
+	 */
+	return true;
+}
+
 /*
  * This function checks whether the range [start_pfn, end_pfn) includes
  * unmovable pages or not. The range must fall into a single pageblock and
@@ -35,7 +129,6 @@ static struct page *has_unmovable_pages(
 {
 	struct page *page = pfn_to_page(start_pfn);
 	struct zone *zone = page_zone(page);
-	unsigned long pfn;
 
 	VM_BUG_ON(pageblock_start_pfn(start_pfn) !=
 		  pageblock_start_pfn(end_pfn - 1));
@@ -52,96 +145,14 @@ static struct page *has_unmovable_pages(
 		return page;
 	}
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-		page = pfn_to_page(pfn);
+	while (start_pfn < end_pfn) {
+		unsigned long step = 1;
 
-		/*
-		 * Both, bootmem allocations and memory holes are marked
-		 * PG_reserved and are unmovable. We can even have unmovable
-		 * allocations inside ZONE_MOVABLE, for example when
-		 * specifying "movablecore".
-		 */
-		if (PageReserved(page))
+		page = pfn_to_page(start_pfn);
+		if (page_is_unmovable(zone, page, mode, &step))
 			return page;
 
-		/*
-		 * If the zone is movable and we have ruled out all reserved
-		 * pages then it should be reasonably safe to assume the rest
-		 * is movable.
-		 */
-		if (zone_idx(zone) == ZONE_MOVABLE)
-			continue;
-
-		/*
-		 * Hugepages are not in LRU lists, but they're movable.
-		 * THPs are on the LRU, but need to be counted as #small pages.
-		 * We need not scan over tail pages because we don't
-		 * handle each tail page individually in migration.
-		 */
-		if (PageHuge(page) || PageTransCompound(page)) {
-			struct folio *folio = page_folio(page);
-			unsigned int skip_pages;
-
-			if (PageHuge(page)) {
-				struct hstate *h;
-
-				/*
-				 * The huge page may be freed so can not
-				 * use folio_hstate() directly.
-				 */
-				h = size_to_hstate(folio_size(folio));
-				if (h && !hugepage_migration_supported(h))
-					return page;
-			} else if (!folio_test_lru(folio)) {
-				return page;
-			}
-
-			skip_pages = folio_nr_pages(folio) - folio_page_idx(folio, page);
-			pfn += skip_pages - 1;
-			continue;
-		}
-
-		/*
-		 * We can't use page_count without pin a page
-		 * because another CPU can free compound page.
-		 * This check already skips compound tails of THP
-		 * because their page->_refcount is zero at all time.
-		 */
-		if (!page_ref_count(page)) {
-			if (PageBuddy(page))
-				pfn += (1 << buddy_order(page)) - 1;
-			continue;
-		}
-
-		/*
-		 * The HWPoisoned page may be not in buddy system, and
-		 * page_count() is not 0.
-		 */
-		if ((mode == PB_ISOLATE_MODE_MEM_OFFLINE) && PageHWPoison(page))
-			continue;
-
-		/*
-		 * We treat all PageOffline() pages as movable when offlining
-		 * to give drivers a chance to decrement their reference count
-		 * in MEM_GOING_OFFLINE in order to indicate that these pages
-		 * can be offlined as there are no direct references anymore.
-		 * For actually unmovable PageOffline() where the driver does
-		 * not support this, we will fail later when trying to actually
-		 * move these pages that still have a reference count > 0.
-		 * (false negatives in this function only)
-		 */
-		if ((mode == PB_ISOLATE_MODE_MEM_OFFLINE) && PageOffline(page))
-			continue;
-
-		if (PageLRU(page) || page_has_movable_ops(page))
-			continue;
-
-		/*
-		 * If there are RECLAIMABLE pages, we need to check
-		 * it.  But now, memory offline itself doesn't call
-		 * shrink_node_slabs() and it still to be fixed.
-		 */
-		return page;
+		start_pfn += step;
 	}
 	return NULL;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-kill-cma_pages_valid.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch
mm-page_isolation-introduce-page_is_unmovable.patch
mm-page_alloc-optimize-pfn_range_valid_contig.patch
mm-hugetlb-optimize-replace_free_hugepage_folios.patch
mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch

