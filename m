From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-sem-use-list-operations.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:36 -0800
Message-ID: <200912162038.nBGKca7L013448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964836AbZLPUim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, manfred@colorfullife.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc/sem.c: sem use list operations
has been removed from the -mm tree.  Its filename was
     ipc-semc-sem-use-list-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -403,58 +403,45 @@ undo:
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

origin.patch
linux-next.patch
fs-anon_inodes-implement-dname.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-improve-remountro-vs-buffercache-coherency.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

