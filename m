From: akpm@linux-foundation.org
Subject: + ipc-semc-optimize-single-sops-when-semval-is-zero.patch added to -mm tree
Date: Tue, 06 Oct 2009 14:17:45 -0700
Message-ID: <200910062117.n96LHkm1000944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933192AbZJFVS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, npiggin@suse.de, peifferp@gmail.com


The patch titled
     ipc/sem.c: optimize single sops when semval is zero
has been added to the -mm tree.  Its filename is
     ipc-semc-optimize-single-sops-when-semval-is-zero.patch

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
Subject: ipc/sem.c: optimize single sops when semval is zero
From: Manfred Spraul <manfred@colorfullife.com>

If multiple simple decrements on the same semaphore are pending, then the
current code scans all decrement operations, even if the semaphore value
is already 0.

The patch optimizes that: if the semaphore value is 0, then there is no
need to scan the q->alter entries.

Note that this is a common case: It happens if 100 decrements by one are
pending and now an increment by one increases the semaphore value from 0
to 1.  Without this patch, all 100 entries are scanned.  With the patch,
only one entry is scanned, then woken up.  Then the new rule triggers and
the scanning is aborted, without looking at the remaining 99 tasks.

With this patch, single sop increment/decrement by 1 are now O(1).
(same as with Nick's patch)

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN ipc/sem.c~ipc-semc-optimize-single-sops-when-semval-is-zero ipc/sem.c
--- a/ipc/sem.c~ipc-semc-optimize-single-sops-when-semval-is-zero
+++ a/ipc/sem.c
@@ -473,6 +473,17 @@ again:
 		q = (struct sem_queue *)((char *)walk - offset);
 		walk = walk->next;
 
+		/* If we are scanning the single sop, per-semaphore list of
+		 * one semaphore and that semaphore is 0, then it is not
+		 * necessary to scan the "alter" entries: simple increments
+		 * that affect only one entry succeed immediately and cannot
+		 * be in the  per semaphore pending queue, and decrements
+		 * cannot be successful if the value is already 0.
+		 */
+		if (semnum != -1 && sma->sem_base[semnum].semval == 0 &&
+				q->alter)
+			break;
+
 		error = try_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
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

