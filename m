From: akpm@linux-foundation.org
Subject: +
 revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch added to -mm tree
Date: Tue, 28 Feb 2017 15:53:37 -0800
Message-ID: <58b60d81.vuimEDf2F51qvVr+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35798 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751439AbdCACMQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 21:12:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm, vmscan: account for skipped pages as a partial scan"
has been added to the -mm tree.  Its filename is
     revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Revert "mm, vmscan: account for skipped pages as a partial scan"

This reverts commit d7f05528eedb047efe2288cff777676b028747b6.

Now that reclaimability of a node is no longer based on the ratio between
pages scanned and theoretically reclaimable pages, we can remove
accounting tricks for pages skipped due to zone constraints.

Link: http://lkml.kernel.org/r/20170228214007.5621-9-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jia He <hejianet@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff -puN mm/vmscan.c~revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan mm/vmscan.c
--- a/mm/vmscan.c~revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan
+++ a/mm/vmscan.c
@@ -1471,12 +1471,12 @@ static unsigned long isolate_lru_pages(u
 	unsigned long nr_taken = 0;
 	unsigned long nr_zone_taken[MAX_NR_ZONES] = { 0 };
 	unsigned long nr_skipped[MAX_NR_ZONES] = { 0, };
-	unsigned long skipped = 0, total_skipped = 0;
+	unsigned long skipped = 0;
 	unsigned long scan, nr_pages;
 	LIST_HEAD(pages_skipped);
 
 	for (scan = 0; scan < nr_to_scan && nr_taken < nr_to_scan &&
-					!list_empty(src);) {
+					!list_empty(src); scan++) {
 		struct page *page;
 
 		page = lru_to_page(src);
@@ -1490,12 +1490,6 @@ static unsigned long isolate_lru_pages(u
 			continue;
 		}
 
-		/*
-		 * Account for scanned and skipped separetly to avoid the pgdat
-		 * being prematurely marked unreclaimable by pgdat_reclaimable.
-		 */
-		scan++;
-
 		switch (__isolate_lru_page(page, mode)) {
 		case 0:
 			nr_pages = hpage_nr_pages(page);
@@ -1524,6 +1518,7 @@ static unsigned long isolate_lru_pages(u
 	if (!list_empty(&pages_skipped)) {
 		int zid;
 
+		list_splice(&pages_skipped, src);
 		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 			if (!nr_skipped[zid])
 				continue;
@@ -1531,17 +1526,8 @@ static unsigned long isolate_lru_pages(u
 			__count_zid_vm_events(PGSCAN_SKIP, zid, nr_skipped[zid]);
 			skipped += nr_skipped[zid];
 		}
-
-		/*
-		 * Account skipped pages as a partial scan as the pgdat may be
-		 * close to unreclaimable. If the LRU list is empty, account
-		 * skipped pages as a full scan.
-		 */
-		total_skipped = list_empty(src) ? skipped : skipped >> 2;
