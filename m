From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-bugfix-for-semctlgetzcnt.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:37:52 -0700
Message-ID: <53960d10.FLy3tpqUUgoBAtH0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaFIThx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:37:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-semc-bugfix-for-semctlgetzcnt.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:37:52 -0700


The patch titled
     Subject: ipc/sem.c: bugfix for semctl(,,GETZCNT)
has been removed from the -mm tree.  Its filename was
     ipc-semc-bugfix-for-semctlgetzcnt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
slab-leaks3-default-y.patch

