From: akpm@linux-foundation.org
Subject: - task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:12:02 -0700
Message-ID: <200710190412.l9J4C2IQ014391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39310 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbXJSEML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     Control Groups: Avoid lockdep warning
has been removed from the -mm tree.  Its filename was
     task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch

This patch was dropped because it was folded into task-containersv11-shared-container-subsystem-group-arrays.patch

------------------------------------------------------
Subject: Control Groups: Avoid lockdep warning
From: Paul Menage <menage@google.com>

I think this is the right way to handle the lockdep false-positive in the
current cgroups patches, but I'm not that familiar with lockdep so any
suggestions for a better approach are welcomed.

In order to avoid a false-positive lockdep warning, we lock the root inode
of a new filesystem mount prior to taking cgroup_mutex, to preserve the
invariant that cgroup_mutex nests inside inode->i_mutex.  In order to
prevent a lockdep false positive when locking i_mutex on a newly-created
cgroup directory inode we use mutex_lock_nested(), with a nesting level
of I_MUTEX_CHILD since the new inode will ultimately be a child directory
of the parent whose i_mutex is nested outside of cgroup_mutex.

Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN kernel/cgroup.c~task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning kernel/cgroup.c
--- a/kernel/cgroup.c~task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning
+++ a/kernel/cgroup.c
@@ -855,13 +855,16 @@ static int cgroup_get_sb(struct file_sys
 	} else {
 		/* New superblock */
 		struct cgroup *cont = &root->top_cgroup;
+		struct inode *inode;
 
 		BUG_ON(sb->s_root != NULL);
 
 		ret = cgroup_get_rootdir(sb);
 		if (ret)
 			goto drop_new_super;
+		inode = sb->s_root->d_inode;
 
+		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
 
 		/*
@@ -874,12 +877,14 @@ static int cgroup_get_sb(struct file_sys
 		ret = allocate_cg_links(css_set_count, &tmp_cg_links);
 		if (ret) {
 			mutex_unlock(&cgroup_mutex);
+			mutex_unlock(&inode->i_mutex);
 			goto drop_new_super;
 		}
 
 		ret = rebind_subsystems(root, root->subsys_bits);
 		if (ret == -EBUSY) {
 			mutex_unlock(&cgroup_mutex);
+			mutex_unlock(&inode->i_mutex);
 			goto drop_new_super;
 		}
 
@@ -919,16 +924,8 @@ static int cgroup_get_sb(struct file_sys
 		BUG_ON(!list_empty(&cont->children));
 		BUG_ON(root->number_of_cgroups != 1);
 
-		/*
-		 * I believe that it's safe to nest i_mutex inside
-		 * cgroup_mutex in this case, since no-one else can
-		 * be accessing this directory yet. But we still need
-		 * to teach lockdep that this is the case - currently
-		 * a cgroupfs remount triggers a lockdep warning
-		 */
-		mutex_lock(&cont->dentry->d_inode->i_mutex);
 		cgroup_populate_dir(cont);
-		mutex_unlock(&cont->dentry->d_inode->i_mutex);
+		mutex_unlock(&inode->i_mutex);
 		mutex_unlock(&cgroup_mutex);
 	}
 
@@ -1384,7 +1381,7 @@ static int cgroup_create_file(struct den
 
 		/* start with the directory inode held, so that we can
 		 * populate it without racing with another mkdir */
-		mutex_lock(&inode->i_mutex);
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
 	} else if (S_ISREG(mode)) {
 		inode->i_size = 0;
 		inode->i_fop = &cgroup_file_operations;
_

Patches currently in -mm which might be from menage@google.com are

cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
add-cgroup-write_uint-helper-method.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
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
