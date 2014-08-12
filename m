From: akpm@linux-foundation.org
Subject: [to-be-updated] timer-provide-an-api-for-deferrable-timeout.patch removed from -mm tree
Date: Tue, 12 Aug 2014 13:17:17 -0700
Message-ID: <53ea764d.qmm9P459gZxtr1xJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:34031 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbaHLURT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 16:17:19 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so1922651oig.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 13:17:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cpandya@codeaurora.org, hughd@google.com, john.stultz@linaro.org, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timer: provide an api for deferrable timeout
has been removed from the -mm tree.  Its filename was
     timer-provide-an-api-for-deferrable-timeout.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chintan Pandya <cpandya@codeaurora.org>
Subject: timer: provide an api for deferrable timeout

schedule_timeout wakes up the CPU from IDLE state.  For some use cases it
is not desirable, hence introduce a convenient API
(schedule_timeout_deferrable_interruptible) on similar pattern which uses
a deferrable timer.

Signed-off-by: Chintan Pandya <cpandya@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 ++
 kernel/time/timer.c   |   27 ++++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff -puN include/linux/sched.h~timer-provide-an-api-for-deferrable-timeout include/linux/sched.h
--- a/include/linux/sched.h~timer-provide-an-api-for-deferrable-timeout
+++ a/include/linux/sched.h
@@ -377,6 +377,8 @@ extern int in_sched_functions(unsigned l
 #define	MAX_SCHEDULE_TIMEOUT	LONG_MAX
 extern signed long schedule_timeout(signed long timeout);
 extern signed long schedule_timeout_interruptible(signed long timeout);
+extern signed long
+schedule_timeout_deferrable_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
diff -puN kernel/time/timer.c~timer-provide-an-api-for-deferrable-timeout kernel/time/timer.c
--- a/kernel/time/timer.c~timer-provide-an-api-for-deferrable-timeout
+++ a/kernel/time/timer.c
@@ -1432,7 +1432,7 @@ static void process_timeout(unsigned lon
 }
 
 /**
- * schedule_timeout - sleep until timeout
+ * __schedule_timeout - sleep until timeout
  * @timeout: timeout value in jiffies
  *
  * Make the current task sleep until @timeout jiffies have
@@ -1457,7 +1457,8 @@ static void process_timeout(unsigned lon
  *
  * In all cases the return value is guaranteed to be non-negative.
  */
-signed long __sched schedule_timeout(signed long timeout)
+static signed long
+__sched __schedule_timeout(signed long timeout, unsigned long flag)
 {
 	struct timer_list timer;
 	unsigned long expire;
@@ -1493,7 +1494,13 @@ signed long __sched schedule_timeout(sig
 
 	expire = timeout + jiffies;
 
-	setup_timer_on_stack(&timer, process_timeout, (unsigned long)current);
+	if (flag & TIMER_DEFERRABLE)
+		setup_deferrable_timer_on_stack(&timer, process_timeout,
+						(unsigned long)current);
+	else
+		setup_timer_on_stack(&timer, process_timeout,
+				     (unsigned long)current);
+
 	__mod_timer(&timer, expire, false, TIMER_NOT_PINNED);
 	schedule();
 	del_singleshot_timer_sync(&timer);
@@ -1506,12 +1513,26 @@ signed long __sched schedule_timeout(sig
  out:
 	return timeout < 0 ? 0 : timeout;
 }
+
+signed long __sched schedule_timeout(signed long timeout)
+{
+	return __schedule_timeout(timeout, 0);
+}
 EXPORT_SYMBOL(schedule_timeout);
 
 /*
  * We can use __set_current_state() here because schedule_timeout() calls
  * schedule() unconditionally.
  */
+
+signed long
+__sched schedule_timeout_deferrable_interruptible(signed long timeout)
+{
+	__set_current_state(TASK_INTERRUPTIBLE);
+	return __schedule_timeout(timeout, TIMER_DEFERRABLE);
+}
+EXPORT_SYMBOL(schedule_timeout_deferrable_interruptible);
+
 signed long __sched schedule_timeout_interruptible(signed long timeout)
 {
 	__set_current_state(TASK_INTERRUPTIBLE);
_

Patches currently in -mm which might be from cpandya@codeaurora.org are

origin.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch

