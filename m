From: akpm@osdl.org
Subject: + nsproxy-externalizes-exit_task_namespaces-fix.patch added to -mm tree
Date: Fri, 26 Jan 2007 12:49:42 -0800
Message-ID: <200701262049.l0QKngAN026149@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54798 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbXAZU4D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 15:56:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com


The patch titled
     namespaces: resolve conflicts between two patches
has been added to the -mm tree.  Its filename is
     nsproxy-externalizes-exit_task_namespaces-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: namespaces: resolve conflicts between two patches
From: "Serge E. Hallyn" <serue@us.ibm.com>

Two patches affecting nsproxy conflicted preventing compilation.  Hopefully
this resolves all the problems.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/nsproxy.h |    8 ++------
 kernel/nsproxy.c        |    5 +++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN include/linux/nsproxy.h~nsproxy-externalizes-exit_task_namespaces-fix include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~nsproxy-externalizes-exit_task_namespaces-fix
+++ a/include/linux/nsproxy.h
@@ -50,11 +50,7 @@ static inline void put_and_finalize_nspr
 	finalize_put_nsproxy(put_nsproxy(ns));
 }
 
-static inline struct nsproxy *preexit_task_namespaces(struct task_struct *p)
-{
-	return put_nsproxy(p->nsproxy);
-}
-
-extern void exit_task_namespaces(struct task_struct *p);
+extern struct nsproxy *preexit_task_namespaces(struct task_struct *p);
+extern void exit_task_namespaces(struct task_struct *p, struct nsproxy *ns);
 
 #endif
diff -puN kernel/nsproxy.c~nsproxy-externalizes-exit_task_namespaces-fix kernel/nsproxy.c
--- a/kernel/nsproxy.c~nsproxy-externalizes-exit_task_namespaces-fix
+++ a/kernel/nsproxy.c
@@ -157,6 +157,11 @@ struct nsproxy *put_nsproxy(struct nspro
 	return NULL;
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

fix-null-nsproxy-dereference-in-proc-mounts.patch
namespaces-fix-exit-race-by-splitting-exit.patch
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
integrity-service-api-and-dummy-provider-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
