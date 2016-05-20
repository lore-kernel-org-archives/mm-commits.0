From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:06:36 -0700
Message-ID: <573f7c5c.rC3rx59aABoNviJ4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcETVGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: move __GFP_HARDWALL modifications out of the fastpath
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: move __GFP_HARDWALL modifications out of the fastpath

__GFP_HARDWALL only has meaning in the context of cpusets but the fast
path always applies the flag on the first attempt.  Move the manipulations
into the cpuset paths where they will be masked by a static branch in the
common case.

With the other micro-optimisations in this series combined, the impact on
a page allocator microbenchmark is

                                           4.6.0-rc2                  4.6.0-rc2
                                       decstat-v1r20                micro-v1r20
Min      alloc-odr0-1               381.00 (  0.00%)           377.00 (  1.05%)
Min      alloc-odr0-2               275.00 (  0.00%)           273.00 (  0.73%)
Min      alloc-odr0-4               229.00 (  0.00%)           226.00 (  1.31%)
Min      alloc-odr0-8               199.00 (  0.00%)           196.00 (  1.51%)
Min      alloc-odr0-16              186.00 (  0.00%)           183.00 (  1.61%)
Min      alloc-odr0-32              179.00 (  0.00%)           175.00 (  2.23%)
Min      alloc-odr0-64              174.00 (  0.00%)           172.00 (  1.15%)
Min      alloc-odr0-128             172.00 (  0.00%)           170.00 (  1.16%)
Min      alloc-odr0-256             181.00 (  0.00%)           183.00 ( -1.10%)
Min      alloc-odr0-512             193.00 (  0.00%)           191.00 (  1.04%)
Min      alloc-odr0-1024            201.00 (  0.00%)           199.00 (  1.00%)
Min      alloc-odr0-2048            206.00 (  0.00%)           204.00 (  0.97%)
Min      alloc-odr0-4096            212.00 (  0.00%)           210.00 (  0.94%)
Min      alloc-odr0-8192            215.00 (  0.00%)           213.00 (  0.93%)
Min      alloc-odr0-16384           216.00 (  0.00%)           214.00 (  0.93%)

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath
+++ a/mm/page_alloc.c
@@ -3350,7 +3350,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW|ALLOC_FAIR;
-	gfp_t alloc_mask; /* The gfp_t that was actually used for allocation */
+	gfp_t alloc_mask = gfp_mask; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = {
 		.high_zoneidx = gfp_zone(gfp_mask),
 		.zonelist = zonelist,
@@ -3359,6 +3359,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	};
 
 	if (cpusets_enabled()) {
+		alloc_mask |= __GFP_HARDWALL;
 		alloc_flags |= ALLOC_CPUSET;
 		if (!ac.nodemask)
 			ac.nodemask = &cpuset_current_mems_allowed;
@@ -3401,7 +3402,6 @@ retry_cpuset:
 	ac.classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
 	/* First allocation attempt */
-	alloc_mask = gfp_mask|__GFP_HARDWALL;
 	page = get_page_from_freelist(alloc_mask, order, alloc_flags, &ac);
 	if (unlikely(!page)) {
 		/*
@@ -3427,8 +3427,10 @@ out:
 	 * the mask is being updated. If a page allocation is about to fail,
 	 * check if the cpuset changed during allocation and if so, retry.
 	 */
-	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
+	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie))) {
+		alloc_mask = gfp_mask;
 		goto retry_cpuset;
+	}
 
 	return page;
 }
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


