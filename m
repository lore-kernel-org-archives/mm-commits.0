From: akpm@linux-foundation.org
Subject: + printk-hand-over-printing-to-console-if-printing-too-long.patch added to -mm tree
Date: Thu, 13 Mar 2014 16:14:45 -0700
Message-ID: <53223be5.xA+jxp1GycDYfqqR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbaCMXOq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 19:14:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, pmladek@suse.cz, fweisbec@gmail.com, jack@suse.cz

Subject: + printk-hand-over-printing-to-console-if-printing-too-long.patch added to -mm tree
To: jack@suse.cz,fweisbec@gmail.com,pmladek@suse.cz,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 16:14:45 -0700


The patch titled
     Subject: printk: hand over printing to console if printing too long
has been added to the -mm tree.  Its filename is
     printk-hand-over-printing-to-console-if-printing-too-long.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-hand-over-printing-to-console-if-printing-too-long.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-hand-over-printing-to-console-if-printing-too-long.patch

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
Subject: printk: hand over printing to console if printing too long

Currently, console_unlock() prints messages from kernel printk buffer to
console while the buffer is non-empty.  When serial console is attached,
printing is slow and thus other CPUs in the system have plenty of time to
append new messages to the buffer while one CPU is printing.  Thus the CPU
can spend unbounded amount of time doing printing in console_unlock(). 
This is especially serious problem if the printk() calling
console_unlock() was called with interrupts disabled.

In practice users have observed a CPU can spend tens of seconds printing
in console_unlock() (usually during boot when hundreds of SCSI devices are
discovered) resulting in RCU stalls (CPU doing printing doesn't reach
quiescent state for a long time), softlockup reports (IPIs for the
printing CPU don't get served and thus other CPUs are spinning waiting for
the printing CPU to process IPIs), and eventually a machine death (as
messages from stalls and lockups append to printk buffer faster than we
are able to print).  So these machines are unable to boot with serial
console attached.  Also during artificial stress testing SATA disk
disappears from the system because its interrupts aren't served for too
long.

This patch implements a mechanism where after printing specified number of
characters (tunable as a kernel parameter printk.offload_chars), CPU doing
printing asks for help by setting PRINTK_HANDOVER_B bit in
printk_handover_state variable and wakes up one of dedicated kthreads.  As
soon as the printing CPU notices kthread got scheduled and is spinning on
console_sem, it drops console_sem and exits console_unlock().  kthread
then takes over printing instead.  This way no CPU should spend printing
too long even if there is heavy printk traffic.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   16 ++
 kernel/printk/printk.c              |  196 +++++++++++++++++++++++---
 2 files changed, 195 insertions(+), 17 deletions(-)

diff -puN Documentation/kernel-parameters.txt~printk-hand-over-printing-to-console-if-printing-too-long Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~printk-hand-over-printing-to-console-if-printing-too-long
+++ a/Documentation/kernel-parameters.txt
@@ -2626,6 +2626,22 @@ bytes respectively. Such letter suffixes
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 			default: disabled
 
+	printk.offload_chars=
+			Printing to console can be relatively slow especially
+			in case of serial console. When there is intensive
+			printing happening from several cpus (as is the case
+			during boot), a cpu can be spending significant time
+			(seconds or more) doing printing. To avoid softlockups,
+			lost interrupts, and similar problems other cpus
+			will take over printing after the currently printing
+			cpu has printed 'printk.offload_chars' characters.
+			Higher value means possibly longer interrupt and other
+			latencies but lower latency of printing and lower
+			chance something goes wrong during system crash and
+			important message is not printed.
+			Format: <number>
+			default: 0 (disabled)
+
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
diff -puN kernel/printk/printk.c~printk-hand-over-printing-to-console-if-printing-too-long kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-hand-over-printing-to-console-if-printing-too-long
+++ a/kernel/printk/printk.c
@@ -45,6 +45,7 @@
 #include <linux/poll.h>
 #include <linux/irq_work.h>
 #include <linux/utsname.h>
+#include <linux/kthread.h>
 
 #include <asm/uaccess.h>
 
