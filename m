From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:10 -0700
Message-ID: <20120801201511.4F996200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:65135 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2HAUPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:13 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so342543wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, handai.szj@taobao.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: introduce own oom handler to iterate only over its own threads
has been removed from the -mm tree.  Its filename was
     mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: introduce own oom handler to iterate only over its own threads

The global oom killer is serialized by the per-zonelist
try_set_zonelist_oom() which is used in the page allocator.  Concurrent
oom kills are thus a rare event and only occur in systems using
mempolicies and with a large number of nodes.

Memory controller oom kills, however, can frequently be concurrent since
there is no serialization once the oom killer is called for oom conditions
in several different memcgs in parallel.

This creates a massive contention on tasklist_lock since the oom killer
requires the readside for the tasklist iteration.  If several memcgs are
calling the oom killer, this lock can be held for a substantial amount of
time, especially if threads continue to enter it as other threads are
exiting.

Since the exit path grabs the writeside of the lock with irqs disabled in
a few different places, this can cause a soft lockup on cpus as a result
of tasklist_lock starvation.

The kernel lacks unfair writelocks, and successful calls to the oom killer
usually result in at least one thread entering the exit path, so an
alternative solution is needed.

This patch introduces a seperate oom handler for memcgs so that they do
not require tasklist_lock for as much time.  Instead, it iterates only
over the threads attached to the oom memcg and grabs a reference to the
selected thread before calling oom_kill_process() to ensure it doesn't
prematurely exit.

This still requires tasklist_lock for the tasklist dump, iterating
children of the selected process, and killing all other threads on the
system sharing the same memory as the selected victim.  So while this
isn't a complete solution to tasklist_lock starvation, it significantly
reduces the amount of time that it is held.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 +----
 include/linux/oom.h        |   16 +++++++++
 mm/memcontrol.c            |   61 ++++++++++++++++++++++++++++++++++-
 mm/oom_kill.c              |   48 ++++++++-------------------
 4 files changed, 93 insertions(+), 41 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads
+++ a/include/linux/memcontrol.h
@@ -180,7 +180,8 @@ static inline void mem_cgroup_dec_page_s
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
-u64 mem_cgroup_get_limit(struct mem_cgroup *memcg);
+extern void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+				       int order);
 
 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -364,12 +365,6 @@ unsigned long mem_cgroup_soft_limit_recl
 	return 0;
 }
 
-static inline
-u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
-{
-	return 0;
-}
-
 static inline void mem_cgroup_split_huge_fixup(struct page *head)
 {
 }
diff -puN include/linux/oom.h~mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads include/linux/oom.h
--- a/include/linux/oom.h~mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads
+++ a/include/linux/oom.h
@@ -40,17 +40,33 @@ enum oom_constraint {
 	CONSTRAINT_MEMCG,
 };
 
+enum oom_scan_t {
+	OOM_SCAN_OK,		/* scan thread and find its badness */
+	OOM_SCAN_CONTINUE,	/* do not consider thread for oom kill */
+	OOM_SCAN_ABORT,		/* abort the iteration and return */
+	OOM_SCAN_SELECT,	/* always select this thread first */
+};
+
 extern void compare_swap_oom_score_adj(int old_val, int new_val);
 extern int test_set_oom_score_adj(int new_val);
 
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
 		unsigned long totalpages);
+extern void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
+			     unsigned int points, unsigned long totalpages,
+			     struct mem_cgroup *memcg, nodemask_t *nodemask,
+			     const char *message);
+
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
+extern enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
+		unsigned long totalpages, const nodemask_t *nodemask,
+		bool force_kill);
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				     int order);
+
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *mask, bool force_kill);
 extern int register_oom_notifier(struct notifier_block *nb);
diff -puN mm/memcontrol.c~mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads
+++ a/mm/memcontrol.c
@@ -1453,7 +1453,7 @@ static int mem_cgroup_count_children(str
 /*
  * Return the memory (and swap, if configured) limit for a memcg.
  */
-u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
+static u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
 {
 	u64 limit;
 	u64 memsw;
@@ -1469,6 +1469,65 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 	return min(limit, memsw);
 }
 
+void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+				int order)
+{
+	struct mem_cgroup *iter;
+	unsigned long chosen_points = 0;
+	unsigned long totalpages;
+	unsigned int points = 0;
+	struct task_struct *chosen = NULL;
+
+	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
+	for_each_mem_cgroup_tree(iter, memcg) {
+		struct cgroup *cgroup = iter->css.cgroup;
+		struct cgroup_iter it;
+		struct task_struct *task;
+
+		cgroup_iter_start(cgroup, &it);
+		while ((task = cgroup_iter_next(cgroup, &it))) {
+			switch (oom_scan_process_thread(task, totalpages, NULL,
+							false)) {
+			case OOM_SCAN_SELECT:
+				if (chosen)
+					put_task_struct(chosen);
+				chosen = task;
+				chosen_points = ULONG_MAX;
+				get_task_struct(chosen);
+				/* fall through */
+			case OOM_SCAN_CONTINUE:
+				continue;
+			case OOM_SCAN_ABORT:
+				cgroup_iter_end(cgroup, &it);
+				mem_cgroup_iter_break(memcg, iter);
+				if (chosen)
+					put_task_struct(chosen);
+				return;
+			case OOM_SCAN_OK:
+				break;
+			};
+			points = oom_badness(task, memcg, NULL, totalpages);
+			if (points > chosen_points) {
+				if (chosen)
+					put_task_struct(chosen);
+				chosen = task;
+				chosen_points = points;
+				get_task_struct(chosen);
+			}
+		}
+		cgroup_iter_end(cgroup, &it);
+	}
+
+	if (!chosen)
+		return;
+	points = chosen_points * 1000 / totalpages;
+	read_lock(&tasklist_lock);
+	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
+			 NULL, "Memory cgroup out of memory");
+	read_unlock(&tasklist_lock);
+	put_task_struct(chosen);
+}
+
 static unsigned long mem_cgroup_reclaim(struct mem_cgroup *memcg,
 					gfp_t gfp_mask,
 					unsigned long flags)
