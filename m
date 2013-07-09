From: akpm@linux-foundation.org
Subject: [merged] memcg-dont-need-to-free-memcg-via-rcu-or-workqueue.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:49 -0700
Message-ID: <51dc9ad1.J3q3AV+XBXek6bT/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3GIXUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, glommer@openvz.org, lizefan@huawei.com

Subject: [merged] memcg-dont-need-to-free-memcg-via-rcu-or-workqueue.patch removed from -mm tree
To: lizefan@huawei.com,glommer@openvz.org,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:49 -0700


The patch titled
     Subject: memcg: don't need to free memcg via RCU or workqueue
has been removed from the -mm tree.  Its filename was
     memcg-dont-need-to-free-memcg-via-rcu-or-workqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: don't need to free memcg via RCU or workqueue

Now memcg has the same life cycle with its corresponding cgroup, and a
cgroup is freed via RCU and then mem_cgroup_css_free() will be called in a
work function, so we can simply call __mem_cgroup_free() in
mem_cgroup_css_free().

This actually reverts 59927fb984d ("memcg: free mem_cgroup by RCU to fix
oops").

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   51 ++++------------------------------------------
 1 file changed, 5 insertions(+), 46 deletions(-)

diff -puN mm/memcontrol.c~memcg-dont-need-to-free-memcg-via-rcu-or-workqueue mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-dont-need-to-free-memcg-via-rcu-or-workqueue
+++ a/mm/memcontrol.c
@@ -263,28 +263,10 @@ struct mem_cgroup {
 	/* vmpressure notifications */
 	struct vmpressure vmpressure;
 
-	union {
-		/*
-		 * the counter to account for mem+swap usage.
-		 */
-		struct res_counter memsw;
-
-		/*
-		 * rcu_freeing is used only when freeing struct mem_cgroup,
-		 * so put it into a union to avoid wasting more memory.
-		 * It must be disjoint from the css field.  It could be
-		 * in a union with the res field, but res plays a much
-		 * larger part in mem_cgroup life than memsw, and might
-		 * be of interest, even at time of free, when debugging.
-		 * So share rcu_head with the less interesting memsw.
-		 */
-		struct rcu_head rcu_freeing;
-		/*
-		 * We also need some space for a worker in deferred freeing.
-		 * By the time we call it, rcu_freeing is no longer in use.
-		 */
-		struct work_struct work_freeing;
-	};
+	/*
+	 * the counter to account for mem+swap usage.
+	 */
+	struct res_counter memsw;
 
 	/*
 	 * the counter to account for kernel memory usage.
@@ -6211,29 +6193,6 @@ static void __mem_cgroup_free(struct mem
 		vfree(memcg);
 }
 
-
-/*
- * Helpers for freeing a kmalloc()ed/vzalloc()ed mem_cgroup by RCU,
- * but in process context.  The work_freeing structure is overlaid
- * on the rcu_freeing structure, which itself is overlaid on memsw.
- */
-static void free_work(struct work_struct *work)
-{
-	struct mem_cgroup *memcg;
-
-	memcg = container_of(work, struct mem_cgroup, work_freeing);
-	__mem_cgroup_free(memcg);
-}
-
-static void free_rcu(struct rcu_head *rcu_head)
-{
-	struct mem_cgroup *memcg;
-
-	memcg = container_of(rcu_head, struct mem_cgroup, rcu_freeing);
-	INIT_WORK(&memcg->work_freeing, free_work);
-	schedule_work(&memcg->work_freeing);
-}
