Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF516FBF
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956149; cv=none; b=JlLU/YKkUt81qcelN4HnOn9Lo2iQGKsVD2WlI+WbKOmDAEb2ccSxgk9jVRGRbaY35qNBqpTJ7pxH9vGDHzHwTyYHn70Pu/GnYqTj/UcyAitamdwGlrienenjxlySPaSwV0yS4T5htVsi9y4JscH+aGlxwZ+Yj9pPZ2qzgWC85mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956149; c=relaxed/simple;
	bh=maQWuhW5Dbl7pRkFVGNgg84KDPuHdZlZIL8/qnN2Y0Y=;
	h=Date:To:From:Subject:Message-Id; b=l6pe7x31mHKuCTg/3+fBGym5ow2QOdyeXasNt5E3n0/XjWYjdKtTYFKHAldI5LwZISmIEyzUS8TUJm0Af6LbWhj1nOBJHb97B/r0LRb+ll+W0y/qK4oDlFDINC3vxokRZi8UoUMob/eJSPsUdp1KVts3H3bHTjQmmCi9vADXjUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y8ToqOyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y8ToqOyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0B5C116B1;
	Mon,  6 May 2024 00:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956149;
	bh=maQWuhW5Dbl7pRkFVGNgg84KDPuHdZlZIL8/qnN2Y0Y=;
	h=Date:To:From:Subject:From;
	b=Y8ToqOyNRS9xmfP8RheA+R+nHzEUksaWr/8yIZMVSDn3Rr6YLtP3uIgB4FI/TN1H5
	 3g7CVUueed6632+9XC4CTcyHi4Jzr7rg6WDhNuGSp389SMo02xBQfOCf14bdzppnjg
	 1+nzeuFUx1pfuWZPbXyYaSFzD/IPisBJkiIEaAzE=
Date: Sun, 05 May 2024 17:42:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2.patch removed from -mm tree
Message-Id: <20240506004229.4C0B5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: convert dissolve_free_huge_pages() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2.patch

This patch was dropped because it was folded into mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert dissolve_free_huge_pages() to folios
Date: Fri, 12 Apr 2024 11:21:38 -0700

Change additional comments which reference hugepages to hugetlb folios per
Miaohe Lin.  

Link: https://lkml.kernel.org/r/20240412182139.120871-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |    4 ++--
 mm/memory-failure.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2
+++ a/mm/hugetlb.c
@@ -2378,7 +2378,7 @@ static struct folio *remove_pool_hugetlb
 
 /*
  * Dissolve a given free hugetlb folio into free buddy pages. This function
- * does nothing for in-use hugepages and non-hugepages.
+ * does nothing for in-use hugetlb folios and non-hugetlb folios.
  * This function returns values like below:
  *
  *  -ENOMEM: failed to allocate vmemmap pages to free the freed hugepages
@@ -2470,7 +2470,7 @@ out:
  * Note that this will dissolve a free gigantic hugepage completely, if any
  * part of it lies within the given range.
  * Also note that if dissolve_free_hugetlb_folio() returns with an error, all
- * free hugepages that were dissolved before that error are lost.
+ * free hugetlb folios that were dissolved before that error are lost.
  */
 int dissolve_free_huge_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
--- a/mm/memory-failure.c~mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2
+++ a/mm/memory-failure.c
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

mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch

