From: akpm@linux-foundation.org
Subject: - user-namespace-add-unshare.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:40 -0700
Message-ID: <200707162056.l6GKueVq002111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42010 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764257AbXGPVh3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:37:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, agm@google.com, chrisw@sous-sol.org, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, jmorris@namei.org, sds@tycho.nsa.gov, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     user namespace: add unshare
has been removed from the -mm tree.  Its filename was
     user-namespace-add-unshare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: user namespace: add unshare
From: Serge E. Hallyn <serue@us.ibm.com>

This patch enables the unshare of user namespaces. 

It adds a new clone flag CLONE_NEWUSER and implements copy_user_ns() which
resets the current user_struct and adds a new root user (uid == 0)

For now, unsharing the user namespace allows a process to reset its
user_struct accounting and uid 0 in the new user namespace should be contained
using appropriate means, for instance selinux

The plan, when the full support is complete (all uid checks covered), is to
keep the original user's rights in the original namespace, and let a process
become uid 0 in the new namespace, with full capabilities to the new
namespace.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Acked-by: Pavel Emelianov <xemul@openvz.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Andrew Morgan <agm@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h          |    1 
 include/linux/user_namespace.h |    4 ++
 kernel/fork.c                  |    2 -
 kernel/nsproxy.c               |    5 ++-
 kernel/user_namespace.c        |   46 ++++++++++++++++++++++++++++++-
 5 files changed, 54 insertions(+), 4 deletions(-)

diff -puN include/linux/sched.h~user-namespace-add-unshare include/linux/sched.h
--- a/include/linux/sched.h~user-namespace-add-unshare
+++ a/include/linux/sched.h
@@ -26,6 +26,7 @@
 #define CLONE_STOPPED		0x02000000	/* Start in stopped state */
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
+#define CLONE_NEWUSER		0x10000000	/* New user namespace */
 
 /*
  * Scheduling policies
diff -puN include/linux/user_namespace.h~user-namespace-add-unshare include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~user-namespace-add-unshare
+++ a/include/linux/user_namespace.h
@@ -4,6 +4,7 @@
 #include <linux/kref.h>
 #include <linux/nsproxy.h>
 #include <linux/sched.h>
+#include <linux/err.h>
 
 #define UIDHASH_BITS	(CONFIG_BASE_SMALL ? 3 : 8)
 #define UIDHASH_SZ	(1 << UIDHASH_BITS)
@@ -45,6 +46,9 @@ static inline struct user_namespace *get
 static inline struct user_namespace *copy_user_ns(int flags,
 						  struct user_namespace *old_ns)
 {
+	if (flags & CLONE_NEWUSER)
+		return ERR_PTR(-EINVAL);
+
 	return NULL;
 }
 
diff -puN kernel/fork.c~user-namespace-add-unshare kernel/fork.c
--- a/kernel/fork.c~user-namespace-add-unshare
+++ a/kernel/fork.c
@@ -1606,7 +1606,7 @@ asmlinkage long sys_unshare(unsigned lon
 	err = -EINVAL;
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
-				CLONE_NEWUTS|CLONE_NEWIPC))
+				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWUSER))
 		goto bad_unshare_out;
 
 	if ((err = unshare_thread(unshare_flags)))
diff -puN kernel/nsproxy.c~user-namespace-add-unshare kernel/nsproxy.c
--- a/kernel/nsproxy.c~user-namespace-add-unshare
+++ a/kernel/nsproxy.c
@@ -117,7 +117,7 @@ int copy_namespaces(int flags, struct ta
 
 	get_nsproxy(old_ns);
 
-	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC)))
+	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWUSER)))
 		return 0;
 
 	if (!capable(CAP_SYS_ADMIN)) {
@@ -161,7 +161,8 @@ int unshare_nsproxy_namespaces(unsigned 
 {
 	int err = 0;
 
-	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC)))
+	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
+			       CLONE_NEWUSER)))
 		return 0;
 
 	if (!capable(CAP_SYS_ADMIN))
diff -puN kernel/user_namespace.c~user-namespace-add-unshare kernel/user_namespace.c
--- a/kernel/user_namespace.c~user-namespace-add-unshare
+++ a/kernel/user_namespace.c
@@ -21,6 +21,45 @@ EXPORT_SYMBOL_GPL(init_user_ns);
 
 #ifdef CONFIG_USER_NS
 
+/*
+ * Clone a new ns copying an original user ns, setting refcount to 1
+ * @old_ns: namespace to clone
+ * Return NULL on error (failure to kmalloc), new ns otherwise
+ */
+static struct user_namespace *clone_user_ns(struct user_namespace *old_ns)
+{
+	struct user_namespace *ns;
+	struct user_struct *new_user;
+	int n;
+
+	ns = kmalloc(sizeof(struct user_namespace), GFP_KERNEL);
+	if (!ns)
+		return NULL;
+
+	kref_init(&ns->kref);
+
+	for (n = 0; n < UIDHASH_SZ; ++n)
+		INIT_LIST_HEAD(ns->uidhash_table + n);
+
+	/* Insert new root user.  */
+	ns->root_user = alloc_uid(ns, 0);
+	if (!ns->root_user) {
+		kfree(ns);
+		return NULL;
+	}
+
+	/* Reset current->user with a new one */
+	new_user = alloc_uid(ns, current->uid);
+	if (!new_user) {
+		free_uid(ns->root_user);
+		kfree(ns);
+		return NULL;
+	}
+
+	switch_uid(new_user);
+	return ns;
+}
+
 struct user_namespace * copy_user_ns(int flags, struct user_namespace *old_ns)
 {
 	struct user_namespace *new_ns;
@@ -28,7 +67,12 @@ struct user_namespace * copy_user_ns(int
 	BUG_ON(!old_ns);
 	get_user_ns(old_ns);
 
-	new_ns = old_ns;
+	if (!(flags & CLONE_NEWUSER))
+		return old_ns;
+
+	new_ns = clone_user_ns(old_ns);
+
+	put_user_ns(old_ns);
 	return new_ns;
 }
 
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
pid-namespaces-round-up-the-api.patch
