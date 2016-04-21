From: akpm@linux-foundation.org
Subject: + printk-nmi-flush-nmi-messages-on-the-system-panic.patch added
 to -mm tree
Date: Thu, 21 Apr 2016 15:04:06 -0700
Message-ID: <57194e56.dCJuwoy+yFZMiDrg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbcDUWEI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 18:04:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, benh@kernel.crashing.org, daniel.thompson@linaro.org, davem@davemloft.net, jack@suse.cz, jkosina@suse.com, mingo@redhat.com, peterz@infradead.org, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, rostedt@goodmis.org, schwidefsky@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/nmi: flush NMI messages on the system panic
has been added to the -mm tree.  Its filename is
     printk-nmi-flush-nmi-messages-on-the-system-panic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-nmi-flush-nmi-messages-on-the-system-panic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-nmi-flush-nmi-messages-on-the-system-panic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: printk/nmi: flush NMI messages on the system panic

In NMI context, printk() messages are stored into per-CPU buffers to avoid
a possible deadlock.  They are normally flushed to the main ring buffer via
an IRQ work.  But the work is never called when the system calls panic() in
the very same NMI handler.

This patch tries to flush NMI buffers before the crash dump is generated.
In this case it does not risk a double release and bails out when the
logbuf_lock is already taken.  The aim is to get the messages into the main
ring buffer when possible.  It makes them better accessible in the vmcore.

Then the patch tries to flush the buffers second time when other CPUs are
down.  It might be more aggressive and reset logbuf_lock. The aim is to
get the messages available for the consequent kmsg_dump() and
console_flush_on_panic() calls.

The patch causes vprintk_emit() to be called even in NMI context again. But
it is done via printk_deferred() so that the console handling is skipped.
Consoles use internal locks and we could not prevent a deadlock easily.
They are explicitly called later when the crash dump is not generated, see
console_flush_on_panic().

Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h   |    2 +
 kernel/kexec_core.c      |    1 
 kernel/panic.c           |    6 ++++-
 kernel/printk/internal.h |    2 +
 kernel/printk/nmi.c      |   39 ++++++++++++++++++++++++++++++++++++-
 kernel/printk/printk.c   |    2 -
 6 files changed, 49 insertions(+), 3 deletions(-)

diff -puN include/linux/printk.h~printk-nmi-flush-nmi-messages-on-the-system-panic include/linux/printk.h
--- a/include/linux/printk.h~printk-nmi-flush-nmi-messages-on-the-system-panic
+++ a/include/linux/printk.h
@@ -127,11 +127,13 @@ extern void printk_nmi_init(void);
 extern void printk_nmi_enter(void);
 extern void printk_nmi_exit(void);
 extern void printk_nmi_flush(void);
+extern void printk_nmi_flush_on_panic(void);
 #else
 static inline void printk_nmi_init(void) { }
 static inline void printk_nmi_enter(void) { }
 static inline void printk_nmi_exit(void) { }
 static inline void printk_nmi_flush(void) { }
+static inline void printk_nmi_flush_on_panic(void) { }
 #endif /* PRINTK_NMI */
 
 #ifdef CONFIG_PRINTK
