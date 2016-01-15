From: akpm@linux-foundation.org
Subject: [merged]
 mm-cma-always-check-which-page-cause-allocation-failure.patch removed from
 -mm tree
Date: Fri, 15 Jan 2016 14:32:45 -0800
Message-ID: <5699738d.IPL9RmeLjgV22Ilv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbcAOWcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, minchan@kernel.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: always check which page caused allocation failure
has been removed from the -mm tree.  Its filename was
     mm-cma-always-check-which-page-cause-allocation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/cma: always check which page caused allocation failure

Now, we have tracepoint in test_pages_isolated() to notify pfn which
cannot be isolated.  But, in alloc_contig_range(), some error path doesn't
call test_pages_isolated() so it's still hard to know exact pfn that
causes allocation failure.

This patch change this situation by calling test_pages_isolated() in
almost error path.  In allocation failure case, some overhead is added by
this change, but, allocation failure is really rare event so it would not
matter.

In fatal signal pending case, we don't call test_pages_isolated() because
this failure is intentional one.

There was a bogus outer_start problem due to unchecked buddy order and
this patch also fix it.  Before this patch, it didn't matter, because end
result is same thing.  But, after this patch, tracepoint will report
failed pfn so it should be accurate.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-cma-always-check-which-page-cause-allocation-failure mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-always-check-which-page-cause-allocation-failure
+++ a/mm/page_alloc.c
@@ -6725,8 +6725,12 @@ int alloc_contig_range(unsigned long sta
 	if (ret)
 		return ret;
 
+	/*
+	 * In case of -EBUSY, we'd like to know which page causes problem.
+	 * So, just fall through. We will check it in test_pages_isolated().
+	 */
 	ret = __alloc_contig_migrate_range(&cc, start, end);
-	if (ret)
+	if (ret && ret != -EBUSY)
 		goto done;
 
 	/*
@@ -6753,12 +6757,25 @@ int alloc_contig_range(unsigned long sta
 	outer_start = start;
 	while (!PageBuddy(pfn_to_page(outer_start))) {
 		if (++order >= MAX_ORDER) {
-			ret = -EBUSY;
-			goto done;
+			outer_start = start;
+			break;
 		}
 		outer_start &= ~0UL << order;
 	}
 
+	if (outer_start != start) {
+		order = page_order(pfn_to_page(outer_start));
+
+		/*
+		 * outer_start page could be small order buddy page and
+		 * it doesn't include start page. Adjust outer_start
+		 * in this case to report failed page properly
+		 * on tracepoint in test_pages_isolated()
+		 */
+		if (outer_start + (1UL << order) <= start)
+			outer_start = start;
+	}
+
 	/* Make sure the range is really isolated. */
 	if (test_pages_isolated(outer_start, end, false)) {
 		pr_info("%s: [%lx, %lx) PFNs busy\n",
_

Patches currently in -mm which might be from js1304@gmail.com are


