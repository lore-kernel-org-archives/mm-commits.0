Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656E831A55B
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 22:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768516958; cv=none; b=sXEsJVUjKm/91t0hTdj1gl8QzOuf/Nox0ZSyo4iE+rO/wz2kcyqgJboZKkqqZWuyhB5BRnkehaNsLXebJxtWrAHAYgqWOYzBuf0OXoeNLbEj5iWpB1iwM6soqVOvlk4QokhXVBZPCShgvDFD2C5JH9KJd4dVefURYNkYg2ybXV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768516958; c=relaxed/simple;
	bh=ZeMkRnIFIdWiea+lk0nI2gRDFK0HMpuiLaP8aSDprGw=;
	h=Date:To:From:Subject:Message-Id; b=nGIWvXwTD8SCLD685LD8NU6C1mgC5Lt0mcrC76YswlZB4zZU87wN9uVznohG+NCaUlAWdg5FOk0qMLVpwwbe6SUqs5OUtBUo0Pv3CXWoWF5BQLqxPPO1+SWglf9Dl4WXlJ7lo3JFv41a0UUV9aN473WXWhvcnS/yz44aL46qDS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HkvRoO50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HkvRoO50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A30C116D0;
	Thu, 15 Jan 2026 22:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768516957;
	bh=ZeMkRnIFIdWiea+lk0nI2gRDFK0HMpuiLaP8aSDprGw=;
	h=Date:To:From:Subject:From;
	b=HkvRoO500WH93IFZmA3VvE/UsiJdtgaovxRVcTSAzqwdNCf17IP6fi9HUHjlkLmhH
	 nc/8017O5BYe2CB+Yx4Ho2Blw81WvslUwqZSOZAKG7TVn5ctesEaDlDfWJ3V/zBwKJ
	 a4QBxbTv+rnMxHddlCH3j9poYFNex1sV6pFog1Qg=
Date: Thu, 15 Jan 2026 14:42:37 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-optimize-replace_free_hugepage_folios-v2.patch added to mm-unstable branch
Message-Id: <20260115224237.C9A30C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: optimize replace_free_hugepage_folios()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-optimize-replace_free_hugepage_folios-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-optimize-replace_free_hugepage_folios-v2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm: hugetlb: optimize replace_free_hugepage_folios()
Date: Wed, 14 Jan 2026 21:55:12 +0800

Turn back to use alloc_and_dissolve_hugetlb_folio() since Oscar pointed
out that the return value is different.  Then adding gigantic folio check
independently, also update changelog.

Link: https://lkml.kernel.org/r/20260114135512.2159799-1-wangkefeng.wang@huawei.com
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

 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-optimize-replace_free_hugepage_folios-v2
+++ a/mm/hugetlb.c
@@ -2810,6 +2810,7 @@ int replace_free_hugepage_folios(unsigne
 	struct page *page;
 	struct hstate *h;
 	LIST_HEAD(list);
+	int ret = 0;
 
 	/* Avoid pfn iterations if no free non-gigantic huge pages */
 	for_each_hstate(h) {
@@ -2835,9 +2836,13 @@ int replace_free_hugepage_folios(unsigne
 
 			/* Not to disrupt normal path by vainly holding hugetlb_lock */
 			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
-				if (isolate_or_dissolve_huge_folio(folio, &list))
+				if (order_is_gigantic(folio_order(folio)))
 					return -ENOMEM;
 
+				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
+				if (ret)
+					break;
+
 				putback_movable_pages(&list);
 			}
 		} else if (PageBuddy(page)) {
@@ -2851,11 +2856,10 @@ int replace_free_hugepage_folios(unsigne
 			if (order <= MAX_PAGE_ORDER)
 				nr = 1UL << order;
 		}
-
 		start_pfn += nr;
 	}
 
-	return 0;
+	return ret;
 }
 
 void wait_for_freed_hugetlb_folios(void)
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
mm-hugetlb-optimize-replace_free_hugepage_folios-v2.patch
mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch

