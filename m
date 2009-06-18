From: akpm@linux-foundation.org
Subject: [merged] ipcns-3-4-make-free_ipc_ns-static.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:42 -0700
Message-ID: <200906182247.n5IMlgru006819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758660AbZFRWsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipcns: make free_ipc_ns() static
has been removed from the -mm tree.  Its filename was
     ipcns-3-4-make-free_ipc_ns-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipcns: make free_ipc_ns() static
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    1 
 ipc/namespace.c               |   48 ++++++++++++++++----------------
 2 files changed, 24 insertions(+), 25 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipcns-3-4-make-free_ipc_ns-static include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipcns-3-4-make-free_ipc_ns-static
+++ a/include/linux/ipc_namespace.h
@@ -94,7 +94,6 @@ static inline int mq_init_ns(struct ipc_
 #endif
 
 #if defined(CONFIG_IPC_NS)
-extern void free_ipc_ns(struct ipc_namespace *ns);
 extern struct ipc_namespace *copy_ipcs(unsigned long flags,
 				       struct ipc_namespace *ns);
 extern void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
diff -puN ipc/namespace.c~ipcns-3-4-make-free_ipc_ns-static ipc/namespace.c
--- a/ipc/namespace.c~ipcns-3-4-make-free_ipc_ns-static
+++ a/ipc/namespace.c
@@ -83,6 +83,30 @@ void free_ipcs(struct ipc_namespace *ns,
 	up_write(&ids->rw_mutex);
 }
 
+static void free_ipc_ns(struct ipc_namespace *ns)
+{
+	/*
+	 * Unregistering the hotplug notifier at the beginning guarantees
+	 * that the ipc namespace won't be freed while we are inside the
+	 * callback routine. Since the blocking_notifier_chain_XXX routines
+	 * hold a rw lock on the notifier list, unregister_ipcns_notifier()
+	 * won't take the rw lock before blocking_notifier_call_chain() has
+	 * released the rd lock.
+	 */
+	unregister_ipcns_notifier(ns);
+	sem_exit_ns(ns);
+	msg_exit_ns(ns);
+	shm_exit_ns(ns);
+	kfree(ns);
+	atomic_dec(&nr_ipc_ns);
+
+	/*
+	 * Do the ipcns removal notification after decrementing nr_ipc_ns in
+	 * order to have a correct value when recomputing msgmni.
+	 */
+	ipcns_notify(IPCNS_REMOVED);
+}
+
 /*
  * put_ipc_ns - drop a reference to an ipc namespace.
  * @ns: the namespace to put
@@ -108,27 +132,3 @@ void put_ipc_ns(struct ipc_namespace *ns
 		free_ipc_ns(ns);
 	}
 }
-
-void free_ipc_ns(struct ipc_namespace *ns)
-{
-	/*
-	 * Unregistering the hotplug notifier at the beginning guarantees
-	 * that the ipc namespace won't be freed while we are inside the
-	 * callback routine. Since the blocking_notifier_chain_XXX routines
-	 * hold a rw lock on the notifier list, unregister_ipcns_notifier()
-	 * won't take the rw lock before blocking_notifier_call_chain() has
-	 * released the rd lock.
-	 */
-	unregister_ipcns_notifier(ns);
-	sem_exit_ns(ns);
-	msg_exit_ns(ns);
-	shm_exit_ns(ns);
-	kfree(ns);
-	atomic_dec(&nr_ipc_ns);