diff -puN mm/oom_kill.c~mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads mm/oom_kill.c
--- a/mm/oom_kill.c~mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads
+++ a/mm/oom_kill.c
@@ -288,20 +288,13 @@ static enum oom_constraint constrained_a
 }
 #endif
 
-enum oom_scan_t {
-	OOM_SCAN_OK,		/* scan thread and find its badness */
-	OOM_SCAN_CONTINUE,	/* do not consider thread for oom kill */
-	OOM_SCAN_ABORT,		/* abort the iteration and return */
-	OOM_SCAN_SELECT,	/* always select this thread first */
-};
-
-static enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
-		struct mem_cgroup *memcg, unsigned long totalpages,
-		const nodemask_t *nodemask, bool force_kill)
+enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
+		unsigned long totalpages, const nodemask_t *nodemask,
+		bool force_kill)
 {
 	if (task->exit_state)
 		return OOM_SCAN_CONTINUE;
-	if (oom_unkillable_task(task, memcg, nodemask))
+	if (oom_unkillable_task(task, NULL, nodemask))
 		return OOM_SCAN_CONTINUE;
 
 	/*
@@ -348,8 +341,8 @@ static enum oom_scan_t oom_scan_process_
  * (not docbooked, we don't want this one cluttering up the manual)
  */
 static struct task_struct *select_bad_process(unsigned int *ppoints,
-		unsigned long totalpages, struct mem_cgroup *memcg,
-		const nodemask_t *nodemask, bool force_kill)
+		unsigned long totalpages, const nodemask_t *nodemask,
+		bool force_kill)
 {
 	struct task_struct *g, *p;
 	struct task_struct *chosen = NULL;
@@ -358,7 +351,7 @@ static struct task_struct *select_bad_pr
 	do_each_thread(g, p) {
 		unsigned int points;
 
-		switch (oom_scan_process_thread(p, memcg, totalpages, nodemask,
+		switch (oom_scan_process_thread(p, totalpages, nodemask,
 						force_kill)) {
 		case OOM_SCAN_SELECT:
 			chosen = p;
@@ -371,7 +364,7 @@ static struct task_struct *select_bad_pr
 		case OOM_SCAN_OK:
 			break;
 		};
-		points = oom_badness(p, memcg, nodemask, totalpages);
+		points = oom_badness(p, NULL, nodemask, totalpages);
 		if (points > chosen_points) {
 			chosen = p;
 			chosen_points = points;
@@ -443,10 +436,10 @@ static void dump_header(struct task_stru
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
-static void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
-			     unsigned int points, unsigned long totalpages,
-			     struct mem_cgroup *memcg, nodemask_t *nodemask,
-			     const char *message)
+void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
+		      unsigned int points, unsigned long totalpages,
+		      struct mem_cgroup *memcg, nodemask_t *nodemask,
+		      const char *message)
 {
 	struct task_struct *victim = p;
 	struct task_struct *child;
@@ -564,10 +557,6 @@ static void check_panic_on_oom(enum oom_
 void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			      int order)
 {
-	unsigned long limit;
-	unsigned int points = 0;
-	struct task_struct *p;
-
 	/*
 	 * If current has a pending SIGKILL, then automatically select it.  The
 	 * goal is to allow it to allocate so that it may quickly exit and free
@@ -579,13 +568,7 @@ void mem_cgroup_out_of_memory(struct mem
 	}
 
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
-	limit = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
-	read_lock(&tasklist_lock);
-	p = select_bad_process(&points, limit, memcg, NULL, false);
-	if (p && PTR_ERR(p) != -1UL)
-		oom_kill_process(p, gfp_mask, order, points, limit, memcg, NULL,
-				 "Memory cgroup out of memory");
-	read_unlock(&tasklist_lock);
+	__mem_cgroup_out_of_memory(memcg, gfp_mask, order);
 }
 #endif
 
@@ -710,7 +693,7 @@ void out_of_memory(struct zonelist *zone
 	struct task_struct *p;
 	unsigned long totalpages;
 	unsigned long freed = 0;
-	unsigned int points;
+	unsigned int uninitialized_var(points);
 	enum oom_constraint constraint = CONSTRAINT_NONE;
 	int killed = 0;
 
@@ -748,8 +731,7 @@ void out_of_memory(struct zonelist *zone
 		goto out;
 	}
 
-	p = select_bad_process(&points, totalpages, NULL, mpol_mask,
-			       force_kill);
+	p = select_bad_process(&points, totalpages, mpol_mask, force_kill);
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
 		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
slab-do-not-call-compound_head-in-page_get_cache.patch

