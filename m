From: akpm@linux-foundation.org
Subject: + mm-fix-create_new_namespaces-return-value.patch added to -mm tree
Date: Tue, 12 Jun 2007 12:26:49 -0700
Message-ID: <200706121926.l5CJQnqq019217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbXFLT2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:28:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, ebiederm@xmission.com, herbert@13thfloor.at, pbadari@us.ibm.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     fix create_new_namespaces() return value
has been added to the -mm tree.  Its filename is
     mm-fix-create_new_namespaces-return-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix create_new_namespaces() return value
From: Cedric Le Goater <clg@fr.ibm.com>

Modify create_new_namespaces() to also use the errors returned by the
copy_*_ns routines and not to systematically return ENOMEM.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c          |    4 ++--
 kernel/nsproxy.c        |   23 +++++++++++++++++------
 kernel/user_namespace.c |    6 +++---
 kernel/utsname.c        |   10 ++++++----
 4 files changed, 28 insertions(+), 15 deletions(-)

diff -puN fs/namespace.c~mm-fix-create_new_namespaces-return-value fs/namespace.c
--- a/fs/namespace.c~mm-fix-create_new_namespaces-return-value
+++ a/fs/namespace.c
@@ -1451,7 +1451,7 @@ static struct mnt_namespace *dup_mnt_ns(
 
 	new_ns = kmalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
 	if (!new_ns)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	atomic_set(&new_ns->count, 1);
 	INIT_LIST_HEAD(&new_ns->list);
@@ -1465,7 +1465,7 @@ static struct mnt_namespace *dup_mnt_ns(
 	if (!new_ns->root) {
 		up_write(&namespace_sem);
 		kfree(new_ns);
-		return NULL;
+		return ERR_PTR(-ENOMEM);;
 	}
 	spin_lock(&vfsmount_lock);
 	list_add_tail(&new_ns->list, &new_ns->root->mnt_list);
diff -puN kernel/nsproxy.c~mm-fix-create_new_namespaces-return-value kernel/nsproxy.c
--- a/kernel/nsproxy.c~mm-fix-create_new_namespaces-return-value
+++ a/kernel/nsproxy.c
@@ -58,30 +58,41 @@ static struct nsproxy *create_new_namesp
 			struct fs_struct *new_fs)
 {
 	struct nsproxy *new_nsp;
+	int err;
 
 	new_nsp = clone_nsproxy(tsk->nsproxy);
 	if (!new_nsp)
 		return ERR_PTR(-ENOMEM);
 
 	new_nsp->mnt_ns = copy_mnt_ns(flags, tsk->nsproxy->mnt_ns, new_fs);
-	if (IS_ERR(new_nsp->mnt_ns))
+	if (IS_ERR(new_nsp->mnt_ns)) {
+		err = PTR_ERR(new_nsp->mnt_ns);
 		goto out_ns;
+	}
 
 	new_nsp->uts_ns = copy_utsname(flags, tsk->nsproxy->uts_ns);
-	if (IS_ERR(new_nsp->uts_ns))
+	if (IS_ERR(new_nsp->uts_ns)) {
+		err = PTR_ERR(new_nsp->uts_ns);
 		goto out_uts;
+	}
 
 	new_nsp->ipc_ns = copy_ipcs(flags, tsk->nsproxy->ipc_ns);
-	if (IS_ERR(new_nsp->ipc_ns))
+	if (IS_ERR(new_nsp->ipc_ns)) {
+		err = PTR_ERR(new_nsp->ipc_ns);
 		goto out_ipc;
+	}
 
 	new_nsp->pid_ns = copy_pid_ns(flags, tsk->nsproxy->pid_ns);
-	if (IS_ERR(new_nsp->pid_ns))
+	if (IS_ERR(new_nsp->pid_ns)) {
+		err = PTR_ERR(new_nsp->pid_ns);
 		goto out_pid;
+	}
 
 	new_nsp->user_ns = copy_user_ns(flags, tsk->nsproxy->user_ns);
-	if (IS_ERR(new_nsp->user_ns))
+	if (IS_ERR(new_nsp->user_ns)) {
+		err = PTR_ERR(new_nsp->user_ns);
 		goto out_user;
+	}
 
 	return new_nsp;
 
@@ -99,7 +110,7 @@ out_uts:
 		put_mnt_ns(new_nsp->mnt_ns);
 out_ns:
 	kfree(new_nsp);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(err);
 }
 
 /*
diff -puN kernel/user_namespace.c~mm-fix-create_new_namespaces-return-value kernel/user_namespace.c
--- a/kernel/user_namespace.c~mm-fix-create_new_namespaces-return-value
+++ a/kernel/user_namespace.c
@@ -34,7 +34,7 @@ static struct user_namespace *clone_user
 
 	ns = kmalloc(sizeof(struct user_namespace), GFP_KERNEL);
 	if (!ns)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	kref_init(&ns->kref);
 
@@ -45,7 +45,7 @@ static struct user_namespace *clone_user
 	ns->root_user = alloc_uid(ns, 0);
 	if (!ns->root_user) {
 		kfree(ns);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	/* Reset current->user with a new one */
@@ -53,7 +53,7 @@ static struct user_namespace *clone_user
 	if (!new_user) {
 		free_uid(ns->root_user);
 		kfree(ns);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	switch_uid(new_user);
diff -puN kernel/utsname.c~mm-fix-create_new_namespaces-return-value kernel/utsname.c
--- a/kernel/utsname.c~mm-fix-create_new_namespaces-return-value
+++ a/kernel/utsname.c
@@ -13,6 +13,7 @@
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <linux/version.h>
+#include <linux/err.h>
 
 /*
  * Clone a new ns copying an original utsname, setting refcount to 1
@@ -24,10 +25,11 @@ static struct uts_namespace *clone_uts_n
 	struct uts_namespace *ns;
 
 	ns = kmalloc(sizeof(struct uts_namespace), GFP_KERNEL);
-	if (ns) {
-		memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
-		kref_init(&ns->kref);
-	}
+	if (!ns)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
+	kref_init(&ns->kref);
 	return ns;
 }
 
_

Patches currently in -mm which might be from clg@fr.ibm.com are

mm-merge-nopfn-into-fault-spufs-fix.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
containersv10-add-tasks-file-interface-fix-2.patch
