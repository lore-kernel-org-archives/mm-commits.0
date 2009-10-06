From: akpm@linux-foundation.org
Subject: + ipc-semc-optimize-if-semops-fail.patch added to -mm tree
Date: Tue, 06 Oct 2009 14:17:39 -0700
Message-ID: <200910062117.n96LHdml000638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933415AbZJFVSW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:18:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, npiggin@suse.de, peifferp@gmail.com


The patch titled
     ipc/sem.c: optimize if semops fail
has been added to the -mm tree.  Its filename is
     ipc-semc-optimize-if-semops-fail.patch

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
@@ -444,13 +444,13 @@ again:
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

ipc-semc-sem-optimise-undo-list-search.patch
ipc-semc-sem-use-list-operations.patch
ipc-semc-sem-preempt-improve.patch
ipc-semc-optimize-if-semops-fail.patch
ipc-semc-add-a-per-semaphore-pending-list.patch
ipc-semc-optimize-single-semop-operations.patch
ipc-semc-optimize-single-sops-when-semval-is-zero.patch
slab-leaks3-default-y.patch

