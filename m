From: akpm@osdl.org
Subject: - user-ns-add-user_namespace-ptr-to-vfsmount-fixes.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:15:07 -0800
Message-ID: <200702010116.l111G5kg032451@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35255 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161184AbXBABQM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:16:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     user ns fixes
has been removed from the -mm tree.  Its filename was
     user-ns-add-user_namespace-ptr-to-vfsmount-fixes.patch

This patch was dropped because it was folded into user-ns-add-user_namespace-ptr-to-vfsmount.patch

------------------------------------------------------
Subject: user ns fixes
From: "Serge E. Hallyn" <serue@us.ibm.com>

Don't do user_ns permission checks when !CONFIG_USER_NS.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/sched.h~user-ns-add-user_namespace-ptr-to-vfsmount-fixes include/linux/sched.h
--- a/include/linux/sched.h~user-ns-add-user_namespace-ptr-to-vfsmount-fixes
+++ a/include/linux/sched.h
@@ -1598,6 +1598,7 @@ extern int cond_resched(void);
 extern int cond_resched_lock(spinlock_t * lock);
 extern int cond_resched_softirq(void);
 
+#ifdef CONFIG_USER_NS
 /*
  * Check whether a task and a vfsmnt belong to the same uidns.
  * Since the initial namespace is exempt from these checks,
@@ -1614,6 +1615,13 @@ static inline int task_mnt_same_uidns(st
 		return 1;
 	return 0;
 }
+#else
+static inline int task_mnt_same_uidns(struct task_struct *tsk,
+					struct vfsmount *mnt)
+{
+	return 1;
+}
+#endif
 
 
 /*
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
introduce-and-use-get_task_mnt_ns.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
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
