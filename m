From: akpm@linux-foundation.org
Subject: [patch 097/117] mm, page_alloc: remove unnecessary initialisation in get_page_from_freelist
Date: Thu, 19 May 2016 17:13:47 -0700
Message-ID: <573e56bb.xUCdz6fBJrsAyn2D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbcETANs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:13:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: remove unnecessary initialisation in get_page_from_freelist

See subject.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist
+++ a/mm/page_alloc.c
@@ -2677,7 +2677,6 @@ get_page_from_freelist(gfp_t gfp_mask, u
 						const struct alloc_context *ac)
 {
 	struct zoneref *z;
-	struct page *page = NULL;
 	struct zone *zone;
 	bool fair_skipped;
 	bool zonelist_rescan;
@@ -2691,6 +2690,7 @@ zonelist_scan:
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
 								ac->nodemask) {
+		struct page *page;
 		unsigned long mark;
 
 		if (cpusets_enabled() &&
_
