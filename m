From: akpm@linux-foundation.org
Subject: + printk-provide-a-wake_up_klogd-off-case.patch added to -mm tree
Date: Thu, 14 Mar 2013 13:39:53 -0700
Message-ID: <20130314203953.E33C331C15E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:46397 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3CNUjz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 16:39:55 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so269928yhz.5
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 13:39:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, james.hogan@imgtec.com, mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org


The patch titled
     Subject: printk: Provide a wake_up_klogd() off-case
has been added to the -mm tree.  Its filename is
     printk-provide-a-wake_up_klogd-off-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 3 files changed, 45 insertions(+), 42 deletions(-)

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
@@ -1958,45 +1957,6 @@ int is_console_locked(void)
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
@@ -2459,6 +2419,44 @@ static int __init printk_late_init(void)
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
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
irq_workh-fix-warning-when-config_irq_work=n.patch
printk-provide-a-wake_up_klogd-off-case.patch
printk-provide-a-wake_up_klogd-off-case-fix.patch
mm-trace-filemap-add-and-del.patch
mm-trace-filemap-add-and-del-v2.patch
printk-tracing-rework-console-tracing.patch

