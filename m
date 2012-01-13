From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:03 -0800
Message-ID: <20120113203504.3B5C420005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759049Ab2AMUfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:06 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, mgorman@suse.de, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: check if we isolated a compound page during lumpy scan
has been removed from the -mm tree.  Its filename was
     mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: vmscan: check if we isolated a compound page during lumpy scan

Properly take into account if we isolated a compound page during the lumpy
scan in reclaim and skip over the tail pages when encountered.  This
corrects the values given to the tracepoint for number of lumpy pages
isolated and will avoid breaking the loop early if compound pages smaller
than the requested allocation size are requested.

[mgorman@suse.de: Updated changelog]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan
+++ a/mm/vmscan.c
@@ -1196,13 +1196,17 @@ static unsigned long isolate_lru_pages(u
 				break;
 
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
+				unsigned int isolated_pages;
+
 				mem_cgroup_lru_del(cursor_page);
 				list_move(&cursor_page->lru, dst);
-				nr_taken += hpage_nr_pages(cursor_page);
-				nr_lumpy_taken++;
+				isolated_pages = hpage_nr_pages(cursor_page);
+				nr_taken += isolated_pages;
+				nr_lumpy_taken += isolated_pages;
 				if (PageDirty(cursor_page))
-					nr_lumpy_dirty++;
+					nr_lumpy_dirty += isolated_pages;
 				scan++;
+				pfn += isolated_pages - 1;
 			} else {
 				/*
 				 * Check if the page is freed already.
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch

