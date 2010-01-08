From: akpm@linux-foundation.org
Subject: + page-allocator-fix-zone-statistic-accumulation-on-error-path.patch added to -mm tree
Date: Fri, 08 Jan 2010 14:59:52 -0800
Message-ID: <201001082259.o08Mxq2p019262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336Ab0AHW76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 17:59:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     page allocator: fix zone statistic accumulation on error path
has been added to the -mm tree.  Its filename is
     page-allocator-fix-zone-statistic-accumulation-on-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: fix zone statistic accumulation on error path
From: Huang Shijie <shijie8@gmail.com>

When the `page' returned by __rmqueue() is NULL, the origin code still
adds -(1 << order) to zone's NR_FREE_PAGES item.

The patch fixes it.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-fix-zone-statistic-accumulation-on-error-path mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-fix-zone-statistic-accumulation-on-error-path
+++ a/mm/page_alloc.c
@@ -1219,10 +1219,14 @@ again:
 		}
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
-		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
-		spin_unlock(&zone->lock);
-		if (!page)
+		if (likely(page)) {
+			__mod_zone_page_state(zone, NR_FREE_PAGES,
+						-(1 << order));
+			spin_unlock(&zone->lock);
+		} else {
+			spin_unlock(&zone->lock);
 			goto failed;
+		}
 	}
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
_

Patches currently in -mm which might be from shijie8@gmail.com are

page-allocator-fix-zone-statistic-accumulation-on-error-path.patch

