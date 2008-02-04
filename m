From: akpm@linux-foundation.org
Subject: + hotplug-cpu-move-tasks-in-empty-cpusets-refinements.patch added to -mm tree
Date: Mon, 04 Feb 2008 13:58:26 -0800
Message-ID: <200802042158.m14LwQw4019606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119AbYBDV6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 16:58:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, cpw@sgi.com, menage@google.com, rientjes@google.com


The patch titled
     hotplug cpu move tasks in empty cpusets - refinements
has been added to the -mm tree.  Its filename is
     hotplug-cpu-move-tasks-in-empty-cpusets-refinements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hotplug cpu move tasks in empty cpusets - refinements
From: Paul Jackson <pj@sgi.com>

- Narrow the scope of callback_mutex in scan_for_empty_cpusets().

- Avoid rewriting the cpus, mems of cpusets except when it is likely that
  we'll be changing them.

- Have remove_tasks_in_empty_cpuset() also check for empty mems.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Cliff Wickman <cpw@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN kernel/cpuset.c~hotplug-cpu-move-tasks-in-empty-cpusets-refinements kernel/cpuset.c
--- a/kernel/cpuset.c~hotplug-cpu-move-tasks-in-empty-cpusets-refinements
+++ a/kernel/cpuset.c
@@ -1709,7 +1709,8 @@ static void remove_tasks_in_empty_cpuset
 	 * has online cpus, so can't be empty).
 	 */
 	parent = cs->parent;
-	while (cpus_empty(parent->cpus_allowed))
+	while (cpus_empty(parent->cpus_allowed) ||
+			nodes_empty(parent->mems_allowed))
 		parent = parent->parent;
 
 	move_member_tasks_to_cpuset(cs, parent);
@@ -1741,7 +1742,6 @@ static void scan_for_empty_cpusets(const
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
-	mutex_lock(&callback_mutex);
 	while (!list_empty(&queue)) {
 		cp = container_of(queue.next, struct cpuset, stack_list);
 		list_del(queue.next);
@@ -1750,19 +1750,24 @@ static void scan_for_empty_cpusets(const
 			list_add_tail(&child->stack_list, &queue);
 		}
 		cont = cp->css.cgroup;
+
+		/* Continue past cpusets with all cpus, mems online */
+		if (cpus_subset(cp->cpus_allowed, cpu_online_map) &&
+		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
+			continue;
+
 		/* Remove offline cpus and mems from this cpuset. */
+		mutex_lock(&callback_mutex);
 		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
 		nodes_and(cp->mems_allowed, cp->mems_allowed,
 						node_states[N_HIGH_MEMORY]);
+		mutex_unlock(&callback_mutex);
+
+		/* Move tasks from the empty cpuset to a parent */
 		if (cpus_empty(cp->cpus_allowed) ||
-		     nodes_empty(cp->mems_allowed)) {
-			/* Move tasks from the empty cpuset to a parent */
-			mutex_unlock(&callback_mutex);
+		     nodes_empty(cp->mems_allowed))
 			remove_tasks_in_empty_cpuset(cp);
-			mutex_lock(&callback_mutex);
-		}
 	}
-	mutex_unlock(&callback_mutex);
 }
 
 /*
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
kernel-cgroupc-remove-dead-code.patch
cgroup-brace-coding-style-fix.patch
cgroup-simplify-space-stripping.patch
cgroup-simplify-space-stripping-fix.patch
cgroups-move-cgroups-destroy-callbacks-to-cgroup_diput.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-node_online_map-fix.patch
cpusets-update_cpumask-revision.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
cgroups-update-comments-in-cpusetc.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-various-other-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-refinements.patch
cpusets-update_cpumask-documentation-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
