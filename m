From: akpm@linux-foundation.org
Subject: + user-namespace-add-unshare.patch added to -mm tree
Date: Fri, 08 Jun 2007 12:22:27 -0700
Message-ID: <200706081922.l58JMRH9009384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57360 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbXFHT3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 15:29:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, agm@google.com, chrisw@sous-sol.org, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, jmorris@namei.org, sds@tycho.nsa.gov, xemul@openvz.org


The patch titled
     user namespace: add unshare
has been added to the -mm tree.  Its filename is
     user-namespace-add-unshare.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: user namespace: add unshare
From: Serge E. Hallyn <serue@us.ibm.com>

Fix !CONFIG_USER_NS clone with CLONE_NEWUSER so it returns -EINVAL rather
than 0, so that userspace knows they didn't get a new user namespace.

(akpm: this changlog is crappy)

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
@@ -1610,7 +1610,7 @@ asmlinkage long sys_unshare(unsigned lon
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
@@ -163,7 +163,8 @@ int unshare_nsproxy_namespaces(unsigned 
 	struct nsproxy *old_ns = current->nsproxy;
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

implement-file-posix-capabilities.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
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
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
