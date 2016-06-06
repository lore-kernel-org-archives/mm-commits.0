From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-prevent-infinite-loop-in-buffered_rmqueue.patch removed from
 -mm tree
Date: Mon, 06 Jun 2016 12:06:52 -0700
Message-ID: <5755c9cc.ZUx3BcMvzCzNsP9z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbcFFTGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2016 15:06:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mgorman@techsingularity.net, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: prevent infinite loop in buffered_rmqueue()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-prevent-infinite-loop-in-buffered_rmqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: prevent infinite loop in buffered_rmqueue()

In DEBUG_VM kernel, we can hit infinite loop for order == 0 in
buffered_rmqueue() when check_new_pcp() returns 1, because the bad page is
never removed from the pcp list.  Fix this by removing the page before
retrying.  Also we don't need to check if page is non-NULL, because we
simply grab it from the list which was just tested for being non-empty.

Fixes: 479f854a207c ("mm, page_alloc: defer debugging checks of pages allocated from the PCP")
Link: http://lkml.kernel.org/r/20160530090154.GM2527@techsingularity.net
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-prevent-infinite-loop-in-buffered_rmqueue mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-prevent-infinite-loop-in-buffered_rmqueue
+++ a/mm/page_alloc.c
@@ -2615,11 +2615,12 @@ struct page *buffered_rmqueue(struct zon
 				page = list_last_entry(list, struct page, lru);
 			else
 				page = list_first_entry(list, struct page, lru);
-		} while (page && check_new_pcp(page));
 
-		__dec_zone_state(zone, NR_ALLOC_BATCH);
-		list_del(&page->lru);
-		pcp->count--;
+			__dec_zone_state(zone, NR_ALLOC_BATCH);
+			list_del(&page->lru);
+			pcp->count--;
+
+		} while (check_new_pcp(page));
 	} else {
 		/*
 		 * We most definitely don't want callers attempting to
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-frontswap-convert-frontswap_enabled-to-static-key.patch

