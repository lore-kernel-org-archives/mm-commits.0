From: akpm@linux-foundation.org
Subject: [merged] memcg-always-free-struct-memcg-through-schedule_work.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:14 -0700
Message-ID: <20120531191814.7CAF3A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56583 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab2EaTSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:16 -0400
Received: by mail-ee0-f74.google.com with SMTP id t10so76371eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, davem@davemloft.net, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: always free struct memcg through schedule_work()
has been removed from the -mm tree.  Its filename was
     memcg-always-free-struct-memcg-through-schedule_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

[akpm@linux-foundation.org: tweak comment]
Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~memcg-always-free-struct-memcg-through-schedule_work mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-always-free-struct-memcg-through-schedule_work
+++ a/mm/memcontrol.c
@@ -258,8 +258,8 @@ struct mem_cgroup {
 		 */
 		struct rcu_head rcu_freeing;
 		/*
-		 * But when using vfree(), that cannot be done at
-		 * interrupt time, so we must then queue the work.
+		 * We also need some space for a worker in deferred freeing.
+		 * By the time we call it, rcu_freeing is no longer in use.
 		 */
 		struct work_struct work_freeing;
 	};
@@ -4702,23 +4702,28 @@ out_free:
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
 
@@ -4744,10 +4749,7 @@ static void __mem_cgroup_free(struct mem
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

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
slab-move-full-state-transition-to-an-initcall.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

