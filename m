From: akpm@linux-foundation.org
Subject: + mm-oom-reduce-dependency-on-tasklist_lock-fix.patch added to -mm tree
Date: Mon, 16 Jul 2012 14:21:53 -0700
Message-ID: <20120716212154.28D2620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:39173 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2GPVV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jul 2012 17:21:57 -0400
Received: by weyr1 with SMTP id r1so329084wey.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Jul 2012 14:21:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com, rientjes@google.com


The patch titled
     Subject: mm, oom: reduce dependency on tasklist_lock: fix
has been added to the -mm tree.  Its filename is
     mm-oom-reduce-dependency-on-tasklist_lock-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm, oom: reduce dependency on tasklist_lock: fix

Patches currently in -mm which might be from hughd@google.com are

memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
mm-oom-reduce-dependency-on-tasklist_lock-fix.patch
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
shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
tmpfs-interleave-the-starting-node-of-dev-shmem.patch
prio_tree-debugging-patch.patch

