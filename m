From: akpm@linux-foundation.org
Subject: - wake-up-mandatory-locks-waiter-on-chmod-v2.patch removed from -mm tree
Date: Thu, 20 Sep 2007 13:29:13 -0700
Message-ID: <200709202029.l8KKTDku000980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887AbXITUaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 16:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     Wake up mandatory locks waiter on chmod 
has been removed from the -mm tree.  Its filename was
     wake-up-mandatory-locks-waiter-on-chmod-v2.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: Wake up mandatory locks waiter on chmod 
From: Pavel Emelyanov <xemul@openvz.org>

When the process is blocked on mandatory lock and someone changes the
inode's permissions, so that the lock is no longer mandatory, nobody wakes
up the blocked process, but probably should.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/attr.c          |    9 +++++++--
 fs/locks.c         |   17 ++++++++++++++++-
 include/linux/fs.h |    1 +
 3 files changed, 24 insertions(+), 3 deletions(-)

diff -puN fs/attr.c~wake-up-mandatory-locks-waiter-on-chmod-v2 fs/attr.c
--- a/fs/attr.c~wake-up-mandatory-locks-waiter-on-chmod-v2
+++ a/fs/attr.c
@@ -104,7 +104,7 @@ int notify_change(struct dentry * dentry
 {
 	struct inode *inode = dentry->d_inode;
 	mode_t mode;
-	int error;
+	int error, mandatory;
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
@@ -151,6 +151,8 @@ int notify_change(struct dentry * dentry
 	if (ia_valid & ATTR_SIZE)
 		down_write(&dentry->d_inode->i_alloc_sem);
 
+	mandatory = (inode->i_flock && mandatory_lock(inode));
+
 	if (inode->i_op && inode->i_op->setattr) {
 		error = security_inode_setattr(dentry, attr);
 		if (!error)
@@ -171,8 +173,11 @@ int notify_change(struct dentry * dentry
 	if (ia_valid & ATTR_SIZE)
 		up_write(&dentry->d_inode->i_alloc_sem);
 
-	if (!error)
+	if (!error) {
 		fsnotify_change(dentry, ia_valid);
+		if (mandatory)
+			locks_wakeup_mandatory(inode);
+	}
 
 	return error;
 }
diff -puN fs/locks.c~wake-up-mandatory-locks-waiter-on-chmod-v2 fs/locks.c
--- a/fs/locks.c~wake-up-mandatory-locks-waiter-on-chmod-v2
+++ a/fs/locks.c
@@ -1109,7 +1109,8 @@ int locks_mandatory_area(int read_write,
 			break;
 		if (!(fl.fl_flags & FL_SLEEP))
 			break;
-		error = wait_event_interruptible(fl.fl_wait, !fl.fl_next);
+		error = wait_event_interruptible(fl.fl_wait,
+				!fl.fl_next || !__mandatory_lock(inode));
 		if (!error) {
 			/*
 			 * If we've been sleeping someone might have
@@ -1128,6 +1129,20 @@ int locks_mandatory_area(int read_write,
 
 EXPORT_SYMBOL(locks_mandatory_area);
 
+void locks_wakeup_mandatory(struct inode *inode)
+{
+	struct file_lock *fl, **before;
+
+	lock_kernel();
+	for_each_lock(inode, before) {
+		fl = *before;
+
+		if (IS_POSIX(fl))
+			locks_wake_up_blocks(fl);
+	}
+	unlock_kernel();
+}
+
 /* We already had a lease on this file; just change its type */
 int lease_modify(struct file_lock **before, int arg)
 {
diff -puN include/linux/fs.h~wake-up-mandatory-locks-waiter-on-chmod-v2 include/linux/fs.h
--- a/include/linux/fs.h~wake-up-mandatory-locks-waiter-on-chmod-v2
+++ a/include/linux/fs.h
@@ -1481,6 +1481,7 @@ extern struct kset fs_subsys;
 
 extern int locks_mandatory_locked(struct inode *);
 extern int locks_mandatory_area(int, struct inode *, struct file *, loff_t, size_t);
+extern void locks_wakeup_mandatory(struct inode *);
 
 /*
  * Candidates for mandatory locking have the setgid bit set
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
convert-uid-hash-to-hlist.patch
fix-user-namespace-exiting-oops.patch
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
wake-up-mandatory-locks-waiter-on-chmod-v2.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
