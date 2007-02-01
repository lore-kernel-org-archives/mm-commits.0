From: akpm@osdl.org
Subject: - user_ns-handle-file-sigio.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:25:00 -0800
Message-ID: <200702010125.l111Pwed032649@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35759 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161220AbXBAB1D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:27:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, mm-commits@vger.kernel.org


The patch titled
     user_ns: handle file sigio
has been removed from the -mm tree.  Its filename was
     user_ns-handle-file-sigio.patch

This patch was dropped because an updated version will be merged

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

 fs/fcntl.c                     |   13 ++++++++++---
 fs/file_table.c                |    2 ++
 include/linux/fs.h             |    1 +
 include/linux/sched.h          |    4 +---
 include/linux/user_namespace.h |    2 +-
 5 files changed, 15 insertions(+), 7 deletions(-)

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
@@ -455,6 +460,8 @@ static const long band_table[NSIGPOLL] =
 static inline int sigio_perm(struct task_struct *p,
                              struct fown_struct *fown, int sig)
 {
+	if (fown->user_ns != p->nsproxy->user_ns)
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
@@ -686,6 +686,7 @@ struct fown_struct {
 	struct pid *pid;	/* pid or -pgrp where SIGIO should be sent */
 	enum pid_type pid_type;	/* Kind of process group SIGIO should be sent to */
 	uid_t uid, euid;	/* uid/euid of process setting the owner */
+	struct user_namespace *user_ns; /* namespace to which uid belongs */
 	int signum;		/* posix.1b rt signal to be delivered on IO */
 };
 
diff -puN include/linux/user_namespace.h~user_ns-handle-file-sigio include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~user_ns-handle-file-sigio
+++ a/include/linux/user_namespace.h
@@ -48,7 +48,7 @@ static inline int clone_mnt_userns_permi
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 {
-	return NULL;
+	return &init_user_ns;
 }
 
 static inline int copy_user_ns(int flags, struct task_struct *tsk)
diff -puN include/linux/sched.h~user_ns-handle-file-sigio include/linux/sched.h
--- a/include/linux/sched.h~user_ns-handle-file-sigio
+++ a/include/linux/sched.h
@@ -1611,12 +1611,10 @@ extern int cond_resched_softirq(void);
 static inline int task_mnt_same_uidns(struct task_struct *tsk,
 					struct vfsmount *mnt)
 {
-	if (tsk->nsproxy == init_task.nsproxy)
+	if (mnt->mnt_user_ns == tsk->nsproxy->user_ns)
 		return 1;
  	if (mnt->mnt_flags & MNT_SHARE_NS)
  		return 1;
-	if (mnt->mnt_user_ns == tsk->nsproxy->user_ns)
-		return 1;
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
uts-namespace-remove-config_uts_ns.patch
integrity-service-api-and-dummy-provider-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
