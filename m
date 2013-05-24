From: akpm@linux-foundation.org
Subject: + ipc-remove-unused-functions.patch added to -mm tree
Date: Fri, 24 May 2013 13:17:44 -0700
Message-ID: <519fcae8.1rkoBTzKM4ZAHwjE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab3EXURp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 16:17:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: + ipc-remove-unused-functions.patch added to -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 13:17:44 -0700


The patch titled
     Subject: ipc: remove unused functions
has been added to the -mm tree.  Its filename is
     ipc-remove-unused-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 static inline struct msg_queue *msq_obtain_object(struct ipc_namespace *ns, int id)
 {
 	struct kern_ipc_perm *ipcp = ipc_obtain_object(&msg_ids(ns), id);
diff -puN ipc/sem.c~ipc-remove-unused-functions ipc/sem.c
--- a/ipc/sem.c~ipc-remove-unused-functions
+++ a/ipc/sem.c
@@ -1281,7 +1281,6 @@ static int semctl_down(struct ipc_namesp
 				      &semid64.sem_perm, 0);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
-		/* the ipc lock is not held upon failure */
 		goto out_unlock1;
 	}
 
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
softirq-use-_ret_ip_.patch
ipc-move-rcu-lock-out-of-ipc_addid.patch
ipc-introduce-ipc-object-locking-helpers.patch
ipc-close-open-coded-spin-lock-calls.patch
ipc-move-locking-out-of-ipcctl_pre_down_nolock.patch
ipcmsg-shorten-critical-region-in-msgctl_down.patch
ipcmsg-introduce-msgctl_nolock.patch
ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcmsg-make-msgctl_nolock-lockless.patch
ipcmsg-shorten-critical-region-in-msgsnd.patch
ipcmsg-shorten-critical-region-in-msgrcv.patch
ipc-remove-unused-functions.patch

