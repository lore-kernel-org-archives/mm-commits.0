From: akpm@linux-foundation.org
Subject: + locks-add-lock-cancel-command.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:41:00 -0700
Message-ID: <200704070541.l375f0fo028407@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45343 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965378AbXDGFlN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:41:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no


The patch titled
     locks: add lock cancel command
has been added to the -mm tree.  Its filename is
     locks-add-lock-cancel-command.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: locks: add lock cancel command
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

Lock managers need to be able to cancel pending lock requests.  In the case
where the exported filesystem manages its own locks, it's not sufficient just
to call posix_unblock_lock(); we need to let the filesystem know what's
happening too.

We do this by adding a new fcntl lock command: FL_CANCELLK.  Some day this
might also be made available to userspace applications that could benefit from
an asynchronous locking api.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c            |   17 +++++++++++++++++
 include/linux/fcntl.h |    4 ++++
 include/linux/fs.h    |    1 +
 3 files changed, 22 insertions(+)

diff -puN fs/locks.c~locks-add-lock-cancel-command fs/locks.c
--- a/fs/locks.c~locks-add-lock-cancel-command
+++ a/fs/locks.c
@@ -2041,6 +2041,23 @@ posix_unblock_lock(struct file *filp, st
 
 EXPORT_SYMBOL(posix_unblock_lock);
 
+/**
+ * vfs_cancel_lock - file byte range unblock lock
+ * @filp: The file to apply the unblock to
+ * @fl: The lock to be unblocked
+ *
+ * Used by lock managers to cancel blocked requests
+ */
+int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
+{
+	if (filp->f_op && filp->f_op->lock)
+		return filp->f_op->lock(filp, F_CANCELLK, fl);
+	else
+		return posix_unblock_lock(filp, fl);
+}
+
+EXPORT_SYMBOL_GPL(vfs_cancel_lock);
+
 static void lock_get_status(char* out, struct file_lock *fl, int id, char *pfx)
 {
 	struct inode *inode = NULL;
diff -puN include/linux/fcntl.h~locks-add-lock-cancel-command include/linux/fcntl.h
--- a/include/linux/fcntl.h~locks-add-lock-cancel-command
+++ a/include/linux/fcntl.h
@@ -3,6 +3,10 @@
 
 #include <asm/fcntl.h>
 
+/* Cancel a blocking posix lock; internal use only until we expose an
+ * asynchronous lock api to userspace: */
+#define F_CANCELLK	(F_LINUX_SPECIFIC_BASE+5)
+
 #define F_SETLEASE	(F_LINUX_SPECIFIC_BASE+0)
 #define F_GETLEASE	(F_LINUX_SPECIFIC_BASE+1)
 
diff -puN include/linux/fs.h~locks-add-lock-cancel-command include/linux/fs.h
--- a/include/linux/fs.h~locks-add-lock-cancel-command
+++ a/include/linux/fs.h
@@ -859,6 +859,7 @@ extern int posix_lock_file_wait(struct f
 extern int posix_unblock_lock(struct file *, struct file_lock *);
 extern int vfs_test_lock(struct file *, struct file_lock *);
 extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
+extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
 extern int flock_lock_file_wait(struct file *filp, struct file_lock *fl);
 extern int __break_lease(struct inode *inode, unsigned int flags);
 extern void lease_get_mtime(struct inode *, struct timespec *time);
_

Patches currently in -mm which might be from eshel@almaden.ibm.com are

locks-trivial-removal-of-unnecessary-parentheses.patch
locks-create-posix-to-flock-helper-functions.patch
locks-make-lock-release-private-data-before-returning-in-getlk-case.patch
locks-give-posix_test_lock-same-interface-as-lock.patch
locks-factor-out-generic-filesystem-switch-from-test_lock.patch
locks-factor-out-generic-filesystem-switch-from-setlock-code.patch
locks-allow-vfsposix_lock_file-to-return-conflicting-lock.patch
locks-add-fl_notify-arguments-for-asynchronous-lock-return.patch
locks-add-lock-cancel-command.patch
nfsd4-convert-nfsv4-to-new-lock-interface.patch
lockd-save-lock-state-on-deferral.patch
lockd-handle-fl_notify-callbacks.patch
lockd-pass-cookie-in-nlmsvc_testlock.patch
lockd-handle-test_lock-deferrals.patch
lockd-always-preallocate-block-in-nlmsvc_lock.patch
lockd-add-code-to-handle-deferred-lock-requests.patch
gfs2-nfs-lock-support-for-gfs2.patch
