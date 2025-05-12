Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC2E14830F
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011008; cv=none; b=lhJXS6NWHXc87l3i5qMdtjFu9qr6TaCIRvoKaDQ7oBjKJTXVP1wPQWMUByD3qGtCfwXwPQA8fVbK7ceNZ0SmPfF5RnDFWiD5EEO/HslsSiBqkplBo0+rI49jcFAzb3NghtcToDqSkHLlhhhKd7Exa5WGLg4nP3PMC6sl0vrqE+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011008; c=relaxed/simple;
	bh=VZMtRvRKgmbXDp1eioMuZ8LlSxWfgWb7tx96OZlGl/I=;
	h=Date:To:From:Subject:Message-Id; b=qCAIG9UADjXW+x2rDuiJFlGpiK+sroEy4zDhdGGl7i19DkckxQm5IlX7GBpEkqdBu/HbJrLpemWHf0Bwf0EpkmfTLEhpDOmhTq2sxYbRS3rp7Z/x211mD5PdPFxBwMCpqWxNjuBaXfuMSK8OI0A8OjaYRfaIXrKr13itGCKUZUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ifAA5dtq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ifAA5dtq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC85C4CEE4;
	Mon, 12 May 2025 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011008;
	bh=VZMtRvRKgmbXDp1eioMuZ8LlSxWfgWb7tx96OZlGl/I=;
	h=Date:To:From:Subject:From;
	b=ifAA5dtqU0/o08BQi7v5Ek+22X0QiqRbRbv4HdFMljdcQy5Xu+0notxfQm5GtRX9a
	 X+0c2JrdkAwcPzdxnmnh1dfEYlC6mYG67EmT8y6QzwBFq7UtGJyPthyfR61HBZDXpD
	 r8LiGaiBRQVi/RZOyOO1M+VrJMbgojdV5h01muIM=
Date: Sun, 11 May 2025 17:50:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,osalvador@suse.de,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-use-folio-in-hugetlb-pathway.patch removed from -mm tree
Message-Id: <20250512005007.EEC85C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: use folio in hugetlb pathway
has been removed from the -mm tree.  Its filename was
     mm-compaction-use-folio-in-hugetlb-pathway.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/compaction: use folio in hugetlb pathway
Date: Mon, 31 Mar 2025 19:10:25 -0700

Use a folio in the hugetlb pathway during the compaction migrate-able
pageblock scan.

This removes a call to compound_head().

Link: https://lkml.kernel.org/r/20250401021025.637333-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/compaction.c         |    8 ++++----
 mm/hugetlb.c            |    3 +--
 3 files changed, 7 insertions(+), 8 deletions(-)

--- a/include/linux/hugetlb.h~mm-compaction-use-folio-in-hugetlb-pathway
+++ a/include/linux/hugetlb.h
@@ -695,7 +695,7 @@ struct huge_bootmem_page {
 
 bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
 
-int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
+int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
@@ -1083,7 +1083,7 @@ static inline struct folio *filemap_lock
 	return NULL;
 }
 
-static inline int isolate_or_dissolve_huge_page(struct page *page,
+static inline int isolate_or_dissolve_huge_folio(struct folio *folio,
 						struct list_head *list)
 {
 	return -ENOMEM;
--- a/mm/compaction.c~mm-compaction-use-folio-in-hugetlb-pathway
+++ a/mm/compaction.c
@@ -1001,10 +1001,11 @@ isolate_migratepages_block(struct compac
 				locked = NULL;
 			}
 
-			ret = isolate_or_dissolve_huge_page(page, &cc->migratepages);
+			folio = page_folio(page);
+			ret = isolate_or_dissolve_huge_folio(folio, &cc->migratepages);
 
 			/*
-			 * Fail isolation in case isolate_or_dissolve_huge_page()
+			 * Fail isolation in case isolate_or_dissolve_huge_folio()
 			 * reports an error. In case of -ENOMEM, abort right away.
 			 */
 			if (ret < 0) {
@@ -1016,12 +1017,11 @@ isolate_migratepages_block(struct compac
 				goto isolate_fail;
 			}
 
-			if (PageHuge(page)) {
+			if (folio_test_hugetlb(folio)) {
 				/*
 				 * Hugepage was successfully isolated and placed
 				 * on the cc->migratepages list.
 				 */
-				folio = page_folio(page);
 				low_pfn += folio_nr_pages(folio) - 1;
 				goto isolate_success_no_list;
 			}
--- a/mm/hugetlb.c~mm-compaction-use-folio-in-hugetlb-pathway
+++ a/mm/hugetlb.c
@@ -2896,10 +2896,9 @@ free_new:
 	return ret;
 }
 
-int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
+int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list)
 {
 	struct hstate *h;
-	struct folio *folio = page_folio(page);
 	int ret = -EBUSY;
 
 	/*
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-gup-remove-unnecessary-check-in-memfd_pin_folios.patch
mm-gup-remove-page_folio-in-memfd_pin_folios.patch

