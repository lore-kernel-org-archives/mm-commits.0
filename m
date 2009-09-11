From: akpm@linux-foundation.org
Subject: + const-make-file_lock_operations-const.patch added to -mm tree
Date: Fri, 11 Sep 2009 13:27:24 -0700
Message-ID: <200909112027.n8BKROp8018854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876AbZIKU1n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 16:27:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     const: make file_lock_operations const
has been added to the -mm tree.  Its filename is
     const-make-file_lock_operations-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1068,7 +1068,7 @@ struct file_lock {
 	struct fasync_struct *	fl_fasync; /* for lease break notifications */
 	unsigned long fl_break_time;	/* for nonblocking lease breaks */
 
-	struct file_lock_operations *fl_ops;	/* Callbacks for filesystems */
+	const struct file_lock_operations *fl_ops;	/* Callbacks for filesystems */
 	struct lock_manager_operations *fl_lmops;	/* Callbacks for lockmanagers */
 	union {
 		struct nfs_lock_info	nfs_fl;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
pcmcia-switch-proc-bus-pccard-drivers-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
const-make-struct-super_block-dq_op-const.patch
const-make-struct-super_block-s_qcop-const.patch
const-mark-remaining-super_operations-const.patch
const-mark-remaining-export_operations-const.patch
const-mark-remaining-address_space_operations-const.patch
const-mark-remaining-inode_operations-as-const.patch
const-make-file_lock_operations-const.patch
const-make-lock_manager_operations-const.patch
const-make-block_device_operations-const.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
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

