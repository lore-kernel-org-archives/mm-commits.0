From: akpm@osdl.org
Subject: - uts-namespace-remove-config_uts_ns.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:25:15 -0800
Message-ID: <200702010126.l111QDtA032679@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35739 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161212AbXBAB0y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:26:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     uts namespace: remove CONFIG_UTS_NS
has been removed from the -mm tree.  Its filename was
     uts-namespace-remove-config_uts_ns.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: uts namespace: remove CONFIG_UTS_NS
From: Cedric Le Goater <clg@fr.ibm.com>

CONFIG_UTS_NS has very little value as it only deactivates the unshare
of the uts namespace and does not improve performance.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Acked-by: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/ipc.h     |   16 ++++++++--------
 include/linux/utsname.h |   19 -------------------
 init/Kconfig            |   17 -----------------
 ipc/msg.c               |    4 +---
 ipc/sem.c               |    4 +---
 ipc/shm.c               |    4 +---
 ipc/util.c              |    4 +---
 ipc/util.h              |    8 ++------
 kernel/Makefile         |    3 +--
 kernel/fork.c           |    2 +-
 kernel/sysctl.c         |    3 +--
 11 files changed, 17 insertions(+), 67 deletions(-)

diff -puN include/linux/utsname.h~uts-namespace-remove-config_uts_ns include/linux/utsname.h
--- a/include/linux/utsname.h~uts-namespace-remove-config_uts_ns
+++ a/include/linux/utsname.h
@@ -48,7 +48,6 @@ static inline void get_uts_ns(struct uts
 	kref_get(&ns->kref);
 }
 
-#ifdef CONFIG_UTS_NS
 extern int unshare_utsname(unsigned long unshare_flags,
 				struct uts_namespace **new_uts);
 extern int copy_utsname(int flags, struct task_struct *tsk);
