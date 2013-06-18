From: akpm@linux-foundation.org
Subject: +
 ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues-fix.patch added to -mm tree
Date: Tue, 18 Jun 2013 14:05:26 -0700
Message-ID: <51c0cb96.fXP2bHLLTWrG6dmh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab3FRVF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jun 2013 17:05:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: + ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues-fix.patch added to -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 18 Jun 2013 14:05:26 -0700


The patch titled
     Subject: ipc/sem.c: scan complex wait-for-zero after undefined updates
has been added to the -mm tree.  Its filename is
     ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues-fix.patch

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
Subject: ipc/sem.c: scan complex wait-for-zero after undefined updates

After an update of a semaphore array that does not use struct sembuf,
complex wait-for-zero operations were not checked if they are able to
proceed.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN ipc/sem.c~ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues-fix ipc/sem.c
--- a/ipc/sem.c~ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues-fix
+++ a/ipc/sem.c
@@ -726,8 +726,10 @@ static int do_smart_wakeup_zero(struct s
 		 * Assume all were changed.
 		 */
 		for (i = 0; i < sma->sem_nsems; i++) {
-			if (sma->sem_base[i].semval == 0)
+			if (sma->sem_base[i].semval == 0) {
+				got_zero = 1;
 				semop_completed |= wake_const_ops(sma, i, pt);
+			}
 		}
 	}
 	/*
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
ipc-semc-cacheline-align-the-semaphore-structures.patch
ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues.patch
ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues-fix.patch
ipc-semc-always-use-only-one-queue-for-alter-operations.patch
ipc-semc-replace-shared-sem_otime-with-per-semaphore-value.patch
ipc-semc-rename-try_atomic_semop-to-perform_atomic_semop-docu-update.patch
slab-leaks3-default-y.patch

