From: akpm@linux-foundation.org
Subject: - fix-potential-oops-in-generic_setlease.patch removed from -mm tree
Date: Tue, 25 Sep 2007 10:23:59 -0700
Message-ID: <200709251723.l8PHNxcB028496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485AbXIYRYK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 13:24:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, bfields@fieldses.org, mm-commits@vger.kernel.org


The patch titled
     Fix potential OOPS in generic_setlease()
has been removed from the -mm tree.  Its filename was
     fix-potential-oops-in-generic_setlease.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Fix potential OOPS in generic_setlease()
From: Pavel Emelyanov <xemul@openvz.org>

This code is run under lock_kernel(), which is dropped during sleeping
operations, so the following race is possible:

CPU1:                                CPU2:
  vfs_setlease();                    vfs_setlease();
  lock_kernel();
                                     lock_kernel(); /* spin */
  generic_setlease():
    ...
    for (before = ...)
    /* here we found some lease after
     * which we will insert the new one
     */
    fl = locks_alloc_lock();
    /* go to sleep in this allocation and
     * drop the BKL
     */
                                     generic_setlease():
                                       ...
                                       for (before = ...)
                                       /* here we find the "before" pointing
                                        * at the one we found on CPU1
                                        */
                                      ->fl_change(my_before, arg);
                                              lease_modify();
                                                     locks_free_lock();
                                                     /* and we freed it */
                                     ...
                                     unlock_kernel();
   locks_insert_lock(before, fl);
   /* OOPS! We have just tried to add the lease
    * at the tail of already removed one
    */

The similar races are already handled in other code - all the
allocations are performed before any checks/updates.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN fs/locks.c~fix-potential-oops-in-generic_setlease fs/locks.c
--- a/fs/locks.c~fix-potential-oops-in-generic_setlease
+++ a/fs/locks.c
@@ -1337,6 +1337,7 @@ int fcntl_getlease(struct file *filp)
 int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 {
 	struct file_lock *fl, **before, **my_before = NULL, *lease;
+	struct file_lock *new_fl = NULL;
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	int error, rdlease_count = 0, wrlease_count = 0;
@@ -1363,6 +1364,11 @@ int generic_setlease(struct file *filp, 
 		|| (atomic_read(&inode->i_count) > 1)))
 		goto out;
 
+	error = -ENOMEM;
+	new_fl = locks_alloc_lock();
+	if (new_fl == NULL)
+		goto out;
+
 	/*
 	 * At this point, we know that if there is an exclusive
 	 * lease on this file, then we hold it on this filp
@@ -1405,18 +1411,15 @@ int generic_setlease(struct file *filp, 
 	if (!leases_enable)
 		goto out;
 
-	error = -ENOMEM;
-	fl = locks_alloc_lock();
-	if (fl == NULL)
-		goto out;
-
-	locks_copy_lock(fl, lease);
+	locks_copy_lock(new_fl, lease);
+	locks_insert_lock(before, new_fl);
 
-	locks_insert_lock(before, fl);
+	*flp = new_fl;
+	return 0;
 
-	*flp = fl;
-	error = 0;
 out:
+	if (new_fl != NULL)
+		locks_free_lock(new_fl);
 	return error;
 }
 EXPORT_SYMBOL(generic_setlease);
_

Patches currently in -mm which might be from xemul@openvz.org are

git-net.patch
git-nfsd.patch
fix-potential-oops-in-generic_setlease.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
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
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
use-helpers-to-obtain-task-pid-in-printks.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
use-helpers-to-obtain-task-pid-in-printks-arch-code.patch
remove-unused-variables-from-fs-proc-basec.patch
use-task_pid_nr-in-ip_vs_syncc.patch
cleanup-macros-for-distinguishing-mandatory-locks.patch
gfs2-cleanup-explicit-check-for-mandatory-locks.patch
9pfs-cleanup-explicit-check-for-mandatory-locks.patch
afs-cleanup-explicit-check-for-mandatory-locks.patch
nfs-cleanup-explicit-check-for-mandatory-locks.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix-2.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
