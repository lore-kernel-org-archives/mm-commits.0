From: akpm@linux-foundation.org
Subject: + timers-add-usleep-timer.patch added to -mm tree
Date: Thu, 22 Jul 2010 16:17:01 -0700
Message-ID: <201007222317.o6MNH1ej017923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166Ab0GVXRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Jul 2010 19:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ppannuto@codeaurora.org, arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     timers: add usleep[_range] timer
has been added to the -mm tree.  Its filename is
     timers-add-usleep-timer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timers: add usleep[_range] timer
From: Patrick Pannuto <ppannuto@codeaurora.org>

usleep[_range] are finer precision implementations of msleep and are
designed to be drop-in replacements for udelay where a precise sleep /
busy-wait is unnecessary.  They also allow an easy interface to specify
slack when a precise (ish) wakeup is unnecessary to help minimize wakeups

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delay.h |    6 ++++++
 kernel/timer.c        |   22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff -puN include/linux/delay.h~timers-add-usleep-timer include/linux/delay.h
--- a/include/linux/delay.h~timers-add-usleep-timer
+++ a/include/linux/delay.h
@@ -45,6 +45,12 @@ extern unsigned long lpj_fine;
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
+void usleep_range(unsigned long min, unsigned long max);
+
+static inline void usleep(unsigned long usecs)
+{
+	usleep_range(usecs, usecs);
+}
 
 static inline void ssleep(unsigned int seconds)
 {
diff -puN kernel/timer.c~timers-add-usleep-timer kernel/timer.c
--- a/kernel/timer.c~timers-add-usleep-timer
+++ a/kernel/timer.c
@@ -1763,3 +1763,25 @@ unsigned long msleep_interruptible(unsig
 }
 
 EXPORT_SYMBOL(msleep_interruptible);
+
+static int __sched do_usleep_range(unsigned long min, unsigned long max)
+{
+	ktime_t kmin;
+	unsigned long delta;
+
+	kmin = ktime_set(0, min * NSEC_PER_USEC);
+	delta = max - min;
+	return schedule_hrtimeout_range(&kmin, delta, HRTIMER_MODE_REL);
+}
+
+/**
+ * usleep_range - Drop in replacement for udelay where wakeup is flexible
+ * @min: Minimum time in usecs to sleep
+ * @max: Maximum time in usecs to sleep
+ */
+void usleep_range(unsigned long min, unsigned long max)
+{
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	do_usleep_range(min, max);
+}
+EXPORT_SYMBOL(usleep_range);
_

Patches currently in -mm which might be from ppannuto@codeaurora.org are

timers-add-usleep-timer.patch

