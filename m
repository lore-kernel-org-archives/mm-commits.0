Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3020A2CA6
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 04:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743652862; cv=none; b=QyYp/R9AwtJ97y0kbpgxmvuecEWY5r+EQ0zH+7yBZ/nR1/EIsHaKfRvdcipSm8KTjK675VvwE9owbBswXDZbPKR2bGmHANUFpKtnHkwwHfcMq4OnzYaI0Mpz9liY9RA2q4F1bpKq+RPhOQZgQkTjYSSz05vkbVCUlLkXaeS0Y7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743652862; c=relaxed/simple;
	bh=RaqFsJnTaUk8sBKdlr2VIj9ZxdvwjJG4Y2LbcP7jnQY=;
	h=Date:To:From:Subject:Message-Id; b=EagLiTJ+UsG8dGUK/YOEloT5EqU2w5gr+9Is3CAh0Tqaow6pC5albEhHHX5Df/FL/b/2SRWQ0G5xHf8eSrLXoWpqfOQ4Sz3vvrfDd48WljtEHceces6GPzQf4IlJeBrItz92zZ0wZ7TRFh5zibpjMpCrqrYIq9EW3xVYjZP0AGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ooVsxJMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ooVsxJMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8387DC4CEE3;
	Thu,  3 Apr 2025 04:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743652861;
	bh=RaqFsJnTaUk8sBKdlr2VIj9ZxdvwjJG4Y2LbcP7jnQY=;
	h=Date:To:From:Subject:From;
	b=ooVsxJMysDnkg3ElyES8VVs9TGIrUiPteCHcFc/T0bTlIED3epU81I+2UpsBLDKO8
	 mwObMqVZ/Z1qrFeR9wfiYLf/tPjWGBk426LB4ey77ATnJNq87KIA6eeVAKz9TfWBLv
	 NMsqo6RTIj833qP/guFn7tsGAHPYnyoNlmAik4NE=
Date: Wed, 02 Apr 2025 21:01:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,osalvador@suse.de,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-use-folio-in-hugetlb-pathway.patch added to mm-new branch
Message-Id: <20250403040101.8387DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: use folio in hugetlb pathway
has been added to the -mm mm-new branch.  Its filename is
     mm-compaction-use-folio-in-hugetlb-pathway.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-use-folio-in-hugetlb-pathway.patch

This patch will later appear in the mm-new branch at
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
@@ -698,7 +698,7 @@ struct huge_bootmem_page {
 
 bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
 
-int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
+int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
@@ -1086,7 +1086,7 @@ static inline struct folio *filemap_lock
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
@@ -2897,10 +2897,9 @@ free_new:
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

mm-compaction-fix-bug-in-hugetlb-handling-pathway.patch
mm-compaction-use-folio-in-hugetlb-pathway.patch

