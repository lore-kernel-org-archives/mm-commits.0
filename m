From: akpm@linux-foundation.org
Subject: + ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch added to -mm tree
Date: Mon, 11 Feb 2008 12:45:20 -0800
Message-ID: <200802112045.m1BKjKuc032102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37067 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199AbYBKVFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 16:05:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, cmm@us.ibm.com, matthltc@us.ibm.com, pierre.peiffer@bull.net, y-goto@jp.fujitsu.com


The patch titled
     ipc: scale msgmni to the number of ipc namespaces
has been added to the -mm tree.  Its filename is
     ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch

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
Subject: ipc: scale msgmni to the number of ipc namespaces
From: Nadia Derbey <Nadia.Derbey@bull.net>

Since all the namespaces see the same amount of memory (the total one) this
patch introduces a new variable that counts the ipc namespaces and divides
msg_ctlmni by this counter.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    1 +
 ipc/msg.c                     |   10 +++++++---
 ipc/namespace.c               |    3 +++
 ipc/util.c                    |    3 +++
 4 files changed, 14 insertions(+), 3 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-scale-msgmni-to-the-number-of-ipc-namespaces include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-scale-msgmni-to-the-number-of-ipc-namespaces
+++ a/include/linux/ipc_namespace.h
@@ -33,6 +33,7 @@ struct ipc_namespace {
 };
 
 extern struct ipc_namespace init_ipc_ns;
+extern atomic_t nr_ipc_ns;
 
 #ifdef CONFIG_SYSVIPC
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
diff -puN ipc/msg.c~ipc-scale-msgmni-to-the-number-of-ipc-namespaces ipc/msg.c
--- a/ipc/msg.c~ipc-scale-msgmni-to-the-number-of-ipc-namespaces
+++ a/ipc/msg.c
@@ -81,24 +81,28 @@ static int sysvipc_msg_proc_show(struct 
 /*
  * Scale msgmni with the available lowmem size: the memory dedicated to msg
  * queues should occupy at most 1/MSG_MEM_SCALE of lowmem.
- * This should be done staying within the (MSGMNI , IPCMNI) range.
+ * Also take into account the number of nsproxies created so far.
+ * This should be done staying within the (MSGMNI , IPCMNI/nr_ipc_ns) range.
  */
 static void recompute_msgmni(struct ipc_namespace *ns)
 {
 	struct sysinfo i;
 	unsigned long allowed;
+	int nb_ns;
 
 	si_meminfo(&i);
 	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
 		/ MSGMNB;
+	nb_ns = atomic_read(&nr_ipc_ns);
+	allowed /= nb_ns;
 
 	if (allowed < MSGMNI) {
 		ns->msg_ctlmni = MSGMNI;
 		goto out_callback;
 	}
 
-	if (allowed > IPCMNI) {
-		ns->msg_ctlmni = IPCMNI;
+	if (allowed > IPCMNI / nb_ns) {
+		ns->msg_ctlmni = IPCMNI / nb_ns;
 		goto out_callback;
 	}
 
diff -puN ipc/namespace.c~ipc-scale-msgmni-to-the-number-of-ipc-namespaces ipc/namespace.c
--- a/ipc/namespace.c~ipc-scale-msgmni-to-the-number-of-ipc-namespaces
+++ a/ipc/namespace.c
@@ -20,6 +20,8 @@ static struct ipc_namespace *clone_ipc_n
 	if (ns == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	atomic_inc(&nr_ipc_ns);
+
 	sem_init_ns(ns);
 	msg_init_ns(ns);
 	shm_init_ns(ns);
@@ -83,4 +85,5 @@ void free_ipc_ns(struct kref *kref)
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
 	kfree(ns);
+	atomic_dec(&nr_ipc_ns);
 }
diff -puN ipc/util.c~ipc-scale-msgmni-to-the-number-of-ipc-namespaces ipc/util.c
--- a/ipc/util.c~ipc-scale-msgmni-to-the-number-of-ipc-namespaces
+++ a/ipc/util.c
@@ -52,6 +52,9 @@ struct ipc_namespace init_ipc_ns = {
 	},
 };
 
+atomic_t nr_ipc_ns = ATOMIC_INIT(1);
+
+
 /**
  *	ipc_init	-	initialise IPC subsystem
  *
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
