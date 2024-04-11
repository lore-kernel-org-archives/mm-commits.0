Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBE312E6C
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 21:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712869904; cv=none; b=iBukTrZreMV2MDlDA/sahMexEw4CWpLj8qkS4pqNcO4pcjxViSOn6SZL6UJ7v30nIwBFkLOQHiGR7OQNsN16CWTHA9RFCkCO97q2e12I/HqXEG6rQNNeY0G/OhIgAQDljrHx8iN917jJmPbC8LAlSSdymG2feKzd7Jc6G28DBqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712869904; c=relaxed/simple;
	bh=b+fEN+AV2q8gfUmM/jyU+NnI90UxI5ZpIV311jKbO+g=;
	h=Date:To:From:Subject:Message-Id; b=uYTXa0GArpHPbRNcqaCijw/5FeyMTyIhGaOTkBfOhXdQdQrPeboCRsNKtJCqgdqLrJl4powPS7GrqsvqRKA70xps671d6RF4Z8GtYhiaQd++DgZbgsF1L2nW7qADVBGmS8aq9mTG5TAedX3P59O5XcGLyhcJoJ40rU6oV2BO7M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=onf4FZbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="onf4FZbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1D4C072AA;
	Thu, 11 Apr 2024 21:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712869903;
	bh=b+fEN+AV2q8gfUmM/jyU+NnI90UxI5ZpIV311jKbO+g=;
	h=Date:To:From:Subject:From;
	b=onf4FZbfm1FUMR0XH5kt0pcCbWWH+VO4ZTr47HSwCAnoxCnLMYlcZ6xKG213RnMbH
	 POXxHORbUHE+l/JGSAS57Pul926hgLWXCbOtIZN+emPdJ5dddQWeLLcobwKp5v4FYb
	 2HivFU/OiSErnWyIVtuAzy2ERMtwDwP+ACEaSbnQ=
Date: Thu, 11 Apr 2024 14:11:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch added to mm-unstable branch
Message-Id: <20240411211143.DC1D4C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: convert dissolve_free_huge_pages() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert dissolve_free_huge_pages() to folios
Date: Thu, 11 Apr 2024 09:47:56 -0700

Allows us to rename dissolve_free_huge_pages() to
dissolve_free_hugetlb_folio().  Convert one caller to pass in a folio
directly and use page_folio() to convert the caller in mm/memory-failure.

Link: https://lkml.kernel.org/r/20240411164756.261178-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |   15 +++++++--------
 mm/memory-failure.c     |    4 ++--
 3 files changed, 11 insertions(+), 12 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-convert-dissolve_free_huge_pages-to-folios
+++ a/include/linux/hugetlb.h
@@ -861,7 +861,7 @@ static inline int hstate_index(struct hs
 	return h - hstates;
 }
 
-extern int dissolve_free_huge_page(struct page *page);
+extern int dissolve_free_hugetlb_folio(struct folio *folio);
 extern int dissolve_free_huge_pages(unsigned long start_pfn,
 				    unsigned long end_pfn);
 
@@ -1148,7 +1148,7 @@ static inline int hstate_index(struct hs
 	return 0;
 }
 
-static inline int dissolve_free_huge_page(struct page *page)
+static inline int dissolve_free_hugetlb_folio(struct folio *folio)
 {
 	return 0;
 }
--- a/mm/hugetlb.c~mm-hugetlb-convert-dissolve_free_huge_pages-to-folios
+++ a/mm/hugetlb.c
@@ -2377,8 +2377,8 @@ static struct folio *remove_pool_hugetlb
 }
 
 /*
- * Dissolve a given free hugepage into free buddy pages. This function does
- * nothing for in-use hugepages and non-hugepages.
+ * Dissolve a given free hugetlb folio into free buddy pages. This function
+ * does nothing for in-use hugepages and non-hugepages.
  * This function returns values like below:
  *
  *  -ENOMEM: failed to allocate vmemmap pages to free the freed hugepages
@@ -2390,10 +2390,9 @@ static struct folio *remove_pool_hugetlb
  *       0:  successfully dissolved free hugepages or the page is not a
  *           hugepage (considered as already dissolved)
  */
-int dissolve_free_huge_page(struct page *page)
+int dissolve_free_hugetlb_folio(struct folio *folio)
 {
 	int rc = -EBUSY;
-	struct folio *folio = page_folio(page);
 
 retry:
 	/* Not to disrupt normal path by vainly holding hugetlb_lock */
@@ -2470,13 +2469,13 @@ out:
  * make specified memory blocks removable from the system.
  * Note that this will dissolve a free gigantic hugepage completely, if any
  * part of it lies within the given range.
- * Also note that if dissolve_free_huge_page() returns with an error, all
+ * Also note that if dissolve_free_hugetlb_folio() returns with an error, all
  * free hugepages that were dissolved before that error are lost.
  */
 int dissolve_free_huge_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
-	struct page *page;
+	struct folio *folio;
 	int rc = 0;
 	unsigned int order;
 	struct hstate *h;
@@ -2489,8 +2488,8 @@ int dissolve_free_huge_pages(unsigned lo
 		order = min(order, huge_page_order(h));
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << order) {
-		page = pfn_to_page(pfn);
-		rc = dissolve_free_huge_page(page);
+		folio = pfn_folio(pfn);
+		rc = dissolve_free_hugetlb_folio(folio);
 		if (rc)
 			break;
 	}
--- a/mm/memory-failure.c~mm-hugetlb-convert-dissolve_free_huge_pages-to-folios
+++ a/mm/memory-failure.c
@@ -155,11 +155,11 @@ static int __page_handle_poison(struct p
 
 	/*
 	 * zone_pcp_disable() can't be used here. It will hold pcp_batch_high_lock and
-	 * dissolve_free_huge_page() might hold cpu_hotplug_lock via static_key_slow_dec()
+	 * dissolve_free_hugetlb_folio() might hold cpu_hotplug_lock via static_key_slow_dec()
 	 * when hugetlb vmemmap optimization is enabled. This will break current lock
 	 * dependency chain and leads to deadlock.
 	 */
-	ret = dissolve_free_huge_page(page);
+	ret = dissolve_free_hugetlb_folio(page_folio(page));
 	if (!ret) {
 		drain_all_pages(page_zone(page));
 		ret = take_page_off_buddy(page);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch

