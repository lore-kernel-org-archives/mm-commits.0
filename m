From: akpm@linux-foundation.org
Subject: [merged]
 printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:07:27 -0700
Message-ID: <53e3dc7f.2K2hGTQyZBoHXBsX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:37976 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaHGUH2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:28 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so842808ieb.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, aeb@debian.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: enable interrupts before calling console_trylock_for_printk()
has been removed from the -mm tree.  Its filename was
     printk-enable-interrupts-before-calling-console_trylock_for_printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: printk: enable interrupts before calling console_trylock_for_printk()

We need interrupts disabled when calling console_trylock_for_printk() only
so that cpu id we pass to can_use_console() remains valid (for other
things console_sem provides all the exclusion we need and deadlocks on
console_sem due to interrupts are impossible because we use
down_trylock()).  However if we are rescheduled, we are guaranteed to run
on an online cpu so we can easily just get the cpu id in
can_use_console().

We can lose a bit of performance when we enable interrupts in
vprintk_emit() and then disable them again in console_unlock() but OTOH it
can somewhat reduce interrupt latency caused by console_unlock().

We differ from (reverted) commit 939f04bec1a4 in that we avoid calling
console_unlock() from vprintk_emit() with lockdep enabled as that has
unveiled quite some bugs leading to system freezes during boot (e.g.
https://lkml.org/lkml/2014/5/30/242,
https://lkml.org/lkml/2014/6/28/521).

Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Andreas Bombe <aeb@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff -puN kernel/printk/printk.c~printk-enable-interrupts-before-calling-console_trylock_for_printk kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-enable-interrupts-before-calling-console_trylock_for_printk
+++ a/kernel/printk/printk.c
@@ -1450,10 +1450,9 @@ static int have_callable_console(void)
 /*
  * Can we actually use the console at this time on this cpu?
  *
- * Console drivers may assume that per-cpu resources have
- * been allocated. So unless they're explicitly marked as
- * being able to cope (CON_ANYTIME) don't call them until
- * this CPU is officially up.
+ * Console drivers may assume that per-cpu resources have been allocated. So
+ * unless they're explicitly marked as being able to cope (CON_ANYTIME) don't
+ * call them until this CPU is officially up.
  */
 static inline int can_use_console(unsigned int cpu)
 {
@@ -1466,8 +1465,10 @@ static inline int can_use_console(unsign
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
  */
-static int console_trylock_for_printk(unsigned int cpu)
+static int console_trylock_for_printk(void)
 {
+	unsigned int cpu = smp_processor_id();
+
 	if (!console_trylock())
 		return 0;
 	/*
@@ -1642,7 +1643,8 @@ asmlinkage int vprintk_emit(int facility
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
-			goto out_restore_irqs;
+			local_irq_restore(flags);
+			return 0;
 		}
 		zap_locks();
 	}
@@ -1750,21 +1752,30 @@ asmlinkage int vprintk_emit(int facility
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
+	lockdep_on();
+	local_irq_restore(flags);
 
 	/* If called from the scheduler, we can not call up(). */
 	if (!in_sched) {
+		lockdep_off();
+		/*
+		 * Disable preemption to avoid being preempted while holding
+		 * console_sem which would prevent anyone from printing to
+		 * console
+		 */
+		preempt_disable();
+
 		/*
 		 * Try to acquire and then immediately release the console
 		 * semaphore.  The release will print out buffers and wake up
 		 * /dev/kmsg and syslog() users.
 		 */
-		if (console_trylock_for_printk(this_cpu))
+		if (console_trylock_for_printk())
 			console_unlock();
+		preempt_enable();
+		lockdep_on();
 	}
 
-	lockdep_on();
-out_restore_irqs:
-	local_irq_restore(flags);
 	return printed_len;
 }
 EXPORT_SYMBOL(vprintk_emit);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

