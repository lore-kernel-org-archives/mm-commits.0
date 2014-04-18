From: akpm@linux-foundation.org
Subject: + mm-page_alloc-do-not-cache-reclaim-distances.patch added to -mm tree
Date: Fri, 18 Apr 2014 13:06:38 -0700
Message-ID: <535185ce.+shpjTaPUTpb3Ija%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaDRUGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 16:06:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, mhocko@suse.cz, hannes@cmpxchg.org, mgorman@suse.de

Subject: + mm-page_alloc-do-not-cache-reclaim-distances.patch added to -mm tree
To: mgorman@suse.de,hannes@cmpxchg.org,mhocko@suse.cz,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 13:06:38 -0700


The patch titled
     Subject: mm: page_alloc: do not cache reclaim distances
has been added to the -mm tree.  Its filename is
     mm-page_alloc-do-not-cache-reclaim-distances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-do-not-cache-reclaim-distances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-do-not-cache-reclaim-distances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: do not cache reclaim distances

pgdat->reclaim_nodes tracks if a remote node is allowed to be reclaimed by
zone_reclaim due to its distance. As it is expected that zone_reclaim_mode
will be rarely enabled it is unreasonable for all machines to take a penalty.
Fortunately, the zone_reclaim_mode() path is already slow and it is the path
that takes the hit.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 mm/page_alloc.c        |   15 ++-------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-do-not-cache-reclaim-distances include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-do-not-cache-reclaim-distances
+++ a/include/linux/mmzone.h
@@ -763,7 +763,6 @@ typedef struct pglist_data {
 	unsigned long node_spanned_pages; /* total size of physical page
 					     range, including holes */
 	int node_id;
-	nodemask_t reclaim_nodes;	/* Nodes allowed to reclaim from */
 	wait_queue_head_t kswapd_wait;
 	wait_queue_head_t pfmemalloc_wait;
 	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
diff -puN mm/page_alloc.c~mm-page_alloc-do-not-cache-reclaim-distances mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-do-not-cache-reclaim-distances
+++ a/mm/page_alloc.c
@@ -1850,16 +1850,8 @@ static bool zone_local(struct zone *loca
 
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
-	return node_isset(local_zone->node, zone->zone_pgdat->reclaim_nodes);
-}
-
-static void __paginginit init_zone_allows_reclaim(int nid)
-{
-	int i;
-
-	for_each_node_state(i, N_MEMORY)
-		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
-			node_set(i, NODE_DATA(nid)->reclaim_nodes);
+	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) <
+				RECLAIM_DISTANCE;
 }
 
 #else	/* CONFIG_NUMA */
@@ -1893,9 +1885,6 @@ static bool zone_allows_reclaim(struct z
 	return true;
 }
 
-static inline void init_zone_allows_reclaim(int nid)
-{
-}
 #endif	/* CONFIG_NUMA */
 
 /*
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-use-paravirt-friendly-ops-for-numa-hinting-ptes.patch
thp-close-race-between-split-and-zap-huge-pages.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

