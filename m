From: akpm@linux-foundation.org
Subject: + ipc-semc-remove-duplicated-memory-barriers.patch added to -mm
 tree
Date: Wed, 13 Jul 2016 15:05:37 -0700
Message-ID: <5786bb31.5d9bXQOsKBtItIhN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbcGMWFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 18:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, 1vier1@web.de, dave@stgolabs.net, felixh@informatik.uni-bremen.de, hpa@zytor.com, mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: remove duplicated memory barriers
has been added to the -mm tree.  Its filename is
     ipc-semc-remove-duplicated-memory-barriers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-remove-duplicated-memory-barriers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-remove-duplicated-memory-barriers.patch

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
Subject: ipc/sem.c: remove duplicated memory barriers

With 2c610022711 ("locking/qspinlock: Fix spin_unlock_wait() some more"),
memory barriers were added into spin_unlock_wait().  Thus another barrier
is not required.

And as explained in 055ce0fd1b8 ("locking/qspinlock: Add comments"),
spin_lock() provides a barrier so that reads within the critical section
cannot happen before the write for the lock is visible.  i.e.  spin_lock
provides an acquire barrier after the write of the lock variable, this
barrier pairs with the smp_mb() in complexmode_enter().

Link: http://lkml.kernel.org/r/1468386412-3608-3-git-send-email-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <1vier1@web.de>
Cc: <felixh@informatik.uni-bremen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN ipc/sem.c~ipc-semc-remove-duplicated-memory-barriers ipc/sem.c
--- a/ipc/sem.c~ipc-semc-remove-duplicated-memory-barriers
+++ a/ipc/sem.c
@@ -291,14 +291,6 @@ static void complexmode_enter(struct sem
 		sem = sma->sem_base + i;
 		spin_unlock_wait(&sem->lock);
 	}
-	/*
-	 * spin_unlock_wait() is not a memory barriers, it is only a
-	 * control barrier. The code must pair with spin_unlock(&sem->lock),
-	 * thus just the control barrier is insufficient.
-	 *
-	 * smp_rmb() is sufficient, as writes cannot pass the control barrier.
-	 */
-	smp_rmb();
 }
 
 /*
@@ -363,12 +355,6 @@ static inline int sem_lock(struct sem_ar
 		 */
 		spin_lock(&sem->lock);
 
-		/*
-		 * A full barrier is required: the write of sem->lock
-		 * must be visible before the read is executed
-		 */
-		smp_mb();
