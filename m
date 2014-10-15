From: akpm@linux-foundation.org
Subject: + ipc-msg-increase-msgmni-remove-scaling.patch added to -mm tree
Date: Wed, 15 Oct 2014 15:04:37 -0700
Message-ID: <543eef75.RuxI5QiAsGMiCh76%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaJOWEi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 18:04:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, aquini@redhat.com, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: increase MSGMNI, remove scaling
has been added to the -mm tree.  Its filename is
     ipc-msg-increase-msgmni-remove-scaling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msg-increase-msgmni-remove-scaling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msg-increase-msgmni-remove-scaling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/msg: increase MSGMNI, remove scaling

SysV can be abused to allocate locked kernel memory.  For most systems, a
small limit doesn't make sense, see the discussion with regards to SHMMAX.

Therefore: increase MSGMNI to the maximum supported.

And: If we ignore the risk of locking too much memory, then an automatic
scaling of MSGMNI doesn't make sense.  Therefore the logic can be removed.

The code preserves auto_msgmni to avoid breaking any user space applications
that expect that the value exists.

Notes:
1) If an administrator must limit the memory allocations, then he can set
MSGMNI as necessary.

Or he can disable sysv entirely (as e.g. done by Android).

2) MSGMAX and MSGMNB are intentionally not increased, as these values are used
to control latency vs. throughput:
If MSGMNB is large, then msgsnd() just returns and more messages can be queued
before a task switch to a task that calls msgrcv() is forced.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   10 +--
 include/linux/ipc_namespace.h   |   20 ------
 include/uapi/linux/msg.h        |   28 ++++++---
 ipc/Makefile                    |    2 
 ipc/ipc_sysctl.c                |   93 +++++-------------------------
 ipc/ipcns_notifier.c            |   92 -----------------------------
 ipc/msg.c                       |   36 -----------
 ipc/namespace.c                 |   22 -------
 ipc/util.c                      |   40 ------------
 9 files changed, 45 insertions(+), 298 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~ipc-msg-increase-msgmni-remove-scaling Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~ipc-msg-increase-msgmni-remove-scaling
+++ a/Documentation/sysctl/kernel.txt
@@ -115,10 +115,12 @@ set during run time.
 
 auto_msgmni:
 
-Enables/Disables automatic recomputing of msgmni upon memory add/remove
-or upon ipc namespace creation/removal (see the msgmni description
-above). Echoing "1" into this file enables msgmni automatic recomputing.
-Echoing "0" turns it off. auto_msgmni default value is 1.
+This variable has no effect and may be removed in future kernel
+releases. Reading it always returns 0.
+Up to Linux 3.17, it enabled/disabled automatic recomputing of msgmni
+upon memory add/remove or upon ipc namespace creation/removal.
+Echoing "1" into this file enabled msgmni automatic recomputing.
+Echoing "0" turned it off. auto_msgmni default value was 1.
 
 
 ==============================================================
diff -puN include/linux/ipc_namespace.h~ipc-msg-increase-msgmni-remove-scaling include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-msg-increase-msgmni-remove-scaling
+++ a/include/linux/ipc_namespace.h
@@ -7,15 +7,6 @@
 #include <linux/notifier.h>
 #include <linux/nsproxy.h>
 
