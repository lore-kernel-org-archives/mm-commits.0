From: akpm@linux-foundation.org
Subject: [merged] mm-fix-tracing-in-free_pcppages_bulk.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:19 -0700
Message-ID: <20121009181120.3C8135C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40119 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab2JISLW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:22 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so363267eek.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: b.zolnierkie@samsung.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix tracing in free_pcppages_bulk()
has been removed from the -mm tree.  Its filename was
     mm-fix-tracing-in-free_pcppages_bulk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: mm: fix tracing in free_pcppages_bulk()

page->private gets re-used in __free_one_page() to store page order
(so trace_mm_page_pcpu_drain() may print order instead of migratetype)
thus migratetype value must be cached locally.

Fixes regression introduced in a701623 ("mm: fix migratetype bug which
slowed swapping").  This caused incorrect data to be attached to the
mm_page_pcpu_drain trace event.

[akpm@linux-foundation.org: add comment]
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-tracing-in-free_pcppages_bulk mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-tracing-in-free_pcppages_bulk
+++ a/mm/page_alloc.c
@@ -668,12 +668,15 @@ static void free_pcppages_bulk(struct zo
 			batch_free = to_free;
 
 		do {
+			int mt;	/* migratetype of the to-be-freed page */
+
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
+			mt = page_private(page);
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
-			__free_one_page(page, zone, 0, page_private(page));
-			trace_mm_page_pcpu_drain(page, 0, page_private(page));
+			__free_one_page(page, zone, 0, mt);
+			trace_mm_page_pcpu_drain(page, 0, mt);
 		} while (--to_free && --batch_free && !list_empty(list));
 	}
 	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
_

Patches currently in -mm which might be from b.zolnierkie@samsung.com are

origin.patch

