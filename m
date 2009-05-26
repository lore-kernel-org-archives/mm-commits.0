From: akpm@linux-foundation.org
Subject: + ipcns-3-4-make-free_ipc_ns-static.patch added to -mm tree
Date: Tue, 26 May 2009 16:16:10 -0700
Message-ID: <200905262316.n4QNGAnB030974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756883AbZEZXQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 19:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     ipcns: make free_ipc_ns() static
has been added to the -mm tree.  Its filename is
     ipcns-3-4-make-free_ipc_ns-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipcns: make free_ipc_ns() static
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
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
-
-	/*
-	 * Do the ipcns removal notification after decrementing nr_ipc_ns in
-	 * order to have a correct value when recomputing msgmni.
-	 */
-	ipcns_notify(IPCNS_REMOVED);
-}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

cred-include-inith-in-credh.patch
procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch
linux-next.patch
mm-consolidate-init_mm-definition.patch
mm-consolidate-init_mm-definition-fix.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
pagemap-export-pg_hwpoison.patch
pagemap-export-pg_hwpoison-fix.patch
groups-move-code-to-kernel-groupsc.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
fs-remove-sparse-errors-in-proc_devtreec.patch
proc-merge-arrayc-into-basec.patch
pidns-make-create_pid_namespace-accept-parent-pidns.patch
pidns-rewrite-copy_pid_ns.patch
utsns-extract-creeate_uts_ns.patch
ipcns-remove-useless-get-put-while-clone_newipc.patch
ipcns-extract-create_ipc_ns.patch
nsproxy-extract-create_nsproxy.patch
ipcns-3-4-make-free_ipc_ns-static.patch

