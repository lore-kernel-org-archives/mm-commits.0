From: akpm@linux-foundation.org
Subject: [merged] clocksource-sanity-check-sysfs-clocksource-changes.patch removed from -mm tree
Date: Mon, 15 Jun 2009 12:01:34 -0700
Message-ID: <200906151901.n5FJ1Y9R023003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758712AbZFOTBv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 15:01:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: sanity check sysfs clocksource changes
has been removed from the -mm tree.  Its filename was
     clocksource-sanity-check-sysfs-clocksource-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: sanity check sysfs clocksource changes
From: john stultz <johnstul@us.ibm.com>

Thomas, Andrew and Ingo pointed out that we don't have any safety checks
in the clocksource sysfs entries to make sure sysadmins don't try to
change the clocksource to a non high-res timer capable clocksource (such
as jiffies) when high-res timers (HRT) is enabled.  Doing so will likely
hang a system.

This patch tries to correct this by filtering non HRT clocksources from
available_clocksources and not accepting non HRT clocksources with HRT is
is enabled.

This has been lightly tested, and seems to work, but there may be some
drawbacks.

One issue I realized was that when TSCs disqualified, they are marked as
not CLOCK_SOURCE_VALID_FOR_HRES.  This means on boxes with unsycned TSCs,
the only available clocksource may be the slower acpi_pm and the user will
not be able to override it with the TSC as is currently possible.  (even
if that seems ill-advised).

So Thomas, what do you think? Should we just use
CLOCK_SOURCE_IS_CONTINUOUS flag or is CLOCK_SOURCE_VALID_FOR_HRES really
what we want?

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>

(akpm: still an rfc)
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h   |    2 +-
 kernel/hrtimer.c          |    4 ++--
 kernel/time/clocksource.c |   17 ++++++++++++++++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff -puN include/linux/hrtimer.h~clocksource-sanity-check-sysfs-clocksource-changes include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~clocksource-sanity-check-sysfs-clocksource-changes
+++ a/include/linux/hrtimer.h
@@ -308,7 +308,7 @@ static inline int hrtimer_is_hres_active
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
-
+extern int hrtimer_hres_active(void);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
diff -puN kernel/hrtimer.c~clocksource-sanity-check-sysfs-clocksource-changes kernel/hrtimer.c
--- a/kernel/hrtimer.c~clocksource-sanity-check-sysfs-clocksource-changes
+++ a/kernel/hrtimer.c
@@ -526,7 +526,7 @@ static inline int hrtimer_is_hres_enable
 /*
  * Is the high resolution mode active ?
  */
-static inline int hrtimer_hres_active(void)
+int hrtimer_hres_active(void)
 {
 	return __get_cpu_var(hrtimer_bases).hres_active;
 }
@@ -754,7 +754,7 @@ static int hrtimer_switch_to_hres(void)
 
 #else
 
-static inline int hrtimer_hres_active(void) { return 0; }
+int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
diff -puN kernel/time/clocksource.c~clocksource-sanity-check-sysfs-clocksource-changes kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-sanity-check-sysfs-clocksource-changes
+++ a/kernel/time/clocksource.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 #include <linux/tick.h>
+#include <linux/hrtimer.h>
 
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
@@ -510,6 +511,17 @@ static ssize_t sysfs_override_clocksourc
 		}
 	}
 
+	/* Check to make sure we don't switch to a non-HRT usable
+	 * clocksource if HRT is enabled and running
+	 */
+	if (hrtimer_hres_active() &&
+	    !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES)) {
+		printk(KERN_WARNING "%s clocksource is not HRT compatible. "
+			"Cannot switch while in HRT mode\n", ovr->name);
+		ovr = NULL;
+		override_name[0] = 0;
+	}
+
 	/* Reselect, when the override name has changed */
 	if (ovr != clocksource_override) {
 		clocksource_override = ovr;
@@ -538,7 +550,10 @@ sysfs_show_available_clocksources(struct
 
 	spin_lock_irq(&clocksource_lock);
 	list_for_each_entry(src, &clocksource_list, list) {
-		count += snprintf(buf + count,
+		/* Don't show non-HRES clocksource if HRES is enabled */
+		if (!hrtimer_hres_active() ||
+				(src->flags & CLOCK_SOURCE_VALID_FOR_HRES))
+			count += snprintf(buf + count,
 				  max((ssize_t)PAGE_SIZE - count, (ssize_t)0),
 				  "%s ", src->name);
 	}
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
linux-next.patch
time-move-pit_tick_rate-to-linux-timexh.patch

