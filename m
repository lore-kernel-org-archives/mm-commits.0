From: akpm@osdl.org
Subject: - nsproxy-externalizes-exit_task_namespaces-fix.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:14:24 -0800
Message-ID: <200702010115.l111FMMM032428@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35230 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161181AbXBABPb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:15:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     namespaces: resolve conflicts between two patches
has been removed from the -mm tree.  Its filename was
     nsproxy-externalizes-exit_task_namespaces-fix.patch

This patch was dropped because it was folded into nsproxy-externalizes-exit_task_namespaces.patch

------------------------------------------------------
Subject: namespaces: resolve conflicts between two patches
From: "Serge E. Hallyn" <serue@us.ibm.com>

Two patches affecting nsproxy conflicted preventing compilation.  Hopefully
this resolves all the problems.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/nsproxy.h |    1 +
 kernel/nsproxy.c        |    5 +++++
 2 files changed, 6 insertions(+)

diff -puN include/linux/nsproxy.h~nsproxy-externalizes-exit_task_namespaces-fix include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~nsproxy-externalizes-exit_task_namespaces-fix
+++ a/include/linux/nsproxy.h
@@ -38,6 +38,7 @@ void get_task_namespaces(struct task_str
 void free_nsproxy(struct nsproxy *ns);
 struct mnt_namespace *get_task_mnt_ns(struct task_struct *tsk);
 void exit_task_namespaces(struct task_struct *p, struct nsproxy *ns);
+struct nsproxy *preexit_task_namespaces(struct task_struct *p);
 
 static inline void finalize_put_nsproxy(struct nsproxy *ns)
 {
diff -puN kernel/nsproxy.c~nsproxy-externalizes-exit_task_namespaces-fix kernel/nsproxy.c
--- a/kernel/nsproxy.c~nsproxy-externalizes-exit_task_namespaces-fix
+++ a/kernel/nsproxy.c
@@ -143,6 +143,11 @@ out_ns:
 	goto out;
 }
 
+struct nsproxy *preexit_task_namespaces(struct task_struct *p)
+{
+	return put_nsproxy(p->nsproxy);
+}
+
 void free_nsproxy(struct nsproxy *ns)
 {
 	if (ns->mnt_ns)
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
introduce-and-use-get_task_mnt_ns.patch
nsproxy-externalizes-exit_task_namespaces.patch
nsproxy-externalizes-exit_task_namespaces-fix.patch
nsproxy-externalizes-exit_task_namespaces-fix-fix.patch
nsproxy-externalizes-exit_task_namespaces-fix-42.patch
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
