From: akpm@linux-foundation.org
Subject: - ipc-recompute-msgmni-on-memory-add--remove.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:56 -0700
Message-ID: <200804300543.m3U5huSv029354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758535AbYD3FpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, cmm@us.ibm.com, matthltc@us.ibm.com, pierre.peiffer@bull.net, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     ipc: recompute msgmni on memory add / remove
has been removed from the -mm tree.  Its filename was
     ipc-recompute-msgmni-on-memory-add--remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: recompute msgmni on memory add / remove
From: Nadia Derbey <Nadia.Derbey@bull.net>

Introduce the registration of a callback routine that recomputes msg_ctlmni
upon memory add / remove.

A single notifier block is registered in the hotplug memory chain for all the
ipc namespaces.

Since the ipc namespaces are not linked together, they have their own
notification chain: one notifier_block is defined per ipc namespace.

Each time an ipc namespace is created (removed) it registers (unregisters) its
notifier block in (from) the ipcns chain.  The callback routine registered in
the memory chain invokes the ipcns notifier chain with the IPCNS_LOWMEM event.
 Each callback routine registered in the ipcns namespace, in turn, recomputes
msgmni for the owning namespace.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |   43 ++++++++++++++++++-
 include/linux/memory.h        |    1 
 ipc/Makefile                  |    3 -
 ipc/ipcns_notifier.c          |   71 ++++++++++++++++++++++++++++++++
 ipc/msg.c                     |    2 
 ipc/namespace.c               |   11 ++++
 ipc/util.c                    |   33 ++++++++++++++
 ipc/util.h                    |    2 
 8 files changed, 162 insertions(+), 4 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-recompute-msgmni-on-memory-add--remove include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-recompute-msgmni-on-memory-add--remove
+++ a/include/linux/ipc_namespace.h
@@ -4,6 +4,17 @@
 #include <linux/err.h>
 #include <linux/idr.h>
 #include <linux/rwsem.h>
+#ifdef CONFIG_MEMORY_HOTPLUG
+#include <linux/notifier.h>
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
+/*
+ * ipc namespace events
+ */
+#define IPCNS_MEMCHANGED   0x00000001   /* Notify lowmem size changed */
+
+#define IPCNS_CALLBACK_PRI 0
+
 
 struct ipc_ids {
 	int in_use;
@@ -30,6 +41,10 @@ struct ipc_namespace {
 	size_t		shm_ctlall;
 	int		shm_ctlmni;
 	int		shm_tot;
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+	struct notifier_block ipcns_nb;
+#endif
 };
 
 extern struct ipc_namespace init_ipc_ns;
@@ -37,9 +52,33 @@ extern atomic_t nr_ipc_ns;
 
 #ifdef CONFIG_SYSVIPC
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
-#else
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+
+extern int register_ipcns_notifier(struct ipc_namespace *);
+extern int unregister_ipcns_notifier(struct ipc_namespace *);
+extern int ipcns_notify(unsigned long);
+
+#else /* CONFIG_MEMORY_HOTPLUG */
+
+static inline int register_ipcns_notifier(struct ipc_namespace *ipcns)
+{
+	return 0;
+}
+static inline int unregister_ipcns_notifier(struct ipc_namespace *ipcns)
+{
+	return 0;
+}
+static inline int ipcns_notify(unsigned long ev)
+{
+	return 0;
+}
+
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
+#else /* CONFIG_SYSVIPC */
 #define INIT_IPC_NS(ns)
-#endif
+#endif /* CONFIG_SYSVIPC */
 
 #if defined(CONFIG_SYSVIPC) && defined(CONFIG_IPC_NS)
 extern void free_ipc_ns(struct kref *kref);
diff -puN include/linux/memory.h~ipc-recompute-msgmni-on-memory-add--remove include/linux/memory.h
--- a/include/linux/memory.h~ipc-recompute-msgmni-on-memory-add--remove
+++ a/include/linux/memory.h
@@ -58,6 +58,7 @@ struct mem_section;
  * order in the callback chain)
  */
 #define SLAB_CALLBACK_PRI       1
