From: akpm@linux-foundation.org
Subject: - ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:01 -0700
Message-ID: <200804300544.m3U5i1Jd029363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756013AbYD3GNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, cmm@us.ibm.com, matthltc@us.ibm.com, pierre.peiffer@bull.net, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     ipc: recompute msgmni on ipc namespace creation/removal
has been removed from the -mm tree.  Its filename was
     ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: recompute msgmni on ipc namespace creation/removal
From: Nadia Derbey <Nadia.Derbey@bull.net>

Introduce a notification mechanism that aims at recomputing msgmni each time
an ipc namespace is created or removed.

The ipc namespace notifier chain already defined for memory hotplug management
is used for that purpose too.

Each time a new ipc namespace is allocated or an existing ipc namespace is
removed, the ipcns notifier chain is notified.  The callback routine for each
registered ipc namespace is then activated in order to recompute msgmni for
that namespace.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |   25 ++-----------------------
 ipc/Makefile                  |    3 +--
 ipc/ipcns_notifier.c          |    2 ++
 ipc/namespace.c               |   12 ++++++++++++
 4 files changed, 17 insertions(+), 25 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-recompute-msgmni-on-ipc-namespace-creation-removal include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-recompute-msgmni-on-ipc-namespace-creation-removal
+++ a/include/linux/ipc_namespace.h
@@ -4,14 +4,14 @@
 #include <linux/err.h>
 #include <linux/idr.h>
 #include <linux/rwsem.h>
-#ifdef CONFIG_MEMORY_HOTPLUG
 #include <linux/notifier.h>
-#endif /* CONFIG_MEMORY_HOTPLUG */
 
 /*
  * ipc namespace events
  */
 #define IPCNS_MEMCHANGED   0x00000001   /* Notify lowmem size changed */
+#define IPCNS_CREATED  0x00000002   /* Notify new ipc namespace created */
+#define IPCNS_REMOVED  0x00000003   /* Notify ipc namespace removed */
 
 #define IPCNS_CALLBACK_PRI 0
 
@@ -42,9 +42,7 @@ struct ipc_namespace {
 	int		shm_ctlmni;
 	int		shm_tot;
 
-#ifdef CONFIG_MEMORY_HOTPLUG
 	struct notifier_block ipcns_nb;
-#endif
 };
 
 extern struct ipc_namespace init_ipc_ns;
@@ -53,29 +51,10 @@ extern atomic_t nr_ipc_ns;
 #ifdef CONFIG_SYSVIPC
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-
 extern int register_ipcns_notifier(struct ipc_namespace *);
 extern int unregister_ipcns_notifier(struct ipc_namespace *);
 extern int ipcns_notify(unsigned long);
 
-#else /* CONFIG_MEMORY_HOTPLUG */
-
-static inline int register_ipcns_notifier(struct ipc_namespace *ipcns)
-{
-	return 0;
-}
-static inline int unregister_ipcns_notifier(struct ipc_namespace *ipcns)
-{
-	return 0;
-}
-static inline int ipcns_notify(unsigned long ev)
-{
-	return 0;
-}
-
-#endif /* CONFIG_MEMORY_HOTPLUG */
-
 #else /* CONFIG_SYSVIPC */
 #define INIT_IPC_NS(ns)
 #endif /* CONFIG_SYSVIPC */
diff -puN ipc/Makefile~ipc-recompute-msgmni-on-ipc-namespace-creation-removal ipc/Makefile
--- a/ipc/Makefile~ipc-recompute-msgmni-on-ipc-namespace-creation-removal
+++ a/ipc/Makefile
@@ -3,8 +3,7 @@
 #
 
 obj-$(CONFIG_SYSVIPC_COMPAT) += compat.o
-obj_mem-$(CONFIG_MEMORY_HOTPLUG) += ipcns_notifier.o
-obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o $(obj_mem-y)
+obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o ipcns_notifier.o
 obj-$(CONFIG_SYSVIPC_SYSCTL) += ipc_sysctl.o
 obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
diff -puN ipc/ipcns_notifier.c~ipc-recompute-msgmni-on-ipc-namespace-creation-removal ipc/ipcns_notifier.c
--- a/ipc/ipcns_notifier.c~ipc-recompute-msgmni-on-ipc-namespace-creation-removal
+++ a/ipc/ipcns_notifier.c
@@ -29,6 +29,8 @@ static int ipcns_callback(struct notifie
 
 	switch (action) {
 	case IPCNS_MEMCHANGED:   /* amount of lowmem has changed */
+	case IPCNS_CREATED:
+	case IPCNS_REMOVED:
 		/*
 		 * It's time to recompute msgmni
 		 */
diff -puN ipc/namespace.c~ipc-recompute-msgmni-on-ipc-namespace-creation-removal ipc/namespace.c
--- a/ipc/namespace.c~ipc-recompute-msgmni-on-ipc-namespace-creation-removal
+++ a/ipc/namespace.c
@@ -26,6 +26,12 @@ static struct ipc_namespace *clone_ipc_n
 	msg_init_ns(ns);
 	shm_init_ns(ns);
 
+	/*
+	 * msgmni has already been computed for the new ipc ns.
+	 * Thus, do the ipcns creation notification before registering that
+	 * new ipcns in the chain.
+	 */
+	ipcns_notify(IPCNS_CREATED);
 	register_ipcns_notifier(ns);
 
 	kref_init(&ns->kref);
@@ -97,4 +103,10 @@ void free_ipc_ns(struct kref *kref)
 	shm_exit_ns(ns);
 	kfree(ns);
 	atomic_dec(&nr_ipc_ns);
+
+	/*
+	 * Do the ipcns removal notification after decrementing nr_ipc_ns in
+	 * order to have a correct value when recomputing msgmni.
+	 */
+	ipcns_notify(IPCNS_REMOVED);
 }
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

