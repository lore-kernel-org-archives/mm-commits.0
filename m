From: akpm@linux-foundation.org
Subject: [merged] mm-do-not-use-page_count-without-a-page-pin.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:44 -0700
Message-ID: <20120801201345.3392D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:37078 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:48 -0400
Received: by wibhr14 with SMTP id hr14so198971wib.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, b.zolnierkie@samsung.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not use page_count() without a page pin
has been removed from the -mm tree.  Its filename was
     mm-do-not-use-page_count-without-a-page-pin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: do not use page_count() without a page pin

d179e84ba ("mm: vmscan: do not use page_count without a page pin") fixed
this problem in vmscan.c but same problem is in __count_immobile_pages().

I copy and paste d179e84ba's contents for description.

"It is unsafe to run page_count during the physical pfn scan because
compound_head could trip on a dangling pointer when reading
page->first_page if the compound page is being freed by another CPU."

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-do-not-use-page_count-without-a-page-pin mm/page_alloc.c
--- a/mm/page_alloc.c~mm-do-not-use-page_count-without-a-page-pin
+++ a/mm/page_alloc.c
@@ -5500,11 +5500,18 @@ __count_immobile_pages(struct zone *zone
 			continue;
 
 		page = pfn_to_page(check);
-		if (!page_count(page)) {
+		/*
+		 * We can't use page_count without pin a page
+		 * because another CPU can free compound page.
+		 * This check already skips compound tails of THP
+		 * because their page->_count is zero at all time.
+		 */
+		if (!atomic_read(&page->_count)) {
 			if (PageBuddy(page))
 				iter += (1 << page_order(page)) - 1;
 			continue;
 		}
+
 		if (!PageLRU(page))
 			found++;
 		/*
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-__gfp_no_kswapd.patch
remove-__gfp_no_kswapd-fixes-fix.patch

