From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-optimize-if-semops-fail.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:42 -0800
Message-ID: <200912162038.nBGKcgO7013458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964972AbZLPUis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, npiggin@suse.de, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc/sem.c: optimize if semops fail
has been removed from the -mm tree.  Its filename was
     ipc-semc-optimize-if-semops-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/sem.c: optimize if semops fail
From: Manfred Spraul <manfred@colorfullife.com>

Reduce the amount of scanning of the list of pending semaphore operations:
If try_atomic_semop failed, then no changes were applied.  Thus no need to
restart.

Additionally, this patch correct an incorrect comment: It's possible to
wait for arbitrary semaphore values (do a dec by <x>, wait-for-zero, inc
by <x> in one atomic operation)

Both changes are from Nick Piggin, the patch is the result of a different
split of the individual changes.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-semc-optimize-if-semops-fail ipc/sem.c
--- a/ipc/sem.c~ipc-semc-optimize-if-semops-fail
+++ a/ipc/sem.c
@@ -445,13 +445,13 @@ again:
 		 * of the completed operation:
 		 * - if the operation modified the array, then restart from the
 		 *   head of the queue and check for threads that might be
-		 *   waiting for semaphore values to become 0.
+		 *   waiting for the new semaphore values.
 		 * - if the operation didn't modify the array, then just
 		 *   continue.
 		 */
 		alter = q->alter;
 		wake_up_sem_queue(q, error);
-		if (alter)
+		if (alter && !error)
 			goto again;
 	}
 }
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch

