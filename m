From: akpm@linux-foundation.org
Subject: + fix-page_alloc-for-larger-i-o-segments.patch added to -mm tree
Date: Thu, 13 Dec 2007 17:04:38 -0800
Message-ID: <200712140104.lBE14ca9028407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759269AbXLNBFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 20:05:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liml@rtr.ca, James.Bottomley@steeleye.com, jens.axboe@oracle.com, mel@csn.ul.ie, mlord@pobox.com


The patch titled
     fix page_alloc for larger I/O segments
has been added to the -mm tree.  Its filename is
     fix-page_alloc-for-larger-i-o-segments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
