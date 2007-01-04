From: akpm@osdl.org
Subject: + user_ns-handle-file-sigio.patch added to -mm tree
Date: Thu, 04 Jan 2007 14:10:36 -0800
Message-ID: <200701042210.l04MAbrK000448@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:58339 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965088AbXADWNN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 17:13:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at


The patch titled
     user_ns: handle file sigio
has been added to the -mm tree.  Its filename is
     user_ns-handle-file-sigio.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: user_ns: handle file sigio


A process in one user namespace could set a fowner and sigio on a file in a
shared vfsmount, ending up killing a task in another user namespace.

Prevent this by adding a user namespace pointer to the fown_struct, and
enforcing that a process causing a signal to be sent be in the same user
namespace as the file owner.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/fcntl.c         |   14 +++++++++++---
 fs/file_table.c    |    2 ++
 include/linux/fs.h |    1 +
 3 files changed, 14 insertions(+), 3 deletions(-)

diff -puN fs/fcntl.c~user_ns-handle-file-sigio fs/fcntl.c
--- a/fs/fcntl.c~user_ns-handle-file-sigio
+++ a/fs/fcntl.c
@@ -18,6 +18,7 @@
 #include <linux/ptrace.h>
 #include <linux/signal.h>
 #include <linux/rcupdate.h>
+#include <linux/user_namespace.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
@@ -250,15 +251,18 @@ static int setfl(int fd, struct file * f
 }
 
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
-                     uid_t uid, uid_t euid, int force)
+		     uid_t uid, uid_t euid, struct user_namespace *user_ns,
+								 int force)
 {
 	write_lock_irq(&filp->f_owner.lock);
 	if (force || !filp->f_owner.pid) {
 		put_pid(filp->f_owner.pid);
+		put_user_ns(filp->f_owner.user_ns);
 		filp->f_owner.pid = get_pid(pid);
 		filp->f_owner.pid_type = type;
 		filp->f_owner.uid = uid;
 		filp->f_owner.euid = euid;
+		filp->f_owner.user_ns = get_user_ns(user_ns);
 	}
 	write_unlock_irq(&filp->f_owner.lock);
 }
@@ -272,7 +276,8 @@ int __f_setown(struct file *filp, struct
 	if (err)
 		return err;
 
-	f_modown(filp, pid, type, current->uid, current->euid, force);
+	f_modown(filp, pid, type, current->uid, current->euid,
+				 current->nsproxy->user_ns, force);
 	return 0;
 }
 EXPORT_SYMBOL(__f_setown);
@@ -298,7 +303,7 @@ EXPORT_SYMBOL(f_setown);
 
 void f_delown(struct file *filp)
 {
-	f_modown(filp, NULL, PIDTYPE_PID, 0, 0, 1);
+	f_modown(filp, NULL, PIDTYPE_PID, 0, 0, NULL, 1);
 }
 
 pid_t f_getown(struct file *filp)
@@ -455,6 +460,9 @@ static const long band_table[NSIGPOLL] =
 static inline int sigio_perm(struct task_struct *p,
                              struct fown_struct *fown, int sig)
 {
+	if (fown->user_ns != init_task.nsproxy->user_ns &&
+				fown->user_ns != p->nsproxy->user_ns)
+		return 0;
 	return (((fown->euid == 0) ||
 		 (fown->euid == p->suid) || (fown->euid == p->uid) ||
 		 (fown->uid == p->suid) || (fown->uid == p->uid)) &&
diff -puN fs/file_table.c~user_ns-handle-file-sigio fs/file_table.c
--- a/fs/file_table.c~user_ns-handle-file-sigio
+++ a/fs/file_table.c
@@ -21,6 +21,7 @@
 #include <linux/fsnotify.h>
 #include <linux/sysctl.h>
 #include <linux/percpu_counter.h>
+#include <linux/user_namespace.h>
 
 #include <asm/atomic.h>
 
@@ -175,6 +176,7 @@ void fastcall __fput(struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		put_write_access(inode);
 	put_pid(file->f_owner.pid);
+	put_user_ns(file->f_owner.user_ns);
 	file_kill(file);
 	file->f_path.dentry = NULL;
 	file->f_path.mnt = NULL;
diff -puN include/linux/fs.h~user_ns-handle-file-sigio include/linux/fs.h
--- a/include/linux/fs.h~user_ns-handle-file-sigio
+++ a/include/linux/fs.h
@@ -684,6 +684,7 @@ struct fown_struct {
 	struct pid *pid;	/* pid or -pgrp where SIGIO should be sent */
 	enum pid_type pid_type;	/* Kind of process group SIGIO should be sent to */
 	uid_t uid, euid;	/* uid/euid of process setting the owner */
+	struct user_namespace *user_ns; /* namespace to which uid belongs */
 	int signum;		/* posix.1b rt signal to be delivered on IO */
 };
 
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
