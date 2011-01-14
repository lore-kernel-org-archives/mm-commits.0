From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:38 -0800
Message-ID: <201101142252.p0EMqSSC005627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWwq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@in.ibm.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix unit mismatch in memcg oom limit calculation
has been removed from the -mm tree.  Its filename was
     memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix unit mismatch in memcg oom limit calculation
From: Johannes Weiner <hannes@cmpxchg.org>

Adding the number of swap pages to the byte limit of a memory control
group makes no sense.  Convert the pages to bytes before adding them.

The only user of this code is the OOM killer, and the way it is used means
that the error results in a higher OOM badness value.  Since the cgroup
limit is the same for all tasks in the cgroup, the error should have no
practical impact at the moment.

But let's not wait for future or changing users to trip over it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation
+++ a/mm/memcontrol.c
@@ -1312,8 +1312,9 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 	u64 limit;
 	u64 memsw;
 
-	limit = res_counter_read_u64(&memcg->res, RES_LIMIT) +
-			total_swap_pages;
+	limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
+	limit += total_swap_pages << PAGE_SHIFT;
+
 	memsw = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
 	/*
 	 * If memsw is finite and limits the amount of swap space available
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

