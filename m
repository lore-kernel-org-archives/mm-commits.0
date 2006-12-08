From: akpm@osdl.org
Subject: - add-pid_namespace-to-nsproxy.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:59 -0800
Message-ID: <200612082005.kB8K5x0i002350@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57795 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946023AbWLHUG6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:06:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, dev@openvz.org, ebiederm@xmission.com, herbert@13thfloor.at, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     to nsproxy
has been removed from the -mm tree.  Its filename was
     add-pid_namespace-to-nsproxy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: to nsproxy
From: Cedric Le Goater <clg@fr.ibm.com>

Add the pid namespace framework to the nsproxy object.  The copy of the pid
namespace only increases the refcount on the global pid namespace,
init_pid_ns, and unshare is not implemented.

There is no configuration option to activate or deactivate this feature
because this not relevant for the moment.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/init_task.h     |    2 ++
 include/linux/nsproxy.h       |    2 ++
 include/linux/pid_namespace.h |   20 ++++++++++++++++++--
 kernel/nsproxy.c              |   26 +++++++++++++++++++-------
 kernel/pid.c                  |   23 +++++++++++++++++++++++
 5 files changed, 64 insertions(+), 9 deletions(-)

diff -puN include/linux/init_task.h~add-pid_namespace-to-nsproxy include/linux/init_task.h
--- a/include/linux/init_task.h~add-pid_namespace-to-nsproxy
+++ a/include/linux/init_task.h
@@ -7,6 +7,7 @@
 #include <linux/utsname.h>
 #include <linux/lockdep.h>
 #include <linux/ipc.h>
