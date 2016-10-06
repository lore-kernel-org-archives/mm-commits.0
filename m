From: akpm@linux-foundation.org
Subject: [withdrawn] ipc-msg-lockless-security-checks-for-msgsnd.patch
 removed from -mm tree
Date: Thu, 06 Oct 2016 14:11:49 -0700
Message-ID: <57f6be15.pAYQ9HdULGEcKEXZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41496 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934857AbcJFVLu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2016 17:11:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, bigeasy@linutronix.de, dbueso@suse.de, manfred@colorfullife.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: lockless security checks for msgsnd
has been removed from the -mm tree.  Its filename was
     ipc-msg-lockless-security-checks-for-msgsnd.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/msg: lockless security checks for msgsnd

Just as with msgrcv (along with the rest of sysvipc since a few years
ago), perform the security checks without holding the ipc object lock. 
This also reduces the hogging of the lock for the entire duration of a
sender, as we drop the lock upon every iteration -- and this is exactly
why we also check for racing with RMID in the first place.

Link: http://lkml.kernel.org/r/1469748819-19484-5-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN ipc/msg.c~ipc-msg-lockless-security-checks-for-msgsnd ipc/msg.c
--- a/ipc/msg.c~ipc-msg-lockless-security-checks-for-msgsnd
+++ a/ipc/msg.c
@@ -623,14 +623,14 @@ long do_msgsnd(int msqid, long mtype, vo
 		goto out_unlock1;
 	}
 
-	ipc_lock_object(&msq->q_perm);
-
 	for (;;) {
 		struct msg_sender s;
 
 		err = -EACCES;
 		if (ipcperms(ns, &msq->q_perm, S_IWUGO))
-			goto out_unlock0;
+			goto out_unlock1;
+
+		ipc_lock_object(&msq->q_perm);
 
 		/* raced with RMID? */
 		if (!ipc_valid_object(&msq->q_perm)) {
@@ -681,6 +681,7 @@ long do_msgsnd(int msqid, long mtype, vo
 			goto out_unlock0;
 		}
 
+		ipc_unlock_object(&msq->q_perm);
 	}
 	msq->q_lspid = task_tgid_vnr(current);
 	msq->q_stime = get_seconds();
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-msg-batch-queue-sender-wakeups.patch
ipc-msg-make-ss_wakeup-kill-arg-boolean.patch
ipc-msg-avoid-waking-sender-upon-full-queue.patch

