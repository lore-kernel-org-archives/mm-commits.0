From: akpm@osdl.org
Subject: + user-namespace-add-the-framework-fixes.patch added to -mm tree
Date: Fri, 05 Jan 2007 00:11:25 -0800
Message-ID: <200701050811.l058BPaj013751@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34864 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030364AbXAEILo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 03:11:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com


The patch titled
     user ns fixes
has been added to the -mm tree.  Its filename is
     user-namespace-add-the-framework-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: user ns fixes
From: "Serge E. Hallyn" <serue@us.ibm.com>

Don't do user_ns permission checks when !CONFIG_USER_NS.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h          |    8 ++++++++
 include/linux/user_namespace.h |   15 +++++++++++++++
 2 files changed, 23 insertions(+)

diff -puN include/linux/sched.h~user-namespace-add-the-framework-fixes include/linux/sched.h
--- a/include/linux/sched.h~user-namespace-add-the-framework-fixes
+++ a/include/linux/sched.h
@@ -1582,6 +1582,7 @@ extern int cond_resched(void);
 extern int cond_resched_lock(spinlock_t * lock);
 extern int cond_resched_softirq(void);
 
+#ifdef CONFIG_USER_NS
 /*
  * Does a critical section need to be broken due to another
  * task waiting?:
@@ -1602,6 +1603,13 @@ static inline int lock_need_resched(spin
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
 
 /* Reevaluate whether the task has signals pending delivery.
    This is required every time the blocked sigset_t changes.
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
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-namespace-add-the-framework-fixes.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user-ns-implement-shared-mounts-fixes.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
user-ns-always-on.patch
integrity-service-api-and-dummy-provider-fix.patch
