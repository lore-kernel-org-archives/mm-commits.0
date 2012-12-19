From: akpm@linux-foundation.org
Subject: [merged] memcg-reclaim-when-more-than-one-page-needed.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:40:00 -0800
Message-ID: <20121219204001.74AED20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:35365 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2LSUkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:40:06 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so121285lag.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:40:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ssouhlal@FreeBSD.org, cl@linux-foundation.org, fweisbec@redhat.com, glommer@parallels.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: reclaim when more than one page needed
has been removed from the -mm tree.  Its filename was
     memcg-reclaim-when-more-than-one-page-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
Subject: memcg: reclaim when more than one page needed

mem_cgroup_do_charge() was written before kmem accounting, and expects
three cases: being called for 1 page, being called for a stock of 32
pages, or being called for a hugepage.  If we call for 2 or 3 pages (and
both the stack and several slabs used in process creation are such, at
least with the debug options I had), it assumed it's being called for
stock and just retried without reclaiming.

Fix that by passing down a minsize argument in addition to the csize.

And what to do about that (csize == PAGE_SIZE && ret) retry?  If it's
needed at all (and presumably is since it's there, perhaps to handle
races), then it should be extended to more than PAGE_SIZE, yet how far? 
And should there be a retry count limit, of what?  For now retry up to
COSTLY_ORDER (as page_alloc.c does) and make sure not to do it if
__GFP_NORETRY.

v4: fixed nr pages calculation pointed out by Christoph Lameter.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-reclaim-when-more-than-one-page-needed mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reclaim-when-more-than-one-page-needed
+++ a/mm/memcontrol.c
@@ -2258,7 +2258,8 @@ enum {
 };
 
 static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				unsigned int nr_pages, bool oom_check)
+				unsigned int nr_pages, unsigned int min_pages,
+				bool oom_check)
 {
 	unsigned long csize = nr_pages * PAGE_SIZE;
 	struct mem_cgroup *mem_over_limit;
@@ -2281,18 +2282,18 @@ static int mem_cgroup_do_charge(struct m
 	} else
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
 	/*
-	 * nr_pages can be either a huge page (HPAGE_PMD_NR), a batch
-	 * of regular pages (CHARGE_BATCH), or a single regular page (1).
-	 *
 	 * Never reclaim on behalf of optional batching, retry with a
 	 * single page instead.
 	 */
-	if (nr_pages == CHARGE_BATCH)
+	if (nr_pages > min_pages)
 		return CHARGE_RETRY;
 
 	if (!(gfp_mask & __GFP_WAIT))
 		return CHARGE_WOULDBLOCK;
 
+	if (gfp_mask & __GFP_NORETRY)
+		return CHARGE_NOMEM;
+
 	ret = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
 		return CHARGE_RETRY;
@@ -2305,7 +2306,7 @@ static int mem_cgroup_do_charge(struct m
 	 * unlikely to succeed so close to the limit, and we fall back
 	 * to regular pages anyway in case of failure.
 	 */
-	if (nr_pages == 1 && ret)
+	if (nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER) && ret)
 		return CHARGE_RETRY;
 
 	/*
@@ -2439,7 +2440,8 @@ again:
 			nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
 		}
 
-		ret = mem_cgroup_do_charge(memcg, gfp_mask, batch, oom_check);
+		ret = mem_cgroup_do_charge(memcg, gfp_mask, batch, nr_pages,
+		    oom_check);
 		switch (ret) {
 		case CHARGE_OK:
 			break;
_

Patches currently in -mm which might be from ssouhlal@FreeBSD.org are

origin.patch

