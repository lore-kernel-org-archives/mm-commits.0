From: akpm@linux-foundation.org
Subject: - ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:52 -0700
Message-ID: <200804300543.m3U5hqvp029347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757785AbYD3FpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:45:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, cmm@us.ibm.com, matthltc@us.ibm.com, pierre.peiffer@bull.net, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     ipc: scale msgmni to the number of ipc namespaces
has been removed from the -mm tree.  Its filename was
     ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

