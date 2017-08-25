From: akpm@linux-foundation.org
Subject: [folded-merged]
 pm-hibernate-feed-the-wathdog-when-creating-snapshot-v3.patch removed from
 -mm tree
Date: Fri, 25 Aug 2017 15:52:53 -0700
Message-ID: <59a0aa45.2ClKo3nrDJ99I0Q+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59922 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933344AbdHYWxl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2017 18:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yu.c.chen@intel.com, dan.j.williams@intel.com, jan.filipcewicz@intel.com, lenb@kernel.org, mgorman@techsingularity.net, mhocko@suse.com, rjw@rjwysocki.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: [v3] PM / Hibernate: Feed the wathdog when creating snapshot
has been removed from the -mm tree.  Its filename was
     pm-hibernate-feed-the-wathdog-when-creating-snapshot-v3.patch

This patch was dropped because it was folded into pm-hibernate-feed-the-wathdog-when-creating-snapshot.patch

------------------------------------------------------
From: Chen Yu <yu.c.chen@intel.com>
Subject: [v3] PM / Hibernate: Feed the wathdog when creating snapshot

simplification

Link: http://lkml.kernel.org/r/1503460079-29721-1-git-send-email-yu.c.chen@intel.com
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Cc: Jan Filipcewicz <jan.filipcewicz@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~pm-hibernate-feed-the-wathdog-when-creating-snapshot-v3 mm/page_alloc.c
--- a/mm/page_alloc.c~pm-hibernate-feed-the-wathdog-when-creating-snapshot-v3
+++ a/mm/page_alloc.c
@@ -2537,14 +2537,13 @@ void drain_all_pages(struct zone *zone)
 #ifdef CONFIG_HIBERNATION
 
 /*
- * Touch the watchdog for every WD_INTERVAL_PAGE pages,
- * choose a power of 2 to avoid the modulus operation.
+ * Touch the watchdog for every WD_PAGE_COUNT pages.
  */
-#define WD_INTERVAL_PAGE	(128*1024)
+#define WD_PAGE_COUNT	(128*1024)
 
 void mark_free_pages(struct zone *zone)
 {
-	unsigned long pfn, max_zone_pfn, page_num = 0;
+	unsigned long pfn, max_zone_pfn, page_count = WD_PAGE_COUNT;
 	unsigned long flags;
 	unsigned int order, t;
 	struct page *page;
@@ -2559,8 +2558,10 @@ void mark_free_pages(struct zone *zone)
 		if (pfn_valid(pfn)) {
 			page = pfn_to_page(pfn);
 
-			if (!((page_num++) % WD_INTERVAL_PAGE))
+			if (!--page_count) {
 				touch_nmi_watchdog();
+				page_count = WD_PAGE_COUNT;
+			}
 
 			if (page_zone(page) != zone)
 				continue;
@@ -2576,8 +2577,10 @@ void mark_free_pages(struct zone *zone)
 
 			pfn = page_to_pfn(page);
 			for (i = 0; i < (1UL << order); i++) {
-				if (!((page_num++) % WD_INTERVAL_PAGE))
+				if (!--page_count) {
 					touch_nmi_watchdog();
+					page_count = WD_PAGE_COUNT;
+				}
 				swsusp_set_page_free(pfn_to_page(pfn + i));
 			}
 		}
_

Patches currently in -mm which might be from yu.c.chen@intel.com are

pm-hibernate-feed-the-wathdog-when-creating-snapshot.patch

