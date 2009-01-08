From: akpm@linux-foundation.org
Subject: - cpuset-remove-on-stack-cpumask_t-in-cpuset_can_attach.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:10 -0800
Message-ID: <200901082250.n08MoA65029391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763053AbZAHW7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:59:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, lizf@cn.fujistu.com, menage@google.com, mingo@elte.hu, rusty@rustcorp.com.au, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: remove on stack cpumask_t in cpuset_can_attach()
has been removed from the -mm tree.  Its filename was
     cpuset-remove-on-stack-cpumask_t-in-cpuset_can_attach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: remove on stack cpumask_t in cpuset_can_attach()
From: Li Zefan <lizf@cn.fujitsu.com>

Impact: redue stack usage

Just use cs->cpus_allowed, and no need to allocate a cpumask_var_t.

Signed-off-by: Li Zefan <lizf@cn.fujistu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Mike Travis <travis@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN kernel/cpuset.c~cpuset-remove-on-stack-cpumask_t-in-cpuset_can_attach kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-remove-on-stack-cpumask_t-in-cpuset_can_attach
+++ a/kernel/cpuset.c
@@ -1311,20 +1311,19 @@ static int cpuset_can_attach(struct cgro
 			     struct cgroup *cont, struct task_struct *tsk)
 {
 	struct cpuset *cs = cgroup_cs(cont);
+	int ret = 0;
 
 	if (cpus_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
-	if (tsk->flags & PF_THREAD_BOUND) {
-		cpumask_t mask;
 
+	if (tsk->flags & PF_THREAD_BOUND) {
 		mutex_lock(&callback_mutex);
-		mask = cs->cpus_allowed;
+		if (!cpus_equal(tsk->cpus_allowed, cs->cpus_allowed))
+			ret = -EINVAL;
 		mutex_unlock(&callback_mutex);
-		if (!cpus_equal(tsk->cpus_allowed, mask))
-			return -EINVAL;
 	}
 
-	return security_task_setscheduler(tsk, 0, NULL);
+	return ret < 0 ? ret : security_task_setscheduler(tsk, 0, NULL);
 }
 
 static void cpuset_attach(struct cgroup_subsys *ss,
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch

