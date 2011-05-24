From: akpm@linux-foundation.org
Subject: [to-be-updated] posix-timers-rcu-conversion.patch removed from -mm tree
Date: Tue, 24 May 2011 01:51:00 -0700
Message-ID: <201105240849.p4O8nb8K010344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754777Ab1EXIuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 04:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, avi@redhat.com, ben@iagu.net, johnstul@us.ibm.com, paulmck@linux.vnet.ibm.com, richard.cochran@omicron.at, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: RCU conversion
has been removed from the -mm tree.  Its filename was
     posix-timers-rcu-conversion.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: RCU conversion
From: Eric Dumazet <eric.dumazet@gmail.com>

Ben Nagy reported a scalability problem with KVM/QEMU that hit very hard a
single spinlock (idr_lock) in posix-timers code, on its 48 core machine.

Even on a 16 cpu machine (2x4x2), a single test can show 98% of cpu time
used in ticket_spin_lock, from lock_timer

Ref: http://www.spinics.net/lists/kvm/msg51526.html

Switching to RCU is quite easy, IDR being already RCU ready.

idr_lock should be locked only for an insert/delete, not a lookup.

Benchmark on a 2x4x2 machine, 16 processes calling timer_gettime().

Before :

real    1m18.669s
user    0m1.346s
sys     1m17.180s

After :

real    0m3.296s
user    0m1.366s
sys     0m1.926s

Reported-by: Ben Nagy <ben@iagu.net>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Ben Nagy <ben@iagu.net>
Cc: Avi Kivity <avi@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Richard Cochran <richard.cochran@omicron.at>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/posix-timers.h |    1 +
 kernel/posix-timers.c        |   25 ++++++++++++++-----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff -puN include/linux/posix-timers.h~posix-timers-rcu-conversion include/linux/posix-timers.h
--- a/include/linux/posix-timers.h~posix-timers-rcu-conversion
+++ a/include/linux/posix-timers.h
@@ -83,6 +83,7 @@ struct k_itimer {
 		} mmtimer;
 		struct alarm alarmtimer;
 	} it;
+	struct rcu_head rcu;
 };
 
 struct k_clock {
diff -puN kernel/posix-timers.c~posix-timers-rcu-conversion kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-rcu-conversion
+++ a/kernel/posix-timers.c
@@ -491,6 +491,13 @@ static struct k_itimer * alloc_posix_tim
 	return tmr;
 }
 
+static void k_itimer_rcu_free(struct rcu_head *head)
+{
+	struct k_itimer *tmr = container_of(head, struct k_itimer, rcu);
+
+	kmem_cache_free(posix_timers_cache, tmr);
+}
+
 #define IT_ID_SET	1
 #define IT_ID_NOT_SET	0
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
@@ -503,7 +510,7 @@ static void release_posix_timer(struct k
 	}
 	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
-	kmem_cache_free(posix_timers_cache, tmr);
+	call_rcu(&tmr->rcu, k_itimer_rcu_free);
 }
 
 static struct k_clock *clockid_to_kclock(const clockid_t id)
@@ -631,22 +638,18 @@ out:
 static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
-	/*
-	 * Watch out here.  We do a irqsave on the idr_lock and pass the
-	 * flags part over to the timer lock.  Must not let interrupts in
-	 * while we are moving the lock.
-	 */
-	spin_lock_irqsave(&idr_lock, *flags);
+
+	rcu_read_lock();
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
-		spin_lock(&timr->it_lock);
+		spin_lock_irqsave(&timr->it_lock, *flags);
 		if (timr->it_signal == current->signal) {
-			spin_unlock(&idr_lock);
+			rcu_read_unlock();
 			return timr;
 		}
-		spin_unlock(&timr->it_lock);
+		spin_unlock_irqrestore(&timr->it_lock, *flags);
 	}
-	spin_unlock_irqrestore(&idr_lock, *flags);
+	rcu_read_unlock();
 
 	return NULL;
 }
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
linux-next.patch
net-convert-%p-usage-to-%pk.patch
percpu_counter-change-return-value-and-add-comments.patch

