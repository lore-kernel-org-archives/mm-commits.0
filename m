From: akpm@linux-foundation.org
Subject: + ipc-semc-update-sem_otime-for-all-operations.patch added to -mm tree
Date: Thu, 26 Sep 2013 14:06:11 -0700
Message-ID: <5244a1c3.C08GxPMNkiQ0EbcS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab3IZVGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 17:06:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jiakernel@gmail.com, efault@gmx.de, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: + ipc-semc-update-sem_otime-for-all-operations.patch added to -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,efault@gmx.de,jiakernel@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 14:06:11 -0700


The patch titled
     Subject: ipc/sem.c: update sem_otime for all operations
has been added to the -mm tree.  Its filename is
     ipc-semc-update-sem_otime-for-all-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-update-sem_otime-for-all-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-update-sem_otime-for-all-operations.patch

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
Subject: ipc/sem.c: update sem_otime for all operations

In 0a2b9d4c ("ipc/sem.c: move wake_up_process out of the spinlock
section"), the update of semaphore's sem_otime(last semop time) was moved
to one central position (do_smart_update).

But: Since do_smart_update() is only called for operations that modify the
array, this means that wait-for-zero semops do not update sem_otime
anymore.

The fix is simple:
Non-alter operations must update sem_otime.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reported-by: Jia He <jiakernel@gmail.com>
Tested-by: Jia He <jiakernel@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff -puN ipc/sem.c~ipc-semc-update-sem_otime-for-all-operations ipc/sem.c
--- a/ipc/sem.c~ipc-semc-update-sem_otime-for-all-operations
+++ a/ipc/sem.c
@@ -918,6 +918,24 @@ again:
 }
 
 /**
+ * set_semotime(sma, sops) - set sem_otime
+ * @sma: semaphore array
+ * @sops: operations that modified the array, may be NULL
+ *
+ * sem_otime is replicated to avoid cache line trashing.
+ * This function sets one instance to the current time.
+ */
+static void set_semotime(struct sem_array *sma, struct sembuf *sops)
+{
+	if (sops == NULL) {
+		sma->sem_base[0].sem_otime = get_seconds();
+	} else {
+		sma->sem_base[sops[0].sem_num].sem_otime =
+							get_seconds();
+	}
+}
+
+/**
  * do_smart_update(sma, sops, nsops, otime, pt) - optimized update_queue
  * @sma: semaphore array
  * @sops: operations that were performed
@@ -967,17 +985,10 @@ static void do_smart_update(struct sem_a
 			}
 		}
 	}
-	if (otime) {
-		if (sops == NULL) {
-			sma->sem_base[0].sem_otime = get_seconds();
-		} else {
-			sma->sem_base[sops[0].sem_num].sem_otime =
-								get_seconds();
-		}
-	}
+	if (otime)
+		set_semotime(sma, sops);
 }
 
-
 /* The following counts are associated to each semaphore:
  *   semncnt        number of tasks waiting on semval being nonzero
  *   semzcnt        number of tasks waiting on semval being zero
@@ -1839,10 +1850,16 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 
 	error = perform_atomic_semop(sma, sops, nsops, un,
 					task_tgid_vnr(current));
-	if (error <= 0) {
-		if (alter && error == 0)
+	if (error == 0) {
+		/* If the operation was successful, then do
+		 * the required updates.
+		 */
+		if (alter)
 			do_smart_update(sma, sops, nsops, 1, &tasks);
