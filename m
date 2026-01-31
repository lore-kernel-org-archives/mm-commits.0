Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24F838A734
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898321; cv=none; b=DhrqhoR+rxgGxJNV6+hGPoT1J1gCam2Kc70OQXReUqFRd6fmI/Qje1GDvqhqZBf7rbJxf81wPqLdeTgdIHU8NlBjCFF/IpmzE2namoDE9cJ8ixOyqyuhgwqdtyxibvKm7Kc5EGWl0q04rtg4IijgLoCWaSeXIZ/ITELxDfwUJTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898321; c=relaxed/simple;
	bh=/kjeo3IjsH1IfelxSI08aq6Dc9bgVTFTIYKSI9KMQFU=;
	h=Date:To:From:Subject:Message-Id; b=KFgh4F8nXBgbt+G4bOoAPQokJh4xtYdm9JoJLyKU8APXQ+dVu9itxdEUp2xIi5pBRvKIuqMe2oD7eCHFPuj+7cMHDkfwpu7/nZy6PRnvuiSQeKiGXEnlfBjop0H5GqjWU4YVsgH7+1C/q4xSo/eDEQy+lUS/UDr0JiBrlPQnX7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZjNWP5lw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZjNWP5lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81096C4CEF1;
	Sat, 31 Jan 2026 22:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898321;
	bh=/kjeo3IjsH1IfelxSI08aq6Dc9bgVTFTIYKSI9KMQFU=;
	h=Date:To:From:Subject:From;
	b=ZjNWP5lwT6h4n7JlE56abwIZOTktpoyBOTT5bDDmgaPoIoj7fo/hbs4PSo8z+eVqD
	 oosq326+0ac+3KQnXTd9FLt96rUdQh82q1V2BkEOeOKzCxsxiOS+ANDPKOZ4GUpC4j
	 MWyTlgGbg6FkMpy1JFyUxSQSvJ3HWatYDTIJO3Pk=
Date: Sat, 31 Jan 2026 14:25:21 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-optimize-pfn_range_valid_contig.patch removed from -mm tree
Message-Id: <20260131222521.81096C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: optimize pfn_range_valid_contig()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-optimize-pfn_range_valid_contig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: optimize pfn_range_valid_contig()
Date: Mon, 12 Jan 2026 23:09:51 +0800

The alloc_contig_pages() spends a significant amount of time within
pfn_range_valid_contig().

- set_max_huge_pages
   - 99.98% alloc_pool_huge_folio
        only_alloc_fresh_hugetlb_folio.isra.0
      - alloc_contig_frozen_pages_noprof
         - 87.00% pfn_range_valid_contig
              pfn_to_online_page
         - 12.91% alloc_contig_frozen_range_noprof
              4.51% replace_free_hugepage_folios
            - 4.02% prep_new_page
                 prep_compound_page
            - 2.98% undo_isolate_page_range
               - 2.79% unset_migratetype_isolate
                  - 2.75% __move_freepages_block_isolate
                       2.71% __move_freepages_block
            - 0.98% start_isolate_page_range
                 0.66% set_migratetype_isolate

To optimize this process, use the new helper page_is_unmovable() to avoid
more unnecessary iterations for compound pages, such as THP not on LRU,
and high-order buddy pages, which significantly improving the efficiency
of contiguous memory allocation.

A simple test on machine with 114G free memory, allocate 120 * 1G
HugeTLB folios(104 successfully returned),

  time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

Before: 0m3.605s
After:  0m0.602s

Link: https://lkml.kernel.org/r/20260112150954.1802953-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-optimize-pfn_range_valid_contig
+++ a/mm/page_alloc.c
@@ -7153,18 +7153,20 @@ static bool pfn_range_valid_contig(struc
 				   unsigned long nr_pages, bool skip_hugetlb,
 				   bool *skipped_hugetlb)
 {
-	unsigned long i, end_pfn = start_pfn + nr_pages;
+	unsigned long end_pfn = start_pfn + nr_pages;
 	struct page *page;
 
-	for (i = start_pfn; i < end_pfn; i++) {
-		page = pfn_to_online_page(i);
+	while (start_pfn < end_pfn) {
+		unsigned long step = 1;
+
+		page = pfn_to_online_page(start_pfn);
 		if (!page)
 			return false;
 
 		if (page_zone(page) != z)
 			return false;
 
-		if (PageReserved(page))
+		if (page_is_unmovable(z, page, PB_ISOLATE_MODE_OTHER, &step))
 			return false;
 
 		/*
@@ -7179,9 +7181,6 @@ static bool pfn_range_valid_contig(struc
 		if (PageHuge(page)) {
 			unsigned int order;
 
-			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
-				return false;
-
 			if (skip_hugetlb) {
 				*skipped_hugetlb = true;
 				return false;
@@ -7192,17 +7191,9 @@ static bool pfn_range_valid_contig(struc
 			if ((order >= MAX_FOLIO_ORDER) ||
 			    (nr_pages <= (1 << order)))
 				return false;
-
-			/*
-			 * Reaching this point means we've encounted a huge page
-			 * smaller than nr_pages, skip all pfn's for that page.
-			 *
-			 * We can't get here from a tail-PageHuge, as it implies
-			 * we started a scan in the middle of a hugepage larger
-			 * than nr_pages - which the prior check filters for.
-			 */
-			i += (1 << order) - 1;
 		}
+
+		start_pfn += step;
 	}
 	return true;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


