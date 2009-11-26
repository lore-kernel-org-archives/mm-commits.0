From: akpm@linux-foundation.org
Subject: + memcg-avoid-oom-killing-innocent-task-in-case-of-use_hierarchy.patch added to -mm tree
Date: Wed, 25 Nov 2009 16:45:21 -0800
Message-ID: <200911260045.nAQ0jLU8015479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965084AbZKZApa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 19:45:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com


The patch titled
     memcg: avoid oom-killing innocent task in case of use_hierarchy
has been added to the -mm tree.  Its filename is
     memcg-avoid-oom-killing-innocent-task-in-case-of-use_hierarchy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: avoid oom-killing innocent task in case of use_hierarchy
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

task_in_mem_cgroup(), which is called by select_bad_process() to check
whether a task can be a candidate for being oom-killed from memcg's limit,
checks "curr->use_hierarchy"("curr" is the mem_cgroup the task belongs
to).

But this check return true(it's false positive) when:

	<some path>/aa		use_hierarchy == 0	<- hitting limit
	  <some path>/aa/00	use_hierarchy == 1	<- the task belongs to

This leads to killing an innocent task in aa/00.  This patch is a fix for
this bug.  And this patch also fixes the arg for
mem_cgroup_print_oom_info().  We should print information of mem_cgroup
which the task being killed, not current, belongs to.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 ++++++++--
 mm/oom_kill.c   |   13 +++++++------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-avoid-oom-killing-innocent-task-in-case-of-use_hierarchy mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-oom-killing-innocent-task-in-case-of-use_hierarchy
+++ a/mm/memcontrol.c
@@ -760,7 +760,13 @@ int task_in_mem_cgroup(struct task_struc
 	task_unlock(task);
 	if (!curr)
 		return 0;
-	if (curr->use_hierarchy)
+	/*
+	 * We should check use_hierarchy of "mem" not "curr". Because checking
+	 * use_hierarchy of "curr" here make this function true if hierarchy is
+	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
+	 * hierarchy(even if use_hierarchy is disabled in "mem").
+	 */
+	if (mem->use_hierarchy)
 		ret = css_is_ancestor(&curr->css, &mem->css);
 	else
 		ret = (curr == mem);
@@ -1009,7 +1015,7 @@ void mem_cgroup_print_oom_info(struct me
 	static char memcg_name[PATH_MAX];
 	int ret;
 
-	if (!memcg)
+	if (!memcg || !p)
 		return;
 
 
diff -puN mm/oom_kill.c~memcg-avoid-oom-killing-innocent-task-in-case-of-use_hierarchy mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-avoid-oom-killing-innocent-task-in-case-of-use_hierarchy
+++ a/mm/oom_kill.c
@@ -356,7 +356,8 @@ static void dump_tasks(const struct mem_
 	} while_each_thread(g, p);
 }
 
-static void dump_header(gfp_t gfp_mask, int order, struct mem_cgroup *mem)
+static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
+							struct mem_cgroup *mem)
 {
 	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
 		"oom_adj=%d\n",
@@ -365,7 +366,7 @@ static void dump_header(gfp_t gfp_mask, 
 	cpuset_print_task_mems_allowed(current);
 	task_unlock(current);
 	dump_stack();
-	mem_cgroup_print_oom_info(mem, current);
+	mem_cgroup_print_oom_info(mem, p);
 	show_mem();
 	if (sysctl_oom_dump_tasks)
 		dump_tasks(mem);
@@ -440,7 +441,7 @@ static int oom_kill_process(struct task_
 	struct task_struct *c;
 
 	if (printk_ratelimit())
-		dump_header(gfp_mask, order, mem);
+		dump_header(p, gfp_mask, order, mem);
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -576,7 +577,7 @@ retry:
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
 		read_unlock(&tasklist_lock);
-		dump_header(gfp_mask, order, NULL);
+		dump_header(NULL, gfp_mask, order, NULL);
 		panic("Out of memory and no killable processes...\n");
 	}
 
@@ -644,7 +645,7 @@ void out_of_memory(struct zonelist *zone
 		return;
 
 	if (sysctl_panic_on_oom == 2) {
-		dump_header(gfp_mask, order, NULL);
+		dump_header(NULL, gfp_mask, order, NULL);
 		panic("out of memory. Compulsory panic_on_oom is selected.\n");
 	}
 
@@ -663,7 +664,7 @@ void out_of_memory(struct zonelist *zone
 
 	case CONSTRAINT_NONE:
 		if (sysctl_panic_on_oom) {
-			dump_header(gfp_mask, order, NULL);
+			dump_header(NULL, gfp_mask, order, NULL);
 			panic("out of memory. panic_on_oom is selected\n");
 		}
 		/* Fall-through */
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
memcg-coalesce-uncharge-during-unmap-truncate.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-coalesce-charging-via-percpu-storage-fix-2.patch
memcg-make-memcgs-file-mapped-consistent-with-global-vm.patch
memcg-add-mem_cgroup_cancel_charge.patch
memcg-cleanup-mem_cgroup_move_parent.patch
memcg-avoid-oom-killing-innocent-task-in-case-of-use_hierarchy.patch
memcg-remove-memcg_tasklist.patch

