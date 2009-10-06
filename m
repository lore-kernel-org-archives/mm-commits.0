From: akpm@linux-foundation.org
Subject: + ipc-semc-sem-use-list-operations.patch added to -mm tree
Date: Tue, 06 Oct 2009 14:17:35 -0700
Message-ID: <200910062117.n96LHZhs000587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933351AbZJFVSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:18:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, manfred@colorfullife.com, peifferp@gmail.com


The patch titled
     ipc/sem.c: sem use list operations
has been added to the -mm tree.  Its filename is
     ipc-semc-sem-use-list-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/sem.c: sem use list operations
From: Nick Piggin <npiggin@suse.de>

Replace the handcoded list operations in update_queue() with the standard
list_for_each_entry macros.

list_for_each_entry_safe() must be used, because list entries can
disappear immediately uppon the wakeup event.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   75 +++++++++++++++++++++-------------------------------
 1 file changed, 31 insertions(+), 44 deletions(-)

diff -puN ipc/sem.c~ipc-semc-sem-use-list-operations ipc/sem.c
--- a/ipc/sem.c~ipc-semc-sem-use-list-operations
+++ a/ipc/sem.c
@@ -402,58 +402,45 @@ undo:
  */
 static void update_queue (struct sem_array * sma)
 {
-	int error;
-	struct sem_queue * q;
+	struct sem_queue *q, *tq;
+
+again:
+	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
+		int error;
+		int alter;
 
-	q = list_entry(sma->sem_pending.next, struct sem_queue, list);
-	while (&q->list != &sma->sem_pending) {
 		error = try_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
 		/* Does q->sleeper still need to sleep? */
-		if (error <= 0) {
-			struct sem_queue *n;
+		if (error > 0)
+			continue;
 
-			/*
-			 * Continue scanning. The next operation
-			 * that must be checked depends on the type of the
-			 * completed operation:
-			 * - if the operation modified the array, then
-			 *   restart from the head of the queue and
-			 *   check for threads that might be waiting
-			 *   for semaphore values to become 0.
-			 * - if the operation didn't modify the array,
-			 *   then just continue.
-			 * The order of list_del() and reading ->next
-			 * is crucial: In the former case, the list_del()
-			 * must be done first [because we might be the
-			 * first entry in ->sem_pending], in the latter
-			 * case the list_del() must be done last
-			 * [because the list is invalid after the list_del()]
-			 */
-			if (q->alter) {
-				list_del(&q->list);
-				n = list_entry(sma->sem_pending.next,
-						struct sem_queue, list);
-			} else {
-				n = list_entry(q->list.next, struct sem_queue,
-						list);
-				list_del(&q->list);
-			}
+		list_del(&q->list);
 
-			/* wake up the waiting thread */
-			q->status = IN_WAKEUP;
+		/*
+		 * The next operation that must be checked depends on the type
+		 * of the completed operation:
+		 * - if the operation modified the array, then restart from the
+		 *   head of the queue and check for threads that might be
+		 *   waiting for semaphore values to become 0.
+		 * - if the operation didn't modify the array, then just
+		 *   continue.
+		 */
+		alter = q->alter;
 
-			wake_up_process(q->sleeper);
-			/* hands-off: q will disappear immediately after
-			 * writing q->status.
-			 */
-			smp_wmb();
-			q->status = error;
-			q = n;
-		} else {
-			q = list_entry(q->list.next, struct sem_queue, list);
-		}
+		/* wake up the waiting thread */
+		q->status = IN_WAKEUP;
+
+		wake_up_process(q->sleeper);
+		/* hands-off: q will disappear immediately after
+		 * writing q->status.
+		 */
+		smp_wmb();
+		q->status = error;
+
+		if (alter)
+			goto again;
 	}
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-improve-remountro-vs-buffercache-coherency.patch
ipc-semc-sem-optimise-undo-list-search.patch
ipc-semc-sem-use-list-operations.patch
ipc-semc-sem-preempt-improve.patch
ipc-semc-optimize-if-semops-fail.patch
ipc-semc-add-a-per-semaphore-pending-list.patch
ipc-semc-optimize-single-semop-operations.patch
ipc-semc-optimize-single-sops-when-semval-is-zero.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

