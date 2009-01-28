From: akpm@linux-foundation.org
Subject: + clocksource-sanity-check-sysfs-clocksource-changes.patch added to -mm tree
Date: Tue, 27 Jan 2009 16:03:35 -0800
Message-ID: <200901280003.n0S03ZgM010915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753730AbZA1AEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 19:04:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     clocksource: sanity check sysfs clocksource changes
has been added to the -mm tree.  Its filename is
     clocksource-sanity-check-sysfs-clocksource-changes.patch

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
@@ -305,7 +305,7 @@ static inline int hrtimer_is_hres_active
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
-
+extern int hrtimer_hres_active(void);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
diff -puN kernel/hrtimer.c~clocksource-sanity-check-sysfs-clocksource-changes kernel/hrtimer.c
--- a/kernel/hrtimer.c~clocksource-sanity-check-sysfs-clocksource-changes
+++ a/kernel/hrtimer.c
@@ -476,7 +476,7 @@ static inline int hrtimer_is_hres_enable
 /*
  * Is the high resolution mode active ?
  */
-static inline int hrtimer_hres_active(void)
+int hrtimer_hres_active(void)
 {
 	return __get_cpu_var(hrtimer_bases).hres_active;
 }
@@ -691,7 +691,7 @@ static int hrtimer_switch_to_hres(void)
 
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
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
@@ -436,6 +437,17 @@ static ssize_t sysfs_override_clocksourc
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
@@ -464,7 +476,10 @@ sysfs_show_available_clocksources(struct
 
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

clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch

