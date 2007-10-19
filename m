From: akpm@linux-foundation.org
Subject: - ipc-introduce-the-ipcid_to_idx-macro.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:43 -0700
Message-ID: <200710192253.l9JMrhi7024448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763865AbXJSXFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     ipc: introduce the ipcid_to_idx macro
has been removed from the -mm tree.  Its filename was
     ipc-introduce-the-ipcid_to_idx-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipc: introduce the ipcid_to_idx macro
From: Nadia Derbey <Nadia.Derbey@bull.net>

This is a trivial patch that changes all the (id % SEQ_MULTIPLIER) into a call
to the ipcid_to_idx(id) macro.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    4 ++--
 ipc/util.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN ipc/util.c~ipc-introduce-the-ipcid_to_idx-macro ipc/util.c
--- a/ipc/util.c~ipc-introduce-the-ipcid_to_idx-macro
+++ a/ipc/util.c
@@ -413,7 +413,7 @@ int ipcget_public(struct ipc_namespace *
  
 void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 {
-	int lid = ipcp->id % SEQ_MULTIPLIER;
+	int lid = ipcid_to_idx(ipcp->id);
 
 	idr_remove(&ids->ipcs_idr, lid);
 
@@ -672,7 +672,7 @@ void ipc64_perm_to_ipc_perm (struct ipc6
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 {
 	struct kern_ipc_perm *out;
-	int lid = id % SEQ_MULTIPLIER;
+	int lid = ipcid_to_idx(id);
 
 	rcu_read_lock();
 	out = idr_find(&ids->ipcs_idr, lid);
diff -puN ipc/util.h~ipc-introduce-the-ipcid_to_idx-macro ipc/util.h
--- a/ipc/util.h~ipc-introduce-the-ipcid_to_idx-macro
+++ a/ipc/util.h
@@ -79,6 +79,8 @@ void __init ipc_init_proc_interface(cons
 #define IPC_MSG_IDS	1
 #define IPC_SHM_IDS	2
 
+#define ipcid_to_idx(id) ((id) % SEQ_MULTIPLIER)
+
 /* must be called with ids->mutex acquired.*/
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
 int ipc_get_maxid(struct ipc_ids *);
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
