Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10C038A734
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898323; cv=none; b=MjD+hQ+2fHrWLBgxDN59pO3PIgRnTDsk81Wwnfjnd2rS8IQR/S46EL+OG57JEa0LIqh4mDIeclg92d/9ebQqu/jHLiK9nGHSM+1rCq/ke+zunebRjbDb3A+e6PKHWOnlwM/uwfPGvqin1lrK3Q3cYn+m0ck0K6DdnafjZklWxUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898323; c=relaxed/simple;
	bh=cQDE92K1tMgjww1UAolyGVJDF6N3y00h3/gvz/+A68A=;
	h=Date:To:From:Subject:Message-Id; b=CdhaMfqE+XHTBL7NiHVS0fMjIJraA9LrNErJmar3ixMyyCOAv/Qcu86O/nHvfLrg/81I5oeUZjzKO4sRfgMARvRrisB8nvBHpRhdwAWfa4TuYRBmuvkAX4nr4/zUv+nfVYEkQbWefskP6kkGmoJl7NIEWKM9CHnxKUQ25HUdNcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uAsxzOv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uAsxzOv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B956AC4CEF1;
	Sat, 31 Jan 2026 22:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898322;
	bh=cQDE92K1tMgjww1UAolyGVJDF6N3y00h3/gvz/+A68A=;
	h=Date:To:From:Subject:From;
	b=uAsxzOv94or75qMWgMTdNqDvNicBAddVjT0WoCp0dCDP+DG3aWSBAWhIsY1VLc8Yv
	 lSJLoBISwc3qV6KV5tjIr7qun3R3zeiEn7J2IIsDg7Eur1AcfFZWLN8Nii3ZVIjpJA
	 ZCmnvlRfP7UI+qDcLFqWDW01/n5DOmVtZstgXc+4=
Date: Sat, 31 Jan 2026 14:25:22 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-optimize-replace_free_hugepage_folios.patch removed from -mm tree
Message-Id: <20260131222522.B956AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: optimize replace_free_hugepage_folios()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-optimize-replace_free_hugepage_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: optimize replace_free_hugepage_folios()
Date: Mon, 12 Jan 2026 23:09:52 +0800

If no free hugepage folios are available, there is no need to perform any
replacement operations.  Additionally, gigantic folios should not be
replaced under any circumstances.  Therefore, we only check for the
presence of non-gigantic folios, also adding the gigantic folio check to
avoid accidental replacement.

To optimize performance, we skip unnecessary iterations over pfn for
compound pages and high-order buddy pages to save processing time.

A simple test on machine with 114G free memory, allocate 120 * 1G HugeTLB
folios(104 successfully returned),

  time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

Before: 0m0.602s
After:  0m0.431s

[wangkefeng.wang@huawei.com: v2]
  Link: https://lkml.kernel.org/r/20260114135512.2159799-1-wangkefeng.wang@huawei.com
[akpm@linux-foundation.org: use single-return-point style, tweak comment]
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

 mm/hugetlb.c |   59 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-optimize-replace_free_hugepage_folios
+++ a/mm/hugetlb.c
@@ -2810,23 +2810,62 @@ int isolate_or_dissolve_huge_folio(struc
  */
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 {
-	struct folio *folio;
+	unsigned long nr = 0;
+	struct page *page;
+	struct hstate *h;
+	LIST_HEAD(list);
 	int ret = 0;
 
-	LIST_HEAD(isolate_list);
+	/* Avoid pfn iterations if no free non-gigantic huge pages */
+	for_each_hstate(h) {
+		if (hstate_is_gigantic(h))
+			continue;
+
+		nr += h->free_huge_pages;
+		if (nr)
+			break;
+	}
+
+	if (!nr)
+		return 0;
 
 	while (start_pfn < end_pfn) {
-		folio = pfn_folio(start_pfn);
+		page = pfn_to_page(start_pfn);
+		nr = 1;
+
+		if (PageHuge(page) || PageCompound(page)) {
+			struct folio *folio = page_folio(page);
+
+			nr = folio_nr_pages(folio) - folio_page_idx(folio, page);
+
+			/*
+			 * Don't disrupt normal path by vainly holding
+			 * hugetlb_lock
+			 */
+			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
+				if (order_is_gigantic(folio_order(folio))) {
+					ret = -ENOMEM;
+					break;
+				}
+
+				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
+				if (ret)
+					break;
 
-		/* Not to disrupt normal path by vainly holding hugetlb_lock */
-		if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
-			ret = alloc_and_dissolve_hugetlb_folio(folio, &isolate_list);
-			if (ret)
-				break;
+				putback_movable_pages(&list);
+			}
+		} else if (PageBuddy(page)) {
+			/*
+			 * Buddy order check without zone lock is unsafe and
+			 * the order is maybe invalid, but race should be
+			 * small, and the worst thing is skipping free hugetlb.
+			 */
+			const unsigned int order = buddy_order_unsafe(page);
 
-			putback_movable_pages(&isolate_list);
+			if (order <= MAX_PAGE_ORDER)
+				nr = 1UL << order;
 		}
-		start_pfn++;
+		start_pfn += nr;
 	}
 
 	return ret;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


