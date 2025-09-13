Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9063124A044
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757802282; cv=none; b=p0OoogQqwJX1f8jyoHBEfQ655JsPb/34cGY3t4mcvs/MDFizvLAMqgxdhOxg7LgWuw777x4Xj0zuhC0zypjZtXoa5oG8tMzJrCDmw/WTRcZ0gQ/6UnhIFj39SBVdsctn9dXvJg9/Ye+lwRoiBfGGFeQ1K9QlAQds8mgxGAmTm/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757802282; c=relaxed/simple;
	bh=6xMO2lvcrWF3b1rhgxqLLc0Ds36MVWI22564hSja0mQ=;
	h=Date:To:From:Subject:Message-Id; b=g1foCN6ca2N1Tf2w+c+lT/XjnqaE5NduST+mpun5CP7GpNTQJH8A86nAVrhVYRtbIbeqp3bP5Aix9/Js6eCMeLvV2H5ykNcKvZE5q5isZCXUONeEJfYQcnGlxcZyLLtB4We9EX37E+MUCRkaf5klaWQLwD5genhUDL85ffrWt4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QauPgEQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QauPgEQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5DDC4CEEB;
	Sat, 13 Sep 2025 22:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757802282;
	bh=6xMO2lvcrWF3b1rhgxqLLc0Ds36MVWI22564hSja0mQ=;
	h=Date:To:From:Subject:From;
	b=QauPgEQnt93BHspnGLZscTxEoMylvb9SiIc/lYmM/F8oPDqyFeWHpMgd44C2fCfrH
	 pETCsK3eCwmgNwlJUjryuqhk/5ZxeUNfgQ+s+w7sCGPN7CoI9X7kAb0ox1H71uX3I/
	 gCeD/rITmvCd4MZMFlMEz1h6XONAqJViO04HSgT4=
Date: Sat, 13 Sep 2025 15:24:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,hannes@cmpxchg.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2.patch removed from -mm tree
Message-Id: <20250913222442.1A5DDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2.patch

This patch was dropped because it was folded into mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order.patch

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2
Date: Tue, 2 Sep 2025 02:58:07 +0000

add comment on assignment of order

Link: https://lkml.kernel.org/r/20250828091618.7869-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20250902025807.11467-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2
+++ a/mm/page_alloc.c
@@ -2033,6 +2033,12 @@ static int move_freepages_block(struct z
 /* Look for a buddy that straddles start_pfn */
 static unsigned long find_large_buddy(unsigned long start_pfn)
 {
+	/*
+	 * If start_pfn is not an order-0 PageBuddy, next PageBuddy containing
+	 * start_pfn has minimal order of __ffs(start_pfn) + 1. Start checking
+	 * the order with __ffs(start_pfn). If start_pfn is order-0 PageBuddy,
+	 * the starting order does not matter.
+	 */
 	int order = start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
 	struct page *page;
 	unsigned long pfn = start_pfn;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
selftests-mm-put-general-ksm-operation-into-vm_util.patch
selftests-mm-test-that-rmap-behave-as-expected.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch
mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch
mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch
mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order.patch
mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block.patch
mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch

