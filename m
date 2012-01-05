From: akpm@linux-foundation.org
Subject: [nacked] mm-vmscanc-check-page-order-when-isolating-lru-pages.patch removed from -mm tree
Date: Thu, 05 Jan 2012 14:50:42 -0800
Message-ID: <20120105225044.93BC21E0133@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:41678 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab2AEWuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2012 17:50:46 -0500
Received: by ghrr15 with SMTP id r15so116792ghr.1
        for <mm-commits@vger.kernel.org>; Thu, 05 Jan 2012 14:50:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, aarcange@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: check page order when isolating lru pages
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-check-page-order-when-isolating-lru-pages.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/vmscan.c: check page order when isolating lru pages

Before trying to isolate physically contiguous pages, a check for the page
order is added.  If it is not a regular page, we should give up the
attempt.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscanc-check-page-order-when-isolating-lru-pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-check-page-order-when-isolating-lru-pages
+++ a/mm/vmscan.c
@@ -1173,6 +1173,7 @@ static unsigned long isolate_lru_pages(u
 		unsigned long end_pfn;
 		unsigned long page_pfn;
 		int zone_id;
+		unsigned int isolated_pages = 1;
 
 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
@@ -1183,7 +1184,7 @@ static unsigned long isolate_lru_pages(u
 		case 0:
 			mem_cgroup_lru_del(page);
 			list_move(&page->lru, dst);
-			nr_taken += hpage_nr_pages(page);
+			isolated_pages = hpage_nr_pages(page);
 			break;
 
 		case -EBUSY:
@@ -1195,8 +1196,12 @@ static unsigned long isolate_lru_pages(u
 			BUG();
 		}
 
+		nr_taken += isolated_pages;
 		if (!order)
 			continue;
+		/* try pfn-based isolation only for regular page */
+		if (isolated_pages != 1)
+			continue;
 
 		/*
 		 * Attempt to take all pages in the order aligned region
@@ -1238,7 +1243,6 @@ static unsigned long isolate_lru_pages(u
 				break;
 
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
-				unsigned int isolated_pages;
 
 				mem_cgroup_del_lru(cursor_page);
 				list_move(&cursor_page->lru, dst);
_

Patches currently in -mm which might be from dhillf@gmail.com are

linux-next.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page.patch
mm-vmscan-fix-typo-in-isolating-lru-pages.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch

