From: akpm@linux-foundation.org
Subject: [merged] timers-introduce-the-concept-of-timer-slack-for-legacy-timers.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:38:12 -0400
Message-ID: <201004151839.o3FIdorW024338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756026Ab0DOSkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:40:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, gorcunov@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timers: introduce the concept of timer slack for legacy timers
has been removed from the -mm tree.  Its filename was
     timers-introduce-the-concept-of-timer-slack-for-legacy-timers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timers: introduce the concept of timer slack for legacy timers
From: Arjan van de Ven <arjan@linux.intel.com>

While HR timers have had the concept of timer slack for quite some time
now, the legacy timers lacked this concept, and had to make do with
round_jiffies() and friends.

Timer slack is important for power management; grouping timers reduces the
number of wakeups which in turn reduces power consumption.

This patch introduces timer slack to the legacy timers using the following
pieces:
* A slack field in the timer struct
* An api (set_timer_slack) that callers can use to set explicit timer slack
* A default slack of 0.4% of the requested delay for callers that do not set
  any explicit slack
* Rounding code that is part of mod_timer() that tries to
  group timers around jiffies values every 'power of two'
  (so quick timers will group around every 2, but longer timers
  will group around every 4, 8, 16, 32 etc)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |   10 ++++++-
 kernel/timer.c        |   56 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff -puN include/linux/timer.h~timers-introduce-the-concept-of-timer-slack-for-legacy-timers include/linux/timer.h
--- a/include/linux/timer.h~timers-introduce-the-concept-of-timer-slack-for-legacy-timers
+++ a/include/linux/timer.h
@@ -10,13 +10,19 @@
 struct tvec_base;
 
 struct timer_list {
+	/*
+	 * All fields that change during normal runtime grouped to the
+	 * same cacheline
+	 */
 	struct list_head entry;
 	unsigned long expires;
+	struct tvec_base *base;
 
 	void (*function)(unsigned long);
 	unsigned long data;
 
-	struct tvec_base *base;
+	int slack;
+
 #ifdef CONFIG_TIMER_STATS
 	void *start_site;
 	char start_comm[16];
@@ -165,6 +171,8 @@ extern int mod_timer(struct timer_list *
 extern int mod_timer_pending(struct timer_list *timer, unsigned long expires);
 extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
+extern void set_timer_slack(struct timer_list *time, int slack_hz);
+
 #define TIMER_NOT_PINNED	0
 #define TIMER_PINNED		1
 /*
diff -puN kernel/timer.c~timers-introduce-the-concept-of-timer-slack-for-legacy-timers kernel/timer.c
--- a/kernel/timer.c~timers-introduce-the-concept-of-timer-slack-for-legacy-timers
+++ a/kernel/timer.c
@@ -319,6 +319,24 @@ unsigned long round_jiffies_up_relative(
 }
 EXPORT_SYMBOL_GPL(round_jiffies_up_relative);
 
+/**
+ * set_timer_slack - set the allowed slack for a timer
+ * @slack_hz: the amount of time (in jiffies) allowed for rounding
+ *
+ * Set the amount of time, in jiffies, that a certain timer has
+ * in terms of slack. By setting this value, the timer subsystem
+ * will schedule the actual timer somewhere between
+ * the time mod_timer() asks for, and that time plus the slack.
+ *
+ * By setting the slack to -1, a percentage of the delay is used
+ * instead.
+ */
+void set_timer_slack(struct timer_list *timer, int slack_hz)
+{
+	timer->slack = slack_hz;
+}
+EXPORT_SYMBOL_GPL(set_timer_slack);
+
 
 static inline void set_running_timer(struct tvec_base *base,
 					struct timer_list *timer)
@@ -550,6 +568,7 @@ static void __init_timer(struct timer_li
 {
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
+	timer->slack = -1;
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
 	timer->start_pid = -1;
@@ -715,6 +734,41 @@ int mod_timer_pending(struct timer_list 
 }
 EXPORT_SYMBOL(mod_timer_pending);
 
+/*
+ * Decide where to put the timer while taking the slack into account
+ *
+ * Algorithm:
+ *   1) calculate the maximum (absolute) time
+ *   2) calculate the highest bit where the expires and new max are different
+ *   3) use this bit to make a mask
+ *   4) use the bitmask to round down the maximum time, so that all last
+ *      bits are zeros
+ */
+static inline
+unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
+{
+	unsigned long expires_limit, mask;
+	int bit;
+
+	expires_limit = expires + timer->slack;
+
+	if (timer->slack < 0) /* auto slack: use 0.4% */
+		expires_limit = expires + (expires - jiffies)/256;
+
+	mask = expires ^ expires_limit;
+
+	if (mask == 0)
+		return expires;
+
+	bit = find_last_bit(&mask, BITS_PER_LONG);
+
+	mask = (1 << bit) - 1;
+
+	expires_limit = expires_limit & ~(mask);
+
+	return expires_limit;
+}
+
 /**
  * mod_timer - modify a timer's timeout
  * @timer: the timer to be modified
@@ -745,6 +799,8 @@ int mod_timer(struct timer_list *timer, 
 	if (timer_pending(timer) && timer->expires == expires)
 		return 1;
 
+	expires = apply_slack(timer, expires);
+
 	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
 }
 EXPORT_SYMBOL(mod_timer);
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch

