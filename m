From: akpm@linux-foundation.org
Subject: [folded-merged] mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:48:39 -0700
Message-ID: <20130429214840.4D6785A4034@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38876 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296Ab3D2Vsl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:48:41 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so109120vbe.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:48:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, dan.carpenter@oracle.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix.patch

This patch was dropped because it was folded into mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix

Dan Carpenter has reported that (alloc_flags & ALLOC_WMARK_MIN) test
doesn't make much sense as the flag is 0 and it is in fact intended for
wmark indexing rather than being used as a flag.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix
+++ a/mm/page_alloc.c
@@ -1955,7 +1955,7 @@ zonelist_scan:
 				 * when the watermark is between the low and
 				 * min watermarks.
 				 */
-				if ((alloc_flags & ALLOC_WMARK_MIN) ||
+				if (((alloc_flags & ALLOC_WMARK_MASK) == ALLOC_WMARK_MIN) ||
 				    ret == ZONE_RECLAIM_SOME)
 					goto this_zone_full;
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch
rmap-recompute-pgoff-for-unmapping-huge-page.patch
memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter.patch
memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators.patch
memcg-relax-memcg-iter-caching.patch
memcg-simplify-mem_cgroup_iter.patch
memcg-further-simplify-mem_cgroup_iter.patch
cgroup-remove-css_get_next.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim.patch
memcg-add-memorypressure_level-events.patch
memcg-avoid-accessing-memcg-after-releasing-reference.patch
mm-memcg-give-exiting-processes-access-to-memory-reserves.patch
memcg-take-reference-before-releasing-rcu_read_lock.patch