+#include <linux/pid_namespace.h>
 
 #define INIT_FDTABLE \
 {							\
@@ -73,6 +74,7 @@
 
 extern struct nsproxy init_nsproxy;
 #define INIT_NSPROXY(nsproxy) {						\
+	.pid_ns		= &init_pid_ns,					\
 	.count		= ATOMIC_INIT(1),				\
 	.nslock		= __SPIN_LOCK_UNLOCKED(nsproxy.nslock),		\
 	.id		= 0,						\
diff -puN include/linux/nsproxy.h~add-pid_namespace-to-nsproxy include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~add-pid_namespace-to-nsproxy
+++ a/include/linux/nsproxy.h
@@ -7,6 +7,7 @@
 struct mnt_namespace;
 struct uts_namespace;
 struct ipc_namespace;
+struct pid_namespace;
 
 /*
  * A structure to contain pointers to all per-process
@@ -27,6 +28,7 @@ struct nsproxy {
 	struct uts_namespace *uts_ns;
 	struct ipc_namespace *ipc_ns;
 	struct mnt_namespace *mnt_ns;
+	struct pid_namespace *pid_ns;
 };
 extern struct nsproxy init_nsproxy;
 
diff -puN include/linux/pid_namespace.h~add-pid_namespace-to-nsproxy include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~add-pid_namespace-to-nsproxy
+++ a/include/linux/pid_namespace.h
@@ -5,6 +5,8 @@
 #include <linux/mm.h>
 #include <linux/threads.h>
 #include <linux/pid.h>
+#include <linux/nsproxy.h>
+#include <linux/kref.h>
 
 struct pidmap {
        atomic_t nr_free;
@@ -14,10 +16,24 @@ struct pidmap {
 #define PIDMAP_ENTRIES         ((PID_MAX_LIMIT + 8*PAGE_SIZE - 1)/PAGE_SIZE/8)
 
 struct pid_namespace {
-       struct pidmap pidmap[PIDMAP_ENTRIES];
-       int last_pid;
+	struct kref kref;
+	struct pidmap pidmap[PIDMAP_ENTRIES];
+	int last_pid;
 };
 
 extern struct pid_namespace init_pid_ns;
 
+static inline void get_pid_ns(struct pid_namespace *ns)
+{
+	kref_get(&ns->kref);
+}
+
+extern int copy_pid_ns(int flags, struct task_struct *tsk);
+extern void free_pid_ns(struct kref *kref);
+
+static inline void put_pid_ns(struct pid_namespace *ns)
+{
+	kref_put(&ns->kref, free_pid_ns);
+}
+
 #endif /* _LINUX_PID_NS_H */
diff -puN kernel/nsproxy.c~add-pid_namespace-to-nsproxy kernel/nsproxy.c
--- a/kernel/nsproxy.c~add-pid_namespace-to-nsproxy
+++ a/kernel/nsproxy.c
@@ -19,6 +19,7 @@
 #include <linux/init_task.h>
 #include <linux/mnt_namespace.h>
 #include <linux/utsname.h>
+#include <linux/pid_namespace.h>
 
 struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
 
@@ -68,6 +69,8 @@ struct nsproxy *dup_namespaces(struct ns
 			get_uts_ns(ns->uts_ns);
 		if (ns->ipc_ns)
 			get_ipc_ns(ns->ipc_ns);
+		if (ns->pid_ns)
+			get_pid_ns(ns->pid_ns);
 	}
 
 	return ns;
@@ -111,10 +114,17 @@ int copy_namespaces(int flags, struct ta
 	if (err)
 		goto out_ipc;
 
+	err = copy_pid_ns(flags, tsk);
+	if (err)
+		goto out_pid;
+
 out:
 	put_nsproxy(old_ns);
 	return err;
 
+out_pid:
+	if (new_ns->ipc_ns)
+		put_ipc_ns(new_ns->ipc_ns);
 out_ipc:
 	if (new_ns->uts_ns)
 		put_uts_ns(new_ns->uts_ns);
@@ -129,11 +139,13 @@ out_ns:
 
 void free_nsproxy(struct nsproxy *ns)
 {
-		if (ns->mnt_ns)
-			put_mnt_ns(ns->mnt_ns);
-		if (ns->uts_ns)
-			put_uts_ns(ns->uts_ns);
-		if (ns->ipc_ns)
-			put_ipc_ns(ns->ipc_ns);
-		kfree(ns);
+	if (ns->mnt_ns)
+		put_mnt_ns(ns->mnt_ns);
+	if (ns->uts_ns)
+		put_uts_ns(ns->uts_ns);
+	if (ns->ipc_ns)
+		put_ipc_ns(ns->ipc_ns);
+	if (ns->pid_ns)
+		put_pid_ns(ns->pid_ns);
+	kfree(ns);
 }
diff -puN kernel/pid.c~add-pid_namespace-to-nsproxy kernel/pid.c
--- a/kernel/pid.c~add-pid_namespace-to-nsproxy
+++ a/kernel/pid.c
@@ -59,6 +59,9 @@ static inline int mk_pid(struct pid_name
  * the scheme scales to up to 4 million PIDs, runtime.
  */
 struct pid_namespace init_pid_ns = {
+	.kref = {
+		.refcount       = ATOMIC_INIT(2),
+	},
 	.pidmap = {
 		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
 	},
@@ -356,6 +359,26 @@ struct pid *find_ge_pid(int nr)
 }
 EXPORT_SYMBOL_GPL(find_get_pid);
 
+int copy_pid_ns(int flags, struct task_struct *tsk)
+{
+	struct pid_namespace *old_ns = tsk->nsproxy->pid_ns;
+	int err = 0;
+
+	if (!old_ns)
+		return 0;
+
+	get_pid_ns(old_ns);
+	return err;
+}
+
+void free_pid_ns(struct kref *kref)
+{
+	struct pid_namespace *ns;
+
+	ns = container_of(kref, struct pid_namespace, kref);
+	kfree(ns);
+}
+
 /*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
_

Patches currently in -mm which might be from clg@fr.ibm.com are

add-pid_namespace-to-nsproxy.patch
use-current-nsproxy-pid_ns.patch
add-child-reaper-to-pid_namespace.patch
mm-fix-pagecache-write-deadlocks-xip.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch

