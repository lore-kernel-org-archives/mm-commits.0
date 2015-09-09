From: akpm@linux-foundation.org
Subject: [merged]
 vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:46:54 -0700
Message-ID: <55f08cae.F8cYOaFTqz7CxibZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbbIITqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaewon31.kim@samsung.com, mgorman@techsingularity.net, minchan@kernel.org, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: fix increasing nr_isolated incurred by putback unevictable pages
has been removed from the -mm tree.  Its filename was
     vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: vmscan: fix increasing nr_isolated incurred by putback unevictable pages

reclaim_clean_pages_from_list() assumes that shrink_page_list() returns
number of pages removed from the candidate list.  But shrink_page_list()
puts back mlocked pages without passing it to caller and without counting
as nr_reclaimed.  This increases nr_isolated.

To fix this, this patch changes shrink_page_list() to pass unevictable
pages back to caller.  Caller will take care those pages.

Minchan said:

It fixes two issues.

1. With unevictable page, cma_alloc will be successful.

Exactly speaking, cma_alloc of current kernel will fail due to
unevictable pages.

2. fix leaking of NR_ISOLATED counter of vmstat

With it, too_many_isolated works.  Otherwise, it could make hang until
the process get SIGKILL.

Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-increasing-nr_isolated-incurred-by-putback-unevictable-pages
+++ a/mm/vmscan.c
@@ -1196,7 +1196,7 @@ cull_mlocked:
 		if (PageSwapCache(page))
 			try_to_free_swap(page);
 		unlock_page(page);
-		putback_lru_page(page);
+		list_add(&page->lru, &ret_pages);
 		continue;
 
 activate_locked:
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are


