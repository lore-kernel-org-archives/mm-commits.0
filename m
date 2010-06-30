From: akpm@linux-foundation.org
Subject: + ipc-semc-bugfix-for-semop-not-reporting-successful-operation-update.patch added to -mm tree
Date: Wed, 30 Jun 2010 12:50:18 -0700
Message-ID: <201006301950.o5UJoILa022948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237Ab0F3TuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 15:50:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com


The patch titled
     ipc-semc-bugfix-for-semop-not-reporting-successful-operation-update
has been added to the -mm tree.  Its filename is
     ipc-semc-bugfix-for-semop-not-reporting-successful-operation-update.patch

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
Subject: ipc-semc-bugfix-for-semop-not-reporting-successful-operation-update
From: Manfred Spraul <manfred@colorfullife.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN ipc/sem.c~ipc-semc-bugfix-for-semop-not-reporting-successful-operation-update ipc/sem.c
--- a/ipc/sem.c~ipc-semc-bugfix-for-semop-not-reporting-successful-operation-update
+++ a/ipc/sem.c
@@ -1440,7 +1440,14 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 
 	if (error != -EINTR) {
 		/* fast path: update_queue already obtained all requested
-		 * resources */
+		 * resources.
+		 * Perform a smp_mb(): User space could assume that semop()
+		 * is a memory barrier: Without the mb(), the cpu could
+		 * speculatively read in user space stale data that was
+		 * overwritten by the previous owner of the semaphore.
+		 */
+		smp_mb();
+
 		goto out_free;
 	}
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
ipc-semc-bugfix-for-semop-not-reporting-successful-operation-update.patch
slab-leaks3-default-y.patch

