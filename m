From: akpm@linux-foundation.org
Subject: + ipc-do-not-use-a-negative-value-to-re-enable-msgmni-automatic-recomputing.patch added to -mm tree
Date: Tue, 22 Jul 2008 03:35:43 -0700
Message-ID: <200807221035.m6MAZhQZ023705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755310AbYGVKgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 06:36:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, Solofo.Ramangalahy@bull.net


The patch titled
     ipc: do not use a negative value to re-enable msgmni automatic recomputing
has been added to the -mm tree.  Its filename is
     ipc-do-not-use-a-negative-value-to-re-enable-msgmni-automatic-recomputing.patch

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
Subject: ipc: do not use a negative value to re-enable msgmni automatic recomputing
From: Nadia.Derbey@bull.net

This patch proposes an alternative to the "magical
positive-versus-negative number trick" Andrew complained about last week
in http://lkml.org/lkml/2008/6/24/418.

This had been introduced with the patches that scale msgmni to the amount
of lowmem.  With these patches, msgmni has a registered notification
routine that recomputes msgmni value upon memory add/remove or ipc
namespace creation/ removal.

When msgmni is changed from user space (i.e.  value written to the proc
file), that notification routine is unregistered, and the way to make it
registered back is to write a negative value into the proc file.  This is
the "magical positive-versus-negative number trick".

To fix this, a new proc file is introduced: /proc/sys/kernel/auto_msgmni.
This file acts as ON/OFF for msgmni automatic recomputing.

With this patch, the process is the following:
1) kernel boots in "automatic recomputing mode"
   /proc/sys/kernel/msgmni contains the value that has been computed (depends
                           on lowmem)
   /proc/sys/kernel/automatic_msgmni contains "1"

2) echo <val> > /proc/sys/kernel/msgmni
   . sets msg_ctlmni to <val>
   . de-activates automatic recomputing (i.e. if, say, some memory is added
     msgmni won't be recomputed anymore)
   . /proc/sys/kernel/automatic_msgmni now contains "0"

3) echo "0" > /proc/sys/kernel/automatic_msgmni
   . de-activates msgmni automatic recomputing
     this has the same effect as 2) except that msg_ctlmni's value stays
     blocked at its current value)

3) echo "1" > /proc/sys/kernel/automatic_msgmni
   . recomputes msgmni's value based on the current available memory size
     and number of ipc namespaces
   . re-activates automatic recomputing for msgmni.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    3 -
 ipc/ipc_sysctl.c              |   72 ++++++++++++++++++++++++++------
 ipc/ipcns_notifier.c          |   20 ++++++--
 3 files changed, 76 insertions(+), 19 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-do-not-use-a-negative-value-to-re-enable-msgmni-automatic-recomputing include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-do-not-use-a-negative-value-to-re-enable-msgmni-automatic-recomputing
+++ a/include/linux/ipc_namespace.h
@@ -36,6 +36,7 @@ struct ipc_namespace {
 	int		msg_ctlmni;
 	atomic_t	msg_bytes;
 	atomic_t	msg_hdrs;
+	int		auto_msgmni;
 
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
@@ -53,7 +54,7 @@ extern atomic_t nr_ipc_ns;
 
 extern int register_ipcns_notifier(struct ipc_namespace *);
 extern int cond_register_ipcns_notifier(struct ipc_namespace *);
-extern int unregister_ipcns_notifier(struct ipc_namespace *);
+extern void unregister_ipcns_notifier(struct ipc_namespace *);
 extern int ipcns_notify(unsigned long);
 
 #else /* CONFIG_SYSVIPC */
diff -puN ipc/ipc_sysctl.c~ipc-do-not-use-a-negative-value-to-re-enable-msgmni-automatic-recomputing ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-do-not-use-a-negative-value-to-re-enable-msgmni-automatic-recomputing
+++ a/ipc/ipc_sysctl.c
@@ -27,15 +27,17 @@ static void *get_ipc(ctl_table *table)
 }
 
 /*
- * Routine that is called when a tunable has successfully been changed by
- * hand and it has a callback routine registered on the ipc namespace notifier
- * chain: we don't want such tunables to be recomputed anymore upon memory
- * add/remove or ipc namespace creation/removal.
- * They can come back to a recomputable state by being set to a <0 value.
+ * Routine that is called when the file "auto_msgmni" has successfully been
+ * written.
+ * Two values are allowed:
+ * 0: unregister msgmni's callback routine from the ipc namespace notifier
+ *    chain. This means that msgmni won't be recomputed anymore upon memory
+ *    add/remove or ipc namespace creation/removal.
+ * 1: register back the callback routine.
  */
