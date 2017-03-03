From: akpm@linux-foundation.org
Subject: + mm-use-is_migrate_isolate_page-to-simplify-the-code.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:06:34 -0800
Message-ID: <58b9f6fa.CyctbUaOgEbgVX0n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48988 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbdCCXPy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:15:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use is_migrate_isolate_page() to simplify the code
has been added to the -mm tree.  Its filename is
     mm-use-is_migrate_isolate_page-to-simplify-the-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-is_migrate_isolate_page-to-simplify-the-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-is_migrate_isolate_page-to-simplify-the-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-use-is_migrate_highatomic-to-simplify-the-code.patch
mm-use-is_migrate_isolate_page-to-simplify-the-code.patch

