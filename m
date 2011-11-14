From: akpm@linux-foundation.org
Subject: + mm-add-free_hot_cold_page_list-helper-v3.patch added to -mm tree
Date: Mon, 14 Nov 2011 15:30:52 -0800
Message-ID: <201111142330.pAENUrYu011688@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:62172 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1KNXa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 18:30:57 -0500
Received: by wwe5 with SMTP id 5so123336wwe.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 15:30:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     Subject: mm-add-free_hot_cold_page_list-helper-v3
has been added to the -mm tree.  Its filename is
     mm-add-free_hot_cold_page_list-helper-v3.patch

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
Subject: Subject: mm-add-free_hot_cold_page_list-helper-v3

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
vmscan-fix-initial-shrinker-size-handling.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch

