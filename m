From: akpm@linux-foundation.org
Subject: [merged]
 ipc-semc-make-semctlgetncntgetzcnt-standard-compliant.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:38:13 -0700
Message-ID: <53960d25.jLiaESoctLIQort0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaFITiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:38:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-semc-make-semctlgetncntgetzcnt-standard-compliant.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:38:13 -0700


The patch titled
     Subject: ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT}) standard compliant
has been removed from the -mm tree.  Its filename was
     ipc-semc-make-semctlgetncntgetzcnt-standard-compliant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT}) standard compliant

SUSv4 clearly defines how semncnt and semzcnt must be calculated: A task
waits on exactly one semaphore: The semaphore from the first operation in
the sop array that cannot proceed.

The Linux implementation never followed the standard, it tried to count
all semaphores that might be the reason why a task sleeps.

This patch fixes that.

Note:
a) The implementation assumes that GETNCNT and GETZCNT are rare operations,
   therefore the code counts them only on demand.
   (If they wouldn't be rare, then the non-compliance would have
   been found earlier)

b) compared to the initial version of the patch, the BUG_ONs were removed
   and it was clarified that the new behavior conforms to SUS.

Back-compatibility concerns:

Manfred:

: - there is no application in Fedora that uses GETNCNT or GETZCNT.
: 
: - application that use only single-sop semop() are also safe, the
:   difference only affects complex apps.
: 
: - portable application are also safe, the new behavior is standard
:   compliant.
: 
: But that's it.  The old behavior existed in Linux from 0.99.something
: until now.

Michael:

: * These operations seem to be very little used.  Grepping the public
:   source that is contained Fedora 20 source DVD, there appear to be no
:   uses.  Of course, this says nothing about uses in private /
:   non-mainstream FOSS code, but it seems likely that the same pattern
:   is followed there.
: 
: * The existing behavior is hard enough to understand that I suspect
:   that no one understood it well enough to rely on it anyway
:   (especially as that behavior contradicted both man page and POSIX).
: 
: So, there's a chance of breakage, but I estimate that it's minute.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff -puN ipc/sem.c~ipc-semc-make-semctlgetncntgetzcnt-standard-compliant ipc/sem.c
--- a/ipc/sem.c~ipc-semc-make-semctlgetncntgetzcnt-standard-compliant
+++ a/ipc/sem.c
@@ -993,38 +993,30 @@ static void do_smart_update(struct sem_a
 }
 
 /*
- * check_qop: Test how often a queued operation sleeps on the semaphore semnum
+ * check_qop: Test if a queued operation sleeps on the semaphore semnum
  */
 static int check_qop(struct sem_array *sma, int semnum, struct sem_queue *q,
 			bool count_zero)
 {
-	struct sembuf *sops = q->sops;
-	int nsops = q->nsops;
-	int i, semcnt;
+	struct sembuf *sop = q->blocking;
 
-	semcnt = 0;
+	if (sop->sem_num != semnum)
+		return 0;
 
-	for (i = 0; i < nsops; i++) {
-		if (sops[i].sem_num != semnum)
-			continue;
-		if (sops[i].sem_flg & IPC_NOWAIT)
-			continue;
-		if (count_zero && sops[i].sem_op == 0)
-			semcnt++;
-		if (!count_zero && sops[i].sem_op < 0)
-			semcnt++;
-	}
-	return semcnt;
+	if (count_zero && sop->sem_op == 0)
+		return 1;
+	if (!count_zero && sop->sem_op < 0)
+		return 1;
+
+	return 0;
 }
 
 /* The following counts are associated to each semaphore:
  *   semncnt        number of tasks waiting on semval being nonzero
  *   semzcnt        number of tasks waiting on semval being zero
- * This model assumes that a task waits on exactly one semaphore.
- * Since semaphore operations are to be performed atomically, tasks actually
- * wait on a whole sequence of semaphores simultaneously.
- * The counts we return here are a rough approximation, but still
- * warrant that semncnt+semzcnt>0 if the task is on the pending queue.
+ *
+ * Per definition, a task waits only on the semaphore of the first semop
+ * that cannot proceed, even if additional operation would block, too.
  */
 static int count_semcnt(struct sem_array *sma, ushort semnum,
 			bool count_zero)
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch

