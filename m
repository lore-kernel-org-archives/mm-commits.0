From: akpm@osdl.org
Subject: + nsproxy-externalizes-exit_task_namespaces.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:35:16 -0800
Message-ID: <200701260635.l0Q6ZGOA009497@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030798AbXAZGge (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:36:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com


The patch titled
     nsproxy: externalizes exit_task_namespaces
has been added to the -mm tree.  Its filename is
     nsproxy-externalizes-exit_task_namespaces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 include/linux/nsproxy.h |   13 ++++---------
 kernel/nsproxy.c        |    8 ++++++++
 2 files changed, 12 insertions(+), 9 deletions(-)

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
@@ -54,12 +55,6 @@ static inline struct nsproxy *preexit_ta
 	return put_nsproxy(p->nsproxy);
 }
 
-static inline void exit_task_namespaces(struct task_struct *p,
-						struct nsproxy *ns)
-{
-	task_lock(p);
-	p->nsproxy = NULL;
-	task_unlock(p);
-	finalize_put_nsproxy(ns);
-}
+extern void exit_task_namespaces(struct task_struct *p);
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
_

Patches currently in -mm which might be from clg@fr.ibm.com are

namespaces-fix-exit-race-by-splitting-exit.patch
kthread-api-conversion-for-dvb_frontend-and-av7110.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user_ns-handle-file-sigio-fix.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
uts-namespace-remove-config_uts_ns.patch
ipc-namespace-remove-config_ipc_ns.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
