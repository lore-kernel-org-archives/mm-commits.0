From: akpm@linux-foundation.org
Subject: [merged] ipc-ns-fix-memory-leak-idr.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:30 -0800
Message-ID: <200912162038.nBGKcU4k013435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964837AbZLPUid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ipc ns: fix memory leak (idr)
has been removed from the -mm tree.  Its filename was
     ipc-ns-fix-memory-leak-idr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc ns: fix memory leak (idr)
From: "Serge E. Hallyn" <serue@us.ibm.com>

We have apparently had a memory leak since
7ca7e564e049d8b350ec9d958ff25eaa24226352 "ipc: store ipcs into IDRs" in
2007.  The idr of which 3 exist for each ipc namespace is never freed.

This patch simply frees them when the ipcns is freed.  I don't believe any
idr_remove() are done from rcu (and could therefore be delayed until after
this idr_destroy()), so the patch should be safe.  Some quick testing
showed no harm, and the memory leak fixed.

Caught by kmemleak.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    1 +
 ipc/sem.c |    1 +
 ipc/shm.c |    1 +
 3 files changed, 3 insertions(+)

diff -puN ipc/msg.c~ipc-ns-fix-memory-leak-idr ipc/msg.c
--- a/ipc/msg.c~ipc-ns-fix-memory-leak-idr
+++ a/ipc/msg.c
@@ -125,6 +125,7 @@ void msg_init_ns(struct ipc_namespace *n
 void msg_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &msg_ids(ns), freeque);
+	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
 }
 #endif
 
diff -puN ipc/sem.c~ipc-ns-fix-memory-leak-idr ipc/sem.c
--- a/ipc/sem.c~ipc-ns-fix-memory-leak-idr
+++ a/ipc/sem.c
@@ -129,6 +129,7 @@ void sem_init_ns(struct ipc_namespace *n
 void sem_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &sem_ids(ns), freeary);
+	idr_destroy(&ns->ids[IPC_SEM_IDS].ipcs_idr);
 }
 #endif
 
diff -puN ipc/shm.c~ipc-ns-fix-memory-leak-idr ipc/shm.c
--- a/ipc/shm.c~ipc-ns-fix-memory-leak-idr
+++ a/ipc/shm.c
@@ -101,6 +101,7 @@ static void do_shm_rmid(struct ipc_names
 void shm_exit_ns(struct ipc_namespace *ns)
 {
 	free_ipcs(ns, &shm_ids(ns), do_shm_rmid);
+	idr_destroy(&ns->ids[IPC_SHM_IDS].ipcs_idr);
 }
 #endif
 
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
linux-next.patch
reiser4.patch

