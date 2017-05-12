From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-scan-until-it-founds-eligible-pages-fix.patch removed from -mm
 tree
Date: Fri, 12 May 2017 15:42:51 -0700
Message-ID: <59163a6b.2gu+0UT0E+svaddm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38392 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757976AbdELWmx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-scan-until-it-founds-eligible-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-scan-until-it-founds-eligible-pages-fix.patch

This patch was dropped because it was folded into mm-vmscan-scan-until-it-founds-eligible-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-scan-until-it-founds-eligible-pages-fix

Clean up mind-bending `for' statement.   Tweak comment text.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-scan-until-it-founds-eligible-pages-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-scan-until-it-founds-eligible-pages-fix
+++ a/mm/vmscan.c
@@ -1472,10 +1472,10 @@ static unsigned long isolate_lru_pages(u
 	unsigned long scan, total_scan, nr_pages;
 	LIST_HEAD(pages_skipped);
 
-	for (total_scan = scan = 0; scan < nr_to_scan &&
-					nr_taken < nr_to_scan &&
-					!list_empty(src);
-					total_scan++) {
+	scan = 0;
+	for (total_scan = 0;
+	     scan < nr_to_scan && nr_taken < nr_to_scan && !list_empty(src);
+	     total_scan++) {
 		struct page *page;
 
 		page = lru_to_page(src);
@@ -1490,10 +1490,10 @@ static unsigned long isolate_lru_pages(u
 		}
 
 		/*
-		 * Do not count skipped pages because it makes the function to
-		 * return with none isolated pages if the LRU mostly contains
-		 * ineligible pages so that VM cannot reclaim any pages and
-		 * trigger premature OOM.
+		 * Do not count skipped pages because that makes the function
+		 * return with no isolated pages if the LRU mostly contains
+		 * ineligible pages.  This causes the VM to not reclaim any
+		 * pages, triggering a premature OOM.
 		 */
 		scan++;
 		switch (__isolate_lru_page(page, mode)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

tigran-has-moved.patch
mm-vmscan-scan-until-it-founds-eligible-pages.patch

