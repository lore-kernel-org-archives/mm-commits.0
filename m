From: akpm@osdl.org
Subject: - user-namespace-add-the-framework-fixes.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:14:55 -0800
Message-ID: <200702010115.l111FrcN032445@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161182AbXBABQU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:16:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     user ns fixes
has been removed from the -mm tree.  Its filename was
     user-namespace-add-the-framework-fixes.patch

This patch was dropped because it was folded into user-namespace-add-the-framework.patch

------------------------------------------------------
Subject: user ns fixes
From: "Serge E. Hallyn" <serue@us.ibm.com>

Don't do user_ns permission checks when !CONFIG_USER_NS.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/user_namespace.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/linux/user_namespace.h~user-namespace-add-the-framework-fixes include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~user-namespace-add-the-framework-fixes
+++ a/include/linux/user_namespace.h
@@ -34,6 +34,16 @@ static inline void put_user_ns(struct us
 		kref_put(&ns->kref, free_user_ns);
 }
 
+static inline int clone_mnt_userns_permission(struct vfsmount *old)
+{
+	if (!(old->mnt_flags & MNT_SHARE_NS)) {
+		if (old->mnt_user_ns != current->nsproxy->user_ns)
+			return 0;
+	}
+
+	return 1;
+}
+
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
@@ -49,6 +59,11 @@ static inline int copy_user_ns(int flags
 static inline void put_user_ns(struct user_namespace *ns)
 {
 }
+
+static inline int clone_mnt_userns_permission(struct vfsmount *old)
+{
+	return 1;
+}
 #endif
 
 #endif /* _LINUX_USER_H */
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
introduce-and-use-get_task_mnt_ns.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
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
