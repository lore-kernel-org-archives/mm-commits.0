From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 =?US-ASCII?Q?mmpage=5Falloccma-conditionally-prefer-cma-pageblocks-for-m?=
 =?US-ASCII?Q?ovable-allocations-fix.patch?= removed from -mm tree
Date: Wed, 03 Jun 2020 15:10:42 -0700
Message-ID: <20200603221042.AuWOPIZQn%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgFCWKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:10:43 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, cai@lca.pw, guro@fb.com, js1304@gmail.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, riel@surriel.com, vbabka@suse.cz


The patch titled
     Subject: mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix
has been removed from the -mm tree.  Its filename was
     mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch

This patch was dropped because it was folded into mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix

ifdef the cma-specific code.

Link: http://lkml.kernel.org/r/20200311225832.GA178154@carbon.DHCP.thefacebook.com
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Qian Cai <cai@lca.pw>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix
+++ a/mm/page_alloc.c
@@ -2752,6 +2752,7 @@ __rmqueue(struct zone *zone, unsigned in
 {
 	struct page *page;
 
+#ifdef CONFIG_CMA
 	/*
 	 * Balance movable allocations between regular and CMA areas by
 	 * allocating from CMA when over half of the zone's free memory
@@ -2764,6 +2765,7 @@ __rmqueue(struct zone *zone, unsigned in
 		if (page)
 			return page;
 	}
+#endif
 retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 	if (unlikely(!page)) {
_

Patches currently in -mm which might be from guro@fb.com are

mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
