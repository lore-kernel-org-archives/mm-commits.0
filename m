From: akpm@linux-foundation.org
Subject: +
 vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages.patch added to -mm tree
Date: Tue, 04 Aug 2015 15:09:59 -0700
Message-ID: <55c13837.BspioSmUPS+DATaY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbbHDWKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 18:10:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaewon31.kim@samsung.com, mgorman@techsingularity.net, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: fix increasing nr_isolated incurred by putback unevictable pages
has been added to the -mm tree.  Its filename is
     vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: vmscan: fix increasing nr_isolated incurred by putback unevictable pages

reclaim_clean_pages_from_list() assumes that shrink_page_list() returns
number of pages removed from the candidate list.  But shrink_page_list()
puts back mlocked pages without passing it to caller and without counting
as nr_reclaimed.  This increases nr_isolated.

To fix this, this patch changes shrink_page_list() to pass unevictable
pages back to caller.  Caller will take care those pages.

Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages
+++ a/mm/vmscan.c
@@ -1193,7 +1193,7 @@ cull_mlocked:
 		if (PageSwapCache(page))
 			try_to_free_swap(page);
 		unlock_page(page);
-		putback_lru_page(page);
+		list_add(&page->lru, &ret_pages);
 		continue;
 
 activate_locked:
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages.patch

