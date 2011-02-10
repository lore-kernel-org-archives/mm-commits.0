From: akpm@linux-foundation.org
Subject: [wrecked] lockdep-timers-explain-in-detail-the-locking-problems-del_timer_sync-may-cause.patch removed from -mm tree
Date: Thu, 10 Feb 2011 12:14:40 -0800
Message-ID: <201102102014.p1AKEeJP016182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753306Ab1BJUPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Feb 2011 15:15:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, nbowler@elliptictech.com, peterz@infradead.org, tglx@linutronix.de, yong.zhang0@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lockdep/timers: explain in detail the locking problems del_timer_sync() may cause
has been removed from the -mm tree.  Its filename was
     lockdep-timers-explain-in-detail-the-locking-problems-del_timer_sync-may-cause.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep/timers: explain in detail the locking problems del_timer_sync() may cause
From: Steven Rostedt <rostedt@goodmis.org>

Twice I had to explain the output about why lockdep gives an error with
locks in IRQ context and with del_timer_sync().  Might as well write it up
and place it in the comments above the code in del_timer_sync().  Perhaps
the next time this lockdep dump triggers people will understand the
issues.

It is a tricky issue and very subtle, explaining it in detail in the code
may help others understand the issue when they stumble upon the bug again.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN kernel/timer.c~lockdep-timers-explain-in-detail-the-locking-problems-del_timer_sync-may-cause kernel/timer.c
--- a/kernel/timer.c~lockdep-timers-explain-in-detail-the-locking-problems-del_timer_sync-may-cause
+++ a/kernel/timer.c
@@ -964,6 +964,25 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  * add_timer_on(). Upon exit the timer is not queued and the handler is
  * not running on any CPU.
  *
+ * Note: You must not hold locks that are held in interrupt context
+ *   while calling this function. Even if the lock has nothing to do
+ *   with the timer in question.  Here's why:
+ *
+ *    CPU0                             CPU1
+ *    ----                             ----
+ *                                   <SOFTIRQ>
+ *                                   call_timer_fn();
+ *                                     base->running_timer = mytimer;
+ *  spin_lock_irq(somelock);
+ *                                     <IRQ>
+ *                                        spin_lock(somelock);
+ *  del_timer_sync(mytimer);
+ *   while (base->running_timer == mytimer);
+ *
+ * Now del_timer_sync() will never return and never release somelock.
+ * The interrupt on the other CPU is waiting to grab somelock but
+ * it has interrupted the softirq that CPU0 is waiting to finish.
+ *
  * The function returns whether it has deactivated a pending timer or not.
  */
 int del_timer_sync(struct timer_list *timer)
@@ -971,6 +990,10 @@ int del_timer_sync(struct timer_list *ti
 #ifdef CONFIG_LOCKDEP
 	unsigned long flags;
 
+	/*
+	 * If lockdep gives a backtrace here, please reference
+	 * the synchronization rules above.
+	 */
 	raw_local_irq_save(flags);
 	local_bh_disable();
 	lock_map_acquire(&timer->lockdep_map);
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch

