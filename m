From: akpm@osdl.org
Subject: - user-ns-implement-user-ns-unshare-remove-config_user_ns.patch removed from -mm tree
Date: Thu, 25 Jan 2007 00:16:17 -0800
Message-ID: <200701250816.l0P8GHlF010003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53861 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965701AbXAYIXH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 03:23:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     user_ns: remove CONFIG_USER_NS
has been removed from the -mm tree.  Its filename was
     user-ns-implement-user-ns-unshare-remove-config_user_ns.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: user_ns: remove CONFIG_USER_NS
From: Cedric Le Goater <clg@fr.ibm.com>

It doesn't look that useful anyway, it just deactivates the unshare
capability for the user namespace.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h          |    9 --------
 include/linux/user_namespace.h |   33 -------------------------------
 init/Kconfig                   |    8 -------
 kernel/user_namespace.c        |    3 --
 4 files changed, 53 deletions(-)

diff -puN include/linux/sched.h~user-ns-implement-user-ns-unshare-remove-config_user_ns include/linux/sched.h
--- a/include/linux/sched.h~user-ns-implement-user-ns-unshare-remove-config_user_ns
+++ a/include/linux/sched.h
@@ -1599,7 +1599,6 @@ extern int cond_resched(void);
 extern int cond_resched_lock(spinlock_t * lock);
 extern int cond_resched_softirq(void);
 
-#ifdef CONFIG_USER_NS
 /*
  * Check whether a task and a vfsmnt belong to the same uidns.
  * Since the initial namespace is exempt from these checks,
@@ -1618,14 +1617,6 @@ static inline int task_mnt_same_uidns(st
 		return 1;
 	return 0;
 }
-#else
-static inline int task_mnt_same_uidns(struct task_struct *tsk,
-					struct vfsmount *mnt)
-{
-	return 1;
-}
-#endif
-
 
 /*
  * Does a critical section need to be broken due to another
diff -puN include/linux/user_namespace.h~user-ns-implement-user-ns-unshare-remove-config_user_ns include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~user-ns-implement-user-ns-unshare-remove-config_user_ns
+++ a/include/linux/user_namespace.h
@@ -16,8 +16,6 @@ struct user_namespace {
 
 extern struct user_namespace init_user_ns;
 
-#ifdef CONFIG_USER_NS
-
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 {
 	if (ns)
@@ -45,35 +43,4 @@ static inline int clone_mnt_userns_permi
 	return 1;
 }
 
-#else
-
-static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
-{
-	return &init_user_ns;
-}
-
-static inline int unshare_user_ns(unsigned long flags,
-			 struct user_namespace **new_user)
-{
-	if (flags & CLONE_NEWUSER)
-		return -EINVAL;
-
-	return 0;
-}
-
-static inline int copy_user_ns(int flags, struct task_struct *tsk)
-{
-	return 0;
-}
-
-static inline void put_user_ns(struct user_namespace *ns)
-{
-}
-
-static inline int clone_mnt_userns_permission(struct vfsmount *old)
-{
-	return 1;
-}
-#endif
-
 #endif /* _LINUX_USER_H */
diff -puN init/Kconfig~user-ns-implement-user-ns-unshare-remove-config_user_ns init/Kconfig
--- a/init/Kconfig~user-ns-implement-user-ns-unshare-remove-config_user_ns
+++ a/init/Kconfig
@@ -222,14 +222,6 @@ config UTS_NS
 	  vservers, to use uts namespaces to provide different
 	  uts info for different servers.  If unsure, say N.
 
-config USER_NS
-	bool "User Namespaces"
-	default n
-	help
-	  Support user namespaces.  This allows containers, i.e.
-	  vservers, to use user namespaces to provide different
-	  user info for different servers.  If unsure, say N.
-
 config AUDIT
 	bool "Auditing support"
 	depends on NET
diff -puN kernel/user_namespace.c~user-ns-implement-user-ns-unshare-remove-config_user_ns kernel/user_namespace.c
--- a/kernel/user_namespace.c~user-ns-implement-user-ns-unshare-remove-config_user_ns
+++ a/kernel/user_namespace.c
@@ -19,7 +19,6 @@ struct user_namespace init_user_ns = {
 
 EXPORT_SYMBOL_GPL(init_user_ns);
 
-#ifdef CONFIG_USER_NS
 /*
  * Clone a new ns copying an original user ns, setting refcount to 1
  * @old_ns: namespace to clone
@@ -110,5 +109,3 @@ void free_user_ns(struct kref *kref)
 	ns = container_of(kref, struct user_namespace, kref);
 	kfree(ns);
 }
-
-#endif /* CONFIG_USER_NS */
_

Patches currently in -mm which might be from clg@fr.ibm.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user_ns-handle-file-sigio-fix.patch
user-ns-implement-user-ns-unshare-remove-config_user_ns.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
uts-namespace-remove-config_uts_ns.patch
ipc-namespace-remove-config_ipc_ns.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
