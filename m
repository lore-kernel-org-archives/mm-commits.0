From: akpm@linux-foundation.org
Subject: +
 mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch added to -mm tree
Date: Tue, 17 Nov 2015 14:42:50 -0800
Message-ID: <564bad6a.ZFqSbMgekdxPa303%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbbKQWmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 17:42:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, minchan@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation.c: return last tested pfn rather than failure indicator
has been added to the -mm tree.  Its filename is
     mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch
mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch
mm-cma-always-check-which-page-cause-allocation-failure.patch

