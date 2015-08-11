From: akpm@linux-foundation.org
Subject: + ipc-semc-update-correct-memory-barriers.patch added to -mm tree
Date: Tue, 11 Aug 2015 15:22:07 -0700
Message-ID: <55ca758f.pisiihrsBvjOii6y%akpm__10494.0554629595$1439331747$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbbHKWWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Aug 2015 18:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, dave@stgolabs.net, jpoimboe@redhat.com, ktkhai@parallels.com, mingo@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: update/correct memory barriers
has been added to the -mm tree.  Its filename is
     ipc-semc-update-correct-memory-barriers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-update-correct-memory-barriers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-update-correct-memory-barriers.patch

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
Subject: ipc/sem.c: update/correct memory barriers

sem_lock() did not properly pair memory barriers:

!spin_is_locked() and spin_unlock_wait() are both only control barriers. 
The code needs an acquire barrier, otherwise the cpu might perform read
operations before the lock test.

As no primitive exists inside <include/spinlock.h> and since it seems
noone wants another primitive, the code creates a local primitive within
ipc/sem.c.

With regards to -stable:

The change of sem_wait_array() is a bugfix, the change to sem_lock() is a
nop (just a preprocessor redefinition to improve the readability).  The
bugfix is necessary for all kernels that use sem_wait_array() (i.e.:
starting from 3.10).

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN ipc/sem.c~ipc-semc-update-correct-memory-barriers ipc/sem.c
--- a/ipc/sem.c~ipc-semc-update-correct-memory-barriers
+++ a/ipc/sem.c
@@ -253,6 +253,16 @@ static void sem_rcu_free(struct rcu_head
 }
 
 /*
+ * spin_unlock_wait() and !spin_is_locked() are not memory barriers, they
+ * are only control barriers.
+ * The code must pair with spin_unlock(&sem->lock) or
+ * spin_unlock(&sem_perm.lock), thus just the control barrier is insufficient.
+ *
+ * smp_rmb() is sufficient, as writes cannot pass the control barrier.
+ */
+#define ipc_smp_acquire__after_spin_is_unlocked()	smp_rmb()
+
+/*
  * Wait until all currently ongoing simple ops have completed.
  * Caller must own sem_perm.lock.
  * New simple ops cannot start, because simple ops first check
@@ -275,6 +285,7 @@ static void sem_wait_array(struct sem_ar
 		sem = sma->sem_base + i;
 		spin_unlock_wait(&sem->lock);
 	}
+	ipc_smp_acquire__after_spin_is_unlocked();
 }
 
 /*
@@ -327,13 +338,12 @@ static inline int sem_lock(struct sem_ar
 		/* Then check that the global lock is free */
 		if (!spin_is_locked(&sma->sem_perm.lock)) {
 			/*
-			 * The ipc object lock check must be visible on all
-			 * cores before rechecking the complex count.  Otherwise
-			 * we can race with  another thread that does:
+			 * We need a memory barrier with acquire semantics,
+			 * otherwise we can race with another thread that does:
 			 *	complex_count++;
 			 *	spin_unlock(sem_perm.lock);
 			 */
-			smp_rmb();
+			ipc_smp_acquire__after_spin_is_unlocked();
 
 			/*
 			 * Now repeat the test of complex_count:
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits.patch
ipcsem-remove-uneeded-sem_undo_list-lock-usage-in-exit_sem.patch
ipc-semc-update-correct-memory-barriers.patch
ipc-convert-invalid-scenarios-to-use-warn_on.patch
slab-leaks3-default-y.patch

