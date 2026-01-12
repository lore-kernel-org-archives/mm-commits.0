Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840E83793B3
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 17:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238498; cv=none; b=diWbz4na5UtdChec586VvJLxuvk8PvejRHcBJNG1vmqI21rblCoVUn5oIM1F7NIlp3qSPLPfPPTJHs0Ssb2iQPr+RS/oVDnCbafbUMWQV15iDGs3nMqDrAvgBmOKEgzfcEYronBmGXftcR2BHkeysFQfieiYxQQkDSzdOj58ztQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238498; c=relaxed/simple;
	bh=XIfIh5ef/Ch+0OFy7kwZTEkHkXeYC6eQ23/o6nEEV9c=;
	h=Date:To:From:Subject:Message-Id; b=UBBkDMcyFMmvuHgcsi65XinG6JQtyfYstBoHllghfOo7VGhdFrugtdiJhMLPMpDmHbYMj33IALY/jsx65KYAXJk70J1Bbi1K9iXpQSengG78YGR/D6TMxZGfs6bQ2O+DS6XsnKLSqfnxzbkejCvG+wWXi8tF5QPURv7L06/PvXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rb1yMwpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rb1yMwpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2A6C116D0;
	Mon, 12 Jan 2026 17:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768238498;
	bh=XIfIh5ef/Ch+0OFy7kwZTEkHkXeYC6eQ23/o6nEEV9c=;
	h=Date:To:From:Subject:From;
	b=rb1yMwpx9kNvV7d/WHocEhOi4CSpPOetODmzTy1mptmYcRSyZysymV9lEdHm/KZ0y
	 BYIlfpylu4PRvNcThQYmhqo5xO3lDpnJhKYnqQtI8F1Kpezr5DVfQ5doFzGoB3vzNN
	 J2Dy3nhA7xntYL7TRHhDHu71hQkn7P9ReFz4b59g=
Date: Mon, 12 Jan 2026 09:21:37 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-optimize-replace_free_hugepage_folios.patch added to mm-new branch
Message-Id: <20260112172138.0B2A6C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: optimize replace_free_hugepage_folios()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-optimize-replace_free_hugepage_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-optimize-replace_free_hugepage_folios.patch

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
Subject: mm: hugetlb: optimize replace_free_hugepage_folios()
Date: Mon, 12 Jan 2026 23:09:52 +0800

If no free hugepage folios are available, there is no need to perform any
replacement operations.  Additionally, gigantic folios should not be
replaced under any circumstances.  Therefore, we only check for the
presence of non-gigantic folios.

To ensure that gigantic folios are not mistakenly replaced, we utilize
isolate_or_dissolve_huge_folio().

Lastly, to optimize performance, we skip unnecessary iterations over pfn
for compound pages and high-order buddy pages to save processing time.

A simple test on machine with 114G free memory, allocate 120 * 1G HugeTLB
folios(104 successfully returned),

  time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

Before: 0m0.602s
After:  0m0.431s

Link: https://lkml.kernel.org/r/20260112150954.1802953-4-wangkefeng.wang@huawei.com
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

 mm/hugetlb.c |   54 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 12 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-optimize-replace_free_hugepage_folios
+++ a/mm/hugetlb.c
@@ -2806,26 +2806,56 @@ int isolate_or_dissolve_huge_folio(struc
  */
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 {
-	struct folio *folio;
-	int ret = 0;
+	unsigned long nr = 0;
+	struct page *page;
+	struct hstate *h;
+	LIST_HEAD(list);
+
+	/* Avoid pfn iterations if no free non-gigantic huge pages */
+	for_each_hstate(h) {
+		if (hstate_is_gigantic(h))
+			continue;
+
+		nr += h->free_huge_pages;
+		if (nr)
+			break;
+	}
 
-	LIST_HEAD(isolate_list);
+	if (!nr)
+		return 0;
 
 	while (start_pfn < end_pfn) {
-		folio = pfn_folio(start_pfn);
+		page = pfn_to_page(start_pfn);
+		nr = 1;
+
+		if (PageHuge(page) || PageCompound(page)) {
+			struct folio *folio = page_folio(page);
 
-		/* Not to disrupt normal path by vainly holding hugetlb_lock */
-		if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
-			ret = alloc_and_dissolve_hugetlb_folio(folio, &isolate_list);
-			if (ret)
-				break;
+			nr = folio_nr_pages(folio) - folio_page_idx(folio, page);
 
-			putback_movable_pages(&isolate_list);
+			/* Not to disrupt normal path by vainly holding hugetlb_lock */
+			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
+				if (isolate_or_dissolve_huge_folio(folio, &list))
+					return -ENOMEM;
+
+				putback_movable_pages(&list);
+			}
+		} else if (PageBuddy(page)) {
+			/*
+			 * Buddy order check without zone lock is unsafe and
+			 * the order is maybe invalid, but race should be
+			 * small, and the worst thing is skipping free hugetlb.
+			 */
+			const unsigned int order = buddy_order_unsafe(page);
+
+			if (order <= MAX_PAGE_ORDER)
+				nr = 1UL << order;
 		}
-		start_pfn++;
+
+		start_pfn += nr;
 	}
 
-	return ret;
+	return 0;
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
mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch

