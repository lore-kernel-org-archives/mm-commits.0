From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:32:39 -0800
Message-ID: <56997387.gVpjaBfWj8PmRW6t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbcAOWck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, minchan@kernel.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation.c: return last tested pfn rather than failure indicator
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/page_isolation.c: return last tested pfn rather than failure indicator

This is preparation step to report test failed pfn in new tracepoint to
analyze cma allocation failure problem.  There is no functional change in
this patch.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/page_isolation.c~mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator
+++ a/mm/page_isolation.c
@@ -212,7 +212,7 @@ int undo_isolate_page_range(unsigned lon
  *
  * Returns 1 if all pages in the range are isolated.
  */
-static int
+static unsigned long
 __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
 				  bool skip_hwpoisoned_pages)
 {
@@ -237,9 +237,8 @@ __test_page_isolated_in_pageblock(unsign
 		else
 			break;
 	}
-	if (pfn < end_pfn)
-		return 0;
-	return 1;
+
+	return pfn;
 }
 
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
@@ -248,7 +247,6 @@ int test_pages_isolated(unsigned long st
 	unsigned long pfn, flags;
 	struct page *page;
 	struct zone *zone;
-	int ret;
 
 	/*
 	 * Note: pageblock_nr_pages != MAX_ORDER. Then, chunks of free pages
@@ -266,10 +264,11 @@ int test_pages_isolated(unsigned long st
 	/* Check all pages are free or marked as ISOLATED */
 	zone = page_zone(page);
 	spin_lock_irqsave(&zone->lock, flags);
-	ret = __test_page_isolated_in_pageblock(start_pfn, end_pfn,
+	pfn = __test_page_isolated_in_pageblock(start_pfn, end_pfn,
 						skip_hwpoisoned_pages);
 	spin_unlock_irqrestore(&zone->lock, flags);
-	return ret ? 0 : -EBUSY;
+
+	return pfn < end_pfn ? -EBUSY : 0;
 }
 
 struct page *alloc_migrate_target(struct page *page, unsigned long private,
_

Patches currently in -mm which might be from js1304@gmail.com are


