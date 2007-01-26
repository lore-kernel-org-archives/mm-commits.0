From: akpm@osdl.org
Subject: + user-ns-implement-user-ns-unshare.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:35:18 -0800
Message-ID: <200701260635.l0Q6ZIkN009503@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48252 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030796AbXAZGg3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:36:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at


The patch titled
     /8] user ns: implement user ns unshare
has been added to the -mm tree.  Its filename is
     user-ns-implement-user-ns-unshare.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: /8] user ns: implement user ns unshare
From: "Serge E. Hallyn" <serue@us.ibm.com>

Quoting Frederik Deweerdt (deweerdt@free.fr):
> On Thu, Jan 04, 2007 at 12:13:10PM -0600, Serge E. Hallyn wrote:
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Subject: [PATCH -mm 8/8] user ns: implement user ns unshare
> >
> > Implement CLONE_NEWUSER flag useable at clone/unshare.
> >
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > ---
>
> >  int copy_user_ns(int flags, struct task_struct *tsk)
> >  {
> > -	struct user_namespace *old_ns = tsk->nsproxy->user_ns;
> > +	struct user_namespace *new_ns, *old_ns = tsk->nsproxy->user_ns;
> >  	int err = 0;
>         ^^^^^^^^^^^^
> The "= 0" is superfluous here.

Ah, since I set it anyway, good point.

> >
> >  	if (!old_ns)
> >  		return 0;
> >
> >  	get_user_ns(old_ns);
> > -	return err;
> > +	if (!(flags & CLONE_NEWUSER))
> > +		return 0;
> > +	err = -EPERM;
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		goto out;
> > +	err = -ENOMEM;
> > +	new_ns = clone_user_ns(old_ns);
> > +	if (!new_ns)
> > +		goto out;
> > +
> > +	tsk->nsproxy->user_ns = new_ns;
> > +	err = 0;
> > +out:
> > +	put_user_ns(old_ns);
> > +	return 0;
>         ^^^^^^^^^
> Should be "return err;"

Yes it should.

New patch attached.

(I suppose the testcase should check for the CAP_SYS_ADMIN
error case...)

Thanks for the close review!

-serge

Subject: [PATCH 8/8] user ns: implement user ns unshare

Implement CLONE_NEWUSER flag useable at clone/unshare.

Changes:
	Jan 4: return the actual error value in copy_user_ns().

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h          |    1 
 include/linux/user_namespace.h |   10 ++++
 kernel/fork.c                  |   22 +++++++--
 kernel/nsproxy.c               |    2 
 kernel/user_namespace.c        |   74 ++++++++++++++++++++++++++++++-
 5 files changed, 102 insertions(+), 7 deletions(-)

diff -puN include/linux/sched.h~user-ns-implement-user-ns-unshare include/linux/sched.h
--- a/include/linux/sched.h~user-ns-implement-user-ns-unshare
+++ a/include/linux/sched.h
@@ -26,6 +26,7 @@
 #define CLONE_STOPPED		0x02000000	/* Start in stopped state */
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
+#define CLONE_NEWUSER		0x10000000	/* New user namespace */
 
 /*
  * Scheduling policies
diff -puN include/linux/user_namespace.h~user-ns-implement-user-ns-unshare include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~user-ns-implement-user-ns-unshare
+++ a/include/linux/user_namespace.h
@@ -26,6 +26,7 @@ static inline struct user_namespace *get
 }
 
 extern int copy_user_ns(int flags, struct task_struct *tsk);
+extern int unshare_user_ns(unsigned long flags, struct user_namespace **new_user);
 extern void free_user_ns(struct kref *kref);
 
 static inline void put_user_ns(struct user_namespace *ns)
@@ -51,6 +52,15 @@ static inline struct user_namespace *get
 	return &init_user_ns;
 }
 
+static inline int unshare_user_ns(unsigned long flags,
+			 struct user_namespace **new_user)
+{
+	if (flags & CLONE_NEWUSER)
+		return -EINVAL;
+
+	return 0;
+}
+
 static inline int copy_user_ns(int flags, struct task_struct *tsk)
 {
 	return 0;
diff -puN kernel/fork.c~user-ns-implement-user-ns-unshare kernel/fork.c
--- a/kernel/fork.c~user-ns-implement-user-ns-unshare
+++ a/kernel/fork.c
@@ -49,6 +49,7 @@
 #include <linux/delayacct.h>
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
+#include <linux/user_namespace.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1624,6 +1625,7 @@ asmlinkage long sys_unshare(unsigned lon
 	struct nsproxy *new_nsproxy = NULL, *old_nsproxy = NULL;
 	struct uts_namespace *uts, *new_uts = NULL;
 	struct ipc_namespace *ipc, *new_ipc = NULL;
+	struct user_namespace *user, *new_user = NULL;
 
 	check_unshare_flags(&unshare_flags);
 
@@ -1631,7 +1633,7 @@ asmlinkage long sys_unshare(unsigned lon
 	err = -EINVAL;
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
-				CLONE_NEWUTS|CLONE_NEWIPC))
+				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWUSER))
 		goto bad_unshare_out;
 
 	if ((err = unshare_thread(unshare_flags)))
@@ -1652,18 +1654,20 @@ asmlinkage long sys_unshare(unsigned lon
 		goto bad_unshare_cleanup_semundo;
 	if ((err = unshare_ipcs(unshare_flags, &new_ipc)))
 		goto bad_unshare_cleanup_uts;
+	if ((err = unshare_user_ns(unshare_flags, &new_user)))
+		goto bad_unshare_cleanup_ipc;
 
-	if (new_ns || new_uts || new_ipc) {
+	if (new_ns || new_uts || new_ipc || new_user) {
 		old_nsproxy = current->nsproxy;
 		new_nsproxy = dup_namespaces(old_nsproxy);
 		if (!new_nsproxy) {
 			err = -ENOMEM;
-			goto bad_unshare_cleanup_ipc;
+			goto bad_unshare_cleanup_user;
 		}
 	}
 
 	if (new_fs || new_ns || new_mm || new_fd || new_ulist ||
-				new_uts || new_ipc) {
+				new_uts || new_ipc || new_user) {
 
 		task_lock(current);
 
@@ -1711,12 +1715,22 @@ asmlinkage long sys_unshare(unsigned lon
 			new_ipc = ipc;
 		}
 
+		if (new_user) {
+			user = current->nsproxy->user_ns;
+			current->nsproxy->user_ns = new_user;
+			new_user = user;
+		}
+
 		task_unlock(current);
 	}
 
 	if (new_nsproxy)
 		put_and_finalize_nsproxy(new_nsproxy);
 
+bad_unshare_cleanup_user:
+	if (new_user)
+		put_user_ns(new_user);
+
 bad_unshare_cleanup_ipc:
 	if (new_ipc)
 		put_ipc_ns(new_ipc);
diff -puN kernel/nsproxy.c~user-ns-implement-user-ns-unshare kernel/nsproxy.c
--- a/kernel/nsproxy.c~user-ns-implement-user-ns-unshare
+++ a/kernel/nsproxy.c
@@ -99,7 +99,7 @@ int copy_namespaces(int flags, struct ta
 
 	get_nsproxy(old_ns);
 
-	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC)))
+	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWUSER)))
 		return 0;
 
 	new_ns = clone_namespaces(old_ns);
diff -puN kernel/user_namespace.c~user-ns-implement-user-ns-unshare kernel/user_namespace.c
--- a/kernel/user_namespace.c~user-ns-implement-user-ns-unshare
+++ a/kernel/user_namespace.c
@@ -20,16 +20,86 @@ struct user_namespace init_user_ns = {
 EXPORT_SYMBOL_GPL(init_user_ns);
 
 #ifdef CONFIG_USER_NS
+/*
+ * Clone a new ns copying an original user ns, setting refcount to 1
+ * @old_ns: namespace to clone
+ * Return NULL on error (failure to kmalloc), new ns otherwise
+ */
+static struct user_namespace *clone_user_ns(struct user_namespace *old_ns)
+{
+       struct user_namespace *ns;
+       struct user_struct *new_user;
+       int n;
+
+       ns = kmalloc(sizeof(struct user_namespace), GFP_KERNEL);
+       if (!ns)
+               return NULL;
+
+       kref_init(&ns->kref);
+
+       for(n = 0; n < UIDHASH_SZ; ++n)
+               INIT_LIST_HEAD(ns->uidhash_table + n);
+
+       /* Insert new root user.  */
+       ns->root_user = alloc_uid(ns, 0);
+       if (!ns->root_user) {
+               kfree(ns);
+               return NULL;
+       }
+
+       /* Reset current->user with a new one */
+       new_user = alloc_uid(ns, current->uid);
+       if (!new_user) {
+               free_uid(ns->root_user);
+               kfree(ns);
+               return NULL;
+       }
+
+       switch_uid(new_user);
+       return ns;
+}
+
+/*
+ * unshare the current process' user namespace.
+ */
+int unshare_user_ns(unsigned long flags,
+			struct user_namespace **new_user)
+{
+       if (flags & CLONE_NEWUSER) {
+               if (!capable(CAP_SYS_ADMIN))
+                       return -EPERM;
+
+               *new_user = clone_user_ns(current->nsproxy->user_ns);
+               if (!*new_user)
+                       return -ENOMEM;
+       }
+
+       return 0;
+}
 
 int copy_user_ns(int flags, struct task_struct *tsk)
 {
-	struct user_namespace *old_ns = tsk->nsproxy->user_ns;
-	int err = 0;
+	struct user_namespace *new_ns, *old_ns = tsk->nsproxy->user_ns;
+	int err;
 
 	if (!old_ns)
 		return 0;
 
 	get_user_ns(old_ns);
+	if (!(flags & CLONE_NEWUSER))
+		return 0;
+	err = -EPERM;
+	if (!capable(CAP_SYS_ADMIN))
+		goto out;
+	err = -ENOMEM;
+	new_ns = clone_user_ns(old_ns);
+	if (!new_ns)
+		goto out;
+
+	tsk->nsproxy->user_ns = new_ns;
+	err = 0;
+out:
+	put_user_ns(old_ns);
 	return err;
 }
 
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
