From: akpm@linux-foundation.org
Subject: + cpusets-decrustify-cpuset-mask-update-code.patch added to -mm tree
Date: Wed, 10 Oct 2007 19:28:42 -0700
Message-ID: <200710110228.l9B2SgXr006486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52581 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbXJKC31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 22:29:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, menage@google.com, mingo@elte.hu


The patch titled
     cpusets: decrustify cpuset mask update code
has been added to the -mm tree.  Its filename is
     cpusets-decrustify-cpuset-mask-update-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpusets: decrustify cpuset mask update code
From: Paul Jackson <pj@sgi.com>

Decrustify the kernel/cpuset.c 'cpus' and 'mems' updating code.

Other than subtle improvements in the consistency of identifying
white space at the beginning and end of passed in masks, this
doesn't make any visible difference in behaviour.  But it's
one or two hundred kernel text bytes smaller, and easier to
understand.

Signed-off-by: Paul Jackson <pj@sgi.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   50 ++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff -puN kernel/cpuset.c~cpusets-decrustify-cpuset-mask-update-code kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-decrustify-cpuset-mask-update-code
+++ a/kernel/cpuset.c
@@ -488,6 +488,14 @@ static int validate_change(const struct 
 			return -EINVAL;
 	}
 
+	/* Cpusets with tasks can't have empty cpus_allowed or mems_allowed */
+	if (cgroup_task_count(cur->css.cgroup)) {
+		if (cpus_empty(trial->cpus_allowed) ||
+	    	    nodes_empty(trial->mems_allowed)) {
+			return -ENOSPC;
+		}
+	}
+
 	return 0;
 }
 
@@ -693,11 +701,13 @@ static int update_cpumask(struct cpuset 
 	trialcs = *cs;
 
 	/*
-	 * We allow a cpuset's cpus_allowed to be empty; if it has attached
-	 * tasks, we'll catch it later when we validate the change and return
-	 * -ENOSPC.
+	 * An empty cpus_allowed is ok iff there are no tasks in the cpuset.
+	 * Since cpulist_parse() fails on an empty mask, we special case
+	 * that parsing.  The validate_change() call ensures that cpusets
+	 * with tasks have cpus.
 	 */
-	if (!buf[0] || (buf[0] == '\n' && !buf[1])) {
+	buf = strstrip(buf);
+	if (!*buf) {
 		cpus_clear(trialcs.cpus_allowed);
 	} else {
 		retval = cpulist_parse(buf, trialcs.cpus_allowed);
@@ -705,10 +715,6 @@ static int update_cpumask(struct cpuset 
 			return retval;
 	}
 	cpus_and(trialcs.cpus_allowed, trialcs.cpus_allowed, cpu_online_map);
-	/* cpus_allowed cannot be empty for a cpuset with attached tasks. */
-	if (cgroup_task_count(cs->css.cgroup) &&
-	    cpus_empty(trialcs.cpus_allowed))
-		return -ENOSPC;
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
 		return retval;
@@ -813,29 +819,19 @@ static int update_nodemask(struct cpuset
 	trialcs = *cs;
 
 	/*
-	 * We allow a cpuset's mems_allowed to be empty; if it has attached
-	 * tasks, we'll catch it later when we validate the change and return
-	 * -ENOSPC.
+	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
+	 * Since nodelist_parse() fails on an empty mask, we special case
+	 * that parsing.  The validate_change() call ensures that cpusets
+	 * with tasks have memory.
 	 */
-	if (!buf[0] || (buf[0] == '\n' && !buf[1])) {
+	buf = strstrip(buf);
+	if (!*buf) {
 		nodes_clear(trialcs.mems_allowed);
 	} else {
 		retval = nodelist_parse(buf, trialcs.mems_allowed);
 		if (retval < 0)
 			goto done;
-		if (!nodes_intersects(trialcs.mems_allowed,
-						node_states[N_HIGH_MEMORY])) {
-			/*
-			 * error if only memoryless nodes specified.
-			 */
-			retval = -ENOSPC;
-			goto done;
-		}
 	}
-	/*
-	 * Exclude memoryless nodes.  We know that trialcs.mems_allowed
-	 * contains at least one node with memory.
-	 */
 	nodes_and(trialcs.mems_allowed, trialcs.mems_allowed,
 						node_states[N_HIGH_MEMORY]);
 	oldmem = cs->mems_allowed;
@@ -843,12 +839,6 @@ static int update_nodemask(struct cpuset
 		retval = 0;		/* Too easy - nothing to do */
 		goto done;
 	}
-	/* mems_allowed cannot be empty for a cpuset with attached tasks. */
-	if (cgroup_task_count(cs->css.cgroup) &&
-	    nodes_empty(trialcs.mems_allowed)) {
-		retval = -ENOSPC;
-		goto done;
-	}
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
 		goto done;
_

Patches currently in -mm which might be from pj@sgi.com are

cpuset-remove-sched-domain-hooks-from-cpusets.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
task-containers-enable-containers-by-default-in-some-configs.patch
whitespace-fixes-cpuset.patch
cpuset-sched_load_balance-flag.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
