From: akpm@linux-foundation.org
Subject: - cpuset-sched_load_balance-kmalloc-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:24:29 -0700
Message-ID: <200710190424.l9J4OThB014927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbXJSEYm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:24:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cpuset sched_load_balance kmalloc fix
has been removed from the -mm tree.  Its filename was
     cpuset-sched_load_balance-kmalloc-fix.patch

This patch was dropped because it was folded into cpuset-sched_load_balance-flag.patch

------------------------------------------------------
Subject: cpuset sched_load_balance kmalloc fix
From: Paul Jackson <pj@sgi.com>

Properly check return value of kmalloc'd dynamic sched domain cpumasks, and
fallback to a non-kmalloc'd default (one large sched domain) if kmalloc
fails.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    4 +++-
 kernel/sched.c  |   25 ++++++++++++++++++++++---
 2 files changed, 25 insertions(+), 4 deletions(-)

diff -puN kernel/cpuset.c~cpuset-sched_load_balance-kmalloc-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-sched_load_balance-kmalloc-fix
+++ a/kernel/cpuset.c
@@ -587,6 +587,8 @@ static void rebuild_sched_domains(void)
 	if (is_sched_load_balance(&top_cpuset)) {
 		ndoms = 1;
 		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+		if (!doms)
+			goto rebuild;
 		*doms = top_cpuset.cpus_allowed;
 		goto rebuild;
 	}
@@ -640,7 +642,7 @@ restart:
 	/* Convert <csn, csa> to <ndoms, doms> */
 	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
 	if (!doms)
-		goto done;
+		goto rebuild;
 
 	for (nslot = 0, i = 0; i < csn; i++) {
 		struct cpuset *a = csa[i];
diff -puN kernel/sched.c~cpuset-sched_load_balance-kmalloc-fix kernel/sched.c
--- a/kernel/sched.c~cpuset-sched_load_balance-kmalloc-fix
+++ a/kernel/sched.c
@@ -6329,6 +6329,13 @@ static cpumask_t *doms_cur;	/* current s
 static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
 
 /*
+ * Special case: If a kmalloc of a doms_cur partition (array of
+ * cpumask_t) fails, then fallback to a single sched domain,
+ * as determined by the single cpumask_t fallback_doms.
+ */
+static cpumask_t fallback_doms;
+
+/*
  * Set up scheduler domains and groups.  Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
@@ -6337,6 +6344,8 @@ static int arch_init_sched_domains(const
 {
 	ndoms_cur = 1;
 	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+	if (!doms_cur)
+		doms_cur = &fallback_doms;
 	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
 	register_sched_domain_sysctl();
 	return build_sched_domains(doms_cur);
@@ -6376,8 +6385,11 @@ static void detach_destroy_domains(const
  * current 'doms_cur' domains and in the new 'doms_new', we can leave
  * it as it is.
  *
- * The passed in 'doms_new' must be kmalloc'd, and this routine takes
- * ownership of it and will kfree it when done with it.
+ * The passed in 'doms_new' should be kmalloc'd.  This routine takes
+ * ownership of it and will kfree it when done with it.  If the caller
+ * failed the kmalloc call, then it can pass in doms_new == NULL,
+ * and partition_sched_domains() will fallback to the single partition
+ * 'fallback_doms'.
  *
  * Call with hotplug lock held
  */
@@ -6385,6 +6397,12 @@ void partition_sched_domains(int ndoms_n
 {
 	int i, j;
 
+	if (doms_new == NULL) {
+		ndoms_new = 1;
+		doms_new = &fallback_doms;
+		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
+	}
+
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
 		for (j = 0; j < ndoms_new; j++) {
@@ -6410,7 +6428,8 @@ match2:
 	}
 
 	/* Remember the new sched domains */
-	kfree(doms_cur);
+	if (doms_cur != &fallback_doms)
+		kfree(doms_cur);
 	doms_cur = doms_new;
 	ndoms_cur = ndoms_new;
 }
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
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
cpuset-sched_load_balance-flag.patch
cpuset-sched_load_balance-kmalloc-fix.patch
cpuset-sched_load_balance-flag-sched-domain-confusion-fix.patch
cpusets-decrustify-cpuset-mask-update-code.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
control-groups-replace-cont-with-cgrp-and-other-misc.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
