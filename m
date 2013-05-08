From: akpm@linux-foundation.org
Subject: + mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch added to -mm tree
Date: Wed, 08 May 2013 14:09:35 -0700
Message-ID: <20130508210935.77C995A404E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:55448 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3EHVJi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 17:09:38 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so225724qen.2
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 14:09:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm, memcg: don't take task_lock in task_in_mem_cgroup
has been added to the -mm tree.  Its filename is
     mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1450,11 +1450,12 @@ static bool mem_cgroup_same_or_subtree(c
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
@@ -1466,14 +1467,14 @@ int task_in_mem_cgroup(struct task_struc
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
mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

