From: akpm@linux-foundation.org
Subject: [merged]
 printk-move-can_use_console-out-of-console_trylock_for_printk.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:41:12 -0700
Message-ID: <56f04048.6z9dm1AjUgyhYWJ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415AbcCUTbO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:31:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, calvinowens@fb.com, davej@codemonkey.org.uk, jack@suse.com, kyle@kernel.org, pmladek@suse.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: move can_use_console() out of console_trylock_for_printk()
has been removed from the -mm tree.  Its filename was
     printk-move-can_use_console-out-of-console_trylock_for_printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: printk: move can_use_console() out of console_trylock_for_printk()

console_unlock() allows to cond_resched() if its caller has set
`console_may_schedule' to 1 (this functionality is present since
8d91f8b15361 ("printk: do cond_resched() between lines while outputting to
consoles").

The rules are:
-- console_lock() always sets `console_may_schedule' to 1
-- console_trylock() always sets `console_may_schedule' to 0

printk() calls console_unlock() with preemption desabled, which basically
can lead to RCU stalls, watchdog soft lockups, etc.  if something is
simultaneously calling printk() frequent enough (IOW, console_sem owner
always has new data to send to console divers and can't leave
console_unlock() for a long time).

printk()->console_trylock() callers do not necessarily execute in atomic
contexts, and some of them can cond_resched() in console_unlock(). 
console_trylock() can set `console_may_schedule' to 1 (allow
cond_resched() later in consoe_unlock()) when it's safe.



This patch (of 3):

vprintk_emit() disables preemption around console_trylock_for_printk() and
console_unlock() calls for a strong reason -- can_use_console() check. 
The thing is that vprintl_emit() can be called on a CPU that is not fully
brought up yet (!cpu_online()), which potentially can cause problems if
console driver wants to access per-cpu data.  A console driver can
explicitly state that it's safe to call it from !online cpu by setting
CON_ANYTIME bit in console ->flags.  That's why for !cpu_online()
can_use_console() iterates all the console to find out if there is a
CON_ANYTIME console, otherwise console_unlock() must be avoided.

