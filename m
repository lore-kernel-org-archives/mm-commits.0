From: akpm@linux-foundation.org
Subject: [merged] mm-fix-calculation-of-dirtyable-memory.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:39:10 -0800
Message-ID: <20121221203910.C367182004A__13752.0581869923$1356122374$gmane$org@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:58666 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2LUUjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:39:12 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so517359yen.0
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:39:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sonnyrao@chromium.org, damien.wyart@free.fr, hannes@cmpxchg.org, puneetster@chromium.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix calculation of dirtyable memory
has been removed from the -mm tree.  Its filename was
     mm-fix-calculation-of-dirtyable-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sonny Rao <sonnyrao@chromium.org>
Subject: mm: fix calculation of dirtyable memory

The system uses global_dirtyable_memory() to calculate number of dirtyable
pages/pages that can be allocated to the page cache.  A bug causes an
underflow thus making the page count look like a big unsigned number. 
This in turn confuses the dirty writeback throttling to aggressively write
back pages as they become dirty (usually 1 page at a time).  This
generally only affects systems with highmem because the underflowed count
gets subtracted from the global count of dirtyable memory.

The problem was introduced with v3.2-4896-gab8fabd

Fix is to ensure we don't get an underflowed total of either highmem
or global dirtyable memory.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Puneet Kumar <puneetster@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Damien Wyart <damien.wyart@free.fr>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff -puN mm/page-writeback.c~mm-fix-calculation-of-dirtyable-memory mm/page-writeback.c
--- a/mm/page-writeback.c~mm-fix-calculation-of-dirtyable-memory
+++ a/mm/page-writeback.c
@@ -201,6 +201,18 @@ static unsigned long highmem_dirtyable_m
 		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
 	}
 	/*
+	 * Unreclaimable memory (kernel memory or anonymous memory
+	 * without swap) can bring down the dirtyable pages below
+	 * the zone's dirty balance reserve and the above calculation
+	 * will underflow.  However we still want to add in nodes
+	 * which are below threshold (negative values) to get a more
+	 * accurate calculation but make sure that the total never
+	 * underflows.
+	 */
+	if ((long)x < 0)
+		x = 0;
+
+	/*
 	 * Make sure that the number of highmem pages is never larger
 	 * than the number of the total dirtyable memory. This can only
 	 * occur in very strange VM situations but we want to make sure
@@ -222,8 +234,8 @@ static unsigned long global_dirtyable_me
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages() -
-	    dirty_balance_reserve;
+	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	x -= min(x, dirty_balance_reserve);
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
@@ -290,9 +302,12 @@ static unsigned long zone_dirtyable_memo
 	 * highmem zone can hold its share of dirty pages, so we don't
 	 * care about vm_highmem_is_dirtyable here.
 	 */
-	return zone_page_state(zone, NR_FREE_PAGES) +
-	       zone_reclaimable_pages(zone) -
-	       zone->dirty_balance_reserve;
+	unsigned long nr_pages = zone_page_state(zone, NR_FREE_PAGES) +
+		zone_reclaimable_pages(zone);
+
+	/* don't allow this to underflow */
+	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
+	return nr_pages;
 }
 
 /**
_

Patches currently in -mm which might be from sonnyrao@chromium.org are

origin.patch