diff -puN kernel/kexec_core.c~printk-nmi-flush-nmi-messages-on-the-system-panic kernel/kexec_core.c
--- a/kernel/kexec_core.c~printk-nmi-flush-nmi-messages-on-the-system-panic
+++ a/kernel/kexec_core.c
@@ -893,6 +893,7 @@ void crash_kexec(struct pt_regs *regs)
 	old_cpu = atomic_cmpxchg(&panic_cpu, PANIC_CPU_INVALID, this_cpu);
 	if (old_cpu == PANIC_CPU_INVALID) {
 		/* This is the 1st CPU which comes here, so go ahead. */
+		printk_nmi_flush_on_panic();
 		__crash_kexec(regs);
 
 		/*
diff -puN kernel/panic.c~printk-nmi-flush-nmi-messages-on-the-system-panic kernel/panic.c
--- a/kernel/panic.c~printk-nmi-flush-nmi-messages-on-the-system-panic
+++ a/kernel/panic.c
@@ -160,8 +160,10 @@ void panic(const char *fmt, ...)
 	 *
 	 * Bypass the panic_cpu check and call __crash_kexec directly.
 	 */
-	if (!crash_kexec_post_notifiers)
+	if (!crash_kexec_post_notifiers) {
+		printk_nmi_flush_on_panic();
 		__crash_kexec(NULL);
+	}
 
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
@@ -176,6 +178,8 @@ void panic(const char *fmt, ...)
 	 */
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
+	/* Call flush even twice. It tries harder with a single online CPU */
+	printk_nmi_flush_on_panic();
 	kmsg_dump(KMSG_DUMP_PANIC);
 
 	/*
diff -puN kernel/printk/internal.h~printk-nmi-flush-nmi-messages-on-the-system-panic kernel/printk/internal.h
--- a/kernel/printk/internal.h~printk-nmi-flush-nmi-messages-on-the-system-panic
+++ a/kernel/printk/internal.h
@@ -22,6 +22,8 @@ int __printf(1, 0) vprintk_default(const
 
 #ifdef CONFIG_PRINTK_NMI
 
+extern raw_spinlock_t logbuf_lock;
+
 /*
  * printk() could not take logbuf_lock in NMI context. Instead,
  * it temporary stores the strings into a per-CPU buffer.
diff -puN kernel/printk/nmi.c~printk-nmi-flush-nmi-messages-on-the-system-panic kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-nmi-flush-nmi-messages-on-the-system-panic
+++ a/kernel/printk/nmi.c
@@ -17,6 +17,7 @@
 
 #include <linux/preempt.h>
 #include <linux/spinlock.h>
+#include <linux/debug_locks.h>
 #include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/irq_work.h>
@@ -106,7 +107,16 @@ static void print_nmi_seq_line(struct nm
 {
 	const char *buf = s->buffer + start;
 
-	printk("%.*s", (end - start) + 1, buf);
+	/*
+	 * The buffers are flushed in NMI only on panic.  The messages must
+	 * go only into the ring buffer at this stage.  Consoles will get
+	 * explicitly called later when a crashdump is not generated.
+	 */
+	if (in_nmi())
+		printk_deferred("%.*s", (end - start) + 1, buf);
+	else
+		printk("%.*s", (end - start) + 1, buf);
+
 }
 
 /*
@@ -194,6 +204,33 @@ void printk_nmi_flush(void)
 		__printk_nmi_flush(&per_cpu(nmi_print_seq, cpu).work);
 }
 
+/**
+ * printk_nmi_flush_on_panic - flush all per-cpu nmi buffers when the system
+ *	goes down.
+ *
+ * Similar to printk_nmi_flush() but it can be called even in NMI context when
+ * the system goes down. It does the best effort to get NMI messages into
+ * the main ring buffer.
+ *
+ * Note that it could try harder when there is only one CPU online.
+ */
+void printk_nmi_flush_on_panic(void)
+{
+	/*
+	 * Make sure that we could access the main ring buffer.
+	 * Do not risk a double release when more CPUs are up.
+	 */
+	if (in_nmi() && raw_spin_is_locked(&logbuf_lock)) {
+		if (num_online_cpus() > 1)
+			return;
+
+		debug_locks_off();
+		raw_spin_lock_init(&logbuf_lock);
+	}
+
+	printk_nmi_flush();
+}
+
 void __init printk_nmi_init(void)
 {
 	int cpu;
diff -puN kernel/printk/printk.c~printk-nmi-flush-nmi-messages-on-the-system-panic kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-nmi-flush-nmi-messages-on-the-system-panic
+++ a/kernel/printk/printk.c
@@ -245,7 +245,7 @@ __packed __aligned(4)
  * within the scheduler's rq lock. It must be released before calling
  * console_unlock() or anything else that might wake up a process.
  */
-static DEFINE_RAW_SPINLOCK(logbuf_lock);
+DEFINE_RAW_SPINLOCK(logbuf_lock);
 
 #ifdef CONFIG_PRINTK
 DECLARE_WAIT_QUEUE_HEAD(log_wait);
_

Patches currently in -mm which might be from pmladek@suse.com are

printk-nmi-generic-solution-for-safe-printk-in-nmi.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context.patch
printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable.patch
printk-nmi-flush-nmi-messages-on-the-system-panic.patch

