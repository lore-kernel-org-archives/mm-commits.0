From: akpm@linux-foundation.org
Subject: [merged] const-make-file_lock_operations-const.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:12 -0700
Message-ID: <200909222037.n8MKbCU5031365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbZIVUhj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:37:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     const: make file_lock_operations const
has been removed from the -mm tree.  Its filename was
     const-make-file_lock_operations-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: const: make file_lock_operations const
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/flock.c      |    2 +-
 fs/lockd/clntproc.c |    2 +-
 fs/nfs/nfs4state.c  |    2 +-
 include/linux/fs.h  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/afs/flock.c~const-make-file_lock_operations-const fs/afs/flock.c
--- a/fs/afs/flock.c~const-make-file_lock_operations-const
+++ a/fs/afs/flock.c
@@ -21,7 +21,7 @@ static void afs_fl_release_private(struc
 static struct workqueue_struct *afs_lock_manager;
 static DEFINE_MUTEX(afs_lock_manager_mutex);
 
-static struct file_lock_operations afs_lock_ops = {
+static const struct file_lock_operations afs_lock_ops = {
 	.fl_copy_lock		= afs_fl_copy_lock,
 	.fl_release_private	= afs_fl_release_private,
 };
diff -puN fs/lockd/clntproc.c~const-make-file_lock_operations-const fs/lockd/clntproc.c
--- a/fs/lockd/clntproc.c~const-make-file_lock_operations-const
+++ a/fs/lockd/clntproc.c
@@ -458,7 +458,7 @@ static void nlmclnt_locks_release_privat
 	nlm_put_lockowner(fl->fl_u.nfs_fl.owner);
 }
 
-static struct file_lock_operations nlmclnt_lock_ops = {
+static const struct file_lock_operations nlmclnt_lock_ops = {
 	.fl_copy_lock = nlmclnt_locks_copy_lock,
 	.fl_release_private = nlmclnt_locks_release_private,
 };
diff -puN fs/nfs/nfs4state.c~const-make-file_lock_operations-const fs/nfs/nfs4state.c
--- a/fs/nfs/nfs4state.c~const-make-file_lock_operations-const
+++ a/fs/nfs/nfs4state.c
@@ -638,7 +638,7 @@ static void nfs4_fl_release_lock(struct 
 	nfs4_put_lock_state(fl->fl_u.nfs4_fl.owner);
 }
 
-static struct file_lock_operations nfs4_fl_lock_ops = {
+static const struct file_lock_operations nfs4_fl_lock_ops = {
 	.fl_copy_lock = nfs4_fl_copy_lock,
 	.fl_release_private = nfs4_fl_release_lock,
 };
diff -puN include/linux/fs.h~const-make-file_lock_operations-const include/linux/fs.h
--- a/include/linux/fs.h~const-make-file_lock_operations-const
+++ a/include/linux/fs.h
@@ -1066,7 +1066,7 @@ struct file_lock {
 	struct fasync_struct *	fl_fasync; /* for lease break notifications */
 	unsigned long fl_break_time;	/* for nonblocking lease breaks */
 
-	struct file_lock_operations *fl_ops;	/* Callbacks for filesystems */
+	const struct file_lock_operations *fl_ops;	/* Callbacks for filesystems */
 	struct lock_manager_operations *fl_lmops;	/* Callbacks for lockmanagers */
 	union {
 		struct nfs_lock_info	nfs_fl;
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

