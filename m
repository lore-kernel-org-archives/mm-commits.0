From: akpm@linux-foundation.org
Subject: [folded] mm-add-free_hot_cold_page_list-helper-v3.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:43:00 -0800
Message-ID: <20120110224300.831001E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:37228 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab2AJWnC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:43:02 -0500
Received: by ghrr15 with SMTP id r15so12493ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:43:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-free_hot_cold_page_list-helper-v3
has been removed from the -mm tree.  Its filename was
     mm-add-free_hot_cold_page_list-helper-v3.patch

This patch was dropped because it was folded into mm-add-free_hot_cold_page_list-helper.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm-add-free_hot_cold_page_list-helper-v3

v3: Always free pages in reverse order.
    The most recently added struct page, the most likely to be hot.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap.c~mm-add-free_hot_cold_page_list-helper-v3 mm/swap.c
--- a/mm/swap.c~mm-add-free_hot_cold_page_list-helper-v3
+++ a/mm/swap.c
@@ -619,7 +619,7 @@ void release_pages(struct page **pages, 
 			del_page_from_lru(zone, page);
 		}
 
-		list_add_tail(&page->lru, &pages_to_free);
+		list_add(&page->lru, &pages_to_free);
 	}
 	if (zone)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mm-account-reaped-page-cache-on-inode-cache-pruning.patch