+#define IPC_CALLBACK_PRI        10
 
 #ifndef CONFIG_MEMORY_HOTPLUG_SPARSE
 static inline int memory_dev_init(void)
diff -puN ipc/Makefile~ipc-recompute-msgmni-on-memory-add--remove ipc/Makefile
--- a/ipc/Makefile~ipc-recompute-msgmni-on-memory-add--remove
+++ a/ipc/Makefile
@@ -3,7 +3,8 @@
 #
 
 obj-$(CONFIG_SYSVIPC_COMPAT) += compat.o
-obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o
+obj_mem-$(CONFIG_MEMORY_HOTPLUG) += ipcns_notifier.o
+obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o $(obj_mem-y)
 obj-$(CONFIG_SYSVIPC_SYSCTL) += ipc_sysctl.o
 obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
diff -puN /dev/null ipc/ipcns_notifier.c
--- /dev/null
+++ a/ipc/ipcns_notifier.c
@@ -0,0 +1,71 @@
+/*
+ * linux/ipc/ipcns_notifier.c
+ * Copyright (C) 2007 BULL SA. Nadia Derbey
+ *
+ * Notification mechanism for ipc namespaces:
+ * The callback routine registered in the memory chain invokes the ipcns
+ * notifier chain with the IPCNS_MEMCHANGED event.
+ * Each callback routine registered in the ipcns namespace recomputes msgmni
+ * for the owning namespace.
+ */
+
+#include <linux/msg.h>
+#include <linux/rcupdate.h>
+#include <linux/notifier.h>
+#include <linux/nsproxy.h>
+#include <linux/ipc_namespace.h>
+
+#include "util.h"
+
+
+
+static BLOCKING_NOTIFIER_HEAD(ipcns_chain);
+
+
+static int ipcns_callback(struct notifier_block *self,
+				unsigned long action, void *arg)
+{
+	struct ipc_namespace *ns;
+
+	switch (action) {
+	case IPCNS_MEMCHANGED:   /* amount of lowmem has changed */
+		/*
+		 * It's time to recompute msgmni
+		 */
+		ns = container_of(self, struct ipc_namespace, ipcns_nb);
+		/*
+		 * No need to get a reference on the ns: the 1st job of
+		 * free_ipc_ns() is to unregister the callback routine.
+		 * blocking_notifier_chain_unregister takes the wr lock to do
+		 * it.
+		 * When this callback routine is called the rd lock is held by
+		 * blocking_notifier_call_chain.
+		 * So the ipc ns cannot be freed while we are here.
+		 */
+		recompute_msgmni(ns);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+int register_ipcns_notifier(struct ipc_namespace *ns)
+{
+	memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
+	ns->ipcns_nb.notifier_call = ipcns_callback;
+	ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
+	return blocking_notifier_chain_register(&ipcns_chain, &ns->ipcns_nb);
+}
+
+int unregister_ipcns_notifier(struct ipc_namespace *ns)
+{
+	return blocking_notifier_chain_unregister(&ipcns_chain,
+						&ns->ipcns_nb);
+}
+
+int ipcns_notify(unsigned long val)
+{
+	return blocking_notifier_call_chain(&ipcns_chain, val, NULL);
+}
diff -puN ipc/msg.c~ipc-recompute-msgmni-on-memory-add--remove ipc/msg.c
--- a/ipc/msg.c~ipc-recompute-msgmni-on-memory-add--remove
+++ a/ipc/msg.c
@@ -84,7 +84,7 @@ static int sysvipc_msg_proc_show(struct 
  * Also take into account the number of nsproxies created so far.
  * This should be done staying within the (MSGMNI , IPCMNI/nr_ipc_ns) range.
  */
-static void recompute_msgmni(struct ipc_namespace *ns)
+void recompute_msgmni(struct ipc_namespace *ns)
 {
 	struct sysinfo i;
 	unsigned long allowed;
diff -puN ipc/namespace.c~ipc-recompute-msgmni-on-memory-add--remove ipc/namespace.c
--- a/ipc/namespace.c~ipc-recompute-msgmni-on-memory-add--remove
+++ a/ipc/namespace.c
@@ -26,6 +26,8 @@ static struct ipc_namespace *clone_ipc_n
 	msg_init_ns(ns);
 	shm_init_ns(ns);
 
+	register_ipcns_notifier(ns);
+
 	kref_init(&ns->kref);
 	return ns;
 }
@@ -81,6 +83,15 @@ void free_ipc_ns(struct kref *kref)
 	struct ipc_namespace *ns;
 
 	ns = container_of(kref, struct ipc_namespace, kref);
+	/*
+	 * Unregistering the hotplug notifier at the beginning guarantees
+	 * that the ipc namespace won't be freed while we are inside the
+	 * callback routine. Since the blocking_notifier_chain_XXX routines
+	 * hold a rw lock on the notifier list, unregister_ipcns_notifier()
+	 * won't take the rw lock before blocking_notifier_call_chain() has
+	 * released the rd lock.
+	 */
+	unregister_ipcns_notifier(ns);
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
diff -puN ipc/util.c~ipc-recompute-msgmni-on-memory-add--remove ipc/util.c
--- a/ipc/util.c~ipc-recompute-msgmni-on-memory-add--remove
+++ a/ipc/util.c
@@ -33,6 +33,7 @@
 #include <linux/audit.h>
 #include <linux/nsproxy.h>
 #include <linux/rwsem.h>
+#include <linux/memory.h>
 #include <linux/ipc_namespace.h>
 
 #include <asm/unistd.h>
@@ -55,11 +56,41 @@ struct ipc_namespace init_ipc_ns = {
 atomic_t nr_ipc_ns = ATOMIC_INIT(1);
 
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+
+static int ipc_memory_callback(struct notifier_block *self,
+				unsigned long action, void *arg)
+{
+	switch (action) {
+	case MEM_ONLINE:    /* memory successfully brought online */
+	case MEM_OFFLINE:   /* or offline: it's time to recompute msgmni */
+		/*
+		 * This is done by invoking the ipcns notifier chain with the
+		 * IPC_MEMCHANGED event.
+		 */
+		ipcns_notify(IPCNS_MEMCHANGED);
+		break;
+	case MEM_GOING_ONLINE:
+	case MEM_GOING_OFFLINE:
+	case MEM_CANCEL_ONLINE:
+	case MEM_CANCEL_OFFLINE:
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
 /**
  *	ipc_init	-	initialise IPC subsystem
  *
  *	The various system5 IPC resources (semaphores, messages and shared
  *	memory) are initialised
+ *	A callback routine is registered into the memory hotplug notifier
+ *	chain: since msgmni scales to lowmem this callback routine will be
+ *	called upon successful memory add / remove to recompute msmgni.
  */
  
 static int __init ipc_init(void)
@@ -67,6 +98,8 @@ static int __init ipc_init(void)
 	sem_init();
 	msg_init();
 	shm_init();
+	hotplug_memory_notifier(ipc_memory_callback, IPC_CALLBACK_PRI);
+	register_ipcns_notifier(&init_ipc_ns);
 	return 0;
 }
 __initcall(ipc_init);
diff -puN ipc/util.h~ipc-recompute-msgmni-on-memory-add--remove ipc/util.h
--- a/ipc/util.h~ipc-recompute-msgmni-on-memory-add--remove
+++ a/ipc/util.h
@@ -124,6 +124,8 @@ extern void free_msg(struct msg_msg *msg
 extern struct msg_msg *load_msg(const void __user *src, int len);
 extern int store_msg(void __user *dest, struct msg_msg *msg, int len);
 
+extern void recompute_msgmni(struct ipc_namespace *);
+
 static inline int ipc_buildid(int id, int seq)
 {
 	return SEQ_MULTIPLIER * seq + id;
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
idr-fix-idr_remove.patch
idr-introduce-the-ridr-structure.patch
idr-introduce-ridr_pre_get.patch
idr-introduce-ridr_init.patch
idr-introduce-ridr_get_new_above.patch
idr-introduce-ridr_get_new.patch
idr-introduce-ridr_find.patch
idr-introduce-ridr_remove.patch
ipc-integrate-the-ridr-code-into-ipc-code.patch
ipc-get-rid-of-ipc_lock_down.patch

