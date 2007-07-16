From: akpm@linux-foundation.org
Subject: - remove-config_uts_ns-and-config_ipc_ns.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:34 -0700
Message-ID: <200707162056.l6GKuYe9002105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42318 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755295AbXGPVaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     remove CONFIG_UTS_NS and CONFIG_IPC_NS
has been removed from the -mm tree.  Its filename was
     remove-config_uts_ns-and-config_ipc_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove CONFIG_UTS_NS and CONFIG_IPC_NS
From: Cedric Le Goater <clg@fr.ibm.com>

CONFIG_UTS_NS and CONFIG_IPC_NS have very little value as they only
deactivate the unshare of the uts and ipc namespaces and do not improve
performance.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Acked-by: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h     |   11 +++--------
 include/linux/utsname.h |   13 -------------
 init/Kconfig            |   17 -----------------
 ipc/msg.c               |    4 +---
 ipc/sem.c               |    4 +---
 ipc/shm.c               |    4 +---
 ipc/util.c              |   11 +----------
 ipc/util.h              |    8 ++------
 kernel/Makefile         |    4 ++--
 kernel/nsproxy.c        |   10 ----------
 kernel/utsname_sysctl.c |    5 +----
 11 files changed, 12 insertions(+), 79 deletions(-)

diff -puN include/linux/ipc.h~remove-config_uts_ns-and-config_ipc_ns include/linux/ipc.h
--- a/include/linux/ipc.h~remove-config_uts_ns-and-config_ipc_ns
+++ a/include/linux/ipc.h
@@ -93,6 +93,7 @@ extern struct ipc_namespace init_ipc_ns;
 
 #ifdef CONFIG_SYSVIPC
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
+extern void free_ipc_ns(struct kref *kref);
 extern struct ipc_namespace *copy_ipcs(unsigned long flags,
 						struct ipc_namespace *ns);
 #else
@@ -104,13 +105,9 @@ static inline struct ipc_namespace *copy
 }
 #endif
 
