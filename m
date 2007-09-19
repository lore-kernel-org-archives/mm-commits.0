From: akpm@linux-foundation.org
Subject: + cleanup-macros-for-distinguishing-mandatory-locks.patch added to -mm tree
Date: Wed, 19 Sep 2007 16:51:07 -0700
Message-ID: <200709192351.l8JNp8AF019001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbXISXwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 19:52:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, bfields@fieldses.org, dhowells@redhat.com, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov, swhiteho@redhat.com, trond.myklebust@fys.uio.no


The patch titled
     Cleanup macros for distinguishing mandatory locks
has been added to the -mm tree.  Its filename is
     cleanup-macros-for-distinguishing-mandatory-locks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Cleanup macros for distinguishing mandatory locks
From: Pavel Emelyanov <xemul@openvz.org>

The combination of S_ISGID bit set and S_IXGRP bit unset is used to mark the
inode as "mandatory lockable" and there's a macro for this check called
MANDATORY_LOCK(inode).  However, fs/locks.c and some filesystems still perform
the explicit i_mode checking.  Besides, Andrew pointed out, that this macro is
buggy itself, as it dereferences the inode arg twice.

Convert this macro into static inline function and switch its users to it,
making the code shorter and more readable.

The __mandatory_lock() helper is to be used in places where the IS_MANDLOCK()
for superblock is already known to be true.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c          |   14 ++++----------
 fs/nfsd/nfs4state.c |    2 +-
 fs/nfsd/vfs.c       |    2 +-
 fs/read_write.c     |    2 +-
 include/linux/fs.h  |   21 +++++++++++++++++----
 5 files changed, 24 insertions(+), 17 deletions(-)

diff -puN fs/locks.c~cleanup-macros-for-distinguishing-mandatory-locks fs/locks.c
--- a/fs/locks.c~cleanup-macros-for-distinguishing-mandatory-locks
+++ a/fs/locks.c
@@ -1115,7 +1115,7 @@ int locks_mandatory_area(int read_write,
 			 * If we've been sleeping someone might have
 			 * changed the permissions behind our back.
 			 */
-			if ((inode->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
+			if (__mandatory_lock(inode))
 				continue;
 		}
 
@@ -1754,9 +1754,7 @@ int fcntl_setlk(unsigned int fd, struct 
 	/* Don't allow mandatory locks on files that may be memory mapped
 	 * and shared.
 	 */
-	if (IS_MANDLOCK(inode) &&
-	    (inode->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID &&
-	    mapping_writably_mapped(filp->f_mapping)) {
+	if (mandatory_lock(inode) && mapping_writably_mapped(filp->f_mapping)) {
 		error = -EAGAIN;
 		goto out;
 	}
@@ -1880,9 +1878,7 @@ int fcntl_setlk64(unsigned int fd, struc
 	/* Don't allow mandatory locks on files that may be memory mapped
 	 * and shared.
 	 */
-	if (IS_MANDLOCK(inode) &&
-	    (inode->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID &&
-	    mapping_writably_mapped(filp->f_mapping)) {
+	if (mandatory_lock(inode) && mapping_writably_mapped(filp->f_mapping)) {
 		error = -EAGAIN;
 		goto out;
 	}
@@ -2076,9 +2072,7 @@ static void lock_get_status(char* out, s
 		out += sprintf(out, "%6s %s ",
 			     (fl->fl_flags & FL_ACCESS) ? "ACCESS" : "POSIX ",
 			     (inode == NULL) ? "*NOINODE*" :
-			     (IS_MANDLOCK(inode) &&
-			      (inode->i_mode & (S_IXGRP | S_ISGID)) == S_ISGID) ?
-			     "MANDATORY" : "ADVISORY ");
+			     mandatory_lock(inode) ? "MANDATORY" : "ADVISORY ");
 	} else if (IS_FLOCK(fl)) {
 		if (fl->fl_type & LOCK_MAND) {
 			out += sprintf(out, "FLOCK  MSNFS     ");
diff -puN fs/nfsd/nfs4state.c~cleanup-macros-for-distinguishing-mandatory-locks fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~cleanup-macros-for-distinguishing-mandatory-locks
+++ a/fs/nfsd/nfs4state.c
@@ -2030,7 +2030,7 @@ static inline int
 io_during_grace_disallowed(struct inode *inode, int flags)
 {
 	return nfs4_in_grace() && (flags & (RD_STATE | WR_STATE))
-		&& MANDATORY_LOCK(inode);
+		&& mandatory_lock(inode);
 }
 
 /*
diff -puN fs/nfsd/vfs.c~cleanup-macros-for-distinguishing-mandatory-locks fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~cleanup-macros-for-distinguishing-mandatory-locks
+++ a/fs/nfsd/vfs.c
@@ -65,7 +65,7 @@
  * locks on them because there is no way to know if the accesser has
  * the lock.
  */
-#define IS_ISMNDLK(i)	(S_ISREG((i)->i_mode) && MANDATORY_LOCK(i))
+#define IS_ISMNDLK(i)	(S_ISREG((i)->i_mode) && mandatory_lock(i))
 
 /*
  * This is a cache of readahead params that help us choose the proper
diff -puN fs/read_write.c~cleanup-macros-for-distinguishing-mandatory-locks fs/read_write.c
--- a/fs/read_write.c~cleanup-macros-for-distinguishing-mandatory-locks
+++ a/fs/read_write.c
@@ -205,7 +205,7 @@ int rw_verify_area(int read_write, struc
 	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
 		goto Einval;
 
-	if (unlikely(inode->i_flock && MANDATORY_LOCK(inode))) {
+	if (unlikely(inode->i_flock && mandatory_lock(inode))) {
 		int retval = locks_mandatory_area(
 			read_write == READ ? FLOCK_VERIFY_READ : FLOCK_VERIFY_WRITE,
 			inode, file, pos, count);
diff -puN include/linux/fs.h~cleanup-macros-for-distinguishing-mandatory-locks include/linux/fs.h
--- a/include/linux/fs.h~cleanup-macros-for-distinguishing-mandatory-locks
+++ a/include/linux/fs.h
@@ -1486,12 +1486,25 @@ extern int locks_mandatory_area(int, str
  * Candidates for mandatory locking have the setgid bit set
  * but no group execute bit -  an otherwise meaningless combination.
  */
-#define MANDATORY_LOCK(inode) \
-	(IS_MANDLOCK(inode) && ((inode)->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
+
+static inline int __mandatory_lock(struct inode *ino)
+{
+	return (ino->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID;
+}
+
+/*
+ * ... and these candidates should be on MS_MANDLOCK mounted fs,
+ * otherwise these will be advisory locks
+ */
+
+static inline int mandatory_lock(struct inode *ino)
+{
+	return IS_MANDLOCK(ino) && __mandatory_lock(ino);
+}
 
 static inline int locks_verify_locked(struct inode *inode)
 {
-	if (MANDATORY_LOCK(inode))
+	if (mandatory_lock(inode))
 		return locks_mandatory_locked(inode);
 	return 0;
 }
@@ -1502,7 +1515,7 @@ static inline int locks_verify_truncate(
 				    struct file *filp,
 				    loff_t size)
 {
-	if (inode->i_flock && MANDATORY_LOCK(inode))
+	if (inode->i_flock && mandatory_lock(inode))
 		return locks_mandatory_area(
 			FLOCK_VERIFY_WRITE, inode, filp,
 			size < inode->i_size ? size : inode->i_size,
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
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