@@ -58,24 +57,6 @@ static inline void put_uts_ns(struct uts
 {
 	kref_put(&ns->kref, free_uts_ns);
 }
-#else
-static inline int unshare_utsname(unsigned long unshare_flags,
-			struct uts_namespace **new_uts)
-{
-	if (unshare_flags & CLONE_NEWUTS)
-		return -EINVAL;
-
-	return 0;
-}
-
-static inline int copy_utsname(int flags, struct task_struct *tsk)
-{
-	return 0;
-}
-static inline void put_uts_ns(struct uts_namespace *ns)
-{
-}
-#endif
 
 static inline struct new_utsname *utsname(void)
 {
diff -puN init/Kconfig~uts-namespace-remove-config_uts_ns init/Kconfig
--- a/init/Kconfig~uts-namespace-remove-config_uts_ns
+++ a/init/Kconfig
@@ -138,15 +138,6 @@ config SYSVIPC
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
 config POSIX_MQUEUE
 	bool "POSIX Message Queues"
 	depends on NET && EXPERIMENTAL
@@ -232,14 +223,6 @@ config TASK_IO_ACCOUNTING
 
 	  Say N if unsure.
 
-config UTS_NS
-	bool "UTS Namespaces"
-	default n
-	help
-	  Support uts namespaces.  This allows containers, i.e.
-	  vservers, to use uts namespaces to provide different
-	  uts info for different servers.  If unsure, say N.
-
 config USER_NS
 	bool "User Namespaces"
 	default n
diff -puN kernel/Makefile~uts-namespace-remove-config_uts_ns kernel/Makefile
--- a/kernel/Makefile~uts-namespace-remove-config_uts_ns
+++ a/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o
+	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o utsname.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
@@ -47,7 +47,6 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_RELAY) += relay.o
-obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 
diff -puN kernel/sysctl.c~uts-namespace-remove-config_uts_ns kernel/sysctl.c
--- a/kernel/sysctl.c~uts-namespace-remove-config_uts_ns
+++ a/kernel/sysctl.c
@@ -181,10 +181,9 @@ int sysctl_legacy_va_layout;
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
-#ifdef CONFIG_UTS_NS
 	struct uts_namespace *uts_ns = current->nsproxy->uts_ns;
 	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
-#endif
+
 	if (!write)
 		down_read(&uts_sem);
 	else
diff -puN include/linux/ipc.h~uts-namespace-remove-config_uts_ns include/linux/ipc.h
--- a/include/linux/ipc.h~uts-namespace-remove-config_uts_ns
+++ a/include/linux/ipc.h
@@ -92,15 +92,17 @@ extern struct ipc_namespace init_ipc_ns;
 
 #ifdef CONFIG_SYSVIPC
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
-#else
-#define INIT_IPC_NS(ns)
-#endif
 
-#ifdef CONFIG_IPC_NS
 extern void free_ipc_ns(struct kref *kref);
 extern int copy_ipcs(unsigned long flags, struct task_struct *tsk);
 extern int unshare_ipcs(unsigned long flags, struct ipc_namespace **ns);
+
 #else
+#define INIT_IPC_NS(ns)
+
+static inline void free_ipc_ns(struct kref *kref)
+{
+}
 static inline int copy_ipcs(unsigned long flags, struct task_struct *tsk)
 {
 	return 0;
@@ -109,7 +111,7 @@ static inline int copy_ipcs(unsigned lon
 
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 {
-#ifdef CONFIG_IPC_NS
+#ifdef CONFIG_SYSVIPC
 	if (ns)
 		kref_get(&ns->kref);
 #endif
@@ -118,7 +120,7 @@ static inline struct ipc_namespace *get_
 
 static inline void put_ipc_ns(struct ipc_namespace *ns)
 {
-#ifdef CONFIG_IPC_NS
+#ifdef CONFIG_SYSVIPC
 	kref_put(&ns->kref, free_ipc_ns);
 #endif
 }
@@ -126,5 +128,3 @@ static inline void put_ipc_ns(struct ipc
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_IPC_H */
-
-
diff -puN ipc/msg.c~uts-namespace-remove-config_uts_ns ipc/msg.c
--- a/ipc/msg.c~uts-namespace-remove-config_uts_ns
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
diff -puN ipc/sem.c~uts-namespace-remove-config_uts_ns ipc/sem.c
--- a/ipc/sem.c~uts-namespace-remove-config_uts_ns
+++ a/ipc/sem.c
@@ -122,7 +122,7 @@ static int sysvipc_sem_proc_show(struct 
 #define sc_semopm	sem_ctls[2]
 #define sc_semmni	sem_ctls[3]
 
-static void __ipc_init __sem_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
+static void __sem_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
 {
 	ns->ids[IPC_SEM_IDS] = ids;
 	ns->sc_semmsl = SEMMSL;
@@ -133,7 +133,6 @@ static void __ipc_init __sem_init_ns(str
 	ipc_init_ids(ids, ns->sc_semmni);
 }
 
-#ifdef CONFIG_IPC_NS
 int sem_init_ns(struct ipc_namespace *ns)
 {
 	struct ipc_ids *ids;
@@ -165,7 +164,6 @@ void sem_exit_ns(struct ipc_namespace *n
 	kfree(ns->ids[IPC_SEM_IDS]);
 	ns->ids[IPC_SEM_IDS] = NULL;
 }
-#endif
 
 void __init sem_init (void)
 {
diff -puN ipc/shm.c~uts-namespace-remove-config_uts_ns ipc/shm.c
--- a/ipc/shm.c~uts-namespace-remove-config_uts_ns
+++ a/ipc/shm.c
@@ -67,7 +67,7 @@ static void shm_destroy (struct ipc_name
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it);
 #endif
 
-static void __ipc_init __shm_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
+static void __shm_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
 {
 	ns->ids[IPC_SHM_IDS] = ids;
 	ns->shm_ctlmax = SHMMAX;
@@ -88,7 +88,6 @@ static void do_shm_rmid(struct ipc_names
 		shm_destroy(ns, shp);
 }
 
-#ifdef CONFIG_IPC_NS
 int shm_init_ns(struct ipc_namespace *ns)
 {
 	struct ipc_ids *ids;
@@ -120,7 +119,6 @@ void shm_exit_ns(struct ipc_namespace *n
 	kfree(ns->ids[IPC_SHM_IDS]);
 	ns->ids[IPC_SHM_IDS] = NULL;
 }
-#endif
 
 void __init shm_init (void)
 {
diff -puN ipc/util.c~uts-namespace-remove-config_uts_ns ipc/util.c
--- a/ipc/util.c~uts-namespace-remove-config_uts_ns
+++ a/ipc/util.c
@@ -51,7 +51,6 @@ struct ipc_namespace init_ipc_ns = {
 	},
 };
 
-#ifdef CONFIG_IPC_NS
 static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
 {
 	int err;
@@ -144,7 +143,6 @@ void free_ipc_ns(struct kref *kref)
 	shm_exit_ns(ns);
 	kfree(ns);
 }
-#endif
 
 /**
  *	ipc_init	-	initialise IPC subsystem
@@ -172,7 +170,7 @@ __initcall(ipc_init);
  *	array itself. 
  */
  
-void __ipc_init ipc_init_ids(struct ipc_ids* ids, int size)
+void ipc_init_ids(struct ipc_ids* ids, int size)
 {
 	int i;
 
diff -puN ipc/util.h~uts-namespace-remove-config_uts_ns ipc/util.h
--- a/ipc/util.h~uts-namespace-remove-config_uts_ns
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
diff -puN kernel/fork.c~uts-namespace-remove-config_uts_ns kernel/fork.c
--- a/kernel/fork.c~uts-namespace-remove-config_uts_ns
+++ a/kernel/fork.c
@@ -1600,7 +1600,7 @@ static int unshare_semundo(unsigned long
 	return 0;
 }
 
-#ifndef CONFIG_IPC_NS
+#ifndef CONFIG_SYSVIPC
 static inline int unshare_ipcs(unsigned long flags, struct ipc_namespace **ns)
 {
 	if (flags & CLONE_NEWIPC)
_

Patches currently in -mm which might be from clg@fr.ibm.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
mxser-remove-useless-fields.patch
uts-namespace-remove-config_uts_ns.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
