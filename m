From: akpm@linux-foundation.org
Subject: [patch 028/102] mm: use is_migrate_isolate_page() to
 simplify the code
Date: Wed, 03 May 2017 14:52:55 -0700
Message-ID: <20170503215255.sFpkHp7MX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47668 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbdECVw5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:52:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, qiuxishi@huawei.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: use is_migrate_isolate_page() to simplify the code

Use is_migrate_isolate_page() to simplify the code, no functional changes.

Link: http://lkml.kernel.org/r/58B94FB1.8020802@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_isolation.c~mm-use-is_migrate_isolate_page-to-simplify-the-code mm/page_isolation.c
--- a/mm/page_isolation.c~mm-use-is_migrate_isolate_page-to-simplify-the-code
+++ a/mm/page_isolation.c
@@ -88,7 +88,7 @@ static void unset_migratetype_isolate(st
 
 	zone = page_zone(page);
 	spin_lock_irqsave(&zone->lock, flags);
-	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
+	if (!is_migrate_isolate_page(page))
 		goto out;
 
 	/*
@@ -205,7 +205,7 @@ int undo_isolate_page_range(unsigned lon
 	     pfn < end_pfn;
 	     pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
-		if (!page || get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
+		if (!page || !is_migrate_isolate_page(page))
 			continue;
 		unset_migratetype_isolate(page, migratetype);
 	}
@@ -262,7 +262,7 @@ int test_pages_isolated(unsigned long st
 	 */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
-		if (page && get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
+		if (page && !is_migrate_isolate_page(page))
 			break;
 	}
 	page = __first_valid_page(start_pfn, end_pfn - start_pfn);
_
