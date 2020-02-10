From: akpm@linux-foundation.org
Subject: +
 kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch
 added to -mm tree
Date: Mon, 10 Feb 2020 14:52:12 -0800
Message-ID: <20200210225212.JtBqe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbgBJWwN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 Feb 2020 17:52:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, rostedt@goodmis.org, pmladek@suse.com, peterz@infradead.org, dmtrmonakhov@yandex-team.ru, khlebnikov@yandex-team.ru


The patch titled
     Subject: kernel/watchdog: flush all printk nmi buffers when hardlockup detected
has been added to the -mm tree.  Its filename is
     kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: kernel/watchdog: flush all printk nmi buffers when hardlockup detected

In NMI context printk() could save messages into per-cpu buffers and
schedule flush by irq_work when IRQ are unblocked.  This means message
about hardlockup appears in kernel log only when/if lockup is gone.

Comment in irq_work_queue_on() states that remote IPI aren't NMI safe thus
printk() cannot schedule flush work to another cpu.

This patch adds simple atomic counter of detected hardlockups and flushes
all per-cpu printk buffers in context softlockup watchdog at any other cpu
when it sees changes of this counter.

Link: http://lkml.kernel.org/r/158132813726.1980.17382047082627699898.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h   |    1 +
 kernel/watchdog.c     |   22 ++++++++++++++++++++++
 kernel/watchdog_hld.c |    1 +
 3 files changed, 24 insertions(+)

--- a/include/linux/nmi.h~kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected
+++ a/include/linux/nmi.h
@@ -84,6 +84,7 @@ static inline void reset_hung_task_detec
 #if defined(CONFIG_HARDLOCKUP_DETECTOR)
 extern void hardlockup_detector_disable(void);
 extern unsigned int hardlockup_panic;
+extern atomic_t hardlockup_detected;
 #else
 static inline void hardlockup_detector_disable(void) {}
 #endif
--- a/kernel/watchdog.c~kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected
+++ a/kernel/watchdog.c
@@ -92,6 +92,26 @@ static int __init hardlockup_all_cpu_bac
 }
 __setup("hardlockup_all_cpu_backtrace=", hardlockup_all_cpu_backtrace_setup);
 # endif /* CONFIG_SMP */
+
+atomic_t hardlockup_detected = ATOMIC_INIT(0);
+
+static inline void flush_hardlockup_messages(void)
+{
+	static atomic_t flushed = ATOMIC_INIT(0);
+
+	/* flush messages from hard lockup detector */
+	if (atomic_read(&hardlockup_detected) != atomic_read(&flushed)) {
+		atomic_set(&flushed, atomic_read(&hardlockup_detected));
+		printk_safe_flush();
+	}
+}
+
+#else /* CONFIG_HARDLOCKUP_DETECTOR */
+
+static inline void flush_hardlockup_messages(void)
+{
+}
+
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
 /*
@@ -370,6 +390,8 @@ static enum hrtimer_restart watchdog_tim
 	/* kick the hardlockup detector */
 	watchdog_interrupt_count();
 
+	flush_hardlockup_messages();
+
 	/* kick the softlockup detector */
 	if (completion_done(this_cpu_ptr(&softlockup_completion))) {
 		reinit_completion(this_cpu_ptr(&softlockup_completion));
--- a/kernel/watchdog_hld.c~kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected
+++ a/kernel/watchdog_hld.c
@@ -154,6 +154,7 @@ static void watchdog_overflow_callback(s
 
 		if (hardlockup_panic)
 			nmi_panic(regs, "Hard LOCKUP");
+		atomic_inc(&hardlockup_detected);
 
 		__this_cpu_write(hard_watchdog_warn, true);
 		return;
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch
lib-test_lockup-test-module-to-generate-lockups.patch
