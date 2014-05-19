From: akpm@linux-foundation.org
Subject: +
 ipc-semc-store-which-operation-blocks-in-perform_atomic_semop.patch added
 to -mm tree
Date: Mon, 19 May 2014 15:46:50 -0700
Message-ID: <537a89da.vO8IfVW2PReII/lo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaESWqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 18:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: + ipc-semc-store-which-operation-blocks-in-perform_atomic_semop.patch added to -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,mtk.manpages@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 15:46:50 -0700


The patch titled
     Subject: ipc/sem.c: store which operation blocks in perform_atomic_semop()
has been added to the -mm tree.  Its filename is
     ipc-semc-store-which-operation-blocks-in-perform_atomic_semop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-store-which-operation-blocks-in-perform_atomic_semop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-store-which-operation-blocks-in-perform_atomic_semop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: store which operation blocks in perform_atomic_semop()

Preparation for the next patch:

In the slow-path of perform_atomic_semop(), store a pointer to the
operation that caused the operation to block.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN ipc/sem.c~ipc-semc-store-which-operation-blocks-in-perform_atomic_semop ipc/sem.c
--- a/ipc/sem.c~ipc-semc-store-which-operation-blocks-in-perform_atomic_semop
+++ a/ipc/sem.c
@@ -109,6 +109,7 @@ struct sem_queue {
 	int			pid;	 /* process id of requesting process */
 	int			status;	 /* completion status of operation */
 	struct sembuf		*sops;	 /* array of pending operations */
+	struct sembuf		*blocking; /* the operation that blocked */
 	int			nsops;	 /* number of operations */
 	int			alter;	 /* does *sops alter the array? */
 };
@@ -642,6 +643,8 @@ out_of_range:
 	goto undo;
 
 would_block:
+	q->blocking = sop;
+
 	if (sop->sem_flg & IPC_NOWAIT)
 		result = -EAGAIN;
 	else
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
ipcshm-document-new-limits-in-the-uapi-header.patch
ipcshm-document-new-limits-in-the-uapi-header-v2.patch
ipcshm-document-new-limits-in-the-uapi-header-v3.patch
ipcmsg-use-current-state-helpers.patch
ipcmsg-move-some-msgq-ns-code-around.patch
ipcmsg-document-volatile-r_msg.patch
ipc-semc-bugfix-for-semctlgetzcnt.patch
ipc-semc-remove-code-duplication.patch
ipc-semc-change-perform_atomic_semop-parameters.patch
ipc-semc-store-which-operation-blocks-in-perform_atomic_semop.patch
ipc-semc-make-semctlgetncntgetzcnt-standard-compliant.patch
slab-leaks3-default-y.patch

