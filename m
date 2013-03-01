From: akpm@linux-foundation.org
Subject: + printk-avoid-softlockups-in-console_unlock.patch added to -mm tree
Date: Fri, 01 Mar 2013 13:42:17 -0800
Message-ID: <20130301214217.DAD0D5A40AC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:48284 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3CAVmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Mar 2013 16:42:19 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so384826vch.2
        for <mm-commits@vger.kernel.org>; Fri, 01 Mar 2013 13:42:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, a.p.zijlstra@chello.nl, fweisbec@gmail.com, mingo@elte.hu, paulmck@us.ibm.com, rostedt@goodmis.org


The patch titled
     Subject: printk: avoid softlockups in console_unlock()
has been added to the -mm tree.  Its filename is
     printk-avoid-softlockups-in-console_unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: printk: avoid softlockups in console_unlock()

A CPU can be caught in console_unlock() for a long time (tens of seconds
are reported by our customers) when other CPUs are using printk heavily
and serial console makes printing slow.  Despite serial console drivers
are calling touch_nmi_watchdog() this triggers softlockup warnings because
interrupts are effectively disabled for the whole time printing takes
place.  Thus IPIs cannot be processed and other CPUs get stuck spinning in
calls like smp_call_function_many().  Also RCU eventually starts reporting
lockups.

In my artifical testing I also managed to trigger a situation when disk
disappeared from the system apparently because commands to / from it could
not be delivered for long enough.  This is why just silencing watchdogs
isn't a reliable solution to the problem.

One part of fixing the issue is changing vprintk_emit() to call
console_unlock() with interrupts enabled (this isn't perfect as printk()
itself can be called with interrupts disabled but it improves the
situation in lots of cases).  Another part is limiting the time we spend
in console_unlock() printing loop to watchdog_thresh() / 4.  Then we
release console_sem and wait for watchdog_thresh() / 4 to give a chance to
other printk() users to get the semaphore and start printing.  If printk()
was called with interrupts enabled, it also gives CPU a chance to process
blocked interrupts.  Then we recheck if there's still anything to print,
try to grab console_sem again and if we succeed, we go on with printing.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |   18 +++++++++++++++++
 kernel/printk.c     |   44 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 56 insertions(+), 6 deletions(-)

diff -puN include/linux/nmi.h~printk-avoid-softlockups-in-console_unlock include/linux/nmi.h
--- a/include/linux/nmi.h~printk-avoid-softlockups-in-console_unlock
+++ a/include/linux/nmi.h
@@ -51,6 +51,24 @@ extern int watchdog_thresh;
 struct ctl_table;
 extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
+/*
+ * Return the maximum number of nanosecond for which interrupts may be disabled
+ * on the current CPU
+ */
+static inline u64 max_interrupt_disabled_duration(void)
+{
+	/*
+	 * We give us some headroom because timers need time to fire before the
+	 * watchdog period expires.
+	 */
+	return ((u64)watchdog_thresh) * NSEC_PER_SEC / 2;
+}
+#else
+static inline u64 max_interrupt_disabled_duration(void)
+{
+	/* About the value we'd get with the default watchdog setting */
+	return 5ULL * NSEC_PER_SEC;
+}
 #endif
 
 #endif
diff -puN kernel/printk.c~printk-avoid-softlockups-in-console_unlock kernel/printk.c
--- a/kernel/printk.c~printk-avoid-softlockups-in-console_unlock
+++ a/kernel/printk.c
@@ -1541,7 +1541,8 @@ asmlinkage int vprintk_emit(int facility
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
-			goto out_restore_irqs;
+			local_irq_restore(flags);
+			return printed_len;
 		}
 		zap_locks();
 	}
@@ -1635,17 +1636,19 @@ asmlinkage int vprintk_emit(int facility
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
-	 * users.
+	 * users. We call console_unlock() with interrupts enabled if possible
+	 * since printing can take a long time.
 	 *
 	 * The console_trylock_for_printk() function will release 'logbuf_lock'
 	 * regardless of whether it actually gets the console semaphore or not.
 	 */
-	if (console_trylock_for_printk(this_cpu))
+	if (console_trylock_for_printk(this_cpu)) {
+		local_irq_restore(flags);
 		console_unlock();
+	} else
+		local_irq_restore(flags);
 
 	lockdep_on();
-out_restore_irqs:
-	local_irq_restore(flags);
 
 	return printed_len;
 }
@@ -2065,6 +2068,8 @@ void console_unlock(void)
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	u64 end_time, now;
+	int cur_cpu;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -2072,6 +2077,15 @@ void console_unlock(void)
 	}
 
 	console_may_schedule = 0;
+	preempt_disable();
+	cur_cpu = smp_processor_id();
+	/*
+	 * We give us some headroom because we check the time only after
+	 * printing the whole message
+	 */
+	end_time = cpu_clock(cur_cpu) + max_interrupt_disabled_duration() / 2;
+	preempt_enable();
+
 
 	/* flush buffered message fragment immediately to console */
 	console_cont_flush(text, sizeof(text));
@@ -2094,7 +2108,8 @@ again:
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		now = sched_clock_cpu(cur_cpu);
+		if (console_seq == log_next_seq || now > end_time)
 			break;
 
 		msg = log_from_idx(console_idx);
@@ -2140,6 +2155,23 @@ skip:
 	up(&console_sem);
 
 	/*
+	 * If the printing took too long, wait a bit to give other CPUs a
+	 * chance to take console_sem or at least provide some time for
+	 * interrupts to be processed (if we are lucky enough and they are
+	 * enabled at this point).
+	 */
+	if (now > end_time) {
+		/*
+		 * We won't reach RCU quiescent state anytime soon, silence
+		 * the warnings.
+		 */
+		local_irq_save(flags);
+		rcu_cpu_stall_reset();
+		local_irq_restore(flags);
+		ndelay(max_interrupt_disabled_duration() / 2);
+	}
+
+	/*
 	 * Someone could have filled up the buffer again, so re-check if there's
 	 * something to flush. In case we cannot trylock the console_sem again,
 	 * there's a new owner and the console_unlock() from them will do the
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs.patch
fs-fix-hang-with-bsd-accounting-on-frozen-filesystem.patch
ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch
printk-avoid-softlockups-in-console_unlock.patch

