From: akpm@linux-foundation.org
Subject: - cfs-cgroup-code-cleanup-report-cpu-usage-in-cfs-cgroup-directories.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:48:29 -0700
Message-ID: <200710261848.l9QImTmG009141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46144 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762415AbXJZSs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, mingo@elte.hu, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     CFS CGroup: Code cleanup, report CPU usage in CFS Cgroup directories
has been removed from the -mm tree.  Its filename was
     cfs-cgroup-code-cleanup-report-cpu-usage-in-cfs-cgroup-directories.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CFS CGroup: Code cleanup, report CPU usage in CFS Cgroup directories
From: Paul Menage <menage@google.com>

Clean up some CFS CGroup code:

- replace "cont" with "cgrp" in a few places in the CFS cgroup code,
- use write_uint rather than write for cpu.shares write function

Adds a cpu.usage file to the CFS cgroup that reports CPU usage in
milliseconds for that cgroup's tasks

This replaces the "example CPU Accounting CGroup subsystem" that
was merged into mainline last week.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   83 ++++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 39 deletions(-)

diff -puN kernel/sched.c~cfs-cgroup-code-cleanup-report-cpu-usage-in-cfs-cgroup-directories kernel/sched.c
--- a/kernel/sched.c~cfs-cgroup-code-cleanup-report-cpu-usage-in-cfs-cgroup-directories
+++ a/kernel/sched.c
@@ -7116,25 +7116,25 @@ unsigned long sched_group_shares(struct 
 #ifdef CONFIG_FAIR_CGROUP_SCHED
 
 /* return corresponding task_group object of a cgroup */
-static inline struct task_group *cgroup_tg(struct cgroup *cont)
+static inline struct task_group *cgroup_tg(struct cgroup *cgrp)
 {
-	return container_of(cgroup_subsys_state(cont, cpu_cgroup_subsys_id),
-					 struct task_group, css);
+	return container_of(cgroup_subsys_state(cgrp, cpu_cgroup_subsys_id),
+			    struct task_group, css);
 }
 
 static struct cgroup_subsys_state *
-cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
+cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct task_group *tg;
 
-	if (!cont->parent) {
+	if (!cgrp->parent) {
 		/* This is early initialization for the top cgroup */
-		init_task_group.css.cgroup = cont;
+		init_task_group.css.cgroup = cgrp;
 		return &init_task_group.css;
 	}
 
 	/* we support only 1-level deep hierarchical scheduler atm */
-	if (cont->parent->parent)
+	if (cgrp->parent->parent)
 		return ERR_PTR(-EINVAL);
 
 	tg = sched_create_group();
@@ -7142,21 +7142,21 @@ cpu_cgroup_create(struct cgroup_subsys *
 		return ERR_PTR(-ENOMEM);
 
 	/* Bind the cgroup to task_group object we just created */
-	tg->css.cgroup = cont;
+	tg->css.cgroup = cgrp;
 
 	return &tg->css;
 }
 
 static void cpu_cgroup_destroy(struct cgroup_subsys *ss,
-					struct cgroup *cont)
+			       struct cgroup *cgrp)
 {
-	struct task_group *tg = cgroup_tg(cont);
+	struct task_group *tg = cgroup_tg(cgrp);
 
 	sched_destroy_group(tg);
 }
 
 static int cpu_cgroup_can_attach(struct cgroup_subsys *ss,
-			     struct cgroup *cont, struct task_struct *tsk)
+			     struct cgroup *cgrp, struct task_struct *tsk)
 {
 	/* We don't support RT-tasks being in separate groups */
 	if (tsk->sched_class != &fair_sched_class)
@@ -7166,51 +7166,56 @@ static int cpu_cgroup_can_attach(struct 
 }
 
 static void
-cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cont,
+cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			struct cgroup *old_cont, struct task_struct *tsk)
 {
 	sched_move_task(tsk);
 }
 
-static ssize_t cpu_shares_write(struct cgroup *cont, struct cftype *cftype,
-				struct file *file, const char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
+static int cpu_shares_write_uint(struct cgroup *cgrp, struct cftype *cftype,
+				u64 shareval)
 {
-	unsigned long shareval;
-	struct task_group *tg = cgroup_tg(cont);
-	char buffer[2*sizeof(unsigned long) + 1];
-	int rc;
-
-	if (nbytes > 2*sizeof(unsigned long))	/* safety check */
-		return -E2BIG;
-
-	if (copy_from_user(buffer, userbuf, nbytes))
-		return -EFAULT;
-
-	buffer[nbytes] = 0;	/* nul-terminate */
-	shareval = simple_strtoul(buffer, NULL, 10);
-
-	rc = sched_group_set_shares(tg, shareval);
-
-	return (rc < 0 ? rc : nbytes);
+	return sched_group_set_shares(cgroup_tg(cgrp), shareval);
 }
 
-static u64 cpu_shares_read_uint(struct cgroup *cont, struct cftype *cft)
+static u64 cpu_shares_read_uint(struct cgroup *cgrp, struct cftype *cft)
 {
-	struct task_group *tg = cgroup_tg(cont);
+	struct task_group *tg = cgroup_tg(cgrp);
 
 	return (u64) tg->shares;
 }
 
-static struct cftype cpu_shares = {
-	.name = "shares",
-	.read_uint = cpu_shares_read_uint,
-	.write = cpu_shares_write,
+static u64 cpu_usage_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	int i;
+	u64 res = 0;
+	for_each_possible_cpu(i) {
+		unsigned long flags;
+		spin_lock_irqsave(&tg->cfs_rq[i]->rq->lock, flags);
+		res += tg->se[i]->sum_exec_runtime;
+		spin_unlock_irqrestore(&tg->cfs_rq[i]->rq->lock, flags);
+	}
+	/* Convert from ns to ms */
+	do_div(res, 1000000);
+	return res;
+}
+
+static struct cftype cpu_files[] = {
+	{
+		.name = "shares",
+		.read_uint = cpu_shares_read_uint,
+		.write_uint = cpu_shares_write_uint,
+	},
+	{
+		.name = "usage",
+		.read_uint = cpu_usage_read,
+	},
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 {
-	return cgroup_add_file(cont, ss, &cpu_shares);
+	return cgroup_add_files(cont, ss, cpu_files, ARRAY_SIZE(cpu_files));
 }
 
 struct cgroup_subsys cpu_cgroup_subsys = {
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
add-a-refcount-check-in-dput.patch
