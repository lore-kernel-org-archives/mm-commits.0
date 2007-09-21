From: akpm@linux-foundation.org
Subject: + fix-potential-oops-in-generic_setlease-v2.patch added to -mm tree
Date: Thu, 20 Sep 2007 21:58:07 -0700
Message-ID: <200709210458.l8L4w73a019551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60220 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbXIUE6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 00:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, bfields@fieldses.org


The patch titled
     Fix potential OOPS in generic_setlease() (v2)
has been added to the -mm tree.  Its filename is
     fix-potential-oops-in-generic_setlease-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix potential OOPS in generic_setlease() (v2)
From: Pavel Emelyanov <xemul@openvz.org>

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/locks.c~fix-potential-oops-in-generic_setlease-v2 fs/locks.c
--- a/fs/locks.c~fix-potential-oops-in-generic_setlease-v2
+++ a/fs/locks.c
@@ -1336,7 +1336,8 @@ int fcntl_getlease(struct file *filp)
  */
 int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 {
-	struct file_lock *fl = NULL, **before, **my_before = NULL, *lease;
+	struct file_lock *fl, **before, **my_before = NULL, *lease;
+	struct file_lock *new_fl = NULL;
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	int error, rdlease_count = 0, wrlease_count = 0;
@@ -1364,8 +1365,8 @@ int generic_setlease(struct file *filp, 
 		goto out;
 
 	error = -ENOMEM;
-	fl = locks_alloc_lock();
-	if (fl == NULL)
+	new_fl = locks_alloc_lock();
+	if (new_fl == NULL)
 		goto out;
 
 	/*
@@ -1410,16 +1411,15 @@ int generic_setlease(struct file *filp, 
 	if (!leases_enable)
 		goto out;
 
-	locks_copy_lock(fl, lease);
-
-	locks_insert_lock(before, fl);
+	locks_copy_lock(new_fl, lease);
+	locks_insert_lock(before, new_fl);
 
 	*flp = fl;
 	return 0;
 
 out:
-	if (fl != NULL)
-		locks_free_lock(fl);
+	if (new_fl != NULL)
+		locks_free_lock(new_fl);
 	return error;
 }
 EXPORT_SYMBOL(generic_setlease);
_

Patches currently in -mm which might be from xemul@openvz.org are

fix-potential-oops-in-generic_setlease.patch
fix-potential-oops-in-generic_setlease-v2.patch
git-net.patch
git-nfsd.patch
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
isolate-some-explicit-usage-of-task-tgid-fix.patch
isolate-some-explicit-usage-of-task-tgid-fix-fix.patch
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
use-list_first_entry-in-locks_wake_up_blocks.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
