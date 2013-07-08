From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:59 -0700
Message-ID: <51db11cf.xZW3A4AbjOGdqlee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3GHTYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, rientjes@google.com

Subject: [merged] mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch removed from -mm tree
To: rientjes@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:59 -0700


The patch titled
     Subject: mm, memcg: don't take task_lock in task_in_mem_cgroup
has been removed from the -mm tree.  Its filename was
     mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: don't take task_lock in task_in_mem_cgroup

For processes that have detached their mm's, task_in_mem_cgroup()
unnecessarily takes task_lock() when rcu_read_lock() is all that is
necessary to call mem_cgroup_from_task().

While we're here, switch task_in_mem_cgroup() to return bool.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 +++++----
 mm/memcontrol.c            |   11 ++++++-----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup
+++ a/include/linux/memcontrol.h
@@ -77,7 +77,8 @@ extern void mem_cgroup_uncharge_cache_pa
 
 bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
 				  struct mem_cgroup *memcg);
-int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *memcg);
+bool task_in_mem_cgroup(struct task_struct *task,
+			const struct mem_cgroup *memcg);
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
@@ -273,10 +274,10 @@ static inline bool mm_match_cgroup(struc
 	return true;
 }
 
-static inline int task_in_mem_cgroup(struct task_struct *task,
-				     const struct mem_cgroup *memcg)
+static inline bool task_in_mem_cgroup(struct task_struct *task,
+				      const struct mem_cgroup *memcg)
 {
-	return 1;
+	return true;
 }
 
 static inline struct cgroup_subsys_state
diff -puN mm/memcontrol.c~mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup
+++ a/mm/memcontrol.c
@@ -1448,11 +1448,12 @@ static bool mem_cgroup_same_or_subtree(c
 	return ret;
 }
 
-int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *memcg)
+bool task_in_mem_cgroup(struct task_struct *task,
+			const struct mem_cgroup *memcg)
 {
-	int ret;
 	struct mem_cgroup *curr = NULL;
 	struct task_struct *p;
+	bool ret;
 
 	p = find_lock_task_mm(task);
 	if (p) {
@@ -1464,14 +1465,14 @@ int task_in_mem_cgroup(struct task_struc
 		 * killer still needs to detect if they have already been oom
 		 * killed to prevent needlessly killing additional tasks.
 		 */
-		task_lock(task);
+		rcu_read_lock();
 		curr = mem_cgroup_from_task(task);
 		if (curr)
 			css_get(&curr->css);
-		task_unlock(task);
+		rcu_read_unlock();
 	}
 	if (!curr)
-		return 0;
+		return false;
 	/*
 	 * We should check use_hierarchy of "memcg" not "curr". Because checking
 	 * use_hierarchy of "curr" here make this function true if hierarchy is
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
mm-mremap-validate-input-before-taking-lock.patch
memcg-clean-up-memcg-nodeinfo.patch
mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch
mm-remove-zone_type-argument-of-build_zonelists_node.patch
mm-remove-unlikely-from-the-current_order-test.patch
mm-sparsec-put-clear_hwpoisoned_pages-within-config_memory_hotremove.patch
mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

