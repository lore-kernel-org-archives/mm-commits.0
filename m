From: akpm@linux-foundation.org
Subject: - pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:21:19 -0700
Message-ID: <200710190421.l9J4LJMq014775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39597 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbXJSEVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     sys_getsid/sys_getpgid return wrong id for task from another namespace
has been removed from the -mm tree.  Its filename was
     pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another.patch

This patch was dropped because it was folded into pid-namespaces-changes-to-show-virtual-ids-to-user.patch

------------------------------------------------------
Subject: sys_getsid/sys_getpgid return wrong id for task from another namespace
From: Pavel Emelyanov <xemul@openvz.org>

When calling the sys_getsid/sys_getpgid for task, that actually lives in
another namespace (sub-namespace) the return value should be not the id as
this task sees it, but the id as the caller does.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN kernel/sys.c~pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another kernel/sys.c
--- a/kernel/sys.c~pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another
+++ a/kernel/sys.c
@@ -994,16 +994,17 @@ asmlinkage long sys_getpgid(pid_t pid)
 	else {
 		int retval;
 		struct task_struct *p;
+		struct pid_namespace *ns;
 
-		read_lock(&tasklist_lock);
-		p = find_task_by_pid_ns(pid,
-				current->nsproxy->pid_ns);
+		ns = current->nsproxy->pid_ns;
 
+		read_lock(&tasklist_lock);
+		p = find_task_by_pid_ns(pid, ns);
 		retval = -ESRCH;
 		if (p) {
 			retval = security_task_getpgid(p);
 			if (!retval)
-				retval = task_pgrp_vnr(p);
+				retval = task_pgrp_nr_ns(p, ns);
 		}
 		read_unlock(&tasklist_lock);
 		return retval;
@@ -1027,16 +1028,17 @@ asmlinkage long sys_getsid(pid_t pid)
 	else {
 		int retval;
 		struct task_struct *p;
+		struct pid_namespace *ns;
 
-		read_lock(&tasklist_lock);
-		p = find_task_by_pid_ns(pid,
-				current->nsproxy->pid_ns);
+		ns = current->nsproxy->pid_ns;
 
+		read_lock(&tasklist_lock);
+		p = find_task_by_pid_ns(pid, ns);
 		retval = -ESRCH;
 		if (p) {
 			retval = security_task_getsid(p);
 			if (!retval)
-				retval = task_session_vnr(p);
+				retval = task_session_nr_ns(p, ns);
 		}
 		read_unlock(&tasklist_lock);
 		return retval;
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
pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another.patch
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