@@ -87,6 +88,31 @@ static DEFINE_SEMAPHORE(console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
+/* State machine for handing over printing */
+enum {
+	/*
+	 * Set by the holder of console_sem if currently printing task wants to
+	 * hand over printing. Cleared before console_sem is released.
+	 */
+	PRINTK_HANDOVER_B,
+	/*
+	 * Set if there's someone spinning on console_sem to take over printing.
+	 * Cleared after acquiring console_sem.
+	 */
+	PRINTK_CONSOLE_SPIN_B,
+};
+static long printk_handover_state;
+
+/*
+ * Number of kernel threads for offloading printing. We need at least two so
+ * that they can hand over printing from one to another one and thus switch
+ * CPUs.
+ */
+#define PRINTING_TASKS 2
+
+/* Wait queue printing tasks sleep on when idle */
+static DECLARE_WAIT_QUEUE_HEAD(print_queue);
+
 #ifdef CONFIG_LOCKDEP
 static struct lockdep_map console_lock_dep_map = {
 	.name = "console_lock"
@@ -254,6 +280,19 @@ static char __log_buf[__LOG_BUF_LEN] __a
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+/*
+ * How many characters can we print in one call of printk before asking
+ * other cpus to continue printing. 0 means infinity. Tunable via
+ * printk.offload_chars kernel parameter. Our default 1000 means about
+ * 0.1s maximum latency due to printing.
+ */
+static unsigned int __read_mostly printk_offload_chars = 1000;
+
+module_param_named(offload_chars, printk_offload_chars, uint,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(offload_chars, "offload printing to console to a different"
+	" cpu after this number of characters");
+
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
 {
@@ -1945,6 +1984,7 @@ void console_lock(void)
 	if (console_suspended)
 		return;
 	console_locked = 1;
+	printk_handover_state = 0;
 	console_may_schedule = 1;
 	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
 }
@@ -1967,12 +2007,45 @@ int console_trylock(void)
 		return 0;
 	}
 	console_locked = 1;
+	printk_handover_state = 0;
 	console_may_schedule = 0;
 	mutex_acquire(&console_lock_dep_map, 0, 1, _RET_IP_);
 	return 1;
 }
 EXPORT_SYMBOL(console_trylock);
 
+/*
+ * This is a version of console_lock() which spins to acquire console_sem.
+ * It is only for use by threads that take care of flushing printk buffer so
+ * that they can be sure they are not preempted while waiting for console_sem.
+ *
+ * The function returns 1 if we acquired console_sem, 0 if we failed (either
+ * someone else is already spinning, someone acquired console_sem, or console
+ * is suspended).
+ */
+static int console_lock_try_spin(void)
+{
+	WARN_ON_ONCE(!in_atomic());
+	/* Someone already spinning? Don't waste cpu time... */
+	if (test_and_set_bit(PRINTK_CONSOLE_SPIN_B, &printk_handover_state))
+		return 0;
+	while (down_trylock(&console_sem)) {
+		/* Someone else took console_sem? */
+		if (!test_bit(PRINTK_CONSOLE_SPIN_B, &printk_handover_state))
+			return 0;
+		cpu_relax();
+	}
+	printk_handover_state = 0;
+	if (console_suspended) {
+		up(&console_sem);
+		return 0;
+	}
+	console_locked = 1;
+	console_may_schedule = 0;
+	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
+	return 1;
+}
+
 int is_console_locked(void)
 {
 	return console_locked;
@@ -2007,15 +2080,44 @@ out:
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 
+/*
+ * Returns true iff there is other cpu waiting to take over printing. This
+ * function also takes are of setting PRINTK_HANDOVER_B if we want to hand over
+ * printing to some other cpu.
+ */
+static bool cpu_stop_printing(int printed_chars)
+{
+	/* Oops? Print everything now to maximize chances user will see it */
+	if (oops_in_progress)
+		return false;
+	if (!printk_offload_chars || printed_chars < printk_offload_chars)
+		return false;
+	/* Someone is spinning on console_sem? Give away to him. */
+	if (test_bit(PRINTK_CONSOLE_SPIN_B, &printk_handover_state))
+		return true;
+	if (!test_bit(PRINTK_HANDOVER_B, &printk_handover_state)) {
+		set_bit(PRINTK_HANDOVER_B, &printk_handover_state);
+		/*
+		 * Paired with barrier in prepare_to_wait_exclusive() in
+		 * printing_task()
+		 */
+		smp_mb();
+		wake_up(&print_queue);
+	}
+	return false;
+}
+
 /**
  * console_unlock - unlock the console system
  *
  * Releases the console_lock which the caller holds on the console system
  * and the console driver list.
  *
- * While the console_lock was held, console output may have been buffered
- * by printk().  If this is the case, console_unlock(); emits
- * the output prior to releasing the lock.
+ * While the console_lock was held, console output may have been buffered by
+ * printk(). If this is the case, console_unlock() emits the output prior to
+ * releasing the lock. However we need not write all the data in the buffer if
+ * we would hog the CPU for too long. In such case we try to hand over printing
+ * to a different cpu.
  *
  * If there is output waiting, we wake /dev/kmsg and syslog() users.
  *
@@ -2028,6 +2130,8 @@ void console_unlock(void)
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	bool hand_over = false;
+	int printed_chars = 0;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -2044,6 +2148,11 @@ again:
 		size_t len;
 		int level;
 
+		if (cpu_stop_printing(printed_chars)) {
+			hand_over = true;
+			break;
+		}
+
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		if (seen_seq != log_next_seq) {
 			wake_klogd = true;
@@ -2057,8 +2166,10 @@ again:
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		if (console_seq == log_next_seq) {
+			raw_spin_unlock(&logbuf_lock);
 			break;
+		}
 
 		msg = log_from_idx(console_idx);
 		if (msg->flags & LOG_NOCONS) {
@@ -2089,31 +2200,39 @@ skip:
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(level, text, len);
 		start_critical_timings();
+		printed_chars += len;
 		local_irq_restore(flags);
 	}
-	console_locked = 0;
-	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 
 	/* Release the exclusive_console once it is used */
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	raw_spin_unlock(&logbuf_lock);
-
+	/* Save modification of printk_handover_state in the common fast path */
+	if (test_bit(PRINTK_HANDOVER_B, &printk_handover_state))
+		clear_bit(PRINTK_HANDOVER_B, &printk_handover_state);
+	console_locked = 0;
+	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 	up(&console_sem);
 
 	/*
-	 * Someone could have filled up the buffer again, so re-check if there's
-	 * something to flush. In case we cannot trylock the console_sem again,
-	 * there's a new owner and the console_unlock() from them will do the
-	 * flush, no worries.
+	 * Subtlety: We have interrupts disabled iff hand_over == false (to
+	 * save one cli/sti pair in the fast path.
 	 */
-	raw_spin_lock(&logbuf_lock);
-	retry = console_seq != log_next_seq;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	if (!hand_over) {
+		/*
+		 * Someone could have filled up the buffer again, so re-check
+		 * if there's something to flush. In case we cannot trylock the
+		 * console_sem again, there's a new owner and the
+		 * console_unlock() from them will do the flush, no worries.
+		 */
+		raw_spin_lock(&logbuf_lock);
+		retry = console_seq != log_next_seq;
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (retry && console_trylock())
-		goto again;
+		if (retry && console_trylock())
+			goto again;
+	}
 
 	if (wake_klogd)
 		wake_up_klogd();
@@ -2151,6 +2270,7 @@ void console_unblank(void)
 		console_lock();
 
 	console_locked = 1;
+	printk_handover_state = 0;
 	console_may_schedule = 0;
 	for_each_console(c)
 		if ((c->flags & CON_ENABLED) && c->unblank)
@@ -2427,9 +2547,38 @@ int unregister_console(struct console *c
 }
 EXPORT_SYMBOL(unregister_console);
 
+/* Kthread which takes over printing from a CPU which asks for help */
+static int printing_task(void *arg)
+{
+	DEFINE_WAIT(wait);
+
+	while (1) {
+		prepare_to_wait_exclusive(&print_queue, &wait,
+					  TASK_INTERRUPTIBLE);
+		if (!test_bit(PRINTK_HANDOVER_B, &printk_handover_state))
+			schedule();
+		finish_wait(&print_queue, &wait);
+		/*
+		 * We don't want to be scheduled away once we got the CPU (that
+		 * would be especially problematic if we hold console_sem at
+		 * that moment since noone else could print to console). So
+		 * disable preemption and spin on console_sem. We shouldn't
+		 * spin for long since printing CPU drops console_sem as soon
+		 * as it notices there is someone spinning on it.
+		 */
+		preempt_disable();
+		if (console_lock_try_spin())
+			console_unlock();
+		preempt_enable();
+	}
+	return 0;
+}
+
 static int __init printk_late_init(void)
 {
 	struct console *con;
+	int i;
+	struct task_struct *task;
 
 	for_each_console(con) {
 		if (!keep_bootcon && con->flags & CON_BOOT) {
@@ -2437,6 +2586,19 @@ static int __init printk_late_init(void)
 		}
 	}
 	hotcpu_notifier(console_cpu_notify, 0);
+
+	/* Does any handover of printing have any sence? */
+	if (num_possible_cpus() <= 1)
+		return 0;
+
+	for (i = 0; i < PRINTING_TASKS; i++) {
+		task = kthread_run(printing_task, NULL, "print/%d", i);
+		if (IS_ERR(task)) {
+			pr_err("printk: Cannot create printing thread: %ld\n",
+			       PTR_ERR(task));
+		}
+	}
+
 	return 0;
 }
 late_initcall(printk_late_init);
_

Patches currently in -mm which might be from jack@suse.cz are

backing_dev-fix-hung-task-on-sync.patch
backing_dev-fix-hung-task-on-sync-fix.patch
bdi-avoid-oops-on-device-removal.patch
kthread-ensure-locality-of-task_struct-allocations.patch
fanotify-remove-useless-bypass_perm-check.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
fanotify-convert-access_mutex-to-spinlock.patch
fanotify-reorganize-loop-in-fanotify_read.patch
fanotify-move-unrelated-handling-from-copy_event_to_user.patch
ocfs2-remove-ocfs2_inode_skip_delete-flag.patch
ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch
quota-provide-function-to-grab-quota-structure-reference.patch
ocfs2-implement-delayed-dropping-of-last-dquot-reference.patch
ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch
ocfs2-revert-iput-deferring-code-in-ocfs2_drop_dentry_lock.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch
printk-remove-outdated-comment.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch
printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
printk-remove-separate-printk_sched-buffers-and-use-printk-buf-instead.patch
printk-hand-over-printing-to-console-if-printing-too-long.patch
kernel-avoid-softlockups-in-stop_machine-during-heavy-printing.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

