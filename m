From: akpm@linux-foundation.org
Subject: + ipc-scale-msgmni-to-the-amount-of-lowmem.patch added to -mm tree
Date: Mon, 11 Feb 2008 12:43:53 -0800
Message-ID: <200802112044.m1BKhr2q032009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46414 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbYBKUyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 15:54:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, cmm@us.ibm.com, matthltc@us.ibm.com, pierre.peiffer@bull.net, y-goto@jp.fujitsu.com


The patch titled
     ipc: scale msgmni to the amount of lowmem
has been added to the -mm tree.  Its filename is
     ipc-scale-msgmni-to-the-amount-of-lowmem.patch

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
Subject: ipc: scale msgmni to the amount of lowmem
From: Nadia Derbey <Nadia.Derbey@bull.net>

On large systems we'd like to allow a larger number of message queues.  In
some cases up to 32K.  However simply setting MSGMNI to a larger value may
cause problems for smaller systems.

The first patch of this series introduces a default maximum number of message
queue ids that scales with the amount of lowmem.

Since msgmni is per namespace and there is no amount of memory dedicated to
each namespace so far, the second patch of this series scales msgmni to the
number of ipc namespaces too.

Since msgmni depends on the amount of memory, it becomes necessary to
recompute it upon memory add/remove.  In the 4th patch, memory hotplug
management is added: a notifier block is registered into the memory hotplug
notifier chain for the ipc subsystem.  Since the ipc namespaces are not linked
together, they have their own notification chain: one notifier_block is
defined per ipc namespace.  Each time an ipc namespace is created (removed) it
registers (unregisters) its notifier block in (from) the ipcns chain.  The
callback routine registered in the memory chain invokes the ipcns notifier
chain with the IPCNS_MEMCHANGE event.  Each callback routine registered in the
ipcns namespace, in turn, recomputes msgmni for the owning namespace.

The 5th patch makes it possible to keep the memory hotplug notifier chain's
lock for a lesser amount of time: instead of directly notifying the ipcns
notifier chain upon memory add/remove, a work item is added to the global
workqueue.  When activated, this work item is the one who notifies the ipcns
notifier chain.

Since msgmni depends on the number of ipc namespaces, it becomes necessary to
recompute it upon ipc namespace creation / removal.  The 6th patch uses the
ipc namespace notifier chain for that purpose: that chain is notified each
time an ipc namespace is created or removed.  This makes it possible to
recompute msgmni for all the namespaces each time one of them is created or
removed.

When msgmni is explicitely set from userspace, we should avoid recomputing it
upon memory add/remove or ipcns creation/removal.  This is what the 7th patch
does: it simply unregisters the ipcns callback routine as soon as msgmni has
been changed from procfs or sysctl().

Even if msgmni is set by hand, it should be possible to make it back
automatically recomputed upon memory add/remove or ipcns creation/removal. 
This what is achieved in patch 8: if set to a negative value, msgmni is added
back to the ipcns notifier chain, making it automatically recomputed again.


This patch:

Compute msg_ctlmni to make it scale with the amount of lowmem.  msg_ctlmni is
now set to make the message queues occupy 1/32 of the available lowmem.

Some cleaning has also been done for the MSGPOOL constant: the msgctl man page
says it's not used, but it also defines it as a size in bytes (the code
expresses it in Kbytes).

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/msg.h |   14 ++++++++++++--
 ipc/msg.c           |   37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 3 deletions(-)

diff -puN include/linux/msg.h~ipc-scale-msgmni-to-the-amount-of-lowmem include/linux/msg.h
--- a/include/linux/msg.h~ipc-scale-msgmni-to-the-amount-of-lowmem
+++ a/include/linux/msg.h
@@ -49,16 +49,26 @@ struct msginfo {
 	unsigned short  msgseg; 
 };
 
+/*
+ * Scaling factor to compute msgmni:
+ * the memory dedicated to msg queues (msgmni * msgmnb) should occupy
+ * at most 1/MSG_MEM_SCALE of the lowmem (see the formula in ipc/msg.c):
+ * up to 8MB       : msgmni = 16 (MSGMNI)
+ * 4 GB            : msgmni = 8K
+ * more than 16 GB : msgmni = 32K (IPCMNI)
+ */
+#define MSG_MEM_SCALE 32
+
 #define MSGMNI    16   /* <= IPCMNI */     /* max # of msg queue identifiers */
 #define MSGMAX  8192   /* <= INT_MAX */   /* max size of message (bytes) */
 #define MSGMNB 16384   /* <= INT_MAX */   /* default max size of a message queue */
 
 /* unused */
-#define MSGPOOL (MSGMNI*MSGMNB/1024)  /* size in kilobytes of message pool */
+#define MSGPOOL (MSGMNI * MSGMNB) /* size in bytes of message pool */
 #define MSGTQL  MSGMNB            /* number of system message headers */
 #define MSGMAP  MSGMNB            /* number of entries in message map */
 #define MSGSSZ  16                /* message segment size */
-#define __MSGSEG ((MSGPOOL*1024)/ MSGSSZ) /* max no. of segments */
+#define __MSGSEG (MSGPOOL / MSGSSZ) /* max no. of segments */
 #define MSGSEG (__MSGSEG <= 0xffff ? __MSGSEG : 0xffff)
 
 #ifdef __KERNEL__
diff -puN ipc/msg.c~ipc-scale-msgmni-to-the-amount-of-lowmem ipc/msg.c
--- a/ipc/msg.c~ipc-scale-msgmni-to-the-amount-of-lowmem
+++ a/ipc/msg.c
@@ -27,6 +27,7 @@
 #include <linux/msg.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/list.h>
 #include <linux/security.h>
@@ -77,11 +78,45 @@ static int newque(struct ipc_namespace *
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it);
 #endif
 
+/*
+ * Scale msgmni with the available lowmem size: the memory dedicated to msg
+ * queues should occupy at most 1/MSG_MEM_SCALE of lowmem.
+ * This should be done staying within the (MSGMNI , IPCMNI) range.
+ */
+static void recompute_msgmni(struct ipc_namespace *ns)
+{
+	struct sysinfo i;
+	unsigned long allowed;
+
+	si_meminfo(&i);
+	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
+		/ MSGMNB;
+
+	if (allowed < MSGMNI) {
+		ns->msg_ctlmni = MSGMNI;
+		goto out_callback;
+	}
+
+	if (allowed > IPCMNI) {
+		ns->msg_ctlmni = IPCMNI;
+		goto out_callback;
+	}
+
+	ns->msg_ctlmni = allowed;
+
+out_callback:
+
+	printk(KERN_INFO "msgmni has been set to %d for ipc namespace %p\n",
+		ns->msg_ctlmni, ns);
+}
+
 void msg_init_ns(struct ipc_namespace *ns)
 {
 	ns->msg_ctlmax = MSGMAX;
 	ns->msg_ctlmnb = MSGMNB;
-	ns->msg_ctlmni = MSGMNI;
+
+	recompute_msgmni(ns);
+
 	atomic_set(&ns->msg_bytes, 0);
 	atomic_set(&ns->msg_hdrs, 0);
 	ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
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
