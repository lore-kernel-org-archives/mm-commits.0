From: akpm@linux-foundation.org
Subject: [merged] mm-improve-documentation-of-page_order-v2.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:59:43 -0800
Message-ID: <52e2b81f.ASJzcdQshsPt/Z6x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, lauraa@codeaurora.org, aquini@redhat.com, mgorman@suse.de

Subject: [merged] mm-improve-documentation-of-page_order-v2.patch removed from -mm tree
To: mgorman@suse.de,aquini@redhat.com,lauraa@codeaurora.org,minchan@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:43 -0800


The patch titled
     Subject: mm: improve documentation of page_order
has been removed from the -mm tree.  Its filename was
     mm-improve-documentation-of-page_order-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: improve documentation of page_order

Developers occasionally try and optimise PFN scanners by using page_order
but miss that in general it requires zone->lock.  This has happened twice
for compaction.c and rejected both times.  This patch clarifies the
documentation of page_order and adds a note to compaction.c why page_order
is not used.

[akpm@linux-foundation.org: tweaks]
[lauraa@codeaurora.org: Corrected a page_zone(page)->lock reference]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++++-
 mm/internal.h   |    8 +++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-improve-documentation-of-page_order-v2 mm/compaction.c
--- a/mm/compaction.c~mm-improve-documentation-of-page_order-v2
+++ a/mm/compaction.c
@@ -523,7 +523,10 @@ isolate_migratepages_range(struct zone *
 		if (!isolation_suitable(cc, page))
 			goto next_pageblock;
 
-		/* Skip if free */
+		/*
+		 * Skip if free. page_order cannot be used without zone->lock
+		 * as nothing prevents parallel allocations or buddy merging.
+		 */
 		if (PageBuddy(page))
 			continue;
 
diff -puN mm/internal.h~mm-improve-documentation-of-page_order-v2 mm/internal.h
--- a/mm/internal.h~mm-improve-documentation-of-page_order-v2
+++ a/mm/internal.h
@@ -143,9 +143,11 @@ isolate_migratepages_range(struct zone *
 #endif
 
 /*
- * function for dealing with page's order in buddy system.
- * zone->lock is already acquired when we use these.
- * So, we don't need atomic page->flags operations here.
+ * This function returns the order of a free page in the buddy system. In
+ * general, page_zone(page)->lock must be held by the caller to prevent the
+ * page from being allocated in parallel and returning garbage as the order.
+ * If a caller does not hold page_zone(page)->lock, it must guarantee that the
+ * page cannot be allocated or merged in parallel.
  */
 static inline unsigned long page_order(struct page *page)
 {
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
linux-next.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

