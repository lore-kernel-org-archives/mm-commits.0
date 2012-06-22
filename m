From: akpm@linux-foundation.org
Subject: + mm-do-not-use-page_count-without-a-page-pin.patch added to -mm tree
Date: Fri, 22 Jun 2012 16:27:53 -0700
Message-ID: <20120622232754.6F4C3A016C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:61464 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab2FVX14 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 19:27:56 -0400
Received: by eeit10 with SMTP id t10so132235eei.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 16:27:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, aarcange@redhat.com, b.zolnierkie@samsung.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mgorman@suse.de, mhocko@suse.cz


The patch titled
     Subject: mm: do not use page_count() without a page pin
has been added to the -mm tree.  Its filename is
     mm-do-not-use-page_count-without-a-page-pin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5499,11 +5499,18 @@ __count_immobile_pages(struct zone *zone
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
Subject: Subject: mm: do not use page_count() without a page pin

Patches currently in -mm which might be from minchan@kernel.org are

linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-compaction-cleanup-on-compaction_deferred.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-fix-page-reclaim-comment-error.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch

