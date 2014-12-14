From: akpm@linux-foundation.org
Subject: [merged]
 ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch removed from
 -mm tree
Date: Sat, 13 Dec 2014 20:10:05 -0800
Message-ID: <548d0d9d.vG7RNajrPQIeOLXw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaLNEJ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, aquini@redhat.com, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: change memory barrier in sem_lock() to smp_rmb()
has been removed from the -mm tree.  Its filename was
     ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: change memory barrier in sem_lock() to smp_rmb()

When I fixed bugs in the sem_lock() logic, I was more conservative than
necessary.  Therefore it is safe to replace the smp_mb() with smp_rmb(). 
And: With smp_rmb(), semop() syscalls are up to 10% faster.

The race we must protect against is:

	sem->lock is free
	sma->complex_count = 0
	sma->sem_perm.lock held by thread B

thread A:

A: spin_lock(&sem->lock)

			B: sma->complex_count++; (now 1)
			B: spin_unlock(&sma->sem_perm.lock);

A: spin_is_locked(&sma->sem_perm.lock);
A: XXXXX memory barrier
A: if (sma->complex_count == 0)

Thread A must read the increased complex_count value, i.e. the read must
not be reordered with the read of sem_perm.lock done by spin_is_locked().

Since it's about ordering of reads, smp_rmb() is sufficient.

[akpm@linux-foundation.org: update sem_lock() comment, from Davidlohr]
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN ipc/sem.c~ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb ipc/sem.c
--- a/ipc/sem.c~ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb
+++ a/ipc/sem.c
@@ -326,10 +326,17 @@ static inline int sem_lock(struct sem_ar
 
 		/* Then check that the global lock is free */
 		if (!spin_is_locked(&sma->sem_perm.lock)) {
-			/* spin_is_locked() is not a memory barrier */
-			smp_mb();
+			/*
+			 * The ipc object lock check must be visible on all
+			 * cores before rechecking the complex count.  Otherwise
+			 * we can race with  another thread that does:
+			 *	complex_count++;
+			 *	spin_unlock(sem_perm.lock);
+			 */
+			smp_rmb();
 
-			/* Now repeat the test of complex_count:
+			/*
+			 * Now repeat the test of complex_count:
 			 * It can't change anymore until we drop sem->lock.
 			 * Thus: if is now 0, then it will stay 0.
 			 */
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch

