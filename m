From: akpm@osdl.org
Subject: - namespaces-fix-exit-race-by-splitting-exit.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:46:22 -0800
Message-ID: <200701302146.l0ULkMJD030095@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52011 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbXA3VsA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:48:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, clg@fr.ibm.com, daniel@hozac.com, ebiederm@xmission.com, herbert@13thfloor.at, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     namespaces: fix exit race by splitting exit
has been removed from the -mm tree.  Its filename was
     namespaces-fix-exit-race-by-splitting-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: namespaces: fix exit race by splitting exit
From: Serge E. Hallyn <serue@us.ibm.com>

Fix exit race by splitting the nsproxy putting into two pieces.  First
piece reduces the nsproxy refcount.  If we dropped the last reference, then
it puts the mnt_ns, and returns the nsproxy as a hint to the caller.  Else
it returns NULL.  The second piece of exiting task namespaces sets
tsk->nsproxy to NULL, and drops the references to other namespaces and
frees the nsproxy only if an nsproxy was passed in.

A little awkward and should probably be reworked, but hopefully it fixes
the NFS oops.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Daniel Hokka Zakrisson <daniel@hozac.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/nsproxy.h |   30 +++++++++++++++++++-----------
 kernel/exit.c           |    6 ++++--
 kernel/fork.c           |    4 ++--
 kernel/nsproxy.c        |   16 +++++++++++++++-
 4 files changed, 40 insertions(+), 16 deletions(-)

diff -puN include/linux/nsproxy.h~namespaces-fix-exit-race-by-splitting-exit include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~namespaces-fix-exit-race-by-splitting-exit
+++ a/include/linux/nsproxy.h
@@ -35,22 +35,30 @@ struct nsproxy *dup_namespaces(struct ns
 int copy_namespaces(int flags, struct task_struct *tsk);
 void get_task_namespaces(struct task_struct *tsk);
 void free_nsproxy(struct nsproxy *ns);
+struct nsproxy *put_nsproxy(struct nsproxy *ns);
 
-static inline void put_nsproxy(struct nsproxy *ns)
+static inline void finalize_put_nsproxy(struct nsproxy *ns)
 {
-	if (atomic_dec_and_test(&ns->count)) {
+	if (ns)
 		free_nsproxy(ns);
-	}
 }
 
-static inline void exit_task_namespaces(struct task_struct *p)
+static inline void put_and_finalize_nsproxy(struct nsproxy *ns)
 {
-	struct nsproxy *ns = p->nsproxy;
-	if (ns) {
-		task_lock(p);
-		p->nsproxy = NULL;
-		task_unlock(p);
-		put_nsproxy(ns);
-	}
+	finalize_put_nsproxy(put_nsproxy(ns));
+}
+
+static inline struct nsproxy *preexit_task_namespaces(struct task_struct *p)
+{
+	return put_nsproxy(p->nsproxy);
+}
+
+static inline void exit_task_namespaces(struct task_struct *p,
+						struct nsproxy *ns)
+{
+	task_lock(p);
+	p->nsproxy = NULL;
+	task_unlock(p);
+	finalize_put_nsproxy(ns);
 }
 #endif
diff -puN kernel/exit.c~namespaces-fix-exit-race-by-splitting-exit kernel/exit.c
--- a/kernel/exit.c~namespaces-fix-exit-race-by-splitting-exit
+++ a/kernel/exit.c
@@ -396,7 +396,7 @@ void daemonize(const char *name, ...)
 	current->fs = fs;
 	atomic_inc(&fs->count);
 
-	exit_task_namespaces(current);
+	put_and_finalize_nsproxy(current->nsproxy);
 	current->nsproxy = init_task.nsproxy;
 	get_task_namespaces(current);
 
@@ -853,6 +853,7 @@ static void exit_notify(struct task_stru
 fastcall NORET_TYPE void do_exit(long code)
 {
 	struct task_struct *tsk = current;
+	struct nsproxy *ns;
 	int group_dead;
 
 	profile_task_exit(tsk);
@@ -938,8 +939,9 @@ fastcall NORET_TYPE void do_exit(long co
 
 	tsk->exit_code = code;
 	proc_exit_connector(tsk);
+	ns = preexit_task_namespaces(tsk);
 	exit_notify(tsk);
-	exit_task_namespaces(tsk);
+	exit_task_namespaces(tsk, ns);
 #ifdef CONFIG_NUMA
 	mpol_free(tsk->mempolicy);
 	tsk->mempolicy = NULL;
diff -puN kernel/fork.c~namespaces-fix-exit-race-by-splitting-exit kernel/fork.c
--- a/kernel/fork.c~namespaces-fix-exit-race-by-splitting-exit
+++ a/kernel/fork.c
@@ -1265,7 +1265,7 @@ static struct task_struct *copy_process(
 	return p;
 
 bad_fork_cleanup_namespaces:
-	exit_task_namespaces(p);
+	put_and_finalize_nsproxy(p->nsproxy);
 bad_fork_cleanup_keys:
 	exit_keys(p);
 bad_fork_cleanup_mm:
@@ -1711,7 +1711,7 @@ asmlinkage long sys_unshare(unsigned lon
 	}
 
 	if (new_nsproxy)
-		put_nsproxy(new_nsproxy);
+		put_and_finalize_nsproxy(new_nsproxy);
 
 bad_unshare_cleanup_ipc:
 	if (new_ipc)
diff -puN kernel/nsproxy.c~namespaces-fix-exit-race-by-splitting-exit kernel/nsproxy.c
--- a/kernel/nsproxy.c~namespaces-fix-exit-race-by-splitting-exit
+++ a/kernel/nsproxy.c
@@ -117,7 +117,7 @@ int copy_namespaces(int flags, struct ta
 		goto out_pid;
 
 out:
-	put_nsproxy(old_ns);
+	put_and_finalize_nsproxy(old_ns);
 	return err;
 
 out_pid:
@@ -135,6 +135,20 @@ out_ns:
 	goto out;
 }
 
+struct nsproxy *put_nsproxy(struct nsproxy *ns)
+{
+	if (ns) {
+		if (atomic_dec_and_test(&ns->count)) {
+			if (ns->mnt_ns) {
+				put_mnt_ns(ns->mnt_ns);
+				ns->mnt_ns = NULL;
+			}
+			return ns;
+		}
+	}
+	return NULL;
+}
+
 void free_nsproxy(struct nsproxy *ns)
 {
 	if (ns->mnt_ns)
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
introduce-and-use-get_task_mnt_ns.patch
introduce-and-use-get_task_mnt_ns-tweaks.patch
nsproxy-externalizes-exit_task_namespaces.patch
nsproxy-externalizes-exit_task_namespaces-fix.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-namespace-add-the-framework-fixes.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-add-user_namespace-ptr-to-vfsmount-fixes.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user-ns-implement-shared-mounts-fixes.patch
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix.patch
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
