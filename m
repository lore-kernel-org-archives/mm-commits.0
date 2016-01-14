From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-cma-always-check-which-page-cause-allocation-failure-v2.patch removed
 from -mm tree
Date: Thu, 14 Jan 2016 14:20:52 -0800
Message-ID: <56981f44.6GXBt8FA5tYTSTyj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbcANWUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:20:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, minchan@kernel.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: always check which page cause allocation failure
has been removed from the -mm tree.  Its filename was
     mm-cma-always-check-which-page-cause-allocation-failure-v2.patch

This patch was dropped because it was folded into mm-cma-always-check-which-page-cause-allocation-failure.patch

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/cma: always check which page cause allocation failure

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/page_alloc.c~mm-cma-always-check-which-page-cause-allocation-failure-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-always-check-which-page-cause-allocation-failure-v2
+++ a/mm/page_alloc.c
@@ -6763,6 +6763,19 @@ int alloc_contig_range(unsigned long sta
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

mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch
mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch
mm-cma-always-check-which-page-cause-allocation-failure.patch
mm-compaction-__compact_pgdat-code-cleanuup.patch

