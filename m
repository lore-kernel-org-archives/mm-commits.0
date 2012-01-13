From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-clean-up-fault-accounting.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:39 -0800
Message-ID: <20120113203340.26A6A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:33163 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:43 -0500
Received: by wgbdt14 with SMTP id dt14so106207wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: clean up fault accounting
has been removed from the -mm tree.  Its filename was
     mm-memcg-clean-up-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: clean up fault accounting

The fault accounting functions have a single, memcg-internal user, so they
don't need to be global.  In fact, their one-line bodies can be directly
folded into the caller.  And since faults happen one at a time, use
this_cpu_inc() directly instead of this_cpu_add(foo, 1).

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-clean-up-fault-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-clean-up-fault-accounting
+++ a/mm/memcontrol.c
@@ -655,16 +655,6 @@ static void mem_cgroup_swap_statistics(s
 	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAPOUT], val);
 }
 
-void mem_cgroup_pgfault(struct mem_cgroup *memcg, int val)
-{
-	this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_PGFAULT], val);
-}
-
-void mem_cgroup_pgmajfault(struct mem_cgroup *memcg, int val)
-{
-	this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_PGMAJFAULT], val);
-}
-
 static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
 					    enum mem_cgroup_events_index idx)
 {
@@ -978,11 +968,11 @@ void mem_cgroup_count_vm_event(struct mm
 		goto out;
 
 	switch (idx) {
-	case PGMAJFAULT:
-		mem_cgroup_pgmajfault(memcg, 1);
-		break;
 	case PGFAULT:
-		mem_cgroup_pgfault(memcg, 1);
+		this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGFAULT]);
+		break;
+	case PGMAJFAULT:
+		this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGMAJFAULT]);
 		break;
 	default:
 		BUG();
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

