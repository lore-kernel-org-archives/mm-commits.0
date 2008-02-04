From: akpm@linux-foundation.org
Subject: + hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-node_online_map-fix.patch added to -mm tree
Date: Mon, 04 Feb 2008 13:49:50 -0800
Message-ID: <200802042149.m14LnooV019175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33917 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbYBDVu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 16:50:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cpw@sgi.com, menage@google.com, pj@sgi.com, rientjes@google.com


The patch titled
     hotplug cpu move tasks in empty cpusets to parent node_online_map fix
has been added to the -mm tree.  Its filename is
     hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-node_online_map-fix.patch

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
Subject: hotplug cpu move tasks in empty cpusets to parent node_online_map fix
From: Cliff Wickman <cpw@sgi.com>

As of the October 2007 kernel/cpuset.c patch "Memoryless nodes:
Use N_HIGH_MEMORY for cpusets", cpuset nodes are relative to
the nodes with (HIGH) memory, not relative to all nodes in
node_online_map.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Cliff Wickman <cpw@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-node_online_map-fix kernel/cpuset.c
--- a/kernel/cpuset.c~hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-node_online_map-fix
+++ a/kernel/cpuset.c
@@ -1817,7 +1817,8 @@ static void scan_for_empty_cpusets(const
 		cont = cp->css.cgroup;
 		/* Remove offline cpus and mems from this cpuset. */
 		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
-		nodes_and(cp->mems_allowed, cp->mems_allowed, node_online_map);
+		nodes_and(cp->mems_allowed, cp->mems_allowed,
+						node_states[N_HIGH_MEMORY]);
 		if ((cpus_empty(cp->cpus_allowed) ||
 		     nodes_empty(cp->mems_allowed))) {
 			/* Move tasks from the empty cpuset to a parent */
@@ -1832,8 +1833,8 @@ static void scan_for_empty_cpusets(const
 
 /*
  * The cpus_allowed and mems_allowed nodemasks in the top_cpuset track
- * cpu_online_map and node_online_map.  Force the top cpuset to track
- * whats online after any CPU or memory node hotplug or unplug event.
+ * cpu_online_map and node_states[N_HIGH_MEMORY].  Force the top cpuset to
+ * track what's online after any CPU or memory node hotplug or unplug event.
  *
  * Since there are two callers of this routine, one for CPU hotplug
  * events and one for memory node hotplug events, we could have coded
_

Patches currently in -mm which might be from cpw@sgi.com are

cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-node_online_map-fix.patch
cpusets-update_cpumask-revision.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
