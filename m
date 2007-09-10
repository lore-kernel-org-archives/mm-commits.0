From: akpm@linux-foundation.org
Subject: + ipc-introduce-the-ipcid_to_idx-macro.patch added to -mm tree
Date: Mon, 10 Sep 2007 13:15:06 -0700
Message-ID: <200709102015.l8AKF6qD008728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48675 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756569AbXIJUPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 16:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net


The patch titled
     ipc: introduce the ipcid_to_idx macro
has been added to the -mm tree.  Its filename is
     ipc-introduce-the-ipcid_to_idx-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -78,6 +78,8 @@ void __init ipc_init_proc_interface(cons
 #define IPC_MSG_IDS	1
 #define IPC_SHM_IDS	2
 
+#define ipcid_to_idx(id) ((id) % SEQ_MULTIPLIER)
+
 /* must be called with ids->mutex acquired.*/
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
 int ipc_get_maxid(struct ipc_ids *);
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

ipc-store-ipcs-into-idrs.patch
ipc-unify-the-syscalls-code.patch
ipc-remove-the-ipc_get-routine.patch
ipc-integrate-ipc_checkid-into-ipc_lock.patch
ipc-introduce-the-ipcid_to_idx-macro.patch
ipc-inline-ipc_buildid.patch
