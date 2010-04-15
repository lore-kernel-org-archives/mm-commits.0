From: akpm@linux-foundation.org
Subject: [merged] hrtimer-provide-schedule_hrtimeout-for-wallclock.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:38:47 -0400
Message-ID: <201004151840.o3FIePNO024420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755447Ab0DOSlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:41:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: C.Emde@osadl.org, arjan@infradead.org, pradysam@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimer: provide schedule_hrtimeout() for wallclock
has been removed from the -mm tree.  Its filename was
     hrtimer-provide-schedule_hrtimeout-for-wallclock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimer: provide schedule_hrtimeout() for wallclock
From: Carsten Emde <C.Emde@osadl.org>

The current version of schedule_hrtimeout() always uses the monotonic
clock.  Some system calls such as mq_timedsend() and mq_timedreceive(),
however, require the use of the wall clock due to the definition of the
system call.

This patch provides the infrastructure to use schedule_hrtimeout() with a
wallclock timer.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Cc: Arjan van de Veen <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Pradyumna Sampath <pradysam@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h |    2 +
 kernel/hrtimer.c        |   66 +++++++++++++++++++++++---------------
 2 files changed, 42 insertions(+), 26 deletions(-)

diff -puN include/linux/hrtimer.h~hrtimer-provide-schedule_hrtimeout-for-wallclock include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~hrtimer-provide-schedule_hrtimeout-for-wallclock
+++ a/include/linux/hrtimer.h
@@ -422,6 +422,8 @@ extern void hrtimer_init_sleeper(struct 
 
 extern int schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
 						const enum hrtimer_mode mode);
+extern int schedule_hrtimeout_range_clock(ktime_t *expires,
+		unsigned long delta, const enum hrtimer_mode mode, int clock);
 extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
 
 /* Soft interrupt function to run the hrtimer queues: */
diff -puN kernel/hrtimer.c~hrtimer-provide-schedule_hrtimeout-for-wallclock kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-provide-schedule_hrtimeout-for-wallclock
+++ a/kernel/hrtimer.c
@@ -1749,35 +1749,14 @@ void __init hrtimers_init(void)
 }
 
 /**
- * schedule_hrtimeout_range - sleep until timeout
+ * schedule_hrtimeout_range_clock - sleep until timeout
  * @expires:	timeout value (ktime_t)
  * @delta:	slack in expires timeout (ktime_t)
  * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
- *
- * Make the current task sleep until the given expiry time has
- * elapsed. The routine will return immediately unless
- * the current task state has been set (see set_current_state()).
- *
- * The @delta argument gives the kernel the freedom to schedule the
- * actual wakeup to a time that is both power and performance friendly.
- * The kernel give the normal best effort behavior for "@expires+@delta",
- * but may decide to fire the timer earlier, but no earlier than @expires.
- *
- * You can set the task state as follows -
- *
- * %TASK_UNINTERRUPTIBLE - at least @timeout time is guaranteed to
- * pass before the routine returns.
- *
- * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
- * delivered to the current task.
- *
- * The current task state is guaranteed to be TASK_RUNNING when this
- * routine returns.
- *
- * Returns 0 when the timer has expired otherwise -EINTR
+ * @clock:	timer clock, CLOCK_MONOTONIC or CLOCK_REALTIME
  */
-int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
-			       const enum hrtimer_mode mode)
+int __sched schedule_hrtimeout_range_clock(ktime_t *expires,
+	unsigned long delta, const enum hrtimer_mode mode, int clock)
 {
 	struct hrtimer_sleeper t;
 
@@ -1799,7 +1778,7 @@ int __sched schedule_hrtimeout_range(kti
 		return -EINTR;
 	}
 
-	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, mode);
+	hrtimer_init_on_stack(&t.timer, clock, mode);
 	hrtimer_set_expires_range_ns(&t.timer, *expires, delta);
 
 	hrtimer_init_sleeper(&t, current);
@@ -1818,6 +1797,41 @@ int __sched schedule_hrtimeout_range(kti
 
 	return !t.task ? 0 : -EINTR;
 }
+
+/**
+ * schedule_hrtimeout_range - sleep until timeout
+ * @expires:	timeout value (ktime_t)
+ * @delta:	slack in expires timeout (ktime_t)
+ * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
+ *
+ * Make the current task sleep until the given expiry time has
+ * elapsed. The routine will return immediately unless
+ * the current task state has been set (see set_current_state()).
+ *
+ * The @delta argument gives the kernel the freedom to schedule the
+ * actual wakeup to a time that is both power and performance friendly.
+ * The kernel give the normal best effort behavior for "@expires+@delta",
+ * but may decide to fire the timer earlier, but no earlier than @expires.
+ *
+ * You can set the task state as follows -
+ *
+ * %TASK_UNINTERRUPTIBLE - at least @timeout time is guaranteed to
+ * pass before the routine returns.
+ *
+ * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
+ * delivered to the current task.
+ *
+ * The current task state is guaranteed to be TASK_RUNNING when this
+ * routine returns.
+ *
+ * Returns 0 when the timer has expired otherwise -EINTR
+ */
+int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
+       const enum hrtimer_mode mode)
+{
+	return schedule_hrtimeout_range_clock(expires, delta, mode,
+	    CLOCK_MONOTONIC);
+}
 EXPORT_SYMBOL_GPL(schedule_hrtimeout_range);
 
 /**
_

Patches currently in -mm which might be from C.Emde@osadl.org are

linux-next.patch