-#ifdef CONFIG_IPC_NS
-extern void free_ipc_ns(struct kref *kref);
-#endif
-
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 {
-#ifdef CONFIG_IPC_NS
+#ifdef CONFIG_SYSVIPC
 	if (ns)
 		kref_get(&ns->kref);
 #endif
@@ -119,7 +116,7 @@ static inline struct ipc_namespace *get_
 
 static inline void put_ipc_ns(struct ipc_namespace *ns)
 {
-#ifdef CONFIG_IPC_NS
+#ifdef CONFIG_SYSVIPC
 	kref_put(&ns->kref, free_ipc_ns);
 #endif
 }
@@ -127,5 +124,3 @@ static inline void put_ipc_ns(struct ipc
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_IPC_H */
-
-
diff -puN include/linux/utsname.h~remove-config_uts_ns-and-config_ipc_ns include/linux/utsname.h
--- a/include/linux/utsname.h~remove-config_uts_ns-and-config_ipc_ns
+++ a/include/linux/utsname.h
@@ -48,7 +48,6 @@ static inline void get_uts_ns(struct uts
 	kref_get(&ns->kref);
 }
 
-#ifdef CONFIG_UTS_NS
 extern struct uts_namespace *copy_utsname(int flags, struct uts_namespace *ns);
 extern void free_uts_ns(struct kref *kref);
 
@@ -56,18 +55,6 @@ static inline void put_uts_ns(struct uts
 {
 	kref_put(&ns->kref, free_uts_ns);
 }
-#else
-static inline struct uts_namespace *copy_utsname(int flags,
-						struct uts_namespace *ns)
-{
-	return ns;
-}
-
-static inline void put_uts_ns(struct uts_namespace *ns)
-{
-}
-#endif
-
 static inline struct new_utsname *utsname(void)
 {
 	return &current->nsproxy->uts_ns->name;
diff -puN init/Kconfig~remove-config_uts_ns-and-config_ipc_ns init/Kconfig
--- a/init/Kconfig~remove-config_uts_ns-and-config_ipc_ns
+++ a/init/Kconfig
@@ -120,15 +120,6 @@ config SYSVIPC
 	  section 6.4 of the Linux Programmer's Guide, available from
 	  <http://www.tldp.org/guides.html>.
 
-config IPC_NS
-	bool "IPC Namespaces"
-	depends on SYSVIPC
-	default n
-	help
-	  Support ipc namespaces.  This allows containers, i.e. virtual
-	  environments, to use ipc namespaces to provide different ipc
-	  objects for different servers.  If unsure, say N.
-
 config SYSVIPC_SYSCTL
 	bool
 	depends on SYSVIPC
@@ -218,14 +209,6 @@ config TASK_IO_ACCOUNTING
 
 	  Say N if unsure.
 
-config UTS_NS
-	bool "UTS Namespaces"
-	default n
-	help
-	  Support uts namespaces.  This allows containers, i.e.
-	  vservers, to use uts namespaces to provide different
-	  uts info for different servers.  If unsure, say N.
-
 config AUDIT
 	bool "Auditing support"
 	depends on NET
diff -puN ipc/msg.c~remove-config_uts_ns-and-config_ipc_ns ipc/msg.c
--- a/ipc/msg.c~remove-config_uts_ns-and-config_ipc_ns
+++ a/ipc/msg.c
@@ -87,7 +87,7 @@ static int newque (struct ipc_namespace 
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it);
 #endif
 
-static void __ipc_init __msg_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
+static void __msg_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
 {
 	ns->ids[IPC_MSG_IDS] = ids;
 	ns->msg_ctlmax = MSGMAX;
@@ -96,7 +96,6 @@ static void __ipc_init __msg_init_ns(str
 	ipc_init_ids(ids, ns->msg_ctlmni);
 }
 
-#ifdef CONFIG_IPC_NS
 int msg_init_ns(struct ipc_namespace *ns)
 {
 	struct ipc_ids *ids;
@@ -128,7 +127,6 @@ void msg_exit_ns(struct ipc_namespace *n
 	kfree(ns->ids[IPC_MSG_IDS]);
 	ns->ids[IPC_MSG_IDS] = NULL;
 }
-#endif
 
 void __init msg_init(void)
 {
diff -puN ipc/sem.c~remove-config_uts_ns-and-config_ipc_ns ipc/sem.c
--- a/ipc/sem.c~remove-config_uts_ns-and-config_ipc_ns
+++ a/ipc/sem.c
@@ -121,7 +121,7 @@ static int sysvipc_sem_proc_show(struct 
 #define sc_semopm	sem_ctls[2]
 #define sc_semmni	sem_ctls[3]
 
-static void __ipc_init __sem_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
+static void __sem_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
 {
 	ns->ids[IPC_SEM_IDS] = ids;
 	ns->sc_semmsl = SEMMSL;
@@ -132,7 +132,6 @@ static void __ipc_init __sem_init_ns(str
 	ipc_init_ids(ids, ns->sc_semmni);
 }
 
-#ifdef CONFIG_IPC_NS
 int sem_init_ns(struct ipc_namespace *ns)
 {
 	struct ipc_ids *ids;
@@ -164,7 +163,6 @@ void sem_exit_ns(struct ipc_namespace *n
 	kfree(ns->ids[IPC_SEM_IDS]);
 	ns->ids[IPC_SEM_IDS] = NULL;
 }
-#endif
 
 void __init sem_init (void)
 {
diff -puN ipc/shm.c~remove-config_uts_ns-and-config_ipc_ns ipc/shm.c
--- a/ipc/shm.c~remove-config_uts_ns-and-config_ipc_ns
+++ a/ipc/shm.c
@@ -77,7 +77,7 @@ static void shm_destroy (struct ipc_name
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it);
 #endif
 
-static void __ipc_init __shm_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
+static void __shm_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
 {
 	ns->ids[IPC_SHM_IDS] = ids;
 	ns->shm_ctlmax = SHMMAX;
@@ -98,7 +98,6 @@ static void do_shm_rmid(struct ipc_names
 		shm_destroy(ns, shp);
 }
 
-#ifdef CONFIG_IPC_NS
 int shm_init_ns(struct ipc_namespace *ns)
 {
 	struct ipc_ids *ids;
@@ -130,7 +129,6 @@ void shm_exit_ns(struct ipc_namespace *n
 	kfree(ns->ids[IPC_SHM_IDS]);
 	ns->ids[IPC_SHM_IDS] = NULL;
 }
-#endif
 
 void __init shm_init (void)
 {
diff -puN ipc/util.c~remove-config_uts_ns-and-config_ipc_ns ipc/util.c
--- a/ipc/util.c~remove-config_uts_ns-and-config_ipc_ns
+++ a/ipc/util.c
@@ -50,7 +50,6 @@ struct ipc_namespace init_ipc_ns = {
 	},
 };
 
-#ifdef CONFIG_IPC_NS
 static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
 {
 	int err;
@@ -110,14 +109,6 @@ void free_ipc_ns(struct kref *kref)
 	shm_exit_ns(ns);
 	kfree(ns);
 }
-#else
-struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
-{
-	if (flags & CLONE_NEWIPC)
-		return ERR_PTR(-EINVAL);
-	return ns;
-}
-#endif
 
 /**
  *	ipc_init	-	initialise IPC subsystem
@@ -145,7 +136,7 @@ __initcall(ipc_init);
  *	array itself. 
  */
  
-void __ipc_init ipc_init_ids(struct ipc_ids* ids, int size)
+void ipc_init_ids(struct ipc_ids* ids, int size)
 {
 	int i;
 
diff -puN ipc/util.h~remove-config_uts_ns-and-config_ipc_ns ipc/util.h
--- a/ipc/util.h~remove-config_uts_ns-and-config_ipc_ns
+++ a/ipc/util.h
@@ -41,12 +41,8 @@ struct ipc_ids {
 };
 
 struct seq_file;
-#ifdef CONFIG_IPC_NS
-#define __ipc_init
-#else
-#define __ipc_init	__init
-#endif
-void __ipc_init ipc_init_ids(struct ipc_ids *ids, int size);
+
+void ipc_init_ids(struct ipc_ids *ids, int size);
 #ifdef CONFIG_PROC_FS
 void __init ipc_init_proc_interface(const char *path, const char *header,
 		int ids, int (*show)(struct seq_file *, void *));
diff -puN kernel/Makefile~remove-config_uts_ns-and-config_ipc_ns kernel/Makefile
--- a/kernel/Makefile~remove-config_uts_ns-and-config_ipc_ns
+++ a/kernel/Makefile
@@ -8,7 +8,8 @@ obj-y     = sched.o fork.o exec_domain.o
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o
+	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o \
+	    utsname.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
@@ -48,7 +49,6 @@ obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
-obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 
diff -puN kernel/nsproxy.c~remove-config_uts_ns-and-config_ipc_ns kernel/nsproxy.c
--- a/kernel/nsproxy.c~remove-config_uts_ns-and-config_ipc_ns
+++ a/kernel/nsproxy.c
@@ -155,16 +155,6 @@ int unshare_nsproxy_namespaces(unsigned 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC)))
 		return 0;
 
-#ifndef CONFIG_IPC_NS
-	if (unshare_flags & CLONE_NEWIPC)
-		return -EINVAL;
-#endif
-
-#ifndef CONFIG_UTS_NS
-	if (unshare_flags & CLONE_NEWUTS)
-		return -EINVAL;
-#endif
-
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
diff -puN kernel/utsname_sysctl.c~remove-config_uts_ns-and-config_ipc_ns kernel/utsname_sysctl.c
--- a/kernel/utsname_sysctl.c~remove-config_uts_ns-and-config_ipc_ns
+++ a/kernel/utsname_sysctl.c
@@ -18,10 +18,7 @@
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
-#ifdef CONFIG_UTS_NS
-	struct uts_namespace *uts_ns = current->nsproxy->uts_ns;
-	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
-#endif
+
 	if (!write)
 		down_read(&uts_sem);
 	else
_

Patches currently in -mm which might be from clg@fr.ibm.com are

origin.patch
containersv10-add-tasks-file-interface-fix-2.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
