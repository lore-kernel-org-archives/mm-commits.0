Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C87315D3C
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 01:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757120862; cv=none; b=lVgePh0jBaUm7IucTQ7FeDkcQLCBmXkknhUz9Z0cQEy3egk8bu95bVC9xblyp668/QoIp/9P3r2b5zj9eA0VrZwJhSMIT3ktamRhbtzrguVxbvy9eKsBej2LKuFpzMhWA3oZqDr4epRrXF4JpoezcQxNDhh49Ogq6+x+qDlqedw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757120862; c=relaxed/simple;
	bh=xHAyd78zUjI5XNnYmLbkwfRB5+5O+hk14xbyVv0DhGc=;
	h=Date:To:From:Subject:Message-Id; b=TQb0vYkDD6uwIw6cPsNsOcmMsKzRJQRDs4NGuultva1aFiBbKrBEJWEvFJ0En051WUeHb1pp+LgnQ/vj6WT2U9XuUe0CjaacgAlK3tJgeO0JVO/3v6JxxPSc8qqqmcM8Xz7Z/j3B9S5YAroZJ3D5AyPLgXLeuJtGEFFVjSQGpr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FvBLo2gb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FvBLo2gb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7513EC4CEF1;
	Sat,  6 Sep 2025 01:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757120861;
	bh=xHAyd78zUjI5XNnYmLbkwfRB5+5O+hk14xbyVv0DhGc=;
	h=Date:To:From:Subject:From;
	b=FvBLo2gbc3GVfbh6DPagZMkwO/8PvLDwQZAH4x8uikg3oSYIw4Bdg1UVTf15VV014
	 vNPZe2zsz/grIgO/PPlXDn+er36D3STzFg+Ikh0Mb+1Kr2XYGR0e5NmXqd4shSUaWo
	 WNOcZ5J5AwdGSh6+MKh1GiXf/K34zQeaQeXUamvE=
Date: Fri, 05 Sep 2025 18:07:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block.patch added to mm-new branch
Message-Id: <20250906010741.7513EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: check the correct buddy if it is a starting block
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch
selftests-mm-put-general-ksm-operation-into-vm_util.patch
selftests-mm-test-that-rmap-behave-as-expected.patch
mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch
mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch
mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2.patch
mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block.patch

