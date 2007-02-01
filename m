From: akpm@osdl.org
Subject: - nsproxy-externalizes-exit_task_namespaces.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:24:45 -0800
Message-ID: <200702010125.l111PhlI032629@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36489 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161234AbXBABnF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:43:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     nsproxy: externalizes exit_task_namespaces
has been removed from the -mm tree.  Its filename was
     nsproxy-externalizes-exit_task_namespaces.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: nsproxy: externalizes exit_task_namespaces
From: Cedric Le Goater <clg@fr.ibm.com>

This patchset adds a user namespace, which allows a process to unshare its
user_struct table, allowing for separate accounting per user namespace.  It
appends a user namespace to vfsmounts and fown_structs, so that uid1==uid2
checks can be extended to be false if uid1 and uid2 are in different
namespaces.

A vfsmount generally cannot be accessed by another user namespace than that in
which it was mounted.  A vfsmount can be mounted "shared-ns", in which case it
can be accessed by any user namespace.  This is needed at least to bootstrap a
container so it can get far enough to create it's own private file system
tree, and can be used in conjunction with read-only bind mounts to provide
shared /usr trees, for instance.  However, for more useful, more fine-grained
sharing accross user namespaces, it has been suggested that a new filesystem
specifying global userid's be used.


This patch:

This is required to remove a header dependency in sched.h which breaks next
patches.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/nsproxy.h |   20 +++++++++-----------
 kernel/fork.c           |    2 +-
 kernel/nsproxy.c        |    8 ++++++++
 3 files changed, 18 insertions(+), 12 deletions(-)

diff -puN include/linux/nsproxy.h~nsproxy-externalizes-exit_task_namespaces include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~nsproxy-externalizes-exit_task_namespaces
+++ a/include/linux/nsproxy.h
@@ -2,7 +2,8 @@
 #define _LINUX_NSPROXY_H
 
 #include <linux/spinlock.h>
-#include <linux/sched.h>
+
+struct task_struct;
 
 struct mnt_namespace;
 struct uts_namespace;
@@ -36,22 +37,19 @@ int copy_namespaces(int flags, struct ta
 void get_task_namespaces(struct task_struct *tsk);
 void free_nsproxy(struct nsproxy *ns);
 struct mnt_namespace *get_task_mnt_ns(struct task_struct *tsk);
+void exit_task_namespaces(struct task_struct *p, struct nsproxy *ns);
 
-static inline void put_nsproxy(struct nsproxy *ns)
+static inline void finalize_put_nsproxy(struct nsproxy *ns)
 {
-	if (atomic_dec_and_test(&ns->count)) {
+	if (ns)
 		free_nsproxy(ns);
-	}
 }
 
-static inline void exit_task_namespaces(struct task_struct *p)
+static inline void put_nsproxy(struct nsproxy *ns)
 {
-	struct nsproxy *ns = p->nsproxy;
-	if (ns) {
-		task_lock(p);
-		p->nsproxy = NULL;
-		task_unlock(p);
-		put_nsproxy(ns);
+	if (atomic_dec_and_test(&ns->count)) {
+		free_nsproxy(ns);
 	}
 }
+
 #endif
diff -puN kernel/nsproxy.c~nsproxy-externalizes-exit_task_namespaces kernel/nsproxy.c
--- a/kernel/nsproxy.c~nsproxy-externalizes-exit_task_namespaces
+++ a/kernel/nsproxy.c
@@ -36,6 +36,14 @@ void get_task_namespaces(struct task_str
 	}
 }
 
+void exit_task_namespaces(struct task_struct *p, struct nsproxy *ns)
+{
+	task_lock(p);
+	p->nsproxy = NULL;
+	task_unlock(p);
+	finalize_put_nsproxy(ns);
+}
+
 /*
  * creates a copy of "orig" with refcount 1.
  * This does not grab references to the contained namespaces,
diff -puN kernel/fork.c~nsproxy-externalizes-exit_task_namespaces kernel/fork.c
--- a/kernel/fork.c~nsproxy-externalizes-exit_task_namespaces
+++ a/kernel/fork.c
@@ -1272,7 +1272,7 @@ static struct task_struct *copy_process(
 	return p;
 
 bad_fork_cleanup_namespaces:
-	exit_task_namespaces(p);
+	exit_task_namespaces(p, p->nsproxy);
 bad_fork_cleanup_keys:
 	exit_keys(p);
 bad_fork_cleanup_mm:
_

Patches currently in -mm which might be from clg@fr.ibm.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
mxser-remove-useless-fields.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
uts-namespace-remove-config_uts_ns.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
