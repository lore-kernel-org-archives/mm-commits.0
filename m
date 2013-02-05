From: akpm@linux-foundation.org
Subject: + printk-avoid-softlockups-in-console_unlock.patch added to -mm tree
Date: Tue, 05 Feb 2013 14:30:12 -0800
Message-ID: <20130205223012.A608831C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:47846 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab3BEWaO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 17:30:14 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so34751ggi.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 14:30:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     Subject: printk: Avoid softlockups in console_unlock()
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
Subject: printk: Avoid softlockups in console_unlock()

A CPU can be caught in console_unlock() for a long time (tens of seconds
are reported by our customers) when other CPUs are using printk heavily
and serial console makes printing slow.  Despite serial console drivers
are calling touch_nmi_watchdog() this triggers softlockup warnings because
interrupts are disabled for the whole time console_unlock() runs (e.g. 
vprintk() calls console_unlock() with interrupts disabled).  Thus IPIs
cannot be processed and other CPUs get stuck spinning in calls like
smp_call_function_many().  Also RCU eventually starts reporting lockups.

In my artificial testing I also managed to trigger a situation when disk
disappeared from the system apparently because commands to / from it could
not be delivered for long enough.  This is why just silencing watchdogs
isn't a reliable solution to the problem and we simply have to avoid
spending too long in console_unlock().

We fix the issue by limiting the time we spend in console_unlock() to
watchdog_thresh() / 4 (unless we are in an early boot stage or oops is
happening).  The rest of the buffer will be printed either by further
callers to printk() or by a queued work.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |   18 ++++++++++++
 kernel/printk.c     |   59 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 69 insertions(+), 8 deletions(-)

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
+	return watchdog_thresh * NSEC_PER_SEC / 2;
+}
+#else
+static inline u64 max_interrupt_disabled_duration(void)
+{
+	/* About the value we'd get with the default watchdog setting */
+	return 5 * NSEC_PER_SEC;
+}
 #endif
 
 #endif
diff -puN kernel/printk.c~printk-avoid-softlockups-in-console_unlock kernel/printk.c
--- a/kernel/printk.c~printk-avoid-softlockups-in-console_unlock
+++ a/kernel/printk.c
@@ -241,6 +241,10 @@ static enum log_flags console_prev;
 static u64 clear_seq;
 static u32 clear_idx;
 
+/* Worker to print accumulated data to console when there's too much of it */
+static void printk_worker(struct work_struct *work);
+static DECLARE_WORK(printk_work, printk_worker);
+
 #define PREFIX_MAX		32
 #define LOG_LINE_MAX		1024 - PREFIX_MAX
 
@@ -2023,28 +2027,39 @@ out:
  * Releases the console_lock which the caller holds on the console system
  * and the console driver list.
  *
- * While the console_lock was held, console output may have been buffered
- * by printk().  If this is the case, console_unlock(); emits
- * the output prior to releasing the lock.
+ * While the console_lock was held, console output may have been buffered by
+ * printk(). If this is the case, console_unlock() emits the output prior to
+ * releasing the lock. However we need not write all the data in the buffer if
+ * we would hog the CPU for too long. Function returns true, if there's more
+ * data that needs printing in the buffer.
  *
  * If there is output waiting, we wake /dev/kmsg and syslog() users.
  *
- * console_unlock(); may be called from any context.
+ * __console_unlock() may be called from any context.
  */
-void console_unlock(void)
+static bool __console_unlock(void)
 {
 	static char text[LOG_LINE_MAX + PREFIX_MAX];
 	static u64 seen_seq;
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	u64 end_time, now;
+	int cur_cpu;
 
 	if (console_suspended) {
 		up(&console_sem);
-		return;
+		return false;
 	}
 
 	console_may_schedule = 0;
+	cur_cpu = smp_processor_id();
+	/*
+	 * We give us some headroom because we check the time only after
+	 * printing the whole message
+	 */
+	end_time = sched_clock_cpu(cur_cpu) +
+				max_interrupt_disabled_duration() / 2;
 
 	/* flush buffered message fragment immediately to console */
 	console_cont_flush(text, sizeof(text));
@@ -2067,7 +2082,9 @@ again:
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		now = sched_clock_cpu(cur_cpu);
+		if (console_seq == log_next_seq ||
+		    (now > end_time && !oops_in_progress && keventd_up()))
 			break;
 
 		msg = log_from_idx(console_idx);
@@ -2121,14 +2138,40 @@ skip:
 	retry = console_seq != log_next_seq;
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (retry && console_trylock())
+	if (retry &&
+	    (now <= end_time || oops_in_progress || !keventd_up()) &&
+	    console_trylock())
 		goto again;
 
 	if (wake_klogd)
 		wake_up_klogd();
+	return retry;
+}
+
+void console_unlock(void)
+{
+	if (__console_unlock()) {
+		/* Let worker do the rest of printing */
+		schedule_work(&printk_work);
+	}
 }
 EXPORT_SYMBOL(console_unlock);
 
+/*
+ * This is a worker function to print data from printk buffer when
+ * console_unlock() didn't write it all. The advantage of this function is that
+ * it does the printing in a well known context where we can reschedule to
+ * avoid locking up one CPU with printing.
+ */
+static void printk_worker(struct work_struct *work)
+{
+	console_lock();
+	while (__console_unlock()) {
+		cond_resched();
+		console_lock();
+	}
+}
+
 /**
  * console_conditional_schedule - yield the CPU if required
  *
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
bdi-allow-block-devices-to-say-that-they-require-stable-page-writes.patch
mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it.patch
9pfs-fix-filesystem-to-wait-for-stable-page-writeback.patch
block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write.patch
ocfs2-wait-for-page-writeback-to-provide-stable-pages.patch
ubifs-wait-for-page-writeback-to-provide-stable-pages.patch
printk-avoid-softlockups-in-console_unlock.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
ocfs2-fix-possible-use-after-free-with-aio.patch
fs-direct-ioc-fix-possible-use-after-free-with-aio.patch

