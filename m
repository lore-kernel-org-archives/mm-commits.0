From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:41 -0800
Message-ID: <20130225205441.BD7155A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:41616 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3BYUym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:42 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so347416ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add informative debugging message in page_outside_zone_boundaries()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: add informative debugging message in page_outside_zone_boundaries()

Add a debug message which prints when a page is found outside of the
boundaries of the zone it should belong to. Format is:
	"page $pfn outside zone [ $start_pfn - $end_pfn ]"

[akpm@linux-foundation.org: s/pr_debug/pr_err/]
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries
+++ a/mm/page_alloc.c
@@ -247,13 +247,20 @@ static int page_outside_zone_boundaries(
 	int ret = 0;
 	unsigned seq;
 	unsigned long pfn = page_to_pfn(page);
+	unsigned long sp, start_pfn;
 
 	do {
 		seq = zone_span_seqbegin(zone);
+		start_pfn = zone->zone_start_pfn;
+		sp = zone->spanned_pages;
 		if (!zone_spans_pfn(zone, pfn))
 			ret = 1;
 	} while (zone_span_seqretry(zone, seq));
 
+	if (ret)
+		pr_err("page %lu outside zone [ %lu - %lu ]\n",
+			pfn, start_pfn, start_pfn + sp);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch

