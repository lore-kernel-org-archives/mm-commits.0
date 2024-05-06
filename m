Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B531DFD2
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957034; cv=none; b=fmrsGO/HNhPi5ebQ8lA0OQMmzXznXehc0xWlEH+Wy5bRhzp/XzwBs2JebLkPHszste6q5IqD4fKqNVXxTVRQqMMko3KcvR+ZOZJ5qOkiNsIWfPBax8OgyHrRRV3Vp2FM1JX5vaGRTEii7VglKasn0GZEzubcob73il9gOCbuDbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957034; c=relaxed/simple;
	bh=orn6LJbbEB2TPz/SPdC39NInBGUG1vIT5IXMJFLd9xs=;
	h=Date:To:From:Subject:Message-Id; b=OGmCh8r+9YVRmVx/LpC2ShgekVNkWpod9TNRCFtOTB7I82RLde/L3oeWXzJ+bd3fsfWbQ7greOaJpQUY14JQjFfzl8+26CDBkAjUHRAj5kqh5L0rr1Lfl1srSb6GCSrUQKHqOL56qF1Lm5hlEhB/7qy4IGC4DwZErj8xpaLjiVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=08vGXTIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="08vGXTIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F83C116B1;
	Mon,  6 May 2024 00:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957034;
	bh=orn6LJbbEB2TPz/SPdC39NInBGUG1vIT5IXMJFLd9xs=;
	h=Date:To:From:Subject:From;
	b=08vGXTImGbhlT1WYwFtCOAtE9RM25qDfLXFuCkVgZ3APyM8oPbrEWIA5FW51LTB7Q
	 VfCSvgvYcFALCRkhoEY/BXtF84VlaT4hmEjDZnEtH524TPuBf8GNQ358bmI2FM7qM8
	 Zm7XxM0Eh5S1zJ2nY7DzhUZADXefFsKXBB7AIiuQ=
Date: Sun, 05 May 2024 17:57:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch removed from -mm tree
Message-Id: <20240506005713.F0F83C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: convert dissolve_free_huge_pages() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert dissolve_free_huge_pages() to folios
Date: Thu, 11 Apr 2024 09:47:56 -0700

Allows us to rename dissolve_free_huge_pages() to
dissolve_free_hugetlb_folio(). Convert one caller to pass in a folio
directly and use page_folio() to convert the caller in mm/memory-failure.

[sidhartha.kumar@oracle.com: remove unneeded `extern']
  Link: https://lkml.kernel.org/r/71760ed4-e80d-493a-95ea-2545414b1aba@oracle.com
[sidhartha.kumar@oracle.com: v2]
  Link: https://lkml.kernel.org/r/20240412182139.120871-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20240411164756.261178-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |   17 ++++++++---------
 mm/memory-failure.c     |    8 ++++----
 3 files changed, 14 insertions(+), 15 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-convert-dissolve_free_huge_pages-to-folios
+++ a/include/linux/hugetlb.h
@@ -861,7 +861,7 @@ static inline int hstate_index(struct hs
 	return h - hstates;
 }
 
-extern int dissolve_free_huge_page(struct page *page);
+int dissolve_free_hugetlb_folio(struct folio *folio);
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
+ * does nothing for in-use hugetlb folios and non-hugetlb folios.
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
- * free hugepages that were dissolved before that error are lost.
+ * Also note that if dissolve_free_hugetlb_folio() returns with an error, all
+ * free hugetlb folios that were dissolved before that error are lost.
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
@@ -155,7 +155,7 @@ static int __page_handle_poison(struct p
 
 	/*
 	 * zone_pcp_disable() can't be used here. It will
-	 * hold pcp_batch_high_lock and dissolve_free_huge_page() might hold
+	 * hold pcp_batch_high_lock and dissolve_free_hugetlb_folio() might hold
 	 * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemmap
 	 * optimization is enabled. This will break current lock dependency
 	 * chain and leads to deadlock.
@@ -165,7 +165,7 @@ static int __page_handle_poison(struct p
 	 * but nothing guarantees that those pages do not get back to a PCP
 	 * queue if we need to refill those.
 	 */
-	ret = dissolve_free_huge_page(page);
+	ret = dissolve_free_hugetlb_folio(page_folio(page));
 	if (!ret) {
 		drain_all_pages(page_zone(page));
 		ret = take_page_off_buddy(page);
@@ -178,8 +178,8 @@ static bool page_handle_poison(struct pa
 {
 	if (hugepage_or_freepage) {
 		/*
-		 * Doing this check for free pages is also fine since dissolve_free_huge_page
-		 * returns 0 for non-hugetlb pages as well.
+		 * Doing this check for free pages is also fine since
+		 * dissolve_free_hugetlb_folio() returns 0 for non-hugetlb folios as well.
 		 */
 		if (__page_handle_poison(page) <= 0)
 			/*
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


