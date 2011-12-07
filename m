From: akpm@linux-foundation.org
Subject: + cpusets-cgroups-disallow-attaching-kthreadd.patch added to -mm tree
Date: Wed, 07 Dec 2011 14:32:23 -0800
Message-ID: <201112072232.pB7MWNcX000381@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:65049 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab1LGWc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2011 17:32:28 -0500
Received: by eaak10 with SMTP id k10so23320eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Dec 2011 14:32:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: efault@gmx.de, a.p.zijlstra@chello.nl, htejun@gmail.com, lizf@cn.fujitsu.com, paul@paulmenage.org, rientjes@google.com


The patch titled
     Subject: cpusets, cgroups: disallow attaching kthreadd
has been added to the -mm tree.  Its filename is
     cpusets-cgroups-disallow-attaching-kthreadd.patch

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

 kernel/cpuset.c     |    6 ++++--
 kernel/sched/core.c |   10 ++++++++++
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
@@ -1394,9 +1395,10 @@ static int cpuset_can_attach(struct cgro
 	 * set of allowed nodes is unnecessary.  Thus, cpusets are not
 	 * applicable for such threads.  This prevents checking for success of
 	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
-	 * be changed.
+	 * be changed.  We also disallow attaching kthreadd, to prevent its
+	 * child from becoming trapped should it then acquire PF_THREAD_BOUND.
 	 */
-	if (tsk->flags & PF_THREAD_BOUND)
+	if (tsk->flags & PF_THREAD_BOUND || tsk == kthreadd_task)
 		return -EINVAL;
 
 	return 0;
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
@@ -7532,6 +7533,15 @@ cpu_cgroup_destroy(struct cgroup_subsys 
 static int
 cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
+	/*
+	 * kthreadd can fork workers for an RT workqueue in a cgroup
+	 * which may or may not have rt_runtime allocated.  Just say no,
+	 * as attaching a global resource to a non-root group  doesn't
+	 * make any sense anyway.
+	 */
+	if (tsk == kthreadd_task)
+		return -EINVAL;
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
 		return -EINVAL;
_
Subject: Subject: cpusets, cgroups: disallow attaching kthreadd

Patches currently in -mm which might be from efault@gmx.de are

origin.patch
linux-next.patch
cpusets-cgroups-disallow-attaching-kthreadd.patch
ipc-semc-alternatives-to-preempt_disable.patch

