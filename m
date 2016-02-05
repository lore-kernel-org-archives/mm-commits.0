From: akpm@linux-foundation.org
Subject: + mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch
 added to -mm tree
Date: Fri, 05 Feb 2016 11:23:28 -0800
Message-ID: <56b4f6b0.F80HPr6UniUdyRFk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbcBETX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 14:23:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-make-tree_statevents-fetch-all-stats-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm-memcontrol-make-tree_statevents-fetch-all-stats-fix

> This looks much better, and most of the callstacks involved here are
> very flat, so the increased stack consumption should be alright.
>
> The only exception there is the threshold code, which can happen from
> the direct reclaim path and thus with a fairly deep stack already.

Yeah, I missed this case. Thought mem_cgroup_usage is only used for
reporting to userspace. Thanks for catching this.

>
> Would it be better to leave mem_cgroup_usage() alone, open-code it,
> and then use tree_stat() and tree_events() only for v2 memory.stat?
>

Definitely.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-make-tree_statevents-fetch-all-stats-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-make-tree_statevents-fetch-all-stats-fix
+++ a/mm/memcontrol.c
@@ -2745,14 +2745,20 @@ static void tree_events(struct mem_cgrou
 
 static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 {
-	unsigned long stat[MEMCG_NR_STAT];
-	unsigned long val;
+	unsigned long val = 0;
 
 	if (mem_cgroup_is_root(memcg)) {
-		tree_stat(memcg, stat);
-		val = stat[MEM_CGROUP_STAT_CACHE] + stat[MEM_CGROUP_STAT_RSS];
-		if (swap)
-			val += stat[MEM_CGROUP_STAT_SWAP];
+		struct mem_cgroup *iter;
+
+		for_each_mem_cgroup_tree(iter, memcg) {
+			val += mem_cgroup_read_stat(iter,
+					MEM_CGROUP_STAT_CACHE);
+			val += mem_cgroup_read_stat(iter,
+					MEM_CGROUP_STAT_RSS);
+			if (swap)
+				val += mem_cgroup_read_stat(iter,
+						MEM_CGROUP_STAT_SWAP);
+		}
 	} else {
 		if (!swap)
 			val = page_counter_read(&memcg->memory);
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch

