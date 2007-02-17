From: akpm@linux-foundation.org
Subject: - extend-next_timer_interrupt-to-use-a-reference-jiffie.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:14:19 -0800
Message-ID: <200702170714.l1H7EJ1S021518@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51271 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946566AbXBQHSU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:18:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, bunk@stusta.de, cotte@de.ibm.com, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Extend next_timer_interrupt() to use a reference jiffie
has been removed from the -mm tree.  Its filename was
     extend-next_timer_interrupt-to-use-a-reference-jiffie.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Extend next_timer_interrupt() to use a reference jiffie
From: Thomas Gleixner <tglx@linutronix.de>

For CONFIG_NO_HZ we need to calculate the next timer wheel event based on a
given jiffie value.  Extend the existing code to allow the extra 'now'
argument.  Provide a compability function for the existing implementations to
call the function with now == jiffies.  (This also solves the racyness of the
original code vs.  jiffies changing during the iteration.)

No functional changes to existing users of this infrastructure.

[ remove WARN_ON() that triggered on s390, by Carsten Otte <cotte@de.ibm.com> ]
[ made new helper static, Adrian Bunk <bunk@stusta.de> ]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |   10 ++++++++++
 kernel/hrtimer.c      |    2 +-
 kernel/timer.c        |   14 +++++++++++---
 3 files changed, 22 insertions(+), 4 deletions(-)

diff -puN include/linux/timer.h~extend-next_timer_interrupt-to-use-a-reference-jiffie include/linux/timer.h
--- a/include/linux/timer.h~extend-next_timer_interrupt-to-use-a-reference-jiffie
+++ a/include/linux/timer.h
@@ -61,7 +61,17 @@ extern int del_timer(struct timer_list *
 extern int __mod_timer(struct timer_list *timer, unsigned long expires);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
 
+/*
+ * Return when the next timer-wheel timeout occurs (in absolute jiffies),
+ * locks the timer base:
+ */
 extern unsigned long next_timer_interrupt(void);
+/*
+ * Return when the next timer-wheel timeout occurs (in absolute jiffies),
+ * locks the timer base and does the comparison against the given
+ * jiffie.
+ */
+extern unsigned long get_next_timer_interrupt(unsigned long now);
 
 /**
  * add_timer - start a timer
diff -puN kernel/hrtimer.c~extend-next_timer_interrupt-to-use-a-reference-jiffie kernel/hrtimer.c
--- a/kernel/hrtimer.c~extend-next_timer_interrupt-to-use-a-reference-jiffie
+++ a/kernel/hrtimer.c
@@ -533,7 +533,7 @@ ktime_t hrtimer_get_remaining(const stru
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_remaining);
 
-#ifdef CONFIG_NO_IDLE_HZ
+#if defined(CONFIG_NO_IDLE_HZ) || defined(CONFIG_NO_HZ)
 /**
  * hrtimer_get_next_event - get the time until next expiry event
  *
diff -puN kernel/timer.c~extend-next_timer_interrupt-to-use-a-reference-jiffie kernel/timer.c
--- a/kernel/timer.c~extend-next_timer_interrupt-to-use-a-reference-jiffie
+++ a/kernel/timer.c
@@ -591,7 +591,7 @@ static inline void __run_timers(tvec_bas
 	spin_unlock_irq(&base->lock);
 }
 
-#ifdef CONFIG_NO_IDLE_HZ
+#if defined(CONFIG_NO_IDLE_HZ) || defined(CONFIG_NO_HZ)
 /*
  * Find out when the next timer event is due to happen. This
  * is used on S/390 to stop all activity when a cpus is idle.
@@ -687,10 +687,10 @@ static unsigned long cmp_next_hrtimer_ev
 /**
  * next_timer_interrupt - return the jiffy of the next pending timer
  */
-unsigned long next_timer_interrupt(void)
+unsigned long get_next_timer_interrupt(unsigned long now)
 {
 	tvec_base_t *base = __get_cpu_var(tvec_bases);
-	unsigned long expires, now = jiffies;
+	unsigned long expires;
 
 	spin_lock(&base->lock);
 	expires = __next_timer_interrupt(base);
@@ -701,6 +701,14 @@ unsigned long next_timer_interrupt(void)
 
 	return cmp_next_hrtimer_event(now, expires);
 }
+
+#ifdef CONFIG_NO_IDLE_HZ
+unsigned long next_timer_interrupt(void)
+{
+	return get_next_timer_interrupt(jiffies);
+}
+#endif
+
 #endif
 
 /******************************************************************/
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
