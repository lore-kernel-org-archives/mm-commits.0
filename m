From: akpm@linux-foundation.org
Subject: + ipc-msg-lockless-security-checks-for-msgsnd.patch added to -mm
 tree
Date: Wed, 10 Aug 2016 15:53:36 -0700
Message-ID: <57abb070.BaZU58EF6R4nH+/M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129AbcHJWxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 18:53:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, bigeasy@linutronix.de, dbueso@suse.de, manfred@colorfullife.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: lockless security checks for msgsnd
has been added to the -mm tree.  Its filename is
     ipc-msg-lockless-security-checks-for-msgsnd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msg-lockless-security-checks-for-msgsnd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msg-lockless-security-checks-for-msgsnd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
ipc-msg-lockless-security-checks-for-msgsnd.patch
ipc-msg-avoid-waking-sender-upon-full-queue.patch

