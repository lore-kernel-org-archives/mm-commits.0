From: akpm@linux-foundation.org
Subject: - hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:27:44 -0700
Message-ID: <200710190427.l9J4RiU9014991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764202AbXJSE1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:27:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, clameter@sgi.com, cpw@sgi.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     hotplug cpu: migrate a task within its cpuset whitespace fix
has been removed from the -mm tree.  Its filename was
     hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch

This patch was dropped because it was folded into hotplug-cpu-migrate-a-task-within-its-cpuset.patch

------------------------------------------------------
Subject: hotplug cpu: migrate a task within its cpuset whitespace fix
From: Paul Jackson <pj@sgi.com>

Fix indentation and spacing.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/sched.c~hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix kernel/sched.c
--- a/kernel/sched.c~hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix
+++ a/kernel/sched.c
@@ -5125,16 +5125,16 @@ static void move_task_off_dead_cpu(int d
 
 		/* No more Mr. Nice Guy. */
 		if (dest_cpu == NR_CPUS) {
-		cpumask_t cpus_allowed = cpuset_cpus_allowed_locked(p);
-		/*
-		 * Try to stay on the same cpuset, where the current cpuset
-		 * may be a subset of all cpus.
-		 * The cpuset_cpus_allowed_locked() variant of
-		 * cpuset_cpus_allowed() will not block
-		 * It must be called within calls to cpuset_lock/cpuset_unlock.
-		 */
+			cpumask_t cpus_allowed = cpuset_cpus_allowed_locked(p);
+			/*
+			 * Try to stay on the same cpuset, where the
+			 * current cpuset may be a subset of all cpus.
+			 * The cpuset_cpus_allowed_locked() variant of
+			 * cpuset_cpus_allowed() will not block.  It must be
+			 * called within calls to cpuset_lock/cpuset_unlock.
+			 */
 			rq = task_rq_lock(p, &flags);
-		p->cpus_allowed = cpus_allowed;
+			p->cpus_allowed = cpus_allowed;
 			dest_cpu = any_online_cpu(p->cpus_allowed);
 			task_rq_unlock(rq, &flags);
 
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
cpusets-decrustify-cpuset-mask-update-code.patch
fix-cpusets-update_cpumask.patch
control-groups-replace-cont-with-cgrp-and-other-misc.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
