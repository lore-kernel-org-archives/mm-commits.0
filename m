From: akpm@linux-foundation.org
Subject: + mm-fix-tracing-in-free_pcppages_bulk.patch added to -mm tree
Date: Wed, 19 Sep 2012 12:51:34 -0700
Message-ID: <20120919195135.BA09120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:52638 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2ISTvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Sep 2012 15:51:39 -0400
Received: by wibhr14 with SMTP id hr14so87166wib.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Sep 2012 12:51:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: b.zolnierkie@samsung.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org


The patch titled
     Subject: mm: fix tracing in free_pcppages_bulk()
has been added to the -mm tree.  Its filename is
     mm-fix-tracing-in-free_pcppages_bulk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: mm: fix tracing in free_pcppages_bulk()

page->private gets re-used in __free_one_page() to store page order
(so trace_mm_page_pcpu_drain() may print order instead of migratetype)
thus migratetype value must be cached locally.

Fixes regression introduced in a701623 ("mm: fix migratetype bug which
slowed swapping").  This caused incorrect data to be attached to the
mm_page_pcpu_drain trace event.

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
@@ -667,12 +667,15 @@ static void free_pcppages_bulk(struct zo
 			batch_free = to_free;
 
 		do {
+			int mt;
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

mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch

