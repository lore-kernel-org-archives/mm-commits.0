From: akpm@linux-foundation.org
Subject: + lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock.patch added to -mm tree
Date: Fri, 14 Sep 2012 14:00:11 -0700
Message-ID: <20120914210012.5AB34100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:47055 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab2INVAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Sep 2012 17:00:13 -0400
Received: by ggnu1 with SMTP id u1so489221ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Sep 2012 14:00:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markivx@codeaurora.org, a.p.zijlstra@chello.nl, tglx@linutronix.de


The patch titled
     Subject: lib/spinlock_debug: avoid livelock in do_raw_spin_lock()
has been added to the -mm tree.  Its filename is
     lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vikram Mulukutla <markivx@codeaurora.org>
Subject: lib/spinlock_debug: avoid livelock in do_raw_spin_lock()

The logic in do_raw_spin_lock() attempts to acquire a spinlock by invoking
arch_spin_trylock() in a loop with a delay between each attempt.  Now
consider the following situation in a 2 CPU system:

1. CPU-0 continually acquires and releases a spinlock in a
   tight loop; it stays in this loop until some condition X
   is satisfied. X can only be satisfied by another CPU.

2. CPU-1 tries to acquire the same spinlock, in an attempt
   to satisfy the aforementioned condition X. However, it
   never sees the unlocked value of the lock because the
   debug spinlock code uses trylock instead of just lock;
   it checks at all the wrong moments - whenever CPU-0 has
   locked the lock.

Now in the absence of debug spinlocks, the architecture specific spinlock
code can correctly allow CPU-1 to wait in a "queue" (e.g., ticket
spinlocks), ensuring that it acquires the lock at some point.  However,
with the debug spinlock code, livelock can easily occur due to the use of
try_lock, which obviously cannot put the CPU in that "queue".  This
queueing mechanism is implemented in both x86 and ARM spinlock code.

Note that the situation mentioned above is not hypothetical.  A real
problem was encountered where CPU-0 was running hrtimer_cancel with
interrupts disabled, and CPU-1 was attempting to run the hrtimer that
CPU-0 was trying to cancel.

Address this by actually attempting arch_spin_lock once it is suspected
that there is a spinlock lockup.  If we're in a situation that is
described above, the arch_spin_lock should succeed; otherwise other
timeout mechanisms (e.g., watchdog) should alert the system of a lockup. 
Therefore, if there is a genuine system problem and the spinlock can't be
acquired, the end result (irrespective of this change being present) is
the same.  If there is a livelock caused by the debug code, this change
will allow the lock to be acquired, depending on the implementation of the
lower level arch specific spinlock code.

Signed-off-by: Vikram Mulukutla <markivx@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/spinlock_debug.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff -puN lib/spinlock_debug.c~lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock lib/spinlock_debug.c
--- a/lib/spinlock_debug.c~lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock
+++ a/lib/spinlock_debug.c
@@ -107,23 +107,27 @@ static void __spin_lock_debug(raw_spinlo
 {
 	u64 i;
 	u64 loops = loops_per_jiffy * HZ;
-	int print_once = 1;
 
-	for (;;) {
-		for (i = 0; i < loops; i++) {
-			if (arch_spin_trylock(&lock->raw_lock))
-				return;
-			__delay(1);
-		}
-		/* lockup suspected: */
-		if (print_once) {
-			print_once = 0;
-			spin_dump(lock, "lockup suspected");
+	for (i = 0; i < loops; i++) {
+		if (arch_spin_trylock(&lock->raw_lock))
+			return;
+		__delay(1);
+	}
+	/* lockup suspected: */
+	spin_dump(lock, "lockup suspected");
 #ifdef CONFIG_SMP
-			trigger_all_cpu_backtrace();
+	trigger_all_cpu_backtrace();
 #endif
-		}
-	}
+
+	/*
+	 * In case the trylock above was causing a livelock, give the lower
+	 * level arch specific lock code a chance to acquire the lock. We have
+	 * already printed a warning/backtrace at this point. The non-debug arch
+	 * specific code might actually succeed in acquiring the lock. If it is
+	 * not successful, the end-result is the same - there is no forward
+	 * progress.
+	 */
+	arch_spin_lock(&lock->raw_lock);
 }
 
 void do_raw_spin_lock(raw_spinlock_t *lock)
_

Patches currently in -mm which might be from markivx@codeaurora.org are

lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch

