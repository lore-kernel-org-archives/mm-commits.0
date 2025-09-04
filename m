Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8109F2D9EE1
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757030147; cv=none; b=HgC2RFQllcspWXdF0sCON1moGJm5hKcosinUgJ2wjviVlr32oIyDNaO3xoc5rApLg5ikjCrKusjQJWwCPQX1TlQly8J4Tf7GC7OLwg7nZu/vofifttoN1pmgeTQQs4gLNYqHgFjR/AXIF+FbiE8q/L5SMXzX2pEArqddhaqyriE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757030147; c=relaxed/simple;
	bh=uOWxI+sghhL8u3/puuEvrz3TBVTcpcHfLqajfvW+XkU=;
	h=Date:To:From:Subject:Message-Id; b=GKZYmlsQmuWBI7CbzJ6wZQgR7EGTbOVyD9hZ2TvYeP1ol87WC4Klv7uQPdtG9WMge+S9GvtCqIwJQuHKckX8NUX3sNvIXzswKlqMXHSAGzhdICEoOVTnVWRf+CqQKBb4F0x/FX1o5itujKJ0mcsF9L5pL9/by9cjkMCYEcrSKfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OwMC2Fwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OwMC2Fwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74EDC4CEF4;
	Thu,  4 Sep 2025 23:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757030147;
	bh=uOWxI+sghhL8u3/puuEvrz3TBVTcpcHfLqajfvW+XkU=;
	h=Date:To:From:Subject:From;
	b=OwMC2FwxHJ+Yc/ECguh8d3w/DDQasuZ2QWN9t24fdY2VRd+5ZZFriCtJWT2mdCIao
	 l7bqCjDtJR6dKlISeD3F5gBvp5r313+WllmwmoWDPSwrlFqe6MTN/+w58nLJU9XSzF
	 rwlvvq5mWnn0NKVTrIAO4DgYxGCZUH01MoMA4OiY=
Date: Thu, 04 Sep 2025 16:55:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block.patch added to mm-new branch
Message-Id: <20250904235546.D74EDC4CEF4@smtp.kernel.org>
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
Date: Thu, 4 Sep 2025 02:06:54 +0000

find_large_buddy() search buddy based on start_pfn, which may be different
from page's pfn, e.g.  when page is not pageblock aligned, because
prep_move_freepages_block() always aligns start_pfn to pageblock.

This means when we found a starting block at start_pfn, it may check on
the wrong page theoretically.

The good news is the page passed to __move_freepages_block_isolate() has
only two possible cases:

  * page is pageblock aligned
  * page is __first_valid_page() of this block

So it is safe for the first case, and it won't get a buddy larger than
pageblock for the second case.

To eliminate the ambiguity, unify the handling for starting/tail block.

Link: https://lkml.kernel.org/r/20250904020654.28689-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block
+++ a/mm/page_alloc.c
@@ -2093,6 +2093,7 @@ static bool __move_freepages_block_isola
 	unsigned long start_pfn, pfn;
 	int from_mt;
 	int to_mt;
+	struct page *buddy;
 
 	if (isolate == get_pageblock_isolate(page)) {
 		VM_WARN_ONCE(1, "%s a pageblock that is already in that state",
@@ -2107,10 +2108,10 @@ static bool __move_freepages_block_isola
 	if (pageblock_order == MAX_PAGE_ORDER)
 		goto move;
 
-	/* We're a tail block in a larger buddy */
 	pfn = find_large_buddy(start_pfn);
-	if (pfn != start_pfn) {
-		struct page *buddy = pfn_to_page(pfn);
+	buddy = pfn_to_page(pfn);
+	/* We're a part of a larger buddy */
+	if (PageBuddy(buddy) && buddy_order(buddy) > pageblock_order) {
 		int order = buddy_order(buddy);
 
 		del_page_from_free_list(buddy, zone, order,
@@ -2120,16 +2121,6 @@ static bool __move_freepages_block_isola
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

