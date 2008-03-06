From: akpm@linux-foundation.org
Subject: - cfs-cgroup-code-cleanup.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:28:03 -0800
Message-ID: <200803062228.m26MS3bJ021154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757128AbYCFW27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:28:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, mingo@elte.hu, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     CFS CGroup: Code cleanup
has been removed from the -mm tree.  Its filename was
     cfs-cgroup-code-cleanup.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CFS CGroup: Code cleanup
From: Paul Menage <menage@google.com>

Clean up some CFS CGroup code

- replace "cont" with "cgrp" in a few places in the CFS cgroup code,
- use write_uint rather than write for cpu.shares write function

Signed-off-by: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   51 +++++++++++++++--------------------------------
 1 file changed, 17 insertions(+), 34 deletions(-)

diff -puN kernel/sched.c~cfs-cgroup-code-cleanup kernel/sched.c
--- a/kernel/sched.c~cfs-cgroup-code-cleanup
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
@@ -7166,38 +7166,21 @@ static int cpu_cgroup_can_attach(struct 
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
_

Patches currently in -mm which might be from menage@google.com are

make-cgroup_enable_task_cg_lists-static.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch
cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch
cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch
devscontrol-avoid-magic-constants-in-drivers-base-mapc.patch
devscontrol-clean-up-get_gendisk-a-bit.patch
devscontrol-add-a-mode-on-the-struct-probe.patch
devscontrol-make-kobj_lookup-return-the-mappings-permissions.patch
devscontrol-make-use-of-permissions-returned-by-kobj_lookup.patch
devscontrol-extend-the-drivers-base-mapc-functionality.patch
devscontrol-provide-functions-to-manipulate-char-device-mappings.patch
devscontrol-provide-functions-to-manipulate-block-device-mappings.patch
devscontrol-devices-accessibility-control-group-itself.patch
add-a-refcount-check-in-dput.patch

