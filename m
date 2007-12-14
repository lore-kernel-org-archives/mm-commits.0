From: akpm@linux-foundation.org
Subject: - fix-page_alloc-for-larger-i-o-segments.patch removed from -mm tree
Date: Fri, 14 Dec 2007 14:37:05 -0800
Message-ID: <200712142237.lBEMb5gH018683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934174AbXLNWiS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Dec 2007 17:38:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liml@rtr.ca, James.Bottomley@steeleye.com, jens.axboe@oracle.com, mel@csn.ul.ie, mlord@pobox.com, mm-commits@vger.kernel.org


The patch titled
     fix page_alloc for larger I/O segments
has been removed from the -mm tree.  Its filename was
     fix-page_alloc-for-larger-i-o-segments.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fix page_alloc for larger I/O segments
From: Mark Lord <liml@rtr.ca>

Fix page allocator to give better chance of larger contiguous segments (we
regressed after 2.6.23).

Signed-off-by: Mark Lord <mlord@pobox.com
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~fix-page_alloc-for-larger-i-o-segments mm/page_alloc.c
--- a/mm/page_alloc.c~fix-page_alloc-for-larger-i-o-segments
+++ a/mm/page_alloc.c
@@ -847,7 +847,7 @@ static int rmqueue_bulk(struct zone *zon
 		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
-		list_add(&page->lru, list);
+		list_add_tail(&page->lru, list);
 		set_page_private(page, migratetype);
 	}
 	spin_unlock(&zone->lock);
_

Patches currently in -mm which might be from liml@rtr.ca are

fix-page_alloc-for-larger-i-o-segments.patch
fix-page_alloc-for-larger-i-o-segments-fix.patch
