From: akpm@linux-foundation.org
Subject: + printk-fix-lockdep-instrumentation-of-console_sem.patch added
 to -mm tree
Date: Tue, 29 Apr 2014 14:55:24 -0700
Message-ID: <53601fcc.YltUCF+KyIVdUvmO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbaD2VzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Apr 2014 17:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@kernel.org, festevam@gmail.com, fabio.estevam@freescale.com, andriy.shevchenko@linux.intel.com, jack@suse.cz

Subject: + printk-fix-lockdep-instrumentation-of-console_sem.patch added to -mm tree
To: jack@suse.cz,andriy.shevchenko@linux.intel.com,fabio.estevam@freescale.com,festevam@gmail.com,mingo@kernel.org,peterz@infradead.org,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Tue, 29 Apr 2014 14:55:24 -0700


The patch titled
     Subject: printk: fix lockdep instrumentation of console_sem
has been added to the -mm tree.  Its filename is
     printk-fix-lockdep-instrumentation-of-console_sem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-fix-lockdep-instrumentation-of-console_sem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-fix-lockdep-instrumentation-of-console_sem.patch

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
Subject: printk: fix lockdep instrumentation of console_sem

Printk calls mutex_acquire() / mutex_release() by hand to instrument
lockdep about console_sem.  However in some corner cases the
instrumentation is missing.  Fix the problem by creating helper functions
for locking / unlocking console_sem which take care of lockdep
instrumentation as well.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Fabio Estevam <festevam@gmail.com>
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   46 +++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff -puN kernel/printk/printk.c~printk-fix-lockdep-instrumentation-of-console_sem kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-fix-lockdep-instrumentation-of-console_sem
+++ a/kernel/printk/printk.c
@@ -91,6 +91,29 @@ static struct lockdep_map console_lock_d
 #endif
 
 /*
+ * Helper macros to handle lockdep when locking/unlocking console_sem. We use
+ * macros instead of functions so that _RET_IP_ contains useful information.
+ */
+#define down_console_sem() do { \
+	down(&console_sem);\
+	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);\
+} while (0)
+
+static int __down_trylock_console_sem(unsigned long ip)
+{
+	if (down_trylock(&console_sem))
+		return 1;
+	mutex_acquire(&console_lock_dep_map, 0, 1, ip);
+	return 0;
+}
+#define down_trylock_console_sem() __down_trylock_console_sem(_RET_IP_)
+
+#define up_console_sem() do { \
+	mutex_release(&console_lock_dep_map, 1, _RET_IP_);\
+	up(&console_sem);\
+} while (0)
+
+/*
  * This is used for debugging the mess that is the VT code by
  * keeping track if we have the console semaphore held. It's
  * definitely not the perfect debug tool (we don't know if _WE_
@@ -1422,7 +1445,7 @@ static int console_trylock_for_printk(un
 	 */
 	if (!can_use_console(cpu)) {
 		console_locked = 0;
-		up(&console_sem);
+		up_console_sem();
 		return 0;
 	}
 	return 1;
@@ -1951,16 +1974,14 @@ void suspend_console(void)
 	printk("Suspending console(s) (use no_console_suspend to debug)\n");
 	console_lock();
 	console_suspended = 1;
-	up(&console_sem);
-	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
+	up_console_sem();
 }
 
 void resume_console(void)
 {
 	if (!console_suspend_enabled)
 		return;
-	down(&console_sem);
-	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
+	down_console_sem();
 	console_suspended = 0;
 	console_unlock();
 }
@@ -2002,12 +2023,11 @@ void console_lock(void)
 {
 	might_sleep();
 
-	down(&console_sem);
+	down_console_sem();
 	if (console_suspended)
 		return;
 	console_locked = 1;
 	console_may_schedule = 1;
-	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
 }
 EXPORT_SYMBOL(console_lock);
 
@@ -2021,15 +2041,14 @@ EXPORT_SYMBOL(console_lock);
  */
 int console_trylock(void)
 {
-	if (down_trylock(&console_sem))
+	if (down_trylock_console_sem())
 		return 0;
 	if (console_suspended) {
-		up(&console_sem);
+		up_console_sem();
 		return 0;
 	}
 	console_locked = 1;
 	console_may_schedule = 0;
-	mutex_acquire(&console_lock_dep_map, 0, 1, _RET_IP_);
 	return 1;
 }
 EXPORT_SYMBOL(console_trylock);
@@ -2091,7 +2110,7 @@ void console_unlock(void)
 	bool retry;
 
 	if (console_suspended) {
-		up(&console_sem);
+		up_console_sem();
 		return;
 	}
 
@@ -2153,7 +2172,6 @@ skip:
 		local_irq_restore(flags);
 	}
 	console_locked = 0;
-	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 
 	/* Release the exclusive_console once it is used */
 	if (unlikely(exclusive_console))
@@ -2161,7 +2179,7 @@ skip:
 
 	raw_spin_unlock(&logbuf_lock);
 
-	up(&console_sem);
+	up_console_sem();
 
 	/*
 	 * Someone could have filled up the buffer again, so re-check if there's
@@ -2206,7 +2224,7 @@ void console_unblank(void)
 	 * oops_in_progress is set to 1..
 	 */
 	if (oops_in_progress) {
-		if (down_trylock(&console_sem) != 0)
+		if (down_trylock_console_sem() != 0)
 			return;
 	} else
 		console_lock();
_

Patches currently in -mm which might be from jack@suse.cz are

fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch
fanotify-create-fan_access-event-for-readdir.patch
fs-notify-markc-trivial-cleanup.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-split-code-for-making-free-space-in-the-log-buffer.patch
printk-ignore-too-long-messages.patch
printk-split-message-size-computation.patch
printk-shrink-too-long-messages.patch
printk-return-really-stored-message-length.patch
printk-remove-outdated-comment.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
printk-fix-lockdep-instrumentation-of-console_sem.patch
printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
printk-remove-separate-printk_sched-buffers-and-use-printk-buf-instead.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

