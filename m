From: akpm@linux-foundation.org
Subject: [merged] const-make-lock_manager_operations-const.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:14 -0700
Message-ID: <200909222037.n8MKbE8U031461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbZIVUhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:37:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     const: make lock_manager_operations const
has been removed from the -mm tree.  Its filename was
     const-make-lock_manager_operations-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: const: make lock_manager_operations const
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svclock.c          |    2 +-
 fs/locks.c                  |    2 +-
 fs/nfsd/nfs4state.c         |    4 ++--
 include/linux/fs.h          |    2 +-
 include/linux/lockd/lockd.h |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/lockd/svclock.c~const-make-lock_manager_operations-const fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~const-make-lock_manager_operations-const
+++ a/fs/lockd/svclock.c
@@ -705,7 +705,7 @@ static int nlmsvc_same_owner(struct file
 	return fl1->fl_owner == fl2->fl_owner && fl1->fl_pid == fl2->fl_pid;
 }
 
-struct lock_manager_operations nlmsvc_lock_operations = {
+const struct lock_manager_operations nlmsvc_lock_operations = {
 	.fl_compare_owner = nlmsvc_same_owner,
 	.fl_notify = nlmsvc_notify_blocked,
 	.fl_grant = nlmsvc_grant_deferred,
diff -puN fs/locks.c~const-make-lock_manager_operations-const fs/locks.c
--- a/fs/locks.c~const-make-lock_manager_operations-const
+++ a/fs/locks.c
@@ -434,7 +434,7 @@ static int lease_mylease_callback(struct
 	return fl->fl_file == try->fl_file;
 }
 
-static struct lock_manager_operations lease_manager_ops = {
+static const struct lock_manager_operations lease_manager_ops = {
 	.fl_break = lease_break_callback,
 	.fl_release_private = lease_release_private_callback,
 	.fl_mylease = lease_mylease_callback,
diff -puN fs/nfsd/nfs4state.c~const-make-lock_manager_operations-const fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~const-make-lock_manager_operations-const
+++ a/fs/nfsd/nfs4state.c
@@ -2163,7 +2163,7 @@ int nfsd_change_deleg_cb(struct file_loc
 		return -EAGAIN;
 }
 
-static struct lock_manager_operations nfsd_lease_mng_ops = {
+static const struct lock_manager_operations nfsd_lease_mng_ops = {
 	.fl_break = nfsd_break_deleg_cb,
 	.fl_release_private = nfsd_release_deleg_cb,
 	.fl_copy_lock = nfsd_copy_lock_deleg_cb,
@@ -3368,7 +3368,7 @@ nfs4_transform_lock_offset(struct file_l
 
 /* Hack!: For now, we're defining this just so we can use a pointer to it
  * as a unique cookie to identify our (NFSv4's) posix locks. */
-static struct lock_manager_operations nfsd_posix_mng_ops  = {
+static const struct lock_manager_operations nfsd_posix_mng_ops  = {
 };
 
 static inline void
diff -puN include/linux/fs.h~const-make-lock_manager_operations-const include/linux/fs.h
--- a/include/linux/fs.h~const-make-lock_manager_operations-const
+++ a/include/linux/fs.h
@@ -1067,7 +1067,7 @@ struct file_lock {
 	unsigned long fl_break_time;	/* for nonblocking lease breaks */
 
 	const struct file_lock_operations *fl_ops;	/* Callbacks for filesystems */
-	struct lock_manager_operations *fl_lmops;	/* Callbacks for lockmanagers */
+	const struct lock_manager_operations *fl_lmops;	/* Callbacks for lockmanagers */
 	union {
 		struct nfs_lock_info	nfs_fl;
 		struct nfs4_lock_info	nfs4_fl;
diff -puN include/linux/lockd/lockd.h~const-make-lock_manager_operations-const include/linux/lockd/lockd.h
--- a/include/linux/lockd/lockd.h~const-make-lock_manager_operations-const
+++ a/include/linux/lockd/lockd.h
@@ -395,7 +395,7 @@ static inline int nlm_compare_locks(cons
 	     &&(fl1->fl_type  == fl2->fl_type || fl2->fl_type == F_UNLCK);
 }
 
-extern struct lock_manager_operations nlmsvc_lock_operations;
+extern const struct lock_manager_operations nlmsvc_lock_operations;
 
 #endif /* __KERNEL__ */
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
viafb-switch-to-seq_file.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch
gru-use-proc_create.patch

