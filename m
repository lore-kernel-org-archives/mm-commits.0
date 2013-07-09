From: akpm@linux-foundation.org
Subject: [merged] ipc-remove-unused-functions.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:49 -0700
Message-ID: <51dc9b0d.qBMaX/pR+9cBIkge%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3GIXVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: [merged] ipc-remove-unused-functions.patch removed from -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:49 -0700


The patch titled
     Subject: ipc: remove unused functions
has been removed from the -mm tree.  Its filename was
     ipc-remove-unused-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc: remove unused functions

We can now drop the msg_lock and msg_lock_check functions along with a
bogus comment introduced previously in semctl_down.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   25 -------------------------
 ipc/sem.c |    1 -
 2 files changed, 26 deletions(-)

diff -puN ipc/msg.c~ipc-remove-unused-functions ipc/msg.c
--- a/ipc/msg.c~ipc-remove-unused-functions
+++ a/ipc/msg.c
@@ -141,31 +141,6 @@ void __init msg_init(void)
 				IPC_MSG_IDS, sysvipc_msg_proc_show);
 }
 
-/*
- * msg_lock_(check_) routines are called in the paths where the rw_mutex
- * is not held.
- */
-static inline struct msg_queue *msg_lock(struct ipc_namespace *ns, int id)
-{
-	struct kern_ipc_perm *ipcp = ipc_lock(&msg_ids(ns), id);
-
-	if (IS_ERR(ipcp))
-		return (struct msg_queue *)ipcp;
-
-	return container_of(ipcp, struct msg_queue, q_perm);
-}
-
-static inline struct msg_queue *msg_lock_check(struct ipc_namespace *ns,
-						int id)
-{
-	struct kern_ipc_perm *ipcp = ipc_lock_check(&msg_ids(ns), id);
-
-	if (IS_ERR(ipcp))
-		return (struct msg_queue *)ipcp;
-
-	return container_of(ipcp, struct msg_queue, q_perm);
-}
