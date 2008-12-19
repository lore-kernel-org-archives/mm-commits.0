From: akpm@linux-foundation.org
Subject: + clocksource-pass-clocksource-to-read-callback-v2.patch added to -mm tree
Date: Fri, 19 Dec 2008 13:13:43 -0800
Message-ID: <200812192113.mBJLDkaS025067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbYLSVOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Dec 2008 16:14:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, davem@davemloft.net


The patch titled
     clocksource: pass clocksource to read() callback V2
has been added to the -mm tree.  Its filename is
     clocksource-pass-clocksource-to-read-callback-v2.patch

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
Subject: clocksource: pass clocksource to read() callback V2
From: Magnus Damm <damm@igel.co.jp>

Pass clocksource pointer to the read() callback for clocksources.
This allows us to share the callback between multiple instances.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/timer_64.h |    3 +--
 arch/sparc/kernel/time_64.c       |   21 +++++++++++++--------
 kernel/time/clocksource.c         |    8 ++++----
 3 files changed, 18 insertions(+), 14 deletions(-)

diff -puN arch/sparc/include/asm/timer_64.h~clocksource-pass-clocksource-to-read-callback-v2 arch/sparc/include/asm/timer_64.h
--- a/arch/sparc/include/asm/timer_64.h~clocksource-pass-clocksource-to-read-callback-v2
+++ a/arch/sparc/include/asm/timer_64.h
@@ -8,10 +8,9 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
-#include <linux/clocksource.h>
 
 struct sparc64_tick_ops {
-	unsigned long (*get_tick)(struct clocksource *cs);
+	unsigned long (*get_tick)(void);
 	int (*add_compare)(unsigned long);
 	unsigned long softint_mask;
 	void (*disable_irq)(void);
diff -puN arch/sparc/kernel/time_64.c~clocksource-pass-clocksource-to-read-callback-v2 arch/sparc/kernel/time_64.c
--- a/arch/sparc/kernel/time_64.c~clocksource-pass-clocksource-to-read-callback-v2
+++ a/arch/sparc/kernel/time_64.c
@@ -106,7 +106,7 @@ static void tick_init_tick(void)
 	tick_disable_irq();
 }
 
-static unsigned long tick_get_tick(struct clocksource *cs)
+static unsigned long tick_get_tick(void)
 {
 	unsigned long ret;
 
@@ -208,7 +208,7 @@ static void stick_init_tick(void)
 	stick_disable_irq();
 }
 
-static unsigned long stick_get_tick(struct clocksource *cs)
+static unsigned long stick_get_tick(void)
 {
 	unsigned long ret;
 
@@ -352,7 +352,7 @@ static void hbtick_init_tick(void)
 	hbtick_disable_irq();
 }
 
-static unsigned long hbtick_get_tick(struct clocksource *cs)
+static unsigned long hbtick_get_tick(void)
 {
 	return __hbird_read_stick() & ~TICK_PRIV_BIT;
 }
@@ -799,9 +799,9 @@ void __delay(unsigned long loops)
 {
 	unsigned long bclock, now;
 
-	bclock = tick_ops->get_tick(&clocksource_tick);
+	bclock = tick_ops->get_tick();
 	do {
-		now = tick_ops->get_tick(&clocksource_tick);
+		now = tick_ops->get_tick();
 	} while ((now-bclock) < loops);
 }
 EXPORT_SYMBOL(__delay);
@@ -812,6 +812,11 @@ void udelay(unsigned long usecs)
 }
 EXPORT_SYMBOL(udelay);
 
+static cycle_t clocksource_tick_read(struct clocksource *cs)
+{
+	return tick_ops->get_tick();
+}
+
 void __init time_init(void)
 {
 	unsigned long freq = sparc64_init_timers();
@@ -825,7 +830,7 @@ void __init time_init(void)
 	clocksource_tick.mult =
 		clocksource_hz2mult(freq,
 				    clocksource_tick.shift);
-	clocksource_tick.read = tick_ops->get_tick;
+	clocksource_tick.read = clocksource_tick_read;
 
 	printk("clocksource: mult[%x] shift[%d]\n",
 	       clocksource_tick.mult, clocksource_tick.shift);
@@ -849,7 +854,7 @@ void __init time_init(void)
 
 unsigned long long sched_clock(void)
 {
-	unsigned long ticks = tick_ops->get_tick(&clocksource_tick);
+	unsigned long ticks = tick_ops->get_tick();
 
 	return (ticks * timer_ticks_per_nsec_quotient)
 		>> SPARC64_NSEC_PER_CYC_SHIFT;
@@ -857,6 +862,6 @@ unsigned long long sched_clock(void)
 
 int __devinit read_current_timer(unsigned long *timer_val)
 {
-	*timer_val = tick_ops->get_tick(&clocksource_tick);
+	*timer_val = tick_ops->get_tick();
 	return 0;
 }
diff -puN kernel/time/clocksource.c~clocksource-pass-clocksource-to-read-callback-v2 kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-pass-clocksource-to-read-callback-v2
+++ a/kernel/time/clocksource.c
@@ -105,12 +105,12 @@ static void clocksource_watchdog(unsigne
 
 	resumed = test_and_clear_bit(0, &watchdog_resumed);
 
-	wdnow = watchdog->read();
+	wdnow = watchdog->read(watchdog);
 	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
 	watchdog_last = wdnow;
 
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
-		csnow = cs->read();
+		csnow = cs->read(cs);
 
 		if (unlikely(resumed)) {
 			cs->wd_last = csnow;
@@ -170,7 +170,7 @@ static void clocksource_check_watchdog(s
 
 		list_add(&cs->wd_list, &watchdog_list);
 		if (!started && watchdog) {
-			watchdog_last = watchdog->read();
+			watchdog_last = watchdog->read(watchdog);
 			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 			add_timer_on(&watchdog_timer,
 				     first_cpu(cpu_online_map));
@@ -191,7 +191,7 @@ static void clocksource_check_watchdog(s
 				cse->flags &= ~CLOCK_SOURCE_WATCHDOG;
 			/* Start if list is not empty */
 			if (!list_empty(&watchdog_list)) {
-				watchdog_last = watchdog->read();
+				watchdog_last = watchdog->read(watchdog);
 				watchdog_timer.expires =
 					jiffies + WATCHDOG_INTERVAL;
 				add_timer_on(&watchdog_timer,
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-v2.patch
clocksource-pass-clocksource-to-read-callback-fix.patch
clocksource-add-enable-and-disable-callbacks.patch
irq-free-setup_irq-interrupt-using-free_irq.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
vmcore-remove-saved_max_pfn-check.patch

