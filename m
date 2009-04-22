From: akpm@linux-foundation.org
Subject: [merged] clocksource-add-enable-and-disable-callbacks.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:29:29 -0700
Message-ID: <200904221829.n3MITTJM005562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956AbZDVScn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:32:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: add enable() and disable() callbacks
has been removed from the -mm tree.  Its filename was
     clocksource-add-enable-and-disable-callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: add enable() and disable() callbacks
From: Magnus Damm <damm@igel.co.jp>

Add enable() and disable() callbacks for clocksources.  This allows us to
put unused clocksources in power save mode.  The functions
clocksource_enable() and clocksource_disable() wrap the callbacks and are
inserted in the timekeeping code to enable before use and disable after
switching to a new clocksource.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |   31 +++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c   |   12 +++++++++---
 2 files changed, 40 insertions(+), 3 deletions(-)

diff -puN include/linux/clocksource.h~clocksource-add-enable-and-disable-callbacks include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-add-enable-and-disable-callbacks
+++ a/include/linux/clocksource.h
@@ -144,6 +144,8 @@ extern u64 timecounter_cyc2time(struct t
  *				The ideal clocksource. A must-use where
  *				available.
  * @read:		returns a cycle value, passes clocksource as argument
+ * @enable:		optional function to enable the clocksource
+ * @disable:		optional function to disable the clocksource
  * @mask:		bitmask for two's complement
  *			subtraction of non 64 bit counters
  * @mult:		cycle to nanosecond multiplier (adjusted by NTP)
@@ -163,6 +165,8 @@ struct clocksource {
 	struct list_head list;
 	int rating;
 	cycle_t (*read)(struct clocksource *cs);
+	int (*enable)(struct clocksource *cs);
+	void (*disable)(struct clocksource *cs);
 	cycle_t mask;
 	u32 mult;
 	u32 mult_orig;
@@ -275,6 +279,33 @@ static inline cycle_t clocksource_read(s
 }
 
 /**
+ * clocksource_enable: - enable clocksource
+ * @cs:		pointer to clocksource
+ *
+ * Enables the specified clocksource. The clocksource callback
+ * function should start up the hardware and setup mult and field
+ * members of struct clocksource to reflect hardware capabilities.
+ */
+static inline int clocksource_enable(struct clocksource *cs)
+{
+	return cs->enable ? cs->enable(cs) : 0;
+}
+
+/**
+ * clocksource_disable: - disable clocksource
+ * @cs:		pointer to clocksource
+ *
+ * Disables the specified clocksource. The clocksource callback
+ * function should power down the now unused hardware block to
+ * save power.
+ */
+static inline void clocksource_disable(struct clocksource *cs)
+{
+	if (cs->disable)
+		cs->disable(cs);
+}
+
+/**
  * cyc2ns - converts clocksource cycles to nanoseconds
  * @cs:		Pointer to clocksource
  * @cycles:	Cycles
diff -puN kernel/time/timekeeping.c~clocksource-add-enable-and-disable-callbacks kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~clocksource-add-enable-and-disable-callbacks
+++ a/kernel/time/timekeeping.c
@@ -182,7 +182,7 @@ EXPORT_SYMBOL(do_settimeofday);
  */
 static void change_clocksource(void)
 {
-	struct clocksource *new;
+	struct clocksource *new, *old;
 
 	new = clocksource_get_next();
 
@@ -191,11 +191,16 @@ static void change_clocksource(void)
 
 	clocksource_forward_now();
 
-	new->raw_time = clock->raw_time;
+	if (clocksource_enable(new))
+		return;
 
+	new->raw_time = clock->raw_time;
+	old = clock;
 	clock = new;
+	clocksource_disable(old);
+
 	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(new);
+	clock->cycle_last = clocksource_read(clock);
 	clock->error = 0;
 	clock->xtime_nsec = 0;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
@@ -292,6 +297,7 @@ void __init timekeeping_init(void)
 	ntp_init();
 
 	clock = clocksource_get_next();
+	clocksource_enable(clock);
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
clocksource-sh_cmt-clocksource-support.patch

