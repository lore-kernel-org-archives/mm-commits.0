From: akpm@linux-foundation.org
Subject: [patch 098/117] mm, page_alloc: remove unnecessary initialisation from __alloc_pages_nodemask()
Date: Thu, 19 May 2016 17:13:50 -0700
Message-ID: <573e56be.cHuiITz9TwCDvavn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbcETANv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:13:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: remove unnecessary initialisation from __alloc_pages_nodemask()

page is guaranteed to be set before it is read with or without the
initialisation.

[akpm@linux-foundation.org: fix warning]
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask
+++ a/mm/page_alloc.c
@@ -3347,7 +3347,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
 	struct zoneref *preferred_zoneref;
-	struct page *page = NULL;
+	struct page *page;
 	unsigned int cpuset_mems_cookie;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW|ALLOC_FAIR;
 	gfp_t alloc_mask; /* The gfp_t that was actually used for allocation */
@@ -3393,8 +3393,11 @@ retry_cpuset:
 	/* The preferred zone is used for statistics later */
 	preferred_zoneref = first_zones_zonelist(ac.zonelist, ac.high_zoneidx,
 				ac.nodemask, &ac.preferred_zone);
-	if (!ac.preferred_zone)
+	if (!ac.preferred_zone) {
+		page = NULL;
 		goto out;
+	}
+
 	ac.classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
 	/* First allocation attempt */
_
