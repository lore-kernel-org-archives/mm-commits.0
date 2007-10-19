From: akpm@linux-foundation.org
Subject: - pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:21:25 -0700
Message-ID: <200710190421.l9J4LPDW014778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbXJSEV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:21:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Fix the sys_setpgrp() to work between namespaces
has been removed from the -mm tree.  Its filename was
     pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces.patch

This patch was dropped because it was folded into pid-namespaces-changes-to-show-virtual-ids-to-user.patch

------------------------------------------------------
Subject: Fix the sys_setpgrp() to work between namespaces
From: Pavel Emelyanov <xemul@openvz.org>

The check if (task_pgrp_nr(p) != pgid) is almost always true, because pgid
is a "virtual" pid and it is most often much smaller than the "real" pgrp
id of any task (because pids are generated sequentially most of the time). 
This leads to the task's pgrp is always reset, even if it is not needed.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/sys.c~pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces kernel/sys.c
--- a/kernel/sys.c~pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces
+++ a/kernel/sys.c
@@ -919,6 +919,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	struct task_struct *p;
 	struct task_struct *group_leader = current->group_leader;
 	int err = -EINVAL;
+	struct pid_namespace *ns;
 
 	if (!pid)
 		pid = task_pid_vnr(group_leader);
@@ -930,10 +931,12 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	/* From this point forward we keep holding onto the tasklist lock
 	 * so that our parent does not change from under us. -DaveM
 	 */
+	ns = current->nsproxy->pid_ns;
+
 	write_lock_irq(&tasklist_lock);
 
 	err = -ESRCH;
-	p = find_task_by_pid_ns(pid, current->nsproxy->pid_ns);
+	p = find_task_by_pid_ns(pid, ns);
 	if (!p)
 		goto out;
 
@@ -959,10 +962,9 @@ asmlinkage long sys_setpgid(pid_t pid, p
 		goto out;
 
 	if (pgid != pid) {
-		struct task_struct *g =
-			find_task_by_pid_type_ns(PIDTYPE_PGID, pgid,
-					current->nsproxy->pid_ns);
+		struct task_struct *g;
 
+		g = find_task_by_pid_type_ns(PIDTYPE_PGID, pgid, ns);
 		if (!g || task_session(g) != task_session(group_leader))
 			goto out;
 	}
@@ -971,7 +973,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	if (err)
 		goto out;
 
-	if (task_pgrp_nr(p) != pgid) {
+	if (task_pgrp_nr_ns(p, ns) != pgid) {
 		struct pid *pid;
 
 		detach_pid(p, PIDTYPE_PGID);
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-merge-fix.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces.patch
uninline-find_task_by_xxx-set-of-functions.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
uninline-find_pid-etc-set-of-functions.patch
uninline-the-task_xid_nr_ns-calls.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
use-helpers-to-obtain-task-pid-in-printks.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
use-helpers-to-obtain-task-pid-in-printks-arch-code.patch
remove-unused-variables-from-fs-proc-basec.patch
use-task_pid_nr-in-ip_vs_syncc.patch
use-task_pid_nr-instead-of-pid_nrtask_pid.patch
