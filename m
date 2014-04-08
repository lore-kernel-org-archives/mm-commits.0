From: akpm@linux-foundation.org
Subject: [merged] memcg-get_mem_cgroup_from_mm.patch removed from -mm tree
Date: Tue, 08 Apr 2014 13:52:41 -0700
Message-ID: <53446199.D9jDLqFecVDvAYOg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264AbaDHUwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:52:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, fengguang.wu@intel.com, hannes@cmpxchg.org

Subject: [merged] memcg-get_mem_cgroup_from_mm.patch removed from -mm tree
To: hannes@cmpxchg.org,fengguang.wu@intel.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:52:41 -0700


The patch titled
     Subject: memcg: get_mem_cgroup_from_mm()
has been removed from the -mm tree.  Its filename was
     memcg-get_mem_cgroup_from_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: memcg: get_mem_cgroup_from_mm()

Instead of returning NULL from try_get_mem_cgroup_from_mm() when the mm
owner is exiting, just return root_mem_cgroup.  This makes sense for all
callsites and gets rid of some of them having to fallback manually.

[fengguang.wu@intel.com: fix warnings]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ------
 mm/memcontrol.c            |   18 ++++--------------
 2 files changed, 4 insertions(+), 20 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-get_mem_cgroup_from_mm include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-get_mem_cgroup_from_mm
+++ a/include/linux/memcontrol.h
@@ -94,7 +94,6 @@ bool task_in_mem_cgroup(struct task_stru
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
-extern struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm);
 
 extern struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
 extern struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css);
@@ -293,11 +292,6 @@ static inline struct mem_cgroup *try_get
 {
 	return NULL;
 }
-
-static inline struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
-{
-	return NULL;
-}
 
 static inline bool mm_match_cgroup(struct mm_struct *mm,
 		struct mem_cgroup *memcg)
diff -puN mm/memcontrol.c~memcg-get_mem_cgroup_from_mm mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-get_mem_cgroup_from_mm
+++ a/mm/memcontrol.c
@@ -1071,7 +1071,7 @@ struct mem_cgroup *mem_cgroup_from_task(
 	return mem_cgroup_from_css(task_css(p, memory_cgrp_id));
 }
 
-struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
+static struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *memcg = NULL;
 
@@ -1079,7 +1079,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	do {
 		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 		if (unlikely(!memcg))
-			break;
+			memcg = root_mem_cgroup;
 	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
@@ -1475,7 +1475,7 @@ bool task_in_mem_cgroup(struct task_stru
 
 	p = find_lock_task_mm(task);
 	if (p) {
-		curr = try_get_mem_cgroup_from_mm(p->mm);
+		curr = get_mem_cgroup_from_mm(p->mm);
 		task_unlock(p);
 	} else {
 		/*
@@ -1489,8 +1489,6 @@ bool task_in_mem_cgroup(struct task_stru
 			css_get(&curr->css);
 		rcu_read_unlock();
 	}
-	if (!curr)
-		return false;
 	/*
 	 * We should check use_hierarchy of "memcg" not "curr". Because checking
 	 * use_hierarchy of "curr" here make this function true if hierarchy is
@@ -3617,15 +3615,7 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
 	if (!current->mm || current->memcg_kmem_skip_account)
 		return true;
 
-	memcg = try_get_mem_cgroup_from_mm(current->mm);
