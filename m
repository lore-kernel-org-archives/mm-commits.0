From: akpm@linux-foundation.org
Subject: + hangcheck-timer-fix-x86_32-bugs.patch added to -mm tree
Date: Fri, 26 Mar 2010 14:24:30 -0700
Message-ID: <201003262124.o2QLOUum021412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947Ab0CZVYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 17:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ypolyans@princeton.edu, jan.glauber@de.ibm.com, joel.becker@oracle.com, johnstul@us.ibm.com


The patch titled
     hangcheck-timer: fix x86_32 bugs
has been added to the -mm tree.  Its filename is
     hangcheck-timer-fix-x86_32-bugs.patch

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
Subject: hangcheck-timer: fix x86_32 bugs
From: Yury Polyanskiy <ypolyans@princeton.edu>

drivers/char/hangcheck-timer.c is doubly broken.  First, the following
line overflows unsigned long:

# define TIMER_FREQ (HZ*loops_per_jiffy)

Second, and more importantly, loops_per_jiffy has little to do with the
con= version from the the time scale of get_cycles() (aka rdtsc) to the
time scale of jiffies.

The attached patch resolves both of the problems.

Cc: Joel Becker <joel.becker@oracle.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Jan Glauber <jan.glauber@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hangcheck-timer.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff -puN drivers/char/hangcheck-timer.c~hangcheck-timer-fix-x86_32-bugs drivers/char/hangcheck-timer.c
--- a/drivers/char/hangcheck-timer.c~hangcheck-timer-fix-x86_32-bugs
+++ a/drivers/char/hangcheck-timer.c
@@ -49,8 +49,9 @@
 #include <asm/uaccess.h>
 #include <linux/sysrq.h>
 #include <linux/timer.h>
+#include <linux/time.h>
 
-#define VERSION_STR "0.9.0"
+#define VERSION_STR "0.9.1"
 
 #define DEFAULT_IOFENCE_MARGIN 60	/* Default fudge factor, in seconds */
 #define DEFAULT_IOFENCE_TICK 180	/* Default timer timeout, in seconds */
@@ -119,10 +120,8 @@ __setup("hcheck_dump_tasks", hangcheck_p
 #if defined(CONFIG_S390)
 # define HAVE_MONOTONIC
 # define TIMER_FREQ 1000000000ULL
-#elif defined(CONFIG_IA64)
-# define TIMER_FREQ ((unsigned long long)local_cpu_data->itc_freq)
 #else
-# define TIMER_FREQ (HZ*loops_per_jiffy)
+# define TIMER_FREQ 1000000000ULL
 #endif
 
 #ifdef HAVE_MONOTONIC
@@ -130,7 +129,9 @@ extern unsigned long long monotonic_cloc
 #else
 static inline unsigned long long monotonic_clock(void)
 {
-	return get_cycles();
+	struct timespec ts;
+	getrawmonotonic(&ts);
+	return timespec_to_ns(&ts);
 }
 #endif  /* HAVE_MONOTONIC */
 
@@ -168,6 +169,13 @@ static void hangcheck_fire(unsigned long
 			printk(KERN_CRIT "Hangcheck: hangcheck value past margin!\n");
 		}
 	}
+#if 0
+	/*
+	 * Enable to investigate delays in detail
+	 */
+	printk("Hangcheck: called %Ld ns since last time (%Ld ns overshoot)\n",
+			tsc_diff, tsc_diff - hangcheck_tick*TIMER_FREQ);
+#endif
 	mod_timer(&hangcheck_ticktock, jiffies + (hangcheck_tick*HZ));
 	hangcheck_tsc = monotonic_clock();
 }
@@ -180,7 +188,7 @@ static int __init hangcheck_init(void)
 #if defined (HAVE_MONOTONIC)
 	printk("Hangcheck: Using monotonic_clock().\n");
 #else
-	printk("Hangcheck: Using get_cycles().\n");
+	printk("Hangcheck: Using getrawmonotonic().\n");
 #endif  /* HAVE_MONOTONIC */
 	hangcheck_tsc_margin =
 		(unsigned long long)(hangcheck_margin + hangcheck_tick);
_

Patches currently in -mm which might be from ypolyans@princeton.edu are

hangcheck-timer-fix-x86_32-bugs.patch

