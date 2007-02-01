From: akpm@osdl.org
Subject: - user_ns-handle-file-sigio-fix-2.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:16:11 -0800
Message-ID: <200702010117.l111H9bx032480@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35416 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161191AbXBABVA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:21:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, mm-commits@vger.kernel.org


The patch titled
     user namespace: remove exceptions for initial namespace
has been removed from the -mm tree.  Its filename was
     user_ns-handle-file-sigio-fix-2.patch

This patch was dropped because it was folded into user_ns-handle-file-sigio.patch

------------------------------------------------------
Subject: user namespace: remove exceptions for initial namespace
From: Serge E. Hallyn <serue@us.ibm.com>

Both sigio and file access checks for user namespace equivalence were being
skipped for processes in the initial namespace.  Remove these exceptions,
enforcing the same cross-namespace checks for all processes in all user
namespaces.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/fcntl.c            |    3 +--
 include/linux/sched.h |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/fcntl.c~user_ns-handle-file-sigio-fix-2 fs/fcntl.c
--- a/fs/fcntl.c~user_ns-handle-file-sigio-fix-2
+++ a/fs/fcntl.c
@@ -460,8 +460,7 @@ static const long band_table[NSIGPOLL] =
 static inline int sigio_perm(struct task_struct *p,
                              struct fown_struct *fown, int sig)
 {
-	if (fown->user_ns != init_task.nsproxy->user_ns &&
-				fown->user_ns != p->nsproxy->user_ns)
+	if (fown->user_ns != p->nsproxy->user_ns)
 		return 0;
 	return (((fown->euid == 0) ||
 		 (fown->euid == p->suid) || (fown->euid == p->uid) ||
diff -puN include/linux/sched.h~user_ns-handle-file-sigio-fix-2 include/linux/sched.h
--- a/include/linux/sched.h~user_ns-handle-file-sigio-fix-2
+++ a/include/linux/sched.h
@@ -1609,12 +1609,10 @@ extern int cond_resched_softirq(void);
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
introduce-and-use-get_task_mnt_ns.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix-2.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
uts-namespace-remove-config_uts_ns.patch
ipc-namespace-remove-config_ipc_ns.patch
ipc-namespace-remove-config_ipc_ns-linkage-fix.patch
ipc-namespace-remove-config_ipc_ns-linkage-fix-fix.patch
integrity-service-api-and-dummy-provider-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
