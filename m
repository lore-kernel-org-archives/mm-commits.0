From: akpm@linux-foundation.org
Subject: [merged]
 ipc-semc-store-which-operation-blocks-in-perform_atomic_semop.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:38:07 -0700
Message-ID: <53960d1f.R7sKsMYS2RN4ODsT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaFITiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:38:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-semc-store-which-operation-blocks-in-perform_atomic_semop.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:38:07 -0700


The patch titled
     Subject: ipc/sem.c: store which operation blocks in perform_atomic_semop()
has been removed from the -mm tree.  Its filename was
     ipc-semc-store-which-operation-blocks-in-perform_atomic_semop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
slab-leaks3-default-y.patch

