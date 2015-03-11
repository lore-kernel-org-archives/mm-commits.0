From: akpm@linux-foundation.org
Subject: +
 memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom.patch added to -mm tree
Date: Wed, 11 Mar 2015 16:24:57 -0700
Message-ID: <5500cec9.Lke+LHvamyXf03w+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbbCKXY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 19:24:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balu252@gmail.com, balasubramani_vivekanandan@mentor.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: print cgroup information when system panics due to panic_on_oom
has been added to the -mm tree.  Its filename is
     memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Balasubramani Vivekanandan <balu252@gmail.com>
Subject: memcg: print cgroup information when system panics due to panic_on_oom

If kernel panics due to oom, caused by a cgroup reaching its limit, when
'compulsory panic_on_oom' is enabled, then we will only see that the OOM
happened because of "compulsory panic_on_oom is enabled" but this doesn't
tell the difference between mempolicy and memcg.  And dumping system wide
information is plain wrong and more confusing.  This patch provides the
information of the cgroup whose limit triggerred panic

Signed-off-by: Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    3 ++-
 mm/memcontrol.c     |   16 +++++++++-------
 mm/oom_kill.c       |    7 ++++---
 3 files changed, 15 insertions(+), 11 deletions(-)

diff -puN include/linux/oom.h~memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom include/linux/oom.h
--- a/include/linux/oom.h~memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom
+++ a/include/linux/oom.h
@@ -66,7 +66,8 @@ extern bool oom_zonelist_trylock(struct
 extern void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_flags);
 
 extern void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
-			       int order, const nodemask_t *nodemask);
+			       int order, const nodemask_t *nodemask,
+			       struct mem_cgroup *memcg);
 
 extern enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
diff -puN mm/memcontrol.c~memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom
+++ a/mm/memcontrol.c
@@ -1442,15 +1442,17 @@ void mem_cgroup_print_oom_info(struct me
 	struct mem_cgroup *iter;
 	unsigned int i;
 
-	if (!p)
-		return;
-
 	mutex_lock(&oom_info_lock);
 	rcu_read_lock();
 
-	pr_info("Task in ");
-	pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
-	pr_cont(" killed as a result of limit of ");
+	if (p) {
+		pr_info("Task in ");
+		pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
+		pr_cont(" killed as a result of limit of ");
+	} else {
+		pr_info("Memory limit reached of cgroup ");
+	}
+
 	pr_cont_cgroup_path(memcg->css.cgroup);
 	pr_cont("\n");
 
@@ -1537,7 +1539,7 @@ static void mem_cgroup_out_of_memory(str
 		return;
 	}
 
-	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
+	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL, memcg);
 	totalpages = mem_cgroup_get_limit(memcg) ? : 1;
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct css_task_iter it;
diff -puN mm/oom_kill.c~memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom
+++ a/mm/oom_kill.c
@@ -612,7 +612,8 @@ void oom_kill_process(struct task_struct
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
 void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
-			int order, const nodemask_t *nodemask)
+			int order, const nodemask_t *nodemask,
+			struct mem_cgroup *memcg)
 {
 	if (likely(!sysctl_panic_on_oom))
 		return;
@@ -625,7 +626,7 @@ void check_panic_on_oom(enum oom_constra
 		if (constraint != CONSTRAINT_NONE)
 			return;
 	}
-	dump_header(NULL, gfp_mask, order, NULL, nodemask);
+	dump_header(NULL, gfp_mask, order, memcg, nodemask);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
 }
@@ -740,7 +741,7 @@ static void __out_of_memory(struct zonel
 	constraint = constrained_alloc(zonelist, gfp_mask, nodemask,
 						&totalpages);
 	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
-	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
+	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask, NULL);
 
 	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
_

Patches currently in -mm which might be from balu252@gmail.com are

memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom.patch

