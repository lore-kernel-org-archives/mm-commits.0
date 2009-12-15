From: akpm@linux-foundation.org
Subject: [merged] oom-dump-stack-and-vm-state-when-oom-killer-panics.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:04 -0800
Message-ID: <200912152150.nBFLo4Ed014916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759758AbZLOVuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:50:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     oom: dump stack and VM state when oom killer panics
has been removed from the -mm tree.  Its filename was
     oom-dump-stack-and-vm-state-when-oom-killer-panics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: dump stack and VM state when oom killer panics
From: David Rientjes <rientjes@google.com>

The oom killer header, including information such as the allocation order
and gfp mask, current's cpuset and memory controller, call trace, and VM
state information is currently only shown when the oom killer has selected
a task to kill.

This information is omitted, however, when the oom killer panics either
because of panic_on_oom sysctl settings or when no killable task was
found.  It is still relevant to know crucial pieces of information such as
the allocation order and VM state when diagnosing such issues, especially
at boot.

This patch displays the oom killer header whenever it panics so that bug
reports can include pertinent information to debug the issue, if possible.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff -puN mm/oom_kill.c~oom-dump-stack-and-vm-state-when-oom-killer-panics mm/oom_kill.c
--- a/mm/oom_kill.c~oom-dump-stack-and-vm-state-when-oom-killer-panics
+++ a/mm/oom_kill.c
@@ -337,6 +337,21 @@ static void dump_tasks(const struct mem_
 	} while_each_thread(g, p);
 }
 
+static void dump_header(gfp_t gfp_mask, int order, struct mem_cgroup *mem)
+{
+	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
+		"oom_adj=%d\n",
+		current->comm, gfp_mask, order, current->signal->oom_adj);
+	task_lock(current);
+	cpuset_print_task_mems_allowed(current);
+	task_unlock(current);
+	dump_stack();
+	mem_cgroup_print_oom_info(mem, current);
+	show_mem();
+	if (sysctl_oom_dump_tasks)
+		dump_tasks(mem);
+}
+
 /*
  * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
@@ -395,20 +410,8 @@ static int oom_kill_process(struct task_
 {
 	struct task_struct *c;
 
-	if (printk_ratelimit()) {
-		printk(KERN_WARNING "%s invoked oom-killer: "
-			"gfp_mask=0x%x, order=%d, oom_adj=%d\n",
-			current->comm, gfp_mask, order,
-			current->signal->oom_adj);
-		task_lock(current);
-		cpuset_print_task_mems_allowed(current);
-		task_unlock(current);
-		dump_stack();
-		mem_cgroup_print_oom_info(mem, current);
-		show_mem();
-		if (sysctl_oom_dump_tasks)
-			dump_tasks(mem);
-	}
+	if (printk_ratelimit())
+		dump_header(gfp_mask, order, mem);
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -544,6 +547,7 @@ retry:
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
 		read_unlock(&tasklist_lock);
+		dump_header(gfp_mask, order, NULL);
 		panic("Out of memory and no killable processes...\n");
 	}
 
@@ -609,8 +613,10 @@ void out_of_memory(struct zonelist *zone
 		/* Got some memory back in the last second. */
 		return;
 
-	if (sysctl_panic_on_oom == 2)
+	if (sysctl_panic_on_oom == 2) {
+		dump_header(gfp_mask, order, NULL);
 		panic("out of memory. Compulsory panic_on_oom is selected.\n");
+	}
 
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
@@ -626,8 +632,10 @@ void out_of_memory(struct zonelist *zone
 		break;
 
 	case CONSTRAINT_NONE:
-		if (sysctl_panic_on_oom)
+		if (sysctl_panic_on_oom) {
+			dump_header(gfp_mask, order, NULL);
 			panic("out of memory. panic_on_oom is selected\n");
+		}
 		/* Fall-through */
 	case CONSTRAINT_CPUSET:
 		__out_of_memory(gfp_mask, order);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
acpi-remove-nid_inval.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

