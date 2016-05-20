From: akpm@linux-foundation.org
Subject: [patch 017/162] mm, oom: protect !costly allocations some more
 for !CONFIG_COMPACTION
Date: Fri, 20 May 2016 16:57:15 -0700
Message-ID: <573fa45b.00S4VHirsVB7EKk3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcETX5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:57:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: protect !costly allocations some more for !CONFIG_COMPACTION

Joonsoo has reported that he is able to trigger OOM for !costly high order
requests (heavy fork() workload close the OOM) with the new oom detection
rework.  This is because we rely only on should_reclaim_retry when the
compaction is disabled and it only checks watermarks for the requested
order and so we might trigger OOM when there is a lot of free memory.

It is not very clear what are the usual workloads when the compaction is
disabled.  Relying on high order allocations heavily without any mechanism
to create those orders except for unbound amount of reclaim is certainly
not a good idea.

To prevent from potential regressions let's help this configuration some. 
We have to sacrifice the determinsm though because there simply is none
here possible.  should_compact_retry implementation for
!CONFIG_COMPACTION, which was empty so far, will do watermark check for
order-0 on all eligible zones.  This will cause retrying until either the
reclaim cannot make any further progress or all the zones are depleted
even for order-0 pages.  This means that the number of retries is
basically unbounded for !costly orders but that was the case before the
rework as well so this shouldn't regress.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/1463051677-29418-3-git-send-email-mhocko@kernel.org
Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN mm/page_alloc.c~mm-oom-protect-costly-allocations-some-more-for-config_compaction mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-protect-costly-allocations-some-more-for-config_compaction
+++ a/mm/page_alloc.c
@@ -3317,6 +3317,24 @@ should_compact_retry(struct alloc_contex
 		     enum migrate_mode *migrate_mode,
 		     int compaction_retries)
 {
+	struct zone *zone;
+	struct zoneref *z;
+
+	if (!order || order > PAGE_ALLOC_COSTLY_ORDER)
+		return false;
+
+	/*
+	 * There are setups with compaction disabled which would prefer to loop
+	 * inside the allocator rather than hit the oom killer prematurely.
+	 * Let's give them a good hope and keep retrying while the order-0
+	 * watermarks are OK.
+	 */
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
+					ac->nodemask) {
+		if (zone_watermark_ok(zone, 0, min_wmark_pages(zone),
+					ac_classzone_idx(ac), alloc_flags))
+			return true;
+	}
 	return false;
 }
 #endif /* CONFIG_COMPACTION */
_
