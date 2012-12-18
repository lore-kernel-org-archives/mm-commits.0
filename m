From: akpm@linux-foundation.org
Subject: + mm-fix-calculation-of-dirtyable-memory.patch added to -mm tree
Date: Tue, 18 Dec 2012 13:48:21 -0800
Message-ID: <20121218214821.ACA5E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:53438 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab2LRVsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 16:48:22 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so139274yhl.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 13:48:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonnyrao@chromium.org, damien.wyart@free.fr, hannes@cmpxchg.org, puneetster@chromium.org, stable@vger.kernel.org


The patch titled
     Subject: mm: fix calculation of dirtyable memory
has been added to the -mm tree.  Its filename is
     mm-fix-calculation-of-dirtyable-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-calculation-of-dirtyable-memory.patch