-static void tunable_set_callback(int val)
+static void ipc_auto_callback(int val)
 {
-	if (val >= 0)
+	if (!val)
 		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
 	else {
 		/*
@@ -71,7 +73,12 @@ static int proc_ipc_callback_dointvec(ct
 	rc = proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);
 
 	if (write && !rc && lenp_bef == *lenp)
-		tunable_set_callback(*((int *)(ipc_table.data)));
+		/*
+		 * Tunable has successfully been changed by hand. Disable its
+		 * automatic adjustment. This simply requires unregistering
+		 * the notifiers that trigger recalculation.
+		 */
+		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
 
 	return rc;
 }
@@ -87,10 +94,39 @@ static int proc_ipc_doulongvec_minmax(ct
 					lenp, ppos);
 }
 
+static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
+	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table ipc_table;
+	size_t lenp_bef = *lenp;
+	int oldval;
+	int rc;
+
+	memcpy(&ipc_table, table, sizeof(ipc_table));
+	ipc_table.data = get_ipc(table);
+	oldval = *((int *)(ipc_table.data));
+
+	rc = proc_dointvec_minmax(&ipc_table, write, filp, buffer, lenp, ppos);
+
+	if (write && !rc && lenp_bef == *lenp) {
+		int newval = *((int *)(ipc_table.data));
+		/*
+		 * The file "auto_msgmni" has correctly been set.
+		 * React by (un)registering the corresponding tunable, if the
+		 * value has changed.
+		 */
+		if (newval != oldval)
+			ipc_auto_callback(newval);
+	}
+
+	return rc;
+}
+
 #else
 #define proc_ipc_doulongvec_minmax NULL
 #define proc_ipc_dointvec	   NULL
 #define proc_ipc_callback_dointvec NULL
+#define proc_ipcauto_dointvec_minmax NULL
 #endif
 
 #ifdef CONFIG_SYSCTL_SYSCALL
@@ -142,14 +178,11 @@ static int sysctl_ipc_registered_data(ct
 	rc = sysctl_ipc_data(table, name, nlen, oldval, oldlenp, newval,
 		newlen);
 
-	if (newval && newlen && rc > 0) {
+	if (newval && newlen && rc > 0)
 		/*
 		 * Tunable has successfully been changed from userland
 		 */
-		int *data = get_ipc(table);
-
-		tunable_set_callback(*data);
-	}
+		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
 
 	return rc;
 }
@@ -158,6 +191,9 @@ static int sysctl_ipc_registered_data(ct
 #define sysctl_ipc_registered_data NULL
 #endif
 
+static int zero;
+static int one = 1;
+
 static struct ctl_table ipc_kern_table[] = {
 	{
 		.ctl_name	= KERN_SHMMAX,
@@ -222,6 +258,16 @@ static struct ctl_table ipc_kern_table[]
 		.proc_handler	= proc_ipc_dointvec,
 		.strategy	= sysctl_ipc_data,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "auto_msgmni",
+		.data		= &init_ipc_ns.auto_msgmni,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_ipcauto_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 	{}
 };
 
diff -puN ipc/ipcns_notifier.c~ipc-do-not-use-a-negative-value-to-re-enable-msgmni-automatic-recomputing ipc/ipcns_notifier.c
--- a/ipc/ipcns_notifier.c~ipc-do-not-use-a-negative-value-to-re-enable-msgmni-automatic-recomputing
+++ a/ipc/ipcns_notifier.c
@@ -55,25 +55,35 @@ static int ipcns_callback(struct notifie
 
 int register_ipcns_notifier(struct ipc_namespace *ns)
 {
+	int rc;
+
 	memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
 	ns->ipcns_nb.notifier_call = ipcns_callback;
 	ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
-	return blocking_notifier_chain_register(&ipcns_chain, &ns->ipcns_nb);
+	rc = blocking_notifier_chain_register(&ipcns_chain, &ns->ipcns_nb);
+	if (!rc)
+		ns->auto_msgmni = 1;
+	return rc;
 }
 
 int cond_register_ipcns_notifier(struct ipc_namespace *ns)
 {
+	int rc;
+
 	memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
 	ns->ipcns_nb.notifier_call = ipcns_callback;
 	ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
-	return blocking_notifier_chain_cond_register(&ipcns_chain,
+	rc = blocking_notifier_chain_cond_register(&ipcns_chain,
 							&ns->ipcns_nb);
+	if (!rc)
+		ns->auto_msgmni = 1;
+	return rc;
 }
 
-int unregister_ipcns_notifier(struct ipc_namespace *ns)
+void unregister_ipcns_notifier(struct ipc_namespace *ns)
 {
-	return blocking_notifier_chain_unregister(&ipcns_chain,
-						&ns->ipcns_nb);
+	blocking_notifier_chain_unregister(&ipcns_chain, &ns->ipcns_nb);
+	ns->auto_msgmni = 0;
 }
 
 int ipcns_notify(unsigned long val)
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_get_new-rcu-safe-fix.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
ipc-semc-convert-undo-structures-to-struct-list_head.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-remove-unused-entries-from-struct-sem_queue.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
ipc-use-simple_read_from_buffer.patch
ipc-do-not-use-a-negative-value-to-re-enable-msgmni-automatic-recomputing.patch

