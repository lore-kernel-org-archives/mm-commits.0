From: akpm@linux-foundation.org
Subject: + ipc-semc-bugfix-for-semctlgetzcnt.patch added to -mm tree
Date: Mon, 19 May 2014 15:46:47 -0700
Message-ID: <537a89d7.dNy2T6zCIFcHc8U3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaESWqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 18:46:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: + ipc-semc-bugfix-for-semctlgetzcnt.patch added to -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,mtk.manpages@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 15:46:47 -0700


The patch titled
     Subject: ipc/sem.c: bugfix for semctl(,,GETZCNT)
has been added to the -mm tree.  Its filename is
     ipc-semc-bugfix-for-semctlgetzcnt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-bugfix-for-semctlgetzcnt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-bugfix-for-semctlgetzcnt.patch

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
Subject: ipc/sem.c: bugfix for semctl(,,GETZCNT)

GETZCNT is supposed to return the number of threads that wait until a
semaphore value becomes 0.

The current implementation overlooks complex operations that contain both
wait-for-zero operation and operations that alter at least one semaphore.

The patch fixes that.  It's intentionally copy&paste, this will be cleaned
up in the next patch.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN ipc/sem.c~ipc-semc-bugfix-for-semctlgetzcnt ipc/sem.c
--- a/ipc/sem.c~ipc-semc-bugfix-for-semctlgetzcnt
+++ a/ipc/sem.c
@@ -1047,6 +1047,16 @@ static int count_semzcnt(struct sem_arra
 			    && !(sops[i].sem_flg & IPC_NOWAIT))
 				semzcnt++;
 	}
+	list_for_each_entry(q, &sma->pending_alter, list) {
+		struct sembuf *sops = q->sops;
+		int nsops = q->nsops;
+		int i;
+		for (i = 0; i < nsops; i++)
+			if (sops[i].sem_num == semnum
+			    && (sops[i].sem_op == 0)
+			    && !(sops[i].sem_flg & IPC_NOWAIT))
+				semzcnt++;
+	}
 	return semzcnt;
 }
 
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

