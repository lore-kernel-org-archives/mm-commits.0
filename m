From: akpm@linux-foundation.org
Subject: - cpuset-convert-cpuset_attach-to-use-cpumask_var_t.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:13 -0800
Message-ID: <200901082250.n08MoDp1029428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763328AbZAHWvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, rusty@rustcorp.com.au, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: convert cpuset_attach() to use cpumask_var_t
has been removed from the -mm tree.  Its filename was
     cpuset-convert-cpuset_attach-to-use-cpumask_var_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: convert cpuset_attach() to use cpumask_var_t
From: Li Zefan <lizf@cn.fujitsu.com>

Impact: reduce stack usage

Allocate a global cpumask_var_t at boot, and use it in cpuset_attach(), so
we won't fail cpuset_attach().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Mike Travis <travis@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN kernel/cpuset.c~cpuset-convert-cpuset_attach-to-use-cpumask_var_t kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-convert-cpuset_attach-to-use-cpumask_var_t
+++ a/kernel/cpuset.c
@@ -1306,6 +1306,9 @@ static int fmeter_getrate(struct fmeter 
 	return val;
 }
 
+/* Protected by cgroup_lock */
+static cpumask_var_t cpus_attach;
+
 /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
 static int cpuset_can_attach(struct cgroup_subsys *ss,
 			     struct cgroup *cont, struct task_struct *tsk)
@@ -1330,7 +1333,6 @@ static void cpuset_attach(struct cgroup_
 			  struct cgroup *cont, struct cgroup *oldcont,
 			  struct task_struct *tsk)
 {
-	cpumask_t cpus;
 	nodemask_t from, to;
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
@@ -1338,13 +1340,13 @@ static void cpuset_attach(struct cgroup_
 	int err;
 
 	if (cs == &top_cpuset) {
-		cpus = cpu_possible_map;
+		cpumask_copy(cpus_attach, cpu_possible_mask);
 	} else {
 		mutex_lock(&callback_mutex);
-		guarantee_online_cpus(cs, &cpus);
+		guarantee_online_cpus(cs, cpus_attach);
 		mutex_unlock(&callback_mutex);
 	}
-	err = set_cpus_allowed_ptr(tsk, &cpus);
+	err = set_cpus_allowed_ptr(tsk, cpus_attach);
 	if (err)
 		return;
 
@@ -1357,7 +1359,6 @@ static void cpuset_attach(struct cgroup_
 			cpuset_migrate_mm(mm, &from, &to);
 		mmput(mm);
 	}
