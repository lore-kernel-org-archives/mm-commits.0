From: akpm@linux-foundation.org
Subject: + ipc-semc-avoid-using-spin_unlock_wait.patch added to -mm tree
Date: Wed, 19 Oct 2016 17:23:10 -0700
Message-ID: <58080e6e.RdwMQymyOhi0wmDd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38524 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753895AbcJTAXM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 20:23:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, 1vier1@web.de, dave@stgolabs.net, felixh@informatik.uni-bremen.de, hpa@zytor.com, mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de, xiaolong.ye@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: avoid using spin_unlock_wait()
has been added to the -mm tree.  Its filename is
     ipc-semc-avoid-using-spin_unlock_wait.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-avoid-using-spin_unlock_wait.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-avoid-using-spin_unlock_wait.patch

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
Subject: ipc/sem.c: avoid using spin_unlock_wait()

a) The ACQUIRE in spin_lock() applies to the read, not to the store, at
   least for powerpc.  This forces to add a smp_mb() into the fast path.

b) The memory barrier provided by spin_unlock_wait() is right now arch
   dependent.

Therefore: Use spin_lock()/spin_unlock() instead of spin_unlock_wait().

Advantage: faster single op semop calls(), observed +8.9% on
x86. (the other solution would be arch dependencies in ipc/sem).

Disadvantage: slower complex op semop calls, if (and only if)
there are no sleeping operations.

The next patch adds hysteresis, this further reduces the
probability that the slow path is used.

Link: http://lkml.kernel.org/r/1476851896-3590-2-git-send-email-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: <1vier1@web.de>
Cc: kernel test robot <xiaolong.ye@intel.com>
Cc: <felixh@informatik.uni-bremen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff -puN ipc/sem.c~ipc-semc-avoid-using-spin_unlock_wait ipc/sem.c
--- a/ipc/sem.c~ipc-semc-avoid-using-spin_unlock_wait
+++ a/ipc/sem.c
@@ -280,24 +280,13 @@ static void complexmode_enter(struct sem
 		return;
 	}
 
-	/* We need a full barrier after seting complex_mode:
-	 * The write to complex_mode must be visible
-	 * before we read the first sem->lock spinlock state.
-	 */
-	smp_store_mb(sma->complex_mode, true);
+	sma->complex_mode = true;
 
 	for (i = 0; i < sma->sem_nsems; i++) {
 		sem = sma->sem_base + i;
-		spin_unlock_wait(&sem->lock);
+		spin_lock(&sem->lock);
+		spin_unlock(&sem->lock);
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
@@ -363,14 +352,6 @@ static inline int sem_lock(struct sem_ar
 		 */
 		spin_lock(&sem->lock);
 
-		/*
-		 * See 51d7d5205d33
-		 * ("powerpc: Add smp_mb() to arch_spin_is_locked()"):
-		 * A full barrier is required: the write of sem->lock
-		 * must be visible before the read is executed
-		 */
-		smp_mb();