can_use_console() ensures that console_unlock() call is safe in
vprintk_emit() only; console_lock() and console_trylock() are not covered
by this check.  Even though call_console_drivers(), invoked from
console_cont_flush() and console_unlock(), tests `!cpu_online() &&
CON_ANYTIME' for_each_console(), it may be too late, which can result in
messages loss.

Assume that we have 2 cpus -- CPU0 is online, CPU1 is !online, and
no CON_ANYTIME consoles available.

CPU0 online                        CPU1 !online
                                 console_trylock()
                                 ...
                                 console_unlock()
                                   console_cont_flush
                                     spin_lock logbuf_lock
                                     if (!cont.len) {
                                        spin_unlock logbuf_lock
                                        return
                                     }
                                   for (;;) {
vprintk_emit
  spin_lock logbuf_lock
  log_store
  spin_unlock logbuf_lock
                                     spin_lock logbuf_lock
  !console_trylock_for_printk        msg_print_text
 return                              console_idx = log_next()
                                     console_seq++
                                     console_prev = msg->flags
                                     spin_unlock logbuf_lock

                                     call_console_drivers()
                                       for_each_console(con) {
                                         if (!cpu_online() &&
                                             !(con->flags & CON_ANYTIME))
                                                 continue;
                                         }
                                   /*
                                    * no message printed, we lost it
                                    */
vprintk_emit
  spin_lock logbuf_lock
  log_store
  spin_unlock logbuf_lock
  !console_trylock_for_printk
 return
                                   /*
                                    * go to the beginning of the loop,
                                    * find out there are new messages,
                                    * lose it
                                    */
                                   }

console_trylock()/console_lock() call on CPU1 may come from cpu notifiers
registered on that CPU.  Since notifiers are not getting unregistered when
CPU is going DOWN, all of the notifiers receive notifications during CPU
UP.  For example, on my x86_64, I see around 50 notification sent from
offline CPU to itself

 [swapper/2] from cpu:2 to:2 action:CPU_STARTING hotplug_hrtick
 [swapper/2] from cpu:2 to:2 action:CPU_STARTING blk_mq_main_cpu_notify
 [swapper/2] from cpu:2 to:2 action:CPU_STARTING blk_mq_queue_reinit_notify
 [swapper/2] from cpu:2 to:2 action:CPU_STARTING console_cpu_notify

while doing
  echo 0 > /sys/devices/system/cpu/cpu2/online
  echo 1 > /sys/devices/system/cpu/cpu2/online

So grabbing the console_sem lock while CPU is !online is possible,
in theory.

This patch moves can_use_console() check out of
console_trylock_for_printk().  Instead it calls it in console_unlock(), so
now console_lock()/console_unlock() are also 'protected' by
can_use_console().  This also means that console_trylock_for_printk() is
not really needed anymore and can be removed.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Jan Kara <jack@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Kyle McMartin <kyle@kernel.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Calvin Owens <calvinowens@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   97 ++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 55 deletions(-)

diff -puN kernel/printk/printk.c~printk-move-can_use_console-out-of-console_trylock_for_printk kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-move-can_use_console-out-of-console_trylock_for_printk
+++ a/kernel/printk/printk.c
@@ -1483,58 +1483,6 @@ static void zap_locks(void)
 	sema_init(&console_sem, 1);
 }
 
-/*
- * Check if we have any console that is capable of printing while cpu is
- * booting or shutting down. Requires console_sem.
- */
-static int have_callable_console(void)
-{
-	struct console *con;
-
-	for_each_console(con)
-		if (con->flags & CON_ANYTIME)
-			return 1;
-
-	return 0;
-}
-
-/*
- * Can we actually use the console at this time on this cpu?
- *
- * Console drivers may assume that per-cpu resources have been allocated. So
- * unless they're explicitly marked as being able to cope (CON_ANYTIME) don't
- * call them until this CPU is officially up.
- */
-static inline int can_use_console(unsigned int cpu)
-{
-	return cpu_online(cpu) || have_callable_console();
-}
-
-/*
- * Try to get console ownership to actually show the kernel
- * messages from a 'printk'. Return true (and with the
- * console_lock held, and 'console_locked' set) if it
- * is successful, false otherwise.
- */
-static int console_trylock_for_printk(void)
-{
-	unsigned int cpu = smp_processor_id();
-
-	if (!console_trylock())
-		return 0;
-	/*
-	 * If we can't use the console, we need to release the console
-	 * semaphore by hand to avoid flushing the buffer. We need to hold the
-	 * console semaphore in order to do this test safely.
-	 */
-	if (!can_use_console(cpu)) {
-		console_locked = 0;
-		up_console_sem();
-		return 0;
-	}
-	return 1;
-}
-
 int printk_delay_msec __read_mostly;
 
 static inline void printk_delay(void)
@@ -1681,7 +1629,6 @@ asmlinkage int vprintk_emit(int facility
 	boot_delay_msec(level);
 	printk_delay();
 
-	/* This stops the holder of console_sem just where we want him */
 	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
@@ -1705,6 +1652,7 @@ asmlinkage int vprintk_emit(int facility
 	}
 
 	lockdep_off();
+	/* This stops the holder of console_sem just where we want him */
 	raw_spin_lock(&logbuf_lock);
 	logbuf_cpu = this_cpu;
 
@@ -1821,7 +1769,7 @@ asmlinkage int vprintk_emit(int facility
 		 * semaphore.  The release will print out buffers and wake up
 		 * /dev/kmsg and syslog() users.
 		 */
-		if (console_trylock_for_printk())
+		if (console_trylock())
 			console_unlock();
 		preempt_enable();
 		lockdep_on();
@@ -2184,6 +2132,33 @@ int is_console_locked(void)
 	return console_locked;
 }
 
+/*
+ * Check if we have any console that is capable of printing while cpu is
+ * booting or shutting down. Requires console_sem.
+ */
+static int have_callable_console(void)
+{
+	struct console *con;
+
+	for_each_console(con)
+		if (con->flags & CON_ANYTIME)
+			return 1;
+
+	return 0;
+}
+
+/*
+ * Can we actually use the console at this time on this cpu?
+ *
+ * Console drivers may assume that per-cpu resources have been allocated. So
+ * unless they're explicitly marked as being able to cope (CON_ANYTIME) don't
+ * call them until this CPU is officially up.
+ */
+static inline int can_use_console(void)
+{
+	return cpu_online(raw_smp_processor_id()) || have_callable_console();
+}
+
 static void console_cont_flush(char *text, size_t size)
 {
 	unsigned long flags;
@@ -2254,9 +2229,21 @@ void console_unlock(void)
 	do_cond_resched = console_may_schedule;
 	console_may_schedule = 0;
 
+again:
+	/*
+	 * We released the console_sem lock, so we need to recheck if
+	 * cpu is online and (if not) is there at least one CON_ANYTIME
+	 * console.
+	 */
+	if (!can_use_console()) {
+		console_locked = 0;
+		up_console_sem();
+		return;
+	}
+
 	/* flush buffered message fragment immediately to console */
 	console_cont_flush(text, sizeof(text));
-again:
+
 	for (;;) {
 		struct printk_log *msg;
 		size_t ext_len = 0;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


