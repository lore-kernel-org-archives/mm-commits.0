From: akpm@linux-foundation.org
Subject: [wrecked] cpusets-cgroups-disallow-attaching-kthreadd.patch removed from -mm tree
Date: Fri, 06 Jan 2012 13:58:55 -0800
Message-ID: <20120106215855.D65611000B1@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49618 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab2AFV65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2012 16:58:57 -0500
Received: by yenm5 with SMTP id m5so226140yen.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Jan 2012 13:58:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: efault@gmx.de, a.p.zijlstra@chello.nl, htejun@gmail.com, lizf@cn.fujitsu.com, paul@paulmenage.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpusets, cgroups: disallow attaching kthreadd
has been removed from the -mm tree.  Its filename was
     cpusets-cgroups-disallow-attaching-kthreadd.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mike Galbraith <efault@gmx.de>
Subject: cpusets, cgroups: disallow attaching kthreadd

Allowing kthreadd to be moved to a non-root group makes no sense, it being
a global resource, and needlessly leads unsuspecting users toward trouble.

1. An RT workqueue worker thread spawned in a task group with no
   rt_runtime allocated is not schedulable.  Simple user error, but
   harmful to the box.

2. A worker thread which acquires PF_THREAD_BOUND can never leave a
   cpuset, rendering the cpuset immortal.

Save the user some unexpected trouble, just say no.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c     |    7 +++++--
 kernel/sched/core.c |    9 +++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpusets-cgroups-disallow-attaching-kthreadd kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-cgroups-disallow-attaching-kthreadd
+++ a/kernel/cpuset.c
@@ -59,6 +59,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/kthread.h>
 
 /*
  * Workqueue for cpuset related tasks.
@@ -1417,9 +1418,11 @@ static int cpuset_can_attach(struct cgro
 		 * unnecessary.  Thus, cpusets are not applicable for such
 		 * threads.  This prevents checking for success of
 		 * set_cpus_allowed_ptr() on all attached tasks before
-		 * cpus_allowed may be changed.
+		 * cpus_allowed may be changed.  We also disallow attaching
+		 * kthreadd, to prevent its child from becoming trapped should
+		 * it then acquire PF_THREAD_BOUND.
 		 */
-		if (task->flags & PF_THREAD_BOUND)
+		if (task->flags & PF_THREAD_BOUND || task == kthreadd_task)
 			return -EINVAL;
 		if ((ret = security_task_setscheduler(task)))
 			return ret;
diff -puN kernel/sched/core.c~cpusets-cgroups-disallow-attaching-kthreadd kernel/sched/core.c
--- a/kernel/sched/core.c~cpusets-cgroups-disallow-attaching-kthreadd
+++ a/kernel/sched/core.c
@@ -71,6 +71,7 @@
 #include <linux/ftrace.h>
 #include <linux/slab.h>
 #include <linux/init_task.h>
+#include <linux/kthread.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -7535,6 +7536,14 @@ static int cpu_cgroup_can_attach(struct 
 	struct task_struct *task;
 
 	cgroup_taskset_for_each(task, cgrp, tset) {
+		/*
+		 * kthreadd can fork workers for an RT workqueue in a cgroup
+		 * which may or may not have rt_runtime allocated.  Just say no,
+		 * as attaching a global resource to a non-root group  doesn't
+		 * make any sense anyway.
+		 */
+		if (task == kthreadd_task)
+			return -EINVAL;
 #ifdef CONFIG_RT_GROUP_SCHED
 		if (!sched_rt_can_attach(cgroup_tg(cgrp), task))
 			return -EINVAL;
_

Patches currently in -mm which might be from efault@gmx.de are

origin.patch
linux-next.patch
ipc-semc-alternatives-to-preempt_disable.patch

