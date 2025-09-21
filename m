Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590081F4CBB
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489925; cv=none; b=cKQyTiSVWYqTwtDAF2L3Lbv5/8tat+a66e+7ON0IZ/eOR0yPP7TPXkn8g6lYc0MeXW3pdSiYP0j4zNzh7kRqyHaME8sMJO60ji1qQul4DoTakKOORYZahrMXdmRnOTuGcQO5Jgt1DL6MPfqfzXDyVqNG3CuixDmyTreCF57nnXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489925; c=relaxed/simple;
	bh=HwW5woAc/aZcOvMBoIZNRLDtSFO4T7kXmY/CHE1xYiA=;
	h=Date:To:From:Subject:Message-Id; b=A/9gwxWeZO+OpV/Jt0OPaEMKARXYME3SxgLf8Nj7s/AMDydHitHunwUFl6FXz2BeK97CKSoHpwTTip71LA5SMKhV5eu/1f4UCsl7GqV3xU0i3U+gTZGbp2r3gD28GS4ok1S4zBMuCIi4orrcz6uvNDFCjoCxoJ2PxcmFmE5AZlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e1n+GejZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e1n+GejZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC28C4CEE7;
	Sun, 21 Sep 2025 21:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489925;
	bh=HwW5woAc/aZcOvMBoIZNRLDtSFO4T7kXmY/CHE1xYiA=;
	h=Date:To:From:Subject:From;
	b=e1n+GejZ3i+cJKN2LgM5H8UbTTObBoRFbYWarKeYjp0BR6RdFGOVvqEVTI2lYwfCG
	 BTsR8Lo/tjyD2fsvoHF82ZSPaYcuQY98bOANmkGL1Te2mkXApMEfmMVfEoaiblid8i
	 x/vn9ENWSh7E1ptmeb4Abuus5QEiIuVnedWBKPXo=
Date: Sun, 21 Sep 2025 14:25:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block.patch removed from -mm tree
Message-Id: <20250921212525.2BC28C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: check the correct buddy if it is a starting block
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: check the correct buddy if it is a starting block
Date: Fri, 5 Sep 2025 14:03:58 +0000

find_large_buddy() search buddy based on start_pfn, which maybe different
from page's pfn, e.g.  when page is not pageblock aligned, because
prep_move_freepages_block() always align start_pfn to pageblock.

This means when we found a starting block at start_pfn, it may check on
the wrong page theoretically.  And not split the free page as it is
supposed to, causing a freelist migratetype mismatch.

The good news is the page passed to __move_freepages_block_isolate() has
only two possible cases:

  * page is pageblock aligned
  * page is __first_valid_page() of this block

So it is safe for the first case, and it won't get a buddy larger than
pageblock for the second case.

To fix the issue, check the returned pfn of find_large_buddy() to decide
whether to split the free page:

  1. if it is not a PageBuddy pfn, no split;
  2. if it is a PageBuddy pfn but order <= pageblock_order, no split;
  3. if it is a PageBuddy pfn with order > pageblock_order, start_pfn is
     either in the starting block or tail block, split the PageBuddy at
     pageblock_order level.

Link: https://lkml.kernel.org/r/20250905140358.28849-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block
+++ a/mm/page_alloc.c
@@ -2090,9 +2090,10 @@ static inline void toggle_pageblock_isol
 static bool __move_freepages_block_isolate(struct zone *zone,
 		struct page *page, bool isolate)
 {
-	unsigned long start_pfn, pfn;
+	unsigned long start_pfn, buddy_pfn;
 	int from_mt;
 	int to_mt;
+	struct page *buddy;
 
 	if (isolate == get_pageblock_isolate(page)) {
 		VM_WARN_ONCE(1, "%s a pageblock that is already in that state",
@@ -2107,29 +2108,19 @@ static bool __move_freepages_block_isola
 	if (pageblock_order == MAX_PAGE_ORDER)
 		goto move;
 
-	/* We're a tail block in a larger buddy */
-	pfn = find_large_buddy(start_pfn);
-	if (pfn != start_pfn) {
-		struct page *buddy = pfn_to_page(pfn);
+	buddy_pfn = find_large_buddy(start_pfn);
+	buddy = pfn_to_page(buddy_pfn);
+	/* We're a part of a larger buddy */
+	if (PageBuddy(buddy) && buddy_order(buddy) > pageblock_order) {
 		int order = buddy_order(buddy);
 
 		del_page_from_free_list(buddy, zone, order,
-					get_pfnblock_migratetype(buddy, pfn));
+					get_pfnblock_migratetype(buddy, buddy_pfn));
 		toggle_pageblock_isolate(page, isolate);
-		split_large_buddy(zone, buddy, pfn, order, FPI_NONE);
+		split_large_buddy(zone, buddy, buddy_pfn, order, FPI_NONE);
 		return true;
 	}
 
-	/* We're the starting block of a larger buddy */
-	if (PageBuddy(page) && buddy_order(page) > pageblock_order) {
-		int order = buddy_order(page);
-
-		del_page_from_free_list(page, zone, order,
-					get_pfnblock_migratetype(page, pfn));
-		toggle_pageblock_isolate(page, isolate);
-		split_large_buddy(zone, page, pfn, order, FPI_NONE);
-		return true;
-	}
 move:
 	/* Use MIGRATETYPE_MASK to get non-isolate migratetype */
 	if (isolate) {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch
mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null.patch
mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch

