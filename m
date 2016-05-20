From: akpm@linux-foundation.org
Subject: [patch 096/117] mm, page_alloc: remove unnecessary local variable in get_page_from_freelist
Date: Thu, 19 May 2016 17:13:44 -0700
Message-ID: <573e56b8.l8GENyqsxq9QzU7F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbcETANp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:13:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: remove unnecessary local variable in get_page_from_freelist

zonelist here is a copy of a struct field that is used once. Ditch it.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist
+++ a/mm/page_alloc.c
@@ -2676,7 +2676,6 @@ static struct page *
 get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 						const struct alloc_context *ac)
 {
-	struct zonelist *zonelist = ac->zonelist;
 	struct zoneref *z;
 	struct page *page = NULL;
 	struct zone *zone;
@@ -2690,7 +2689,7 @@ zonelist_scan:
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
 	 */
-	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->high_zoneidx,
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
 								ac->nodemask) {
 		unsigned long mark;
 
_
