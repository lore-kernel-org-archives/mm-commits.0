From: akpm@linux-foundation.org
Subject: [merged] printk-provide-a-wake_up_klogd-off-case.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:44:57 -0700
Message-ID: <20130325194457.87F0C5A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:59482 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884Ab3CYTo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:44:59 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so653419vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:44:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, james.hogan@imgtec.com, mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: Provide a wake_up_klogd() off-case
has been removed from the -mm tree.  Its filename was
     printk-provide-a-wake_up_klogd-off-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: printk: Provide a wake_up_klogd() off-case

wake_up_klogd() is useless when CONFIG_PRINTK=n because neither printk()
nor printk_sched() are in use and there are actually no waiter on log_wait
waitqueue.  It should be a stub in this case for users like
bust_spinlocks().

Otherwise this results in this warning when CONFIG_PRINTK=n
and CONFIG_IRQ_WORK=n:

	kernel/built-in.o In function `wake_up_klogd':
	(.text.wake_up_klogd+0xb4): undefined reference to `irq_work_queue'

To fix this, provide an off-case for wake_up_klogd() when CONFIG_PRINTK=n.

There is much more from console_unlock() and other console related code in
printk.c that should be moved under CONFIG_PRINTK.  But for now, focus on
a minimal fix as we passed the merged window already.

[akpm@linux-foundation.org: include printk.h in bust_spinlocks.c]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: James Hogan <james.hogan@imgtec.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 
 include/linux/printk.h |    6 ++
 kernel/printk.c        |   80 +++++++++++++++++++--------------------
 lib/bust_spinlocks.c   |    3 -
 4 files changed, 46 insertions(+), 44 deletions(-)

diff -puN include/linux/kernel.h~printk-provide-a-wake_up_klogd-off-case include/linux/kernel.h
--- a/include/linux/kernel.h~printk-provide-a-wake_up_klogd-off-case
+++ a/include/linux/kernel.h
@@ -390,7 +390,6 @@ extern struct pid *session_of_pgrp(struc
 unsigned long int_sqrt(unsigned long);
 
 extern void bust_spinlocks(int yes);
-extern void wake_up_klogd(void);
 extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
 extern int panic_timeout;
 extern int panic_on_oops;
diff -puN include/linux/printk.h~printk-provide-a-wake_up_klogd-off-case include/linux/printk.h
--- a/include/linux/printk.h~printk-provide-a-wake_up_klogd-off-case
+++ a/include/linux/printk.h
@@ -134,6 +134,8 @@ extern int printk_delay_msec;
 extern int dmesg_restrict;
 extern int kptr_restrict;
 
+extern void wake_up_klogd(void);
+
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
 #else
@@ -162,6 +164,10 @@ static inline bool printk_timed_ratelimi
 	return false;
 }
 
+static inline void wake_up_klogd(void)
+{
+}
+
 static inline void log_buf_kexec_setup(void)
 {
 }
diff -puN kernel/printk.c~printk-provide-a-wake_up_klogd-off-case kernel/printk.c
--- a/kernel/printk.c~printk-provide-a-wake_up_klogd-off-case
+++ a/kernel/printk.c
@@ -63,8 +63,6 @@ void asmlinkage __attribute__((weak)) ea
 #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
 #define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
 
-DECLARE_WAIT_QUEUE_HEAD(log_wait);
-
 int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* console_loglevel */
 	DEFAULT_MESSAGE_LOGLEVEL,	/* default_message_loglevel */
@@ -224,6 +222,7 @@ struct log {
 static DEFINE_RAW_SPINLOCK(logbuf_lock);
 
 #ifdef CONFIG_PRINTK
+DECLARE_WAIT_QUEUE_HEAD(log_wait);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
@@ -1957,45 +1956,6 @@ int is_console_locked(void)
 	return console_locked;
 }
 
-/*
- * Delayed printk version, for scheduler-internal messages:
- */
-#define PRINTK_BUF_SIZE		512
-
-#define PRINTK_PENDING_WAKEUP	0x01
-#define PRINTK_PENDING_SCHED	0x02
-
-static DEFINE_PER_CPU(int, printk_pending);
-static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
-
-static void wake_up_klogd_work_func(struct irq_work *irq_work)
-{
-	int pending = __this_cpu_xchg(printk_pending, 0);
-
-	if (pending & PRINTK_PENDING_SCHED) {
-		char *buf = __get_cpu_var(printk_sched_buf);
-		printk(KERN_WARNING "[sched_delayed] %s", buf);
-	}
-
-	if (pending & PRINTK_PENDING_WAKEUP)
-		wake_up_interruptible(&log_wait);
-}
-
-static DEFINE_PER_CPU(struct irq_work, wake_up_klogd_work) = {
-	.func = wake_up_klogd_work_func,
-	.flags = IRQ_WORK_LAZY,
-};
-
-void wake_up_klogd(void)
-{
-	preempt_disable();
-	if (waitqueue_active(&log_wait)) {
-		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
-		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
-	}
-	preempt_enable();
-}
-
 static void console_cont_flush(char *text, size_t size)
 {
 	unsigned long flags;
@@ -2458,6 +2418,44 @@ static int __init printk_late_init(void)
 late_initcall(printk_late_init);
 
 #if defined CONFIG_PRINTK
+/*
+ * Delayed printk version, for scheduler-internal messages:
+ */
+#define PRINTK_BUF_SIZE		512
+
+#define PRINTK_PENDING_WAKEUP	0x01
+#define PRINTK_PENDING_SCHED	0x02
+
+static DEFINE_PER_CPU(int, printk_pending);
+static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
+
+static void wake_up_klogd_work_func(struct irq_work *irq_work)
+{
+	int pending = __this_cpu_xchg(printk_pending, 0);
+
+	if (pending & PRINTK_PENDING_SCHED) {
+		char *buf = __get_cpu_var(printk_sched_buf);
+		printk(KERN_WARNING "[sched_delayed] %s", buf);
+	}
+
+	if (pending & PRINTK_PENDING_WAKEUP)
+		wake_up_interruptible(&log_wait);
+}
+
+static DEFINE_PER_CPU(struct irq_work, wake_up_klogd_work) = {
+	.func = wake_up_klogd_work_func,
+	.flags = IRQ_WORK_LAZY,
+};
+
+void wake_up_klogd(void)
+{
+	preempt_disable();
+	if (waitqueue_active(&log_wait)) {
+		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
+		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	}
+	preempt_enable();
+}
 
 int printk_sched(const char *fmt, ...)
 {
diff -puN lib/bust_spinlocks.c~printk-provide-a-wake_up_klogd-off-case lib/bust_spinlocks.c
--- a/lib/bust_spinlocks.c~printk-provide-a-wake_up_klogd-off-case
+++ a/lib/bust_spinlocks.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/spinlock.h>
 #include <linux/tty.h>
 #include <linux/wait.h>
@@ -28,5 +29,3 @@ void __attribute__((weak)) bust_spinlock
 			wake_up_klogd();
 	}
 }
-
