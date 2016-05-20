From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch removed from -mm tree
Date: Fri, 20 May 2016 14:06:28 -0700
Message-ID: <573f7c54.ASdhpfTXjo7X2pP1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbcETVG3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove unnecessary local variable in get_page_from_freelist
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mgorman@techsingularity.net are


