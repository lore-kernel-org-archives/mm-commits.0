From: akpm@linux-foundation.org
Subject: + memcg-always-free-struct-memcg-through-schedule_work.patch added to -mm tree
Date: Wed, 16 May 2012 14:13:54 -0700
Message-ID: <20120516211355.828CCA0358@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60348 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2EPVN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 17:13:58 -0400
Received: by werf13 with SMTP id f13so61501wer.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 14:13:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, davem@davemloft.net, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, mhocko@suse.cz, tj@kernel.org


The patch titled
     Subject: memcg: always free struct memcg through schedule_work()
has been added to the -mm tree.  Its filename is
     memcg-always-free-struct-memcg-through-schedule_work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: always free struct memcg through schedule_work()

Right now we free struct memcg with kfree right after a rcu grace period,
but defer it if we need to use vfree() to get rid of that memory area.  We
do that by need, because we need vfree to be called in a process context.

This patch unifies this behavior, by ensuring that even kfree will happen
in a separate thread.  The goal is to have a stable place to call the
upcoming jump label destruction function outside the realm of the
complicated and quite far-reaching cgroup lock (that can't be held when
holding either the cpu_hotplug.lock or jump_label_mutex)

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~memcg-always-free-struct-memcg-through-schedule_work mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-always-free-struct-memcg-through-schedule_work
+++ a/mm/memcontrol.c
@@ -270,8 +270,8 @@ struct mem_cgroup {
 		 */
 		struct rcu_head rcu_freeing;
 		/*
-		 * But when using vfree(), that cannot be done at
-		 * interrupt time, so we must then queue the work.
+		 * We also need some space for a worker in deferred freeing.
+		 * By the time we call it, rcu_freeing is not longer in use.
 		 */
 		struct work_struct work_freeing;
 	};
@@ -4924,23 +4924,28 @@ out_free:
 }
 
 /*
- * Helpers for freeing a vzalloc()ed mem_cgroup by RCU,
+ * Helpers for freeing a kmalloc()ed/vzalloc()ed mem_cgroup by RCU,
  * but in process context.  The work_freeing structure is overlaid
  * on the rcu_freeing structure, which itself is overlaid on memsw.
  */
-static void vfree_work(struct work_struct *work)
+static void free_work(struct work_struct *work)
 {
 	struct mem_cgroup *memcg;
+	int size = sizeof(struct mem_cgroup);
 
 	memcg = container_of(work, struct mem_cgroup, work_freeing);
-	vfree(memcg);
+	if (size < PAGE_SIZE)
+		kfree(memcg);
+	else
+		vfree(memcg);
 }
-static void vfree_rcu(struct rcu_head *rcu_head)
+
+static void free_rcu(struct rcu_head *rcu_head)
 {
 	struct mem_cgroup *memcg;
 
 	memcg = container_of(rcu_head, struct mem_cgroup, rcu_freeing);
-	INIT_WORK(&memcg->work_freeing, vfree_work);
+	INIT_WORK(&memcg->work_freeing, free_work);
 	schedule_work(&memcg->work_freeing);
 }
 
@@ -4966,10 +4971,7 @@ static void __mem_cgroup_free(struct mem
 		free_mem_cgroup_per_zone_info(memcg, node);
 
 	free_percpu(memcg->stat);
-	if (sizeof(struct mem_cgroup) < PAGE_SIZE)
-		kfree_rcu(memcg, rcu_freeing);
-	else
-		call_rcu(&memcg->rcu_freeing, vfree_rcu);
+	call_rcu(&memcg->rcu_freeing, free_rcu);
 }
 
 static void mem_cgroup_get(struct mem_cgroup *memcg)
_
Subject: Subject: memcg: always free struct memcg through schedule_work()

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
rescounters-add-res_counter_uncharge_until.patch
memcg-use-res_counter_uncharge_until-in-move_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch
memcg-dont-uncharge-in-mem_cgroup_move_account.patch
remove-__must_check-for-res_counter_charge_nofail.patch
memcg-always-free-struct-memcg-through-schedule_work.patch
memcg-always-free-struct-memcg-through-schedule_work-fix.patch
memcg-decrement-static-keys-at-real-destroy-time.patch
memcg-decrement-static-keys-at-real-destroy-time-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