-/*
- * ipc namespace events
- */
-#define IPCNS_MEMCHANGED   0x00000001   /* Notify lowmem size changed */
-#define IPCNS_CREATED  0x00000002   /* Notify new ipc namespace created */
-#define IPCNS_REMOVED  0x00000003   /* Notify ipc namespace removed */
-
-#define IPCNS_CALLBACK_PRI 0
-
 struct user_namespace;
 
 struct ipc_ids {
@@ -38,7 +29,6 @@ struct ipc_namespace {
 	unsigned int	msg_ctlmni;
 	atomic_t	msg_bytes;
 	atomic_t	msg_hdrs;
-	int		auto_msgmni;
 
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
@@ -77,18 +67,8 @@ extern atomic_t nr_ipc_ns;
 extern spinlock_t mq_lock;
 
 #ifdef CONFIG_SYSVIPC
-extern int register_ipcns_notifier(struct ipc_namespace *);
-extern int cond_register_ipcns_notifier(struct ipc_namespace *);
-extern void unregister_ipcns_notifier(struct ipc_namespace *);
-extern int ipcns_notify(unsigned long);
 extern void shm_destroy_orphaned(struct ipc_namespace *ns);
 #else /* CONFIG_SYSVIPC */
-static inline int register_ipcns_notifier(struct ipc_namespace *ns)
-{ return 0; }
-static inline int cond_register_ipcns_notifier(struct ipc_namespace *ns)
-{ return 0; }
-static inline void unregister_ipcns_notifier(struct ipc_namespace *ns) { }
-static inline int ipcns_notify(unsigned long l) { return 0; }
 static inline void shm_destroy_orphaned(struct ipc_namespace *ns) {}
 #endif /* CONFIG_SYSVIPC */
 
diff -puN include/uapi/linux/msg.h~ipc-msg-increase-msgmni-remove-scaling include/uapi/linux/msg.h
--- a/include/uapi/linux/msg.h~ipc-msg-increase-msgmni-remove-scaling
+++ a/include/uapi/linux/msg.h
@@ -51,16 +51,28 @@ struct msginfo {
 };
 
 /*
- * Scaling factor to compute msgmni:
- * the memory dedicated to msg queues (msgmni * msgmnb) should occupy
- * at most 1/MSG_MEM_SCALE of the lowmem (see the formula in ipc/msg.c):
- * up to 8MB       : msgmni = 16 (MSGMNI)
- * 4 GB            : msgmni = 8K
- * more than 16 GB : msgmni = 32K (IPCMNI)
+ * MSGMNI, MSGMAX and MSGMNB are default values which can be
+ * modified by sysctl.
+ *
+ * MSGMNI is the upper limit for the number of messages queues per
+ * namespace.
+ * It has been chosen to be as large possible without facilitating
+ * scenarios where userspace causes overflows when adjusting the limits via
+ * operations of the form retrieve current limit; add X; update limit".
+ *
+ * MSGMNB is the default size of a new message queue. Non-root tasks can
+ * decrease the size with msgctl(IPC_SET), root tasks
+ * (actually: CAP_SYS_RESOURCE) can both increase and decrease the queue
+ * size. The optimal value is application dependant.
+ * 16384 is used because it was always used (since 0.99.10)
+ *
+ * MAXMAX is the maximum size of an individual message, it's a global
+ * (per-namespace) limit that applies for all message queues.
+ * It's set to 1/2 of MSGMNB, to ensure that at least two messages fit into
+ * the queue. This is also an arbitrary choice (since 2.6.0).
  */
-#define MSG_MEM_SCALE 32
 
-#define MSGMNI    16   /* <= IPCMNI */     /* max # of msg queue identifiers */
+#define MSGMNI 32000   /* <= IPCMNI */     /* max # of msg queue identifiers */
 #define MSGMAX  8192   /* <= INT_MAX */   /* max size of message (bytes) */
 #define MSGMNB 16384   /* <= INT_MAX */   /* default max size of a message queue */
 
diff -puN ipc/Makefile~ipc-msg-increase-msgmni-remove-scaling ipc/Makefile
--- a/ipc/Makefile~ipc-msg-increase-msgmni-remove-scaling
+++ a/ipc/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_SYSVIPC_COMPAT) += compat.o
-obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o ipcns_notifier.o syscall.o
+obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o syscall.o
 obj-$(CONFIG_SYSVIPC_SYSCTL) += ipc_sysctl.o
 obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
diff -puN ipc/ipc_sysctl.c~ipc-msg-increase-msgmni-remove-scaling ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-msg-increase-msgmni-remove-scaling
+++ a/ipc/ipc_sysctl.c
@@ -62,29 +62,6 @@ static int proc_ipc_dointvec_minmax_orph
 	return err;
 }
 
