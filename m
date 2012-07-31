From: akpm@linux-foundation.org
Subject: [folded] mm-oom-reduce-dependency-on-tasklist_lock-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:31:55 -0700
Message-ID: <20120731233155.62499A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:44314 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab2GaXb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:31:57 -0400
Received: by bkcjc3 with SMTP id jc3so299783bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:31:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: reduce dependency on tasklist_lock: fix
has been removed from the -mm tree.  Its filename was
     mm-oom-reduce-dependency-on-tasklist_lock-fix.patch

This patch was dropped because it was folded into mm-oom-reduce-dependency-on-tasklist_lock.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm, oom: reduce dependency on tasklist_lock: fix

Slab poisoning gave me a General Protection Fault on the
	atomic_dec(&__task_cred(p)->user->processes);
line of release_task() called from wait_task_zombie(),
every time my dd to USB testing generated a memcg OOM.

oom_kill_process() now does the put_task_struct(),
mem_cgroup_out_of_memory() should not repeat it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memcontrol.c~mm-oom-reduce-dependency-on-tasklist_lock-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-reduce-dependency-on-tasklist_lock-fix
+++ a/mm/memcontrol.c
@@ -1523,7 +1523,6 @@ void __mem_cgroup_out_of_memory(struct m
 	points = chosen_points * 1000 / totalpages;
 	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
 			 NULL, "Memory cgroup out of memory");
-	put_task_struct(chosen);
 }
 
 static unsigned long mem_cgroup_reclaim(struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from hughd@google.com are

memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
mm-oom-reduce-dependency-on-tasklist_lock.patch
mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits.patch
mm-swapfile-clean-up-unuse_pte-race-handling.patch
mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions.patch
mm-memcg-only-check-for-pageswapcache-when-uncharging-anon.patch
mm-memcg-move-swapin-charge-functions-above-callsites.patch
mm-memcg-remove-unneeded-shmem-charge-type.patch
mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging.patch
mm-memcg-split-swapin-charge-function-into-private-and-public-part.patch
mm-memcg-only-check-swap-cache-pages-for-repeated-charging.patch
mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
tmpfs-distribute-interleave-better-across-nodes.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

