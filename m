From: akpm@linux-foundation.org
Subject: + ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch added to -mm tree
Date: Mon, 11 Feb 2008 12:51:34 -0800
Message-ID: <200802112052.m1BKpZts032327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbYBKVBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 16:01:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, cmm@us.ibm.com, matthltc@us.ibm.com, pierre.peiffer@bull.net, y-goto@jp.fujitsu.com


The patch titled
     ipc: re-enable msgmni automatic recomputing msgmni if set to negative
has been added to the -mm tree.  Its filename is
     ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: re-enable msgmni automatic recomputing msgmni if set to negative
From: Nadia Derbey <Nadia.Derbey@bull.net>

The enhancement as asked for by Yasunori: if msgmni is set to a negative
value, register it back into the ipcns notifier chain.

A new interface has been added to the notification mechanism:
notifier_chain_cond_register() registers a notifier block only if not already
registered.  With that new interface we avoid taking care of the states
changes in procfs.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    1 
 include/linux/notifier.h      |    4 ++
 ipc/ipc_sysctl.c              |   45 ++++++++++++++++++++++++--------
 ipc/ipcns_notifier.c          |    9 ++++++
 kernel/notifier.c             |   38 +++++++++++++++++++++++++++
 5 files changed, 87 insertions(+), 10 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative
+++ a/include/linux/ipc_namespace.h
@@ -52,6 +52,7 @@ extern atomic_t nr_ipc_ns;
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
 
 extern int register_ipcns_notifier(struct ipc_namespace *);
+extern int cond_register_ipcns_notifier(struct ipc_namespace *);
 extern int unregister_ipcns_notifier(struct ipc_namespace *);
 extern int ipcns_notify(unsigned long);
 
diff -puN include/linux/notifier.h~ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative include/linux/notifier.h
--- a/include/linux/notifier.h~ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative
+++ a/include/linux/notifier.h
@@ -121,6 +121,10 @@ extern int raw_notifier_chain_register(s
 extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
 		struct notifier_block *nb);
 
+extern int blocking_notifier_chain_cond_register(
+		struct blocking_notifier_head *nh,
+		struct notifier_block *nb);
+
 extern int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
 		struct notifier_block *nb);
 extern int blocking_notifier_chain_unregister(struct blocking_notifier_head *nh,
diff -puN ipc/ipc_sysctl.c~ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative
+++ a/ipc/ipc_sysctl.c
@@ -15,6 +15,8 @@
 #include <linux/sysctl.h>
 #include <linux/uaccess.h>
 #include <linux/ipc_namespace.h>
+#include <linux/msg.h>
+#include "util.h"
 
 static void *get_ipc(ctl_table *table)
 {
@@ -24,6 +26,27 @@ static void *get_ipc(ctl_table *table)
 	return which;
 }
 
+/*
+ * Routine that is called when a tunable has successfully been changed by
+ * hand and it has a callback routine registered on the ipc namespace notifier
+ * chain: we don't want such tunables to be recomputed anymore upon memory
+ * add/remove or ipc namespace creation/removal.
+ * They can come back to a recomputable state by being set to a <0 value.
+ */
+static void tunable_set_callback(int val)
+{
+	if (val >= 0)
+		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
+	else {
+		/*
+		 * Re-enable automatic recomputing only if not already
+		 * enabled.
+		 */
+		recompute_msgmni(current->nsproxy->ipc_ns);
+		cond_register_ipcns_notifier(current->nsproxy->ipc_ns);
+	}
+}
+
 #ifdef CONFIG_PROC_FS
 static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -38,17 +61,17 @@ static int proc_ipc_dointvec(ctl_table *
 static int proc_ipc_callback_dointvec(ctl_table *table, int write,
 	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
 {
+	struct ctl_table ipc_table;
 	size_t lenp_bef = *lenp;
 	int rc;
 
-	rc = proc_ipc_dointvec(table, write, filp, buffer, lenp, ppos);
+	memcpy(&ipc_table, table, sizeof(ipc_table));
+	ipc_table.data = get_ipc(table);
+
+	rc = proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);
 
 	if (write && !rc && lenp_bef == *lenp)
-		/*
-		 * Tunable has successfully been changed from userland:
-		 * disable its automatic recomputing.
-		 */
-		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
+		tunable_set_callback(*((int *)(ipc_table.data)));
 
 	return rc;
 }
@@ -119,12 +142,14 @@ static int sysctl_ipc_registered_data(ct
 	rc = sysctl_ipc_data(table, name, nlen, oldval, oldlenp, newval,
 		newlen);
 
-	if (newval && newlen && rc > 0)
+	if (newval && newlen && rc > 0) {
 		/*
-		 * Tunable has successfully been changed from userland:
-		 * disable its automatic recomputing.
+		 * Tunable has successfully been changed from userland
 		 */
-		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
+		int *data = get_ipc(table);
+
+		tunable_set_callback(*data);
+	}
 
 	return rc;
 }
diff -puN ipc/ipcns_notifier.c~ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative ipc/ipcns_notifier.c
--- a/ipc/ipcns_notifier.c~ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative
+++ a/ipc/ipcns_notifier.c
@@ -61,6 +61,15 @@ int register_ipcns_notifier(struct ipc_n
 	return blocking_notifier_chain_register(&ipcns_chain, &ns->ipcns_nb);
 }
 
+int cond_register_ipcns_notifier(struct ipc_namespace *ns)
+{
+	memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
+	ns->ipcns_nb.notifier_call = ipcns_callback;
+	ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
+	return blocking_notifier_chain_cond_register(&ipcns_chain,
+							&ns->ipcns_nb);
+}
+
 int unregister_ipcns_notifier(struct ipc_namespace *ns)
 {
 	return blocking_notifier_chain_unregister(&ipcns_chain,
diff -puN kernel/notifier.c~ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative kernel/notifier.c
--- a/kernel/notifier.c~ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative
+++ a/kernel/notifier.c
@@ -31,6 +31,21 @@ static int notifier_chain_register(struc
 	return 0;
 }
 
+static int notifier_chain_cond_register(struct notifier_block **nl,
+		struct notifier_block *n)
+{
+	while ((*nl) != NULL) {
+		if ((*nl) == n)
+			return 0;
+		if (n->priority > (*nl)->priority)
+			break;
+		nl = &((*nl)->next);
+	}
+	n->next = *nl;
+	rcu_assign_pointer(*nl, n);
+	return 0;
+}
+
 static int notifier_chain_unregister(struct notifier_block **nl,
 		struct notifier_block *n)
 {
@@ -205,6 +220,29 @@ int blocking_notifier_chain_register(str
 EXPORT_SYMBOL_GPL(blocking_notifier_chain_register);
 
 /**
+ *	blocking_notifier_chain_cond_register - Cond add notifier to a blocking notifier chain
+ *	@nh: Pointer to head of the blocking notifier chain
+ *	@n: New entry in notifier chain
+ *
+ *	Adds a notifier to a blocking notifier chain, only if not already
+ *	present in the chain.
+ *	Must be called in process context.
+ *
+ *	Currently always returns zero.
+ */
+int blocking_notifier_chain_cond_register(struct blocking_notifier_head *nh,
+		struct notifier_block *n)
+{
+	int ret;
+
+	down_write(&nh->rwsem);
+	ret = notifier_chain_cond_register(&nh->head, n);
+	up_write(&nh->rwsem);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(blocking_notifier_chain_cond_register);
+
+/**
  *	blocking_notifier_chain_unregister - Remove notifier from a blocking notifier chain
  *	@nh: Pointer to head of the blocking notifier chain
  *	@n: Entry to remove from notifier chain
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
