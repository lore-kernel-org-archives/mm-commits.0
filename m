From: akpm@linux-foundation.org
Subject: - task-containersv11-add-container_clone-interface-containers-fix-refcount-bug.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:11:03 -0700
Message-ID: <200710190411.l9J4B397014363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200AbXJSELK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:11:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, mm-commits@vger.kernel.org


The patch titled
     Control Groups: Fix refcount bug
has been removed from the -mm tree.  Its filename was
     task-containersv11-add-container_clone-interface-containers-fix-refcount-bug.patch

This patch was dropped because it was folded into task-containersv11-add-container_clone-interface.patch

------------------------------------------------------
Subject: Control Groups: Fix refcount bug
From: Paul Menage <menage@google.com>

Fix a reference counting bug in cgroupfs

As part of the extraction of cpusetfs to cgroupfs, a call to
cpuset_get_dentry() was lost (justified by the fact that the dentry in
question was now being passed down by the caller). Since
cpuset_get_dentry() called lookup_one_len(), this resulted in a
reference count being missed from the directory dentry.

This patch removes cgroup_get_dentry() and replaces it with direct
calls to lookup_one_len(); the initialization of cgroupfs dentry
ops is done now in cgroup_create_file() at dentry creation time.

Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~task-containersv11-add-container_clone-interface-containers-fix-refcount-bug kernel/cgroup.c
--- a/kernel/cgroup.c~task-containersv11-add-container_clone-interface-containers-fix-refcount-bug
+++ a/kernel/cgroup.c
@@ -1756,7 +1756,7 @@ int cgroup_clone(struct task_struct *tsk
 	/* Hold the parent directory mutex across this operation to
 	 * stop anyone else deleting the new cgroup */
 	mutex_lock(&inode->i_mutex);
-	dentry = cgroup_get_dentry(parent->dentry, nodename);
+	dentry = lookup_one_len(nodename, parent->dentry, strlen(nodename));
 	if (IS_ERR(dentry)) {
 		printk(KERN_INFO
 		       "Couldn't allocate dentry for %s: %ld\n", nodename,
_

Patches currently in -mm which might be from menage@google.com are

cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
add-cgroup-write_uint-helper-method.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-container_clone-interface-containers-fix-refcount-bug.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-automatic-userspace-notification-of-idle-containers-fix.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
task-containers-enable-containers-by-default-in-some-configs.patch
add-containerstats-v3.patch
add-containerstats-v3-fix.patch
containers-implement-namespace-tracking-subsystem.patch
containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
uninline-find_task_by_xxx-set-of-functions.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
uninline-find_pid-etc-set-of-functions.patch
uninline-the-task_xid_nr_ns-calls.patch
cpusets-decrustify-cpuset-mask-update-code.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
use-task_pid_nr-instead-of-pid_nrtask_pid.patch
control-groups-replace-cont-with-cgrp-and-other-misc.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
