From: akpm@linux-foundation.org
Subject: + hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:40:06 -0700
Message-ID: <200710172140.l9HLe6bY009695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54741 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656AbXJQVk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, clameter@sgi.com, cpw@sgi.com, mingo@elte.hu, oleg@tv-sign.ru


The patch titled
     hotplug cpu: migrate a task within its cpuset whitespace fix
has been added to the -mm tree.  Its filename is
     hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-scsi-misc.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-automatic-userspace-notification-of-idle-containers-fix.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
task-containers-enable-containers-by-default-in-some-configs.patch
whitespace-fixes-cpuset.patch
cpuset-sched_load_balance-flag.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
control-groups-replace-cont-with-cgrp-and-other-misc.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
