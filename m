From: akpm@linux-foundation.org
Subject: + ipcmsg-drop-msg_unlock.patch added to -mm tree
Date: Tue, 16 Jul 2013 15:51:54 -0700
Message-ID: <51e5ce8a.B/TzGTLvld5W8HIv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657Ab3GPWwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jul 2013 18:52:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipcmsg-drop-msg_unlock.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 16 Jul 2013 15:51:54 -0700


The patch titled
     Subject: ipc,msg: drop msg_unlock
has been added to the -mm tree.  Its filename is
     ipcmsg-drop-msg_unlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcmsg-drop-msg_unlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcmsg-drop-msg_unlock.patch

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
Subject: ipc,msg: drop msg_unlock

There is only one user left, drop this function and just call
ipc_unlock_object() and rcu_read_unlock().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN ipc/msg.c~ipcmsg-drop-msg_unlock ipc/msg.c
--- a/ipc/msg.c~ipcmsg-drop-msg_unlock
+++ a/ipc/msg.c
@@ -70,8 +70,6 @@ struct msg_sender {
 
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
-#define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
-
 static void freeque(struct ipc_namespace *, struct kern_ipc_perm *);
 static int newque(struct ipc_namespace *, struct ipc_params *);
 #ifdef CONFIG_PROC_FS
@@ -270,7 +268,8 @@ static void freeque(struct ipc_namespace
 	expunge_all(msq, -EIDRM);
 	ss_wakeup(&msq->q_senders, 1);
 	msg_rmid(ns, msq);
-	msg_unlock(msq);
+	ipc_unlock_object(&msq->q_perm);
+	rcu_read_unlock();
 
 	list_for_each_entry_safe(msg, t, &msq->q_messages, m_list) {
 		atomic_dec(&ns->msg_hdrs);
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcshm-shorten-critical-region-in-shmctl_down.patch
ipc-drop-ipcctl_pre_down.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-introduce-shmctl_nolock.patch
ipcshm-make-shmctl_nolock-lockless.patch
ipcshm-shorten-critical-region-for-shmctl.patch
ipcshm-cleanup-do_shmat-pasta.patch
ipcshm-shorten-critical-region-for-shmat.patch
ipc-rename-ids-rw_mutex.patch
ipcmsg-drop-msg_unlock.patch
ipc-document-general-ipc-locking-scheme.patch