-static int proc_ipc_callback_dointvec_minmax(struct ctl_table *table, int write,
-	void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	struct ctl_table ipc_table;
-	size_t lenp_bef = *lenp;
-	int rc;
-
-	memcpy(&ipc_table, table, sizeof(ipc_table));
-	ipc_table.data = get_ipc(table);
-
-	rc = proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
-
-	if (write && !rc && lenp_bef == *lenp)
-		/*
-		 * Tunable has successfully been changed by hand. Disable its
-		 * automatic adjustment. This simply requires unregistering
-		 * the notifiers that trigger recalculation.
-		 */
-		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
-
-	return rc;
-}
-
 static int proc_ipc_doulongvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -96,54 +73,19 @@ static int proc_ipc_doulongvec_minmax(st
 					lenp, ppos);
 }
 
-/*
- * Routine that is called when the file "auto_msgmni" has successfully been
- * written.
- * Two values are allowed:
- * 0: unregister msgmni's callback routine from the ipc namespace notifier
- *    chain. This means that msgmni won't be recomputed anymore upon memory
- *    add/remove or ipc namespace creation/removal.
- * 1: register back the callback routine.
- */
-static void ipc_auto_callback(int val)
-{
-	if (!val)
-		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
-	else {
-		/*
-		 * Re-enable automatic recomputing only if not already
-		 * enabled.
-		 */
-		recompute_msgmni(current->nsproxy->ipc_ns);
-		cond_register_ipcns_notifier(current->nsproxy->ipc_ns);
-	}
-}
-
-static int proc_ipcauto_dointvec_minmax(struct ctl_table *table, int write,
+static int proc_ipc_auto_msgmni(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
-	int oldval;
-	int rc;
+	int dummy = 0;
 
 	memcpy(&ipc_table, table, sizeof(ipc_table));
-	ipc_table.data = get_ipc(table);
-	oldval = *((int *)(ipc_table.data));
-
-	rc = proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
+	ipc_table.data = &dummy;
 
-	if (write && !rc) {
-		int newval = *((int *)(ipc_table.data));
-		/*
-		 * The file "auto_msgmni" has correctly been set.
-		 * React by (un)registering the corresponding tunable, if the
-		 * value has changed.
-		 */
-		if (newval != oldval)
-			ipc_auto_callback(newval);
-	}
+	if (write)
+		pr_info_once("writing to auto_msgmni has no effect");
 
-	return rc;
+	return proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
 }
 
 #else
@@ -151,8 +93,7 @@ static int proc_ipcauto_dointvec_minmax(
 #define proc_ipc_dointvec	   NULL
 #define proc_ipc_dointvec_minmax   NULL
 #define proc_ipc_dointvec_minmax_orphans   NULL
-#define proc_ipc_callback_dointvec_minmax  NULL
-#define proc_ipcauto_dointvec_minmax NULL
+#define proc_ipc_auto_msgmni	   NULL
 #endif
 
 static int zero;
@@ -204,11 +145,20 @@ static struct ctl_table ipc_kern_table[]
 		.data		= &init_ipc_ns.msg_ctlmni,
 		.maxlen		= sizeof(init_ipc_ns.msg_ctlmni),
 		.mode		= 0644,
-		.proc_handler	= proc_ipc_callback_dointvec_minmax,
+		.proc_handler	= proc_ipc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &int_max,
 	},
 	{
+		.procname	= "auto_msgmni",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_auto_msgmni,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname	=  "msgmnb",
 		.data		= &init_ipc_ns.msg_ctlmnb,
 		.maxlen		= sizeof(init_ipc_ns.msg_ctlmnb),
@@ -224,15 +174,6 @@ static struct ctl_table ipc_kern_table[]
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec,
 	},
-	{
-		.procname	= "auto_msgmni",
-		.data		= &init_ipc_ns.auto_msgmni,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_ipcauto_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
-	},
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	{
 		.procname	= "sem_next_id",
diff -puN ipc/ipcns_notifier.c~ipc-msg-increase-msgmni-remove-scaling /dev/null
--- a/ipc/ipcns_notifier.c
+++ /dev/null
@@ -1,92 +0,0 @@
-/*
- * linux/ipc/ipcns_notifier.c
- * Copyright (C) 2007 BULL SA. Nadia Derbey
- *
- * Notification mechanism for ipc namespaces:
- * The callback routine registered in the memory chain invokes the ipcns
- * notifier chain with the IPCNS_MEMCHANGED event.
- * Each callback routine registered in the ipcns namespace recomputes msgmni
- * for the owning namespace.
- */
-
-#include <linux/msg.h>
-#include <linux/rcupdate.h>
-#include <linux/notifier.h>
-#include <linux/nsproxy.h>
-#include <linux/ipc_namespace.h>
-
-#include "util.h"
-
-
-
-static BLOCKING_NOTIFIER_HEAD(ipcns_chain);
-
-
-static int ipcns_callback(struct notifier_block *self,
-				unsigned long action, void *arg)
-{
-	struct ipc_namespace *ns;
-
-	switch (action) {
-	case IPCNS_MEMCHANGED:   /* amount of lowmem has changed */
-	case IPCNS_CREATED:
-	case IPCNS_REMOVED:
-		/*
-		 * It's time to recompute msgmni
-		 */
-		ns = container_of(self, struct ipc_namespace, ipcns_nb);
-		/*
-		 * No need to get a reference on the ns: the 1st job of
-		 * free_ipc_ns() is to unregister the callback routine.
-		 * blocking_notifier_chain_unregister takes the wr lock to do
-		 * it.
-		 * When this callback routine is called the rd lock is held by
-		 * blocking_notifier_call_chain.
-		 * So the ipc ns cannot be freed while we are here.
-		 */
-		recompute_msgmni(ns);
-		break;
-	default:
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-
-int register_ipcns_notifier(struct ipc_namespace *ns)
-{
-	int rc;
-
-	memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
-	ns->ipcns_nb.notifier_call = ipcns_callback;
-	ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
-	rc = blocking_notifier_chain_register(&ipcns_chain, &ns->ipcns_nb);
-	if (!rc)
-		ns->auto_msgmni = 1;
-	return rc;
-}
-
-int cond_register_ipcns_notifier(struct ipc_namespace *ns)
-{
-	int rc;
-
-	memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
-	ns->ipcns_nb.notifier_call = ipcns_callback;
-	ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
-	rc = blocking_notifier_chain_cond_register(&ipcns_chain,
-							&ns->ipcns_nb);
-	if (!rc)
-		ns->auto_msgmni = 1;
-	return rc;
-}
-
-void unregister_ipcns_notifier(struct ipc_namespace *ns)
-{
-	blocking_notifier_chain_unregister(&ipcns_chain, &ns->ipcns_nb);
-	ns->auto_msgmni = 0;
-}
-
-int ipcns_notify(unsigned long val)
-{
-	return blocking_notifier_call_chain(&ipcns_chain, val, NULL);
-}
diff -puN ipc/msg.c~ipc-msg-increase-msgmni-remove-scaling ipc/msg.c
--- a/ipc/msg.c~ipc-msg-increase-msgmni-remove-scaling
+++ a/ipc/msg.c
@@ -989,43 +989,12 @@ SYSCALL_DEFINE5(msgrcv, int, msqid, stru
 	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg, do_msg_fill);
 }
 
-/*
- * Scale msgmni with the available lowmem size: the memory dedicated to msg
- * queues should occupy at most 1/MSG_MEM_SCALE of lowmem.
- * Also take into account the number of nsproxies created so far.
- * This should be done staying within the (MSGMNI , IPCMNI/nr_ipc_ns) range.
- */
-void recompute_msgmni(struct ipc_namespace *ns)
-{
-	struct sysinfo i;
-	unsigned long allowed;
-	int nb_ns;
-
-	si_meminfo(&i);
-	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
-		/ MSGMNB;
-	nb_ns = atomic_read(&nr_ipc_ns);
-	allowed /= nb_ns;
-
-	if (allowed < MSGMNI) {
-		ns->msg_ctlmni = MSGMNI;
-		return;
-	}
-
-	if (allowed > IPCMNI / nb_ns) {
-		ns->msg_ctlmni = IPCMNI / nb_ns;
-		return;
-	}
-
-	ns->msg_ctlmni = allowed;
-}
 
 void msg_init_ns(struct ipc_namespace *ns)
 {
 	ns->msg_ctlmax = MSGMAX;
 	ns->msg_ctlmnb = MSGMNB;
-
-	recompute_msgmni(ns);
+	ns->msg_ctlmni = MSGMNI;
 
 	atomic_set(&ns->msg_bytes, 0);
 	atomic_set(&ns->msg_hdrs, 0);
@@ -1069,9 +1038,6 @@ void __init msg_init(void)
 {
 	msg_init_ns(&init_ipc_ns);
 
-	printk(KERN_INFO "msgmni has been set to %d\n",
-		init_ipc_ns.msg_ctlmni);
-
 	ipc_init_proc_interface("sysvipc/msg",
 				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
 				IPC_MSG_IDS, sysvipc_msg_proc_show);
diff -puN ipc/namespace.c~ipc-msg-increase-msgmni-remove-scaling ipc/namespace.c
--- a/ipc/namespace.c~ipc-msg-increase-msgmni-remove-scaling
+++ a/ipc/namespace.c
@@ -45,14 +45,6 @@ static struct ipc_namespace *create_ipc_
 	msg_init_ns(ns);
 	shm_init_ns(ns);
 
-	/*
-	 * msgmni has already been computed for the new ipc ns.
-	 * Thus, do the ipcns creation notification before registering that
-	 * new ipcns in the chain.
-	 */
-	ipcns_notify(IPCNS_CREATED);
-	register_ipcns_notifier(ns);
-
 	ns->user_ns = get_user_ns(user_ns);
 
 	return ns;
@@ -99,25 +91,11 @@ void free_ipcs(struct ipc_namespace *ns,
 
 static void free_ipc_ns(struct ipc_namespace *ns)
 {
-	/*
-	 * Unregistering the hotplug notifier at the beginning guarantees
-	 * that the ipc namespace won't be freed while we are inside the
-	 * callback routine. Since the blocking_notifier_chain_XXX routines
-	 * hold a rw lock on the notifier list, unregister_ipcns_notifier()
-	 * won't take the rw lock before blocking_notifier_call_chain() has
-	 * released the rd lock.
-	 */
-	unregister_ipcns_notifier(ns);
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
 	atomic_dec(&nr_ipc_ns);
 
-	/*
-	 * Do the ipcns removal notification after decrementing nr_ipc_ns in
-	 * order to have a correct value when recomputing msgmni.
-	 */
-	ipcns_notify(IPCNS_REMOVED);
 	put_user_ns(ns->user_ns);
 	proc_free_inum(ns->proc_inum);
 	kfree(ns);
diff -puN ipc/util.c~ipc-msg-increase-msgmni-remove-scaling ipc/util.c
--- a/ipc/util.c~ipc-msg-increase-msgmni-remove-scaling
+++ a/ipc/util.c
@@ -71,44 +71,6 @@ struct ipc_proc_iface {
 	int (*show)(struct seq_file *, void *);
 };
 
-static void ipc_memory_notifier(struct work_struct *work)
-{
-	ipcns_notify(IPCNS_MEMCHANGED);
-}
-
-static int ipc_memory_callback(struct notifier_block *self,
-				unsigned long action, void *arg)
-{
-	static DECLARE_WORK(ipc_memory_wq, ipc_memory_notifier);
-
-	switch (action) {
-	case MEM_ONLINE:    /* memory successfully brought online */
-	case MEM_OFFLINE:   /* or offline: it's time to recompute msgmni */
-		/*
-		 * This is done by invoking the ipcns notifier chain with the
-		 * IPC_MEMCHANGED event.
-		 * In order not to keep the lock on the hotplug memory chain
-		 * for too long, queue a work item that will, when waken up,
-		 * activate the ipcns notification chain.
-		 */
-		schedule_work(&ipc_memory_wq);
-		break;
-	case MEM_GOING_ONLINE:
-	case MEM_GOING_OFFLINE:
-	case MEM_CANCEL_ONLINE:
-	case MEM_CANCEL_OFFLINE:
-	default:
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block ipc_memory_nb = {
-	.notifier_call = ipc_memory_callback,
-	.priority = IPC_CALLBACK_PRI,
-};
