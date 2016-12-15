From: akpm@linux-foundation.org
Subject: [merged]
 kdb-properly-synchronize-vkdb_printf-calls-with-other-cpus.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:46:24 -0800
Message-ID: <5852e500.RjUrH5IhXMM2yG55%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754581AbcLOSqv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, daniel.thompson@linaro.org, jason.wessel@windriver.com, peterz@infradead.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdb: properly synchronize vkdb_printf() calls with other CPUs
has been removed from the -mm tree.  Its filename was
     kdb-properly-synchronize-vkdb_printf-calls-with-other-cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kdb: properly synchronize vkdb_printf() calls with other CPUs

kdb_printf_lock does not prevent other CPUs from entering the critical
section because it is ignored when KDB_STATE_PRINTF_LOCK is set.

The problematic situation might look like:

CPU0					CPU1

vkdb_printf()
  if (!KDB_STATE(PRINTF_LOCK))
    KDB_STATE_SET(PRINTF_LOCK);
    spin_lock_irqsave(&kdb_printf_lock, flags);

					vkdb_printf()
					  if (!KDB_STATE(PRINTF_LOCK))

BANG: The PRINTF_LOCK state is set and CPU1 is entering the critical
section without spinning on the lock.

The problem is that the code tries to implement locking using two state
variables that are not handled atomically.  Well, we need a custom locking
because we want to allow reentering the critical section on the very same
CPU.

Let's use solution from Petr Zijlstra that was proposed for a similar
scenario, see
https://lkml.kernel.org/r/20161018171513.734367391@infradead.org

This patch uses the same trick with cmpxchg().  The only difference is
that we want to handle only recursion from the same context and therefore
we disable interrupts.

In addition, KDB_STATE_PRINTF_LOCK is removed. In fact, we are not
able to set it a non-racy way.

Link: http://lkml.kernel.org/r/1480412276-16690-3-git-send-email-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/kdb/kdb_io.c      |   30 +++++++++++++-----------------
 kernel/debug/kdb/kdb_private.h |    1 -
 2 files changed, 13 insertions(+), 18 deletions(-)

diff -puN kernel/debug/kdb/kdb_io.c~kdb-properly-synchronize-vkdb_printf-calls-with-other-cpus kernel/debug/kdb/kdb_io.c
--- a/kernel/debug/kdb/kdb_io.c~kdb-properly-synchronize-vkdb_printf-calls-with-other-cpus
+++ a/kernel/debug/kdb/kdb_io.c
@@ -555,16 +555,16 @@ int vkdb_printf(enum kdb_msgsrc src, con
 	int colcount;
 	int logging, saved_loglevel = 0;
 	int saved_trap_printk;
-	int got_printf_lock = 0;
 	int retlen = 0;
 	int fnd, len;
+	int this_cpu, old_cpu;
+	static int kdb_printf_cpu = -1;
 	char *cp, *cp2, *cphold = NULL, replaced_byte = ' ';
 	char *moreprompt = "more> ";
 	struct console *c = console_drivers;
-	static DEFINE_SPINLOCK(kdb_printf_lock);
 	unsigned long uninitialized_var(flags);
 
-	preempt_disable();
+	local_irq_save(flags);
 	saved_trap_printk = kdb_trap_printk;
 	kdb_trap_printk = 0;
 
@@ -572,12 +572,13 @@ int vkdb_printf(enum kdb_msgsrc src, con
 	 * But if any cpu goes recursive in kdb, just print the output,
 	 * even if it is interleaved with any other text.
 	 */
-	if (!KDB_STATE(PRINTF_LOCK)) {
-		KDB_STATE_SET(PRINTF_LOCK);
-		spin_lock_irqsave(&kdb_printf_lock, flags);
-		got_printf_lock = 1;
-	} else {
-		__acquire(kdb_printf_lock);
+	this_cpu = smp_processor_id();
+	for (;;) {
+		old_cpu = cmpxchg(&kdb_printf_cpu, -1, this_cpu);
+		if (old_cpu == -1 || old_cpu == this_cpu)
+			break;
+
+		cpu_relax();
 	}
 
 	diag = kdbgetintenv("LINES", &linecount);
@@ -846,15 +847,10 @@ kdb_print_out:
 	suspend_grep = 0; /* end of what may have been a recursive call */
 	if (logging)
 		console_loglevel = saved_loglevel;
-	if (KDB_STATE(PRINTF_LOCK) && got_printf_lock) {
-		got_printf_lock = 0;
-		spin_unlock_irqrestore(&kdb_printf_lock, flags);
-		KDB_STATE_CLEAR(PRINTF_LOCK);
-	} else {
-		__release(kdb_printf_lock);
-	}
+	/* kdb_printf_cpu locked the code above. */
+	smp_store_release(&kdb_printf_cpu, old_cpu);
 	kdb_trap_printk = saved_trap_printk;
-	preempt_enable();
+	local_irq_restore(flags);
 	return retlen;
 }
 
diff -puN kernel/debug/kdb/kdb_private.h~kdb-properly-synchronize-vkdb_printf-calls-with-other-cpus kernel/debug/kdb/kdb_private.h
--- a/kernel/debug/kdb/kdb_private.h~kdb-properly-synchronize-vkdb_printf-calls-with-other-cpus
+++ a/kernel/debug/kdb/kdb_private.h
@@ -132,7 +132,6 @@ extern int kdb_state;
 #define KDB_STATE_PAGER		0x00000400	/* pager is available */
 #define KDB_STATE_GO_SWITCH	0x00000800	/* go is switching
 						 * back to initial cpu */
-#define KDB_STATE_PRINTF_LOCK	0x00001000	/* Holds kdb_printf lock */
 #define KDB_STATE_WAIT_IPI	0x00002000	/* Waiting for kdb_ipi() NMI */
 #define KDB_STATE_RECURSE	0x00004000	/* Recursive entry to kdb */
 #define KDB_STATE_IP_ADJUSTED	0x00008000	/* Restart IP has been
_

Patches currently in -mm which might be from pmladek@suse.com are


