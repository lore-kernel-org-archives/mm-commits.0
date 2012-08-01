From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-move-all-oom-handling-to-memcontrolc.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:20 -0700
Message-ID: <20120801201520.C3CB61E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2HAUPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:22 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: move all oom handling to memcontrol.c
has been removed from the -mm tree.  Its filename was
     mm-memcg-move-all-oom-handling-to-memcontrolc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: move all oom handling to memcontrol.c

By globally defining check_panic_on_oom(), the memcg oom handler can be
moved entirely to mm/memcontrol.c.  This removes the ugly #ifdef in the
oom killer and cleans up the code.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 include/linux/oom.h        |    3 +++
 mm/memcontrol.c            |   15 +++++++++++++--
 mm/oom_kill.c              |   23 ++---------------------
 4 files changed, 18 insertions(+), 25 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-move-all-oom-handling-to-memcontrolc include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-move-all-oom-handling-to-memcontrolc
+++ a/include/linux/memcontrol.h
@@ -180,8 +180,6 @@ static inline void mem_cgroup_dec_page_s
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
-extern void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				       int order);
 
 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff -puN include/linux/oom.h~mm-memcg-move-all-oom-handling-to-memcontrolc include/linux/oom.h
--- a/include/linux/oom.h~mm-memcg-move-all-oom-handling-to-memcontrolc
+++ a/include/linux/oom.h
@@ -61,6 +61,9 @@ extern void oom_kill_process(struct task
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
+extern void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
+			       int order, const nodemask_t *nodemask);
+
 extern enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill);
diff -puN mm/memcontrol.c~mm-memcg-move-all-oom-handling-to-memcontrolc mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-move-all-oom-handling-to-memcontrolc
+++ a/mm/memcontrol.c
@@ -1469,8 +1469,8 @@ static u64 mem_cgroup_get_limit(struct m
 	return min(limit, memsw);
 }
 
-void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				int order)
+void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+			      int order)
 {
 	struct mem_cgroup *iter;
 	unsigned long chosen_points = 0;
@@ -1478,6 +1478,17 @@ void __mem_cgroup_out_of_memory(struct m
 	unsigned int points = 0;
 	struct task_struct *chosen = NULL;
 
+	/*
+	 * If current has a pending SIGKILL, then automatically select it.  The
+	 * goal is to allow it to allocate so that it may quickly exit and free
+	 * its memory.
+	 */
+	if (fatal_signal_pending(current)) {
+		set_thread_flag(TIF_MEMDIE);
+		return;
+	}
+
+	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
 	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct cgroup *cgroup = iter->css.cgroup;
diff -puN mm/oom_kill.c~mm-memcg-move-all-oom-handling-to-memcontrolc mm/oom_kill.c
--- a/mm/oom_kill.c~mm-memcg-move-all-oom-handling-to-memcontrolc
+++ a/mm/oom_kill.c
@@ -556,8 +556,8 @@ void oom_kill_process(struct task_struct
 /*
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
-static void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
-				int order, const nodemask_t *nodemask)
+void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
+			int order, const nodemask_t *nodemask)
 {
 	if (likely(!sysctl_panic_on_oom))
 		return;
@@ -575,25 +575,6 @@ static void check_panic_on_oom(enum oom_
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
 }
 
-#ifdef CONFIG_MEMCG
-void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-			      int order)
-{
-	/*
-	 * If current has a pending SIGKILL, then automatically select it.  The
-	 * goal is to allow it to allocate so that it may quickly exit and free
-	 * its memory.
-	 */
-	if (fatal_signal_pending(current)) {
-		set_thread_flag(TIF_MEMDIE);
-		return;
-	}
-
-	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
-	__mem_cgroup_out_of_memory(memcg, gfp_mask, order);
-}
-#endif
